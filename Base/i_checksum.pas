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

unit i_checksum;

interface

//==============================================================================
//
// I_FileCheckSum
//
//==============================================================================
function I_FileCheckSum(const fname: string): LongWord;

implementation

uses
  d_delphi;

//==============================================================================
//
// I_FileCheckSum
//
//==============================================================================
function I_FileCheckSum(const fname: string): Longword;
var
  f: TCachedFile;
  b: byte;
  sz: integer;
begin
  result := 0;
  f := TCachedFile.Create(fname, fOpenReadOnly);
  sz := f.Size;
  while f.Position < sz do
  begin
    f.Read(b, SizeOf(b));
    result := result + b;
  end;
  f.Free;
end;

end.
