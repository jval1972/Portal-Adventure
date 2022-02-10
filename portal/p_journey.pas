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

unit p_journey;

interface

uses
  d_delphi,
  d_player,
  m_fixed,
  p_mobj_h;

//==============================================================================
//
// A_PlayerAngle
//
//==============================================================================
procedure A_PlayerAngle(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M1
//
//==============================================================================
procedure A_E1M1(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M2
//
//==============================================================================
procedure A_E1M2(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M3
//
//==============================================================================
procedure A_E1M3(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M4
//
//==============================================================================
procedure A_E1M4(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M5
//
//==============================================================================
procedure A_E1M5(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M6
//
//==============================================================================
procedure A_E1M6(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M7
//
//==============================================================================
procedure A_E1M7(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M8
//
//==============================================================================
procedure A_E1M8(const actor: Pmobj_t);

//==============================================================================
//
// J_RestorePlayers
//
//==============================================================================
procedure J_RestorePlayers;

//==============================================================================
//
// J_RestorePlayerParams
//
//==============================================================================
procedure J_RestorePlayerParams(const p: Pplayer_t);

//==============================================================================
//
// A_E1M2_PORTAL
//
//==============================================================================
procedure A_E1M2_PORTAL(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M3_PORTAL
//
//==============================================================================
procedure A_E1M3_PORTAL(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M4_PORTAL
//
//==============================================================================
procedure A_E1M4_PORTAL(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M5_PORTAL
//
//==============================================================================
procedure A_E1M5_PORTAL(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M6_PORTAL
//
//==============================================================================
procedure A_E1M6_PORTAL(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M7_PORTAL
//
//==============================================================================
procedure A_E1M7_PORTAL(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M8_PORTAL
//
//==============================================================================
procedure A_E1M8_PORTAL(const actor: Pmobj_t);

//==============================================================================
//
// A_E1M9_PORTAL
//
//==============================================================================
procedure A_E1M9_PORTAL(const actor: Pmobj_t);

//==============================================================================
//
// A_Manager_Look
//
//==============================================================================
procedure A_Manager_Look(const actor: Pmobj_t);

//==============================================================================
//
// A_Manager_A
//
//==============================================================================
procedure A_Manager_A(const actor: Pmobj_t);

//==============================================================================
//
// A_Manager_Look_B
//
//==============================================================================
procedure A_Manager_Look_B(const actor: Pmobj_t);

//==============================================================================
//
// A_Manager_B
//
//==============================================================================
procedure A_Manager_B(const actor: Pmobj_t);

//==============================================================================
//
// A_Manager_C
//
//==============================================================================
procedure A_Manager_C(const actor: Pmobj_t);

//==============================================================================
//
// A_Manager_D
//
//==============================================================================
procedure A_Manager_D(const actor: Pmobj_t);

//==============================================================================
//
// A_EgyptBox
//
//==============================================================================
procedure A_EgyptBox(const actor: Pmobj_t);

//==============================================================================
//
// A_SectorAutoAlign
//
//==============================================================================
procedure A_SectorAutoAlign(const actor: Pmobj_t);

//==============================================================================
//
// A_RaptorChase
//
//==============================================================================
procedure A_RaptorChase(const actor: Pmobj_t);

//==============================================================================
//
// A_FreakA_1
//
//==============================================================================
procedure A_FreakA_1(const actor: Pmobj_t);

//==============================================================================
//
// A_FreakA_2
//
//==============================================================================
procedure A_FreakA_2(const actor: Pmobj_t);

//==============================================================================
//
// A_FreakA_3
//
//==============================================================================
procedure A_FreakA_3(const actor: Pmobj_t);

//==============================================================================
//
// A_SpawnWaterSplash
//
//==============================================================================
procedure A_SpawnWaterSplash(actor: Pmobj_t);

//==============================================================================
//
// A_Majong_A
//
//==============================================================================
procedure A_Majong_A(const actor: Pmobj_t);

//==============================================================================
//
// A_Majong_B
//
//==============================================================================
procedure A_Majong_B(const actor: Pmobj_t);

//==============================================================================
//
// A_Majong_C
//
//==============================================================================
procedure A_Majong_C(const actor: Pmobj_t);

//==============================================================================
//
// A_FacePlayer
//
//==============================================================================
procedure A_FacePlayer(const actor: Pmobj_t);

//==============================================================================
//
// P_FindMobj
//
//==============================================================================
function P_FindMobj(const dn: integer): Pmobj_t;

var
  j_restore: boolean = false;
  j_gamemap: integer;
  j_gameepisode: integer;
  j_jump: boolean = false;

//==============================================================================
//
// J_DeleteSaveSlot
//
//==============================================================================
procedure J_DeleteSaveSlot(const x: integer);

//==============================================================================
//
// J_CopySaveSlot
//
//==============================================================================
procedure J_CopySaveSlot(const x: integer);

//==============================================================================
//
// J_RestoreSaveSlot
//
//==============================================================================
procedure J_RestoreSaveSlot(const x: integer);

type
  journeymapinfo_t = record
    skytexture: string[8];
    drawsky: boolean;
    fog_r, fog_g, fog_b: float;
    fog_density: integer;
    gl_clear: boolean;
    view_xy, view_z: integer;
    waterheight: integer;
    min_viewz: fixed_t;
    look2: boolean;
    walksnd: boolean;
    drawshadows: boolean;
  end;

var
  journeymapinfo: array[1..9] of journeymapinfo_t = (
      ( // E1M1
        skytexture: 'SKY1';
        drawsky: true;
        fog_r: 0.0;
        fog_g: 0.0;
        fog_b: 0.0;
        fog_density: 100;
        gl_clear: false;
        view_xy: 192;
        view_z:   0;
        waterheight: -10000;
        min_viewz: -10240 * FRACUNIT;
        look2: false;
        walksnd: true;
        drawshadows: true;
      ),
      ( // E1M2
        skytexture: 'SKY1';
        drawsky: false;
        fog_r: 0.0;
        fog_g: 0.0;
        fog_b: 0.0;
        fog_density: 100;
        gl_clear: true;
        view_xy:  72;
        view_z: -16;
        waterheight: -10000;
        min_viewz: -10240 * FRACUNIT;
        look2: true;
        walksnd: true;
        drawshadows: true;
      ),
      ( // E1M3
        skytexture: 'SKY3';
        drawsky: true;
        fog_r: 1.0;
        fog_g: 0.8;
        fog_b: 0.5;
        fog_density:  50;
        gl_clear: false;
        view_xy: 192;
        view_z:   0;
        waterheight: -10000;
        min_viewz: -10240 * FRACUNIT;
        look2: true;
        walksnd: true;
        drawshadows: true;
      ),
      ( // E1M4
        skytexture: 'SKY3';
        drawsky: true;
        fog_r: 0.4;
        fog_g: 0.4;
        fog_b: 0.4;
        fog_density:  50;
        gl_clear: false;
        view_xy: 192;
        view_z:   0;
        waterheight:     -4;
        min_viewz:   -190 * FRACUNIT;
        look2: true;
        walksnd: true;
        drawshadows: true;
      ),
      ( // E1M5
        skytexture: 'SKY1';
        drawsky: true;
        fog_r: 0.7;
        fog_g: 0.7;
        fog_b: 0.7;
        fog_density: 20;
        gl_clear: false;
        view_xy: 92;
        view_z:   0;
        waterheight: -10000;
        min_viewz: -10240 * FRACUNIT;
        look2: true;
        walksnd: true;
        drawshadows: true;
      ),
      ( // E1M6
        skytexture: 'SKY5';
        drawsky: true;
        fog_r: 0.1;
        fog_g: 0.1;
        fog_b: 0.1;
        fog_density: 70;
        gl_clear: false;
        view_xy: 96;
        view_z:   0;
        waterheight: -10000;
        min_viewz: -10240 * FRACUNIT;
        look2: true;
        walksnd: true;
        drawshadows: true;
      ),
      ( // E1M7
        skytexture: 'SKY7';
        drawsky: true;
        fog_r: 0.0;
        fog_g: 0.0;
        fog_b: 0.0;
        fog_density: 100;
        gl_clear: false;
        view_xy: 96;
        view_z:   0;
        waterheight: -10000;
        min_viewz: -10240 * FRACUNIT;
        look2: true;
        walksnd: true;
        drawshadows: true;
      ),
      ( // E1M8
        skytexture: 'SKY1';
        drawsky: false;
        fog_r: 0.0;
        fog_g: 0.0;
        fog_b: 0.0;
        fog_density: 100;
        gl_clear: false;
        view_xy: 92;
        view_z:   0;
        waterheight: -10000;
        min_viewz: -10240 * FRACUNIT;
        look2: true;
        walksnd: false;
        drawshadows: false;
      ),
      ( // E1M9
        skytexture: 'SKY1';
        drawsky: true;
        fog_r: 0.0;
        fog_g: 0.0;
        fog_b: 0.0;
        fog_density: 100;
        gl_clear: false;
        view_xy: 192;
        view_z:   0;
        waterheight: -10000;
        min_viewz: -10240 * FRACUNIT;
        look2: true;
        walksnd: true;
        drawshadows: true;
      )
  );

implementation

uses
  gamedef,
  d_main,
  dstrings,
  d_event,
  c_con,
  m_argv,
  info_h,
  info,
  i_system,
  cm_main,
  d_think,
  r_main,
  tables,
  m_rnd,
  g_game,
  s_sound,
  sounds,
  r_defs,
  r_procs,
  p_setup,
  p_terrain,
  p_sounds,
  p_inter,
  p_mobj,
  p_map,
  p_local,
  p_user,
  p_enemy,
  p_extra,
  p_tick,
  p_maputl;

const
  RETURNPOINT = 22004;

//==============================================================================
//
// P_JumpSaveName
//
//==============================================================================
function P_JumpSaveName(const ep, map: Integer): string;
begin
  result := M_SaveFileName(SAVEGAMENAME + '8') + itoa(ep) + itoa(map) + '.dsg';
end;

//==============================================================================
//
// J_DeleteSaveSlot
//
//==============================================================================
procedure J_DeleteSaveSlot(const x: integer);
var
  i: integer;
  fname: string;
begin
  for i := 0 to 9 do
  begin
    fname := M_SaveFileName(SAVEGAMENAME) + itoa(x) + '1' + itoa(i) + '.dsg';
    if fexists(fname) then
      fdelete(fname);
  end;

end;

//==============================================================================
//
// J_CopySaveSlot
//
//==============================================================================
procedure J_CopySaveSlot(const x: integer);
var
  i: integer;
  FromN, ToN: string;
begin
  J_DeleteSaveSlot(x);
  for i := 0 to 9 do
  begin
    FromN := M_SaveFileName(SAVEGAMENAME) + '81' + itoa(i) + '.dsg';
    if fexists(FromN) then
    begin
      ToN := M_SaveFileName(SAVEGAMENAME) + itoa(x) + '1' + itoa(i) + '.dsg';
      CopyFile2(FromN, ToN);
    end;
  end;
end;

//==============================================================================
//
// J_RestoreSaveSlot
//
//==============================================================================
procedure J_RestoreSaveSlot(const x: integer);
var
  i: integer;
  FromN, ToN: string;
begin
  J_DeleteSaveSlot(8);
  for i := 0 to 9 do
  begin
    FromN := M_SaveFileName(SAVEGAMENAME) + itoa(x) + '1' + itoa(i) + '.dsg';
    if fexists(FromN) then
    begin
      ToN := M_SaveFileName(SAVEGAMENAME) + '81' + itoa(i) + '.dsg';
      CopyFile2(FromN, ToN);
    end;
  end;
end;

var
  playersbackup: array[0..MAXPLAYERS - 1] of player_t;

//==============================================================================
//
// P_FindMobj
//
//==============================================================================
function P_FindMobj(const dn: integer): Pmobj_t;
var
  currentthinker: Pthinker_t;
begin
  currentthinker := thinkercap.next;
  while Pointer(currentthinker) <> Pointer(@thinkercap) do
  begin
    if (@currentthinker._function.acp1 = @P_MobjThinker) and
       (Pmobj_t(currentthinker).info.doomednum = dn) then
    begin
      result := Pmobj_t(currentthinker);
      exit;
    end;
    currentthinker := currentthinker.next;
  end;

  result := nil;
end;

//==============================================================================
//
// P_KeepPlayerNearMe
//
//==============================================================================
procedure P_KeepPlayerNearMe(const actor: Pmobj_t; const p: Pplayer_t; const dist: fixed_t; const tics: integer);
begin
  p.radiouskeep := dist;
  p.radiousx := actor.x;
  p.radiousy := actor.y;
  p.radiousticks := tics;
end;

//==============================================================================
//
// P_JumpToMap
//
//==============================================================================
procedure P_JumpToMap(const ep, map: Integer);
var
  currentthinker: Pthinker_t;
  rp_mo: Pmobj_t; // return point
  p_mo: Pmobj_t;
begin

  currentthinker := thinkercap.next;
  rp_mo := nil;
  while Pointer(currentthinker) <> Pointer(@thinkercap) do
  begin
    if (@currentthinker._function.acp1 = @P_MobjThinker) and
       (Pmobj_t(currentthinker).info.doomednum = RETURNPOINT) then
    begin
      rp_mo := Pmobj_t(currentthinker);
      break;
    end;
    currentthinker := currentthinker.next;
  end;

  if rp_mo = nil then
    I_Error('P_JumpToMap(): rp_mo = nil');

  p_mo := players[consoleplayer].mo;
  P_SetMobjState(p_mo, S_PLAY);

  p_mo.x := rp_mo.x;
  p_mo.y := rp_mo.y;
  p_mo.z := rp_mo.z;
  p_mo.momx := 0;
  p_mo.momy := 0;
  p_mo.momz := 0;
  p_mo.angle := rp_mo.angle;

  norender := true; // Don't render next frame
  nodrawers := true;
  noblit := true;

  P_SetMobjCustomParam(p_mo, 'LEVELTIME' + itoa(gameepisode) + itoa(gamemap), leveltime);
  memcpy(@playersbackup, @players, SizeOf(players));

  C_AddCommand('savegame ' + P_JumpSaveName(gameepisode, gamemap));
  C_AddCommand('interpolate 0');
  C_SkipTicks(TICRATE div 2);

  if fexists(P_JumpSaveName(ep, map)) then
    C_AddCommand('loadgame ' + P_JumpSaveName(ep, map))
  else
    C_AddCommand('engage ' + itoa(ep) + ' ' + itoa(map));
  j_restore := true;

  C_AddCommand('interpolate 1');
end;

//==============================================================================
//
// J_RestorePlayers
//
//==============================================================================
procedure J_RestorePlayers;
var
  i, j: integer;
begin
  for i := 0 to MAXPLAYERS - 1 do
    if playeringame[i] then
    begin
      players[i].health := playersbackup[i].health;
      players[i].armorpoints := playersbackup[i].armorpoints;
      players[i].armortype := playersbackup[i].armortype;
      players[i].powers := playersbackup[i].powers;
      players[i].cards := playersbackup[i].cards;
      players[i].ammo[Ord(am_clip)] := 2000000000; //jval: JOURNEY
      players[i].maxammo[Ord(am_clip)] := 2000000000; //jval: JOURNEY
      players[i].ammo[Ord(am_cell)] := 300; //jval: JOURNEY
      players[i].maxammo[Ord(am_cell)] := 300; //jval: JOURNEY
      for j := 0 to 8 do
        players[i].weaponowned[j] := playersbackup[i].weaponowned[j];
      players[i].numparams := playersbackup[i].numparams;
      players[i].params := playersbackup[i].params;
      players[i].do_updateparams := true;
      players[i].breathtype := 0;
      if playersbackup[i].weaponowned[Ord(wp_chaingun)] <> 0 then
      begin
        players[i].weaponowned[Ord(wp_pistol)] := 0;
        players[i].readyweapon := wp_chaingun;
        players[i].pendingweapon := wp_chaingun;
      end
    end;
end;

//==============================================================================
//
// J_RestorePlayerParams
//
//==============================================================================
procedure J_RestorePlayerParams(const p: Pplayer_t);
var
  j: integer;
begin
  P_ClearMobjCustomParams(p.mo);
  for j := 0 to p.numparams - 1 do
    P_SetMobjCustomParam(p.mo, p.params[j].name, p.params[j].value);
end;

//==============================================================================
//
// A_PlayerAngle
//
//==============================================================================
procedure A_PlayerAngle(const actor: Pmobj_t);
var
  p: Pplayer_t;
  mo: Pmobj_t;
begin
  if not P_CheckStateParams(actor, 1) then
    exit;

  p := @players[consoleplayer];
  mo := p.mo;

  mo.angle := actor.state.params.IntVal[0] * ANG1;
end;

//==============================================================================
//
// A_E1M1
//
//==============================================================================
procedure A_E1M1(const actor: Pmobj_t);
var
  p: Pplayer_t;
  mo: Pmobj_t;
  a: angle_t;
  dist: integer;
begin
  p := @players[consoleplayer];
  mo := p.mo;

  a := mo.angle div ANG1;
  if a < 70 then
    a := 70
  else if a > 110 then
    a := 110;

  mo.angle := a * ANG1;

  dist := P_Distance(mo.x - actor.x, mo.y - actor.y) div FRACUNIT;
  if dist < 128 then
  begin
    journeymapinfo[1].view_xy := 192 - (128 - dist);

    if dist < 64 then
    begin
      C_AddCommand('engage E1M2');
      P_SetMobjCustomParam(mo, 'LEVELTIME' + itoa(gameepisode) + itoa(gamemap), leveltime);
    end;
  end
  else
    journeymapinfo[1].view_xy := 192;

end;

//==============================================================================
//
// A_E1M2
//
//==============================================================================
procedure A_E1M2(const actor: Pmobj_t);
var
  parm: Pmobjcustomparam_t;
begin
  parm := P_GetMobjCustomParam(actor, 'E1M2TICKER');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'E1M2TICKER', 0);

  Inc(parm.value);

  case parm.value of
    1: CM_ExecComicDialog(actor, CM_DialogID('e1m1/a'));
  end;

end;

//==============================================================================
//
// P_DoPortal
//
//==============================================================================
procedure P_DoPortal(const actor: Pmobj_t; const ep, map: Integer);
var
  mo: Pmobj_t;
  fog: Pmobj_t;
  parm: Pmobjcustomparam_t;
begin
  parm := P_GetMobjCustomParam(actor, 'PORTALFOG');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'PORTALFOG', 0);

  if N_Random < 10 then
  begin
    fog := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_TFOG));
    parm.value := leveltime;
  end
  else if leveltime - parm.value > TICRATE then
  begin
    fog := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_TFOG));
    parm.value := leveltime;
  end;

  mo := players[consoleplayer].mo;
  if P_Distance(mo.x - actor.x, mo.y - actor.y) < 32 * FRACUNIT then
    if Abs(mo.z - actor.z) < 64 * FRACUNIT then
      P_JumpToMap(ep, map);
end;

//==============================================================================
//
// A_E1M2_PORTAL
//
//==============================================================================
procedure A_E1M2_PORTAL(const actor: Pmobj_t);
begin
  P_DoPortal(actor, 1, 2);
end;

//==============================================================================
//
// A_E1M3_PORTAL
//
//==============================================================================
procedure A_E1M3_PORTAL(const actor: Pmobj_t);
begin
  P_DoPortal(actor, 1, 3);
end;

//==============================================================================
//
// A_E1M4_PORTAL
//
//==============================================================================
procedure A_E1M4_PORTAL(const actor: Pmobj_t);
begin
  P_DoPortal(actor, 1, 4);
end;

//==============================================================================
//
// A_E1M5_PORTAL
//
//==============================================================================
procedure A_E1M5_PORTAL(const actor: Pmobj_t);
begin
  P_DoPortal(actor, 1, 5);
end;

//==============================================================================
//
// A_E1M6_PORTAL
//
//==============================================================================
procedure A_E1M6_PORTAL(const actor: Pmobj_t);
begin
  P_DoPortal(actor, 1, 6);
end;

//==============================================================================
//
// A_E1M7_PORTAL
//
//==============================================================================
procedure A_E1M7_PORTAL(const actor: Pmobj_t);
begin
  P_DoPortal(actor, 1, 7);
end;

//==============================================================================
//
// A_E1M8_PORTAL
//
//==============================================================================
procedure A_E1M8_PORTAL(const actor: Pmobj_t);
begin
  P_DoPortal(actor, 1, 8);
end;

//==============================================================================
//
// A_E1M9_PORTAL
//
//==============================================================================
procedure A_E1M9_PORTAL(const actor: Pmobj_t);
begin
  P_DoPortal(actor, 1, 9);
end;

//==============================================================================
// P_SpawnObjectToSpot
//
// Use .doomednum for mobjinfo table
//
//==============================================================================
function P_SpawnObjectToSpot(const spotdn, typedn: integer; const targetmo: Pmobj_t; const mindist: integer): Pmobj_t;
var
  A: array[0..127] of Pmobj_t;
  hits: integer;
  currentthinker: Pthinker_t;
  spot: Pmobj_t;
begin
  currentthinker := thinkercap.next;
  hits := 0;
  while (hits < 128) and (Pointer(currentthinker) <> Pointer(@thinkercap)) do
    begin
    if (@currentthinker._function.acp1 = @P_MobjThinker) and
       (Pmobj_t(currentthinker).info.doomednum = spotdn) then
    begin
      spot := Pmobj_t(currentthinker);
      if P_Distance(targetmo.x - spot.x, targetmo.y - spot.y) >= mindist then
      begin
        A[hits] := spot;
        Inc(hits);
      end;
    end;
    currentthinker := currentthinker.next;
  end;
  if hits = 0 then
  begin
    result := nil;
    exit;
  end;

  spot := A[N_Random mod hits];
  result := P_SpawnMobj(spot.x, spot.y, ONFLOORZ, Info_GetMobjNumForDoomNum(typedn));
  if result <> nil then
  begin
    result.z := result.z + 16 * FRACUNIT;
    result.momz := 8 * FRACUNIT;
    result.momx := 32 * N_Random;
    result.momy := 32 * N_Random;
  end;
end;

//==============================================================================
//
// A_Manager_Look
//
//==============================================================================
procedure A_Manager_Look(const actor: Pmobj_t);
begin
  if players[consoleplayer].mo <> nil then
    actor.target := players[consoleplayer].mo;
  A_FaceTarget(actor);
end;

//==============================================================================
//
// A_Manager_A
//
//==============================================================================
procedure A_Manager_A(const actor: Pmobj_t);
var
  p: Pplayer_t;
  parm: Pmobjcustomparam_t;
  parm2: Pmobjcustomparam_t;
  mo: Pmobj_t;
begin
  parm := P_GetMobjCustomParam(actor, 'INTERACT_COUNT');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'INTERACT_COUNT', 0);

  parm2 := P_GetMobjCustomParam(actor, 'INTERACT_TICS');
  if parm2 = nil then
    parm2 := P_SetMobjCustomParam(actor, 'INTERACT_TICS', 0);

  p := @players[consoleplayer];
  if p.mo = nil then
    Exit;

  if p.cards[Ord(it_greencard)] then
    if P_GetMobjCustomParamValue(actor, 'GREENKEYFOUND') = 0 then
      if P_GetMobjCustomParamValue(p.mo, 'LEVELTIME' + itoa(gameepisode) + '5') = 0 then
      begin
        P_SetMobjCustomParam(actor, 'GREENKEYFOUND', 1);
        P_KeepPlayerNearMe(actor, p, 128 * FRACUNIT, 5 * TICRATE);
        P_PlayerFaceMobj(p, actor, 5 * TICRATE);
        CM_ExecComicDialog(actor, CM_DialogID('manager_a/greenkey'));
      end;

  if p.cards[Ord(it_bluecard)] then
    if P_GetMobjCustomParamValue(actor, 'BLUEKEYFOUND') = 0 then
      if P_GetMobjCustomParamValue(p.mo, 'LEVELTIME' + itoa(gameepisode) + '7') = 0 then
      begin
        P_SetMobjCustomParam(actor, 'BLUEKEYFOUND', 1);
        P_KeepPlayerNearMe(actor, p, 128 * FRACUNIT, 5 * TICRATE);
        P_PlayerFaceMobj(p, actor, 5 * TICRATE);
        CM_ExecComicDialog(actor, CM_DialogID('manager_a/bluekey'));
      end;

  actor.target := p.mo;
  A_FaceTarget(actor);

  A_UnSetInteractive(actor);

  if parm2.value > 0 then
  begin
    Dec(parm2.value);
    if parm2.value = 0 then
    begin
      A_SetInteractive(actor);
      P_SetMobjState(actor, statenum_t(actor.info.seestate));
    end;
    exit;
  end;

  inc(parm.value);

  case parm.value of
    1:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_a/speech1'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_a/speech1'), 3 * TICRATE);
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply2/manager_a/speech1'), 6 * TICRATE);
        parm2.value := 9 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 96 * FRACUNIT, 9 * TICRATE);
      end;
    2:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_a/speech2'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_a/speech2'), 8 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 96 * FRACUNIT, 13 * TICRATE);
      end;

    3:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_a/speech3'));
        parm2.value := 9 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 96 * FRACUNIT, 9 * TICRATE);
      end;

    4:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_a/speech4'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_a/speech4'), 8 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 96 * FRACUNIT, 13 * TICRATE);
      end;

    5:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_a/speech5'));
        parm2.value := 6 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 96 * FRACUNIT, 6 * TICRATE);
      end;

    6:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_a/speech6'));
        parm2.value := 6 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 96 * FRACUNIT, 6 * TICRATE);
      end;

    7:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_a/speech7'));
        parm2.value := 7 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 96 * FRACUNIT, 7 * TICRATE);
      end;

    8:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        mo := P_SpawnObjectToSpot(22014, 6, p.mo, 64 * FRACUNIT);
        if mo <> nil then
          P_PlayerFaceMobj(p, mo, TICRATE div 2);
      end;
  end;

end;

//==============================================================================
//
// A_EgyptBox
//
//==============================================================================
procedure A_EgyptBox(const actor: Pmobj_t);
begin
  if (actor.z < 0) and (actor.flags2_ex and MF2_EX_PUSHABLE <> 0) then
  begin
    actor.flags2_ex := actor.flags2_ex and not MF2_EX_PUSHABLE;
    actor.momx := 0;
    actor.momy := 0;
    S_StartSound(actor, 'egbox001');
  end;
end;

//==============================================================================
//
// A_E1M3
//
//==============================================================================
procedure A_E1M3(const actor: Pmobj_t);
var
  currentthinker: Pthinker_t;
  alldone: Boolean;
  parm: Pmobjcustomparam_t;
  py: integer;
  p: Pplayer_t;
begin
  p := @players[consoleplayer];
  if p.mo = nil then
    Exit;

  py := p.mo.y div FRACUNIT;

  if py < -5000 then
    journeymapinfo[3].view_xy := 192 + round((py + 5000) / 5)
  else if py > -500 then
    journeymapinfo[3].view_xy := 92
  else if py > -1500 then
    journeymapinfo[3].view_xy := 192 - round((py + 1500) / 10)
  else
    journeymapinfo[3].view_xy := 192;

  if Psubsector_t(p.mo.subsector).sector.tag = 1 then
    if p.mo.z < -300 * FRACUNIT then
    begin
      P_DamageMobj(p.mo, nil, nil, 10000);
      exit;
    end;

  parm := P_GetMobjCustomParam(actor, 'ALLDONE');
  if parm <> nil then
  begin
    Inc(parm.value);
    if parm.value > TICRATE then
      exit
    else if parm.value = TICRATE then
    begin
      P_SpawnMobj(actor.x, actor.y, ONFLOORZ, Info_GetMobjNumForDoomNum(22007)); // 22007 -> E1M4_PORTAL
      exit;
    end;
  end
  else
  begin
    alldone := true;
    currentthinker := thinkercap.next;
    while Pointer(currentthinker) <> Pointer(@thinkercap) do
      begin
      if (@currentthinker._function.acp1 = @P_MobjThinker) and
         (Pmobj_t(currentthinker).info.doomednum = 22027) then // 22027 -> Egypt box
      begin
        if Pmobj_t(currentthinker).flags2_ex and MF2_EX_PUSHABLE <> 0 then
        begin
          alldone := false;
          break;
        end;
      end;
      currentthinker := currentthinker.next;
    end;
    if alldone then
    begin
      parm := P_SetMobjCustomParam(actor, 'ALLDONE', 0);
      S_StartSound(nil, 'WELLDONE');
      P_PlayerFaceMobj(@players[consoleplayer].mo, actor, TICRATE);
    end;
  end;
end;

type
  alignitem_t = record
    line: Pline_t;
    flip: Boolean;
  end;
  alignitem_p = ^alignitem_t;

//==============================================================================
//
// P_AutoAlignSector
//
//==============================================================================
procedure P_AutoAlignSector(const sec: Psector_t);
var
  A: array[0..$FF] of alignitem_t;
  pa: alignitem_p;
  num_al: integer;
  i: integer;
  s: Pside_t;
  idx: integer;
  rofs: fixed_t;
  flip: boolean;
  found: array[0..$FF] of boolean;
  match: boolean;
begin
  ZeroMemory(@A, SizeOf(A));
  ZeroMemory(@found, SizeOf(found));
  A[0].flip := sec <> sec.lines[0].frontsector;
  A[0].line := sec.lines[0];
  num_al := 1;
  pa := @A[0];
  found[0] := true;
  while num_al < sec.linecount do
  begin
    i := 1;
    match := false;
    while (i < sec.linecount) do
    begin
      if found[i] then
      begin
        inc(i);
        Continue;
      end;

      flip := sec <> sec.lines[i].frontsector;

      if ((pa.flip xor flip) and (sec.lines[i].v2 = pa.line.v2)) then
      begin
        Inc(pa);
        Inc(num_al);
        pa.flip := flip;
        pa.line := sec.lines[i];
        found[i] := True;
        match := true;
      end;

      if (not (pa.flip xor flip) and (sec.lines[i].v1 = pa.line.v2)) then
      begin
        Inc(pa);
        Inc(num_al);
        pa.flip := flip;
        pa.line := sec.lines[i];
        found[i] := True;
        match := true;
      end;

      inc(i);
    end;

    if not match then
    begin
      i := 0;
      while not found[i] do
        Inc(i);
      Inc(pa);
      Inc(num_al);
      pa.flip := false;
      pa.line := sec.lines[i];
      found[i] := True;
    end;
  end;

  rofs := 0;
  for i := 0 to num_al - 1 do
  begin
    idx := A[i].line.sidenum[0];
    if idx >= 0 then
    begin
      s := @sides[idx];
      if s.sector = sec then
        s.textureoffset := rofs
      else
        s.textureoffset := rofs;
    end;
    idx := A[i].line.sidenum[1];
    if idx >= 0 then
    begin
      s := @sides[idx];
      if s.sector = sec then
        s.textureoffset := -rofs
      else
        s.textureoffset := -rofs;
    end;
    rofs := rofs + P_Distance(A[i].line.dx, A[i].line.dy);
  end;
end;

//==============================================================================
//
// A_SectorAutoAlign
//
//==============================================================================
procedure A_SectorAutoAlign(const actor: Pmobj_t);
var
  sub: Psubsector_t;
begin
  sub := actor.subsector;
  P_AutoAlignSector(sub.sector);
end;

//==============================================================================
//
// A_E1M4
//
//==============================================================================
procedure A_E1M4(const actor: Pmobj_t);
var
  py: integer;
  pz: integer;
  p: Pplayer_t;
  manager_b: Pmobj_t;
  dist: fixed_t;
  parm: Pmobjcustomparam_t;
  sec1, sec2: Psector_t;
  i: integer;
begin
  p := @players[consoleplayer];
  if p.mo = nil then
    Exit;

  if p.cards[Ord(it_greencard)] then
  begin
    parm := P_GetMobjCustomParam(actor, 'SPAWNPORTALTICKER');
    if parm = nil then
    begin
      S_StartSound(nil, 'DSEARTHQ');
      parm := P_SetMobjCustomParam(actor, 'SPAWNPORTALTICKER', 5 * TICRATE);
    end
    else if parm.value > 0 then
    begin
      dec(parm.value);
      if parm.value = 3 * TICRATE then
      begin
        p.quaketics := 3 * TICRATE;
        P_PlayerFaceMobj(p, actor, 3 * TICRATE div 2)
      end
      else if parm.value < 64 then
      begin
        sec1 := nil;
        sec2 := nil;
        for i := 0 to numsectors - 1 do
        begin
          if sectors[i].tag = 3 then
            sec1 := @sectors[i]
          else if sectors[i].tag = 4 then
            sec2 := @sectors[i];
        end;
        if sec1 <> nil then
          sec1.floorheight := sec1.floorheight + 2 * FRACUNIT;
        if sec2 <> nil then
          sec2.floorheight := sec2.floorheight + 2 * FRACUNIT;
        if parm.value = 1 then
        begin
          S_StartSound(nil, 'WELLDONE');
          P_SpawnMobj(actor.x, actor.y, ONFLOORZ, Info_GetMobjNumForDoomNum(22005)); // 22005 -> E1M2_PORTAL
        end;
      end;
    end;
  end;

  py := p.mo.y div FRACUNIT;

  pz := p.mo.z div FRACUNIT;

  if pz < -240 then
    P_DamageMobj(p.mo, nil, nil, 10000);

  if (pz < 0) and (py > -3840) then
  begin
    journeymapinfo[4].fog_density := 50 - pz div 4;
    if journeymapinfo[4].fog_density <= 0 then
      journeymapinfo[4].fog_density := 1;
  end
  else
    journeymapinfo[4].fog_density := 50;

  manager_b := P_FindMobj(22018);
  if manager_b <> nil then
  begin
    dist := P_Distance(manager_b.x - p.mo.x, manager_b.y - p.mo.y) div FRACUNIT;
    if dist < 300 then
    begin
      journeymapinfo[4].view_xy := 192 - ((300 - dist) div 3);
      Exit;
    end;
  end;

  if py < -4700 then
    journeymapinfo[4].view_xy := 192
  else if py < -4400 then
    journeymapinfo[4].view_xy := 192 - round((py + 4700) / 3)
  else
    journeymapinfo[4].view_xy := 92;

end;

//==============================================================================
//
// A_Manager_Look_B
//
//==============================================================================
procedure A_Manager_Look_B(const actor: Pmobj_t);
begin
  if P_GetMobjCustomParamValue(actor, 'PAPYRUS') > 0 then
    exit;

  if players[consoleplayer].mo <> nil then
    actor.target := players[consoleplayer].mo;
  A_FaceTarget(actor);
end;

//==============================================================================
//
// A_Manager_B
//
//==============================================================================
procedure A_Manager_B(const actor: Pmobj_t);
var
  p: Pplayer_t;
  parm: Pmobjcustomparam_t;
  parm2: Pmobjcustomparam_t;
  mo: Pmobj_t;
  pmoney: integer;
  amoney: integer;
  i: integer;
begin
  parm := P_GetMobjCustomParam(actor, 'INTERACT_COUNT');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'INTERACT_COUNT', 0);

  parm2 := P_GetMobjCustomParam(actor, 'INTERACT_TICS');
  if parm2 = nil then
    parm2 := P_SetMobjCustomParam(actor, 'INTERACT_TICS', 0);

  p := @players[consoleplayer];
  if p.mo = nil then
    Exit;

  actor.target := p.mo;
  A_FaceTarget(actor);

  A_UnSetInteractive(actor);

  if parm2.value > 0 then
  begin
    Dec(parm2.value);
    if parm2.value = 0 then
    begin
      A_SetInteractive(actor);
      P_SetMobjState(actor, statenum_t(actor.info.seestate));
    end;
    exit;
  end;

  inc(parm.value);

  case parm.value of
    1:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_b/speech1'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_b/speech1'), 8 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 13 * TICRATE);
      end;
    2:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_b/speech2'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_b/speech2'), 8 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 13 * TICRATE);
      end;

    3:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_b/speech3'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_b/speech3'), 9 * TICRATE);
        parm2.value := 14 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 14 * TICRATE);
      end;

    4:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_b/speech4'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_b/speech4'), 6 * TICRATE);
        parm2.value := 12 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 12 * TICRATE);
      end;

    5:
      begin
        P_PlayerFaceMobj(p, actor, 3 * TICRATE);
        CM_ExecComicDialog(actor, CM_DialogID('manager_b/speech5'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_b/speech5'), 9 * TICRATE);
        parm2.value := 20 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 12 * TICRATE);

        for i := 0 to numsectors - 1 do
          if sectors[i].tag = 2 then
          begin
            sectors[i].floorheight := 0;
            break;
          end;

      end;

  else
    begin
      pmoney := P_GetMobjCustomParamValue(p.mo, 'PAPYRUS');
      amoney := P_GetMobjCustomParamValue(actor, 'PAPYRUS');
      if (pmoney >= 1) and (amoney = 0) then
      begin
        P_SetMobjCustomParam(p.mo, 'PAPYRUS', pmoney - 1);
        P_SetMobjCustomParam(actor, 'PAPYRUS', 1);
        S_StartSound(actor, 'DSGIVE');
        P_PlayerFaceMobj(p, actor, TICRATE div 2);

        // Spawn the green keycard
        mo := P_SpawnObjectToSpot(22030, 22031, p.mo, 64 * FRACUNIT);
        if mo <> nil then
          P_PlayerFaceMobj(p, mo, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_b/speech12'));
        parm2.value := 7 * TICRATE;
      end
      else if amoney > 0 then
      begin
        CM_ExecComicDialog(actor, CM_DialogID('manager_b/speech' + itoa((N_Random mod 3) + 6)));
        parm2.value := 7 * TICRATE;
      end
      else
      begin
        CM_ExecComicDialog(actor, CM_DialogID('manager_b/speech' + itoa((N_Random mod 3) + 9)));
        parm2.value := 7 * TICRATE;
      end;
    end;
  end;

end;

//==============================================================================
//
// A_RaptorChase
//
//==============================================================================
procedure A_RaptorChase(const actor: Pmobj_t);
var
  dest: Pmobj_t;
  an: angle_t;
  dist: integer;
  parm: Pmobjcustomparam_t;
begin
  if actor.target = nil then
    exit;

  dest := actor.target;

  dist := P_Distance(actor.x - dest.x, actor.y - dest.y);

  parm := P_GetMobjCustomParam(actor, 'RAPTORCHASE');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'RAPTORCHASE', 0);
  if parm.value = 0 then
    parm.value := 20;
  Dec(parm.value);

  if (dist > 256 * FRACUNIT) or (parm.value > 5) then
  begin
    A_Chase(actor);
    exit;
  end;

  if parm.value = 4 then
    A_AttackSound(actor, actor);

  A_FaceTarget(actor);
  if (actor.info.meleestate <> 0) and P_CheckMeleeRange(actor) then
  begin
    actor.momx := 0;
    actor.momy := 0;
    P_SetMobjState(actor, statenum_t(actor.info.meleestate));
  end
  else
  begin
    an := actor.angle shr ANGLETOFINESHIFT;
    actor.momx := FixedMul(12 * FRACUNIT, finecosine[an]);
    actor.momy := FixedMul(12 * FRACUNIT, finesine[an]);
  end;

end;

const
    NUM_E1M5_OFFSETS = 15;

type
  effect_e1m5_t = record
    fmin, fmax: fixed_t;
    phase: float;
    interval: integer;
  end;
  effect_e1m5_p = ^effect_e1m5_t;

const
  E1M5_OFFSETS: array[0..NUM_E1M5_OFFSETS - 1] of effect_e1m5_t = (
    (fmin: -10 * FRACUNIT; fmax: 12 * FRACUNIT; phase: 0.3; interval: 40),
    (fmin: -20 * FRACUNIT; fmax: 15 * FRACUNIT; phase: 0.7; interval: 60),
    (fmin: -22 * FRACUNIT; fmax: 10 * FRACUNIT; phase: 1.0; interval: 57),
    (fmin: -24 * FRACUNIT; fmax: 18 * FRACUNIT; phase: 1.3; interval: 32),
    (fmin: -20 * FRACUNIT; fmax: 16 * FRACUNIT; phase: 1.6; interval: 60),
    (fmin: -10 * FRACUNIT; fmax: 12 * FRACUNIT; phase: 1.9; interval: 50),
    (fmin: -20 * FRACUNIT; fmax: 14 * FRACUNIT; phase: 2.2; interval: 76),
    (fmin: -19 * FRACUNIT; fmax: 16 * FRACUNIT; phase: 2.6; interval: 47),
    (fmin: -15 * FRACUNIT; fmax: 13 * FRACUNIT; phase: 2.9; interval: 45),
    (fmin:  -5 * FRACUNIT; fmax: 14 * FRACUNIT; phase: 3.2; interval: 34),
    (fmin:  -8 * FRACUNIT; fmax: 18 * FRACUNIT; phase: 3.3; interval: 51),
    (fmin: -10 * FRACUNIT; fmax: 15 * FRACUNIT; phase: 3.9; interval: 37),
    (fmin: -15 * FRACUNIT; fmax: 12 * FRACUNIT; phase: 4.3; interval: 42),
    (fmin:  -8 * FRACUNIT; fmax: 10 * FRACUNIT; phase: 3.9; interval: 40),
    (fmin: -12 * FRACUNIT; fmax:  9 * FRACUNIT; phase: 4.3; interval: 36)
  );

//==============================================================================
//
// A_E1M5
//
//==============================================================================
procedure A_E1M5(const actor: Pmobj_t);
var
  dist: fixed_t;
  p: Pplayer_t;
  i: integer;
  scnt: integer;
  parm: Pmobjcustomparam_t;
  effect: effect_e1m5_p;
  sec: Psector_t;
  skillf: float;
  alldone: boolean;
  currentthinker: Pthinker_t;
  mo: Pmobj_t;
  manager_c: Pmobj_t;
  sec1, sec2, sec3, sec4: Psector_t;
begin
  p := @players[consoleplayer];
  if p.mo = nil then
    exit;

  manager_c := P_FindMobj(22040);
  if manager_c <> nil then
  begin
    dist := P_Distance(manager_c.x - p.mo.x, manager_c.y - p.mo.y) div FRACUNIT;
    if dist < 128 then
      journeymapinfo[5].view_xy := 92 - (128 - dist) div 8
    else
      journeymapinfo[5].view_xy := 92;
  end;

  if p.cards[Ord(it_bluecard)] then
  begin
    parm := P_GetMobjCustomParam(actor, 'SPAWNPORTALTICKER');
    if parm = nil then
    begin
      S_StartSound(nil, 'DSEARTHQ');
      parm := P_SetMobjCustomParam(actor, 'SPAWNPORTALTICKER', 6 * TICRATE);
    end
    else if parm.value > 0 then
    begin
      dec(parm.value);
      if parm.value = 5 * TICRATE then
      begin
        p.quaketics := 5 * TICRATE;
        P_PlayerFaceMobj(p, P_FindMobj(22005), 3 * TICRATE div 2)
      end
      else if parm.value < 4 * TICRATE then
      begin
        sec1 := nil;
        sec2 := nil;
        sec3 := nil;
        sec4 := nil;
        for i := 0 to numsectors - 1 do
        begin
          if sectors[i].tag = 8 then
            sec1 := @sectors[i]
          else if sectors[i].tag = 9 then
            sec2 := @sectors[i]
          else if sectors[i].tag = 10 then
            sec3 := @sectors[i]
          else if sectors[i].tag = 11 then
            sec4 := @sectors[i]
        end;
        if sec1 <> nil then
        begin
          sec1.ceilingheight := sec1.ceilingheight + 2 * FRACUNIT;
          if sec1.ceilingheight > 72 * FRACUNIT then
            sec1.ceilingheight := 72 * FRACUNIT;
        end;

        if sec2 <> nil then
        begin
          sec2.ceilingheight := sec2.ceilingheight + 3 * FRACUNIT div 2;
          if sec2.ceilingheight > 72 * FRACUNIT then
            sec2.ceilingheight := 72 * FRACUNIT;
        end;

        if sec3 <> nil then
        begin
          sec3.ceilingheight := sec3.ceilingheight + FRACUNIT;
          if sec3.ceilingheight > 72 * FRACUNIT then
            sec3.ceilingheight := 72 * FRACUNIT;
        end;

        if sec4 <> nil then
        begin
          sec4.ceilingheight := sec4.ceilingheight + FRACUNIT div 2;
          if sec4.ceilingheight > 72 * FRACUNIT then
            sec4.ceilingheight := 72 * FRACUNIT;
        end;

        if parm.value = 1 then
          S_StartSound(nil, 'WELLDONE');
      end;
    end;
  end;

  parm := P_GetMobjCustomParam(actor, 'FLOAT_SECTORS');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'FLOAT_SECTORS', 0);

  dist := P_Distance(actor.x - p.mo.x, actor.y - p.mo.y);
  if dist < 640 * FRACUNIT then
  begin
    if parm.value <> 1 then
    begin
      parm := P_SetMobjCustomParam(actor, 'FLOAT_SECTORS', 1);
      for i := 0 to numsectors - 1 do
      begin
        if sectors[i].tag = 1 then
          sectors[i].floorheight := -256 * FRACUNIT
      end;
    end;

    journeymapinfo[5].fog_density := 20 + Round(32 - dist / FRACUNIT / 20);
    Psubsector_t(actor.subsector).sector.lightlevel := Round(32 - dist / FRACUNIT / 20);
  end
  else
  begin
    journeymapinfo[5].fog_density := 20;
    Psubsector_t(actor.subsector).sector.lightlevel := 0;
  end;

  if Psubsector_t(p.mo.subsector).sector.tag = 1 then
    if p.mo.z < -200 * FRACUNIT then
      P_DamageMobj(p.mo, nil, nil, 10000);

  if parm.value = 1 then
  begin
    scnt := 0;
    skillf := 1 / (4 - Ord(gameskill));
    for i := 0 to numsectors - 1 do
    begin
      if sectors[i].tag = 3 then
      begin
        effect := @E1M5_OFFSETS[scnt mod NUM_E1M5_OFFSETS];
        Inc(scnt);
        sec := @sectors[i];
        sec.floorheight := Round(effect.fmin + (effect.fmax - effect.fmin) * Sin(effect.phase + leveltime / effect.interval) * skillf);
        P_ChangeSector(sec, false);
      end;
    end;
  end;

  alldone := true;
  currentthinker := thinkercap.next;
  while Pointer(currentthinker) <> Pointer(@thinkercap) do
  begin
    if (@currentthinker._function.acp1 = @P_MobjThinker) and
       (Pmobj_t(currentthinker).info.doomednum = 22039) then
    begin
      if Pmobj_t(currentthinker).flags2_ex and MF2_EX_PUSHABLE <> 0 then
      begin
        alldone := false;
        break;
      end;
    end;
    currentthinker := currentthinker.next;
  end;

  if alldone then
  begin
    parm := P_GetMobjCustomParam(actor, 'MAKESECTORS');
    if parm = nil then
    begin
      parm := P_SetMobjCustomParam(actor, 'MAKESECTORS', 10 * TICRATE + 1);
    end
    else if parm.value > 0 then
    begin
      dec(parm.value);
      if parm.value = 10 * TICRATE then
      begin
        P_PlayerFaceMobj(p, actor, 3 * TICRATE div 2);
        S_StartSound(nil, 'DSEARTHQ');
      end
      else if parm.value = 9 * TICRATE then
      begin
        p.quaketics := 3 * TICRATE div 2;
        P_PlayerFaceMobj(p, actor, 3 * TICRATE div 2);
      end
      else if (parm.value < 9 * TICRATE) and (parm.value > 9 * TICRATE - 66) then
      begin
        for i := 0 to numsectors - 1 do
        begin
          if sectors[i].tag = 4 then
            if sectors[i].floorheight > 0 then
              sectors[i].floorheight := sectors[i].floorheight - 2 * FRACUNIT;
        end;
      end
      else
      begin
        if parm.value = 0 then
        begin
          mo := P_SpawnObjectToSpot(22042, 22009, actor, 64 * FRACUNIT);
          if mo <> nil then
            P_PlayerFaceMobj(p, mo, TICRATE div 2);
        end;

        if parm.value = 5 * TICRATE then
        begin
          P_PlayerFaceMobj(p, P_FindMobj(22041), 3 * TICRATE div 2);
          S_StartSound(nil, 'DSEARTHQ');
        end
        else if parm.value = 4 * TICRATE then
        begin
          p.quaketics := 2 * TICRATE;
        end;

        for i := 0 to numsectors - 1 do
        begin
          if sectors[i].tag = 3 then
          begin
            if sectors[i].floorheight < 0 then
              sectors[i].floorheight := sectors[i].floorheight + 2 * FRACUNIT + 256 * N_Random;
          end
          else if parm.value < 3 * TICRATE then
          begin
            if sectors[i].tag = 6 then
              if sectors[i].floorheight < 0 then
                sectors[i].floorheight := sectors[i].floorheight + 2 * FRACUNIT;
          end;
        end;
      end;
    end;
  end;

end;

//==============================================================================
//
// A_Manager_C
//
//==============================================================================
procedure A_Manager_C(const actor: Pmobj_t);
var
  p: Pplayer_t;
  parm: Pmobjcustomparam_t;
  parm2: Pmobjcustomparam_t;
  mo: Pmobj_t;
  p_astro: integer;
  a_astro: integer;
  i: integer;
  cp_firstdialogend: Pmobjcustomparam_t;
begin
  parm := P_GetMobjCustomParam(actor, 'INTERACT_COUNT');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'INTERACT_COUNT', 0);

  parm2 := P_GetMobjCustomParam(actor, 'INTERACT_TICS');
  if parm2 = nil then
    parm2 := P_SetMobjCustomParam(actor, 'INTERACT_TICS', 0);

  cp_firstdialogend := P_GetMobjCustomParam(actor, 'FIRSTDIALOGEND');
  if cp_firstdialogend = nil then
    cp_firstdialogend := P_SetMobjCustomParam(actor, 'FIRSTDIALOGEND', 0);

  p := @players[consoleplayer];
  if p.mo = nil then
    Exit;

  actor.target := p.mo;
  A_FaceTarget(actor);

  A_UnSetInteractive(actor);

  if parm2.value > 0 then
  begin
    Dec(parm2.value);
    if parm2.value = 0 then
    begin
      A_SetInteractive(actor);
      P_SetMobjState(actor, statenum_t(actor.info.seestate));
    end;
    exit;
  end;

  inc(parm.value);

  case parm.value of
    1:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech1'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_c/speech1'), 6 * TICRATE);
        parm2.value := 10 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 10 * TICRATE);
      end;
    2:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech2'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_c/speech2'), 8 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 13 * TICRATE);
      end;

    3:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech3'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_c/speech3'), 8 * TICRATE);
        parm2.value := 12 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 12 * TICRATE);
      end;

    4:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech4'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_c/speech4'), 8 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 13 * TICRATE);
      end;

    5:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech5'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_c/speech5'), 9 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 13 * TICRATE);
      end;

    6:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech6'));
        parm2.value := 8 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 13 * TICRATE);
      end;

    7:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech7'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_c/speech7'), 9 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 9 * TICRATE);
        for i := 0 to numsectors - 1 do
          if sectors[i].tag = 2 then
          begin
            sectors[i].floorheight := 16 * FRACUNIT;
            break;
          end;
        cp_firstdialogend.value := leveltime;
      end;

  else
    begin
      p_astro := P_GetMobjCustomParamValue(p.mo, 'ASTROLABE');
      a_astro := P_GetMobjCustomParamValue(actor, 'ASTROLABE');
      if (p_astro >= 1) and (a_astro = 0) then
      begin
        P_SetMobjCustomParam(p.mo, 'ASTROLABE', p_astro - 1);
        P_SetMobjCustomParam(actor, 'ASTROLABE', 1);
        S_StartSound(actor, 'DSGIVE');
        P_PlayerFaceMobj(p, actor, TICRATE div 2);

        // Spawn the blue keycard (dn=5)
        mo := P_SpawnObjectToSpot(22030, 5, p.mo, 64 * FRACUNIT);
        if mo <> nil then
          P_PlayerFaceMobj(p, mo, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech14'));
        parm2.value := 7 * TICRATE;
      end
      else if a_astro > 0 then
      begin
        CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech' + itoa((N_Random mod 3) + 8)));
        parm2.value := 7 * TICRATE;
      end
      else
      begin
        if leveltime - cp_firstdialogend.value > 60 * TICRATE then
        begin
          if N_Random > 128 then
            CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech' + itoa((N_Random mod 3) + 11)))
          else
            CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech15'))
        end
        else
          CM_ExecComicDialog(actor, CM_DialogID('manager_c/speech' + itoa((N_Random mod 3) + 11)));
        parm2.value := 7 * TICRATE;
      end;
    end;
  end;
end;

//==============================================================================
//
// A_FreakA_1
//
//==============================================================================
procedure A_FreakA_1(const actor: Pmobj_t);
var
  p: Pplayer_t;
  mo: Pmobj_t;
  parm: Pmobjcustomparam_t;
  parm2: Pmobjcustomparam_t;
  dist: fixed_t;
begin
  p := @players[consoleplayer];
  mo := p.mo;
  if mo = nil then
    exit;

  parm := P_GetMobjCustomParam(actor, 'FREAK_A');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'FREAK_A', 0);

  parm2 := P_GetMobjCustomParam(actor, 'PLAYERNEARFREAK');
  if parm2 = nil then
    parm2 := P_SetMobjCustomParam(actor, 'PLAYERNEARFREAK', 0);

  if parm.value = 0 then
  begin
    if Psubsector_t(mo.subsector).sector.tag = 7 then
    begin
      parm.value := 3 * TICRATE;
      actor.momx := 15 * FRACUNIT;
      P_KeepPlayerNearMe(actor, p, 512 * FRACUNIT, 12 * TICRATE);
      parm2.value := 512 * FRACUNIT;
    end;
    Exit;
  end;

  if parm.value = 1 then
    exit;

  dec(parm.value);
  actor.target := mo;
  A_FaceTarget(actor);

{ if parm.value < 3 * TICRATE - 7 then
    P_PlayerFaceMobj(p, actor, 2);}

  case parm.value of
    3 * TICRATE - 2:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE - 15);
        CM_ExecComicDialog(actor, CM_DialogID('freak_a/dialog1'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/freak_a/dialog1'), 3 * TICRATE + 10);
      end;
     1 * TICRATE:
      begin
        actor.momx := 0;
        CM_ExecComicDialog(actor, CM_DialogID('freak_a/dialog2'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/freak_a/dialog2'), 4 * TICRATE);
      end;
     1:
      begin
        P_DamageMobj(actor, nil, nil, 10000);
      end;
    else
    begin
      if parm.value < 2 * TICRATE then
      begin
        dist := P_Distance(actor.x - p.mo.x, actor.y - p.mo.y);
        if dist < parm2.value then
        begin
          parm2.value := dist;
          if dist < 64 * FRACUNIT then
            dist := 64 * FRACUNIT;
          P_KeepPlayerNearMe(actor, p, dist, parm.value * 3);
        end;
      end;
    end;
  end;
end;

//==============================================================================
//
// A_FreakA_2
//
//==============================================================================
procedure A_FreakA_2(const actor: Pmobj_t);
begin
  S_StartSound(actor, Ord(sfx_telept));
  P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_TFOG));
end;

//==============================================================================
//
// A_FreakA_3
//
//==============================================================================
procedure A_FreakA_3(const actor: Pmobj_t);
begin
  P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_TFOG));
end;

//==============================================================================
//
// A_SpawnWaterSplash
//
//==============================================================================
procedure A_SpawnWaterSplash(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, ONFLOORZ, Ord(MT_SPLASH));
  mo.momx := (P_Random - P_Random) * 256;
  mo.momy := (P_Random - P_Random) * 256;
  mo.momz := 3 * FRACUNIT + (P_Random * 256);
end;

var
  waterbubble_mt: integer = -1;

//==============================================================================
//
// J_SpawnWaterBubble
//
//==============================================================================
function J_SpawnWaterBubble(const x, y, z: fixed_t): Pmobj_t;
begin
  if waterbubble_mt < 0 then
    waterbubble_mt := Info_GetMobjNumForDoomNum(22047);

  result := P_SpawnMobj(x, y, z, waterbubble_mt);
  result.momz := 3 * FRACUNIT;
  result.momx := FRACUNIT div 2 - 256 * N_Random;
  result.momy := FRACUNIT div 2 - 256 * N_Random;
  result.scale := FRACUNIT div 20 + 16 * N_Random;
end;

var
  waterbubble_mt2: integer = -1;

//==============================================================================
//
// J_SpawnWaterBubble2
//
//==============================================================================
function J_SpawnWaterBubble2(const x, y, z: fixed_t): Pmobj_t;
begin
  if waterbubble_mt2 < 0 then
    waterbubble_mt2 := Info_GetMobjNumForDoomNum(22048);

  result := P_SpawnMobj(x, y, z, waterbubble_mt2);
  result.momz := 3 * FRACUNIT;
  result.momx := FRACUNIT div 2 - 256 * N_Random;
  result.momy := FRACUNIT div 2 - 256 * N_Random;
  result.scale := FRACUNIT + 512 * N_Random;
end;

//==============================================================================
//
// J_SectorFromTag
//
//==============================================================================
function J_SectorFromTag(const tag: smallint): Psector_t;
var
  i: integer;
begin
  for i := 0 to numsectors - 1 do
    if sectors[i].tag = tag then
    begin
      Result := @sectors[i];
      exit;
    end;
  Result := nil;
end;

//==============================================================================
//
// A_E1M6
//
//==============================================================================
procedure A_E1M6(const actor: Pmobj_t);
var
  p_as_trigger: Pmobjcustomparam_t;
  p_as: Pmobjcustomparam_t;
  p_as_countdown: Pmobjcustomparam_t;
  p_diving: Pmobjcustomparam_t;
  p_swimming: Pmobjcustomparam_t;
  p_swimtics: Pmobjcustomparam_t;
  p: Pplayer_t;
  wb: Pmobj_t;
  currentthinker: Pthinker_t;
  ss: Psubsector_t;
  sec: Psector_t;
  floorx: fixed_t;
  x, y, z: fixed_t;
  portalmo: Pmobj_t;
  sl: integer;

  procedure DoSectorEffect(const tag: SmallInt; const height: fixed_t; const brightness: smallint);
  var
    sec: Psector_t;
    sec2: Psector_t;
  begin
    sec := J_SectorFromTag(tag);
    if sec = nil then
      Exit;
    sec2 := J_SectorFromTag(10);
    if sec2 = nil then
      Exit;

    sec.floorheight := height;
    sec.lightlevel := brightness;
    sec.floorpic := sec2.floorpic;
  end;

begin
  p := @players[consoleplayer];
  if p.mo = nil then
    exit;

  p.breathtype := 0;

  journeymapinfo[6].drawsky := p.mo.z > - 64 * FRACUNIT;

  if leveltime = 4 * TICRATE then
    CM_ExecComicDialog(p.mo, CM_DialogID('hero/bermuda'));

  if Psubsector_t(p.mo.subsector).sector.tag = 12 then
    if p.mo.z < 64 * FRACUNIT then
      P_DamageMobj(p.mo, nil, nil, 10000);

  p_as_trigger := P_GetMobjCustomParam(actor, 'ASTROLABE_TRIGGER');
  if p_as_trigger = nil then
    p_as_trigger := P_SetMobjCustomParam(actor, 'ASTROLABE_TRIGGER', 0);

  if p_as_trigger.value = 0 then
  begin
    p_as := P_GetMobjCustomParam(p.mo, 'ASTROLABE');
    if p_as <> nil then
      if p_as.value = 1 then
      begin
        p_as_trigger.value := 1;
        p_as_countdown := P_SetMobjCustomParam(actor, 'ASTROLABE_COUNTDOWN', 10 * TICRATE);
      end;
  end;

  p_as_countdown := P_GetMobjCustomParam(actor, 'ASTROLABE_COUNTDOWN');
  if p_as_countdown = nil then
    p_as_countdown := P_SetMobjCustomParam(actor, 'ASTROLABE_COUNTDOWN', 0);

  if p_as_countdown.value > 0 then
  begin
    if p_as_countdown.value < 5 * FRACUNIT then
    begin
      sec := J_SectorFromTag(11);
      sec.floorheight := sec.floorheight + FRACUNIT div 4;
      if sec.floorheight > -448 * FRACUNIT then
        sec.floorheight := -448 * FRACUNIT;
    end;
    case p_as_countdown.value of
     10 * TICRATE - 1:
        S_StartSound(nil, 'DSEARTHQ');
      9 * TICRATE:
        begin
          P_PlayerFaceMobj(p, actor, TICRATE);
          p.quaketics := 5 * TICRATE;
        end;
     17 * TICRATE div 2:
        DoSectorEffect(1, -1024 * FRACUNIT, 255);
     16 * TICRATE div 2:
        DoSectorEffect(2, -1024 * FRACUNIT, 255);
     15 * TICRATE div 2:
        DoSectorEffect(3, -1024 * FRACUNIT, 255);
     14 * TICRATE div 2:
        DoSectorEffect(4, -1024 * FRACUNIT, 255);
     13 * TICRATE div 2:
        DoSectorEffect(5, -1024 * FRACUNIT, 255);
     12 * TICRATE div 2:
        DoSectorEffect(6, -1024 * FRACUNIT, 255);
     11 * TICRATE div 2:
        DoSectorEffect(7, -1024 * FRACUNIT, 255);
     10 * TICRATE div 2:
        DoSectorEffect(8, -1024 * FRACUNIT, 255);
      9 * TICRATE div 2:
        DoSectorEffect(9, -1024 * FRACUNIT, 255);
      6 * TICRATE div 2:
        begin
          portalmo := P_SpawnMobj(actor.x, actor.y, -448 * FRACUNIT, Info_GetMobjNumForDoomNum(22008)); // 22008 -> E1M5_PORTAL
          portalmo.flags := portalmo.flags or MF_NOGRAVITY;
        end;
    end;
    Dec(p_as_countdown.value);
  end;

  if (p_as_trigger.value = 1) and (p_as_countdown.value < 7 * TICRATE) then
  begin
    // Spawn bubbles
    x := actor.x - 64 * FRACUNIT + (N_Random * FRACUNIT) div 2;
    y := actor.y - 400 * FRACUNIT + (7 * N_Random * FRACUNIT) div 2;
    if P_Distance(actor.x - x, actor.y - y) < 128 * FRACUNIT then
      y := y + 128 * FRACUNIT;

    ss := R_PointInSubsector(x, y);
    floorx := ss.sector.floorheight;
    if floorx < -512 * FRACUNIT then
      z := floorx + 2 * N_Random * FRACUNIT
    else
      z := floorx + N_Random * FRACUNIT div 2;
    wb := J_SpawnWaterBubble2(x, y, z);
    wb.momz := wb.momz + 128 * N_Random;
  end;

  if p.mo.z < 16 * FRACUNIT then
  begin
    // Adjust waterbubbles
    currentthinker := thinkercap.next;
    while Pointer(currentthinker) <> Pointer(@thinkercap) do
    begin
      if (@currentthinker._function.acp1 = @P_MobjThinker) then
      begin
        sl := R_E1M6Sealevel;
        if Pmobj_t(currentthinker).info.doomednum = 22047 then
        begin
          wb := Pmobj_t(currentthinker);
          if wb.z > 0 then
            wb.z := 0;
          if (viewz < sl) or (wb.z < sl - 3 * FRACUNIT) then
            wb.flags2_ex := wb.flags2_ex and not MF2_EX_DONTDRAW
          else
            wb.flags2_ex := wb.flags2_ex or MF2_EX_DONTDRAW;
        end
        else if Pmobj_t(currentthinker).info.doomednum = 22048 then
        begin
          wb := Pmobj_t(currentthinker);
          if wb.z > - 256 * FRACUNIT then
            P_RemoveMobj(wb)
          else
          begin
            if (viewz < sl) or (wb.z < sl - 3 * FRACUNIT) then
              wb.flags2_ex := wb.flags2_ex and not MF2_EX_DONTDRAW
            else
              wb.flags2_ex := wb.flags2_ex or MF2_EX_DONTDRAW;
          end;
        end;
      end;
      currentthinker := currentthinker.next;
    end;
  end;

  if p.mo.z > - 16 * FRACUNIT then
    journeymapinfo[6].view_z := 0
  else if p.mo.z < - 80 * FRACUNIT then
    journeymapinfo[6].view_z := -32
  else
    journeymapinfo[6].view_z := p.mo.z div (FRACUNIT * 2)  + 8;

  p_swimming := P_GetMobjCustomParam(p.mo, 'SWIMMING');
  if p_swimming = nil then
    p_swimming := P_SetMobjCustomParam(p.mo, 'SWIMMING', 0);
  p_swimming.value := 0;

  p_diving := P_GetMobjCustomParam(p.mo, 'E1M6DIVING');
  if p_diving = nil then
    p_diving := P_SetMobjCustomParam(p.mo, 'E1M6DIVING', 0);

  p_swimtics := P_GetMobjCustomParam(p.mo, 'E1M6SWIMMTICS');
  if p_swimtics = nil then
    p_swimtics := P_SetMobjCustomParam(p.mo, 'E1M6SWIMMTICS', 0);

  if p_diving.value = 0 then
  begin
    p.minimumz := 0;
    if P_GetThingFloorType(p.mo) = FLOOR_WATER then
    begin
      p.thrustmodifier := 0.4;
      if p.mo.y < -4624 * FRACUNIT then
        p.mo.y := -4624 * FRACUNIT;
      if p.mo.x < -4664 * FRACUNIT then
        p.mo.x := -4664 * FRACUNIT
      else if p.mo.x > -3136 * FRACUNIT then
        p.mo.x := -3136 * FRACUNIT;
      inc(p_swimtics.value);
    end
    else
      p.thrustmodifier := 1.0;
  end
  else
  begin
    p.minimumz := -32000 * FRACUNIT;
    p.thrustmodifier := 1.0;
  end;

  if p_swimtics.value > 10 * TICRATE + N_Random then
  begin
    p_swimtics.value := 0;
    CM_ExecComicDialog(p.mo, CM_DialogID('hero/needdiving'));
  end;

  if viewz < R_E1M6Sealevel then
  begin
    journeymapinfo[6].fog_r := 0.1;
    journeymapinfo[6].fog_g := 0.1;
    journeymapinfo[6].fog_b := 0.9;
    journeymapinfo[6].fog_density := 150;
  end
  else
  begin
    journeymapinfo[6].fog_r := 0.1;
    journeymapinfo[6].fog_g := 0.1;
    journeymapinfo[6].fog_b := 0.1;
    journeymapinfo[6].fog_density := 70;
  end;

  if p.mo.z < R_E1M6Sealevel - PVIEWHEIGHT then
  begin
    if p.cheats and CF_LOWGRAVITY = 0 then
    begin
      p.lowgravtics := TICRATE div 2;
      p.cheats := p.cheats or CF_LOWGRAVITY;
    end;
    p.cheats := p.cheats or CF_UNDERWATER;
    p.underwatertics := 3;

    if (p.mo.z < R_E1M6Sealevel + 63 * FRACUNIT) and (leveltime > TICRATE) then
    begin
      p_swimming.value := 1;
      p.breathtype := 1;
      S_StopSound(p.mo);
      P_SaveRandom;
      if N_Random < 80 then
      begin
        wb := J_SpawnWaterBubble(p.mo.x, p.mo.y, p.mo.z + p.mo.height);
        if N_Random < 80 then
        begin
          wb := J_SpawnWaterBubble(p.mo.x, p.mo.y, p.mo.z + p.mo.height);
          wb.momz := wb.momz + 128 * N_Random;
        end;
        if N_Random < 64 then
          S_StartSound(wb, 'wbubble' + itoa(leveltime mod 9));
      end;
      P_RestoreRandom;
    end;

    p.mo.flags2_ex := p.mo.flags2_ex or MF2_EX_RENDERROTATE;
    if p.mo.z < Psubsector_t(p.mo.subsector).sector.floorheight + 16 * FRACUNIT then
    begin
      p.mo.anglex := p.mo.anglex - 1.0;
      if p.mo.anglex < 0.0 then
        p.mo.anglex := 0.0;
      p.mo.radius := p.mo.radius - FRACUNIT;
      if p.mo.radius < p.mo.info.radius then
        p.mo.radius := p.mo.info.radius;
    end
    else
    begin
      p.mo.anglex := p.mo.anglex + 1.0;
      if p.mo.anglex > 45.0 then
        p.mo.anglex := 45.0;
      p.mo.radius := p.mo.radius + FRACUNIT;
      if p.mo.radius > 2 * p.mo.info.radius then
        p.mo.radius := 2 * p.mo.info.radius;
    end;
    p.mo.angley := 0.0;
    p.mo.anglez := 0.0;
  end
  else
  begin
    p.cheats := p.cheats and not CF_LOWGRAVITY;
    p.cheats := p.cheats and not CF_UNDERWATER;
    p.mo.flags2_ex := p.mo.flags2_ex and not MF2_EX_RENDERROTATE;
    p.mo.anglex := p.mo.anglex - 1.0;
    if p.mo.anglex < 0.0 then
      p.mo.anglex := 0.0;
    p.mo.angley := 0.0;
    p.mo.anglez := 0.0;
    p.mo.radius := p.mo.radius - FRACUNIT;
    if p.mo.radius < p.mo.info.radius then
      p.mo.radius := p.mo.info.radius;
  end;

end;

//==============================================================================
//
// P_SpawnMobjInSectorUnique
//
//==============================================================================
function P_SpawnMobjInSectorUnique(const sec: Psector_t; const x, y, z: integer; const typedn: integer): Pmobj_t;
var
  mo: Pmobj_t;
begin
  result := nil;
  mo := sec.thinglist;
  while mo <> nil do
  begin
    if mo.info.doomednum = typedn then
    begin
      result := nil;
      exit;
    end;
    mo := mo.snext;
  end;

  result := P_SpawnMobj(x, y, z, Info_GetMobjNumForDoomNum(typedn));
end;

//==============================================================================
//
// A_E1M7
//
//==============================================================================
procedure A_E1M7(const actor: Pmobj_t);
var
  manager_d: Pmobj_t;
  dist: fixed_t;
  p: Pplayer_t;
  raptor: Pmobj_t;
  sec1, sec2, sec3, sec4: Psector_t;
  ma_mo_a1: Pmobj_t;
  ma_mo_a2: Pmobj_t;
  ma_mo_b1: Pmobj_t;
  ma_mo_b2: Pmobj_t;
  ma_mo_c1: Pmobj_t;
  ma_mo_c2: Pmobj_t;
  b1, b2, b3: Boolean;
  i: integer;
  parm: Pmobjcustomparam_t;
  parm2: Pmobjcustomparam_t;
  currentthinker: Pthinker_t;

  function MakeMajongCouple(var mo1, mo2: Pmobj_t): boolean;
  var
    parm_a1: Pmobjcustomparam_t;
    parm_a2: Pmobjcustomparam_t;
    mo: Pmobj_t;
  begin
    if (mo1 = nil) and (mo2 = nil) then
    begin
      result := true; // Already done
      exit;
    end;

    if (mo1 <> nil) and (mo2 <> nil) then
    begin
      parm_a1 := P_GetMobjCustomParam(mo1, 'MAJONG');
      if parm_a1 = nil then
        parm_a1 := P_SetMobjCustomParam(mo1, 'MAJONG', 0);
      parm_a2 := P_GetMobjCustomParam(mo2, 'MAJONG');
      if parm_a2 = nil then
        parm_a2 := P_SetMobjCustomParam(mo2, 'MAJONG', 0);

      if (parm_a1.value = 1) and (parm_a2.value = 1) then
      begin
        P_RemoveMobj(mo1);
        P_RemoveMobj(mo2);
        mo := P_SpawnSoundOrigin(p.mo.x, p.mo.y, p.mo.z);
        S_StartSound(mo, 'egbox001');
        result := True;
        exit;
      end;

      if parm_a1.value = 1 then
        if (leveltime mod TICRATE) > TICRATE div 2 then
          A_HideThing(mo1)
        else
          A_UnHideThing(mo1);

      if parm_a2.value = 1 then
        if (leveltime mod TICRATE) > TICRATE div 2 then
          A_HideThing(mo2)
        else
          A_UnHideThing(mo2);
    end;
    result := false;
  end;

begin
  p := @players[consoleplayer];
  if p.mo = nil then
    Exit;

  if p.mo.z < -450 * FRACUNIT then
  begin
    P_DamageMobj(p.mo, nil, nil, 10000);
    exit;
  end;

  if p.mo.y > - 500 * FRACUNIT then
  begin
    manager_d := P_FindMobj(22055);
    if manager_d <> nil then
    begin
      dist := P_Distance(manager_d.x - p.mo.x, manager_d.y - p.mo.y) div FRACUNIT;
      if dist < 128 then
        journeymapinfo[7].view_xy := 96 - (128 - dist) div 8
      else
        journeymapinfo[7].view_xy := 96;
    end;

    if p.mo.x > - 6800 * FRACUNIT then
    begin
      if p.weaponowned[Ord(wp_chaingun)] <> 0 then
      begin
        p.weaponowned[Ord(wp_pistol)] := 0;
        sec1 := nil;
        sec2 := nil;
        sec3 := nil;
        for i := 0 to numsectors - 1 do
        begin
          if sectors[i].tag = 1 then
            sec1 := @sectors[i]
          else if sectors[i].tag = 2 then
            sec2 := @sectors[i]
          else if sectors[i].tag = 3 then
            sec3 := @sectors[i]
        end;
        if sec1 <> nil then
          sec1.floorheight := -24 * FRACUNIT;
        if sec2 <> nil then
          sec2.floorheight := -16 * FRACUNIT;
        if sec3 <> nil then
          sec3.floorheight := 0;
      end;
    end;

  end
  else
    journeymapinfo[7].view_xy := 96;

  // The puzzle has been solved
  parm2 := P_GetMobjCustomParam(actor, 'PUZZLE_OK');
  if parm2 = nil then
    parm2 := P_SetMobjCustomParam(actor, 'PUZZLE_OK', 0);

  // majong puzzle
  if (parm2.value = 0) and (p.mo.y < -3500 * FRACUNIT) then
  begin

    // Locate majong stones
    ma_mo_a1 := nil;
    ma_mo_a2 := nil;
    ma_mo_b1 := nil;
    ma_mo_b2 := nil;
    ma_mo_c1 := nil;
    ma_mo_c2 := nil;
    currentthinker := thinkercap.next;
    while Pointer(currentthinker) <> Pointer(@thinkercap) do
    begin
      if (@currentthinker._function.acp1 = @P_MobjThinker) then
      begin
        if Pmobj_t(currentthinker).info.doomednum = 22060 then
        begin
          if ma_mo_a1 = nil then
            ma_mo_a1 := Pmobj_t(currentthinker)
          else
            ma_mo_a2 := Pmobj_t(currentthinker);
        end
        else if Pmobj_t(currentthinker).info.doomednum = 22061 then
        begin
          if ma_mo_b1 = nil then
            ma_mo_b1 := Pmobj_t(currentthinker)
          else
            ma_mo_b2 := Pmobj_t(currentthinker);
        end
        else if Pmobj_t(currentthinker).info.doomednum = 22062 then
        begin
          if ma_mo_c1 = nil then
            ma_mo_c1 := Pmobj_t(currentthinker)
          else
            ma_mo_c2 := Pmobj_t(currentthinker);
        end;
      end;
      currentthinker := currentthinker.next;
    end;

    b1 := MakeMajongCouple(ma_mo_a1, ma_mo_a2);
    b2 := MakeMajongCouple(ma_mo_b1, ma_mo_b2);
    b3 := MakeMajongCouple(ma_mo_c1, ma_mo_c2);

    if b1 and b2 and b3 then
      parm2.value := 7 * TICRATE;
  end;

  // Lower antigrav surrounding stones.

  if parm2.value > 2 then
  begin
    dec(parm2.value);

    if parm2.value = 6 * TICRATE + 10 then
    begin
      S_StartSound(nil, 'DSEARTHQ');

      // Spawn raptors
      currentthinker := thinkercap.next;
      while Pointer(currentthinker) <> Pointer(@thinkercap) do
      begin
        if (@currentthinker._function.acp1 = @P_MobjThinker) then
          if Pmobj_t(currentthinker).info.doomednum = 22063 then
          begin
            raptor :=
              P_SpawnMobjInSectorUnique(
                PSubSector_t(Pmobj_t(currentthinker).subsector).sector,
                Pmobj_t(currentthinker).x,
                Pmobj_t(currentthinker).y,
                Pmobj_t(currentthinker).z,
                22036);
            if raptor <> nil then
              raptor.angle := Pmobj_t(currentthinker).angle;
          end;
        currentthinker := currentthinker.next;
      end;

    end
    else if parm2.value = 6 * TICRATE then
    begin
      p.quaketics := 5 * TICRATE;
      P_PlayerFaceMobj(p, actor, TICRATE)
    end
    else if parm2.value < 5 * TICRATE + 20 then
    begin
      for i := 0 to numsectors - 1 do
      begin
        if sectors[i].tag = 4 then
        begin
          sectors[i].floorheight := sectors[i].floorheight - 2 * FRACUNIT div 3;
          if sectors[i].floorheight < 0 then
            sectors[i].floorheight := 0;
        end;
      end;

      if parm2.value = TICRATE then
        S_StartSound(nil, 'WELLDONE');
    end;
  end;

  // The antigrav rock has been given to the manager_d
  parm := P_GetMobjCustomParam(actor, 'ANTIGRAVROCK_TICKER');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'ANTIGRAVROCK_TICKER', 0);

  // Final ticker
  if parm.value > 0 then
  begin
    Dec(parm.value);

    if parm.value = 5 * TICRATE then
    begin
      S_StartSound(nil, 'DSEARTHQ');
      p.quaketics := 5 * TICRATE;
      P_PlayerFaceMobj(p, P_FindMobj(22011), 3 * TICRATE div 2) // 22011: Level 8 portal - final portal
    end
    else if parm.value < 4 * TICRATE then
    begin
      sec1 := nil;
      sec2 := nil;
      sec3 := nil;
      sec4 := nil;

      for i := 0 to numsectors - 1 do
      begin
        if sectors[i].tag = 5 then
          sec1 := @sectors[i]
        else if sectors[i].tag = 6 then
          sec2 := @sectors[i]
        else if sectors[i].tag = 7 then
          sec3 := @sectors[i]
        else if sectors[i].tag = 8 then
          sec4 := @sectors[i]
      end;
      if sec1 <> nil then
      begin
        sec1.ceilingheight := sec1.ceilingheight + 2 * FRACUNIT;
        if sec1.ceilingheight > 72 * FRACUNIT then
          sec1.ceilingheight := 72 * FRACUNIT;
      end;

      if sec2 <> nil then
      begin
        sec2.ceilingheight := sec2.ceilingheight + 3 * FRACUNIT div 2;
        if sec2.ceilingheight > 72 * FRACUNIT then
          sec2.ceilingheight := 72 * FRACUNIT;
      end;

      if sec3 <> nil then
      begin
        sec3.ceilingheight := sec3.ceilingheight + FRACUNIT;
        if sec3.ceilingheight > 72 * FRACUNIT then
          sec3.ceilingheight := 72 * FRACUNIT;
      end;

      if sec4 <> nil then
      begin
        sec4.ceilingheight := sec4.ceilingheight + FRACUNIT div 2;
        if sec4.ceilingheight > 72 * FRACUNIT then
          sec4.ceilingheight := 72 * FRACUNIT;
      end;

      if parm.value = 1 then
        S_StartSound(nil, 'WELLDONE');
    end;

  end;

end;

//==============================================================================
//
// A_Manager_D
//
//==============================================================================
procedure A_Manager_D(const actor: Pmobj_t);
var
  p: Pplayer_t;
  parm: Pmobjcustomparam_t;
  parm2: Pmobjcustomparam_t;
  parm3: Pmobjcustomparam_t;
  parm4: Pmobjcustomparam_t;
  prock: integer;
  arock: integer;
  mo: Pmobj_t;
begin
  parm := P_GetMobjCustomParam(actor, 'INTERACT_COUNT');
  if parm = nil then
    parm := P_SetMobjCustomParam(actor, 'INTERACT_COUNT', 0);

  parm2 := P_GetMobjCustomParam(actor, 'INTERACT_TICS');
  if parm2 = nil then
    parm2 := P_SetMobjCustomParam(actor, 'INTERACT_TICS', 0);

  parm3 := P_GetMobjCustomParam(actor, 'SPAWN_WEAPON');
  if parm3 = nil then
    parm3 := P_SetMobjCustomParam(actor, 'SPAWN_WEAPON', 0);

  p := @players[consoleplayer];
  if p.mo = nil then
    Exit;

  if parm3.value = 1 then
  begin
    mo := P_SpawnObjectToSpot(22014, 2002, p.mo, 64 * FRACUNIT);  // Spawn gun
    if mo <> nil then
    begin
      P_PlayerFaceMobj(p, mo, TICRATE div 2);
      S_StartSound(mo, 'DSGIVE');
    end;
    parm3.value := 0;
  end
  else if parm3.value > 0 then
    parm3.value := parm3.value - 1;

  actor.target := p.mo;
  A_FaceTarget(actor);

  A_UnSetInteractive(actor);

  parm4 := P_GetMobjCustomParam(actor, 'FINAL_TICKER');
  if parm4 = nil then
    parm4 := P_SetMobjCustomParam(actor, 'FINAL_TICKER', 0);

  if parm4.value > 0 then
  begin
    Dec(parm4.value);
    case parm4.value of
    24 * TICRATE + 1: P_PlayerFaceMobj(p, actor, 24 * TICRATE);
    24 * TICRATE: CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech9'));
    16 * TICRATE: CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech10'));
     8 * TICRATE: CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech11'));
               0: CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech12'));
    end;
  end;

  if parm2.value > 0 then
  begin
    Dec(parm2.value);
    if parm2.value = 0 then
    begin
      A_SetInteractive(actor);
      P_SetMobjState(actor, statenum_t(actor.info.seestate));
    end;
    exit;
  end;

  inc(parm.value);

  case parm.value of
    1:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech1'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_d/speech1'), 6 * TICRATE);
        parm2.value := 11 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 11 * TICRATE);
      end;
    2:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech2'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_d/speech2'), 8 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 13 * TICRATE);
      end;

    3:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech3'));
        CM_ExecComicDialogInFuture(p.mo,  CM_DialogID('reply/manager_d/speech3'), 8 * TICRATE);
        parm2.value := 13 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 13 * TICRATE);
      end;

    4:
      begin
        P_PlayerFaceMobj(p, actor, TICRATE div 2);
        CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech4'));
        parm2.value := 12 * TICRATE;
        parm3.value := 7 * TICRATE;
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 5 * TICRATE);
      end;

  else
    begin
      prock := P_GetMobjCustomParamValue(p.mo, 'ANTIGRAVROCK');
      arock := P_GetMobjCustomParamValue(actor, 'ANTIGRAVROCK');
      if (prock >= 1) and (arock = 0) then
      begin
        P_SetMobjCustomParam(p.mo, 'ANTIGRAVROCK', 0);
        P_SetMobjCustomParam(actor, 'ANTIGRAVROCK', 1);
        S_StartSound(actor, 'DSGIVE');
        P_PlayerFaceMobj(p, actor, TICRATE div 2);

        mo := P_FindMobj(22057); // Find E1M7_THINKER
        if mo <> nil then
          P_SetMobjCustomParam(mo, 'ANTIGRAVROCK_TICKER', 35 * TICRATE);

        P_PlayerFaceMobj(p, actor, TICRATE);
        P_KeepPlayerNearMe(actor, p, 144 * FRACUNIT, 25 * TICRATE);
        parm4.value := 25 * TICRATE;
        parm2.value := 35 * TICRATE;
      end
      else if arock > 0 then
      begin
        CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech8'));
        parm2.value := 5 * TICRATE;
      end
      else
      begin
        CM_ExecComicDialog(actor, CM_DialogID('manager_d/speech' + itoa((N_Random mod 3) + 5)));
        parm2.value := 7 * TICRATE;
      end;
    end;
  end;

end;

//==============================================================================
//
// J_Majong
//
//==============================================================================
procedure J_Majong(const actor: Pmobj_t; const dn1, dn2: integer);
var
  currentthinker: Pthinker_t;
begin
  currentthinker := thinkercap.next;
  while Pointer(currentthinker) <> Pointer(@thinkercap) do
  begin
    if (@currentthinker._function.acp1 = @P_MobjThinker) then
    begin
      if (Pmobj_t(currentthinker).info.doomednum = dn1) or (Pmobj_t(currentthinker).info.doomednum = dn2) then
      begin
        P_SetMobjCustomParam(Pmobj_t(currentthinker), 'MAJONG', 0);
        A_UnHideThing(Pmobj_t(currentthinker));
      end;
    end;
    currentthinker := currentthinker.next;
  end;
  P_SetMobjCustomParam(actor, 'MAJONG', 1);
  S_StartSound(actor, 'DSMENU1');
end;

//==============================================================================
//
// A_Majong_A
//
//==============================================================================
procedure A_Majong_A(const actor: Pmobj_t);
begin
  J_Majong(actor, 22061, 22062);
end;

//==============================================================================
//
// A_Majong_B
//
//==============================================================================
procedure A_Majong_B(const actor: Pmobj_t);
begin
  J_Majong(actor, 22060, 22062);
end;

//==============================================================================
//
// A_Majong_C
//
//==============================================================================
procedure A_Majong_C(const actor: Pmobj_t);
begin
  J_Majong(actor, 22060, 22061);
end;

//==============================================================================
//
// A_E1M8
//
//==============================================================================
procedure A_E1M8(const actor: Pmobj_t);
var
  p: Pplayer_t;
  sec: Psector_t;
  k: integer;
begin
  p := @players[consoleplayer];
  if p.mo = nil then
    exit;

  if leveltime < 300 then
    journeymapinfo[8].fog_density := 400 - leveltime
  else
    journeymapinfo[8].fog_density := 100;

  if leveltime = 400 then
    P_SpawnObjectToSpot(21115, 21114, p.mo, 256 * FRACUNIT);

  k := P_GetMobjCustomParamValue(actor, 'youwon');
  if k = 1 then
  begin
    youwon := True;
    G_ExitLevel;
  end
  else if k > 1 then
    P_SetMobjCustomParam(actor, 'youwon', k - 1);

  p.mo.flags2_ex := p.mo.flags2_ex or MF2_EX_RENDERROTATE;
  p.mo.anglex := 60.0;
  p.mo.radius := 48 * FRACUNIT;
  p.mo.height := 48 * FRACUNIT;

  sec := Psubsector_t(p.mo.subsector).sector;
  P_ChangeSector(sec, false);

end;

//==============================================================================
//
// A_FacePlayer
//
//==============================================================================
procedure A_FacePlayer(const actor: Pmobj_t);
var
  an: angle_t;
  p_mo: Pmobj_t;
begin
  p_mo := players[consoleplayer].mo;
  if p_mo = nil then
    Exit;
  an := ANGLE_MAX - p_mo.angle;
  actor.angle := an;
end;

end.
