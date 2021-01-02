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

unit gl_multisample;

interface

uses
  Windows,
  dglOpenGL;

const
  CHECK_FOR_MULTISAMPLE = true;
  WGL_SAMPLE_BUFFERS_ARB = $2041;
  WGL_SAMPLES_ARB	= $2042;
  WGL_DRAW_TO_WINDOW_ARB = $2001;
  WGL_SUPPORT_OPENGL_ARB = $2010;
  WGL_ACCELERATION_ARB = $2003;
  WGL_FULL_ACCELERATION_ARB = $2027;
  WGL_COLOR_BITS_ARB = $2014;
  WGL_ALPHA_BITS_ARB = $201B;
  WGL_DEPTH_BITS_ARB = $2022;
  WGL_STENCIL_BITS_ARB = $2023;
  WGL_DOUBLE_BUFFER_ARB = $2011;

var
  arbMultisampleSupported: boolean = false;
  arbMultisampleFormat: integer = 0;

function InitMultisample(hInstance: HINST; hWnd: HWND; pfd: PIXELFORMATDESCRIPTOR): boolean;

implementation

function WGLisExtensionSupported(const extension: string): boolean;
var
  wglGetExtString: function(hdc: HDC): Pchar; stdcall;
  supported: PChar;
begin
  supported := nil;
  wglGetExtString := wglGetProcAddress('wglGetExtensionsStringARB');
  if Assigned(wglGetExtString) then
    supported := wglGetExtString(wglGetCurrentDC);
  if supported = nil then
    supported := glGetString(GL_EXTENSIONS);
  if supported = nil then
  begin
    Result := false;
    exit;
  end;
  if Pos(extension,supported) = 0 then
  begin
    Result := false;
    exit;
  end;
  Result := true;
end;

function InitMultisample(hInstance: HINST; hWnd: HWND; pfd: PIXELFORMATDESCRIPTOR): boolean;
var
  wglChoosePixelFormatARB: function(hdc: HDC; const piAttribIList: PGLint; const pfAttribFList: PGLfloat; nMaxFormats: GLuint; piFormats: PGLint; nNumFormats: PGLuint): BOOL; stdcall;
  h_dc: HDC;
  pixelFormat: integer;
  valid: boolean;
  numFormats: UINT;
  fAttributes: array of GLfloat;
  iAttributes: array of integer;
begin
  if not WGLisExtensionSupported('WGL_ARB_multisample') then
  begin
    arbMultisampleSupported := false;
    Result := false;
    exit;
  end;
  wglChoosePixelFormatARB := wglGetProcAddress('wglChoosePixelFormatARB');
  if not Assigned(wglChoosePixelFormatARB) then
  begin
    arbMultisampleSupported := false;
    Result := false;
    exit;
  end;
  h_dc := GetDC(hWnd);
  SetLength(fAttributes,2);
  fAttributes[0] := 0;
  fAttributes[1] := 0;
  SetLength(iAttributes,22);
  iAttributes[0] := WGL_DRAW_TO_WINDOW_ARB;
  iAttributes[1] := 1;
  iAttributes[2] := WGL_SUPPORT_OPENGL_ARB;
  iAttributes[3] := 1;
  iAttributes[4] := WGL_ACCELERATION_ARB;
  iAttributes[5] := WGL_FULL_ACCELERATION_ARB;
  iAttributes[6] := WGL_COLOR_BITS_ARB;
  iAttributes[7] := 24;
  iAttributes[8] := WGL_ALPHA_BITS_ARB;
  iAttributes[9] := 8;
  iAttributes[10] := WGL_DEPTH_BITS_ARB;
  iAttributes[11] := 16;
  iAttributes[12] := WGL_STENCIL_BITS_ARB;
  iAttributes[13] := 0;
  iAttributes[14] := WGL_DOUBLE_BUFFER_ARB;
  iAttributes[15] := 1;
  iAttributes[16] := WGL_SAMPLE_BUFFERS_ARB;
  iAttributes[17] := 1;
  iAttributes[18] := WGL_SAMPLES_ARB;
  iAttributes[19] := 4;
  iAttributes[20] := 0;
  iAttributes[21] := 0;
  valid := wglChoosePixelFormatARB(h_dc,@iattributes,@fattributes,1,@pixelFormat,@numFormats);
  if valid and (numFormats >= 1) then
  begin
    arbMultisampleSupported := true;
    arbMultisampleFormat := pixelFormat;
    Result := arbMultisampleSupported;
    SetLength(fAttributes,0);
    SetLength(iAttributes,0);
    exit;
  end;
  iAttributes[19] := 2;
  valid := wglChoosePixelFormatARB(h_dc,@iAttributes,@fAttributes,1,@pixelFormat,@numFormats);
  if valid and (numFormats >= 1) then
  begin
    arbMultisampleSupported := true;
    arbMultisampleFormat := pixelFormat;
    Result := arbMultisampleSupported;
    SetLength(fAttributes,0);
    SetLength(iAttributes,0);
    exit;
  end;
  Result :=  arbMultisampleSupported;
  SetLength(fAttributes,0);
  SetLength(iAttributes,0);
end;

end.

