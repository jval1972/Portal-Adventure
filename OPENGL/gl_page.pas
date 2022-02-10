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

unit gl_page;

interface

//==============================================================================
//
// gld_DrawPage
//
//==============================================================================
procedure gld_DrawPage(const pgname: string);

implementation

uses
  dglOpenGL,
  gamedef,
  gl_main,
  gl_render,
  gl_tex;

//==============================================================================
//
// gld_DrawPage
//
//==============================================================================
procedure gld_DrawPage(const pgname: string);
var
  tex: GLUInt;
begin
  if hMainWnd = 0 then
    exit;

  tex := gld_LoadExternalTexture(pgname, false, GL_CLAMP);

  glPushAttrib(GL_ALL_ATTRIB_BITS);
  gld_Enable2D;

  glColor4f(1.0, 1.0, 1.0, 1.0);
  glEnable(GL_ALPHA_TEST);
  glAlphaFunc(GL_NOTEQUAL, 0);

    glBindTexture(GL_TEXTURE_2D, tex);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0, 1.0);
      glVertex2f(0, 0);
      glTexCoord2f(1.0, 1.0);
      glVertex2f(SCREENWIDTH, 0);
      glTexCoord2f(1.0, 0.0);
      glVertex2f(SCREENWIDTH, SCREENHEIGHT);
      glTexCoord2f(0.0, 0.0);
      glVertex2f(0, SCREENHEIGHT);
    glEnd;

  gld_Disable2D;
  glPopAttrib;
  gld_Finish;
  glDeleteTextures(1, @tex);
end;

end.
