//------------------------------------------------------------------------------
//
//  Portal Adventure - 2nd PGD Challenge: The Journey
//  Copyright (C) 2012-2022 by Jim Valavanis
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
//  02111-1307, USA.
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr - jvalavanis@gmail.com
//------------------------------------------------------------------------------

{$I portal.inc}

unit p_user;

interface

//-----------------------------------------------------------------------------

uses
  p_mobj_h,
  d_player;

//==============================================================================
//
// P_PlayerThink
//
//==============================================================================
procedure P_PlayerThink(player: Pplayer_t);

//==============================================================================
//
// P_CalcHeight
//
//==============================================================================
procedure P_CalcHeight(player: Pplayer_t);

//==============================================================================
// P_PlayerFaceMobj
//
// JVAL: XMEN
//
//==============================================================================
procedure P_PlayerFaceMobj(const player: Pplayer_t; const face: Pmobj_t; const ticks: integer);

implementation

uses
  d_delphi,
  m_fixed,
  tables,
  d_ticcmd,
  d_event,
  info_h,
  info,
{$IFDEF DEBUG}
  i_io,
{$ENDIF}
  g_game,
  p_maputl,
  p_mobj,
  p_tick,
  p_pspr,
  p_local,
  p_spec,
  p_map,
  p_extra,
  p_journey,
  r_main,
  r_defs,
  gamedef;

//
// Movement.
//
const
// 16 pixels of bob
  MAXBOB = $100000;

var
  onground: boolean;

//==============================================================================
//
// P_Thrust
// Moves the given origin along a given angle.
//
//==============================================================================
procedure P_Thrust(player: Pplayer_t; angle: angle_t; const move: fixed_t);
begin
  angle := angle shr ANGLETOFINESHIFT;

  player.mo.momx := player.mo.momx + FixedMul(move, finecosine[angle]);
  player.mo.momy := player.mo.momy + FixedMul(move, finesine[angle]);
end;

//==============================================================================
//
// P_CalcHeight
// Calculate the walking / running height adjustment
//
//==============================================================================
procedure P_CalcHeight(player: Pplayer_t);
var
  angle: integer;
  bob: fixed_t;
begin
  // Regular movement bobbing
  // (needs to be calculated for gun swing
  // even if not on ground)
  // OPTIMIZE: tablify angle
  // Note: a LUT allows for effects
  //  like a ramp with low health.

  player.bob := FixedMul(player.mo.momx, player.mo.momx) +
                FixedMul(player.mo.momy, player.mo.momy);
  player.bob := player.bob div 4;

  if player.bob > MAXBOB then
    player.bob := MAXBOB;

  player.bob := 0;

  if (player.cheats and CF_NOMOMENTUM <> 0) or (not onground) then
  begin
    player.viewz := player.mo.z + PVIEWHEIGHT;

    if player.viewz > player.mo.ceilingz - 4 * FRACUNIT then
      player.viewz := player.mo.ceilingz - 4 * FRACUNIT;

    exit;
  end;

  angle := (FINEANGLES div 20 * leveltime) and FINEMASK;
  bob := FixedMul(player.bob div 2, finesine[angle]);

  // move viewheight
  if player.playerstate = PST_LIVE then
  begin
    player.viewheight := player.viewheight + player.deltaviewheight;

    if player.viewheight > PVIEWHEIGHT then
    begin
      player.viewheight := PVIEWHEIGHT;
      player.deltaviewheight := 0;
    end;

    if player.viewheight < PVIEWHEIGHT div 2 then
    begin
      player.viewheight := PVIEWHEIGHT div 2;
      if player.deltaviewheight <= 0 then
        player.deltaviewheight := 1;
    end;

    if player.deltaviewheight <> 0 then
    begin
      player.deltaviewheight := player.deltaviewheight + FRACUNIT div 4;
      if player.deltaviewheight = 0 then
        player.deltaviewheight := 1;
    end;
  end;
  player.viewz := player.mo.z + player.viewheight + bob;

  if player.viewz > player.mo.ceilingz - 4 * FRACUNIT then
    player.viewz := player.mo.ceilingz - 4 * FRACUNIT;
end;

//==============================================================================
// PlayerInIdleFrame
//
// P_MovePlayer
//
//==============================================================================
function PlayerInIdleFrame(const p: Pplayer_t): Boolean;
begin
  if p.mo.state = @states[Ord(S_PLAY)] then
  begin
    result := true;
    exit;
  end;
  if (integer(p.mo.state) >= integer(@states[Ord(S_PLAY1)])) and (integer(p.mo.state) <= integer(@states[Ord(S_PLAY39)])) then
  begin
    result := True;
    Exit;
  end;
  result := false;
end;

//==============================================================================
//
// P_MovePlayer
//
//==============================================================================
procedure P_MovePlayer(player: Pplayer_t);
var
  cmd: Pticcmd_t;
  look: integer;
  look2: integer;
  dist: integer;
  angle: angle_t;
  flyspeed: integer;
begin
  cmd := @player.cmd;

  if cmd.forwardmove = 0 then
    if player.ammo[Ord(am_cell)] < 300 then
      player.ammo[Ord(am_cell)] := player.ammo[Ord(am_cell)] + 1;

  if player.ammo[Ord(am_cell)] > 0 then
  begin
    if (cmd.forwardmove > forwardmove[0]) or (cmd.forwardmove < -forwardmove[0]) then
      if leveltime and 15 <> 0 then
        player.ammo[Ord(am_cell)] := player.ammo[Ord(am_cell)] - 1;
  end
  else
  begin
    if cmd.forwardmove > forwardmove[1] div 2 then
      cmd.forwardmove := forwardmove[1] div 2
    else if cmd.forwardmove < -forwardmove[1] div 2 then
      cmd.forwardmove := -forwardmove[1] div 2;
  end;

  player.mo.angle := player.mo.angle + _SHLW(cmd.angleturn, 16);

  // Do not let the player control movement
  //  if not onground.
  onground := (player.mo.z <= player.mo.floorz) or (player.mo.z <= player.minimumz);

  if (player.cheats and CF_LOWGRAVITY <> 0) or
    ((cmd.forwardmove <> 0) and
     (onground or ((cmd.jump > 0) and (player.mo.momx = 0) and (player.mo.momy = 0)))) then
    P_Thrust(player, player.mo.angle, round(cmd.forwardmove * 2048 * player.thrustmodifier));

  if (player.cheats and CF_LOWGRAVITY <> 0) or
    ((cmd.sidemove <> 0) and
     (onground or ((cmd.jump > 0) and (player.mo.momx = 0) and (player.mo.momy = 0)))) then
    P_Thrust(player, player.mo.angle - ANG90, Round(cmd.sidemove * 2048 * player.thrustmodifier));

  begin
    // JVAL: Adjust speed while flying
    if (player.cheats and CF_LOWGRAVITY <> 0) and (player.mo.z > player.mo.floorz) then
    begin
      if player.cheats and CF_UNDERWATER <> 0 then
        flyspeed := 3
      else
        flyspeed := 5;
      if player.mo.momx > flyspeed * FRACUNIT then
        player.mo.momx := flyspeed * FRACUNIT
      else if player.mo.momx < -flyspeed * FRACUNIT then
        player.mo.momx := -flyspeed * FRACUNIT;
      if player.mo.momy > flyspeed * FRACUNIT then
        player.mo.momy := flyspeed * FRACUNIT
      else if player.mo.momy < -flyspeed * FRACUNIT then
        player.mo.momy := -flyspeed * FRACUNIT;

      if (cmd.forwardmove = 0) and (cmd.sidemove = 0) then
      begin
        if player.cheats and CF_UNDERWATER <> 0 then
        begin
          player.mo.momx := player.mo.momx * 11 div 12;
          player.mo.momy := player.mo.momy * 11 div 12;
        end
        else
        begin
          player.mo.momx := player.mo.momx * 15 div 16;
          player.mo.momy := player.mo.momy * 15 div 16;
        end;
      end;
    end;
  end;

  if ((cmd.forwardmove <> 0) or (cmd.sidemove <> 0)) and PlayerInIdleFrame(player) then
    P_SetMobjState(player.mo, S_PLAY_RUN1);

// JVAL Look UP and DOWN
  if zaxisshift then
  begin
    look := cmd.look;
    if look > 7 then
      look := look - 16;

    if look <> 0 then
    begin
      if look = TOCENTER then
        player.centering := true
      else
      begin
        player.lookdir := player.lookdir + 5 * look;
        if player.lookdir > MAXLOOKDIR then
          player.lookdir := MAXLOOKDIR
        else if player.lookdir < MINLOOKDIR then
          player.lookdir := MINLOOKDIR;
      end;
    end;

    if gamemap = 1 then
      player.lookdir := -30    // jval journey
    else
    if player.lookdir > 10 then
      player.lookdir := 10;    // jval journey

    // --------------------------------------------------
    player.lookdir := -30;    // jval journey
    // --------------------------------------------------

    if player.centering then
    begin
      if player.lookdir > 0 then
        player.lookdir := player.lookdir - 8
      else if player.lookdir < 0 then
        player.lookdir := player.lookdir + 8;

      if abs(player.lookdir) < 8 then
      begin
        player.lookdir := 0;
        player.centering := false;
      end;
    end;
  end;

  if journeymapinfo[gamemap].look2 and not G_NeedsCompatibilityMode then
  begin
    // JVAL Look LEFT and RIGHT
    look2 := cmd.look2;
    if look2 > 7 then
      look2 := look2 - 16;

    if look2 <> 0 then
    begin
      if look2 = TOFORWARD then
        player.forwarding := true
      else
      begin
        player.lookdir2 := (player.lookdir2 + 2 * look2) and 255;
        if player.lookdir2 in [64..127] then
          player.lookdir2 := 63
        else if player.lookdir2 in [128..191] then
          player.lookdir2 := 192;
      end;
    end
    else
      if player.oldlook2 <> 0 then
        player.forwarding := true;

    if player.forwarding then
    begin
      if player.lookdir2 in [3..63] then
        player.lookdir2 := player.lookdir2 - 6
      else if player.lookdir2 in [192..251] then
        player.lookdir2 := player.lookdir2 + 6;

      if (player.lookdir2 < 8) or (player.lookdir2 > 247) then
      begin
        player.lookdir2 := 0;
        player.forwarding := false;
      end;
    end;
    player.mo.viewangle := player.lookdir2 shl 24;

    player.oldlook2 := look2;

    if (onground or (player.cheats and CF_LOWGRAVITY <> 0)) and (cmd.jump > 1) then
    begin
      if player.cheats or CF_UNDERWATER <> 0 then
        player.mo.momz := 8 * FRACUNIT
      else
        player.mo.momz := 4 * FRACUNIT;
    end;
  end
  else
    player.lookdir2 := 0;

  if player.underwatertics > 0 then
  begin
    if not onground then
      if (cmd.forwardmove <> 0) or (cmd.sidemove <> 0) then
        if player.mo.momz < 2 * FRACUNIT then
          player.mo.momz := player.mo.momz + FRACUNIT div 4;
    player.mo.momz := player.mo.momz * 11 div 12;
  end;

  if Psubsector_t(player.mo.subsector).sector.tag = 666 then
  begin
    player.mo.momx := 0;
    player.mo.momy := 0;
  end;

  if player.radiousticks > 0 then
  begin
    dist := P_Distance(player.mo.x - player.radiousx, player.mo.y - player.radiousy);
    if dist > player.radiouskeep then
    begin
      player.mo.momx := 0;
      player.mo.momy := 0;
      angle := R_PointToAngle2(player.mo.x, player.mo.y, player.radiousx, player.radiousy);
      angle := angle shr ANGLETOFINESHIFT;
      player.mo.x := player.radiousx - FixedMul(player.radiouskeep, finecosine[angle]);
      player.mo.y := player.radiousy - FixedMul(player.radiouskeep, finesine[angle]);
    end;
  end;
end;

//==============================================================================
//
// P_DeathThink
// Fall on your face when dying.
// Decrease POV height to floor height.
//
//==============================================================================
procedure P_DeathThink(player: Pplayer_t);
var
  angle: angle_t;
  delta: angle_t;
begin
  P_MovePsprites(player);

  // fall to the ground
  if player.viewheight > 6 * FRACUNIT then
    player.viewheight := player.viewheight - FRACUNIT;

  if player.viewheight < 6 * FRACUNIT then
    player.viewheight := 6 * FRACUNIT;

  if player.viewheight > 6 * FRACUNIT then
    if player.lookdir > -65 then
      player.lookdir := player.lookdir - 5;

  player.deltaviewheight := 0;
  onground := player.mo.z <= player.mo.floorz;
  P_CalcHeight(player);

  if (player.attacker <> nil) and (player.attacker <> player.mo) then
  begin

    angle := R_PointToAngle2(
      player.mo.x, player.mo.y, player.attackerx, player.attackery);

    delta := angle - player.mo.angle;

    if (delta < ANG5) or (delta > ANG355) then
    begin
      // Looking at killer,
      //  so fade damage flash down.
      player.mo.angle := angle;

      if player.damagecount <> 0 then
        player.damagecount := player.damagecount - 1;
    end
    else if delta < ANG180 then
      player.mo.angle := player.mo.angle + ANG5
    else
      player.mo.angle := player.mo.angle - ANG5;

  end
  else if player.damagecount <> 0 then
    player.damagecount := player.damagecount - 1;

{  if player.cmd.buttons and BT_USE <> 0 then
    player.playerstate := PST_REBORN; }
end;

//==============================================================================
// P_AngleTarget
//
// JVAL: XMEN
//
//==============================================================================
procedure P_AngleTarget(player: Pplayer_t);
var
  ticks: LongWord;
  angle: angle_t;
  diff: angle_t;
begin
  if player.angletargetticks <= 0 then
    exit;

  player.cmd.angleturn := 0;
  angle := R_PointToAngle2(player.mo.x, player.mo.y, player.angletargetx, player.angletargety);
  diff := player.mo.angle - angle;

  ticks := player.angletargetticks;
  if diff > ANG180 then
  begin
    diff := ANGLE_MAX - diff;
    player.mo.angle := player.mo.angle + (diff div ticks);
  end
  else
    player.mo.angle := player.mo.angle - (diff div ticks);

  Dec(player.angletargetticks);
end;

//==============================================================================
//
// P_PlayerThink
//
//==============================================================================
procedure P_PlayerThink(player: Pplayer_t);
var
  cmd: Pticcmd_t;
  newweapon: weapontype_t;
begin
  if player.quaketics > 0 then
    dec(player.quaketics);

  if player.radiousticks > 0 then
    dec(player.radiousticks);

  if player.lowgravtics > 0 then
    dec(player.lowgravtics);

  if player.underwatertics > 0 then
    dec(player.underwatertics);

  if player.do_updateparams then
  begin
    J_RestorePlayerParams(player);
    player.do_updateparams := false;
  end;

  // fixme: do this in the cheat code
  if player.cheats and CF_NOCLIP <> 0 then
    player.mo.flags := player.mo.flags or MF_NOCLIP
  else
    player.mo.flags := player.mo.flags and (not MF_NOCLIP);

  // chain saw run forward
  cmd := @player.cmd;
  if player.mo.flags and MF_JUSTATTACKED <> 0 then
  begin
    cmd.angleturn := 0;
    cmd.forwardmove := $c800 div 512;
    cmd.sidemove := 0;
    player.mo.flags := player.mo.flags and (not MF_JUSTATTACKED);
  end;

  if player.playerstate = PST_DEAD then
  begin
    P_DeathThink(player);
    exit;
  end;

  P_AngleTarget(player); // jval: XMEN

  // Move around.
  // Reactiontime is used to prevent movement
  //  for a bit after a teleport.
  if player.mo.reactiontime <> 0 then
    player.mo.reactiontime := player.mo.reactiontime - 1
  else
    P_MovePlayer(player);

  P_CalcHeight(player);

  if Psubsector_t(player.mo.subsector).sector.special <> 0 then
    P_PlayerInSpecialSector(player);

  // Check for weapon change.

  // A special event has no other buttons.
  if cmd.buttons and BT_SPECIAL <> 0 then
    cmd.buttons := 0;

  if cmd.buttons and BT_CHANGE <> 0 then
  begin
    // The actual changing of the weapon is done
    //  when the weapon psprite can do it
    //  (read: not in the middle of an attack).
    newweapon := weapontype_t(_SHR(cmd.buttons and BT_WEAPONMASK, BT_WEAPONSHIFT));

    if (newweapon = wp_fist) and
       (player.weaponowned[Ord(wp_chainsaw)] <> 0) and (not (
       (player.readyweapon = wp_chainsaw) and (player.powers[Ord(pw_strength)] <> 0))) then
    begin
      newweapon := wp_chainsaw;
      // JVAL: If readyweapon is already the chainsaw return to fist
      // Only if we don't have old compatibility mode suspended
      if not G_NeedsCompatibilityMode then
        if player.readyweapon = wp_chainsaw then
          newweapon := wp_fist;
    end;

    if (gamemode = commercial) and
       (newweapon = wp_shotgun) and
       (player.weaponowned[Ord(wp_supershotgun)] <> 0) and
       (player.readyweapon <> wp_supershotgun) then
      newweapon := wp_supershotgun;

    if (player.weaponowned[Ord(newweapon)] <> 0) and
       (newweapon <> player.readyweapon) then
      // Do not go to plasma or BFG in shareware,
      //  even if cheated.
      if ((newweapon <> wp_plasma) and (newweapon <> wp_bfg)) or
         (gamemode <> shareware) then
        player.pendingweapon := newweapon;

  end;

  // check for use
  if cmd.buttons and BT_USE <> 0 then
  begin
    if not player.usedown then
    begin
      P_UseLines(player);
      player.usedown := true;
    end;
  end
  else
    player.usedown := false;

  // cycle psprites
  P_MovePsprites(player);

  // Counters, time dependend power ups.

  // Strength counts up to diminish fade.
  if player.powers[Ord(pw_strength)] <> 0 then
    player.powers[Ord(pw_strength)] := player.powers[Ord(pw_strength)] + 1;

  if player.powers[Ord(pw_invulnerability)] <> 0 then
    player.powers[Ord(pw_invulnerability)] := player.powers[Ord(pw_invulnerability)] - 1;

  if player.powers[Ord(pw_invisibility)] <> 0 then
  begin
    player.powers[Ord(pw_invisibility)] := player.powers[Ord(pw_invisibility)] - 1;
    if player.powers[Ord(pw_invisibility)] = 0 then
      player.mo.flags := player.mo.flags and (not MF_SHADOW);
  end;

  if player.powers[Ord(pw_infrared)] <> 0 then
    player.powers[Ord(pw_infrared)] := player.powers[Ord(pw_infrared)] - 1;

  if player.powers[Ord(pw_ironfeet)] <> 0 then
    player.powers[Ord(pw_ironfeet)] := player.powers[Ord(pw_ironfeet)] - 1;

  if player.damagecount <> 0 then
    player.damagecount := player.damagecount - 1;

  if player.hardbreathtics > 0 then
    player.hardbreathtics := player.hardbreathtics - 1;

  if player.bonuscount <> 0 then
    player.bonuscount := player.bonuscount - 1;

  if player.autohealcount <> 0 then
    player.autohealcount := player.autohealcount - 1;

  // Handling colormaps.
  if player.powers[Ord(pw_invulnerability)] <> 0 then
  begin
    if (player.powers[Ord(pw_invulnerability)] > 4 * 32) or
       (player.powers[Ord(pw_invulnerability)] and 8 <> 0) then
      player.fixedcolormap := INVERSECOLORMAP
    else
      player.fixedcolormap := 0;
  end
  else if player.powers[Ord(pw_infrared)] <> 0 then
  begin
    if (player.powers[Ord(pw_infrared)] > 4 * 32) or
       (player.powers[Ord(pw_infrared)] and 8 <> 0) then
      // almost full bright
      player.fixedcolormap := 1
    else
      player.fixedcolormap := 0;
  end
  else
    player.fixedcolormap := 0;

  A_PlayerBreath(player);
//  A_PlayerWalk(player);
end;

//==============================================================================
// P_PlayerFaceMobj
//
// JVAL
//
//==============================================================================
procedure P_PlayerFaceMobj(const player: Pplayer_t; const face: Pmobj_t; const ticks: integer);
begin
  player.angletargetx := face.x;
  player.angletargety := face.y;
  player.angletargetticks := ticks;
end;

end.
