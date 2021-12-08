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

unit r_hires;

// Description
// Hi resolution support

interface

uses
  d_delphi,
  m_fixed;

var
  detailLevel: integer;
  extremeflatfiltering: boolean;
  setdetail: integer = -1;
  allowlowdetails: boolean = true;
  usetransparentsprites: boolean;
  useexternaltextures: boolean;
  dc_32bittexturepaletteeffects: boolean;

const
  DL_LOWEST = 0;
  DL_LOW = 1;
  DL_MEDIUM = 2;
  DL_NORMAL = 3;
  DL_HIRES = 4;
  DL_ULTRARES = 5;
  DL_NUMRESOLUTIONS = 6;

const
  detailStrings: array[0..DL_NUMRESOLUTIONS - 1] of string = ('LOWEST', 'LOW', 'MEDIUM', 'NORMAL', 'HIGH', 'ULTRA');
  flatfilteringstrings: array[boolean] of string = ('NORMAL', 'EXTREME');

procedure R_CmdLowestRes(const parm1: string = '');
procedure R_CmdLowRes(const parm1: string = '');
procedure R_CmdMediumRes(const parm1: string = '');
procedure R_CmdNormalRes(const parm1: string = '');
procedure R_CmdHiRes(const parm1: string = '');
procedure R_CmdUltraRes(const parm1: string = '');
procedure R_CmdDetailLevel(const parm1: string = '');
procedure R_CmdExtremeflatfiltering(const parm1: string = '');
procedure R_CmdFullScreen(const parm1: string = '');
procedure R_Cmd32bittexturepaletteeffects(const parm1: string = '');
procedure R_CmdUseExternalTextures(const parm1: string = '');

function R_ColorAdd(const c1, c2: LongWord): LongWord; register;

const
  DC_HIRESBITS = 3;
  DC_HIRESFACTOR = 1 shl DC_HIRESBITS;

type
  hirestable_t = array[0..DC_HIRESFACTOR - 1, 0..255, 0..255] of LongWord;
  Phirestable_t = ^hirestable_t;
  hiresmodtable_t = array[0..255, 0..255] of LongWord;
  Phiresmodtable_t = ^hiresmodtable_t;

var
  hirestable: hirestable_t;
  recalctablesneeded: boolean = true;

procedure R_InitHiRes;

var
  pal_color: LongWord;

implementation

uses
  c_cmds,
  gamedef,
  m_misc,
  i_system,
  gl_main,
  gl_tex,
  r_defs,
  r_main,
  r_data,
  r_lights,
  v_video,
  w_wad,
  z_zone;

////////////////////////////////////////////////////////////////////////////////
//
// Commands
//

//
// R_CmdLowestRes
//
procedure R_CmdLowestRes(const parm1: string = '');
var
  newres: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: lowestres = %s.'#13#10, [truefalseStrings[detailLevel = DL_LOWEST]]);
    exit;
  end;

  newres := C_BoolEval(parm1, detailLevel = DL_LOWEST);
  if newres <> (detailLevel = DL_LOWEST) then
  begin
    if newres then
      detailLevel := DL_LOWEST
    else
      detailLevel := DL_MEDIUM;
    R_SetViewSize;
  end;
  R_CmdLowestRes;
end;


//
// R_CmdLowRes
//
procedure R_CmdLowRes(const parm1: string = '');
var
  newres: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: lowres = %s.'#13#10, [truefalseStrings[detailLevel = DL_LOW]]);
    exit;
  end;

  newres := C_BoolEval(parm1, detailLevel = DL_LOW);
  if newres <> (detailLevel = DL_LOW) then
  begin
    if newres then
      detailLevel := DL_LOW
    else
      detailLevel := DL_MEDIUM;
    R_SetViewSize;
  end;
  R_CmdLowRes;
end;

//
// R_CmdMediumRes
//
procedure R_CmdMediumRes(const parm1: string = '');
var
  newres: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: mediumres = %s.'#13#10, [truefalseStrings[detailLevel = DL_MEDIUM]]);
    exit;
  end;

  newres := C_BoolEval(parm1, detailLevel = DL_MEDIUM);
  if newres <> (detailLevel = DL_MEDIUM) then
  begin
    if newres then
      detailLevel := DL_MEDIUM
    else
      detailLevel := DL_NORMAL;
    R_SetViewSize;
  end;
  R_CmdNormalRes;
end;

//
// R_CmdNormalRes
//
procedure R_CmdNormalRes(const parm1: string = '');
var
  newres: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: normalres = %s.'#13#10, [truefalseStrings[detailLevel = DL_NORMAL]]);
    exit;
  end;

  newres := C_BoolEval(parm1, detailLevel = DL_NORMAL);
  if newres <> (detailLevel = DL_NORMAL) then
  begin
    if newres then
      detailLevel := DL_NORMAL
    else
      detailLevel := DL_MEDIUM;
    R_SetViewSize;
  end;
  R_CmdNormalRes;
end;

//
// R_CmdHiRes
//
procedure R_CmdHiRes(const parm1: string = '');
var
  newres: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: hires = %s.'#13#10, [truefalseStrings[detailLevel = DL_HIRES]]);
    exit;
  end;

  newres := C_BoolEval(parm1, detailLevel = DL_HIRES);
  if newres <> (detailLevel = DL_HIRES) then
  begin
    if newres then
      detailLevel := DL_HIRES
    else
      detailLevel := DL_NORMAL;
    R_SetViewSize;
  end;
  R_CmdHiRes;
end;

//
// R_CmdUltraRes
//
procedure R_CmdUltraRes(const parm1: string = '');
var
  newres: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: ultrares = %s.'#13#10, [truefalseStrings[detailLevel = DL_ULTRARES]]);
    if detailLevel = DL_ULTRARES then
      printf('true.'#13#10)
    else
      printf('false.'#13#10);
    exit;
  end;

  newres := C_BoolEval(parm1, detailLevel = DL_ULTRARES);
  if newres <> (detailLevel = DL_ULTRARES) then
  begin
    if newres then
      detailLevel := DL_ULTRARES
    else
      detailLevel := DL_HIRES;
    R_SetViewSize;
  end;
  R_CmdUltraRes;
end;

//
// R_CmdDetailLevel
//
procedure R_CmdDetailLevel(const parm1: string = '');
var
  i, newdetail: integer;
  s_det: string;
begin
  if parm1 = '' then
  begin
    printf('Current setting: detailLevel = %s.'#13#10, [detailStrings[detailLevel]]);
    exit;
  end;

  s_det := strupper(parm1);
  newdetail := -1;
  for i := 0 to DL_NUMRESOLUTIONS - 1 do
    if s_det = detailStrings[i] then
    begin
      newdetail := i;
      break;
    end;

  if newdetail = -1 then
    newdetail := atoi(parm1, detailLevel);
  if newdetail <> detailLevel then
  begin
    detailLevel := newdetail;
    R_SetViewSize;
  end;

  R_CmdDetailLevel;
end;

procedure R_CmdFullScreen(const parm1: string = '');
var
  newfullscreen: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: fullscreen = ');
    if fullscreen then
      printf('true.'#13#10)
    else
      printf('false.'#13#10);
    exit;
  end;

  newfullscreen := C_BoolEval(parm1, fullscreen);

  if newfullscreen <> fullscreen then
    GL_ChangeFullScreen(newfullscreen);

  R_CmdFullScreen;
end;

procedure R_CmdExtremeflatfiltering(const parm1: string = '');
var
  newflatfiltering: boolean;
  parm: string;
begin
  if parm1 = '' then
  begin
    printf('Current setting: extremeflatfiltering = %s.'#13#10, [flatfilteringstrings[extremeflatfiltering]]);
    exit;
  end;

  parm := strupper(parm1);
  if parm = flatfilteringstrings[true] then
    newflatfiltering := true
  else if parm = flatfilteringstrings[false] then
    newflatfiltering := false
  else
    newflatfiltering := C_BoolEval(parm1, extremeflatfiltering);

  if extremeflatfiltering <> newflatfiltering then
  begin
    extremeflatfiltering := newflatfiltering;
  end;
  R_CmdExtremeflatfiltering;
end;

procedure R_Cmd32bittexturepaletteeffects(const parm1: string = '');
var
  new_32bittexturepaletteeffects: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: 32bittexturepaletteeffects = %s.'#13#10, [truefalseStrings[dc_32bittexturepaletteeffects]]);
    exit;
  end;

 new_32bittexturepaletteeffects := C_BoolEval(parm1, dc_32bittexturepaletteeffects);

  if dc_32bittexturepaletteeffects <> new_32bittexturepaletteeffects then
  begin
    dc_32bittexturepaletteeffects := new_32bittexturepaletteeffects;
  end;
  R_Cmd32bittexturepaletteeffects;
end;

procedure R_CmdUseExternalTextures(const parm1: string = '');
var
  new_useexternaltextures: boolean;
begin
  if parm1 = '' then
  begin
    printf('Current setting: useexternaltextures = %s.'#13#10, [truefalseStrings[useexternaltextures]]);
    exit;
  end;

  new_useexternaltextures := C_BoolEval(parm1, useexternaltextures);

  if useexternaltextures <> new_useexternaltextures then
  begin
    useexternaltextures := new_useexternaltextures;
    gld_ClearTextureMemory;
  end;
  R_CmdUseExternalTextures;
end;

////////////////////////////////////////////////////////////////////////////////

function R_ColorAdd(const c1, c2: LongWord): LongWord; register;
var
  r1, g1, b1: byte;
  r2, g2, b2: byte;
  r, g, b: LongWord;
begin
  r1 := c1;
  g1 := c1 shr 8;
  b1 := c1 shr 16;
  r2 := c2;
  g2 := c2 shr 8;
  b2 := c2 shr 16;

  r := r1 + r2;
  if r > 255 then
    r := 255;
  g := g1 + g2;
  if g > 255 then
    g := 255;
  b := b1 + b2;
  if b > 255 then
    b := 255;
  result := r + g shl 8 + b shl 16;
end;

procedure R_InitHiRes;
begin
  R_InitLightBoost;
end;

end.

