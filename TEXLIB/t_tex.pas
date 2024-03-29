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

unit t_tex;

interface

uses
  d_delphi,
  t_main;

type
  TTexTextureManager = object(TTextureManager)
    tex1: PTexture;
  public
    constructor Create;
    function LoadHeader(stream: TStream): boolean; virtual;
    function LoadImage(stream: TStream): boolean; virtual;
    destructor Destroy; virtual;
  end;

implementation

//==============================================================================
//
// TTexTextureManager.Create
//
//==============================================================================
constructor TTexTextureManager.Create;
begin
  inherited Create;
  SetFileExt('.TEX');
end;

//==============================================================================
//
// TTexTextureManager.LoadHeader
//
//==============================================================================
function TTexTextureManager.LoadHeader(stream: TStream): boolean;
var
  w, h: integer;
begin
  stream.seek(0, sFromBeginning);
  stream.Read(w, SizeOf(w));
  stream.Read(h, SizeOf(h));
  FBitmap^.SetBytesPerPixel(4);
  FBitmap^.SetWidth(w);
  FBitmap^.SetHeight(h);
  result := true;
end;

//==============================================================================
//
// TTexTextureManager.LoadImage
//
//==============================================================================
function TTexTextureManager.LoadImage(stream: TStream): boolean;
begin
  stream.Read(FBitmap.GetImage^, FBitmap.GetWidth * FBitmap.GetHeight * 4);
  result := true;
end;

//==============================================================================
//
// TTexTextureManager.Destroy
//
//==============================================================================
destructor TTexTextureManager.Destroy;
begin
  Inherited destroy;
end;

end.

