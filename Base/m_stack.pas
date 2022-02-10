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

unit m_stack;

interface

uses
  d_delphi;

type
  TIntegerStack = class(TDNumberList)
  public
    procedure Push(const x: integer);
    function Pop(var x: integer): boolean;
  end;

  TIntegerQueue = class(TDNumberList)
  public
    function Remove: boolean;
  end;

//==============================================================================
//
// M_PushValue
//
//==============================================================================
procedure M_PushValue(const x: integer);

//==============================================================================
//
// M_PopValue
//
//==============================================================================
function M_PopValue: integer;

implementation

uses
  i_system;

var
  globalstack: TIntegerStack;

//==============================================================================
//
// TIntegerStack.Push
//
//==============================================================================
procedure TIntegerStack.Push(const x: integer);
begin
  Add(x);
end;

//==============================================================================
//
// TIntegerStack.Pop
//
//==============================================================================
function TIntegerStack.Pop(var x: integer): boolean;
begin
  result := Count > 0;
  if result then
  begin
    x := Numbers[Count - 1];
    Delete(Count - 1);
  end;
end;

//==============================================================================
//
// TIntegerQueue.Remove
//
//==============================================================================
function TIntegerQueue.Remove: boolean;
begin
  result := Count > 0;
  Delete(0);
end;

//==============================================================================
//
// M_PushValue
//
//==============================================================================
procedure M_PushValue(const x: integer);
begin
  globalstack.Push(x);
end;

//==============================================================================
//
// M_PopValue
//
//==============================================================================
function M_PopValue: integer;
begin
  if not globalstack.Pop(result) then
    I_DevError('M_PopValue(): Global Stack is empty!'#13#10);
end;

initialization
  globalstack := TIntegerStack.Create;

finalization
  globalstack.Free;

end.
