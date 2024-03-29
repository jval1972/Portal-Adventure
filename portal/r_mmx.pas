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

unit r_mmx;

interface

uses
  d_delphi;

//==============================================================================
//
// R_BatchColorAdd32_MMX
//
//==============================================================================
function R_BatchColorAdd32_MMX(const dest0: PLongWord; const color: LongWord; const numpixels: integer): boolean;

implementation

type
  rec_2lw = record
    dwords: array[0..1] of LongWord;
  end;

//==============================================================================
//
// R_BatchColorAdd32_MMX
//
//==============================================================================
function R_BatchColorAdd32_MMX(const dest0: PLongWord; const color: LongWord; const numpixels: integer): boolean;
var
  data: rec_2lw;
  pdat: pointer;
  dest: PByte;
  count: integer;
begin
  if mmxMachine = 0 then
  begin
    result := false;
    exit;
  end;

  if color = 0 then
  begin
    result := true;
    exit;
  end;

  dest := PByte(dest0);

  count := numpixels * 4;
  if count and 7 <> 0 then
  begin
    result := false;
    exit;
  end;

  result := true;

  if count = 0 then
    exit;

  data.dwords[0] := color;
  data.dwords[1] := color;
  pdat := @data;

  if count >= 64 then
  begin
    asm
      push esi

      mov eax, dest
      mov esi, pdat

      mov ecx, count
      // 64 bytes per iteration
      shr ecx, 6
@@loop1:
      // Read in source data
      movq mm1, [esi]
      movq mm2, mm1
      movq mm3, mm1
      movq mm4, mm1
      movq mm5, mm1
      movq mm6, mm1
      movq mm7, mm1
      movq mm0, mm1

      paddusb mm1, [eax]
      paddusb mm2, [eax + 8]
      paddusb mm3, [eax + 16]
      paddusb mm4, [eax + 24]
      paddusb mm5, [eax + 32]
      paddusb mm6, [eax + 40]
      paddusb mm7, [eax + 48]
      paddusb mm0, [eax + 56]

      movntq [eax], mm1
      movntq [eax + 8], mm2
      movntq [eax + 16], mm3
      movntq [eax + 24], mm4
      movntq [eax + 32], mm5
      movntq [eax + 40], mm6
      movntq [eax + 48], mm7
      movntq [eax + 56], mm0

      add eax, 64
      dec ecx
      jnz @@loop1

      pop esi
    end;

    inc(dest, count and (not 63));
    count := count and 63;
  end;

  if count >= 8 then
  begin
    asm
      push esi

      mov eax, dest
      mov esi, pdat

      mov ecx, count
      // 8 bytes per iteration
      shr ecx, 3
      // Read in source data
      movq mm1, [esi]
@@loop2:
      movq mm2, mm1
      paddusb mm2, [eax]
      movntq [eax], mm2

      add eax, 8
      dec ecx
      jnz @@loop2

      pop esi
    end;
  end;

  asm
    emms
  end;

end;

end.
