//------------------------------------------------------------------------------
//
//  Portal Adventure - 2nd PGD Challenge: The Journey
//  Copyright (C) 2012-2019 by Jim Valavanis
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

unit r_plane;

interface

uses
  m_fixed,
  gamedef,
  r_data,
  r_defs;

//-----------------------------------------------------------------------------
procedure R_ClearPlanes;

function R_FindPlane(height: fixed_t; picnum: integer; lightlevel: integer; xoffs, yoffs: fixed_t): Pvisplane_t;

var
  floorplane: Pvisplane_t;
  ceilingplane: Pvisplane_t;

//
// opening
//

// ?
const
  MAXOPENINGS = MAXWIDTH * 64;

var
  openings: packed array[0..MAXOPENINGS - 1] of smallint;
  lastopening: integer;

implementation

uses
  d_delphi,
  d_player,
  tables,
  i_system,
  r_sky,
  r_draw,
  r_main,
  r_things,
  r_hires,
  z_zone,
  w_wad;

// Here comes the obnoxious "visplane".
const
// JVAL - Note about visplanes:
//   Top and Bottom arrays (of visplane_t struct) are now
//   allocated dynamically (using zone memory)
//   Use -zone cmdline param to specify more zone memory allocation
//   if out of memory.
//   See also R_NewVisPlane()
// Now maximum visplanes are 2048 (originally 128)
  MAXVISPLANES = 2048;

var
  visplanes: array[0..MAXVISPLANES - 1] of visplane_t;
  lastvisplane: integer;

//
// R_ClearPlanes
// At begining of frame.
//
procedure R_ClearPlanes;
begin
  lastvisplane := 0;
  lastopening := 0;
end;

//
// R_NewVisPlane
//
// JVAL
//   Create a new visplane
//   Uses zone memory to allocate top and bottom arrays
//
procedure R_NewVisPlane;
begin
  if lastvisplane > maxvisplane then
    maxvisplane := lastvisplane;
  inc(lastvisplane);
end;

//
// R_FindPlane
//
function R_FindPlane(height: fixed_t; picnum: integer; lightlevel: integer; xoffs, yoffs: fixed_t): Pvisplane_t;
var
  check: integer;
begin
  if picnum = skyflatnum then
  begin
    height := 0; // all skies map together
    lightlevel := 0;
    xoffs := 0;
    yoffs := 0;
  end;

  check := 0;
  result := @visplanes[0];
  while check < lastvisplane do
  begin
    if (height = result.height) and
       (picnum = result.picnum) and
       (xoffs = result.xoffs) and
       (yoffs = result.yoffs) and
       (lightlevel = result.lightlevel) then
      break;
    inc(check);
    inc(result);
  end;

  if check < lastvisplane then
  begin
    exit;
  end;

  if lastvisplane = MAXVISPLANES then
    I_Error('R_FindPlane(): no more visplanes');

  R_NewVisPlane;

  result.height := height;
  result.picnum := picnum;
  result.lightlevel := lightlevel;
  result.minx := SCREENWIDTH;
  result.maxx := -1;
  result.xoffs := xoffs;
  result.yoffs := yoffs;
end;

end.

