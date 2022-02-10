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

unit gl_sky;

interface

uses
  r_sky;

//==============================================================================
//
// gld_InitSky
//
//==============================================================================
procedure gld_InitSky;

//==============================================================================
//
// gld_DrawSky
//
//==============================================================================
procedure gld_DrawSky;

//==============================================================================
//
// gld_SkyDone
//
//==============================================================================
procedure gld_SkyDone;

implementation

uses
  d_delphi,
  dglOpenGL,
  gl_tex,
  gl_defs;

const
  COMPLEXITY = 32;

var
  fSkyListUpper: GLuint;
  fSkyListLower: GLuint;

//==============================================================================
//
// gld_InitSky
//
//==============================================================================
procedure gld_InitSky;
var
  iRotationStep: double;
  asize: Double;
  iRotationZ, iRotationY: double;
  iStartPoint, iTemp: TGLVectorf3;
  iI, iJ, iX, iY: Integer;
  iUStep: Double;
  iMatrix: TGLMatrixf4;
  iVertices: array[0..(COMPLEXITY div 4 + 1) * (COMPLEXITY + 1) - 1] of TGLVectorf3;
  iUVCoords: array[0..(COMPLEXITY div 4 + 1) * (COMPLEXITY + 1) - 1] of TGLVectorf2;
  ipos: integer;
begin
  asize := 10000.00;
  iRotationStep := 2 * __glPi / COMPLEXITY;
  iStartPoint[0] := aSize;
  iStartPoint[1] := 0.0;
  iStartPoint[2] := 0.0;

  iUStep := - 4 / (COMPLEXITY);
  iRotationZ := 0;
  ipos := 0;
  for iI := (COMPLEXITY div 4) downto 0 do
  begin
    iRotationY := 0;
    for iJ := 0 to COMPLEXITY do
    begin
      ZeroMemory(@iMatrix, SizeOf(iMatrix));
      iMatrix[0, 0] := cos(iRotationY);
      iMatrix[0, 2] := sin(iRotationY);
      iMatrix[1, 1] := 1.0;
      iMatrix[2, 0] := -sin(iRotationY);
      iMatrix[2, 2] := cos(iRotationY);
      iMatrix[3, 3] := 1.0;

      iTemp[0] := iStartPoint[0] * iMatrix[0, 0] + iStartPoint[1] * iMatrix[1, 0] + iStartPoint[2] * iMatrix[2, 0] + iMatrix[3, 0];
      iTemp[1] := iStartPoint[0] * iMatrix[0, 1] + iStartPoint[1] * iMatrix[1, 1] + iStartPoint[2] * iMatrix[2, 1] + iMatrix[3, 1];
      iTemp[2] := iStartPoint[0] * iMatrix[0, 2] + iStartPoint[1] * iMatrix[1, 2] + iStartPoint[2] * iMatrix[2, 2] + iMatrix[3, 2];

      iVertices[ipos] := iTemp;

      iUVCoords[ipos][0] := iJ * iUStep;
      iUVCoords[ipos][1] := -(iTemp[1] / aSize * 1.2 + 0.01);
      if iUVCoords[ipos][1] < -1.0 then
        iUVCoords[ipos][1] := - 2 - iUVCoords[ipos][1];
      inc(ipos);
      iRotationY := iRotationY + iRotationStep;
    end;
    iStartPoint[0] := aSize;
    iStartPoint[1] := 0.0;
    iStartPoint[2] := 0.0;
    iRotationZ := iRotationZ - iRotationStep;
    ZeroMemory(@iMatrix, SizeOf(iMatrix));
    iMatrix[0, 0] := cos(iRotationZ);
    iMatrix[1, 0] := sin(iRotationZ);
    iMatrix[0, 1] := -sin(iRotationZ);
    iMatrix[1, 1] := cos(iRotationZ);
    iTemp[0] := iStartPoint[0] * iMatrix[0, 0] + iStartPoint[1] * iMatrix[1, 0] + iStartPoint[2] * iMatrix[2, 0] + iMatrix[3, 0];
    iTemp[1] := iStartPoint[0] * iMatrix[0, 1] + iStartPoint[1] * iMatrix[1, 1] + iStartPoint[2] * iMatrix[2, 1] + iMatrix[3, 1];
    iTemp[2] := iStartPoint[0] * iMatrix[0, 2] + iStartPoint[1] * iMatrix[1, 2] + iStartPoint[2] * iMatrix[2, 2] + iMatrix[3, 2];
    iStartPoint := iTemp;
  end;

  fSkyListUpper := glGenLists(1);

  glNewList(fSkyListUpper, GL_COMPILE);

  glColor4fv(@gl_whitecolor);
  for iI := 0 to (COMPLEXITY div 4) - 1 do
  begin
    glBegin(GL_TRIANGLE_STRIP);
    for iJ := 0 to COMPLEXITY do
    begin
      iX := iJ + (iI * (COMPLEXITY + 1));
      iY := iJ + ((iI + 1) * (COMPLEXITY + 1));

      if iVertices[iY][1] > aSize / 1.8 then
        glColor4f(1 - (iVertices[iY][1] - aSize / 1.6)/ iVertices[iY][1] * 4.8,
                  1 - (iVertices[iY][1] - aSize / 1.6)/ iVertices[iY][1] * 4.8,
                  1 - (iVertices[iY][1] - aSize / 1.6)/ iVertices[iY][1] * 4.8, 1.0);
      glTexCoord2fv(@iUVCoords[iY]);
      glVertex3fv(@iVertices[iY]);

      if iVertices[iX][1] > aSize / 1.8 then
        glColor4f(1 - (iVertices[iX][1] - aSize / 1.6)/ iVertices[iX][1] * 4.8,
                  1 - (iVertices[iX][1] - aSize / 1.6)/ iVertices[iX][1] * 4.8,
                  1 - (iVertices[iX][1] - aSize / 1.6)/ iVertices[iX][1] * 4.8, 1.0);
      glTexCoord2fv(@iUVCoords[iX]);
      glVertex3fv(@iVertices[iX]);
    end;
    glEnd;
  end;

  glEndList;

  for iI := 0 to (COMPLEXITY div 4 + 1) * (COMPLEXITY + 1) - 1 do
    iVertices[iI][1] := 1.0 -iVertices[iI][1];

  fSkyListLower := glGenLists(1);

  glNewList(fSkyListLower, GL_COMPILE);

  glColor4fv(@gl_whitecolor);
  for iI := 0 to (COMPLEXITY div 4) - 1 do
  begin
    glBegin(GL_TRIANGLE_STRIP);
    for iJ := 0 to COMPLEXITY do
    begin
      iX := iJ + (iI * (COMPLEXITY + 1));
      iY := iJ + ((iI + 1) * (COMPLEXITY + 1));

      if iVertices[iY][1] < -aSize / 1.8 then
        glColor4f(1 + (-iVertices[iY][1] - aSize / 1.6)/ iVertices[iY][1] * 4.8,
                  1 + (-iVertices[iY][1] - aSize / 1.6)/ iVertices[iY][1] * 4.8,
                  1 + (-iVertices[iY][1] - aSize / 1.6)/ iVertices[iY][1] * 4.8, 1.0);
      glTexCoord2fv(@iUVCoords[iY]);
      glVertex3fv(@iVertices[iY]);

      if iVertices[iX][1] < -aSize / 1.8 then
        glColor4f(1 + (-iVertices[iX][1] - aSize / 1.6)/ iVertices[iX][1] * 4.8,
                  1 + (-iVertices[iX][1] - aSize / 1.6)/ iVertices[iX][1] * 4.8,
                  1 + (-iVertices[iX][1] - aSize / 1.6)/ iVertices[iX][1] * 4.8, 1.0);
      glTexCoord2fv(@iUVCoords[iX]);
      glVertex3fv(@iVertices[iX]);
    end;
    glEnd;
  end;

  glEndList;

end;

//==============================================================================
//
// gld_DrawSky
//
//==============================================================================
procedure gld_DrawSky;
begin
  glDisable(GL_CULL_FACE);
  glDisable(GL_DEPTH_TEST);
  glDepthMask(FALSE);
  gld_BindTexture(gld_RegisterTexture(skytexture, false));
  glCallList(fSkyListUpper);
  glCallList(fSkyListLower);
  glDepthMask(TRUE);
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_CULL_FACE);
end;

//==============================================================================
//
// gld_SkyDone
//
//==============================================================================
procedure gld_SkyDone;
begin
  glDeleteLists(fSkyListLower, 1);
  glDeleteLists(fSkyListUpper, 1);
end;

end.

