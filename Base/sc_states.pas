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

unit sc_states;

interface

uses
  d_delphi;

var
  statenames: TDStringList;

procedure SC_ParseStatedefLump;

implementation

uses
  sc_engine,
  w_wad;

const
  STATEDEFLUMPNAME = 'STATEDEF';

procedure SC_ParseStatedefLump;
var
  i: integer;
  sc: TScriptEngine;
begin
  for i := 0 to W_NumLumps - 1 do
    if char8tostring(W_GetNameForNum(i)) = STATEDEFLUMPNAME then
    begin
      sc := TScriptEngine.Create(W_TextLumpNum(i));
      while sc.GetString do
        statenames.Add(strupper(sc._String));
      sc.Free;
      break;
    end;
end;

end.
