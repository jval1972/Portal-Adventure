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

unit p_xprocs;

interface

uses
  p_mobj_h;

//==============================================================================
//
// A_Mission1
//
//==============================================================================
procedure A_Mission1(actor: Pmobj_t);

//==============================================================================
//
// A_Mission1Property
//
//==============================================================================
procedure A_Mission1Property(actor: Pmobj_t);

//==============================================================================
//
// A_AutoHeal
//
//==============================================================================
procedure A_AutoHeal(actor: Pmobj_t);

//==============================================================================
//
// A_MoneyThink
//
//==============================================================================
procedure A_MoneyThink(actor: Pmobj_t);

//==============================================================================
//
// A_JoeAttack
//
//==============================================================================
procedure A_JoeAttack(actor: Pmobj_t);

//==============================================================================
//
// A_DrFreakTeleport
//
//==============================================================================
procedure A_DrFreakTeleport(actor: Pmobj_t);

//==============================================================================
//
// A_DrFreakAttack
//
//==============================================================================
procedure A_DrFreakAttack(actor: Pmobj_t);

//==============================================================================
//
// A_DrFreakBubble
//
//==============================================================================
procedure A_DrFreakBubble(actor: Pmobj_t);

//==============================================================================
//
// A_FreakLook
//
//==============================================================================
procedure A_FreakLook(actor: Pmobj_t);

//==============================================================================
//
// A_DrFreakDesideTeleport
//
//==============================================================================
procedure A_DrFreakDesideTeleport(actor: Pmobj_t);

//==============================================================================
//
// A_BeggarSee
//
//==============================================================================
procedure A_BeggarSee(actor: Pmobj_t);

//==============================================================================
//
// A_BeggarInteract
//
//==============================================================================
procedure A_BeggarInteract(actor: Pmobj_t);

//==============================================================================
//
// A_BeggarDeside
//
//==============================================================================
procedure A_BeggarDeside(actor: Pmobj_t);

//==============================================================================
//
// A_BeggarLook
//
//==============================================================================
procedure A_BeggarLook(actor: Pmobj_t);

//==============================================================================
//
// A_PosAttack
//
//==============================================================================
procedure A_PosAttack(actor: Pmobj_t);

var
  mission1: Pmobj_t;

implementation

uses
  d_delphi,
  cm_main,
  gamedef,
  d_think,
  r_defs,
  tables,
  m_rnd,
  m_fixed,
  info_h,
  d_player,
  g_game,
  p_enemy,
  p_extra,
  p_sight,
  p_tick,
  p_mobj,
  p_user,
  p_map,
  p_maputl,
  p_local,
  p_journey,
  sounds,
  s_sound;

const
  S_PROFESSOR = 'PROFESSOR';

const
  S_MISSION1 = 'MISSION1';
  S_MONEYLOOK = 'MONEYLOOK';
  MAXSPAWNPOINTSRK = 10;

//==============================================================================
//
// A_Mission1
//
//==============================================================================
procedure A_Mission1(actor: Pmobj_t);
var
  parm: Pmobjcustomparam_t;
  chp1: Pmobjcustomparam_t;
  moneysee: Pmobjcustomparam_t;
  p: Pplayer_t;
  k: integer;
  currentthinker: Pthinker_t;
  A: array[0..MAXSPAWNPOINTSRK - 1] of Pmobj_t;
  hits: integer;
  i: integer;
  max1, dist: fixed_t;
  rkey, rkeypnt: Pmobj_t;
begin
  parm := P_GetMobjCustomParam(actor, S_MISSION1);
  if parm = nil then
  begin
    parm := P_SetMobjCustomParam(actor, S_MISSION1, 0);
    CM_ExecComicDialog(actor, CM_DialogID('mission1/init'));
  end;

  Inc(parm.value);

  p := @players[consoleplayer];
  if p = nil then
    exit;

//------------------------------------------------------------------------------
  k := P_GetMobjCustomParamValue(actor, 'youwon');
  if k = 1 then
  begin
    youwon := True;
    G_ExitLevel;
  end
  else if k > 1 then
    P_SetMobjCustomParam(actor, 'youwon', k - 1);
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
  k := P_GetMobjCustomParamValue(p.mo, 'BEGGAR1');
  if k = 1 then
  begin
    CM_ExecComicDialog(p.mo, CM_DialogID('beggar/response1'));
    P_SetMobjCustomParam(p.mo, 'BEGGAR1', 0);
  end
  else if k > 1 then
    P_SetMobjCustomParam(p.mo, 'BEGGAR1', k - 1);

//------------------------------------------------------------------------------
  k := P_GetMobjCustomParamValue(p.mo, 'BEGGAR2');
  if k = 1 then
    CM_ExecComicDialog(p.mo, CM_DialogID('beggar/response2'))
  else if k = TICRATE then
  begin
    currentthinker := thinkercap.next;
    hits := 0;
    while (hits < MAXSPAWNPOINTSRK) and (Pointer(currentthinker) <> Pointer(@thinkercap)) do
    begin
      if (@currentthinker._function.acp1 = @P_MobjThinker) and
         (Pmobj_t(currentthinker).info.doomednum = 21118) then // 21118: REDKEYSPAWN
      begin
        A[hits] := Pmobj_t(currentthinker);
        Inc(hits);
      end;
      currentthinker := currentthinker.next;
    end;
    max1 := 0;
    rkeypnt := nil;
    for i := 0 to hits - 1 do
    begin
      dist := P_Distance(p.mo.x - A[i].x, p.mo.y - A[i].y);
      if dist > max1 then
      begin
        rkeypnt := A[i];
        max1 := dist;
      end;
    end;
    if rkeypnt = nil then
      exit; // {? I_Error ???? }
    P_PlayerFaceMobj(p, rkeypnt, 1 * TICRATE);
    rkey := P_SpawnMobj(rkeypnt.x, rkeypnt.y, ONFLOORZ, Ord(MT_MISC5));
    rkey.z := rkey.z + 32 * FRACUNIT;
    rkey.momz := 4 * FRACUNIT;
    rkey.momx := 64 * N_Random;
    rkey.momy := 64 * N_Random;
  end;
  if k > 0 then
    P_SetMobjCustomParam(p.mo, 'BEGGAR2', k - 1);

//------------------------------------------------------------------------------
  moneysee := P_GetMobjCustomParam(p.mo, S_MONEYLOOK);
  if moneysee <> nil then
  begin
    if moneysee.value = 0 then
    begin
      CM_ExecComicDialog(p.mo, CM_DialogID('wolverine/cash2'));
      moneysee.value := -1;
    end
    else if moneysee.value > 0 then
      moneysee.value := moneysee.value - 1;
  end;
//------------------------------------------------------------------------------

  chp1 := P_GetMobjCustomParam(actor, 'CHECKPOINT1');

  case parm.value of
    2 * TICRATE:
      begin
        CM_ExecComicDialog(p.mo, CM_DialogID('wolverine/think1'));
      end;
   30 * TICRATE:
      begin
        if chp1 = nil then
          CM_ExecComicDialog(p.mo, CM_DialogID('wolverine/think2'));
      end;

  end;

//------------------------------------------------------------------------------
  if chp1 <> nil then
  begin
    if chp1.value = 1 then
    begin
       CM_ExecComicDialog(actor, CM_DialogID('mission1/checkpoint1'));
       chp1.value := 0;
    end;
  end;
end;

//==============================================================================
//
// A_Mission1Property
//
//==============================================================================
procedure A_Mission1Property(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  mo := P_FindMobj(22065);
  if mo <> nil then
    P_SetMobjCustomParam(mo, actor.state.params.StrVal[0], actor.state.params.IntVal[1]);
end;

//==============================================================================
//
// A_AutoHeal
//
//==============================================================================
procedure A_AutoHeal(actor: Pmobj_t);
var
  p: Pplayer_t;
begin
  p := actor.player;
  if p = nil then
    exit;

  if p.health >= 100 then
    exit;

  if (leveltime div 4) mod TICRATE <> 0 then
    exit;

  p.health := p.health + 5 - Ord(gameskill);
  if p.health > 100 then
    p.health := 100;
  p.mo.health := p.health;
  p.autohealcount := TICRATE;

  if p = @players[consoleplayer] then
    S_StartSound(nil, Ord(sfx_itemup));

end;

//==============================================================================
//
// A_MoneyThink
//
//==============================================================================
procedure A_MoneyThink(actor: Pmobj_t);
var
  parm: Pmobjcustomparam_t;
begin
  if not P_LookForPlayers(actor, true) then
    exit;

  if actor.target = nil then
    exit;

  if actor.target.player = nil then
    exit;

  parm := P_GetMobjCustomParam(actor.target, S_MONEYLOOK);
  if parm = nil then
    parm := P_SetMobjCustomParam(actor.target, S_MONEYLOOK, 100);
end;

//==============================================================================
//
// A_FireSameSectorOnly
//
//==============================================================================
function A_FireSameSectorOnly(const sec: Psector_t): boolean;
var
  m: Pmobj_t;
begin
  m := sec.thinglist;
  while m <> nil do
  begin
    if m.info.doomednum = 21119 then
    begin
      result := true;
      exit;
    end;
    m := m.snext;
  end;
  result := false;
end;

//==============================================================================
//
// A_PosAttack
//
//==============================================================================
procedure A_PosAttack(actor: Pmobj_t);
var
  angle: angle_t;
  damage: integer;
  slope: integer;
  sec: Psector_t;
begin
  if actor.target = nil then
    exit;

  sec := Psubsector_t(actor.subsector).sector;
  if sec <> Psubsector_t(actor.target.subsector).sector then
    if A_FireSameSectorOnly(sec) then
    begin
      P_SetMobjState(actor, statenum_t(actor.info.seestate));
      Exit;
    end;

  A_FaceTarget(actor);
  angle := actor.angle;
  slope := P_AimLineAttack (actor, angle, MISSILERANGE);

  S_StartSound(actor, Ord(sfx_pistol));
  angle := angle + _SHLW(P_Random - P_Random, 20);
  damage := ((P_Random mod 5) + 1) * 3;
  P_LineAttack(actor, angle, MISSILERANGE, slope, damage);
end;

//==============================================================================
//
// A_JoeAttack
//
//==============================================================================
procedure A_JoeAttack(actor: Pmobj_t);
var
  angle: angle_t;
  damage: integer;
  slope: integer;
  sec: Psector_t;
begin
  if actor.target = nil then
    exit;

  sec := Psubsector_t(actor.subsector).sector;
  if sec <> Psubsector_t(actor.target.subsector).sector then
    if A_FireSameSectorOnly(sec) then
    begin
      P_SetMobjState(actor, statenum_t(actor.info.seestate));
      Exit;
    end;

  A_FaceTarget(actor);
  angle := actor.angle;
  slope := P_AimLineAttack(actor, angle, MISSILERANGE);

  S_StartSound(actor, Ord(sfx_pistol));
  angle := angle + _SHLW(P_Random - P_Random, 20);
  damage := ((P_Random mod 3) + 1) + (Ord(gameskill) div 2);
  P_LineAttack(actor, angle, MISSILERANGE, slope, damage);
end;

const
  MAXDRFREAKTELEPORTS = 32;
  S_FREAKLASTTELEPORT = 'FREAKLASTTELEPORT';

//==============================================================================
//
// A_DrFreakDesideTeleport
//
//==============================================================================
procedure A_DrFreakDesideTeleport(actor: Pmobj_t);
var
  parm: Pmobjcustomparam_t;
begin
  parm := P_GetMobjCustomParam(actor, S_FREAKLASTTELEPORT);
  if parm <> nil then
    if parm.value + 4 * TICRATE < leveltime then
      P_SetMobjState(actor, statenum_t(actor.info.spawnstate));

  P_SetMobjCustomParam(actor, S_FREAKLASTTELEPORT, leveltime);
end;

//==============================================================================
//
// A_DrFreakTeleport
//
//==============================================================================
procedure A_DrFreakTeleport(actor: Pmobj_t);
var
  fog, spot: Pmobj_t;
  currentthinker: Pthinker_t;
  A: array[0..MAXDRFREAKTELEPORTS - 1] of Pmobj_t;
  hits: integer;
  oldx: fixed_t;
  oldy: fixed_t;
  oldz: fixed_t;
  an: angle_t;
begin

  hits := 0;

  if actor.target = nil then
  begin
    currentthinker := thinkercap.next;
    while (hits < MAXDRFREAKTELEPORTS) and (Pointer(currentthinker) <> Pointer(@thinkercap)) do
    begin
      if (@currentthinker._function.acp1 = @P_MobjThinker) and
         (Pmobj_t(currentthinker).info.doomednum = 21115) then // 21115: DrFreakTeleport exit
      begin
        A[hits] := Pmobj_t(currentthinker);
        Inc(hits);
      end;
      currentthinker := currentthinker.next;
    end;
  end
  else
  begin
    currentthinker := thinkercap.next;
    while (hits < MAXDRFREAKTELEPORTS) and (Pointer(currentthinker) <> Pointer(@thinkercap)) do
    begin
      if (@currentthinker._function.acp1 = @P_MobjThinker) and
         (Pmobj_t(currentthinker).info.doomednum = 21115) then // 21115: DrFreakTeleport exit
      begin
        spot := Pmobj_t(currentthinker);
        if (P_AproxDistance(actor.x - spot.x, actor.y - spot.y) > 512 * FRACUNIT) and
           (P_AproxDistance(actor.target.x - spot.x, actor.target.y - spot.y) > 512 * FRACUNIT){ and
           (P_AproxDistance(actor.target.x - spot.x, actor.target.y - spot.y) > 128 * FRACUNIT)} then
        begin
          A[hits] := spot;
          Inc(hits);
        end;
      end;
      currentthinker := currentthinker.next;
    end;

    if hits = 0 then
    begin
      currentthinker := thinkercap.next;
      while (hits < MAXDRFREAKTELEPORTS) and (Pointer(currentthinker) <> Pointer(@thinkercap)) do
      begin
        if (@currentthinker._function.acp1 = @P_MobjThinker) and
           (Pmobj_t(currentthinker).info.doomednum = 21115) then // 21115: DrFreakTeleport exit
        begin
          spot := Pmobj_t(currentthinker);
          if (P_AproxDistance(actor.x - spot.x, actor.y - spot.y) < 1024 * FRACUNIT) and
             (P_AproxDistance(actor.target.x - spot.x, actor.target.y - spot.y) < 1024 * FRACUNIT) and
             (P_AproxDistance(actor.target.x - spot.x, actor.target.y - spot.y) > 128 * FRACUNIT) then
          begin
            A[hits] := spot;
            Inc(hits);
          end;
        end;
        currentthinker := currentthinker.next;
      end;
    end;
  end;

  if (hits = 0) and (actor.target <> nil) then
  begin
    currentthinker := thinkercap.next;
    while (hits < MAXDRFREAKTELEPORTS) and (Pointer(currentthinker) <> Pointer(@thinkercap)) do
    begin
      if (@currentthinker._function.acp1 = @P_MobjThinker) and
         (Pmobj_t(currentthinker).info.doomednum = 21115) then // 21115: DrFreakTeleport exit
        if (P_AproxDistance(actor.target.x - spot.x, actor.target.y - spot.y) > 128 * FRACUNIT) then
        begin
          A[hits] := Pmobj_t(currentthinker);
          Inc(hits);
        end;
      currentthinker := currentthinker.next;
    end;
  end;

  if hits = 0 then
    Exit;

  spot := A[P_Random mod hits];

  oldx := actor.x;
  oldy := actor.y;
  oldz := actor.z;

  if not P_TeleportMove(actor, spot.x, spot.y) then
    exit;

  P_PlayerFaceMobj(@players[consoleplayer], spot, 2 * TICRATE);

  actor.angle := spot.angle;

  actor.momx := 0;
  actor.momy := 0;
  actor.z := actor.floorz;

  fog := P_SpawnMobj(oldx, oldy, oldz, Ord(MT_TFOG));
  S_StartSound(fog, Ord(sfx_telept));

  an := spot.angle shr ANGLETOFINESHIFT;
  fog := P_SpawnMobj(spot.x + 20 * finecosine[an],
                     spot.y + 20 * finesine[an],
                     actor.z, Ord(MT_TFOG));
  S_StartSound(fog, Ord(sfx_telept));

  P_SetMobjState(actor, statenum_t(actor.info.spawnstate));

end;

//==============================================================================
//
// A_DrFreakAttack
//
//==============================================================================
procedure A_DrFreakAttack(actor: Pmobj_t);
begin
  if actor.target = nil then
    exit;

  A_FaceTarget(actor);
  actor.angle := actor.angle + _SHLW(P_Random - P_Random, 20);
  P_SpawnMissile(actor, actor.target, Ord(MT_ROCKET));
end;

//==============================================================================
//
// A_FreakLook
//
//==============================================================================
procedure A_FreakLook(actor: Pmobj_t);
begin
  A_Look(actor);
  if actor.target = nil then
    actor.angle := actor.angle + ANG5
  else
    A_FaceTarget(actor);
end;

const
  S_FREAKLASTSPEAK = 'FREAKLASTSPEAK';

//==============================================================================
//
// A_DrFreakBubble
//
//==============================================================================
procedure A_DrFreakBubble(actor: Pmobj_t);
var
  parm: Pmobjcustomparam_t;
begin
  if not P_CheckStateParams(actor) then
    exit;

  parm := P_GetMobjCustomParam(actor, S_FREAKLASTSPEAK);
  if parm = nil then
  begin
    A_ComicBubble(actor);
  end
  else
  begin
    if parm.value + 4 * TICRATE < leveltime then
      A_ComicBubble(actor);
  end;
  P_SetMobjCustomParam(actor, S_FREAKLASTSPEAK, leveltime);
end;

const
  S_BEGGARLASTTALK = 'BEGGARLASTTALK';

//==============================================================================
//
// A_BeggarSee
//
//==============================================================================
procedure A_BeggarSee(actor: Pmobj_t);
var
  lasttalk: integer;
begin
  if actor.target = nil then
  begin
    A_Look(actor);
    exit;
  end;

  A_SetInteractive(actor);
  if not P_CheckSight(actor, actor.target) then
    Exit;
  lasttalk := P_GetMobjCustomParamValue(actor, S_BEGGARLASTTALK);
  if leveltime - lasttalk > 4 * TICRATE then
  begin
    if P_Random < 60 then
      exit;

    if P_AproxDistance(actor.x - actor.target.x, actor.y - actor.target.y) > 512 * FRACUNIT then
    begin
      //P_SetMobjState(actor, statenum_t(actor.info.spawnstate));
      Exit;
    end;

    P_SetMobjCustomParam(actor, S_BEGGARLASTTALK, leveltime);
    if P_Random < 128 then
      CM_ExecComicDialog(actor, CM_DialogID('beggar/dialog1'))
    else
      CM_ExecComicDialog(actor, CM_DialogID('beggar/dialog2'));
  end;

end;

const
  S_BEGGAR_INTERACT_LEVEL_NOMONEY = 'BEGGAR_INTERACT_LEVEL_NOMONEY';
  S_BEGGAR_INTERACT_LEVEL_MONEY = 'BEGGAR_INTERACT_LEVEL_MONEY';
  S_BEGGAR_INTERACT_EARLY_EXIT = 'BEGGAR_INTERACT_EARLY_EXIT';

//==============================================================================
//
// A_BeggarInteract
//
//==============================================================================
procedure A_BeggarInteract(actor: Pmobj_t);
var
  lasttalk: integer;
  k: integer;
  il_nomoney{, il_money}: integer;
  money, bmoney: integer;
begin
  if actor.target = nil then
  begin
    P_SetMobjState(actor, statenum_t(actor.info.spawnstate));
    exit;
  end;

  if actor.target.player = nil then
  begin
    P_SetMobjState(actor, statenum_t(actor.info.spawnstate));
    exit;
  end;

  lasttalk := P_GetMobjCustomParamValue(actor, S_BEGGARLASTTALK);

  if leveltime - lasttalk < 4 * TICRATE then
  begin
    P_SetMobjCustomParam(actor, S_BEGGAR_INTERACT_EARLY_EXIT, 1);
    exit; {Already talking}
  end;

  A_UnSetInteractive(actor);

  money := P_GetMobjCustomParamValue(actor.target, 'MONEY');
  bmoney := P_GetMobjCustomParamValue(actor, 'MONEY');
  if (money = 0) and (bmoney = 0) then
  begin
    il_nomoney := P_GetMobjCustomParamValue(actor, S_BEGGAR_INTERACT_LEVEL_NOMONEY);
    if il_nomoney = 0 then
    begin
      k := P_GetMobjCustomParamValue(actor.target, 'BEGGAR1');
      if k = 0 then
      begin
        CM_ExecComicDialog(actor, CM_DialogID('beggar/dialog3'));
        P_SetMobjCustomParam(actor, S_BEGGARLASTTALK, leveltime + 3 * TICRATE);
        P_SetMobjCustomParam(actor.target, 'BEGGAR1', 3 * TICRATE);
        P_PlayerFaceMobj(actor.target.player, actor, 3 * TICRATE);
      end;
    end
    else if il_nomoney = 1 then
    begin
      CM_ExecComicDialog(actor, CM_DialogID('beggar/dialog4'));
      P_SetMobjCustomParam(actor, S_BEGGARLASTTALK, leveltime);
      P_PlayerFaceMobj(actor.target.player, actor, 2 * TICRATE);
    end
    else
    begin
      CM_ExecComicDialog(actor, CM_DialogID('beggar/dialog5'));
      P_SetMobjCustomParam(actor, S_BEGGARLASTTALK, leveltime + 3 * TICRATE);
      P_PlayerFaceMobj(actor.target.player, actor, 3 * TICRATE);
    end;
    P_SetMobjCustomParam(actor, S_BEGGAR_INTERACT_LEVEL_NOMONEY, il_nomoney + 1);
    exit;
  end
  else if (money < 500) and (bmoney = 0) then
  begin
    CM_ExecComicDialog(actor, CM_DialogID('beggar/dialog' + Chr(Ord('3') + (P_Random mod 3))));
    P_SetMobjCustomParam(actor, S_BEGGARLASTTALK, leveltime + 3 * TICRATE);
    P_PlayerFaceMobj(actor.target.player, actor, 3 * TICRATE);
  end
  else if bmoney > 0 then
  begin
    CM_ExecComicDialog(actor, CM_DialogID('beggar/dialog6'));
    P_SetMobjCustomParam(actor, S_BEGGARLASTTALK, leveltime);
    P_PlayerFaceMobj(actor.target.player, actor, 1 * TICRATE);
  end
  else
  begin
    k := P_GetMobjCustomParamValue(actor.target, 'BEGGAR2');
    if k = 0 then
    begin
      P_SetMobjCustomParam(actor.target, 'BEGGAR2', 4 * TICRATE);
      P_SetMobjCustomParam(actor.target, 'MONEY', money - 500);
      P_SetMobjCustomParam(actor, 'MONEY', 500);
      S_StartSound(nil, 'money/cash01');
      CM_ExecComicDialog(actor, CM_DialogID('beggar/dialog7'));
      P_SetMobjCustomParam(actor, S_BEGGARLASTTALK, leveltime + 2 * TICRATE);
      P_PlayerFaceMobj(actor.target.player, actor, 5 * TICRATE);
    end;
  end;

end;

//==============================================================================
//
// A_BeggarDeside
//
//==============================================================================
procedure A_BeggarDeside(actor: Pmobj_t);
begin
  A_SetInteractive(actor);
  if P_GetMobjCustomParamValue(actor, S_BEGGAR_INTERACT_EARLY_EXIT) > 0 then
  begin
    P_SetMobjCustomParam(actor, S_BEGGAR_INTERACT_EARLY_EXIT, 0);
    P_SetMobjState(actor, statenum_t(actor.info.interactstate));
    exit;
  end;
  if P_GetMobjCustomParamValue(actor, 'MONEY') = 0 then
    P_SetMobjState(actor, statenum_t(actor.info.seestate))
  else
    P_SetMobjState(actor, statenum_t(actor.info.spawnstate))
end;

//==============================================================================
//
// A_BeggarLook
//
//==============================================================================
procedure A_BeggarLook(actor: Pmobj_t);
begin
//  if P_GetMobjCustomParamValue(actor, 'MONEY') = 0 then
    A_Look(actor);
end;

end.
