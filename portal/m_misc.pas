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

unit m_misc;

interface

//==============================================================================
// M_WriteFile
//
// MISC
//
//==============================================================================
function M_WriteFile(const name: string; source: pointer; length: integer): boolean;

//==============================================================================
//
// M_ReadFile
//
//==============================================================================
function M_ReadFile(const name: string; var buffer: Pointer): integer;

//==============================================================================
//
// M_ScreenShot
//
//==============================================================================
procedure M_ScreenShot(const filename: string = ''; const silent: boolean = false);

//==============================================================================
//
// M_DoScreenShot
//
//==============================================================================
function M_DoScreenShot(const filename: string): boolean;

//==============================================================================
//
// M_LoadDefaults
//
//==============================================================================
procedure M_LoadDefaults;

//==============================================================================
//
// M_SaveDefaults
//
//==============================================================================
procedure M_SaveDefaults;

var
  yesnoStrings: array[boolean] of string = ('NO', 'YES');
  truefalseStrings: array[boolean] of string = ('FALSE', 'TRUE');

implementation

uses
  d_delphi,
  gamedef,
  d_main,
  m_argv,
  m_defs,
  i_system,
  gl_main,
  z_zone,
  d_sshot,
  i_tmp;

//==============================================================================
//
// M_WriteFile
//
//==============================================================================
function M_WriteFile(const name: string; source: pointer; length: integer): boolean;
var
  handle: file;
  count: integer;
begin
  if not fopen(handle, name, fCreate) then
  begin
    result := false;
    exit;
  end;

  BlockWrite(handle, source^, length, count);
  close(handle);

  result := count > 0;
end;

//==============================================================================
//
// M_ReadFile
//
//==============================================================================
function M_ReadFile(const name: string; var buffer: Pointer): integer;
var
  handle: file;
  count: integer;
begin
  if not fopen(handle, name, fOpenReadOnly) then
    I_Error('M_ReadFile(): Could not read file %s', [name]);

  result := FileSize(handle);
  // JVAL
  // If Z_Malloc changed to malloc() a lot of changes must be made....
  buffer := Z_Malloc(result, PU_STATIC, nil);
  BlockRead(handle, buffer^, result, count);
  close(handle);

  if count < result then
    I_Error('M_ReadFile(): Could not read file %s', [name]);
end;

type
  TargaHeader = record
    id_length, colormap_type, image_type: byte;
    colormap_index, colormap_length: word;
    colormap_size: byte;
    x_origin, y_origin, width, height: word;
    pixel_size, attributes: byte;
  end;

const
  MSG_ERR_SCREENSHOT = 'Couldn''t create a screenshot';

//==============================================================================
//
// M_ScreenShot
//
//==============================================================================
procedure M_ScreenShot(const filename: string = ''; const silent: boolean = false);
var
  tganame,
  jpgname: string;
  i: integer;
  ret: boolean;
begin
  if filename = '' then
  begin
    tganame := I_NewTempFile('portal.tga');
//
// find a file name to save it to
//

  end
  else
  begin
    if Pos('.', filename) = 0 then
      tganame := filename + '.tga'
    else
      tganame := filename;
  end;

  ret := M_DoScreenShot(tganame);

  if not ret then
    exit;

  i := 0;
  ForceDirectories(M_SaveFileName('SCREENSHOTS\'));
  while i <= 99999 do
  begin

    jpgname := M_SaveFileName('SCREENSHOTS\IMG' + IntToStrZfill(5, i) + '.jpg');
    if not fexists(jpgname) then
      break;  // file doesn't exist
    inc(i);
  end;

  if i < 100000 then
    TGAtoJPG(tganame, jpgname);

  fdelete(tganame);
end;

//==============================================================================
//
// M_DoScreenShot
//
//==============================================================================
function M_DoScreenShot(const filename: string): boolean;
var
  buffer: PByteArray;
  bufsize: integer;
  src: PByteArray;
begin
  bufsize := SCREENWIDTH * SCREENHEIGHT * 4 + 18;
  buffer := malloc(bufsize);
  ZeroMemory(buffer, 18);
  buffer[2] := 2;    // uncompressed type
  buffer[12] := SCREENWIDTH and 255;
  buffer[13] := SCREENWIDTH div 256;
  buffer[14] := SCREENHEIGHT and 255;
  buffer[15] := SCREENHEIGHT div 256;
  buffer[16] := 32;  // pixel size
  buffer[17] := 0;  // Origin in upper left-hand corner.

  src := @buffer[18];

  I_ReadScreen32(src);

  result := M_WriteFile(filename, buffer, SCREENWIDTH * SCREENHEIGHT * 4 + 18);

  memfree(pointer(buffer), bufsize);
end;

const
  VERFMT = 'ver %d.%d';

var
  defaultfile: string;

//==============================================================================
//
// M_SaveDefaults
//
//==============================================================================
procedure M_SaveDefaults;
var
  i: integer;
  pd: Pdefault_t;
  s: TDStringList;
  verstr: string;
begin
  s := TDStringList.Create;
  try
    sprintf(verstr, '[' + AppTitle + ' ' + VERFMT + ']', [VERSION div 100, VERSION mod 100]);
    s.Add(verstr);
    pd := @defaults[0];
    for i := 0 to NUMDEFAULTS - 1 do
    begin
      if pd.saveable then
      begin
        if pd._type = tInteger then
          s.Add(pd.name + '=' + itoa(PInteger(pd.location)^))
        else if pd._type = tString then
          s.Add(pd.name + '=' + PString(pd.location)^)
        else if pd._type = tBoolean then
          s.Add(pd.name + '=' + itoa(intval(PBoolean(pd.location)^)))
        else if pd._type = tGroup then
        begin
          s.Add('');
          s.Add('[' + pd.name + ']');
        end;
      end;
      inc(pd);
    end;

    s.SaveToFile(defaultfile);

  finally
    s.Free;
  end;
end;

//==============================================================================
//
// M_LoadDefaults
//
//==============================================================================
procedure M_LoadDefaults;
var
  i: integer;
  j: integer;
  idx: integer;
  pd: Pdefault_t;
  s: TDStringList;
  n: string;
  verstr: string;
begin
  // set everything to base values
  for i := 0 to NUMDEFAULTS - 1 do
    if defaults[i]._type = tInteger then
      PInteger(defaults[i].location)^ := defaults[i].defaultivalue
    else if defaults[i]._type = tBoolean then
      PBoolean(defaults[i].location)^ := defaults[i].defaultbvalue
    else if defaults[i]._type = tString then
      PString(defaults[i].location)^ := defaults[i].defaultsvalue;

  if M_CheckParm('-defaultvalues') > 0 then
    exit;

  // check for a custom default file
  i := M_CheckParm('-config');
  if (i > 0) and (i < myargc - 1) then
  begin
    defaultfile := myargv[i + 1];
    printf(' default file: %s'#13#10, [defaultfile]);
  end
  else
    defaultfile := basedefault;

  s := TDStringList.Create;
  try
    // read the file in, overriding any set defaults
    if fexists(defaultfile) then
      s.LoadFromFile(defaultfile);

    if s.Count > 1 then
    begin
      sprintf(verstr, VERFMT, [VERSION div 100, VERSION mod 100]);
      if Pos(verstr, s[0]) > 0 then
      begin
        s.Delete(0);

        for i := 0 to s.Count - 1 do
        begin
          idx := -1;
          n := strlower(s.Names[i]);
          for j := 0 to NUMDEFAULTS - 1 do
            if defaults[j].name = n then
            begin
              idx := j;
              break;
            end;

          if idx > -1 then
          begin
            pd := @defaults[idx];
            if pd._type = tInteger then
              PInteger(pd.location)^ := atoi(s.Values[n])
            else if pd._type = tBoolean then
              PBoolean(pd.location)^ := atoi(s.Values[n]) <> 0
            else if pd._type = tString then
              PString(pd.location)^ := s.Values[n];
          end;
        end;
      end;
    end;

  finally
    s.Free;
  end;
end;

end.

