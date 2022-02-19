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

unit p_sight;

interface

uses
  m_fixed,
  p_mobj_h;

//==============================================================================
//
// P_CheckSight
//
//==============================================================================
function P_CheckSight(t1: Pmobj_t; t2: Pmobj_t): boolean;

//==============================================================================
//
// P_CheckCameraSight
//
//==============================================================================
function P_CheckCameraSight(const camx, camy, camz: fixed_t; mo: Pmobj_t): boolean;

//==============================================================================
//
// P_CheckVisibility
//
//==============================================================================
function P_CheckVisibility(const atx, aty, atz: fixed_t; const atradious: fixed_t): boolean;

//==============================================================================
//
// R_CheckCameraSight
//
//==============================================================================
function R_CheckCameraSight(camx, camy, camz: fixed_t; mo: Pmobj_t): boolean;

var
  bottomslope: fixed_t; // slopes to top and bottom of target
  topslope: fixed_t;

implementation

uses
  d_delphi,
  gamedef,
  mapdata,
  i_system,
  p_local,
  p_setup,
  p_maputl,
  p_map,
  r_defs,
  r_main;

//
// P_CheckSight
//
var
  sightzstart: fixed_t; // eye z of looker

  strace: divline_t; // from t1 to t2
  t2x: fixed_t;
  t2y: fixed_t;

//==============================================================================
//
// P_DivlineSide
// Returns side 0 (front), 1 (back), or 2 (on).
//
//==============================================================================
function P_DivlineSide(const x, y: fixed_t; const node: Pdivline_t): integer;
var
  dx: fixed_t;
  dy: fixed_t;
  left: fixed_t;
  right: fixed_t;
begin
  if node.dx = 0 then
  begin
    if x = node.x then
    begin
      result := 2;
      exit;
    end;
    if x <= node.x then
    begin
      if node.dy > 0 then
        result := 1
      else
        result := 0;
      exit;
    end;
    if node.dy < 0 then
      result := 1
    else
      result := 0;
    exit;
  end;

  if node.dy = 0 then
  begin
    if y = node.y then
    begin
      result := 2;
      exit;
    end;
    if y <= node.y then
    begin
      if node.dx < 0 then
        result := 1
      else
        result := 0;
      exit;
    end;
    if node.dx > 0 then
      result := 1
    else
      result := 0;
    exit;
  end;

  dx := (x - node.x);
  dy := (y - node.y);

  left := FixedInt(node.dy) * FixedInt(dx);
  right := FixedInt(dy) * FixedInt(node.dx);

  if right < left then
  begin
    result := 0; // front side
    exit;
  end;

  if left = right then
    result := 2
  else
    result := 1; // back side
end;

//==============================================================================
//
// P_InterceptVector2
// Returns the fractional intercept point
// along the first divline.
// This is only called by the addthings and addlines traversers.
//
//==============================================================================
function P_InterceptVector2(v2, v1: Pdivline_t): fixed_t;
var
  num: fixed_t;
  den: fixed_t;
begin
  den := FixedMul8(v1.dy, v2.dx) - FixedMul8(v1.dx, v2.dy);

  if den = 0 then
  begin
    result := 0;
    exit;
    //  I_Error ("P_InterceptVector: parallel");
  end;

  num := FixedMul8(v1.x - v2.x, v1.dy) +
         FixedMul8(v2.y - v1.y, v1.dx);

  result := FixedDiv(num , den);
end;

//==============================================================================
//
// P_CrossSubsector
// Returns true
//  if strace crosses the given subsector successfully.
//
//==============================================================================
function P_CrossSubsector(const num: integer): boolean;
var
  seg: Pseg_t;
  line: Pline_t;
  s1: integer;
  s2: integer;
  i: integer;
  sub: Psubsector_t;
  front: Psector_t;
  back: Psector_t;
  opentop: fixed_t;
  openbottom: fixed_t;
  divl: divline_t;
  v1: Pvertex_t;
  v2: Pvertex_t;
  frac: fixed_t;
  slope: fixed_t;
begin
  sub := @subsectors[num];

  // check lines
  seg := @segs[sub.firstline - 1];
  for i := 0 to sub.numlines - 1 do
  begin
    inc(seg);
    if seg.miniseg then // JVAL: skip minisegs
      continue;

    line := seg.linedef;

    // allready checked other side?
    if line.validcount = validcount then
      continue;

    line.validcount := validcount;

    v1 := line.v1;
    v2 := line.v2;
    s1 := P_DivlineSide(v1.x, v1.y, @strace);
    s2 := P_DivlineSide(v2.x, v2.y, @strace);

    // line isn't crossed?
    if s1 = s2 then
      continue;

    divl.x := v1.x;
    divl.y := v1.y;
    divl.dx := v2.x - v1.x;
    divl.dy := v2.y - v1.y;
    s1 := P_DivlineSide(strace.x, strace.y, @divl);
    s2 := P_DivlineSide(t2x, t2y, @divl);

    // line isn't crossed?
    if s1 = s2 then
      continue;

    // stop because it is not two sided anyway
    // might do this after updating validcount?
    if line.flags and ML_TWOSIDED = 0 then
    begin
      result := false;
      exit;
    end;

    // crosses a two sided line
    front := seg.frontsector;
    back := seg.backsector;

    // no wall to block sight with?
    if (front.floorheight = back.floorheight) and
       (front.ceilingheight = back.ceilingheight) then
      continue;

    // possible occluder
    // because of ceiling height differences
    if front.ceilingheight < back.ceilingheight then
      opentop := front.ceilingheight + P_SectorJumpOverhead(front)
    else
      opentop := back.ceilingheight + P_SectorJumpOverhead(back);

    // because of ceiling height differences
    if front.floorheight > back.floorheight then
      openbottom := front.floorheight
    else
      openbottom := back.floorheight;

    // quick test for totally closed doors
    if openbottom >= opentop then
    begin
      result := false; // stop
      exit;
    end;

    frac := P_InterceptVector2(@strace, @divl);

    if front.floorheight <> back.floorheight then
    begin
      slope := FixedDiv(openbottom - sightzstart, frac);
      if slope > bottomslope then
        bottomslope := slope;
    end;

    if front.ceilingheight <> back.ceilingheight then
    begin
      slope := FixedDiv(opentop - sightzstart, frac);
      if slope < topslope then
        topslope := slope;
    end;

    if topslope <= bottomslope then
    begin
      result := false; // stop
      exit;
    end;
  end;

  // passed the subsector ok
  result := true;
end;

//==============================================================================
//
// P_CrossBSPNode
// Returns true
//  if strace crosses the given node successfully.
//
//==============================================================================
function P_CrossBSPNode(bspnum: integer): boolean;
var
  bsp: Pnode_t;
  side: integer;
begin
  if bspnum and NF_SUBSECTOR <> 0 then
  begin
    if bspnum = -1 then
      result := P_CrossSubsector(0)
    else
      result := P_CrossSubsector(bspnum and (not NF_SUBSECTOR));
    exit;
  end;

  bsp := @nodes[bspnum];

  // decide which side the start point is on
  side := P_DivlineSide(strace.x, strace.y, Pdivline_t(bsp));
  if side = 2 then
    side := 0; // an "on" should cross both sides

  // cross the starting side
  if not P_CrossBSPNode(bsp.children[side]) then
  begin
    result := false;
    exit;
  end;

  // the partition plane is crossed here
  if side = P_DivlineSide(t2x, t2y, Pdivline_t(bsp)) then
  begin
    // the line doesn't touch the other side
    result := true;
    exit;
  end;

  // cross the ending side
  result := P_CrossBSPNode(bsp.children[side xor 1]);
end;

//==============================================================================
//
// P_CheckSight
// Returns true
//  if a straight line between t1 and t2 is unobstructed.
// Uses REJECT.
//
//==============================================================================
function P_CheckSight(t1: Pmobj_t; t2: Pmobj_t): boolean;
var
  s1: integer;
  s2: integer;
  hsec1: integer;
  hsec2: integer;
  pnum: integer;
  bytenum: integer;
  bitnum: integer;
begin
  // First check for trivial rejection.

  // Determine subsector entries in REJECT table.
  s1 := pDiff(Psubsector_t(t1.subsector).sector, sectors, SizeOf(sector_t));
  s2 := pDiff(Psubsector_t(t2.subsector).sector, sectors, SizeOf(sector_t));
  pnum := s1 * numsectors + s2;
  bytenum := _SHR(pnum, 3);
  bitnum := 1 shl (pnum and 7);

  // Check in REJECT table.
  if rejectmatrix[bytenum] and bitnum <> 0 then
  begin
    // can't possibly be connected
    result := false;
    exit;
  end;

  hsec1 := sectors[s1].heightsec;
  if (hsec1 <> -1) and
       (((t1.z + t1.height <= sectors[hsec1].floorheight) and
         (t2.z >= sectors[hsec1].floorheight)) or
        ((t1.z >= sectors[hsec1].ceilingheight) and
         (t2.z + t1.height <= sectors[hsec1].ceilingheight))) then
  begin
    result := false;
    exit;
  end;

  hsec2 := sectors[s2].heightsec;
  if (hsec2 <> -1) and
       (((t2.z + t2.height <= sectors[hsec2].floorheight) and
         (t1.z >= sectors[hsec2].floorheight)) or
        ((t2.z >= sectors[hsec2].ceilingheight) and
         (t1.z + t2.height <= sectors[hsec2].ceilingheight))) then
  begin
    result := false;
    exit;
  end;

  // An unobstructed LOS is possible.
  // Now look from eyes of t1 to any part of t2.
  inc(validcount);

  sightzstart := t1.z + t1.height - _SHR2(t1.height);
  topslope := (t2.z + t2.height) - sightzstart;
  bottomslope := t2.z - sightzstart;

  strace.x := t1.x;
  strace.y := t1.y;
  t2x := t2.x;
  t2y := t2.y;
  strace.dx := t2.x - t1.x;
  strace.dy := t2.y - t1.y;

  // the head node is the last node output
  result := P_CrossBSPNode(numnodes - 1);
end;

//==============================================================================
//
// P_SightBlockLinesIterator
//
//==============================================================================
function P_SightBlockLinesIterator(x, y: integer): boolean;
var
  offset: integer;
  list: PSmallInt;
  ld: Pline_t;
  s1, s2: integer;
  dl: divline_t;
begin
  offset := y * bmapwidth + x;

  offset := blockmap[offset];

  list := @blockmaplump[offset];
  while list^ <> -1 do
  begin
    ld := @lines[list^];
    if ld.validcount = validcount then
    begin
      inc(list);
      continue; // line has already been checked
    end;
    ld.validcount := validcount;

    s1 := P_PointOnDivlineSide (ld.v1.x, ld.v1.y, @trace);
    s2 := P_PointOnDivlineSide (ld.v2.x, ld.v2.y, @trace);
    if s1 = s2 then
    begin
      inc(list);
      continue; // line isn't crossed
    end;
    P_MakeDivline(ld, @dl);
    s1 := P_PointOnDivlineSide (trace.x, trace.y, @dl);
    s2 := P_PointOnDivlineSide (trace.x + trace.dx, trace.y + trace.dy, @dl);
    if s1 = s2 then
    begin
      inc(list);
      continue; // line isn't crossed
    end;

  // try to early out the check
    if ld.backsector = nil then
    begin
      result := false;  // stop checking
      exit;
    end;

  // store the line for later intersection testing
    intercepts[intercept_p].d.line := ld;
    inc(intercept_p);
    inc(list);
  end;

  result := true; // everything was checked
end;

var
  sightcounts: array[0..2] of integer;

//==============================================================================
//
// PTR_SightTraverse
//
//==============================================================================
function PTR_SightTraverse(_in: Pintercept_t): boolean;
var
  li: Pline_t;
  slope: fixed_t;
begin
  li := _in.d.line;

//
// crosses a two sided line
//
  P_LineOpening(li);

  if openbottom >= opentop then // quick test for totally closed doors
  begin
    result := false;   // stop
    exit;
  end;

  if li.frontsector.floorheight <> li.backsector.floorheight then
  begin
    slope := FixedDiv(openbottom - sightzstart, _in.frac);
    if slope > bottomslope then
      bottomslope := slope;
  end;

  if li.frontsector.ceilingheight <> li.backsector.ceilingheight then
  begin
    slope := FixedDiv(opentop - sightzstart, _in.frac);
    if slope < topslope then
      topslope := slope;
  end;

  result := topslope > bottomslope;
end;

//==============================================================================
//
// P_SightTraverseIntercepts
//
//==============================================================================
function P_SightTraverseIntercepts: boolean;
var
  i: integer;
  count: integer;
  dist: fixed_t;
  scan, _in: Pintercept_t;
  dl: divline_t;
begin
  count := intercept_p;
//
// calculate intercept distance
//
  for i := 0 to count - 1 do
  begin
    scan := @intercepts[i];
    P_MakeDivline(scan.d.line, @dl);
    scan.frac := P_InterceptVector (@trace, @dl);
  end;

//
// go through in order
//
  _in := nil; // shut up compiler warning

  while count > 0 do
  begin
    dist := MAXINT;
    for i := 0 to intercept_p - 1 do
    begin
      scan := @intercepts[i];
      if scan.frac < dist then
      begin
        dist := scan.frac;
        _in := scan;
      end;
    end;

    if not PTR_SightTraverse(_in) then
    begin
      result := false;  // don't bother going farther
      exit;
    end;
    _in.frac := MAXINT;
    dec(count);
  end;

  result := true; // everything was traversed
end;

//==============================================================================
//
// P_SightPathTraverse 
//
//==============================================================================
function P_SightPathTraverse (x1, y1, x2, y2: fixed_t): boolean;
var
  xt1, yt1, xt2, yt2: fixed_t;
  xstep, ystep: fixed_t;
  partial: fixed_t;
  xintercept, yintercept: fixed_t;
  mapx, mapy, mapxstep, mapystep: integer;
  count: integer;
begin
  inc(validcount);
  intercept_p := 0;

  if (x1 - bmaporgx) and (MAPBLOCKSIZE - 1) = 0 then
    x1 := x1 + FRACUNIT;  // don't side exactly on a line
  if (y1 - bmaporgy) and (MAPBLOCKSIZE - 1) = 0 then
    y1 := y1 + FRACUNIT;  // don't side exactly on a line
  trace.x := x1;
  trace.y := y1;
  trace.dx := x2 - x1;
  trace.dy := y2 - y1;

  x1 := x1 - bmaporgx;
  y1 := y1 - bmaporgy;
  xt1 := MapBlockInt(x1);
  yt1 := MapBlockInt(y1);

  x2 := x2 - bmaporgx;
  y2 := y2 - bmaporgy;
  xt2 := MapBlockInt(x2);
  yt2 := MapBlockInt(y2);

// points should never be out of bounds, but check once instead of
// each block
  if (xt1 < 0) or (yt1 < 0) or (xt1 >= bmapwidth) or (yt1 >= bmapheight) or
     (xt2 < 0) or (yt2 < 0) or (xt2 >= bmapwidth) or (yt2 >= bmapheight) then
  begin
    result := false;
    exit;
  end;

  if xt2 > xt1 then
  begin
    mapxstep := 1;
    partial := FRACUNIT - MapToFrac(x1) and (FRACUNIT - 1);
    ystep := FixedDiv(y2 - y1, abs(x2 - x1));
  end
  else if xt2 < xt1 then
  begin
    mapxstep := -1;
    partial := MapToFrac(x1) and (FRACUNIT - 1);
    ystep := FixedDiv(y2 - y1, abs(x2 - x1));
  end
  else
  begin
    mapxstep := 0;
    partial := FRACUNIT;
    ystep := 256 * FRACUNIT;
  end;
  yintercept := MapToFrac(y1) + FixedMul(partial, ystep);

  if yt2 > yt1 then
  begin
    mapystep := 1;
    partial := FRACUNIT - MapToFrac(y1) and (FRACUNIT - 1);
    xstep := FixedDiv(x2 - x1, abs(y2 - y1));
  end
  else if yt2 < yt1 then
  begin
    mapystep := -1;
    partial := MapToFrac(y1) and (FRACUNIT - 1);
    xstep := FixedDiv(x2 - x1, abs(y2 - y1));
  end
  else
  begin
    mapystep := 0;
    partial := FRACUNIT;
    xstep := 256 * FRACUNIT;
  end;
  xintercept := MapToFrac(x1) + FixedMul(partial, xstep);

//
// step through map blocks
// Count is present to prevent a round off error from skipping the break
  mapx := xt1;
  mapy := yt1;

  for count := 0 to 63 do
  begin
    if not P_SightBlockLinesIterator(mapx, mapy) then
    begin
      inc(sightcounts[1]);
      result := false;   // early out
      exit;
    end;

    if (mapx = xt2) and (mapy = yt2) then
      break;

    if FixedInt(yintercept) = mapy then
    begin
      yintercept := yintercept + ystep;
      mapx := mapx + mapxstep;
    end
    else if FixedInt(xintercept) = mapx then
    begin
      xintercept := xintercept + xstep;
      mapy := mapy + mapystep;
    end;

  end;

//
// couldn't early out, so go through the sorted list
//
  inc(sightcounts[2]);

  result := P_SightTraverseIntercepts;
end;

//==============================================================================
//
// R_CheckCameraSight
//
//==============================================================================
function R_CheckCameraSight(camx, camy, camz: fixed_t; mo: Pmobj_t): boolean;
begin
  if mo = nil then
  begin
    result := false;
    exit;
  end;

  inc(validcount);

  sightzstart := camz + mo.height - _SHR2(mo.height);
  topslope := (mo.z + mo.height) - sightzstart;
  bottomslope := mo.z - sightzstart;

  result := P_SightPathTraverse(camx, camy, mo.x, mo.y);
end;

//==============================================================================
//
// P_CheckCameraSight
//
// JVAL: To determine if camera chase view can see the player
//
//==============================================================================
function P_CheckCameraSight(const camx, camy, camz: fixed_t; mo: Pmobj_t): boolean;
begin
  if mo = nil then
  begin
    result := false;
    exit;
  end;

  // An unobstructed LOS is possible.
  // Now look from eyes of t1 to any part of t2.
  inc(validcount);

  sightzstart := camz + mo.height - _SHR2(mo.height);
  topslope := (mo.z + mo.height) - sightzstart;
  bottomslope := mo.z - sightzstart;

  strace.x := camx;
  strace.y := camy;
  t2x := mo.x;
  t2y := mo.y;
  strace.dx := mo.x - camx;
  strace.dy := mo.y - camy;

  // the head node is the last node output
  result := P_CrossBSPNode(numnodes - 1);
end;

//==============================================================================
//
// P_CheckVisibility
//
// JVAL: General visibility check
// Checks if an object at (atx, aty, atz) with radious = atradious can be
// possibly visible
//
//==============================================================================
function P_CheckVisibility(const atx, aty, atz: fixed_t; const atradious: fixed_t): boolean;
begin
  inc(validcount);

  sightzstart := viewz + atradious - _SHR2(atradious);
  topslope := (atz + atradious) - sightzstart;
  bottomslope := atz - sightzstart;

  strace.x := viewx;
  strace.y := viewy;
  t2x := atx;
  t2y := aty;
  strace.dx := atx - viewx;
  strace.dy := aty - viewy;

  // the head node is the last node output
  result := P_CrossBSPNode(numnodes - 1);
end;

end.
