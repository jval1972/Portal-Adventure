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

unit dl_form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ExtCtrls;

type
  TConfigForm = class(TForm)
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    Button1: TButton;
    XPManifest1: TXPManifest;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    CheckBox3: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    function GetDefCmd(const demo: Boolean): string;
    procedure DoneCmd(const cmd: string);
  public
    { Public declarations }
    addcmds: string;
  end;

implementation

uses
  gl_tex,
  i_system,
  dl_utils;

{$R *.dfm}

//==============================================================================
//
// TConfigForm.FormCreate
//
//==============================================================================
procedure TConfigForm.FormCreate(Sender: TObject);
var
  dm: TDevMode;
  i: integer;
  s: string;
begin
  addcmds := '';
  i := 0;
  while EnumDisplaySettings(nil, i, dm) do
  begin
    if (dm.dmPelsWidth >= 800) and (dm.dmPelsHeight >= 600) and (dm.dmBitsPerPel = 32) then
    begin
      s := Format('%dx%d', [dm.dmPelsWidth, dm.dmPelsHeight]);
      if ComboBox1.Items.IndexOf(s) = -1 then
        ComboBox1.Items.Add(s);
    end;
    Inc(i);
  end;
  if ComboBox1.Items.Count = 0 then // JVAL -> uneeded :)
    ComboBox1.Items.Add('640x480');
  ComboBox1.ItemIndex := ComboBox1.Items.Count - 1;
end;

//==============================================================================
//
// TConfigForm.GetDefCmd
//
//==============================================================================
function TConfigForm.GetDefCmd(const demo: Boolean): string;
var
  s: string;
  w, h: integer;
begin
  result := '';
  if not CheckBox1.Checked then
    result := result + '-nofullscreen'#13#10;
  if CheckBox2.Checked then
    gl_maxtexwidth := 512
  else
    gl_maxtexwidth := 1024;

  if demo or CheckBox3.Checked then
    result := result + '-skill'#13#10 + IntToStr(RadioGroup1.ItemIndex + 1) + #13#10;
  if ComboBox1.Itemindex >= 0 then
  begin
    s := ComboBox1.Items.Strings[ComboBox1.Itemindex];
    Get2Ints(s, w, h);
    result := result + '-screenwidth'#13#10 + IntToStr(w) + #13#10'-screenheight'#13#10 + IntToStr(h) + #13#10;
  end;
end;

//==============================================================================
//
// TConfigForm.DoneCmd
//
//==============================================================================
procedure TConfigForm.DoneCmd(const cmd: string);
begin
  addcmds := cmd;
  Close;
end;

//==============================================================================
//
// TConfigForm.Button1Click
//
//==============================================================================
procedure TConfigForm.Button1Click(Sender: TObject);
begin
  DoneCmd(GetDefCmd(False));
end;

//==============================================================================
//
// TConfigForm.Button2Click
//
//==============================================================================
procedure TConfigForm.Button2Click(Sender: TObject);
begin
  //
end;

//==============================================================================
//
// TConfigForm.Button3Click
//
//==============================================================================
procedure TConfigForm.Button3Click(Sender: TObject);
begin
  //
end;

end.
