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

unit p_sun;

interface

uses
  p_mobj_h;

//==============================================================================
//
// P_SetSun
//
//==============================================================================
procedure P_SetSun(const mo: Pmobj_t);

//==============================================================================
//
// P_CanSeeSun
//
//==============================================================================
function P_CanSeeSun(const actor: Pmobj_t): boolean;

var
  sun: Pmobj_t = nil;

implementation

uses
  p_sight;

//==============================================================================
//
// P_SetSun
//
//==============================================================================
procedure P_SetSun(const mo: Pmobj_t);
begin
  sun := mo;
end;

//==============================================================================
//
// P_CanSeeSun
//
//==============================================================================
function P_CanSeeSun(const actor: Pmobj_t): boolean;
begin
  if sun = nil then
  begin
    result := false;
    exit;
  end;

  result := P_CheckSight(actor, sun);
end;

end.
