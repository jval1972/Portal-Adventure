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

unit i_tmp;

interface

procedure I_InitTempFiles;

procedure I_ShutDownTempFiles;

function I_NewTempFile(const name: string): string;

implementation

uses
  Windows,
  d_delphi;

var
  tempfiles: TDStringList;

procedure I_InitTempFiles;
begin
  tempfiles := TDStringList.Create;
end;

procedure I_ShutDownTempFiles;
var
  i: integer;
begin
{$I-}
  for i := 0 to tempfiles.Count - 1 do
    fdelete(tempfiles.Strings[i]);
{$I+}
  tempfiles.Free;
end;

function I_NewTempFile(const name: string): string;
var
  buf: array[0..1024] of char;
begin
  ZeroMemory(@buf, SizeOf(buf));
  GetTempPath(SizeOf(buf), buf);
  result :=  StringVal(buf) + '\' + fname(name);
  tempfiles.Add(result);
end;

end.

