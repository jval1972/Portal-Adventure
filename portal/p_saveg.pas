//------------------------------------------------------------------------------
//
//  Portal Adventure - 2nd PGD Challenge: The Journey
//  Copyright (C) 2012-2018 by Jim Valavanis
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

unit p_saveg;

interface

uses
  d_delphi;

//==============================================================================
// P_ArchivePlayers
//
// Persistent storage/archiving.
// These are the load / save game routines.
//
//==============================================================================
procedure P_ArchivePlayers;

//==============================================================================
//
// P_UnArchivePlayers
//
//==============================================================================
procedure P_UnArchivePlayers;

//==============================================================================
//
// P_ArchiveExtra
//
//==============================================================================
procedure P_ArchiveExtra;

//==============================================================================
//
// P_UnArchiveExtra
//
//==============================================================================
procedure P_UnArchiveExtra;

//==============================================================================
//
// P_ArchiveWorld
//
//==============================================================================
procedure P_ArchiveWorld;

//==============================================================================
//
// P_UnArchiveWorld
//
//==============================================================================
procedure P_UnArchiveWorld;

//==============================================================================
//
// P_ArchiveThinkers
//
//==============================================================================
procedure P_ArchiveThinkers;

//==============================================================================
//
// P_UnArchiveThinkers
//
//==============================================================================
procedure P_UnArchiveThinkers;

//==============================================================================
//
// P_ArchiveSpecials
//
//==============================================================================
procedure P_ArchiveSpecials;

//==============================================================================
//
// P_UnArchiveSpecials
//
//==============================================================================
procedure P_UnArchiveSpecials;

var
  save_p: PByteArray;
  savegameversion: integer;

implementation

uses
  gamedef,
  d_player,
  d_think,
  g_game,
  cm_main,
  info_h,
  info,
  i_system,
  p_journey,
  p_pspr_h,
  p_setup,
  p_mobj_h,
  p_mobj,
  p_tick,
  p_maputl,
  p_spec,
  p_ceilng,
  p_doors,
  p_floor,
  p_plats,
  p_lights,
  p_scroll,
  r_defs,
  z_zone;

//==============================================================================
// PADSAVEP
//
// Pads save_p to a 4-byte boundary
//  so that the load/save works on SGI&Gecko.
//
//==============================================================================
procedure PADSAVEP;
begin
  save_p := PByteArray(integer(save_p) + ((4 - (integer(save_p) and 3) and 3)));
end;

//==============================================================================
//
// P_ArchivePlayers
//
//==============================================================================
procedure P_ArchivePlayers;
var
  i: integer;
  j: integer;
  dest: Pplayer_t;
begin
  for i := 0 to MAXPLAYERS - 1 do
  begin
    if not playeringame[i] then
      continue;

    PADSAVEP;

    dest := Pplayer_t(save_p);
    memcpy(dest, @players[i], SizeOf(player_t));
    save_p := PByteArray(integer(save_p) + SizeOf(player_t));
    for j := 0 to Ord(NUMPSPRITES) - 1 do
      if dest.psprites[j].state <> nil then
        dest.psprites[j].state := Pstate_t(pDiff(dest.psprites[j].state, @states[0], SizeOf(dest.psprites[j].state^)));
  end;
end;

//==============================================================================
//
// P_UnArchivePlayers
//
//==============================================================================
procedure P_UnArchivePlayers;
var
  i: integer;
  j: integer;
begin
  for i := 0 to MAXPLAYERS - 1 do
  begin
    if not playeringame[i] then
      continue;

    PADSAVEP;

    memcpy(@players[i], save_p, SizeOf(player_t));
    incp(pointer(save_p), SizeOf(player_t));

    // will be set when unarc thinker
    players[i].mo := nil;
    players[i]._message := '';
    players[i].attacker := nil;

    for j := 0 to Ord(NUMPSPRITES) - 1 do
      if players[i].psprites[j].state <> nil then
        players[i].psprites[j].state := @states[integer(players[i].psprites[j].state)];
  end;

end;

//==============================================================================
//
// P_ArchiveExtra
//
//==============================================================================
procedure P_ArchiveExtra;
var
  fd: futuredialog_t;
  i: integer;
begin
  memcpy(save_p, @journeymapinfo, SizeOf(journeymapinfo));
  incp(pointer(save_p), SizeOf(journeymapinfo));

  for i := 0 to NUMFUTUREDIALOGS - 1 do
  begin
    fd := futuredialogs[i];
    if fd.actor <> nil then
      fd.actor := Pmobj_t(fd.actor.key);
    memcpy(save_p, @fd, SizeOf(futuredialog_t));
    incp(pointer(save_p), SizeOf(futuredialog_t));
  end;

end;

//==============================================================================
//
// P_UnArchiveExtra
//
//==============================================================================
procedure P_UnArchiveExtra;
var
  fd: futuredialog_t;
  i: integer;
begin
  memcpy(@journeymapinfo, save_p, SizeOf(journeymapinfo));
  incp(pointer(save_p), SizeOf(journeymapinfo));

  for i := 0 to NUMFUTUREDIALOGS - 1 do
  begin
    memcpy(@fd, save_p, SizeOf(futuredialog_t));
    incp(pointer(save_p), SizeOf(futuredialog_t));

    if fd.actor <> nil then
      fd.actor := P_FindMobjFromKey(integer(fd.actor));
    futuredialogs[i] := fd;
  end;
end;

//==============================================================================
//
// P_ArchiveWorld
//
//==============================================================================
procedure P_ArchiveWorld;
var
  i: integer;
  j: integer;
  sec: Psector_t;
  li: Pline_t;
  si: Pside_t;
  put: PIntegerArray;
begin
  put := PIntegerArray(save_p);

  // do sectors
  i := 0;
  while i < numsectors do
  begin
    sec := Psector_t(@sectors[i]);
    put[0] := sec.floorheight;
    put := @put[1];
    put[0] := sec.ceilingheight;
    put := @put[1];
    put[0] := sec.floorpic;
    put := @put[1];
    put[0] := sec.ceilingpic;
    put := @put[1];
    put[0] := sec.lightlevel;
    put := @put[1];
    put[0] := sec.special; // needed?
    put := @put[1];
    put[0] := sec.tag;  // needed?
    put := @put[1];
    put[0] := sec.floor_xoffs;
    put := @put[1];
    put[0] := sec.floor_yoffs;
    put := @put[1];
    put[0] := sec.ceiling_xoffs;
    put := @put[1];
    put[0] := sec.ceiling_yoffs;
    put := @put[1];
    inc(i);
  end;

  // do lines
  i := 0;
  while i < numlines do
  begin
    li := Pline_t(@lines[i]);
    put[0] := li.flags;
    put := @put[1];
    put[0] := li.special;
    put := @put[1];
    put[0] := li.tag;
    put := @put[1];
    for j := 0 to 1 do
    begin
      if li.sidenum[j] = -1 then
        continue;

      si := @sides[li.sidenum[j]];

      put[0] := si.textureoffset;
      put := @put[1];
      put[0] := si.rowoffset;
      put := @put[1];
      put[0] := si.toptexture;
      put := @put[1];
      put[0] := si.bottomtexture;
      put := @put[1];
      put[0] := si.midtexture;
      put := @put[1];
    end;
    inc(i);
  end;

  save_p := PByteArray(put);
end;

//==============================================================================
//
// P_UnArchiveWorld
//
//==============================================================================
procedure P_UnArchiveWorld;
var
  i: integer;
  j: integer;
  sec: Psector_t;
  li: Pline_t;
  si: Pside_t;
  get: PIntegerArray;
begin
  get := PIntegerArray(save_p);

  // do sectors
  i := 0;
  while i < numsectors do
  begin
    sec := Psector_t(@sectors[i]);
    sec.floorheight := get[0];
    get := @get[1];
    sec.ceilingheight := get[0];
    get := @get[1];
    sec.floorpic := get[0];
    get := @get[1];
    sec.ceilingpic := get[0];
    get := @get[1];
    sec.lightlevel := get[0];
    get := @get[1];
    sec.special := get[0]; // needed?
    get := @get[1];
    sec.tag := get[0]; // needed?
    get := @get[1];
    sec.floordata := nil;
    sec.ceilingdata := nil;
    sec.lightingdata := nil;
    sec.soundtarget := nil;

    sec.floor_xoffs := get[0];
    get := @get[1];
    sec.floor_yoffs := get[0];
    get := @get[1];
    sec.ceiling_xoffs := get[0];
    get := @get[1];
    sec.ceiling_yoffs := get[0];
    get := @get[1];

    sec.touching_thinglist := nil;
    sec.iSectorID := i;
    inc(i);
  end;

  // do lines
  i := 0;
  while i < numlines do
  begin
    li := Pline_t(@lines[i]);
    li.flags := get[0];
    get := @get[1];
    li.special := get[0];
    get := @get[1];
    li.tag := get[0];
    get := @get[1];
    for j := 0 to 1 do
    begin
      if li.sidenum[j] = -1 then
        continue;
      si := @sides[li.sidenum[j]];
      si.textureoffset := get[0];
      get := @get[1];
      si.rowoffset := get[0];
      get := @get[1];
      si.toptexture := get[0];
      get := @get[1];
      si.bottomtexture := get[0];
      get := @get[1];
      si.midtexture := get[0];
      get := @get[1];
    end;
    inc(i);
  end;
  save_p := PByteArray(get);
end;

//
// Thinkers
//
type
  thinkerclass_t = (tc_end, tc_mobj);

//==============================================================================
//
// P_ArchiveThinkers
//
//==============================================================================
procedure P_ArchiveThinkers;
var
  th: Pthinker_t;
  mobj: Pmobj_t;
  parm, parm1: Pmobjcustomparam_t;
begin
  // save off the current thinkers
  th := thinkercap.next;
  while th <> @thinkercap do
  begin
    if @th._function.acp1 = @P_MobjThinker then
    begin
      save_p[0] := Ord(tc_mobj);
      save_p := @save_p[1];
      PADSAVEP;
      mobj := Pmobj_t(save_p);
      memcpy(mobj, th, SizeOf(mobj_t));
      incp(pointer(save_p), SizeOf(mobj_t));
      mobj.state := Pstate_t(pDiff(mobj.state, @states[0], SizeOf(state_t)));
      mobj.prevstate := Pstate_t(pDiff(mobj.prevstate, @states[0], SizeOf(state_t)));
      if mobj.comicdata <> nil then
        mobj.comicdata := pointer(1 + pDiff(mobj.comicdata, @comicdialogs[0], SizeOf(dialogdef_t)));

      if mobj.player <> nil then
        mobj.player := Pplayer_t(pDiff(mobj.player, @players[0], SizeOf(player_t)) + 1);

      if mobj.target <> nil then
        mobj.target := Pmobj_t(Pmobj_t(th).target.key);

      parm := mobj.customparams;
      while parm <> nil do
      begin
        parm1 := Pmobjcustomparam_t(save_p);
        memcpy(parm1, parm, SizeOf(mobjcustomparam_t));
        incp(pointer(save_p), SizeOf(mobjcustomparam_t));
        parm := parm.next;
      end;

    end;
    th := th.next;
  end;

  // add a terminating marker
  save_p[0] := Ord(tc_end);
  save_p := @save_p[1];
end;

// P_UnArchiveThinkers
//
//==============================================================================
procedure P_UnArchiveThinkers;
var
  tclass: byte;
  currentthinker: Pthinker_t;
  next: Pthinker_t;
  mobj: Pmobj_t;
  parm: Pmobjcustomparam_t;
begin
  // remove all the current thinkers
  currentthinker := thinkercap.next;
  while currentthinker <> @thinkercap do
  begin
    next := currentthinker.next;

    if @currentthinker._function.acp1 = @P_MobjThinker then
      P_RemoveMobj(Pmobj_t(currentthinker))
    else
      Z_Free(currentthinker);

    currentthinker := next;
  end;
  P_InitThinkers;

  // read in saved thinkers
  while true do
  begin
    tclass := save_p[0];
    save_p := @save_p[1];
    case tclass of
      Ord(tc_end):
        begin
          currentthinker := thinkercap.next;
          while currentthinker <> @thinkercap do
          begin
            if @currentthinker._function.acp1 = @P_MobjThinker then
              if Pmobj_t(currentthinker).target <> nil then
                Pmobj_t(currentthinker).target := P_FindMobjFromKey(integer(Pmobj_t(currentthinker).target));
            currentthinker := currentthinker.next;
          end;

          break; // end of list
        end;

      Ord(tc_mobj):
        begin
          PADSAVEP;
          mobj := Z_Malloc(SizeOf(mobj_t), PU_LEVEL, nil);

          if savegameversion = VERSION then
          begin
            memcpy(mobj, save_p, SizeOf(mobj_t));
            incp(pointer(save_p), SizeOf(mobj_t));
          end
          else
            I_Error('P_UnArchiveThinkers(): Unsupported saved game version: %d', [savegameversion]);

          if mobj.key >= mobjkeycnt then
            mobjkeycnt := mobj.key + 1;

          mobj.state := @states[integer(mobj.state)];
          mobj.prevstate := @states[integer(mobj.prevstate)];
          if mobj.comicdata <> nil then
          begin
            CM_PrepareComicDialog(Integer(mobj.comicdata) - 1);
            mobj.comicdata := @comicdialogs[Integer(mobj.comicdata) - 1];
          end;
          mobj.tracer := nil;
          mobj.touching_sectorlist := nil;

          if mobj.player <> nil then
          begin
            mobj.player := @players[integer(mobj.player) - 1];

            Pplayer_t(mobj.player).mo := mobj;
          end;

          if mobj.customparams <> nil then
          begin
            mobj.customparams := nil;
            repeat
              parm := Z_Malloc(SizeOf(mobjcustomparam_t), PU_STATIC, nil);
              memcpy(parm, save_p, SizeOf(mobjcustomparam_t));
              incp(pointer(save_p), SizeOf(mobjcustomparam_t));
              P_SetMobjCustomParam(mobj, parm.name, parm.value);
            until parm.next = nil;
          end;

          P_SetThingPosition(mobj);
          mobj.info := @mobjinfo[Ord(mobj._type)];
          mobj.floorz := Psubsector_t(mobj.subsector).sector.floorheight;
          mobj.ceilingz := Psubsector_t(mobj.subsector).sector.ceilingheight;
          @mobj.thinker._function.acp1 := @P_MobjThinker;
          P_AddThinker(@mobj.thinker);
        end;
      else
        I_Error('P_UnArchiveThinkers(): Unknown tclass %d in savegame', [tclass]);
    end;
  end;

  if j_restore then
  begin
    J_RestorePlayers;
    j_restore := false;
  end;
end;

//
// P_ArchiveSpecials
//
type
  specials_e = (
    tc_ceiling,
    tc_door,
    tc_floor,
    tc_plat,
    tc_flash,
    tc_strobe,
    tc_glow,
    tc_scroll,
    tc_friction,    // phares 3/18/98:  new friction effect thinker
    tc_pusher,      // phares 3/22/98:  new push/pull effect thinker
    tc_endspecials
  );

//==============================================================================
// P_ArchiveSpecials
//
// Things to handle:
//
// T_MoveCeiling, (ceiling_t: sector_t * swizzle), - active list
// T_VerticalDoor, (vldoor_t: sector_t * swizzle),
// T_MoveFloor, (floormove_t: sector_t * swizzle),
// T_LightFlash, (lightflash_t: sector_t * swizzle),
// T_StrobeFlash, (strobe_t: sector_t *),
// T_Glow, (glow_t: sector_t *),
// T_PlatRaise, (plat_t: sector_t *), - active list
//
//==============================================================================
procedure P_ArchiveSpecials;
var
  th: Pthinker_t;
  th1: Pthinker_t;
  ceiling: Pceiling_t;
  door: Pvldoor_t;
  floor: Pfloormove_t;
  plat: Pplat_t;
  flash: Plightflash_t;
  strobe: Pstrobe_t;
  glow: Pglow_t;
  scroll: Pscroll_t;
  friction: Pfriction_t;
  pusher: Ppusher_t;
  i: integer;
begin
  // save off the current thinkers
  th1 := thinkercap.next;
  while th1 <> @thinkercap do
  begin
    th := th1;
    th1 := th1.next;
    if not Assigned(th._function.acv) then
    begin
      i := 0;
      while i < MAXCEILINGS do
      begin
        if activeceilings[i] = Pceiling_t(th) then
          break;
        inc(i);
      end;

      if i < MAXCEILINGS then
      begin
        save_p[0] := Ord(tc_ceiling);
        save_p := @save_p[1];
        PADSAVEP;
        ceiling := Pceiling_t(save_p);
        memcpy(ceiling, th, SizeOf(ceiling_t));
        incp(pointer(save_p), SizeOf(ceiling_t));
        ceiling.sector := Psector_t(pDiff(ceiling.sector, sectors, SizeOf(sector_t)));
      end;
      continue;
    end;

    if @th._function.acp1 = @T_MoveCeiling then
    begin
      save_p[0] := Ord(tc_ceiling);
      save_p := @save_p[1];
      PADSAVEP;
      ceiling := Pceiling_t(save_p);
      memcpy(ceiling, th, SizeOf(ceiling_t));
      incp(pointer(save_p), SizeOf(ceiling_t));
      ceiling.sector := Psector_t(pDiff(ceiling.sector, sectors, SizeOf(sector_t)));
      continue;
    end;

    if @th._function.acp1 = @T_VerticalDoor then
    begin
      save_p[0] := Ord(tc_door);
      save_p := @save_p[1];
      PADSAVEP;
      door := Pvldoor_t(save_p);
      memcpy(door, th, SizeOf(vldoor_t));
      incp(pointer(save_p), SizeOf(vldoor_t));
      door.sector := Psector_t(pDiff(door.sector, sectors, SizeOf(sector_t)));
      if door.line = nil then
        door.line := Pline_t(-1)
      else
        door.line := Pline_t(pDiff(door.line, lines, SizeOf(line_t)));
      continue;
    end;

    if @th._function.acp1 = @T_MoveFloor then
    begin
      save_p[0] := Ord(tc_floor);
      save_p := @save_p[1];
      PADSAVEP;
      floor := Pfloormove_t(save_p);
      memcpy(floor, th, SizeOf(floormove_t));
      incp(pointer(save_p), SizeOf(floormove_t));
      floor.sector := Psector_t(pDiff(floor.sector, sectors, SizeOf(sector_t)));
      continue;
    end;

    if @th._function.acp1 = @T_PlatRaise then
    begin
      save_p[0] := Ord(tc_plat);
      save_p := @save_p[1];
      PADSAVEP;
      plat := Pplat_t(save_p);
      memcpy(plat, th, SizeOf(plat_t));
      incp(pointer(save_p), SizeOf(plat_t));
      plat.sector := Psector_t(pDiff(plat.sector, sectors, SizeOf(sector_t)));
      continue;
    end;

    if @th._function.acp1 = @T_LightFlash then
    begin
      save_p[0] := Ord(tc_flash);
      save_p := @save_p[1];
      PADSAVEP;
      flash := Plightflash_t(save_p);
      memcpy(flash, th, SizeOf(lightflash_t));
      incp(pointer(save_p), SizeOf(lightflash_t));
      flash.sector := Psector_t(pDiff(flash.sector, sectors, SizeOf(sector_t)));
      continue;
    end;

    if @th._function.acp1 = @T_StrobeFlash then
    begin
      save_p[0] := Ord(tc_strobe);
      save_p := @save_p[1];
      PADSAVEP;
      strobe := Pstrobe_t(save_p);
      memcpy(strobe, th, SizeOf(strobe_t));
      incp(pointer(save_p), SizeOf(strobe_t));
      strobe.sector := Psector_t(pDiff(strobe.sector, sectors, SizeOf(sector_t)));
      continue;
    end;

    if @th._function.acp1 = @T_Glow then
    begin
      save_p[0] := Ord(tc_glow);
      save_p := @save_p[1];
      PADSAVEP;
      glow := Pglow_t(save_p);
      memcpy(glow, th, SizeOf(glow_t));
      incp(pointer(save_p), SizeOf(glow_t));
      glow.sector := Psector_t(pDiff(glow.sector, sectors, SizeOf(sector_t)));
      continue;
    end;

    if @th._function.acp1 = @T_Scroll then
    begin
      save_p[0] := Ord(tc_scroll);
      save_p := @save_p[1];
      PADSAVEP;
      scroll := Pscroll_t(save_p);
      memcpy(scroll, th, SizeOf(scroll_t));
      incp(pointer(save_p), SizeOf(scroll_t));
      continue;
    end;

    if @th._function.acp1 = @T_Friction then
    begin
      save_p[0] := Ord(tc_friction);
      save_p := @save_p[1];
      PADSAVEP;
      friction := Pfriction_t(save_p);
      memcpy(friction, th, SizeOf(friction_t));
      incp(pointer(save_p), SizeOf(friction_t));
      continue;
    end;

    if @th._function.acp1 = @T_Pusher then
    begin
      save_p[0] := Ord(tc_pusher);
      save_p := @save_p[1];
      PADSAVEP;
      pusher := Ppusher_t(save_p);
      memcpy(pusher, th, SizeOf(pusher_t));
      incp(pointer(save_p), SizeOf(pusher_t));
      continue;
    end;

  end;

  // add a terminating marker
  save_p[0] := Ord(tc_endspecials);
  save_p := @save_p[1];
end;

//==============================================================================
//
// P_UnArchiveSpecials
//
//==============================================================================
procedure P_UnArchiveSpecials;
var
  tclass: byte;
  ceiling: Pceiling_t;
  door: Pvldoor_t;
  floor: Pfloormove_t;
  plat: Pplat_t;
  flash: Plightflash_t;
  strobe: Pstrobe_t;
  glow: Pglow_t;
  scroll: Pscroll_t;
  friction: Pfriction_t;
  pusher: Ppusher_t;
begin
  // read in saved thinkers
  while true do
  begin
    tclass := save_p[0];
    save_p := @save_p[1];
    case tclass of
      Ord(tc_endspecials):
        exit; // end of list

      Ord(tc_ceiling):
        begin
          PADSAVEP;
          ceiling := Z_Malloc(SizeOf(ceiling_t), PU_LEVEL, nil);
          memcpy(ceiling, save_p, SizeOf(ceiling_t));
          incp(pointer(save_p), SizeOf(ceiling_t));
          ceiling.sector := @sectors[integer(ceiling.sector)];
          ceiling.sector.ceilingdata := ceiling;

          if Assigned(ceiling.thinker._function.acp1) then // JVAL works ???
            @ceiling.thinker._function.acp1 := @T_MoveCeiling;

          P_AddThinker(@ceiling.thinker);
          P_AddActiveCeiling(ceiling);
        end;

      Ord(tc_door):
        begin
          PADSAVEP;
          door := Z_Malloc(SizeOf(vldoor_t), PU_LEVEL, nil);
          memcpy(door, save_p, SizeOf(vldoor_t));
          incp(pointer(save_p), SizeOf(vldoor_t));
          door.sector := @sectors[integer(door.sector)];
          door.sector.ceilingdata := door;
          if integer(door.line) = -1 then
            door.line := nil
          else
            door.line := @lines[integer(door.line)];

          @door.thinker._function.acp1 := @T_VerticalDoor;
          P_AddThinker(@door.thinker);
        end;

      Ord(tc_floor):
        begin
          PADSAVEP;
          floor := Z_Malloc(SizeOf(floormove_t), PU_LEVEL, nil);
          memcpy(floor, save_p, SizeOf(floormove_t));
          incp(pointer(save_p), SizeOf(floormove_t));
          floor.sector := @sectors[integer(floor.sector)];
          floor.sector.floordata := floor;
          @floor.thinker._function.acp1 := @T_MoveFloor;
          P_AddThinker(@floor.thinker);
        end;

      Ord(tc_plat):
        begin
          PADSAVEP;
          plat := Z_Malloc(SizeOf(plat_t), PU_LEVEL, nil);
          memcpy(plat, save_p, SizeOf(plat_t));
          incp(pointer(save_p), SizeOf(plat_t));
          plat.sector := @sectors[integer(plat.sector)];
          plat.sector.floordata := plat;

          if Assigned(plat.thinker._function.acp1) then
            @plat.thinker._function.acp1 := @T_PlatRaise;

          P_AddThinker(@plat.thinker);
          P_AddActivePlat(plat);
        end;

      Ord(tc_flash):
        begin
          PADSAVEP;
          flash := Z_Malloc(Sizeof(lightflash_t), PU_LEVEL, nil);
          memcpy(flash, save_p, SizeOf(lightflash_t));
          incp(pointer(save_p), SizeOf(lightflash_t));
          flash.sector := @sectors[integer(flash.sector)];
          @flash.thinker._function.acp1 := @T_LightFlash;
          P_AddThinker(@flash.thinker);
        end;

      Ord(tc_strobe):
        begin
          PADSAVEP;
          strobe := Z_Malloc(SizeOf(strobe_t), PU_LEVEL, nil);
          memcpy(strobe, save_p, SizeOf(strobe_t));
          incp(pointer(save_p), SizeOf(strobe_t));
          strobe.sector := @sectors[integer(strobe.sector)];
          @strobe.thinker._function.acp1 := @T_StrobeFlash;
          P_AddThinker(@strobe.thinker);
        end;

      Ord(tc_glow):
        begin
          PADSAVEP;
          glow := Z_Malloc(SizeOf(glow_t), PU_LEVEL, nil);
          memcpy(glow, save_p, SizeOf(glow_t));
          incp(pointer(save_p), SizeOf(glow_t));
          glow.sector := @sectors[integer(glow.sector)];
          @glow.thinker._function.acp1 := @T_Glow;
          P_AddThinker(@glow.thinker);
        end;

      Ord(tc_scroll):
        begin

          PADSAVEP;
          scroll := Z_Malloc(SizeOf(scroll_t), PU_LEVEL, nil);
          memcpy(scroll, save_p, SizeOf(scroll_t));
          incp(pointer(save_p), SizeOf(scroll_t));
          @scroll.thinker._function.acp1 := @T_Scroll;
          P_AddThinker(@scroll.thinker);
        end;

      Ord(tc_friction):
        begin
          PADSAVEP;
          friction := Z_Malloc(SizeOf(friction_t), PU_LEVEL, nil);
          memcpy(friction, save_p, SizeOf(friction_t));
          incp(pointer(save_p), SizeOf(friction_t));
          @friction.thinker._function.acp1 := @T_Friction;
          P_AddThinker(@friction.thinker);
        end;

      Ord(tc_pusher):
        begin
          PADSAVEP;
          pusher := Z_Malloc(SizeOf(pusher_t), PU_LEVEL, nil);
          memcpy(pusher, save_p, SizeOf(pusher_t));
          incp(pointer(save_p), SizeOf(pusher_t));
          @pusher.thinker._function.acp1 := @T_Pusher;
          P_AddThinker(@pusher.thinker);
        end;

      else
        I_Error('P_UnarchiveSpecials(): Unknown tclass %d in savegame', [tclass]);
    end;
  end;
end;

end.
