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

unit i_io;

interface

uses
  d_delphi;

var
  debugfile: TFile;
  stderr: TFile;
  stdout: TFile;
  stdoutbuffer: TDStringList;
  quietIO: Boolean = false;

//==============================================================================
//
// I_InitializeIO
//
//==============================================================================
procedure I_InitializeIO;

//==============================================================================
//
// I_ShutDownIO
//
//==============================================================================
procedure I_ShutDownIO;

//==============================================================================
//
// I_IOErrorMessageBox
//
//==============================================================================
procedure I_IOErrorMessageBox(const s: string);

//==============================================================================
//
// I_IOprintf
//
//==============================================================================
procedure I_IOprintf(const s: string);

//==============================================================================
//
// I_IOSetWindowHandle
//
//==============================================================================
procedure I_IOSetWindowHandle(const handle: integer);

implementation

uses
  Windows,
  d_main,
  g_game,
  i_startup,
  gl_main,
  m_argv;

var
  msghandle: integer = 0;

//==============================================================================
//
// I_IOErrorMessageBox
//
//==============================================================================
procedure I_IOErrorMessageBox(const s: string);
begin
  MessageBox(msghandle, PChar(s), AppTitle, MB_OK or MB_ICONERROR or MB_APPLMODAL);
end;

var
  io_lastNL: boolean = true;

//==============================================================================
//
// I_IOprintf
//
//==============================================================================
procedure I_IOprintf(const s: string);
var
  len: integer;
  s1: string;
  i: integer;
  l: TDStringList;
begin
  SetLength(s1, Length(s));
  len := 0;
  for i := 1 to Length(s) do
    if not (s[i] in [#8, #10]) then
    begin
      inc(len);
      s1[len] := s[i];
    end;
  if len = 0 then
    exit;

  SetLength(s1, len);

  l := TDStringList.Create;
  l.Text := s1;

  if (length(s1) = 1) and (s1[1] = #13) then
  begin
    stdoutbuffer.Add('');
    io_lastNL := true;
  end
  else
  begin
    if io_lastNL or (stdoutbuffer.Count = 0) then
      stdoutbuffer.Text := stdoutbuffer.Text + s1
    else
    begin
      stdoutbuffer.Strings[stdoutbuffer.Count - 1] :=
        stdoutbuffer.Strings[stdoutbuffer.Count - 1] + l.Strings[0];
      for i := 1 to l.Count - 1 do
        stdoutbuffer.Add(l.Strings[i]);
    end;
    io_lastNL := s1[length(s1)] = #13;
  end;

  l.Free;

  if IsConsole then
    write(s);
end;

const
  basename = 'portal';

//==============================================================================
//
// I_InitializeIO
//
//==============================================================================
procedure I_InitializeIO;
var
  dfilename: string;
  efilename: string;
  sfilename: string;
begin
  if M_CheckParm('-debugfile') <> 0 then
    sprintf(dfilename, '.\logs\%s32_debug%d.txt', [basename, consoleplayer])
  else
    sprintf(dfilename, '.\LOGS\%s_debug.txt', [basename]);
  sprintf(efilename, '.\LOGS\%s_stderr.txt', [basename]);
  sprintf(sfilename, '.\LOGS\%s_stdout.txt', [basename]);

  if M_CheckParmCDROM then
  begin
    dfilename := CD_WORKDIR + dfilename;
    efilename := CD_WORKDIR + efilename;
    sfilename := CD_WORKDIR + sfilename;
    ForceDirectories(CD_WORKDIR + '\LOGS\');
  end
  else
    ForceDirectories('LOGS\');

  printf(' error output to: %s' + #13#10, [efilename]);
  stderr := TFile.Create(efilename, fCreate);
  printf(' debug output to: %s' + #13#10, [dfilename]);
  debugfile := TFile.Create(dfilename, fCreate);
  printf(' standard output to: %s' + #13#10, [sfilename]);
  stdout := TFile.Create(sfilename, fCreate);
end;

//==============================================================================
//
// I_ShutDownIO
//
//==============================================================================
procedure I_ShutDownIO;
begin
  stderr.Free;
  debugfile.Free;
  stdout.Free;
  SUC_Close;
end;

//==============================================================================
//
// I_IOSetWindowHandle
//
//==============================================================================
procedure I_IOSetWindowHandle(const handle: integer);
begin
  if handle > 0 then
    msghandle := handle
  else
    msghandle := hMainWnd
end;

initialization
  stdoutbuffer := TDStringList.Create;

finalization
  stdoutbuffer.Free;

end.

