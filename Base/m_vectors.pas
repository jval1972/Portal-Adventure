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

unit m_vectors;

interface

uses
  d_delphi;

type
  vec_t = float;
  Pvec_t = ^vec_t;

  vec3_t = array[0..2] of vec_t;
  Pvec3_t = ^vec3_t;

  mat3_t = array[0..2, 0..2] of float;
  Pmat3_t = ^mat3_t;

  vec5_t = array[0..4] of vec_t;
  Pvec5_t = ^vec5_t;

const
  M_PI = 3.14159265358979323846;  // matches value in gcc v2 math.h

//==============================================================================
//
// VectorLength
//
//==============================================================================
function VectorLength(v: Pvec3_t): vec_t;

//==============================================================================
//
// VectorNormalize
//
//==============================================================================
function VectorNormalize(v: Pvec3_t): float;

implementation

//==============================================================================
//
// VectorLength
//
//==============================================================================
function VectorLength(v: Pvec3_t): vec_t; // VJ mayby add VectorSquareLength ?
begin
  result := v[0] * v[0] + v[1] * v[1] + v[2] * v[2];
  result := sqrt(result);    // FIXME
end;

//==============================================================================
//
// VectorNormalize
//
//==============================================================================
function VectorNormalize(v: Pvec3_t): float;
var
  ilength: float;
begin
  result := v[0] * v[0] + v[1] * v[1] + v[2] * v[2];
  result := sqrt(result);    // FIXME

  if result > 0.0 then
  begin
    ilength := 1 / result;
    v[0] := v[0] * ilength;
    v[1] := v[1] * ilength;
    v[2] := v[2] * ilength;
  end;
end;

end.

