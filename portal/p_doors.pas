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

unit p_doors;

interface

uses
  z_zone,
  gamedef,
  p_mobj_h,
  p_spec,
  r_defs,
  s_sound,
  sounds;

//==============================================================================
//
// T_VerticalDoor
//
//==============================================================================
procedure T_VerticalDoor(door: Pvldoor_t);

//==============================================================================
//
// EV_DoLockedDoor
//
//==============================================================================
function EV_DoLockedDoor(line: Pline_t; _type: vldoor_e; thing: Pmobj_t): integer;

//==============================================================================
//
// EV_DoDoor
//
//==============================================================================
function EV_DoDoor(line: Pline_t; _type: vldoor_e): integer;

//==============================================================================
//
// EV_VerticalDoor
//
//==============================================================================
procedure EV_VerticalDoor(line: Pline_t; thing: Pmobj_t);

//==============================================================================
//
// P_SpawnDoorCloseIn30
//
//==============================================================================
procedure P_SpawnDoorCloseIn30(sec: Psector_t);

//==============================================================================
//
// P_SpawnDoorRaiseIn5Mins
//
//==============================================================================
procedure P_SpawnDoorRaiseIn5Mins(sec: Psector_t; secnum: integer);

implementation

uses
  d_player,
  g_game,
  cm_main,
  m_fixed,
  p_genlin,
  p_lights,
  p_tick,
  p_setup,
  p_floor;

//==============================================================================
//
// VERTICAL DOORS
//
// T_VerticalDoor
//
//==============================================================================
procedure T_VerticalDoor(door: Pvldoor_t);
var
  res: result_e;
begin
  case door.direction of
    0:
      begin
  // WAITING
        dec(door.topcountdown);
        if door.topcountdown = 0 then
        begin
          case door._type of
            blazeRaise,
            genBlazeRaise:
              begin
                door.direction := -1; // time to go back down
                S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_bdcls));
              end;
            normal,
            genRaise:
              begin
                door.direction := -1; // time to go back down
                S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_dorcls));
              end;
            close30ThenOpen,
            genCdO:
              begin
                door.direction := 1;
                S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_doropn));
              end;
            genBlazeCdO:
              begin
                door.direction := 1;
                S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_bdopn));
              end;
          end;
        end;
      end;
    2:
      begin
  //  INITIAL WAIT
        dec(door.topcountdown);
        if door.topcountdown = 0 then
        begin
          case door._type of
            raiseIn5Mins:
              begin
                door.direction := 1;
                door._type := normal;
                S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_doropn));
              end;
          end;
        end;
      end;

   -1:
      begin
  // DOWN
        res := T_MovePlane(door.sector, door.speed, door.sector.floorheight,
                  false, 1, door.direction);
        if res = pastdest then
        begin
          case door._type of
            blazeRaise,
            blazeClose,
            genBlazeRaise,
            genBlazeClose:
              begin
                door.sector.ceilingdata := nil;
                P_RemoveThinker(@door.thinker); // unlink and free
                if compatibilitymode then
                  S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_bdcls));
              end;
            normal,
            close,
            genRaise,
            genClose:
              begin
                door.sector.ceilingdata := nil;
                P_RemoveThinker(@door.thinker);  // unlink and free
              end;
            close30ThenOpen:
              begin
                door.direction := 0;
                door.topcountdown := TICRATE * 30;
              end;
            genCdO,
            genBlazeCdO:
              begin
                door.direction := 0;
                door.topcountdown := door.topwait; // jff 5/8/98 insert delay
              end;
          end;

          if not compatibilitymode then
            if door.line <> nil then
              if door.line.tag <> 0 then
              begin
                if (door.line.special > CGENLOCKEDBASE) and
                   (door.line.special and 6 = 6) then //jff 3/9/98 all manual doors
                  EV_TurnTagLightsOff(door.line)
                else
                  case door.line.special of
                    1,
                    26,
                    27,
                    28,
                    31,
                    32,
                    33,
                    34,
                    117,
                    118,
                    300,
                    301:
                      EV_TurnTagLightsOff(door.line);
                  end;
              end;
        end
        else if res = crushed then
        begin
          case door._type of
            blazeClose,
            close,    // DO NOT GO BACK UP!
            genBlazeClose,
            genClose:
              begin
              end;
          else
            begin
              door.direction := 1;
              S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_doropn));
            end;
          end;
        end;
      end;
    1:
      begin
  // UP
        res := T_MovePlane(door.sector, door.speed, door.topheight,
                  false, 1, door.direction);
        if res = pastdest then
        begin
          case door._type of
            blazeRaise,
            normal,
            genRaise,
            genBlazeRaise:
              begin
                door.direction := 0; // wait at top
                door.topcountdown := door.topwait;
              end;
            close30ThenOpen,
            blazeOpen,
            open,
            genBlazeOpen,
            genOpen,
            genCdO,
            genBlazeCdO:
              begin
                door.sector.ceilingdata := nil;
                P_RemoveThinker(@door.thinker); // unlink and free
              end;
          end;

          if not compatibilitymode then
            if door.line <> nil then
              if door.line.tag <> 0 then
              begin
                if (door.line.special > CGENLOCKEDBASE) and
                   (door.line.special and 6 = 6) then //jff 3/9/98 all manual doors
                  EV_LightTurnOn(door.line, 0)
                else
                  case door.line.special of
                    1,
                    26,
                    27,
                    28,
                    31,
                    32,
                    33,
                    34,
                    117,
                    118,
                    300,
                    301:
                      EV_LightTurnOn(door.line, 0);
                  end;
              end;

        end;
      end;
  end;
end;

//==============================================================================
//
// EV_DoLockedDoor
// Move a locked door up/down
//
//==============================================================================
function EV_DoLockedDoor(line: Pline_t; _type: vldoor_e; thing: Pmobj_t): integer;
var
  p: Pplayer_t;
begin
  p := thing.player;

  // only players can open locked doors
  if p = nil then
  begin
    result := 0;
    exit;
  end;

  case line.special of
    99,  // Blue Lock
   133:
      begin
        if (not p.cards[Ord(it_bluecard)]) and
           (not p.cards[Ord(it_blueskull)]) then
        begin
//          p._message := PD_BLUEO;
          if p.mo <> nil then
            CM_ExecComicDialog(p.mo, CM_DialogID('hero/door_b'));
          S_StartSound(nil, Ord(sfx_oof));
          result := 0;
          exit;
        end;
      end;

   134, // Red Lock
   135:
      begin
        if (not p.cards[Ord(it_redcard)]) and
           (not p.cards[Ord(it_redskull)]) then
        begin
//          p._message := PD_REDO;
          if p.mo <> nil then
            CM_ExecComicDialog(p.mo, CM_DialogID('hero/door_r'));
          S_StartSound(nil, Ord(sfx_oof));
          result := 0;
          exit;
        end;
      end;

   136,  // Yellow Lock
   137:
      begin
        if (not p.cards[Ord(it_yellowcard)]) and
           (not p.cards[Ord(it_yellowskull)]) then
        begin
//          p._message := PD_YELLOWO;
          if p.mo <> nil then
            CM_ExecComicDialog(p.mo, CM_DialogID('hero/door_y'));
          S_StartSound(nil, Ord(sfx_oof));
          result := 0;
          exit;
        end;
      end;
  end;

  result := EV_DoDoor(line, _type);
end;

//==============================================================================
//
// EV_DoDoor
//
//==============================================================================
function EV_DoDoor(line: Pline_t; _type: vldoor_e): integer;
var
  initial: boolean;
  secnum: integer;
  sec: Psector_t;
  door: Pvldoor_t;
begin
  secnum := -1;
  result := 0;

  initial := true;
  while (secnum >= 0) or initial do
  begin
    initial := false;
    secnum := P_FindSectorFromLineTag(line, secnum);
    if secnum < 0 then
      break;

    sec := @sectors[secnum];
    if P_SectorActive(ceiling_special, sec) then
      continue;

    // new door thinker
    result := 1;
    door := Z_Malloc(SizeOf(vldoor_t), PU_LEVSPEC, nil);
    P_AddThinker(@door.thinker);
    sec.ceilingdata := door;

    door.thinker._function.acp1 := @T_VerticalDoor;
    door.sector := sec;
    door._type := _type;
    door.topwait := VDOORWAIT;
    door.speed := VDOORSPEED;
    door.line := nil;

    case _type of
      blazeClose:
        begin
          door.topheight := P_FindLowestCeilingSurrounding(sec);
          door.topheight := door.topheight - 4 * FRACUNIT;
          door.direction := -1;
          door.speed := VDOORSPEED * 4;
          S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_bdcls));
        end;

      close:
        begin
          door.topheight := P_FindLowestCeilingSurrounding(sec);
          door.topheight := door.topheight - 4 * FRACUNIT;
          door.direction := -1;
          S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_dorcls));
        end;

      close30ThenOpen:
        begin
          door.topheight := sec.ceilingheight;
          door.direction := -1;
          S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_dorcls));
        end;

      blazeRaise,
      blazeOpen:
        begin
          door.direction := 1;
          door.topheight := P_FindLowestCeilingSurrounding(sec);
          door.topheight := door.topheight - 4 * FRACUNIT;
          door.speed := VDOORSPEED * 4;
          if door.topheight <> sec.ceilingheight then
            S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_bdopn));
        end;

      normal,
      open:
        begin
          door.direction := 1;
          door.topheight := P_FindLowestCeilingSurrounding(sec);
          door.topheight := door.topheight - 4 * FRACUNIT;
          if door.topheight <> sec.ceilingheight then
            S_StartSound(Pmobj_t(@door.sector.soundorg), Ord(sfx_doropn));
        end;
    end;
  end;
end;

//==============================================================================
//
// EV_VerticalDoor : open a door manually, no tag value
//
//==============================================================================
procedure EV_VerticalDoor(line: Pline_t; thing: Pmobj_t);
var
  player: Pplayer_t;
  sec: Psector_t;
  door: Pvldoor_t;
begin
  // Check for locks
  player := thing.player;

  case line.special of
    26, // Blue Lock
    32:
      begin
        if player = nil then
          exit;

        if (not player.cards[Ord(it_bluecard)]) and
           (not player.cards[Ord(it_blueskull)]) then
        begin
//          player._message := PD_BLUEK;
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/door_b'));
          S_StartSound(nil, Ord(sfx_oof));
          exit;
        end;
      end;
    27, // Yellow Lock
    34:
      begin
        if player = nil then
          exit;

        if (not player.cards[Ord(it_yellowcard)]) and
           (not player.cards[Ord(it_yellowskull)]) then
        begin
//          player._message := PD_YELLOWK;
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/door_y'));
          S_StartSound(nil, Ord(sfx_oof));
          exit;
        end;
      end;
    300:
      begin
        if player = nil then
          exit;

        if (not player.cards[Ord(it_greencard)]) and
           (not player.cards[Ord(it_greenskull)]) then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/door_g'));
          S_StartSound(nil, Ord(sfx_oof));
          exit;
        end;
      end;
    301:
      begin
        if player = nil then
          exit;

        if (not player.cards[Ord(it_whitecard)]) and
           (not player.cards[Ord(it_whiteskull)]) then
        begin
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/door_w'));
          S_StartSound(nil, Ord(sfx_oof));
          exit;
        end;
      end;
    28, // Red Lock
    33:
      begin
        if player = nil then
          exit;

        if (not player.cards[Ord(it_redcard)]) and
           (not player.cards[Ord(it_redskull)]) then
        begin
//          player._message := PD_REDK;
          if player.mo <> nil then
            CM_ExecComicDialog(player.mo, CM_DialogID('hero/door_r'));
          S_StartSound(nil, Ord(sfx_oof));
          exit;
        end;
      end;
  end;

  // if the sector has an active thinker, use it
  // back sides
  sec := sides[line.sidenum[1]].sector;

  if P_SectorActive(ceiling_special, sec) then
  begin
    door := sec.ceilingdata;
    case line.special of
       1, // ONLY FOR "RAISE" DOORS, NOT "OPEN"s
      26,
      27,
      28,
     117:
        begin
          if door.direction = -1 then
            door.direction := 1 // go back up
          else
          begin
            if thing.player = nil then
              exit; // JDC: bad guys never close doors

            door.direction := -1; // start going down immediately
          end;
          exit;
        end;
    end;
  end;

  // for proper sound
  case line.special of
   117, // BLAZING DOOR RAISE
   118: // BLAZING DOOR OPEN
      S_StartSound(Pmobj_t(@sec.soundorg), Ord(sfx_bdopn));
     1, // NORMAL DOOR SOUND
    31:
      S_StartSound(Pmobj_t(@sec.soundorg), Ord(sfx_doropn));
  else // LOCKED DOOR SOUND
    S_StartSound(Pmobj_t(@sec.soundorg), Ord(sfx_doropn));
  end;

  // new door thinker
  door := Z_Malloc(SizeOf(vldoor_t), PU_LEVSPEC, nil);
  P_AddThinker(@door.thinker);
  sec.ceilingdata := door;
  door.thinker._function.acp1 := @T_VerticalDoor;
  door.sector := sec;
  door.direction := 1;
  door.speed := VDOORSPEED;
  door.topwait := VDOORWAIT;
  door.line := nil;

  case line.special of
     1,
    26,
    27,
    28:
      door._type := normal;
    31,
    32,
    33,
    300,
    301,
    34:
      begin
        door._type := open;
        line.special := 0;
      end;
   117: // blazing door raise
      begin
        door._type := blazeRaise;
        door.speed := VDOORSPEED * 4;
      end;
   118: // blazing door open
      begin
        door._type := blazeOpen;
        line.special := 0;
        door.speed := VDOORSPEED * 4;
      end;
  end;

  // find the top and bottom of the movement range
  door.topheight := P_FindLowestCeilingSurrounding(sec) - 4 * FRACUNIT;
end;

//==============================================================================
// P_SpawnDoorCloseIn30
//
// Spawn a door that closes after 30 seconds
//
//==============================================================================
procedure P_SpawnDoorCloseIn30(sec: Psector_t);
var
  door: Pvldoor_t;
begin
  door := Z_Malloc(SizeOf(vldoor_t), PU_LEVSPEC, nil);

  P_AddThinker(@door.thinker);

  sec.ceilingdata := door;
  sec.special := 0;

  door.thinker._function.acp1 := @T_VerticalDoor;
  door.sector := sec;
  door.direction := 0;
  door._type := normal;
  door.speed := VDOORSPEED;
  door.topcountdown := 30 * TICKRATE;
  door.line := nil; // remember line that triggered us
end;

//==============================================================================
// P_SpawnDoorRaiseIn5Mins
//
// Spawn a door that opens after 5 minutes
//
//==============================================================================
procedure P_SpawnDoorRaiseIn5Mins(sec: Psector_t; secnum: integer);
var
  door: Pvldoor_t;
begin
  door := Z_Malloc(SizeOf(vldoor_t), PU_LEVSPEC, nil);

  P_AddThinker(@door.thinker);

  sec.ceilingdata := door;
  sec.special := 0;

  door.thinker._function.acp1 := @T_VerticalDoor;
  door.sector := sec;
  door.direction := 2;
  door._type := raiseIn5Mins;
  door.speed := VDOORSPEED;
  door.topheight := P_FindLowestCeilingSurrounding(sec) - 4 * FRACUNIT;
  door.topwait := VDOORWAIT;
  door.topcountdown := 5 * 60 * TICKRATE;
  door.line := nil; // remember line that triggered us
end;

end.
