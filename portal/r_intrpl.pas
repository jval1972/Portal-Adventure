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

unit r_intrpl;

// JVAL
// Frame interpolation to exceed the TICRATE limit
//

interface

uses
  m_fixed;

procedure R_InitInterpolations;

procedure R_ResetInterpolationBuffer;

procedure R_StoreInterpolationData(const tick: integer);

procedure R_RestoreInterpolationData;

function R_Interpolate: boolean;

procedure R_InterpolateTicker;

procedure R_SetInterpolateSkipTicks(const ticks: integer);

var
  interpolate: boolean;
  didinterpolations: boolean;
  ticfrac: fixed_t;

implementation

uses
  d_delphi,
  d_player,
  d_think,
  g_game,
  i_system,
  p_setup,
  p_tick,
  p_mobj,
  p_mobj_h,
  p_pspr_h,
  r_defs,
  tables,
  r_main;

type
  itype = (iinteger, ismallint, ibyte, iangle, ifloat);

  // Interpolation item
  //  Holds information about the previous and next values and interpolation type
  iitem_t = record
    lastaddress: pointer;
    address: pointer;
    lastkey: integer;
    key: integer;
    case _type: itype of
      iinteger: (iprev, inext: integer);
      ismallint: (siprev, sinext: smallint);
      ibyte: (bprev, bnext: byte);
      iangle: (aprev, anext: LongWord);
      ifloat: (fprev, fnext: float);
  end;
  Piitem_t = ^iitem_t;
  iitem_tArray = array[0..$FFFF] of iitem_t;
  Piitem_tArray = ^iitem_tArray;

  // Interpolation structure
  //  Holds the global interpolation items list
  istruct_t = record
    numitems: integer;
    realsize: integer;
    items: Piitem_tArray;
  end;

const
  IGROWSTEP = 256;

var
  istruct: istruct_t;

procedure R_InitInterpolations;
begin
  istruct.numitems := 0;
  istruct.realsize := 0;
  istruct.items := nil;
end;

procedure R_ResetInterpolationBuffer;
begin
  memfree(pointer(istruct.items), istruct.realsize * SizeOf(iitem_t));
  istruct.numitems := 0;
  istruct.realsize := 0;
  R_ResetSmooth;
end;

function R_InterpolationCalcI(const prev, next: fixed_t; const frac: fixed_t): fixed_t;
begin
  if next = prev then
    result := next
  else
    result := prev + round((next - prev) / FRACUNIT * frac);
end;

function R_InterpolationCalcF(const prev, next: float; const frac: fixed_t): float;
begin
  if next = prev then
    result := next
  else
    result := prev + ((next - prev) / FRACUNIT * frac);
end;

function R_InterpolationCalcSI(const prev, next: smallint; const frac: fixed_t): smallint;
begin
  if next = prev then
    result := next
  else
    result := prev + round((next - prev) / FRACUNIT * frac);
end;

function R_InterpolationCalcB(const prev, next: byte; const frac: fixed_t): byte;
begin
  if next = prev then
    result := next
  else if (next = 0) or (prev = 0) then // Hack for player.lookdir2
    result := next
  else if ((next > 247) and (prev < 8)) or ((next < 8) and (prev > 247)) then // Hack for player.lookdir2
    result := 0
  else
    result := prev + (next - prev) * frac div FRACUNIT;
end;

function R_InterpolationCalcA(const prev, next: angle_t; const frac: fixed_t): angle_t;
begin
  if prev = next then
    result := next
  else
  begin
    if ((prev < ANG90) and (next > ANG270)) or
       ((next < ANG90) and (prev > ANG270)) then
    begin
      if frac < FRACUNIT div 4 then
        result := prev
      else if frac > FRACUNIT * 3 div 4 then
        result := next
      else
        result := 0;
    end
    else if prev > next then
    begin
      result := prev - round((prev - next) / FRACUNIT * frac);
    end
    else
    begin
      result := prev + round((next - prev) / FRACUNIT * frac);
    end;
  end;
end;

procedure R_AddInterpolationItem(const addr: pointer; const typ: itype; const key: integer);
var
  newrealsize: integer;
  pi: Piitem_t;
begin
  if istruct.realsize <= istruct.numitems then
  begin
    newrealsize := istruct.realsize + IGROWSTEP;
    realloc(pointer(istruct.items), istruct.realsize * SizeOf(iitem_t), newrealsize * SizeOf(iitem_t));
    istruct.realsize := newrealsize;
  end;
  pi := @istruct.items[istruct.numitems];
  pi.lastaddress := pi.address;
  pi.address := addr;
  pi.lastkey := pi.key;
  pi.key := key;
  pi._type := typ;
  case typ of
    iinteger:
      begin
        pi.iprev := pi.inext;
        pi.inext := PInteger(addr)^;
      end;
    ismallint:
      begin
        pi.siprev := pi.sinext;
        pi.sinext := PSmallInt(addr)^;
      end;
    ibyte:
      begin
        pi.bprev := pi.bnext;
        pi.bnext := PByte(addr)^;
      end;
    iangle:
      begin
        pi.aprev := pi.anext;
        pi.anext := Pangle_t(addr)^;
      end;
    ifloat:
      begin
        pi.fprev := pi.fnext;
        pi.fnext := Pfloat(addr)^;
      end;
  end;
  inc(istruct.numitems);
end;

var
  interpolationstoretime: fixed_t;

procedure R_StoreInterpolationData(const tick: integer);
var
  sec: Psector_t;
  li: Pline_t;
  si: PSide_t;
  i, j: integer;
  player: Pplayer_t;
  th: Pthinker_t;
begin
  interpolationstoretime := tick * FRACUNIT;
  istruct.numitems := 0;

  // Interpolate player
  player := @players[displayplayer];
  if player <> nil then
  begin
    R_AddInterpolationItem(@player.lookdir, iinteger, 0);
    R_AddInterpolationItem(@player.lookdir2, ibyte, 0);
    R_AddInterpolationItem(@player.viewz, iinteger, 0);
    for i := 0 to Ord(NUMPSPRITES) - 1 do
    begin
      R_AddInterpolationItem(@player.psprites[i].sx, iinteger, i);
      R_AddInterpolationItem(@player.psprites[i].sy, iinteger, i);
    end;
  end;

  // Interpolate Sectors
  sec := @sectors[0];
  for i := 0 to numsectors - 1 do
    if sec.tag <> 0 then
    begin
      R_AddInterpolationItem(@sec.floorheight, iinteger, sec.iSectorID);
      R_AddInterpolationItem(@sec.ceilingheight, iinteger, sec.iSectorID);
      R_AddInterpolationItem(@sec.lightlevel, ismallint, sec.iSectorID);
      // JVAL: 30/9/2009
      R_AddInterpolationItem(@sec.floor_xoffs, iinteger, sec.iSectorID);
      R_AddInterpolationItem(@sec.floor_yoffs, iinteger, sec.iSectorID);
      R_AddInterpolationItem(@sec.ceiling_xoffs, iinteger, sec.iSectorID);
      R_AddInterpolationItem(@sec.ceiling_yoffs, iinteger, sec.iSectorID);
      inc(sec);
    end;

  // Interpolate Lines
  li := @lines[0];
  for i := 0 to numlines - 1 do
  begin
    if li.special <> 0 then
      for j := 0 to 1 do
      begin
        if li.sidenum[j] > -1 then
        begin
          si := @sides[li.sidenum[j]];
          R_AddInterpolationItem(@si.textureoffset, iinteger, i);
          R_AddInterpolationItem(@si.rowoffset, iinteger, i);
        end;
      end;
    inc(li);
  end;

  // Map Objects
  th := thinkercap.next;
  while (th <> nil) and (th <> @thinkercap) do
  begin
    if @th._function.acp1 = @P_MobjThinker then
    begin
      if Pmobj_t(th).flags and MF_JUSTAPPEARED = 0 then  // JVAL Remove ?
      begin
        R_AddInterpolationItem(@Pmobj_t(th).x, iinteger, Pmobj_t(th).key);
        R_AddInterpolationItem(@Pmobj_t(th).y, iinteger, Pmobj_t(th).key);
        R_AddInterpolationItem(@Pmobj_t(th).z, iinteger, Pmobj_t(th).key);
        R_AddInterpolationItem(@Pmobj_t(th).angle, iangle, Pmobj_t(th).key);
        R_AddInterpolationItem(@Pmobj_t(th).anglex, ifloat, Pmobj_t(th).key);
        R_AddInterpolationItem(@Pmobj_t(th).angley, ifloat, Pmobj_t(th).key);
        R_AddInterpolationItem(@Pmobj_t(th).anglez, ifloat, Pmobj_t(th).key);
      end;
    end;
    th := th.next;
  end;

end;

procedure R_RestoreInterpolationData;
var
  i: integer;
  pi: Piitem_t;
begin
  pi := @istruct.items[0];
  for i := 0 to istruct.numitems - 1 do
  begin
    case pi._type of
      iinteger: PInteger(pi.address)^ := pi.inext;
      ismallint: PSmallInt(pi.address)^ := pi.sinext;
      ibyte: PByte(pi.address)^ := pi.bnext;
      iangle: Pangle_t(pi.address)^ := pi.anext;
      ifloat: Pfloat(pi.address)^ := pi.fnext;
    end;
    inc(pi);
  end;
end;

// JVAL: Skip interpolation if we have teleport
var
  skipinterpolationticks: integer = -1;

function R_Interpolate: boolean;
var
  i: integer;
  pi: Piitem_t;
  fractime: fixed_t;
begin
  result := false;
  if skipinterpolationticks >= 0 then
    exit;

  fractime := I_GetFracTime;
  ticfrac := fractime - interpolationstoretime;
  pi := @istruct.items[0];
  if ticfrac < FRACUNIT then
  begin
    result := true;
    for i := 0 to istruct.numitems - 1 do
    begin
      if (pi.address = pi.lastaddress) and (pi.lastkey = pi.key) then
      begin
        case pi._type of
          iinteger: PInteger(pi.address)^ := R_InterpolationCalcI(pi.iprev, pi.inext, ticfrac);
          ismallint: PSmallInt(pi.address)^ := R_InterpolationCalcSI(pi.siprev, pi.sinext, ticfrac);
          ibyte: PByte(pi.address)^ := R_InterpolationCalcB(pi.bprev, pi.bnext, ticfrac);
          iangle: PAngle_t(pi.address)^ := R_InterpolationCalcA(pi.aprev, pi.anext, ticfrac);
          ifloat: Pfloat(pi.address)^ := R_InterpolationCalcF(pi.fprev, pi.fnext, ticfrac);
        end;
      end;
      inc(pi);
    end;
  end;
end;

procedure R_InterpolateTicker;
begin
  if skipinterpolationticks >= 0 then
    dec(skipinterpolationticks)
end;

procedure R_SetInterpolateSkipTicks(const ticks: integer);
begin
  skipinterpolationticks := ticks;
end;

end.

