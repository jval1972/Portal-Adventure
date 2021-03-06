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

unit i_startup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TStartUpConsoleForm = class(TForm)
    GamePanel: TPanel;
    GameLabel: TLabel;
    StartUpProgressBar: TProgressBar;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure SUC_Open;

procedure SUC_Close;

procedure SUC_Outproc(const s: string);

procedure SUC_Progress(const p: integer);

procedure SUC_SetGameMode(const s: string);

function SUC_GetHandle: integer;

procedure SUC_Enable;

procedure SUC_Disable;

procedure SUC_SecondaryProgressInit(const p: integer);

procedure SUC_SecondaryProgressDone;

procedure SUC_SecondaryProgress(const p: integer);

implementation

{$R *.dfm}

uses
  d_delphi,
  d_main,
  i_io;
  
var
  StartUpConsoleForm: TStartUpConsoleForm;
  startupformactive: boolean = false;
  suc_enabled: boolean = true;

procedure SUC_Open;
begin
  Screen.Cursor := crHourGlass;
  StartUpConsoleForm := TStartUpConsoleForm.Create(nil);
  StartUpConsoleForm.Show;
  startupformactive := true;
end;

procedure SUC_Close;
begin
  if startupformactive then
  begin
    startupformactive := false;
    StartUpConsoleForm.Free;
    Screen.Cursor := crDefault;
  end;
end;

var
  suc_wasdisabled: boolean = false;

procedure SUC_Outproc(const s: string);
var
  s1: string;
  i, j: integer;
begin
  SetLength(s1, Length(s));
  j := 0;
  for i := 1 to Length(s) do
    if not (s[i] in [#8, #10]) then
    begin
      inc(j);
      s1[j] := s[i];
    end;
  SetLength(s1, j);
  I_IOprintf(s1);

end;

procedure SUC_Progress(const p: integer);
begin
  StartUpConsoleForm.StartUpProgressBar.Position := p;
  StartUpConsoleForm.StartUpProgressBar.Repaint;
   StartUpConsoleForm.Repaint;
end;

procedure SUC_SetGameMode(const s: string);
begin
  StartUpConsoleForm.GameLabel.Caption := s;
  StartUpConsoleForm.GamePanel.Visible := true;
end;

function SUC_GetHandle: integer;
begin
  if startupformactive then
    result := StartUpConsoleForm.Handle
  else
    result := 0;
end;

procedure TStartUpConsoleForm.FormCreate(Sender: TObject);
begin
  Caption := 'The hunt for Dr. Freak';
end;

procedure SUC_Enable;
begin
  suc_enabled := true;
end;

procedure SUC_Disable;
begin
  suc_enabled := false;
end;

var
  suc_progress2parm: integer;

procedure SUC_SecondaryProgressInit(const p: integer);
begin
  if p = 0 then
    exit;

  suc_progress2parm := p;
//  StartUpConsoleForm.StartUpProgressBar2.Visible := true;
//  StartUpConsoleForm.StartUpProgressBar2.Position := 0;
//  StartUpConsoleForm.StartUpProgressBar2.Repaint;
end;

procedure SUC_SecondaryProgressDone;
begin
//  StartUpConsoleForm.StartUpProgressBar2.Visible := false;
  StartUpConsoleForm.Repaint;
  suc_progress2parm := 0;
end;

procedure SUC_SecondaryProgress(const p: integer);
//var
//  newpos: integer;
begin
{  if suc_progress2parm = 0 then
    exit;

  newpos := round(p * StartUpConsoleForm.StartUpProgressBar2.Max / suc_progress2parm);
  if newpos > StartUpConsoleForm.StartUpProgressBar2.Max then
    newpos := StartUpConsoleForm.StartUpProgressBar2.Max;
  if newpos <> StartUpConsoleForm.StartUpProgressBar2.Position then
  begin
    StartUpConsoleForm.StartUpProgressBar2.Position := newpos;
    StartUpConsoleForm.StartUpProgressBar2.Repaint;
  end;         }
end;

end.
