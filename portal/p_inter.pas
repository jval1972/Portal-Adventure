//------------------------------------------------------------------------------
//
//  Portal Adventure - 2nd PGD Challenge: The Journey
//  Copyright (C) 2012-2021 by Jim Valavanis
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

unit p_inter;

interface

uses
  gamedef,
  dstrings,
  d_englsh,
  sounds,
  m_rnd,
  i_system,
  p_local,
  p_mobj_h,
  s_sound,
  d_player;

//-----------------------------------------------------------------------------

function P_GivePower(player: Pplayer_t; power: integer): boolean;

procedure P_TouchSpecialThing(special: Pmobj_t; toucher: Pmobj_t);

procedure P_DamageMobj(target, inflictor, source: Pmobj_t; damage: integer);

const
// a weapon is found with two clip loads,
// a big item has five clip loads
  maxammo: array[0..Ord(NUMAMMO) - 1] of integer = (2000000000, 50, 300, 50);
  clipammo: array[0..Ord(NUMAMMO) - 1] of integer = (10, 4, 20, 1);

procedure P_CmdSuicide;

var
  p_maxhealth: integer = 200;
  p_soulspherehealth: integer = 100;
  p_megaspherehealth: integer = 200;
  p_medikithealth: integer = 25;
  p_stimpackhealth: integer = 10;
  p_bonushealth: integer = 1;
  p_maxarmor: integer = 200;
  p_greenarmorclass: integer = 1;
  p_bluearmorclass: integer = 2;

implementation

uses
  c_cmds,
  d_delphi,
  info_h,
  info,
  m_fixed,
  d_items,
  g_game,
  cm_main,
  p_mobj, p_pspr,
  r_defs, r_main,
  tables;

const
  BONUSADD = 6;

//
// GET STUFF
//

//
// P_GiveAmmo
// Num is the number of clip loads,
// not the individual count (0= 1/2 clip).
// Returns false if the ammo can't be picked up at all
//
function P_GiveAmmo(player: Pplayer_t; ammo: ammotype_t; num: integer): boolean;
var
  oldammo: integer;
begin
  if ammo = am_noammo then
  begin
    result := false;
    exit;
  end;

  if (Ord(ammo) < 0) or (Ord(ammo) > Ord(NUMAMMO)) then
    I_Error('P_GiveAmmo(): bad type %d', [Ord(ammo)]);

  if player.ammo[Ord(ammo)] = player.maxammo[Ord(ammo)] then
  begin
    result := false;
    exit;
  end;

  if num <> 0 then
    num := num * clipammo[Ord(ammo)]
  else
    num := clipammo[Ord(ammo)] div 2;

  if (gameskill = sk_baby) or (gameskill = sk_nightmare) then
  begin
    // give double ammo in trainer mode,
    // you'll need in nightmare
    num := num * 2
  end;


  oldammo := player.ammo[Ord(ammo)];
  player.ammo[Ord(ammo)] := player.ammo[Ord(ammo)] + num;
  if player.ammo[Ord(ammo)] < 0 then
    player.ammo[Ord(ammo)] := player.maxammo[Ord(ammo)];

  if player.ammo[Ord(ammo)] > player.maxammo[Ord(ammo)] then
    player.ammo[Ord(ammo)] := player.maxammo[Ord(ammo)];

  // If non zero ammo,
  // don't change up weapons,
  // player was lower on purpose.
  if oldammo <> 0 then
  begin
    result := true;
    exit;
  end;

  // We were down to zero,
  // so select a new weapon.
  // Preferences are not user selectable.
  case ammo of
    am_clip:
      begin
        if player.readyweapon = wp_fist then
        begin
          if player.weaponowned[Ord(wp_chaingun)] <> 0 then
            player.pendingweapon := wp_chaingun
          else
            player.pendingweapon := wp_pistol;
        end;
      end;
    am_shell:
      begin
        if (player.readyweapon = wp_fist) or
           (player.readyweapon = wp_pistol) then
        begin
          if player.weaponowned[Ord(wp_shotgun)] <> 0 then
            player.pendingweapon := wp_shotgun;
        end;
      end;
    am_cell:
      begin
        if (player.readyweapon = wp_fist) or
           (player.readyweapon = wp_pistol) then
        begin
          if player.weaponowned[Ord(wp_plasma)] <> 0 then
            player.pendingweapon := wp_plasma;
        end;
      end;
    am_misl:
      begin
        if player.readyweapon = wp_fist then
        begin
          if player.weaponowned[Ord(wp_missile)] <> 0 then
            player.pendingweapon := wp_missile;
        end
      end;
  end;

  result := true;
end;

//
// P_GiveWeapon
// The weapon name may have a MF_DROPPED flag ored in.
//
function P_GiveWeapon(player: Pplayer_t; weapon: weapontype_t; dropped: boolean): boolean;
var
  gaveammo: boolean;
  gaveweapon: boolean;
  ammo: ammotype_t;
begin
  ammo := weaponinfo[Ord(weapon)].ammo;
  if netgame and (deathmatch <> 2) and (not dropped) then
  begin
  // leave placed weapons forever on net games
    if player.weaponowned[Ord(weapon)] <> 0 then
    begin
      result := false;
      exit;
    end;

    player.bonuscount := player.bonuscount + BONUSADD;
    player.weaponowned[Ord(weapon)] := 1;

    if deathmatch <> 0 then
      P_GiveAmmo(player, ammo, 5)
    else
      P_GiveAmmo(player, ammo, 2);
    player.pendingweapon := weapon;

    if (player = @players[consoleplayer]) then
      S_StartSound(nil, 'DSGIVE');

    result := false;
    exit;
  end;

  if ammo <> am_noammo then
  begin
  // give one clip with a dropped weapon,
  // two clips with a found weapon
    if dropped then
      gaveammo := P_GiveAmmo(player, ammo, 1)
    else
      gaveammo := P_GiveAmmo(player, ammo, 2);
  end
  else
    gaveammo := false;

  if player.weaponowned[Ord(weapon)] <> 0 then
    gaveweapon := false
  else
  begin
    gaveweapon := true;
    player.weaponowned[Ord(weapon)] := 1;
    player.pendingweapon := weapon;
  end;

  result := gaveweapon or gaveammo;
end;

//
// P_GiveBody
// Returns false if the body isn't needed at all
//
function P_GiveBody(player: Pplayer_t; num: integer): boolean;
begin
  if player.health >= mobjinfo[Ord(MT_PLAYER)].spawnhealth then
  begin
    result := false;
    exit;
  end;

  player.health := player.health + num;
  if player.health > mobjinfo[Ord(MT_PLAYER)].spawnhealth then
    player.health := mobjinfo[Ord(MT_PLAYER)].spawnhealth;
  player.mo.health := player.health;

  result := true;
end;

//
// P_GiveArmor
// Returns false if the armor is worse
// than the current armor.
//
function P_GiveArmor(player: Pplayer_t; armortype: integer): boolean;
var
  hits: integer;
begin
  hits := armortype * 100;
  if player.armorpoints >= hits then
  begin
    result := false;  // don't pick up
    exit;
  end;

  player.armortype := armortype;
  player.armorpoints := hits;

  result := true;
end;

//
// P_GiveCard
//
procedure P_GiveCard(player: Pplayer_t; card: card_t);
begin
  if player.cards[Ord(card)] then
    exit;

  player.bonuscount := BONUSADD;
  player.cards[Ord(card)] := true;
end;

//
// P_GivePower
//
function P_GivePower(player: Pplayer_t; power: integer): boolean;
begin
  if power = Ord(pw_invulnerability) then
  begin
    player.powers[power] := INVULNTICS;
    result := true;
    exit;
  end;

  if power = Ord(pw_invisibility) then
  begin
    player.powers[power] := INVISTICS;
    player.mo.flags := player.mo.flags or MF_SHADOW;
    result := true;
    exit;
  end;

  if power = Ord(pw_infrared) then
  begin
    player.powers[power] := INFRATICS;
    result := true;
    exit;
  end;

  if power = Ord(pw_ironfeet) then
  begin
    player.powers[power] := IRONTICS;
    result := true;
    exit;
  end;

  if power = Ord(pw_strength) then
  begin
    P_GiveBody(player, 100);
    player.powers[power] := 1;
    result := true;
    exit;
  end;

  if player.powers[power] <> 0 then
    result := false // already got it
  else
  begin
    player.powers[power] := 1;
    result := true;
  end;
end;

//
// P_TouchSpecialThing
//
procedure P_TouchSpecialThing(special: Pmobj_t; toucher: Pmobj_t);
var
  player: Pplayer_t;
  i: integer;
  delta: fixed_t;
begin
  delta := special.z - toucher.z;

  if (delta > toucher.height) or (delta < - 8 * FRACUNIT) then
  // out of reach
    exit;

  player := toucher.player;

  // Dead thing touching.
  // Can happen with a sliding player corpse.
  if toucher.health <= 0 then
    exit;

  // Identify by sprite.
  case special.sprite of
  // armor
    Ord(SPR_ARM1):
      begin
        if not P_GiveArmor(player, p_greenarmorclass) then
          exit;
      end;

    Ord(SPR_ARM2):
      begin
        if not P_GiveArmor(player, p_bluearmorclass) then
          exit;
      end;

  // bonus items
    Ord(SPR_BON1):
      begin
        player.health := player.health + p_bonushealth; // can go over 100%
        if player.health > p_maxhealth then
          player.health := p_maxhealth;
        player.mo.health := player.health;
      end;

    Ord(SPR_BON2):
      begin
        player.armorpoints := player.armorpoints + 1; // can go over 100%
        if player.armorpoints > p_maxarmor then
          player.armorpoints := p_maxarmor;
        if player.armortype = 0 then
          player.armortype := 1;
      end;

    Ord(SPR_SOUL):
      begin
        player.health := player.health + p_soulspherehealth;
        if player.health > p_maxhealth then
          player.health := p_maxhealth;
        player.mo.health := player.health;
      end;

    Ord(SPR_MEGA):
      begin
        if gamemode <> commercial then
          exit;
        player.health := 200;
        player.mo.health := player.health;
        P_GiveArmor(player, p_bluearmorclass);
      end;

  // cards
  // leave cards for everyone
    Ord(SPR_BKEY):
      begin
        if not player.cards[Ord(it_bluecard)] then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/gotkey'));
        end;
        P_GiveCard(player, it_bluecard);
        if netgame then
          exit;
      end;

    Ord(SPR_GKEY):
      begin
        if not player.cards[Ord(it_greencard)] then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/gotkey'));
        end;
        P_GiveCard(player, it_greencard);
        if netgame then
          exit;
      end;

    Ord(SPR_WKEY):
      begin
        if not player.cards[Ord(it_whitecard)] then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/gotkey'));
        end;
        P_GiveCard(player, it_whitecard);
        if netgame then
          exit;
      end;

    Ord(SPR_YKEY):
      begin
        if not player.cards[Ord(it_yellowcard)] then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/gotkey'));
        end;
        P_GiveCard(player, it_yellowcard);
        if netgame then
          exit;
      end;

    Ord(SPR_RKEY):
      begin
        if not player.cards[Ord(it_redcard)] then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/gotkey'));
        end;
        P_GiveCard(player, it_redcard);
        if netgame then
          exit;
      end;

    Ord(SPR_BSKU):
      begin
        if not player.cards[Ord(it_blueskull)] then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/gotkey'));
        end;
        P_GiveCard(player, it_blueskull);
        if netgame then
          exit;
      end;

    Ord(SPR_YSKU):
      begin
        if not player.cards[Ord(it_yellowskull)] then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/gotkey'));
        end;
        P_GiveCard(player, it_yellowskull);
        if netgame then
          exit;
      end;

    Ord(SPR_RSKU):
      begin
        if not player.cards[Ord(it_redskull)] then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/gotkey'));
        end;
        P_GiveCard(player, it_redskull);
        if netgame then
          exit;
      end;

  // medikits, heals
    Ord(SPR_STIM):
      begin
        if not P_GiveBody(player, p_stimpackhealth) then
          exit;
      end;

    Ord(SPR_MEDI):
      begin
        if not P_GiveBody(player, p_medikithealth) then
          exit;

      end;

  // power ups
    Ord(SPR_PINV):
      begin
        if not P_GivePower(player, Ord(pw_invulnerability)) then
          exit;
      end;

    Ord(SPR_PSTR):
      begin
        if not P_GivePower(player, Ord(pw_strength)) then
          exit;
        if player.readyweapon <> wp_fist then
          player.pendingweapon := wp_fist;
      end;

    Ord(SPR_PINS):
      begin
        if not P_GivePower(player, Ord(pw_invisibility)) then
          exit;
      end;

    Ord(SPR_SUIT):
      begin
        if not P_GivePower(player, Ord(pw_ironfeet)) then
          exit;
      end;

    Ord(SPR_PMAP):
      begin
        if not P_GivePower(player, Ord(pw_allmap)) then
          exit;
      end;

    Ord(SPR_PVIS):
      begin
        if not P_GivePower(player, Ord(pw_infrared)) then
          exit;
      end;

  // ammo
    Ord(SPR_CLIP):
      begin
        if special.flags and MF_DROPPED <> 0 then
        begin
          if not P_GiveAmmo(player, am_clip, 0) then
            exit;
        end
        else
        begin
          if not P_GiveAmmo(player, am_clip, 1) then
            exit;
        end;
//        player._message := GOTCLIP;
      end;

    Ord(SPR_AMMO):
      begin
        if not P_GiveAmmo(player, am_clip, 5) then
          exit;
      end;

    Ord(SPR_ROCK):
      begin
        if not P_GiveAmmo(player, am_misl, 1) then
          exit;
      end;

    Ord(SPR_BROK):
      begin
        if not P_GiveAmmo(player, am_misl, 5) then
          exit;
      end;

    Ord(SPR_CELL):
      begin
        if not P_GiveAmmo(player, am_cell, 1) then
          exit;
      end;

    Ord(SPR_CELP):
      begin
        if not P_GiveAmmo(player, am_cell, 1 {jval: wolf} ) then
          exit;
      end;

    Ord(SPR_SHEL):
      begin
        if not P_GiveAmmo(player, am_shell, 1) then
          exit;
      end;

    Ord(SPR_SBOX):
      begin
        if not P_GiveAmmo(player, am_shell, 5) then
          exit;
      end;

    Ord(SPR_BPAK):
      begin
        if not player.backpack then
        begin
          for i := 0 to Ord(NUMAMMO) - 1 do
            player.maxammo[i] := player.maxammo[i] * 2;
          player.backpack := true;
        end;
        for i := 0 to Ord(NUMAMMO) - 1 do
          P_GiveAmmo(player, ammotype_t(i), 1);
      end;

  // weapons
    Ord(SPR_BFUG):
      begin
        if not P_GiveWeapon(player, wp_bfg, false) then
          exit;
      end;

    Ord(SPR_MGUN):
      begin
        if not P_GiveWeapon(player, wp_chaingun, special.flags and MF_DROPPED <> 0) then
          exit;
      end;

    Ord(SPR_CSAW):
      begin
        if not P_GiveWeapon(player, wp_chainsaw, false) then
          exit;
      end;

    Ord(SPR_LAUN):
      begin
        if not P_GiveWeapon(player, wp_missile, false) then
          exit;
      end;

    Ord(SPR_PLAS):
      begin
        if not P_GiveWeapon(player, wp_plasma, false) then
          exit;
      end;

    Ord(SPR_SHOT):
      begin
        if not P_GiveWeapon(player, wp_shotgun, special.flags and MF_DROPPED <> 0) then
          exit;
      end;

    Ord(SPR_SGN2):
      begin
        if not P_GiveWeapon(player, wp_supershotgun, special.flags and MF_DROPPED <> 0) then
          exit;
      end;

  else
    I_Error('P_TouchSpecialThing(): Unknown gettable thing');
  end;

  if special.flags and MF_COUNTITEM <> 0 then
    player.itemcount := player.itemcount + 1;
  P_RemoveMobj(special);
  player.bonuscount := player.bonuscount + BONUSADD;
  if player = @players[consoleplayer] then
//    S_StartSound(nil, sound);
    S_StartSound(nil, 'DSGIVE');
end;

//
// KillMobj
//
function P_SpawnDroppedMobj(x, y, z: fixed_t; _type: integer): Pmobj_t;
begin
  result := P_SpawnMobj(x, y, z, _type);
  result.flags := result.flags or MF_DROPPED; // special versions of items
  // JVAL Dropped items fall down to floor.
  if not compatibilitymode then
  begin
    result.z := result.z + 32 * FRACUNIT;
    result.momz := 4 * FRACUNIT;
    result.momx := 64 * N_Random;
    result.momy := 64 * N_Random;
  end;
end;

const
  PLAYERDEATHTICKS = TICRATE;

procedure P_KillMobj(source: Pmobj_t; target: Pmobj_t);
var
  item: integer;
begin
  target.flags := target.flags and (not (MF_SHOOTABLE or MF_FLOAT or MF_SKULLFLY));

  if target._type <> Ord(MT_SKULL) then
    target.flags := target.flags and (not MF_NOGRAVITY);

  target.flags := target.flags or (MF_CORPSE or MF_DROPOFF);
  target.height := _SHR2(target.height);

  if (source <> nil) and (source.player <> nil) then
  begin
    // count for intermission
    if target.flags and MF_COUNTKILL <> 0 then
      Pplayer_t(source.player).killcount := Pplayer_t(source.player).killcount + 1;

    if target.player <> nil then
      Pplayer_t(source.player).frags[pDiff(target.player, @players[0], SizeOf(players[0]))] :=
        Pplayer_t(source.player).frags[pDiff(target.player, @players[0], SizeOf(players[0]))] + 1;
  end
  else if (not netgame) and (target.flags and MF_COUNTKILL <> 0) then
  begin
    // count all monster deaths,
    // even those caused by other monsters
    players[0].killcount := players[0].killcount + 1;
  end;

  if target.player <> nil then
  begin
    // count environment kills against you
    if source = nil then
      Pplayer_t(target.player).frags[pDiff(target.player, @players[0], SizeOf(players[0]))] :=
        Pplayer_t(target.player).frags[pDiff(target.player, @players[0], SizeOf(players[0]))] + 1;

    target.flags := target.flags and (not MF_SOLID);
    Pplayer_t(target.player).playerstate := PST_DEAD;

    // JVAL
    // Save the attacker coordinates
    if Pplayer_t(target.player).attacker <> nil then
    begin
      Pplayer_t(target.player).attackerx := Pplayer_t(target.player).attacker.x;
      Pplayer_t(target.player).attackery := Pplayer_t(target.player).attacker.y;
    end;

    P_DropWeapon(target.player);
  end;

  if (target.health < -target.info.spawnhealth) and (target.info.xdeathstate <> 0) then
    P_SetMobjState(target, statenum_t(target.info.xdeathstate))
  else
    P_SetMobjState(target, statenum_t(target.info.deathstate));
  target.tics := target.tics - (P_Random and 3);

  if target.tics < 1 then
    target.tics := 1;

  // Drop stuff.
  // This determines the kind of object spawned
  // during the death frame of a thing.

  // JVAL: Check if dropitem is set to drop a custom item.
  if target.info.dropitem > 0 then
    item := target.info.dropitem
  else
  begin
    case target._type of
      Ord(MT_WOLFSS),
      Ord(MT_POSSESSED):
        item := Ord(MT_CLIP);
      Ord(MT_SHOTGUY):
        item := Ord(MT_SHOTGUN);
      Ord(MT_CHAINGUY):
        item := Ord(MT_CHAINGUN);
      else
        exit;
    end;
  end;

  P_SpawnDroppedMobj(target.x, target.y, ONFLOORZ, item);
end;

//
// P_DamageMobj
// Damages both enemies and players
// "inflictor" is the thing that caused the damage
//  creature or missile, can be NULL (slime, etc)
// "source" is the thing to target after taking damage
//  creature or NULL
// Source and inflictor are the same for melee attacks.
// Source can be NULL for slime, barrel explosions
// and other environmental stuff.
//
procedure P_DamageMobj(target, inflictor, source: Pmobj_t; damage: integer);
var
  ang: angle_t;
  saved: integer;
  player: Pplayer_t;
  thrust: fixed_t;
  mass: integer;
begin
  if target.flags and MF_SHOOTABLE = 0 then
  begin
  // 19/9/2009 jval: Display a warning message for debugging 
    I_DevWarning('P_DamageMobj(): Trying to damage unshootable mobj "%s"'#13#10, [target.info.name]);
    exit; // shouldn't happen...
  end;

  // JVAL: Invulnerable monsters
  if target.flags_ex and MF_EX_INVULNERABLE <> 0 then
    exit;

  if target.health <= 0 then
    exit;

  if target.flags and MF_SKULLFLY <> 0 then
  begin
    target.momx := 0;
    target.momy := 0;
    target.momz := 0;
  end;

  player := target.player;
  if player <> nil then // jval: changed
  begin
    if (gameskill = sk_baby) and (damage > 1) then
      damage := _SHR1(damage) // take half damage in trainer mode
    else if (gameskill = sk_easy) and (damage > 40) then
      damage := (damage * 3) div 4;
  end;


  if (inflictor <> nil) and (target.flags_ex and MF_EX_FIRERESIST <> 0) then
  begin
    if damage > 1 then
      damage := _SHR1(damage);
  end;

  // Some close combat weapons should not
  // inflict thrust and push the victim out of reach,
  // thus kick away unless using the chainsaw.
  if (inflictor <> nil) and (target.flags and MF_NOCLIP = 0) and
    ((source = nil) or (source.player = nil) or (Pplayer_t(source.player).readyweapon <> wp_chainsaw)) then
  begin
    ang := R_PointToAngle2(inflictor.x, inflictor.y, target.x, target.y);

    mass := target.info.mass;
    if mass = 0 then
    begin
      I_DevError('P_DamageMobj(): Target (%s) mass is zero', [target.info.name]);
      thrust := 0;
    end
    else
      thrust := (damage * $2000 * 100) div mass;

    // make fall forwards sometimes
    if (damage < 40) and (damage > target.health) and
       (target.z - inflictor.z > 64 * FRACUNIT) and ((P_Random and 1) <> 0) then
    begin
      ang := ang + ANG180;
      thrust := thrust * 4;
    end;

    ang := ang shr ANGLETOFINESHIFT;
    target.momx := target.momx + FixedMul(thrust, finecosine[ang]);
    target.momy := target.momy + FixedMul(thrust, finesine[ang]);
  end;

  // player specific
  if player <> nil then
  begin
    // end of game hell hack
    if (Psubsector_t(target.subsector).sector.special = 11) and (damage >= target.health) then
      damage := target.health - 1;

    // Below certain threshold,
    // ignore damage in GOD mode, or with INVUL power.
    if (damage < 1000) and
       ((player.cheats and CF_GODMODE <> 0) or (player.powers[Ord(pw_invulnerability)] <> 0)) then
      exit;

    if player.armortype <> 0 then
    begin
      if player.armortype = 1 then
        saved := damage div 3
      else
        saved := damage div 2;

      if player.armorpoints <= saved then
      begin
        // armor is used up
        saved := player.armorpoints;
        player.armortype := 0;
      end;
      player.armorpoints := player.armorpoints - saved;
      damage := damage - saved;
    end;
    player.health := player.health - damage;  // mirror mobj health here for Dave
    if player.health < 0 then
      player.health := 0;

    player.attacker := source;
    player.damagecount := player.damagecount + damage;  // add damage after armor / invuln

    if player.damagecount > 100 then
      player.damagecount := 100;  // teleport stomp does 10k points...

    player.hardbreathtics := player.damagecount * 10;
  end;

  // do the damage
  target.health := target.health - damage;
  if target.health <= 0 then
  begin
    P_KillMobj(source, target);
    exit;
  end;

  if (P_Random < target.info.painchance) and
     ((target.flags and MF_SKULLFLY) = 0) then
  begin
    target.flags := target.flags or MF_JUSTHIT; // fight back!
    P_SetMobjState(target, statenum_t(target.info.painstate));
  end;

  target.reactiontime := 0; // we're awake now...

  if ((target.threshold = 0) or (target._type = Ord(MT_VILE))) and
     (source <> nil) and (source <> target) and (source._type <> Ord(MT_VILE)) then
  begin
    // if not intent on another player,
    // chase after this one
    if target.flags2_ex and MF2_EX_DONTINFIGHTMONSTERS = 0 then
    begin
      target.target := source;
      target.threshold := BASETHRESHOLD;
      if (target.state = @states[target.info.spawnstate]) and
         (target.info.seestate <> Ord(S_NULL)) then
        P_SetMobjState(target, statenum_t(target.info.seestate));
    end;
  end;
end;

procedure P_CmdSuicide;
begin
  if demoplayback then
  begin
    I_Warning('P_CmdSuicide(): You can''t suicide during demo playback.'#13#10);
    exit;
  end;
  if demorecording then
  begin
    I_Warning('P_CmdSuicide(): You can''t suicide during demo recording.'#13#10);
    exit;
  end;

  if (gamestate = GS_LEVEL) and (players[consoleplayer].mo <> nil) then
  begin
    if players[consoleplayer].health > 0 then
    begin
      C_ExecuteCmd('closeconsole');
      P_DamageMobj(players[consoleplayer].mo, nil, nil, 1000);
    end
    else
      printf('You''re already dead.'#13#10);
  end
  else
    I_Warning('P_CmdSuicide(): You can''t suicide if you aren''t playing.'#13#10);
end;

end.

