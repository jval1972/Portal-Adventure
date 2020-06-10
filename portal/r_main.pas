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

unit r_main;

interface

uses
  d_delphi,
  gamedef,
  d_player,
  m_stack,
  m_fixed,
  tables,
  r_data,
  r_defs;

var
  qx: TIntegerQueue;
  qy: TIntegerQueue;
  qz: TIntegerQueue;
  qzz: TIntegerQueue;

const
//
// Lighting LUT.
// Used for z-depth cuing per column/row,
//  and other lighting effects (sector ambient, flash).
//

// Lighting constants.
// Now why not 32 levels here?
  LIGHTSEGSHIFT = 4;
  LIGHTLEVELS = (256 div (1 shl LIGHTSEGSHIFT));

  MAXLIGHTSCALE = 48;
  LIGHTSCALESHIFT = 12;
  HLL_MAXLIGHTSCALE = MAXLIGHTSCALE * 64;

  MAXLIGHTZ = 128;
  LIGHTZSHIFT = 20;

  HLL_MAXLIGHTZ = MAXLIGHTZ * 64; // Hi resolution light level for z depth
  HLL_LIGHTZSHIFT = 12;
  HLL_LIGHTSCALESHIFT = 3;
  HLL_ZDISTANCESHIFT = 14;

  LIGHTDISTANCESHIFT = 12;

// Colormap constants
// Number of diminishing brightness levels.
// There a 0-31, i.e. 32 LUT in the COLORMAP lump.
// Index of the special effects (INVUL inverse) map.
  INVERSECOLORMAP = 32;

var
  forcecolormaps: boolean;
  use32bitfuzzeffect: boolean;
  diher8bittransparency: boolean;
  chasecamera: boolean;
  chasecamera_viewxy: integer;
  chasecamera_viewz: integer;

//
// Utility functions.
//
function R_PointOnSide(const x: fixed_t; const y: fixed_t; const node: Pnode_t): boolean;

function R_PointToAngle(x: fixed_t; y: fixed_t): angle_t;

function R_PointToAngle2(const x1: fixed_t; const y1: fixed_t; const x2: fixed_t; const y2: fixed_t): angle_t;

function R_PointInSubsector(const x: fixed_t; const y: fixed_t): Psubsector_t;

procedure R_ResetSmooth;

//
// REFRESH - the actual rendering functions.
//

// Called by G_Drawer.
procedure R_RenderPlayerView(player: Pplayer_t);

// Called by startup code.
procedure R_Init;
procedure R_ShutDown;

// Called by M_Responder.
procedure R_SetViewSize;

procedure R_ExecuteSetViewSize;

procedure R_SetViewAngleOffset(const angle: angle_t);

var
  colfunc: PProcedure;
  wallcolfunc: PProcedure;
  skycolfunc: PProcedure;
  transcolfunc: PProcedure;
  averagecolfunc: PProcedure;
  alphacolfunc: PProcedure;
  maskedcolfunc: PProcedure;
  maskedcolfunc2: PProcedure; // For hi res textures
  fuzzcolfunc: PProcedure;
  lightcolfunc: PProcedure;
  whitelightcolfunc: PProcedure;
  redlightcolfunc: PProcedure;
  greenlightcolfunc: PProcedure;
  bluelightcolfunc: PProcedure;
  yellowlightcolfunc: PProcedure;
  spanfunc: PProcedure;

  centerxfrac: fixed_t;
  centeryfrac: fixed_t;
  centerxshift: fixed_t;

  viewx: fixed_t;
  viewy: fixed_t;
  viewz: fixed_t;

  viewangle: angle_t;

  shiftangle: byte;

  viewcos: fixed_t;
  viewsin: fixed_t;

  projection: fixed_t;
  projectiony: fixed_t; // JVAL For correct aspect

  centerx: integer;
  centery: integer;

  fixedcolormap: PByteArray;
  fixedcolormapnum: integer = 0;

// increment every time a check is made
  validcount: integer = 1;
  rendervalidcount: Integer = 1;

// bumped light from gun blasts
  extralight: integer;

  scalelight: array[0..LIGHTLEVELS - 1, 0..MAXLIGHTSCALE - 1] of PByteArray;
  scalelightlevels: array[0..LIGHTLEVELS - 1, 0..HLL_MAXLIGHTSCALE - 1] of fixed_t;
  scalelightfixed: array[0..MAXLIGHTSCALE - 1] of PByteArray;
  zlight: array[0..LIGHTLEVELS - 1, 0..MAXLIGHTZ - 1] of PByteArray;
  zlightlevels: array[0..LIGHTLEVELS - 1, 0..HLL_MAXLIGHTZ - 1] of fixed_t;

  viewplayer: Pplayer_t;

// The viewangletox[viewangle + FINEANGLES/4] lookup
// maps the visible view angles to screen X coordinates,
// flattening the arc to a flat projection plane.
// There will be many angles mapped to the same X.
  viewangletox: array[0..FINEANGLES div 2 - 1] of integer;

// The xtoviewangleangle[] table maps a screen pixel
// to the lowest viewangle that maps back to x ranges
// from clipangle to -clipangle.
  xtoviewangle: array[0..MAXWIDTH] of angle_t;

  clipangle: angle_t;

  sscount: integer;
  linecount: integer;
  loopcount: integer;

  viewangleoffset: angle_t = 0; // never a value assigned to this variable!

  setsizeneeded: boolean;

// Blocky mode, has default, 0 = high, 1 = normal
  screenblocks: integer;  // has default

procedure R_Ticker;

var
  viewpitch: integer;
  absviewpitch: integer;

implementation

uses
  mapdata,
  m_rnd,
  p_journey,
  p_tick,
  c_cmds,
  d_main,
  d_net,
  i_io,
  m_bbox,
  p_sight,
  m_menu,
  m_misc,
  p_setup,
  p_map,
  p_maputl,
  p_mobj_h,
  g_game,
  p_sun,
  r_draw,
  r_bsp,
  r_things,
  r_plane,
  r_sky,
  r_hires,
  r_lights,
  r_procs,
  r_intrpl,
  gl_render, // JVAL OPENGL
  gl_clipper,
  gl_tex,
  v_data, v_video,
  st_stuff,
  z_zone,
  hu_stuff;

const
// Fineangles in the SCREENWIDTH wide window.
  FIELDOFVIEW = 2048;

//
// R_PointOnSide
// Traverse BSP (sub) tree,
//  check point against partition plane.
// Returns side 0 (front) or 1 (back).
//
function R_PointOnSide(const x: fixed_t; const y: fixed_t; const node: Pnode_t): boolean;
var
  dx: fixed_t;
  dy: fixed_t;
  left: fixed_t;
  right: fixed_t;
begin
  if node.dx = 0 then
  begin
    if x <= node.x then
      result := node.dy > 0
    else
      result := node.dy < 0;
    exit;
  end;

  if node.dy = 0 then
  begin
    if y <= node.y then
      result := node.dx < 0
    else
      result := node.dx > 0;
    exit;
  end;

  dx := (x - node.x);
  dy := (y - node.y);

  // Try to quickly decide by looking at sign bits.
  if ((node.dy xor node.dx xor dx xor dy) and $80000000) <> 0 then
  begin
    result := ((node.dy xor dx) and $80000000) <> 0;
    exit;
  end;

  left := IntFixedMul(node.dy, dx);
  right := FixedIntMul(dy, node.dx);

  result := right >= left;
end;

//
// R_PointToAngle
// To get a global angle from cartesian coordinates,
//  the coordinates are flipped until they are in
//  the first octant of the coordinate system, then
//  the y (<=x) is scaled and divided by x to get a
//  tangent (slope) value which is looked up in the
//  tantoangle[] table.
//
// JVAL  -> Calculates: result := round(683565275 * (arctan2(y, x)));
//
function R_PointToAngle(x: fixed_t; y: fixed_t): angle_t;
begin
  x := x - viewx;
  y := y - viewy;

  if (x = 0) and (y = 0) then
  begin
    result := 0;
    exit;
  end;

  if x >= 0 then
  begin
    // x >=0
    if y >= 0 then
    begin
      // y>= 0
      if x > y then
      begin
        // octant 0
        result := tantoangle[SlopeDiv(y, x)];
        exit;
      end
      else
      begin
        // octant 1
        result := ANG90 - 1 - tantoangle[SlopeDiv(x, y)];
        exit;
      end;
    end
    else
    begin
      // y<0
      y := -y;
      if x > y then
      begin
        // octant 8
        result := -tantoangle[SlopeDiv(y, x)];
        exit;
      end
      else
      begin
        // octant 7
        result := ANG270 + tantoangle[SlopeDiv(x, y)];
        exit;
      end;
    end;
  end
  else
  begin
    // x<0
    x := -x;
    if y >= 0 then
    begin
      // y>= 0
      if x > y then
      begin
        // octant 3
        result := ANG180 - 1 - tantoangle[SlopeDiv(y, x)];
        exit;
      end
      else
      begin
        // octant 2
        result := ANG90 + tantoangle[SlopeDiv(x, y)];
        exit;
      end;
    end
    else
    begin
      // y<0
      y := -y;
      if x > y then
      begin
        // octant 4
        result := ANG180 + tantoangle[SlopeDiv(y, x)];
        exit;
      end
      else
      begin
        // octant 5
        result := ANG270 - 1 - tantoangle[SlopeDiv(x, y)];
        exit;
      end;
    end;
  end;

  result := 0;
end;

function R_PointToAngle2(const x1: fixed_t; const y1: fixed_t; const x2: fixed_t; const y2: fixed_t): angle_t;
begin
  result := R_PointToAngle(x2 - x1 + viewx, y2 - y1 + viewy);
end;

//
// R_InitTables
//
procedure R_InitTables;
begin
  finecosine := Pfixed_tArray(@finesine[FINEANGLES div 4]);
end;

//
// R_InitTextureMapping
//
procedure R_InitTextureMapping;
var
  i: integer;
  x: integer;
  t: integer;
  focallength: fixed_t;
  an: angle_t;
begin
  // Use tangent table to generate viewangletox:
  //  viewangletox will give the next greatest x
  //  after the view angle.
  //
  // Calc focallength
  //  so FIELDOFVIEW angles covers SCREENWIDTH.
  focallength := FixedDiv(centerxfrac, finetangent[FINEANGLES div 4 + FIELDOFVIEW div 2]);

  for i := 0 to FINEANGLES div 2 - 1 do
  begin
    if finetangent[i] > FRACUNIT * 2 then
      t := -1
    else if finetangent[i] < -FRACUNIT * 2 then
      t := viewwidth + 1
    else
    begin
      t := FixedMul(finetangent[i], focallength);
      t := (centerxfrac - t + (FRACUNIT - 1)) div FRACUNIT;

      if t < -1 then
        t := -1
      else if t > viewwidth + 1 then
        t := viewwidth + 1;
    end;
    viewangletox[i] := t;
  end;

  // Scan viewangletox[] to generate xtoviewangle[]:
  //  xtoviewangle will give the smallest view angle
  //  that maps to x.
  for x := 0 to viewwidth do
  begin
    an := 0;
    while viewangletox[an] > x do
      inc(an);
    xtoviewangle[x] := an * ANGLETOFINEUNIT - ANG90;
  end;

  // Take out the fencepost cases from viewangletox.
  for i := 0 to FINEANGLES div 2 - 1 do
  begin
    if viewangletox[i] = -1 then
      viewangletox[i] := 0
    else if viewangletox[i] = viewwidth + 1 then
      viewangletox[i] := viewwidth;
  end;
  clipangle := xtoviewangle[0];
end;

//
//
// Only inits the zlight table,
//  because the scalelight table changes with view size.
//
const
  DISTMAP = 2;

procedure R_InitLightTables;
var
  i: integer;
  j: integer;
  level: integer;
  startmap: integer;
  scale: integer;
  levelhi: integer;
  startmaphi: integer;
  scalehi: integer;
begin
  // Calculate the light levels to use
  //  for each level / distance combination.
  for i := 0 to LIGHTLEVELS - 1 do
  begin
    startmap := ((LIGHTLEVELS - 1 - i) * 2 * NUMCOLORMAPS) div LIGHTLEVELS;
    for j := 0 to MAXLIGHTZ - 1 do
    begin
      scale := FixedDiv(160 * FRACUNIT, _SHL(j + 1, LIGHTZSHIFT));
      scale := _SHR(scale, LIGHTSCALESHIFT);
      level := startmap - scale div DISTMAP;

      if level < 0 then
        level := 0
      else if level >= NUMCOLORMAPS then
        level := NUMCOLORMAPS - 1;

      zlight[i][j] := PByteArray(integer(colormaps) + level * 256);
    end;

    startmaphi := ((LIGHTLEVELS - 1 - i) * 2 * FRACUNIT) div LIGHTLEVELS;
    for j := 0 to HLL_MAXLIGHTZ - 1 do
    begin

      scalehi := FixedDiv(160 * FRACUNIT, _SHL(j + 1, HLL_LIGHTZSHIFT));
      scalehi := _SHR(scalehi, HLL_LIGHTSCALESHIFT);
      levelhi := FRACUNIT - startmaphi + scalehi div DISTMAP;

      if levelhi < 0 then
        levelhi := 0
      else if levelhi >= FRACUNIT then
        levelhi := FRACUNIT - 1;

      zlightlevels[i][j] := levelhi;
    end;
  end;

end;

//
// R_SetViewSize
// Do not really change anything here,
//  because it might be in the middle of a refresh.
// The change will take effect next refresh.
//
var
  setblocks: integer = -1;
  olddetail: integer = -1;

procedure R_SetViewSize;
begin
  if demoplayback then
    screenblocks := 12
  else
    screenblocks := 11; //jval: wolf
    
  if not allowlowdetails then
    if detailLevel < DL_NORMAL then
      detailLevel := DL_NORMAL;

  if (setblocks <> screenblocks) or (setdetail <> detailLevel) then
  begin
    if setdetail <> detailLevel then
      recalctablesneeded := true;
    setsizeneeded := true;
    setblocks := screenblocks;
    setdetail := detailLevel;
  end;
end;

//
// R_ExecuteSetViewSize
//
procedure R_ExecuteSetViewSize;
var
  i: integer;
  j: integer;
  level: integer;
  startmap: integer;
  levelhi: integer;
  startmaphi: integer;
begin
  setsizeneeded := false;

  if setblocks > 10 then
  begin
    scaledviewwidth := SCREENWIDTH;
    viewheight := SCREENHEIGHT;
  end
  else
  begin
    scaledviewwidth := (setblocks * SCREENWIDTH div 10) and (not 7);
    if setblocks = 10 then
      viewheight := trunc(ST_Y * SCREENHEIGHT / 200)
    else
      viewheight := (setblocks * trunc(ST_Y * SCREENHEIGHT / 2000)) and (not 7);
  end;

  viewwidth := scaledviewwidth;

  centery := viewheight div 2;
  centerx := viewwidth div 2;
  centerxfrac := centerx * FRACUNIT;
  centeryfrac := centery * FRACUNIT;
  projection := centerxfrac;
  projectiony := ((SCREENHEIGHT * centerx * 320) div 200) div SCREENWIDTH * FRACUNIT; // JVAL for correct aspect

  if olddetail <> setdetail then
  begin
    olddetail := setdetail;
  end;

  R_InitBuffer(scaledviewwidth, viewheight);

  R_InitTextureMapping;

  // psprite scales
  pspritescale := FRACUNIT * viewwidth div 320;
  pspriteiscale := FRACUNIT * 320 div viewwidth;
  pspriteyscale := (((SCREENHEIGHT * viewwidth) div SCREENWIDTH) * FRACUNIT) div 200;

  // thing clipping
  for i := 0 to viewwidth - 1 do
    screenheightarray[i] := viewheight;

  // Calculate the light levels to use
  //  for each level / scale combination.
  for i := 0 to LIGHTLEVELS - 1 do
  begin
    startmap := ((LIGHTLEVELS - 1 - i) * 2) * NUMCOLORMAPS div LIGHTLEVELS;
    for j := 0 to MAXLIGHTSCALE - 1 do
    begin
      level := startmap - j * SCREENWIDTH div viewwidth div DISTMAP;

      if level < 0 then
        level := 0
      else
      begin
        if level >= NUMCOLORMAPS then
          level := NUMCOLORMAPS - 1;
      end;

      scalelight[i][j] := PByteArray(integer(colormaps) + level * 256);
    end;
  end;

  if setdetail >= DL_NORMAL then
    for i := 0 to LIGHTLEVELS - 1 do
    begin
      startmaphi := ((LIGHTLEVELS - 1 - i) * 2 * FRACUNIT) div LIGHTLEVELS;
      for j := 0 to HLL_MAXLIGHTSCALE - 1 do
      begin
        levelhi := startmaphi - j * 16 * SCREENWIDTH div viewwidth;

        if levelhi < 0 then
          scalelightlevels[i][j] := FRACUNIT
        else if levelhi >= FRACUNIT then
            scalelightlevels[i][j] := 1
        else
          scalelightlevels[i][j] := FRACUNIT - levelhi;
      end;
    end;
end;

procedure R_CmdZAxisShift(const parm1: string = '');
var
  newz: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: zaxisshift = %s.'#13#10, [truefalseStrings[zaxisshift]]);
    exit;
  end;

  newz := C_BoolEval(parm1, zaxisshift);
  if newz <> zaxisshift then
  begin
    zaxisshift := newz;
    setsizeneeded := true;
  end;
  R_CmdZAxisShift;
end;

procedure R_CmdUse32boitfuzzeffect(const parm1: string = '');
var
  newusefz: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: use32bitfuzzeffect = %s.'#13#10, [truefalseStrings[use32bitfuzzeffect]]);
    exit;
  end;

  newusefz := C_BoolEval(parm1, use32bitfuzzeffect);
  if newusefz <> use32bitfuzzeffect then
  begin
    use32bitfuzzeffect := newusefz;
  end;
  R_CmdUse32boitfuzzeffect;
end;

procedure R_CmdDiher8bitTransparency(const parm1: string = '');
var
  newdih: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: diher8bittransparency = %s.'#13#10, [truefalseStrings[diher8bittransparency]]);
    exit;
  end;

  newdih := C_BoolEval(parm1, diher8bittransparency);
  if newdih <> diher8bittransparency then
  begin
    diher8bittransparency := newdih;
  end;
  R_CmdDiher8bitTransparency;
end;

procedure R_CmdScreenWidth;
begin
  printf('ScreenWidth = %d.'#13#10, [SCREENWIDTH]);
end;

procedure R_CmdScreenHeight;
begin
  printf('ScreenHeight = %d.'#13#10, [SCREENHEIGHT]);
end;

procedure R_CmdClearCache;
begin
  gld_ClearTextureMemory;
  Z_FreeTags(PU_CACHE, PU_CACHE);
  printf('Texture cache clear'#13#10);
end;

procedure R_CmdResetCache;
begin
  Z_FreeTags(PU_CACHE, PU_CACHE);
  printf('Texture cache reset'#13#10);
end;

//
// R_Init
//
procedure R_Init;
begin
  printf(#13#10 + 'R_InitProcs');
  R_InitProcs;
  printf(#13#10 + 'R_InitData');
  R_InitData;
  printf(#13#10 + 'R_InitInterpolations');
  R_InitInterpolations;
  printf(#13#10 + 'R_InitTables');
  R_InitTables;
  printf(#13#10 + 'R_SetViewSize');
  // viewwidth / viewheight / detailLevel are set by the defaults
  R_SetViewSize;
  printf(#13#10 + 'R_InitLightTables');
  R_InitLightTables;
  printf(#13#10 + 'R_InitTranslationsTables');
  R_InitTranslationTables;

  C_AddCmd('zaxisshift', @R_CmdZAxisShift);
  C_AddCmd('lowestres, lowestresolution', @R_CmdLowestRes);
  C_AddCmd('lowres, lowresolution', @R_CmdLowRes);
  C_AddCmd('mediumres, mediumresolution', @R_CmdMediumRes);
  C_AddCmd('normalres, normalresolution', @R_CmdNormalRes);
  C_AddCmd('hires, hiresolution', @R_CmdHiRes);
  C_AddCmd('ultrares, ultraresolution', @R_CmdUltraRes);
  C_AddCmd('detaillevel, displayresolution', @R_CmdDetailLevel);
  C_AddCmd('fullscreen', @R_CmdFullScreen);
  C_AddCmd('extremeflatfiltering', @R_CmdExtremeflatfiltering);
  C_AddCmd('32bittexturepaletteeffects, use32bittexturepaletteeffects', @R_Cmd32bittexturepaletteeffects);
  C_AddCmd('useexternaltextures', @R_CmdUseExternalTextures);
  C_AddCmd('use32bitfuzzeffect', @R_CmdUse32boitfuzzeffect);
  C_AddCmd('diher8bittransparency', @R_CmdDiher8bitTransparency);
  C_AddCmd('lightboostfactor', @R_CmdLightBoostFactor);
  C_AddCmd('screenwidth', @R_CmdScreenWidth);
  C_AddCmd('screenheight', @R_CmdScreenHeight);
  C_AddCmd('clearcache, cleartexturecache', @R_CmdClearCache);
  C_AddCmd('resetcache, resettexturecache', @R_CmdResetCache);
end;

procedure R_ShutDown;
begin
  printf(#13#10 + 'R_ShutDownLightBoost');
  R_ShutDownLightBoost;
  printf(#13#10 + 'R_ShutDownInterpolation');
  R_ResetInterpolationBuffer;
  printf(#13#10 + 'R_FreeMemory');
  R_FreeMemory;
  printf(#13#10 + 'R_ShutDownOpenGL');
  R_ShutDownOpenGL;
  printf(#13#10);
end;

//
// R_PointInSubsector
//
function R_PointInSubsector(const x: fixed_t; const y: fixed_t): Psubsector_t;
var
  node: Pnode_t;
  nodenum: integer;
begin
  // single subsector is a special case
  if numnodes = 0 then
  begin
    result := @subsectors[0];
    exit;
  end;

  nodenum := numnodes - 1;

  while nodenum and NF_SUBSECTOR = 0 do
  begin
    node := @nodes[nodenum];
    if R_PointOnSide(x, y, node) then
      nodenum := node.children[1]
    else
      nodenum := node.children[0]
  end;

  result := @subsectors[nodenum and (not NF_SUBSECTOR)];
end;

//
// R_AdjustChaseCamera
//
// JVAL: Adjust the chace camera position
//       A bit clumsy but works OK
//
const
  CAMERARADIOUS = 32 * FRACUNIT;
var
  lastchasex, lastchasey, lastchasez: fixed_t;

procedure R_AdjustChaseCamera;
var
  c_an: angle_t;
  cx, cy, cz: fixed_t;
  dx, dy: fixed_t;
  loops: integer;
  sec: Psector_t;
  sec2: Psector_t;
  ceilz, floorz: fixed_t;
  i: integer;
  size1: integer;
  dz: double;
begin
  if chasecamera then
  begin
    if norender then
    begin
      viewx := lastchasex;
      viewy := lastchasey;
      viewz := lastchasez;
      Exit;
    end;

    chasecamera_viewxy := journeymapinfo[gamemap].view_xy;
    chasecamera_viewz := journeymapinfo[gamemap].view_z;

    sec := Psubsector_t(viewplayer.mo.subsector).sector;
    ceilz := sec.ceilingheight + P_SectorJumpOverhead(sec) - CAMERARADIOUS;
    cz := viewz + chasecamera_viewz * FRACUNIT;
    floorz := viewz + CAMERARADIOUS;
    if cz > ceilz - 8 * FRACUNIT then
      cz := ceilz - 8 * FRACUNIT
    else
    begin
      if cz < floorz then
        cz := floorz
    end;

    c_an := (viewangle + ANG180) shr ANGLETOFINESHIFT;
    dx := chasecamera_viewxy * finecosine[c_an];
    dy := chasecamera_viewxy * finesine[c_an];

    loops := 0;
    repeat
      cx := viewx + dx;
      cy := viewy + dy;
      if P_CheckCameraSight(cx, cy, cz, viewplayer.mo) then
        break;
      dx := dx * 127 div 128;
      dy := dy * 127 div 128;
      inc(loops);
    until loops > 1024;

    dx := 16 * finecosine[c_an];
    dy := 16 * finesine[c_an];

    viewx := cx - dx;
    viewy := cy - dy;

    if loops > 1 then
    begin
      size1 := HU_FPS div 10;
      if size1 < 2 then
        size1 := 2;

      qx.Add(viewx);
      while qx.Count > size1 do
        qx.Remove;

      dz := 0;
      for i := 0 to qx.Count - 1 do
        dz := dz + qx.Numbers[i] / FRACUNIT;
      viewx := round(dz * FRACUNIT / qx.Count);

      qy.Add(viewy);
      while qy.Count > size1 do
        qy.Remove;

      dz := 0;
      for i := 0 to qy.Count - 1 do
        dz := dz + qy.Numbers[i] / FRACUNIT;
      viewy := round(dz * FRACUNIT / qy.Count);

      if not P_CheckCameraSight(viewx, viewy, cz, viewplayer.mo) then
      begin
        viewx := qx.Numbers[qx.Count - 1];
        viewy := qy.Numbers[qx.Count - 1];
      end;

    end
    else
    begin
      qx.Clear;
      qy.Clear;
    end;

    qz.Add(floorz);
    size1 := HU_FPS div 10;
    if size1 < 2 then
      size1 := 2;
    while qz.Count > size1 do
      qz.Remove;

    dz := 0;
    for i := 0 to qz.Count - 1 do
      dz := dz + qz.Numbers[i] / FRACUNIT;
    floorz := round(dz * FRACUNIT / qz.Count);

    if cz < floorz  + 8 * FRACUNIT then
      cz := floorz + 8 * FRACUNIT;

    sec2 := R_PointInSubsector(viewx, viewy).sector;
    floorz := sec2.floorheight;
    if cz < floorz + 8 * FRACUNIT then
      cz := floorz + 8 * FRACUNIT;
    ceilz := sec2.ceilingheight + P_SectorJumpOverhead(sec2);
    if cz > ceilz - 8 * FRACUNIT then
      cz := ceilz - 8 * FRACUNIT;
    viewz := cz;

    dx := (players[consoleplayer].mo.x - viewx) div 128;
    dy := (players[consoleplayer].mo.y - viewy) div 128;
    loops := 0;
    while Abs((viewz - players[consoleplayer].mo.z) div FRACUNIT) > 128 do
    begin
      viewx := viewx - dx;
      viewy := viewy - dy;

      sec2 := R_PointInSubsector(viewx, viewy).sector;
      floorz := sec2.floorheight;
      if cz < floorz + 8 * FRACUNIT then
        cz := floorz + 8 * FRACUNIT;
      ceilz := sec2.ceilingheight + P_SectorJumpOverhead(sec2);
      if cz > ceilz - 8 * FRACUNIT then
        cz := ceilz - 8 * FRACUNIT;
      viewz := cz;

      inc(loops);
      if loops = 129 then
        Break;
    end;

    if Abs((viewz - players[consoleplayer].mo.z) div FRACUNIT) > 128 then
      if loops = 129 then
      begin
        viewx := players[consoleplayer].mo.x;
        viewy := players[consoleplayer].mo.y;
        viewz := players[consoleplayer].mo.z + players[consoleplayer].mo.height + chasecamera_viewz * FRACUNIT;
      end;

    size1 :=  HU_FPS div 10;
    if size1 < 1 then
      size1 := 1;

    qzz.Add(viewz);
    while qzz.Count > size1 do
      qzz.Remove;

    dz := 0;
    for i := 0 to qzz.Count - 1 do
      dz := dz + qzz.Numbers[i] / FRACUNIT;
    viewz := round(dz * FRACUNIT / qzz.Count);

    if viewz < journeymapinfo[gamemap].min_viewz then
      viewz := journeymapinfo[gamemap].min_viewz;

    lastchasex := viewx;
    lastchasey := viewy;
    lastchasez := viewz;
  end;
end;

//
// R_SetupFrame
//
var
  quakerndseed: integer = 0;

procedure R_SetupFrame(player: Pplayer_t);
var
  i: integer;
  cy: fixed_t;
begin
  viewplayer := player;
  shiftangle := player.lookdir2;
  if gamemap = 1 then
    viewangle := player.mo.angle + viewangleoffset
  else
    viewangle := player.mo.angle + shiftangle * DIR256TOANGLEUNIT + viewangleoffset;
  extralight := player.extralight;

  viewx := player.mo.x;
  viewy := player.mo.y;
  viewz := player.viewz;

  R_AdjustChaseCamera;

  if (player.quaketics > 0) and not isgamesuspended then
  begin
    viewx := viewx + (4 - (C_Random(quakerndseed) mod 8)) * FRACUNIT;
    viewy := viewy + (4 - (C_Random(quakerndseed) mod 8)) * FRACUNIT;
  end;


  viewpitch := 0;
  absviewpitch := 0;
//******************************
// JVAL Enabled z axis shift
  if zaxisshift and ((player.lookdir <> 0) or p_justspawned) and (viewangleoffset = 0) then
  begin
    cy := (viewheight + player.lookdir * screenblocks * SCREENHEIGHT div 1000) div 2;
    if centery <> cy then
    begin
      centery := cy;
      centeryfrac := centery * FRACUNIT;
    end;

    viewpitch := player.lookdir;
    absviewpitch := abs(viewpitch);
  end
  else
    p_justspawned := false;
//******************************

  viewsin := finesine[viewangle shr ANGLETOFINESHIFT];
  viewcos := finecosine[viewangle shr ANGLETOFINESHIFT];

  sscount := 0;

  fixedcolormapnum := player.fixedcolormap;
  if fixedcolormapnum <> 0 then
  begin
    fixedcolormap := PByteArray(
      integer(colormaps) + fixedcolormapnum * 256);

    for i := 0 to MAXLIGHTSCALE - 1 do
      scalelightfixed[i] := fixedcolormap;
  end
  else
    fixedcolormap := nil;

  inc(validcount);
end;

procedure R_SetViewAngleOffset(const angle: angle_t);
begin
  viewangleoffset := angle;
end;

//
// R_RenderView
//

procedure R_RenderPlayerView(player: Pplayer_t);
begin

  if norender then
    exit;

  R_SetupFrame(player);

  // Clear buffers.
  R_ClearPlanes;
  R_ClearSprites;

  gld_StartDrawScene; // JVAL OPENGL

  // check for new console commands.
  NetUpdate;

  gld_ClipperAddViewRange;
 // if P_CanSeeSun(player.mo) then
  if sun <> nil then
    gld_AddSun(sun);

  // The head node is the last node output.
  R_RenderBSP;

  R_RenderAdditionalSprites;
//  HU_CmdFPS;

  // Check for new console commands.
  NetUpdate;

  gld_DrawScene(player);

  NetUpdate;

  gld_EndDrawScene;

  // Check for new console commands.
  NetUpdate;

end;

procedure R_Ticker;
begin
  R_InterpolateTicker;
end;

procedure R_ResetSmooth;
begin
  qz.Clear;
  qzz.Clear;
end;

initialization
  qx := TIntegerQueue.Create;
  qy := TIntegerQueue.Create;
  qz := TIntegerQueue.Create;
  qzz := TIntegerQueue.Create;

finalization
  qx.Free;
  qy.Free;
  qz.Free;
  qzz.Free;

end.
