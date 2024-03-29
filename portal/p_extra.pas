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

unit p_extra;

//
// JVAL
// Extra mobj functions

interface

uses
  m_fixed,
  d_player,
  p_mobj_h;

//==============================================================================
//
// A_CustomSound1
//
//==============================================================================
procedure A_CustomSound1(mo: Pmobj_t);

//==============================================================================
//
// A_CustomSound2
//
//==============================================================================
procedure A_CustomSound2(mo: Pmobj_t);

//==============================================================================
//
// A_CustomSound3
//
//==============================================================================
procedure A_CustomSound3(mo: Pmobj_t);

//==============================================================================
//
// P_RandomSound
//
//==============================================================================
procedure P_RandomSound(const actor: Pmobj_t; const soundnum: integer);

//==============================================================================
//
// A_RandomPainSound
//
//==============================================================================
procedure A_RandomPainSound(actor: Pmobj_t);

//==============================================================================
//
// A_RandomSeeSound
//
//==============================================================================
procedure A_RandomSeeSound(actor: Pmobj_t);

//==============================================================================
//
// A_RandomAttackSound
//
//==============================================================================
procedure A_RandomAttackSound(actor: Pmobj_t);

//==============================================================================
//
// A_RandomDeathSound
//
//==============================================================================
procedure A_RandomDeathSound(actor: Pmobj_t);

//==============================================================================
//
// A_RandomActiveSound
//
//==============================================================================
procedure A_RandomActiveSound(actor: Pmobj_t);

//==============================================================================
//
// A_RandomCustomSound1
//
//==============================================================================
procedure A_RandomCustomSound1(actor: Pmobj_t);

//==============================================================================
//
// A_RandomCustomSound2
//
//==============================================================================
procedure A_RandomCustomSound2(actor: Pmobj_t);

//==============================================================================
//
// A_RandomCustomSound3
//
//==============================================================================
procedure A_RandomCustomSound3(actor: Pmobj_t);

//==============================================================================
//
// A_RandomCustomSound
//
//==============================================================================
procedure A_RandomCustomSound(actor: Pmobj_t);

//==============================================================================
//
// A_RandomMeleeSound
//
//==============================================================================
procedure A_RandomMeleeSound(actor: Pmobj_t);

//==============================================================================
//
// A_AnnihilatorAttack
//
//==============================================================================
procedure A_AnnihilatorAttack(actor: Pmobj_t);

//==============================================================================
//
// A_Playsound
//
//==============================================================================
procedure A_Playsound(actor: Pmobj_t);

//==============================================================================
//
// A_PlaysoundEx
//
//==============================================================================
procedure A_PlaysoundEx(actor: Pmobj_t);

//==============================================================================
//
// A_PlaysoundIfMoving
//
//==============================================================================
procedure A_PlaysoundIfMoving(actor: Pmobj_t);

//==============================================================================
//
// A_PlayPlayerWalkSound
//
//==============================================================================
procedure A_PlayPlayerWalkSound(actor: Pmobj_t);

//==============================================================================
//
// A_PlayerBreath
//
//==============================================================================
procedure A_PlayerBreath(p: Pplayer_t);

//==============================================================================
//
// A_PlayerWalk
//
//==============================================================================
procedure A_PlayerWalk(mo: Pmobj_t);

//==============================================================================
//
// A_PlayFullVolumesound
//
//==============================================================================
procedure A_PlayFullVolumesound(actor: Pmobj_t);

//==============================================================================
//
// A_PlayFullVolumesoundIfMoving
//
//==============================================================================
procedure A_PlayFullVolumesoundIfMoving(actor: Pmobj_t);

//==============================================================================
//
// A_MediaPlayerPlaysound
//
//==============================================================================
procedure A_MediaPlayerPlaysound(actor: Pmobj_t);

//==============================================================================
//
// A_PlayWeaponsound
//
//==============================================================================
procedure A_PlayWeaponsound(actor: Pmobj_t);

//==============================================================================
//
// A_RandomSound
//
//==============================================================================
procedure A_RandomSound(actor: Pmobj_t);

//==============================================================================
//
// A_Stop
//
//==============================================================================
procedure A_Stop(actor: Pmobj_t);

//==============================================================================
//
// A_Jump
//
//==============================================================================
procedure A_Jump(actor: Pmobj_t);

//==============================================================================
//
// A_CustomMissile
//
//==============================================================================
procedure A_CustomMissile(actor: Pmobj_t);

//==============================================================================
//
// A_RandomMissile
//
//==============================================================================
procedure A_RandomMissile(actor: Pmobj_t);

//==============================================================================
//
// A_LowGravity
//
//==============================================================================
procedure A_LowGravity(actor: Pmobj_t);

//==============================================================================
//
// A_NoGravity
//
//==============================================================================
procedure A_NoGravity(actor: Pmobj_t);

//==============================================================================
//
// A_Gravity
//
//==============================================================================
procedure A_Gravity(actor: Pmobj_t);

//==============================================================================
//
// A_NoBlocking
//
//==============================================================================
procedure A_NoBlocking(actor: Pmobj_t);

//==============================================================================
//
// A_MeleeAttack
//
//==============================================================================
procedure A_MeleeAttack(actor: Pmobj_t);

//==============================================================================
//
// A_SpawnItem
//
//==============================================================================
procedure A_SpawnItem(actor: Pmobj_t);

//==============================================================================
//
// A_SpawnItemEx
//
//==============================================================================
procedure A_SpawnItemEx(actor: Pmobj_t);

//==============================================================================
//
// A_SeekerMissile
//
//==============================================================================
procedure A_SeekerMissile(actor: Pmobj_t);

//==============================================================================
//
// A_CStaffMissileSlither
//
//==============================================================================
procedure A_CStaffMissileSlither(actor: Pmobj_t);

//==============================================================================
//
// A_SetTranslucent
//
//==============================================================================
procedure A_SetTranslucent(actor: Pmobj_t);

//==============================================================================
//
// A_Die
//
//==============================================================================
procedure A_Die(actor: Pmobj_t);

//==============================================================================
//
// A_CustomBulletAttack
//
//==============================================================================
procedure A_CustomBulletAttack(actor: Pmobj_t);

//==============================================================================
//
// A_FadeOut
//
//==============================================================================
procedure A_FadeOut(actor: Pmobj_t);

//==============================================================================
//
// A_FadeOut10
//
//==============================================================================
procedure A_FadeOut10(actor: Pmobj_t);

//==============================================================================
//
// A_FadeOut20
//
//==============================================================================
procedure A_FadeOut20(actor: Pmobj_t);

//==============================================================================
//
// A_FadeOut30
//
//==============================================================================
procedure A_FadeOut30(actor: Pmobj_t);

//==============================================================================
//
// A_FadeIn
//
//==============================================================================
procedure A_FadeIn(actor: Pmobj_t);

//==============================================================================
//
// A_FadeIn10
//
//==============================================================================
procedure A_FadeIn10(actor: Pmobj_t);

//==============================================================================
//
// A_FadeIn20
//
//==============================================================================
procedure A_FadeIn20(actor: Pmobj_t);

//==============================================================================
//
// A_FadeIn30
//
//==============================================================================
procedure A_FadeIn30(actor: Pmobj_t);

//==============================================================================
//
// A_MissileAttack
//
//==============================================================================
procedure A_MissileAttack(actor: Pmobj_t);

//==============================================================================
//
// A_AdjustSideSpot
//
//==============================================================================
procedure A_AdjustSideSpot(actor: Pmobj_t);

//==============================================================================
//
// A_Countdown
//
//==============================================================================
procedure A_Countdown(actor: Pmobj_t);

//==============================================================================
//
// A_FastChase
//
//==============================================================================
procedure A_FastChase(actor: Pmobj_t);

//==============================================================================
//
// A_ThrustZ
//
//==============================================================================
procedure A_ThrustZ(actor: Pmobj_t);

//==============================================================================
//
// A_ThrustZ5
//
//==============================================================================
procedure A_ThrustZ5(actor: Pmobj_t);

//==============================================================================
//
// A_ThrustZ10
//
//==============================================================================
procedure A_ThrustZ10(actor: Pmobj_t);

//==============================================================================
//
// A_ThrustXY
//
//==============================================================================
procedure A_ThrustXY(actor: Pmobj_t);

//==============================================================================
//
// A_Turn
//
//==============================================================================
procedure A_Turn(actor: Pmobj_t);

//==============================================================================
//
// A_Turn5
//
//==============================================================================
procedure A_Turn5(actor: Pmobj_t);

//==============================================================================
//
// A_Turn10
//
//==============================================================================
procedure A_Turn10(actor: Pmobj_t);

//==============================================================================
//
// A_JumpIfCloser
//
//==============================================================================
procedure A_JumpIfCloser(actor: Pmobj_t);

//==============================================================================
//
// A_JumpIfHealthLower
//
//==============================================================================
procedure A_JumpIfHealthLower(actor: Pmobj_t);

//==============================================================================
//
// A_ScreamAndUnblock
//
//==============================================================================
procedure A_ScreamAndUnblock(actor: Pmobj_t);

//==============================================================================
//
// A_SetInvulnerable
//
//==============================================================================
procedure A_SetInvulnerable(actor: Pmobj_t);

//==============================================================================
//
// A_UnSetInvulnerable
//
//==============================================================================
procedure A_UnSetInvulnerable(actor: Pmobj_t);

//==============================================================================
//
// A_FloatBob
//
//==============================================================================
procedure A_FloatBob(actor: Pmobj_t);

//==============================================================================
//
// A_NoFloatBob
//
//==============================================================================
procedure A_NoFloatBob(actor: Pmobj_t);

//==============================================================================
//
// A_Missile
//
//==============================================================================
procedure A_Missile(actor: Pmobj_t);

//==============================================================================
//
// A_NoMissile
//
//==============================================================================
procedure A_NoMissile(actor: Pmobj_t);

//==============================================================================
//
// A_ComboAttack
//
//==============================================================================
procedure A_ComboAttack(actor: Pmobj_t);

//==============================================================================
//
// A_BulletAttack
//
//==============================================================================
procedure A_BulletAttack(actor: Pmobj_t);

//==============================================================================
//
// A_MediumGravity
//
//==============================================================================
procedure A_MediumGravity(actor: Pmobj_t);

//==============================================================================
//
// A_Wander
//
//==============================================================================
procedure A_Wander(actor: Pmobj_t);

//==============================================================================
//
// A_HideThing
//
//==============================================================================
procedure A_HideThing(actor: Pmobj_t);

//==============================================================================
//
// A_UnHideThing
//
//==============================================================================
procedure A_UnHideThing(actor: Pmobj_t);

//==============================================================================
//
// A_SpawnDebris
//
//==============================================================================
procedure A_SpawnDebris(actor: Pmobj_t);

//==============================================================================
//
// A_SpawnSmokeUp
//
//==============================================================================
procedure A_SpawnSmokeUp(actor: Pmobj_t);

//==============================================================================
//
// A_SpawnSmokeDown
//
//==============================================================================
procedure A_SpawnSmokeDown(actor: Pmobj_t);

//==============================================================================
//
// A_SpawnSmokeMiddle
//
//==============================================================================
procedure A_SpawnSmokeMiddle(actor: Pmobj_t);

//==============================================================================
//
// A_SpawnSmokeHorz48
//
//==============================================================================
procedure A_SpawnSmokeHorz48(actor: Pmobj_t);

//==============================================================================
//
// A_SpawnSmokeHorz
//
//==============================================================================
procedure A_SpawnSmokeHorz(actor: Pmobj_t);

//==============================================================================
//
// A_DesidePlayerWalkFrame
//
//==============================================================================
procedure A_DesidePlayerWalkFrame(actor: Pmobj_t);

//==============================================================================
//
// A_Speak
//
//==============================================================================
procedure A_Speak(actor: Pmobj_t);

//==============================================================================
//
// A_ComicBubble
//
//==============================================================================
procedure A_ComicBubble(actor: Pmobj_t);

//==============================================================================
//
// A_ComicBubbleOnce
//
//==============================================================================
procedure A_ComicBubbleOnce(actor: Pmobj_t);

//==============================================================================
//
// A_TargetComicBubble
//
//==============================================================================
procedure A_TargetComicBubble(actor: Pmobj_t);

//==============================================================================
//
// A_SetInteractive
//
//==============================================================================
procedure A_SetInteractive(actor: Pmobj_t);

//==============================================================================
//
// A_UnSetInteractive
//
//==============================================================================
procedure A_UnSetInteractive(actor: Pmobj_t);

//==============================================================================
//
// A_DoComicBubbles
//
//==============================================================================
procedure A_DoComicBubbles(actor: Pmobj_t);

//==============================================================================
//
// A_NoComicBubbles
//
//==============================================================================
procedure A_NoComicBubbles(actor: Pmobj_t);

//==============================================================================
//
// A_SetMonsterInfight
//
//==============================================================================
procedure A_SetMonsterInfight(actor: Pmobj_t);

//==============================================================================
//
// A_UnSetMonsterInfight
//
//==============================================================================
procedure A_UnSetMonsterInfight(actor: Pmobj_t);

//==============================================================================
//
// A_NoiseAlert
//
//==============================================================================
procedure A_NoiseAlert(actor: Pmobj_t);

//==============================================================================
//
// A_ConsoleCommand
//
//==============================================================================
procedure A_ConsoleCommand(actor: Pmobj_t);

//==============================================================================
//
// A_SetCustomParam
//
//==============================================================================
procedure A_SetCustomParam(actor: Pmobj_t);

//==============================================================================
//
// A_AddCustomParam
//
//==============================================================================
procedure A_AddCustomParam(actor: Pmobj_t);

//==============================================================================
//
// A_RemoveCustomParam
//
//==============================================================================
procedure A_RemoveCustomParam(actor: Pmobj_t);

//==============================================================================
//
// A_SetTargetCustomParam
//
//==============================================================================
procedure A_SetTargetCustomParam(actor: Pmobj_t);

//==============================================================================
//
// A_AddTargetCustomParam
//
//==============================================================================
procedure A_AddTargetCustomParam(actor: Pmobj_t);

//==============================================================================
//
// A_RemoveTargetCustomParam
//
//==============================================================================
procedure A_RemoveTargetCustomParam(actor: Pmobj_t);

//==============================================================================
//
// A_PlayerFaceMe
//
//==============================================================================
procedure A_PlayerFaceMe(actor: Pmobj_t);

const
  FLOATBOBSIZE = 64;
  FLOATBOBMASK = FLOATBOBSIZE - 1;

  FloatBobOffsets: array[0..FLOATBOBSIZE - 1] of fixed_t = (
         0,  51389, 102283, 152192,
    200636, 247147, 291278, 332604,
    370727, 405280, 435929, 462380,
    484378, 501712, 514213, 521763,
    524287, 521763, 514213, 501712,
    484378, 462380, 435929, 405280,
    370727, 332604, 291278, 247147,
    200636, 152192, 102283,  51389,
        -1, -51390,-102284,-152193,
   -200637,-247148,-291279,-332605,
   -370728,-405281,-435930,-462381,
   -484380,-501713,-514215,-521764,
   -524288,-521764,-514214,-501713,
   -484379,-462381,-435930,-405280,
   -370728,-332605,-291279,-247148,
   -200637,-152193,-102284, -51389
  );

//==============================================================================
//
// P_CheckStateParams
//
//==============================================================================
function P_CheckStateParams(actor: Pmobj_t; const numparms: integer = -1): boolean;

//==============================================================================
//
// P_SpawnSoundOrigin
//
//==============================================================================
function P_SpawnSoundOrigin(const x, y, z: fixed_t): Pmobj_t;

implementation

uses
  d_delphi,
  gamedef,
  c_con,
  i_system,
  info_h,
  info,
  m_rnd,
  m_vectors,
  g_game,
  p_terrain,
  p_journey,
  p_enemy,
  p_mobj,
  p_inter,
  p_user,
  p_map,
  p_maputl,
  p_local,
  p_pspr,
  p_sounds,
  p_tick,
  r_defs,
  sounds,
  s_sound,
  cm_main,
  tables;

//==============================================================================
//
// A_CustomSound1
//
//==============================================================================
procedure A_CustomSound1(mo: Pmobj_t);
begin
  if mo.info.customsound1 <> 0 then
  begin
    if mo.info.flags_ex and MF_EX_RANDOMCUSTOMSOUND1 <> 0 then
      A_RandomCustomSound1(mo)
    else
      S_StartSound(mo, mo.info.customsound1);
  end;
end;

//==============================================================================
//
// A_CustomSound2
//
//==============================================================================
procedure A_CustomSound2(mo: Pmobj_t);
begin
  if mo.info.customsound2 <> 0 then
  begin
    if mo.info.flags_ex and MF_EX_RANDOMCUSTOMSOUND2 <> 0 then
      A_RandomCustomSound2(mo)
    else
      S_StartSound(mo, mo.info.customsound2);
  end;
end;

//==============================================================================
//
// A_CustomSound3
//
//==============================================================================
procedure A_CustomSound3(mo: Pmobj_t);
begin
  if mo.info.customsound3 <> 0 then
  begin
    if mo.info.flags_ex and MF_EX_RANDOMCUSTOMSOUND3 <> 0 then
      A_RandomCustomSound3(mo)
    else
      S_StartSound(mo, mo.info.customsound3);
  end;
end;

//==============================================================================
//
// P_RandomSound
//
//==============================================================================
procedure P_RandomSound(const actor: Pmobj_t; const soundnum: integer);
var
  randomlist: TDNumberList;
  rndidx: integer;
begin
  if soundnum <> 0 then
  begin
    randomlist := S_GetRandomSoundList(soundnum);
    if randomlist <> nil then
    begin
      if randomlist.Count > 0 then
      begin
        rndidx := N_Random mod randomlist.Count;
        S_StartSound(actor, randomlist[rndidx]);
      end
      else
      // JVAL: This should never happen, see S_GetRandomSoundList() in sounds.pas
        I_Error('P_RandomSound(): Random list is empty for sound no %d', [soundnum]);
    end;
  end;
end;

//==============================================================================
//
// A_RandomPainSound
//
//==============================================================================
procedure A_RandomPainSound(actor: Pmobj_t);
begin
  P_RandomSound(actor, actor.info.painsound);
end;

//==============================================================================
//
// A_RandomSeeSound
//
//==============================================================================
procedure A_RandomSeeSound(actor: Pmobj_t);
begin
  P_RandomSound(actor, actor.info.seesound);
end;

//==============================================================================
//
// A_RandomAttackSound
//
//==============================================================================
procedure A_RandomAttackSound(actor: Pmobj_t);
begin
  P_RandomSound(actor, actor.info.attacksound);
end;

//==============================================================================
//
// A_RandomDeathSound
//
//==============================================================================
procedure A_RandomDeathSound(actor: Pmobj_t);
begin
  P_RandomSound(actor, actor.info.deathsound);
end;

//==============================================================================
//
// A_RandomActiveSound
//
//==============================================================================
procedure A_RandomActiveSound(actor: Pmobj_t);
begin
  P_RandomSound(actor, actor.info.activesound);
end;

//==============================================================================
//
// A_RandomCustomSound1
//
//==============================================================================
procedure A_RandomCustomSound1(actor: Pmobj_t);
begin
  P_RandomSound(actor, actor.info.customsound1);
end;

//==============================================================================
//
// A_RandomCustomSound2
//
//==============================================================================
procedure A_RandomCustomSound2(actor: Pmobj_t);
begin
  P_RandomSound(actor, actor.info.customsound2);
end;

//==============================================================================
//
// A_RandomCustomSound3
//
//==============================================================================
procedure A_RandomCustomSound3(actor: Pmobj_t);
begin
  P_RandomSound(actor, actor.info.customsound3);
end;

//==============================================================================
//
// A_RandomCustomSound
//
//==============================================================================
procedure A_RandomCustomSound(actor: Pmobj_t);
var
  list: TDNumberList;
  rndidx: integer;
begin
  list := TDNumberList.Create;
  try
    if actor.info.customsound1 > 0 then
      list.Add(actor.info.customsound1);
    if actor.info.customsound2 > 0 then
      list.Add(actor.info.customsound2);
    if actor.info.customsound3 > 0 then
      list.Add(actor.info.customsound3);
    if list.Count > 0 then
    begin
      rndidx := N_Random mod list.Count;
      P_RandomSound(actor, list[rndidx]);
    end;
  finally
    list.Free;
  end;
end;

//==============================================================================
//
// A_RandomMeleeSound
//
//==============================================================================
procedure A_RandomMeleeSound(actor: Pmobj_t);
begin
  P_RandomSound(actor, actor.info.meleesound);
end;

//==============================================================================
//
// A_AnnihilatorAttack
//
//==============================================================================
procedure A_AnnihilatorAttack(actor: Pmobj_t);
var
  mo: Pmobj_t;
  an: angle_t;
  rnd: byte;
  speed: fixed_t;
begin
  A_FaceTarget(actor);
  mo := P_SpawnMissile(actor, actor.target, Ord(MT_ROCKET));
  if mo = nil then
    exit;
  rnd := N_Random;
  mo.angle := mo.angle - ANG1 * (2 + (rnd mod 5));
  an := mo.angle shr ANGLETOFINESHIFT;
  speed := mo.info.speed + (2 - (N_Random mod 5)) * FRACUNIT;
  mo.momx := FixedMul(speed, finecosine[an]);
  mo.momy := FixedMul(speed, finesine[an]);
  mo.z := mo.z + 5 * FRACUNIT;

  mo := P_SpawnMissile(actor, actor.target, Ord(MT_ROCKET));
  if mo = nil then
    exit;
  rnd := N_Random;
  mo.angle := mo.angle + ANG1 * (2 + (rnd mod 5));
  an := mo.angle shr ANGLETOFINESHIFT;
  speed := mo.info.speed + (2 - (N_Random mod 5)) * FRACUNIT;
  mo.momx := FixedMul(speed, finecosine[an]);
  mo.momy := FixedMul(speed, finesine[an]);
  mo.z := mo.z + 5 * FRACUNIT;

end;

//==============================================================================
//
// P_CheckStateParams
//
//==============================================================================
function P_CheckStateParams(actor: Pmobj_t; const numparms: integer = -1): boolean;
begin
  if numparms = 0 then
  begin
    I_Warning('P_CheckStateParams(): Expected params can not be 0'#13#10, [numparms]);
    result := false;
    exit;
  end;

  if actor.state.params = nil then
  begin
    I_Warning('P_CheckStateParams(): Parameter list is null');
    if numparms > 0 then
      I_Warning(', %d parameters expected', [numparms]);
    I_Warning(#13#10);
    result := false;
    exit;
  end;

  if numparms <> -1 then
    if actor.state.params.Count <> numparms then
    begin
      I_Warning('P_CheckStateParams(): Parameter list has %d parameters, but %d parameters expected'#13#10, [actor.state.params.Count, numparms]);
      result := false;
      exit;
    end;

  result := true;
end;

//==============================================================================
//
// JVAL
// Play a sound
// A_Playsound(soundname)
//
//==============================================================================
procedure A_Playsound(actor: Pmobj_t);
var
  sndidx: integer;
begin
  if not P_CheckStateParams(actor, 1) then
    exit;

  if actor.state.params.IsComputed[0] then
    sndidx := actor.state.params.IntVal[0]
  else
  begin
    sndidx := S_GetSoundNumForName(actor.state.params.StrVal[0]);
    actor.state.params.IntVal[0] := sndidx;
  end;

  S_StartSound(actor, sndidx);

end;

//==============================================================================
//
// A_PlaysoundEx
//
//==============================================================================
procedure A_PlaysoundEx(actor: Pmobj_t);
var
  sndidx: integer;
  vol1: integer;
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  if actor.state.params.IsComputed[0] then
    sndidx := actor.state.params.IntVal[0]
  else
  begin
    sndidx := S_GetSoundNumForName(actor.state.params.StrVal[0]);
    actor.state.params.IntVal[0] := sndidx;
  end;

  vol1 := (actor.state.params.IntVal[1] * snd_SfxVolume) div 256;
  if vol1 > 15 then
    vol1 := 15
  else if vol1 < 0 then
    vol1 := 0;

  S_StartSoundAtVolume(actor, sndidx, vol1);

end;

//==============================================================================
//
// A_PlaysoundIfMoving
//
//==============================================================================
procedure A_PlaysoundIfMoving(actor: Pmobj_t);
begin
  if (actor.momx <> 0) and (actor.momy <> 0) then
    A_Playsound(actor);
end;

//==============================================================================
//
// A_PlayPlayerWalkSound
//
//==============================================================================
procedure A_PlayPlayerWalkSound(actor: Pmobj_t);
begin
  if actor.player = nil then
    exit;

  if actor.health <= 0 then
    exit;

  if P_AproxDistance(actor.x - Pplayer_t(actor.player).lastsoundstepx,
                     actor.y - Pplayer_t(actor.player).lastsoundstepy) < 128 * FRACUNIT then
    exit;

  Pplayer_t(actor.player).lastsoundstepx := actor.x;
  Pplayer_t(actor.player).lastsoundstepy := actor.y;

  A_PlaysoundIfMoving(actor);
end;

var
  brsnd: integer = -1;
  brsnd2: integer = -1;
  sndorgdn: Integer = -1;

//==============================================================================
//
// P_SpawnSoundOrigin
//
//==============================================================================
function P_SpawnSoundOrigin(const x, y, z: fixed_t): Pmobj_t;
begin
  if sndorgdn = -1 then
    sndorgdn := Info_GetMobjNumForDoomNum(22051);

  if sndorgdn > 0 then
    result := P_SpawnMobj(x, y, z, sndorgdn)
  else
    result := nil;
end;

//==============================================================================
//
// A_PlayerBreath
//
//==============================================================================
procedure A_PlayerBreath(p: Pplayer_t);
var
  sndidx: integer;
  mo: Pmobj_t;
begin
  if p.health <= 0 then
    exit;

  if p.playerstate = PST_DEAD then
    exit;

  if leveltime - p.lastbreath < 3 * TICRATE + (N_Random mod TICRATE) then
    exit;

  p.lastbreath := leveltime;

  sndidx := -1;

  if p.breathtype = 0 then
  begin
    if p.hardbreathtics > 0 then
    begin
      if brsnd2 < 0 then
        brsnd2 := S_GetSoundNumForName('player/breath2');
      sndidx := brsnd2;
    end
    else
    begin
      if brsnd < 0 then
        brsnd := S_GetSoundNumForName('player/breath');
      sndidx := brsnd;
    end;
  end;

  if sndidx > 0 then
  begin
    mo := P_SpawnSoundOrigin(p.mo.x + p.mo.height, p.mo.y, p.mo.z);
    S_StartSound(mo, sndidx);
  end;
end;

var
  walksnd: integer = -1;
  walksnd_water: integer = -1;
  walk_cnt: Integer = 0;

//==============================================================================
//
// A_PlayerWalk
//
//==============================================================================
procedure A_PlayerWalk(mo: Pmobj_t);
var
  p: Pplayer_t;
  th: Pmobj_t;
begin
  if not journeymapinfo[gamemap].walksnd then
    exit;

  p := mo.player;
  if p = nil then
    Exit;

  if p.health <= 0 then
    exit;

  if p.playerstate = PST_DEAD then
    exit;

  if (p.mo.momx = 0) and (p.mo.momy = 0) then
    exit;

  p.lastsoundstepx := p.mo.x;
  p.lastsoundstepy := p.mo.y;

  if P_GetThingFloorType(mo) = FLOOR_WATER then
  begin
    Inc(walk_cnt);
    if mo.z < Psubsector_t(mo.subsector).sector.floorheight + 32 then
    begin
      th := P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, Ord(MT_BLUEBLOOD));
      th.flags2_ex := th.flags2_ex or MF2_EX_NOHITFLOOR;
      th.momz := FRACUNIT div 2;
      th.momx := 128 * N_Random + p.mo.momx;
      th.momy := 128 * N_Random + p.mo.momy;

      if th.tics < 1 then
        th.tics := 1;

      if N_Random > 128 then
        P_SetMobjState(th, S_BLUEBLOOD2);

      if walk_cnt mod 5 <> 0 then
        exit;

      if walksnd_water < 0 then
        walksnd_water := S_GetSoundNumForName('DSPLATS');

      if walksnd_water > 0 then
        S_StartSound(mo, walksnd_water);
    end;
  end
  else
  begin
    walk_cnt := 0;
    if mo.z < Psubsector_t(mo.subsector).sector.floorheight + 32 then
    begin
      if walksnd < 0 then
        walksnd := S_GetSoundNumForName('dsstep');

      if walksnd > 0 then
        S_StartSound(mo, walksnd);
    end;
  end;
end;

//==============================================================================
//
// A_PlayFullVolumesound
//
//==============================================================================
procedure A_PlayFullVolumesound(actor: Pmobj_t);
var
  sndidx: integer;
begin
  if not P_CheckStateParams(actor, 1) then
    exit;

  if actor.state.params.IsComputed[0] then
    sndidx := actor.state.params.IntVal[0]
  else
  begin
    sndidx := S_GetSoundNumForName(actor.state.params.StrVal[0]);
    actor.state.params.IntVal[0] := sndidx;
  end;

  S_StartSound(nil, sndidx);

end;

//==============================================================================
//
// A_PlayFullVolumesoundIfMoving
//
//==============================================================================
procedure A_PlayFullVolumesoundIfMoving(actor: Pmobj_t);
begin
  if (actor.momx <> 0) and (actor.momy <> 0) then
    A_PlayFullVolumesound(actor);
end;

//==============================================================================
//
// A_MediaPlayerPlaysound
//
//==============================================================================
procedure A_MediaPlayerPlaysound(actor: Pmobj_t);
var
  sndidx: integer;
begin
  if not P_CheckStateParams(actor, 1) then
    exit;

  if actor.state.params.IsComputed[0] then
    sndidx := actor.state.params.IntVal[0]
  else
  begin
    sndidx := S_GetSoundNumForName(actor.state.params.StrVal[0]);
    actor.state.params.IntVal[0] := sndidx;
  end;

  S_StartMediaSound(sndidx);

end;

//==============================================================================
//
// A_PlayWeaponsound
//
//==============================================================================
procedure A_PlayWeaponsound(actor: Pmobj_t);
begin
  A_Playsound(actor);
end;

//==============================================================================
//
// JVAL
// Random sound
// A_RandomSound(sound1, sound2, ...)
//
//==============================================================================
procedure A_RandomSound(actor: Pmobj_t);
var
  sidxs: TDNumberList;
  sndidx: integer;
  i: integer;
begin
  if not P_CheckStateParams(actor) then
    exit;

  if actor.state.params.Count = 0 then // Should never happen
    exit;

  sidxs := TDNumberList.Create;
  try
    for i := 0 to actor.state.params.Count - 1 do
    begin
      if actor.state.params.IsComputed[i] then
        sndidx := actor.state.params.IntVal[i]
      else
      begin
        sndidx := S_GetSoundNumForName(actor.state.params.StrVal[i]);
        actor.state.params.IntVal[i] := sndidx;
      end;
      sidxs.Add(sndidx);
    end;
    sndidx := N_Random mod sidxs.Count;
    S_StartSound(actor, sidxs[sndidx]);
  finally
    sidxs.Free;
  end;
end;

//==============================================================================
// A_Stop
//
// JVAL
// Set all momentum to zero
//
//==============================================================================
procedure A_Stop(actor: Pmobj_t);
begin
  actor.momx := 0;
  actor.momy := 0;
  actor.momz := 0;
end;

//==============================================================================
//
// JVAL
// Change state offset
// A_Jump(propability, offset)
//
//==============================================================================
procedure A_Jump(actor: Pmobj_t);
var
  propability: integer;
  offset: integer;
  cur: integer;
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  propability := actor.state.params.IntVal[0];  // JVAL simple integer values are precalculated

  if N_Random < propability then
  begin
    offset := actor.state.params.IntVal[1];

    cur := (integer(actor.state) - integer(states)) div SizeOf(state_t);

    P_SetMobjState(actor, statenum_t(cur + offset));
  end;
end;

//==============================================================================
//
// JVAL
// Custom missile, based on A_CustomMissile() of ZDoom
// A_CustomMissile(type, height, offset, angle, aimmode, pitch)
//
//==============================================================================
procedure A_CustomMissile(actor: Pmobj_t);
var
  mobj_no: integer;
  spawnheight: fixed_t;
  spawnoffs: integer;
  angle: angle_t;
  aimmode: integer;
  pitch: angle_t;
  missile: Pmobj_t;
  ang: angle_t;
  x, y, z: fixed_t;
  vx, vz: fixed_t;
  velocity: vec3_t;
  missilespeed: fixed_t;
  owner: Pmobj_t;
begin
  if not P_CheckStateParams(actor) then
    exit;

  if actor.state.params.IsComputed[0] then
    mobj_no := actor.state.params.IntVal[0]
  else
  begin
    mobj_no := Info_GetMobjNumForName(actor.state.params.StrVal[0]);
    actor.state.params.IntVal[0] := mobj_no;
  end;
  if mobj_no = -1 then
  begin
    I_Warning('A_CustomMissile(): Unknown missile %s'#13#10, [actor.state.params.StrVal[0]]);
    exit;
  end;

  if mobjinfo[mobj_no].speed < 2048 then
    mobjinfo[mobj_no].speed := mobjinfo[mobj_no].speed * FRACUNIT;  // JVAL fix me!!!
  spawnheight := actor.state.params.IntVal[1];
  spawnoffs := actor.state.params.IntVal[2];
  angle := ANG1 * actor.state.params.IntVal[3];
  aimmode := actor.state.params.IntVal[4] and 3;
  pitch := ANG1 * actor.state.params.IntVal[5];

  if (actor.target <> nil) or (aimmode = 2) then
  begin
    ang := (actor.angle - ANG90) shr ANGLETOFINESHIFT;
    x := spawnoffs * finecosine[ang];
    y := spawnoffs * finesine[ang];
    if aimmode <> 0 then
      z := spawnheight * FRACUNIT
    else
      z := (spawnheight - 32) * FRACUNIT;
    case aimmode of
      1:
        begin
          missile := P_SpawnMissileXYZ(actor.x + x, actor.y + y, actor.z + z, actor, actor.target, mobj_no);
        end;
      2:
        begin
          missile := P_SpawnMissileAngleZ(actor, actor.z + z, mobj_no, actor.angle, 0, 0);

          // It is not necessary to use the correct angle here.
          // The only important thing is that the horizontal momentum is correct.
          // Therefore use 0 as the missile's angle and simplify the calculations accordingly.
          // The actual momentum vector is set below.
          if missile <> nil then
          begin
            pitch := pitch shr ANGLETOFINESHIFT;
            vx := finecosine[pitch];
            vz := finesine[pitch];
            missile.momx := FixedMul(vx, missile.info.speed);
            missile.momy := 0;
            missile.momz := FixedMul(vz, missile.info.speed);
          end;
        end;
      else
      begin
        inc(actor.x, x);
        inc(actor.y, y);
        inc(actor.z, z);
        missile := P_SpawnMissile(actor, actor.target, mobj_no);
        dec(actor.x, x);
        dec(actor.y, y);
        dec(actor.z, z);

      end;
    end;  // case

    if missile <> nil then
    begin
      // Use the actual momentum instead of the missile's Speed property
      // so that this can handle missiles with a high vertical velocity
      // component properly.
      velocity[0] := missile.momx;
      velocity[1] := missile.momy;
      velocity[2] := 0.0;

      missilespeed := round(VectorLength(@velocity));

      missile.angle := missile.angle + angle;
      ang := missile.angle shr ANGLETOFINESHIFT;
      missile.momx := FixedMul(missilespeed, finecosine[ang]);
      missile.momy := FixedMul(missilespeed, finesine[ang]);

      // handle projectile shooting projectiles - track the
      // links back to a real owner
      if (actor.info.flags and MF_MISSILE <> 0) or (aimmode and 4 <> 0) then
      begin
        owner := actor;
        while (owner.info.flags and MF_MISSILE <> 0) and (owner.target <> nil) do
          owner := owner.target;
         missile.target := owner;
        // automatic handling of seeker missiles
        if actor.info.flags_ex and missile.info.flags_ex and MF_EX_SEEKERMISSILE <> 0 then
          missile.tracer := actor.tracer;
      end
      else if missile.info.flags_ex and MF_EX_SEEKERMISSILE <> 0 then
      // automatic handling of seeker missiles
        missile.tracer := actor.target;

    end;
  end;
end;

//==============================================================================
//
// JVAL
// Standard random missile procedure
// A_RandomMissile(type1, type2, type3, ...)
//
//==============================================================================
procedure A_RandomMissile(actor: Pmobj_t);
var
  ridx: integer;
  mobj_no: integer;
  spawnheight: fixed_t;
  spawnoffs: integer;
  angle: angle_t;
  missile: Pmobj_t;
  ang: angle_t;
  x, y, z: fixed_t;
  velocity: vec3_t;
  missilespeed: fixed_t;
  owner: Pmobj_t;
begin
  if not P_CheckStateParams(actor) then
    exit;

  // Random index
  ridx := N_Random mod actor.state.params.Count;

  if actor.state.params.IsComputed[ridx] then
    mobj_no := actor.state.params.IntVal[ridx]
  else
  begin
    mobj_no := Info_GetMobjNumForName(actor.state.params.StrVal[ridx]);
    actor.state.params.IntVal[ridx] := mobj_no;
  end;
  if mobj_no = -1 then
  begin
    I_Warning('A_RandomMissile(): Unknown missile %s'#13#10, [actor.state.params.StrVal[ridx]]);
    exit;
  end;

  if mobjinfo[mobj_no].speed < 2048 then
    mobjinfo[mobj_no].speed := mobjinfo[mobj_no].speed * FRACUNIT;  // JVAL fix me!!!
  spawnheight := 0;
  spawnoffs := 0;
  angle := 0;

  if actor.target <> nil then
  begin
    ang := (actor.angle - ANG90) shr ANGLETOFINESHIFT;
    x := spawnoffs * finecosine[ang];
    y := spawnoffs * finesine[ang];
    z := (spawnheight - 32) * FRACUNIT;
    inc(actor.x, x);
    inc(actor.y, y);
    inc(actor.z, z);
    missile := P_SpawnMissile(actor, actor.target, mobj_no);
    dec(actor.x, x);
    dec(actor.y, y);
    dec(actor.z, z);

    if missile <> nil then
    begin
      // Use the actual momentum instead of the missile's Speed property
      // so that this can handle missiles with a high vertical velocity
      // component properly.
      velocity[0] := missile.momx;
      velocity[1] := missile.momy;
      velocity[2] := 0.0;

      missilespeed := round(VectorLength(@velocity));

      missile.angle := missile.angle + angle;
      ang := missile.angle shr ANGLETOFINESHIFT;
      missile.momx := FixedMul(missilespeed, finecosine[ang]);
      missile.momy := FixedMul(missilespeed, finesine[ang]);

      owner := actor;
      while (owner.info.flags and MF_MISSILE <> 0) and (owner.target <> nil) do
        owner := owner.target;
       missile.target := owner;
      // automatic handling of seeker missiles
      if actor.info.flags_ex and missile.info.flags_ex and MF_EX_SEEKERMISSILE <> 0 then
        missile.tracer := actor.tracer;

    end;
  end;
end;

//==============================================================================
// A_LowGravity
//
// JVAL
// Low gravity
//
//==============================================================================
procedure A_LowGravity(actor: Pmobj_t);
begin
  actor.flags := actor.flags and (not MF_NOGRAVITY);
  actor.flags_ex := actor.flags_ex or MF_EX_LOWGRAVITY;
  actor.flags2_ex := actor.flags2_ex and (not MF2_EX_MEDIUMGRAVITY);
end;

//==============================================================================
// A_NoGravity
//
// JVAL
// Remove gravity
//
//==============================================================================
procedure A_NoGravity(actor: Pmobj_t);
begin
  actor.flags := actor.flags or MF_NOGRAVITY;
  actor.flags_ex := actor.flags_ex and (not MF_EX_LOWGRAVITY);
  actor.flags2_ex := actor.flags2_ex and (not MF2_EX_MEDIUMGRAVITY);
end;

//==============================================================================
// A_Gravity
//
// JVAL
// Normal gravity
//
//==============================================================================
procedure A_Gravity(actor: Pmobj_t);
begin
  actor.flags := actor.flags and (not MF_NOGRAVITY);
  actor.flags_ex := actor.flags_ex and (not MF_EX_LOWGRAVITY);
  actor.flags2_ex := actor.flags2_ex and (not MF2_EX_MEDIUMGRAVITY);
end;

//==============================================================================
// A_NoBlocking
//
// JVAL
// Remove blocking flag
//
//==============================================================================
procedure A_NoBlocking(actor: Pmobj_t);
begin
  actor.flags := actor.flags and (not MF_SOLID);
end;

//==============================================================================
//
// JVAL
// Close distance attack
// A_MeleeAttack(mindamage=0; maxdamage=0);
//
//==============================================================================
procedure A_MeleeAttack(actor: Pmobj_t);
var
  dmin, dmax: integer;  // Minimum and maximum damage
  damage: integer;
begin
  if actor.target = nil then
    exit;

  A_FaceTarget(actor);
  if P_CheckMeleeRange(actor) then
  begin
    A_MeleeSound(actor, actor);
    if actor.state.params = nil then
      damage := actor.info.meleedamage
    else
    begin
      dmin := actor.state.params.IntVal[0];
      dmax := actor.state.params.IntVal[1];
      if dmax < dmin then
      begin
        damage := dmax;
        dmax := dmin;
        dmin := damage;
      end;
      damage := dmin + N_Random mod (dmax - dmin + 1);
    end;
    P_DamageMobj(actor.target, actor, actor, damage);
  end;
end;

//==============================================================================
//
// A_SpawnItem(type, distance, zheight, angle)
//
//==============================================================================
procedure A_SpawnItem(actor: Pmobj_t);
var
  mobj_no: integer;
  distance: fixed_t;
  zheight: fixed_t;
  mo: Pmobj_t;
  ang: angle_t;
begin
  if not P_CheckStateParams(actor) then
    exit;

  if actor.state.params.IsComputed[0] then
    mobj_no := actor.state.params.IntVal[0]
  else
  begin
    mobj_no := Info_GetMobjNumForName(actor.state.params.StrVal[0]);
    actor.state.params.IntVal[0] := mobj_no;
  end;
  if mobj_no = -1 then
  begin
    I_Warning('A_SpawnItem(): Unknown item %s'#13#10, [actor.state.params.StrVal[0]]);
    exit;
  end;

  distance := actor.state.params.FixedVal[1] + actor.radius + mobjinfo[mobj_no].radius;

  zheight := actor.state.params.FixedVal[2];
  ang := ANG1 * actor.state.params.IntVal[3];

  ang := (ang + actor.angle) shr ANGLETOFINESHIFT;
  mo := P_SpawnMobj(actor.x + FixedMul(distance, finecosine[ang]),
                    actor.y + FixedMul(distance, finesine[ang]),
                    actor.z - actor.floorz + zheight, mobj_no);
  if mo <> nil then
    mo.angle := actor.angle;
end;

// A_SpawnItemEx Flags
const
	SIXF_TRANSFERTRANSLATION = 1;
	SIXF_ABSOLUTEPOSITION = 2;
	SIXF_ABSOLUTEANGLE = 4;
	SIXF_ABSOLUTEMOMENTUM = 8;
	SIXF_SETMASTER = 16;
	SIXF_NOCHECKPOSITION = 32;
	SIXF_TELEFRAG = 64;
	// 128 is used by Skulltag!
	SIXF_TRANSFERAMBUSHFLAG = 256;

//==============================================================================
//
// A_SpawnItemEx(type, xofs, yofs, zofs, momx, momy, momz, Angle, flags, chance)
//
// type -> parm0
// xofs -> parm1
// yofs -> parm2
// zofs -> parm3
// momx -> parm4
// momy -> parm5
// momz -> parm6
// Angle -> parm7
// flags -> parm8
// chance -> parm9
//
//==============================================================================
procedure A_SpawnItemEx(actor: Pmobj_t);
var
  mobj_no: integer;
  x, y: fixed_t;
  xofs, yofs, zofs: fixed_t;
  momx, momy, momz: fixed_t;
  newxmom: fixed_t;
  mo: Pmobj_t;
  ang, ang1: angle_t;
  flags: integer;
  chance: integer;
begin
  if not P_CheckStateParams(actor) then
    exit;

  chance := actor.state.params.IntVal[9];

  if (chance > 0) and (chance < N_Random) then
    exit;

  if actor.state.params.IsComputed[0] then
    mobj_no := actor.state.params.IntVal[0]
  else
  begin
    mobj_no := Info_GetMobjNumForName(actor.state.params.StrVal[0]);
    actor.state.params.IntVal[0] := mobj_no;
  end;
  if mobj_no = -1 then
  begin
    I_Warning('A_SpawnItemEx(): Unknown item %s'#13#10, [actor.state.params.StrVal[0]]);
    exit;
  end;

  xofs := actor.state.params.IntVal[1];
  yofs := actor.state.params.IntVal[2];
  zofs := actor.state.params.IntVal[3];
  momx := actor.state.params.IntVal[4];
  momy := actor.state.params.IntVal[5];
  momz := actor.state.params.IntVal[6];
  ang1 := actor.state.params.IntVal[7];
  flags := actor.state.params.IntVal[8];

	if (flags and SIXF_ABSOLUTEANGLE) = 0 then
		ang1 := ang1 + Actor.angle;

	ang := ang1 shr ANGLETOFINESHIFT;

	if (flags and SIXF_ABSOLUTEPOSITION) <> 0 then
	begin
		x := actor.x + xofs;
		y := actor.y + yofs;
	end
	else
	begin
		// in relative mode negative y values mean 'left' and positive ones mean 'right'
		// This is the inverse orientation of the absolute mode!
		x := actor.x + FixedMul(xofs, finecosine[ang]) + FixedMul(yofs, finesine[ang]);
		y := actor.y + FixedMul(xofs, finesine[ang]) - FixedMul(yofs, finecosine[ang]);
	end;

	if (flags and SIXF_ABSOLUTEMOMENTUM) = 0 then
	begin
		// Same orientation issue here!
		newxmom := FixedMul(momx, finecosine[ang]) + FixedMul(momy, finesine[ang]);
		momy := FixedMul(momx, finesine[ang]) - FixedMul(momy, finecosine[ang]);
		momx := newxmom;
	end;

  mo := P_SpawnMobj(x, y, actor.z - actor.floorz + zofs, mobj_no);

  if mo <> nil then
  begin
    mo.momx := momx;
    mo.momy := momy;
    mo.momz := momz;
    mo.angle := ang1;
		if (flags and SIXF_TRANSFERAMBUSHFLAG) <> 0 then
      mo.flags := (mo.flags and not MF_AMBUSH) or (actor.flags and MF_AMBUSH);
	end;
end;

//==============================================================================
//
// Generic seeker missile function
//
// A_SeekerMissile(threshold: angle; turnMax: angle)
//
//==============================================================================
procedure A_SeekerMissile(actor: Pmobj_t);
begin
  if not P_CheckStateParams(actor) then
    exit;

  P_SeekerMissile(actor, actor.state.params.IntVal[0] * ANG1, actor.state.params.IntVal[1] * ANG1);
end;

//==============================================================================
//
// A_CStaffMissileSlither
//
//==============================================================================
procedure A_CStaffMissileSlither(actor: Pmobj_t);
var
  newX, newY: fixed_t;
  weaveXY: integer;
  angle: angle_t;
begin
  weaveXY := actor.bob;
  angle := (actor.angle + ANG90) shr ANGLETOFINESHIFT;
  newX := actor.x - FixedMul(finecosine[angle], FloatBobOffsets[weaveXY]);
  newY := actor.y - FixedMul(finesine[angle], FloatBobOffsets[weaveXY]);
  weaveXY := (weaveXY + 3) and 63;
  newX := newX + FixedMul(finecosine[angle], FloatBobOffsets[weaveXY]);
  newY := newY + FixedMul(finesine[angle], FloatBobOffsets[weaveXY]);
  P_TryMove(actor, newX, newY);
  actor.bob := weaveXY;
end;

//==============================================================================
//
// A_SetTranslucent
//
//==============================================================================
procedure A_SetTranslucent(actor: Pmobj_t);
begin
  if not P_CheckStateParams(actor) then
    exit;

  actor.alpha := actor.state.params.FixedVal[0];

  if actor.alpha <= 0 then
  begin
    actor.renderstyle := mrs_normal;
    actor.flags := actor.flags or MF_SHADOW;
    actor.alpha := 0;
  end
  else if actor.alpha >= FRACUNIT then
  begin
    actor.renderstyle := mrs_normal;
    actor.flags := actor.flags and not MF_SHADOW;
    actor.alpha := FRACUNIT;
  end
  else
    actor.renderstyle := mrs_translucent;
end;

//==============================================================================
//
// A_Die
//
//==============================================================================
procedure A_Die(actor: Pmobj_t);
begin
  actor.flags_ex := actor.flags_ex and not MF_EX_INVULNERABLE;  // Clear invulnerability flag
  P_DamageMobj(actor, nil, nil, actor.health);
end;

//==============================================================================
// A_CustomBulletAttack
//
// CustomBulletAttack(spread_xy, numbullets, damageperbullet, range)
//
//==============================================================================
procedure A_CustomBulletAttack(actor: Pmobj_t);
var
  spread_xy: angle_t;
  numbullets: integer;
  damageperbullet: integer;
  range: fixed_t;
  i: integer;
  angle, bangle: angle_t;
  slope: fixed_t;
  rnd: byte;
begin
  if not P_CheckStateParams(actor) then
    exit;

  if actor.target = nil then
    exit;

  spread_xy := round(actor.state.params.FloatVal[0] * ANG1);
  numbullets := actor.state.params.IntVal[1];
  damageperbullet := actor.state.params.IntVal[2];
  range := actor.state.params.FixedVal[3];

  if range <= 0 then
    range := MISSILERANGE;

  A_FaceTarget(actor);
  bangle := actor.angle;

  slope := P_AimLineAttack(actor, bangle, range);

  A_AttackSound(actor, actor);

  spread_xy := spread_xy div 256;
  for i := 0 to numbullets - 1 do
  begin
    rnd := N_Random;
    angle := bangle + 128 * spread_xy - rnd * spread_xy;
    P_LineAttack(actor, angle, range, slope, damageperbullet);
  end;
end;

//==============================================================================
// A_FadeOut
//
// FadeOut(reduce = 10%)
//
//==============================================================================
procedure A_FadeOut(actor: Pmobj_t);
var
  reduce: fixed_t;
begin
  reduce := FRACUNIT div 10;

  if actor.state.params <> nil then
    if actor.state.params.Count > 0 then
      reduce := actor.state.params.FixedVal[0];

  if actor.renderstyle = mrs_normal then
  begin
    actor.renderstyle := mrs_translucent;
    actor.alpha := FRACUNIT;
  end;

  actor.alpha := actor.alpha - reduce;
  if actor.alpha <= 0 then
    P_RemoveMobj(actor);
end;

//==============================================================================
// Do_FadeOut
//
// reduce -> percentage to reduce fading
//
//==============================================================================
procedure Do_FadeOut(actor: Pmobj_t; const reduce: integer);
begin
  if actor.renderstyle = mrs_normal then
  begin
    actor.renderstyle := mrs_translucent;
    actor.alpha := FRACUNIT;
  end;

  actor.alpha := actor.alpha - (reduce * FRACUNIT) div 100;
  if actor.alpha <= 0 then
    P_RemoveMobj(actor);
end;

//==============================================================================
//
// A_FadeOut10
//
//==============================================================================
procedure A_FadeOut10(actor: Pmobj_t);
begin
  Do_FadeOut(actor, 10);
end;

//==============================================================================
//
// A_FadeOut20
//
//==============================================================================
procedure A_FadeOut20(actor: Pmobj_t);
begin
  Do_FadeOut(actor, 20);
end;

//==============================================================================
//
// A_FadeOut30
//
//==============================================================================
procedure A_FadeOut30(actor: Pmobj_t);
begin
  Do_FadeOut(actor, 30);
end;

//==============================================================================
// A_FadeIn
//
// FadeIn(incriment = 10%)
//
//==============================================================================
procedure A_FadeIn(actor: Pmobj_t);
var
  incriment: fixed_t;
begin
  if actor.renderstyle = mrs_normal then
    exit;

  incriment := FRACUNIT div 10;

  if actor.state.params <> nil then
    if actor.state.params.Count > 0 then
      incriment := actor.state.params.FixedVal[0];

  actor.alpha := actor.alpha + incriment;
  if actor.alpha > FRACUNIT then
  begin
    actor.alpha := FRACUNIT;
    actor.renderstyle := mrs_normal;
  end;
end;

//==============================================================================
// Do_FadeIn
//
// incriment -> percentage to inscrease fading
//
//==============================================================================
procedure Do_FadeIn(actor: Pmobj_t; const incriment: integer);
begin
  actor.renderstyle := mrs_translucent;
  actor.alpha := actor.alpha + (incriment * FRACUNIT) div 100;
  if actor.alpha > FRACUNIT then
  begin
    actor.alpha := FRACUNIT;
    actor.renderstyle := mrs_normal
  end;
end;

//==============================================================================
//
// A_FadeIn10
//
//==============================================================================
procedure A_FadeIn10(actor: Pmobj_t);
begin
  Do_FadeIn(actor, 10);
end;

//==============================================================================
//
// A_FadeIn20
//
//==============================================================================
procedure A_FadeIn20(actor: Pmobj_t);
begin
  Do_FadeIn(actor, 20);
end;

//==============================================================================
//
// A_FadeIn30
//
//==============================================================================
procedure A_FadeIn30(actor: Pmobj_t);
begin
  Do_FadeIn(actor, 30);
end;

//==============================================================================
//
// A_MissileAttack(missilename = actor.info.missiletype)
//
//==============================================================================
procedure A_MissileAttack(actor: Pmobj_t);
var
  missile: Pmobj_t;
  mobj_no: integer;
begin
  mobj_no := actor.info.missiletype;

  if actor.state.params <> nil then
  begin
    if actor.state.params.IsComputed[0] then
      mobj_no := actor.state.params.IntVal[0]
    else
    begin
      mobj_no := Info_GetMobjNumForName(actor.state.params.StrVal[0]);
      actor.state.params.IntVal[0] := mobj_no;
    end;
    if mobj_no = -1 then
    begin
      I_Warning('A_MissileAttack(): Unknown missile %s'#13#10, [actor.state.params.StrVal[0]]);
      exit;
    end;
  end
  else if mobj_no <= 0 then
  begin
    I_Warning('A_MissileAttack(): Unknown missile'#13#10);
    exit;
  end;

  if mobjinfo[mobj_no].speed < 256 then
    mobjinfo[mobj_no].speed := mobjinfo[mobj_no].speed * FRACUNIT;  // JVAL fix me!!!

  actor.z := actor.z;
  missile := P_SpawnMissile(actor, actor.target, mobj_no);
  actor.z := actor.z;

  if missile <> nil then
  begin
    if missile.info.flags_ex and MF_EX_SEEKERMISSILE <> 0 then
      missile.tracer := actor.target;
  end;

end;

//==============================================================================
//
// A_AdjustSideSpot(sideoffset: float)
//
//==============================================================================
procedure A_AdjustSideSpot(actor: Pmobj_t);
var
  offs: fixed_t;
  ang: angle_t;
  x, y: fixed_t;
begin
  if not P_CheckStateParams(actor, 1) then
    exit;

  offs := actor.state.params.Fixedval[0];

  ang := actor.angle shr ANGLETOFINESHIFT;

  x := FixedMul(offs, finecosine[ang]);
  y := FixedMul(offs, finesine[ang]);

  actor.x := actor.x + x;
  actor.y := actor.y + y;
end;

//==============================================================================
//
// A_Countdown(void)
//
//==============================================================================
procedure A_Countdown(actor: Pmobj_t);
begin
  dec(actor.reactiontime);
  if actor.reactiontime <= 0 then
  begin
    P_ExplodeMissile(actor);
    actor.flags := actor.flags and not MF_SKULLFLY;
  end;
end;

//==============================================================================
//
// A_FastChase
//
//==============================================================================
procedure A_FastChase(actor: Pmobj_t);
begin
  P_DoChase(actor, true);
end;

//==============================================================================
//
// JVAL
// A_ThrustZ(momz: float)
// Changes z momentum
//
//==============================================================================
procedure A_ThrustZ(actor: Pmobj_t);
begin
  if not P_CheckStateParams(actor, 1) then
    exit;

  actor.momz := actor.momz + actor.state.params.FixedVal[0];
end;

//==============================================================================
//
// A_ThrustZ5
//
//==============================================================================
procedure A_ThrustZ5(actor: Pmobj_t);
begin
  actor.momz := actor.momz + 5 * FRACUNIT;
end;

//==============================================================================
//
// A_ThrustZ10
//
//==============================================================================
procedure A_ThrustZ10(actor: Pmobj_t);
begin
  actor.momz := actor.momz + 10 * FRACUNIT;
end;

//==============================================================================
//
// JVAL
// A_ThrustXY(momz: float)
// Changes x, y momentum
//
//==============================================================================
procedure A_ThrustXY(actor: Pmobj_t);
var
  ang: angle_t;
  thrust: fixed_t;
begin
  if not P_CheckStateParams(actor, 1) then
    exit;

  thrust := actor.state.params.FixedVal[0];

  ang := actor.angle;
  ang := ang shr ANGLETOFINESHIFT;

  actor.momx := actor.momx + FixedMul(thrust, finecosine[ang]);
  actor.momy := actor.momy + FixedMul(thrust, finesine[ang]);
end;

//==============================================================================
//
// JVAL
// A_Turn(angle: float)
// Changes the actor's angle
//
//==============================================================================
procedure A_Turn(actor: Pmobj_t);
var
  ang: angle_t;
begin
  if not P_CheckStateParams(actor, 1) then
    exit;

  ang := round(actor.state.params.FloatVal[0] * ANG1);
  actor.angle := actor.angle + ang;
end;

//==============================================================================
//
// A_Turn5
//
//==============================================================================
procedure A_Turn5(actor: Pmobj_t);
var
  ang: angle_t;
begin
  ang := 5 * ANG1;
  actor.angle := actor.angle + ang;
end;

//==============================================================================
//
// A_Turn10
//
//==============================================================================
procedure A_Turn10(actor: Pmobj_t);
var
  ang: angle_t;
begin
  ang := 10 * ANG1;
  actor.angle := actor.angle + ang;
end;

//==============================================================================
//
// JVAL
// A_JumpIfCloser(distancetotarget: float, offset: integer)
// Jump conditionally to another state if distance to target is closer to first parameter
//
//==============================================================================
procedure A_JumpIfCloser(actor: Pmobj_t);
var
  dist: fixed_t;
  target: Pmobj_t;
  offset: integer;
  cur: integer;
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  if actor.player = nil then
    target := actor.target
  else
  begin
    // Does the player aim at something that can be shot?
    P_BulletSlope(actor);
    target := linetarget;
  end;

  // No target - no jump
  if target = nil then
    exit;

  dist := actor.state.params.FixedVal[0];
  if P_AproxDistance(actor.x - target.x, actor.y - target.y) < dist then
  begin
    offset := actor.state.params.IntVal[1];
    cur := (integer(actor.state) - integer(states)) div SizeOf(state_t);
    P_SetMobjState(actor, statenum_t(cur + offset));
  end;
end;

//==============================================================================
//
// JVAL
// A_JumpIfHealthLower(health: integer; offset: integer)
// Jump conditionally to another state if health is lower to first parameter
//
//==============================================================================
procedure A_JumpIfHealthLower(actor: Pmobj_t);
var
  offset: integer;
  cur: integer;
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  if actor.health < actor.state.params.IntVal[0] then
  begin
    offset := actor.state.params.IntVal[1];
    cur := (integer(actor.state) - integer(states)) div SizeOf(state_t);
    P_SetMobjState(actor, statenum_t(cur + offset));
  end;
end;

//==============================================================================
//
// A_ScreamAndUnblock
//
//==============================================================================
procedure A_ScreamAndUnblock(actor: Pmobj_t);
begin
  A_Scream(actor);
  A_NoBlocking(actor);
end;

//==============================================================================
//
// A_SetInvulnerable
//
//==============================================================================
procedure A_SetInvulnerable(actor: Pmobj_t);
begin
  actor.flags_ex := actor.flags_ex or MF_EX_INVULNERABLE;
end;

//==============================================================================
//
// A_UnSetInvulnerable
//
//==============================================================================
procedure A_UnSetInvulnerable(actor: Pmobj_t);
begin
  actor.flags_ex := actor.flags_ex and not MF_EX_INVULNERABLE;
end;

//==============================================================================
//
// A_FloatBob
//
//==============================================================================
procedure A_FloatBob(actor: Pmobj_t);
begin
  actor.flags_ex := actor.flags_ex or MF_EX_FLOATBOB;
end;

//==============================================================================
//
// A_NoFloatBob
//
//==============================================================================
procedure A_NoFloatBob(actor: Pmobj_t);
begin
  actor.flags_ex := actor.flags_ex and not MF_EX_FLOATBOB;
end;

//==============================================================================
//
// A_Missile
//
//==============================================================================
procedure A_Missile(actor: Pmobj_t);
begin
  actor.flags := actor.flags or MF_MISSILE;
end;

//==============================================================================
//
// A_NoMissile
//
//==============================================================================
procedure A_NoMissile(actor: Pmobj_t);
begin
  actor.flags := actor.flags and not MF_MISSILE;
end;

//==============================================================================
//
// A_ComboAttack(void)
//
//==============================================================================
procedure A_ComboAttack(actor: Pmobj_t);
var
  missile: Pmobj_t;
  mobj_no: integer;
begin
  A_FaceTarget(actor);

  if P_CheckMeleeRange(actor) then
  begin
    A_MeleeSound(actor, actor);
    P_DamageMobj(actor.target, actor, actor, actor.info.meleedamage);
  end
  else
  begin
    mobj_no := actor.info.missiletype;

    if mobj_no <= 0 then
      exit;

    if mobjinfo[mobj_no].speed < 256 then
      mobjinfo[mobj_no].speed := mobjinfo[mobj_no].speed * FRACUNIT;  // JVAL fix me!!!

    actor.z := actor.z;
    missile := P_SpawnMissile(actor, actor.target, mobj_no);
    actor.z := actor.z;

    if missile <> nil then
    begin
      if missile.info.flags_ex and MF_EX_SEEKERMISSILE <> 0 then
        missile.tracer := actor.target;
    end;
  end;
end;

//==============================================================================
//
// A_BulletAttack(numbullets: integer [optional])
//
//==============================================================================
procedure A_BulletAttack(actor: Pmobj_t);
var
  i: integer;
  angle, bangle: angle_t;
  slope: fixed_t;
  damage: integer;
  numbullets: integer;
begin
  if actor.target = nil then
    exit;

  A_FaceTarget(actor);
  bangle := actor.angle;

  slope := P_AimLineAttack(actor, bangle, MISSILERANGE);

  A_AttackSound(actor, actor);

// Attack with a customizable amount of bullets (specified in damage)
  numbullets := actor.info.damage;
// If parameter specified, then use parameter as custom number of bullets
  if actor.state.params <> nil then
    if actor.state.params.Count = 1 then
      numbullets := actor.state.params.IntVal[0];

  for i := 0 to numbullets - 1 do
  begin
    angle := bangle + _SHLW(P_Random - P_Random, 20);
    damage := ((P_Random mod 5) + 1) * 3;
    P_LineAttack(actor, angle, MISSILERANGE, slope, damage);
  end;
end;

//==============================================================================
// A_MediumGravity
//
// JVAL
// Medium gravity
//
//==============================================================================
procedure A_MediumGravity(actor: Pmobj_t);
begin
  actor.flags := actor.flags and (not MF_NOGRAVITY);
  actor.flags_ex := actor.flags_ex and (not MF_EX_LOWGRAVITY);
  actor.flags2_ex := actor.flags2_ex or MF2_EX_MEDIUMGRAVITY;
end;

//=============================================================================
//
// P_DoNewChaseDir
//
// killough 9/8/98:
//
// Most of P_NewChaseDir(), except for what
// determines the new direction to take
//
//=============================================================================

const
  opposite: array[0..8] of dirtype_t = (
    DI_WEST, DI_SOUTHWEST, DI_SOUTH, DI_SOUTHEAST,
    DI_EAST, DI_NORTHEAST, DI_NORTH, DI_NORTHWEST, DI_NODIR
  );

  diags: array[0..3] of dirtype_t = (
    DI_NORTHWEST, DI_NORTHEAST, DI_SOUTHWEST, DI_SOUTHEAST
  );

//==============================================================================
//
// P_DoNewChaseDir
//
//==============================================================================
procedure P_DoNewChaseDir(actor: Pmobj_t; deltax, deltay: fixed_t);
var
  d: array[0..2] of dirtype_t;
  dt: dirtype_t;
  tdir: integer;
  olddir, turnaround: dirtype_t;
begin
  olddir := dirtype_t(actor.movedir);
  turnaround := opposite[Ord(olddir)];

  if deltax > 10 * FRACUNIT then
    d[1] := DI_EAST
  else if deltax < -10 * FRACUNIT then
    d[1] := DI_WEST
  else
    d[1] := DI_NODIR;

  if deltay < -10 * FRACUNIT then
    d[2] := DI_SOUTH
  else if deltay > 10 * FRACUNIT then
    d[2] := DI_NORTH
  else
    d[2] := DI_NODIR;

  // try direct route
  if (d[1] <> DI_NODIR) and (d[2] <> DI_NODIR) then
  begin
    actor.movedir := Ord(diags[(intval(deltay < 0) shl 1) + intval(deltax > 0)]);
    if (actor.movedir <> Ord(turnaround)) and P_TryWalk(actor) then
      exit;
  end;

  // try other directions
  if (N_Random > 200) or (abs(deltay) > abs(deltax)) then
  begin
    dt := d[1];
    d[1] := d[2];
    d[2] := dt;
  end;

  if d[1] = turnaround then
    d[1] := DI_NODIR;
  if d[2] = turnaround then
    d[2] := DI_NODIR;

  if d[1] <> DI_NODIR then
  begin
    actor.movedir := Ord(d[1]);
    if P_TryWalk(actor) then
      exit; // either moved forward or attacked
  end;

  if d[2] <> DI_NODIR then
  begin
    actor.movedir := Ord(d[2]);
    if P_TryWalk(actor) then
      exit;
  end;

  // there is no direct path to the player, so pick another direction.
  if olddir <> DI_NODIR then
  begin
    actor.movedir := Ord(olddir);
    if P_TryWalk(actor) then
      exit;
  end;

  // randomly determine direction of search
  if N_Random and 1 <> 0 then
  begin
    for tdir := Ord(DI_EAST) to Ord(DI_SOUTHEAST) do
    begin
      if tdir <> Ord(turnaround) then
      begin
        actor.movedir := tdir;
        if P_TryWalk(actor) then
          exit;
      end;
    end;
  end
  else
  begin
    for tdir := Ord(DI_SOUTHEAST) downto Ord(DI_EAST) - 1 do
    begin
      if tdir <> Ord(turnaround) then
      begin
        actor.movedir := tdir;
        if P_TryWalk(actor) then
          exit;
      end;
    end;
  end;

  if turnaround <> DI_NODIR then
  begin
    actor.movedir := Ord(turnaround);
    if P_TryWalk(actor) then
      exit;
  end;

  actor.movedir := Ord(DI_NODIR);  // can not move
end;

//=============================================================================
//
// P_RandomChaseDir
//
//=============================================================================
//
//==============================================================================
procedure P_RandomChaseDir(actor: Pmobj_t);
var
  turndir, tdir: integer;
  olddir: integer;
  turnaround: dirtype_t;
begin
  olddir := actor.movedir;
  turnaround := opposite[olddir];

  // If the actor elects to continue in its current direction, let it do
  // so unless the way is blocked. Then it must turn.
  if N_Random < 150 then
  begin
    if P_TryWalk(actor) then
      exit;
  end;

  turndir := 1 - 2 * (N_Random and 1);

  if olddir = Ord(DI_NODIR) then
    olddir := N_Random and 7;

  tdir := (Ord(olddir) + turndir) and 7;
  while tdir <> olddir do
  begin
    if tdir <> Ord(turnaround) then
    begin
      actor.movedir := tdir;
      if P_TryWalk(actor) then
        exit;
    end;
    tdir := (tdir + turndir) and 7;
  end;

  if turnaround <> DI_NODIR then
  begin
    actor.movedir := Ord(turnaround);
    if P_TryWalk(actor) then
    begin
      actor.movecount := N_Random and 15;
      exit;
    end;
  end;

  actor.movedir := Ord(DI_NODIR);  // cannot move
end;

//==============================================================================
//
// A_Wander
//
//==============================================================================
procedure A_Wander(actor: Pmobj_t);
var
  delta: integer;
begin
  // modify target threshold
  if actor.threshold <> 0 then
    actor.threshold := actor.threshold - 1;

  // turn towards movement direction if not there yet
  if actor.movedir < 8 then
  begin
    actor.angle := actor.angle and $E0000000;
    delta := actor.angle - _SHLW(actor.movedir, 29);

    if delta > 0 then
      actor.angle := actor.angle - ANG45
    else if delta < 0 then
      actor.angle := actor.angle + ANG45;
  end;

  dec(actor.movecount);
  if (actor.movecount < 0) or P_Move(actor) then
  begin
    P_RandomChaseDir(actor);
    actor.movecount := actor.movecount + 5;
  end;
end;

//==============================================================================
//
// PROC A_HideThing
//
//==============================================================================
procedure A_HideThing(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex or MF2_EX_DONTDRAW;
end;

//==============================================================================
//
// A_UnHideThing
//
//==============================================================================
procedure A_UnHideThing(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex and not MF2_EX_DONTDRAW;
end;

//==============================================================================
//
// A_SpawnDebris(mobj_no, count, mult_h, mult_v
//
//==============================================================================
procedure A_SpawnDebris(actor: Pmobj_t);
var
  i, count: integer;
  mult_h, mult_v: fixed_t;
  mobj_no: integer;
  mo: Pmobj_t;
begin
  if not P_CheckStateParams(actor) then
    exit;

  if actor.state.params.IsComputed[0] then
    mobj_no := actor.state.params.IntVal[0]
  else
  begin
    mobj_no := Info_GetMobjNumForName(actor.state.params.StrVal[0]);
    actor.state.params.IntVal[0] := mobj_no;
  end;

  count := actor.state.params.IntVal[1];
  if count <= 0 then count := 1;

  mult_h := actor.state.params.IntVal[2];
  if mult_h <= 0 then mult_h := FRACUNIT;

  mult_v := actor.state.params.IntVal[3];
  if mult_v <= 0 then mult_v := FRACUNIT;

  for i := 0 to count - 1 do
  begin
    mo := P_SpawnMobj(actor.x + ((N_Random - 128) shr 12),
			                actor.y + ((N_Random - 128) shr 12),
			                actor.z + ((N_Random * actor.height) div 256), mobj_no);
    if mo <> nil then
    begin
			mo.momz := FixedMul(mult_v, ((N_Random and 7) + 5) * FRACUNIT);
			mo.momx := FixedMul(mult_h, (N_Random - N_Random) shl (FRACBITS - 6));
			mo.momy := FixedMul(mult_h, (N_Random - N_Random) shl (FRACBITS - 6));
    end;
  end;
end;

//==============================================================================
//
// A_SpawnSmokeUp
//
//==============================================================================
procedure A_SpawnSmokeUp(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, ONFLOORZ, Ord(MT_LAVASMOKE));
  mo.momz := FRACUNIT + (P_Random * 128);
//  S_StartSound(mo, Ord(sfx_burn));
end;

//==============================================================================
//
// A_SpawnSmokeDown
//
//==============================================================================
procedure A_SpawnSmokeDown(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, ONCEILINGZ, Ord(MT_LAVASMOKE));
  mo.momz := -2 * FRACUNIT + (P_Random * 128);
//  S_StartSound(mo, Ord(sfx_burn));
end;

//==============================================================================
//
// A_SpawnSmokeMiddle
//
//==============================================================================
procedure A_SpawnSmokeMiddle(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, ONFLOATZ, Ord(MT_LAVASMOKE));
  mo.momz := -FRACUNIT + (P_Random * 128);
//  S_StartSound(mo, Ord(sfx_burn));
end;

//==============================================================================
//
// A_SpawnSmokeHorz48
//
//==============================================================================
procedure A_SpawnSmokeHorz48(actor: Pmobj_t);
var
  mo: Pmobj_t;
  an: angle_t;
  speed: fixed_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 48 * FRACUNIT, Ord(MT_LAVASMOKE));
  an := actor.angle shr ANGLETOFINESHIFT;
  speed := (5 - (N_Random mod 3)) * FRACUNIT;
  mo.momx := FixedMul(speed, finecosine[an]);
  mo.momy := FixedMul(speed, finesine[an]);
end;

//==============================================================================
//
// A_SpawnSmokeHorz
//
//==============================================================================
procedure A_SpawnSmokeHorz(actor: Pmobj_t);
var
  mo: Pmobj_t;
  an: angle_t;
  speed: fixed_t;
  height: integer;
begin
  if not P_CheckStateParams(actor) then
    exit;

  height := actor.state.params.IntVal[0];

  mo := P_SpawnMobj(actor.x, actor.y, actor.z + height * FRACUNIT, Ord(MT_LAVASMOKE));
  an := actor.angle shr ANGLETOFINESHIFT;
  speed := (5 - (N_Random mod 3)) * FRACUNIT;
  mo.momx := FixedMul(speed, finecosine[an]);
  mo.momy := FixedMul(speed, finesine[an]);
end;

//==============================================================================
//
// A_DesidePlayerWalkFrame
//
//==============================================================================
procedure A_DesidePlayerWalkFrame(actor: Pmobj_t);
var
  x, y: double;
begin
  if actor.player = nil then
    exit;

  if actor.health <= 0 then
    exit;

  x := actor.momx / FRACUNIT;
  x := x * x;
  y := actor.momy / FRACUNIT;
  y := y * y;
  if x + y > 32 then
    P_SetMobjState(actor, S_PLAY_RUNFAST1)
  else
    P_SetMobjState(actor, S_PLAY_RUN1);

end;

//==============================================================================
//
// A_Speak
//
//==============================================================================
procedure A_Speak(actor: Pmobj_t);
begin
  if not P_CheckStateParams(actor) then
    exit;
  // JVAL: not implement :(
end;

// JVAL
// A_ComicBubble(dialogdef);
//
//==============================================================================
procedure A_ComicBubble(actor: Pmobj_t);
var
  dlg_id: integer;
  idx: integer;
begin
  if actor.flags2_ex and MF2_EX_DOCOMICBUBBLES = 0 then
    exit;

  if not P_CheckStateParams(actor) then
    exit;

  idx := N_Random mod actor.state.params.Count;
  if actor.state.params.IsComputed[idx] then
    dlg_id := actor.state.params.IntVal[idx]
  else
  begin
    dlg_id := CM_DialogID(actor.state.params.StrVal[idx]);
    actor.state.params.IntVal[idx] := dlg_id;
  end;

  if dlg_id >= 0 then
    CM_ExecComicDialog(actor, dlg_id);
end;

//==============================================================================
//
// A_ComicBubbleOnce
//
//==============================================================================
procedure A_ComicBubbleOnce(actor: Pmobj_t);
var
  dlg_id: integer;
  idx: integer;
begin
  if actor.flags2_ex and MF2_EX_DOCOMICBUBBLES = 0 then
    exit;

  if not P_CheckStateParams(actor) then
    exit;

  idx := N_Random mod actor.state.params.Count;
  if actor.state.params.IsComputed[idx] then
    dlg_id := actor.state.params.IntVal[idx]
  else
  begin
    dlg_id := CM_DialogID(actor.state.params.StrVal[idx]);
    actor.state.params.IntVal[idx] := dlg_id;
  end;

  if dlg_id >= 0 then
  begin
    CM_ExecComicDialog(actor, dlg_id);
    actor.flags2_ex := actor.flags2_ex and (not MF2_EX_DOCOMICBUBBLES);
  end;
end;

//==============================================================================
//
// A_TargetComicBubble
//
//==============================================================================
procedure A_TargetComicBubble(actor: Pmobj_t);
var
  dlg_id: integer;
  idx: integer;
begin
  if actor.flags2_ex and MF2_EX_DOCOMICBUBBLES = 0 then
    exit;

  if not P_CheckStateParams(actor) then
    exit;

  if actor.target = nil then
    exit;

  idx := N_Random mod actor.state.params.Count;
  if actor.state.params.IsComputed[idx] then
    dlg_id := actor.state.params.IntVal[idx]
  else
  begin
    dlg_id := CM_DialogID(actor.state.params.StrVal[idx]);
    actor.state.params.IntVal[idx] := dlg_id;
  end;

  if dlg_id >= 0 then
    CM_ExecComicDialog(actor.target, dlg_id);
end;

//==============================================================================
//
// A_SetInteractive
//
//==============================================================================
procedure A_SetInteractive(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex or MF2_EX_INTERACTIVE;
end;

//==============================================================================
//
// A_UnSetInteractive
//
//==============================================================================
procedure A_UnSetInteractive(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex and not MF2_EX_INTERACTIVE;
end;

//==============================================================================
//
// A_DoComicBubbles
//
//==============================================================================
procedure A_DoComicBubbles(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex or MF2_EX_DOCOMICBUBBLES;
end;

//==============================================================================
//
// A_NoComicBubbles
//
//==============================================================================
procedure A_NoComicBubbles(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex and not MF2_EX_DOCOMICBUBBLES;
end;

//==============================================================================
//
// A_SetMonsterInfight
//
//==============================================================================
procedure A_SetMonsterInfight(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex or MF2_EX_DONTINFIGHTMONSTERS;
end;

//==============================================================================
//
// A_UnSetMonsterInfight
//
//==============================================================================
procedure A_UnSetMonsterInfight(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex and not MF2_EX_DONTINFIGHTMONSTERS;
end;

//==============================================================================
//
// A_NoiseAlert
//
//==============================================================================
procedure A_NoiseAlert(actor: Pmobj_t);
begin
  if actor.target = nil then
    exit;
  if actor.target.player = nil then
    exit;

  P_NoiseAlert(actor.target, actor);
end;

//==============================================================================
//
// A_ConsoleCommand
//
//==============================================================================
procedure A_ConsoleCommand(actor: Pmobj_t);
var
  cmd: string;
  i: integer;
begin
  if not P_CheckStateParams(actor) then
    exit;

  cmd := actor.state.params.StrVal[0];
  for i := 1 to actor.state.params.Count - 1 do
    cmd := cmd + ' ' + actor.state.params.StrVal[i];

  C_AddCommand(cmd);
end;

//==============================================================================
//
// A_SetCustomParam
//
//==============================================================================
procedure A_SetCustomParam(actor: Pmobj_t);
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  P_SetMobjCustomParam(actor, actor.state.params.StrVal[0], actor.state.params.IntVal[1]);
end;

//==============================================================================
//
// A_AddCustomParam
//
//==============================================================================
procedure A_AddCustomParam(actor: Pmobj_t);
var
  parm: Pmobjcustomparam_t;
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  parm := P_GetMobjCustomParam(actor, actor.state.params.StrVal[0]);
  if parm = nil then
    P_SetMobjCustomParam(actor, actor.state.params.StrVal[0], actor.state.params.IntVal[1])
  else
    P_SetMobjCustomParam(actor, actor.state.params.StrVal[0], parm.value + actor.state.params.IntVal[1])
end;

//==============================================================================
//
// A_RemoveCustomParam
//
//==============================================================================
procedure A_RemoveCustomParam(actor: Pmobj_t);
var
  parm: Pmobjcustomparam_t;
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  parm := P_GetMobjCustomParam(actor, actor.state.params.StrVal[0]);
  if parm <> nil then
  begin
    P_SetMobjCustomParam(actor, actor.state.params.StrVal[0], parm.value + actor.state.params.IntVal[1]);
    if parm.value < 0 then
      parm.value := 0;
  end;
end;

//==============================================================================
//
// A_SetTargetCustomParam
//
//==============================================================================
procedure A_SetTargetCustomParam(actor: Pmobj_t);
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  if actor.target = nil then
    exit;

  P_SetMobjCustomParam(actor.target, actor.state.params.StrVal[0], actor.state.params.IntVal[1]);
end;

//==============================================================================
//
// A_AddTargetCustomParam
//
//==============================================================================
procedure A_AddTargetCustomParam(actor: Pmobj_t);
var
  parm: Pmobjcustomparam_t;
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  if actor.target = nil then
    exit;

  parm := P_GetMobjCustomParam(actor.target, actor.state.params.StrVal[0]);
  if parm = nil then
    P_SetMobjCustomParam(actor.target, actor.state.params.StrVal[0], actor.state.params.IntVal[1])
  else
    P_SetMobjCustomParam(actor.target, actor.state.params.StrVal[0], parm.value + actor.state.params.IntVal[1])
end;

//==============================================================================
//
// A_RemoveTargetCustomParam
//
//==============================================================================
procedure A_RemoveTargetCustomParam(actor: Pmobj_t);
var
  parm: Pmobjcustomparam_t;
begin
  if not P_CheckStateParams(actor, 2) then
    exit;

  if actor.target = nil then
    exit;

  parm := P_GetMobjCustomParam(actor.target, actor.state.params.StrVal[0]);
  if parm <> nil then
  begin
    P_SetMobjCustomParam(actor.target, actor.state.params.StrVal[0], parm.value + actor.state.params.IntVal[1]);
    if parm.value < 0 then
      parm.value := 0;
  end;
end;

//==============================================================================
//
// A_PlayerFaceMe
//
//==============================================================================
procedure A_PlayerFaceMe(actor: Pmobj_t);
begin
  if not P_CheckStateParams(actor, 1) then
    exit;

  if actor.target = nil then
    Exit;

  if actor.target.player = nil then
    Exit;

  P_PlayerFaceMobj(actor.target.player, actor, actor.state.params.IntVal[0]);
end;

end.

