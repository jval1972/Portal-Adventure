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

unit dl_utils;

interface

function Get2Ints(const s: string; var i1, i2: integer): boolean;

implementation

uses
  Windows, SysUtils;
  
function Get2Ints(const s: string; var i1, i2: integer): boolean;
var
  p: integer;
  s1, s2: string;
begin
  p := Pos('x', s);
  if p <= 0 then
  begin
    result := false;
    exit;
  end;

  s1 := Copy(s, 1, p - 1);
  s2 := Copy(s, p + 1, length(s) - p);

  i1 := StrToIntDef(s1, -1);
  i2 := StrToIntDef(s2, -1);

  result := (i1 > 0) and (i2 > 0);

end;

end.
 
