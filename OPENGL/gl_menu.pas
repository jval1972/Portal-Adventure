//------------------------------------------------------------------------------
//
//  Portal Adventure - 2nd PGD Challenge: The Journey
//  Copyright (C) 2012 by Jim Valavanis
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

unit gl_menu;

interface

procedure gld_InitMenus;

procedure gld_MenusDone;

procedure gld_MenuDrawer;

implementation

uses
  dglOpenGL,
  d_delphi,
  gamedef,
  gl_tex,
  m_menu;

type
  glmenuitem_t = record
    id: string[3];
    tex: LongWord;
  end;

const
  NUMMENUTEXTURES = 38;

var
  menutextures: array[0..NUMMENUTEXTURES - 1] of glmenuitem_t;
  bckshade: LongWord;

procedure gld_InitMenus;
var
  i, k: integer;
begin
  k := 0;

  for i := 1 to 6 do
  begin
    menutextures[k].id := '0' + itoa(i) + 'a';
    inc(k);
    menutextures[k].id := '0' + itoa(i) + 'b';
    inc(k);
  end;

  for i := 1 to 4 do
  begin
    menutextures[k].id := '1' + itoa(i) + 'a';
    inc(k);
    menutextures[k].id := '1' + itoa(i) + 'b';
    inc(k);
  end;

  for i := 0 to 8 do
  begin
    menutextures[k].id := '2' + itoa(i) + 'a';
    inc(k);
    menutextures[k].id := '2' + itoa(i) + 'b';
    inc(k);
  end;

  for i := 0 to NUMMENUTEXTURES - 1 do
    menutextures[i].tex := gld_LoadExternalTexture('menu' + menutextures[i].id + '.material', True, GL_CLAMP);

  bckshade := gld_LoadExternalTexture('menushade.material', True, GL_REPEAT);
end;

procedure gld_MenusDone;
var
  i: integer;
begin
  for i := 0 to NUMMENUTEXTURES - 1 do
    glDeleteTextures(1, @menutextures[i].tex);

  glDeleteTextures(1, @bckshade);
end;

function f_findmenutextureindex(const s: string): integer;
var
  i: integer;
begin
  for i := 0 to NUMMENUTEXTURES - 1 do
    if menutextures[i].id = s then
    begin
      result := i;
      exit;
    end;

  result := -1;
end;

procedure gld_MenuDrawer;
var
  i: integer;
  idx: Integer;
  l, r: integer;
begin
  if menudrawitems = nil then
    exit;

  if menudrawitems.Count = 0 then
    exit;

  last_gltexture := nil;

  if shademenubackground then
  begin
    glBindTexture(GL_TEXTURE_2D, bckshade);
    last_cm := -1;
      glBegin(GL_QUADS);
        glTexCoord2f(0.0, 1.0);
        glVertex2i(0, 0);
        glTexCoord2f(1.0, 1.0);
        glVertex2i(SCREENWIDTH, 0);
        glTexCoord2f(1.0, 0.0);
        glVertex2i(SCREENWIDTH, SCREENHEIGHT);
        glTexCoord2f(0.0, 0.0);
        glVertex2i(0, SCREENHEIGHT);
      glEnd;
  end;

  l := (SCREENWIDTH - 300) div 2;
  r := l + 512;
  for i := 0 to menudrawitems.Count - 1 do
  begin
    idx := f_findmenutextureindex(menudrawitems.Strings[i]);
    if idx >= 0 then
    begin
      glBindTexture(GL_TEXTURE_2D, menutextures[idx].tex);
      glBegin(GL_QUADS);
        glTexCoord2f(0.0, 1.0);
        glVertex2i(l, SCREENHEIGHT - 96 - i * 40);
        glTexCoord2f(1.0, 1.0);
        glVertex2i(r, SCREENHEIGHT - 96 - i * 40);
        glTexCoord2f(1.0, 0.0);
        glVertex2i(r, SCREENHEIGHT - 32 - i * 40);
        glTexCoord2f(0.0, 0.0);
        glVertex2i(l, SCREENHEIGHT - 32 - i * 40);
      glEnd;
    end;
  end;
end;

end.

