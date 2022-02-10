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

unit cm_main;

interface

uses
  d_delphi,
  t_main,
  p_mobj_h;

//==============================================================================
//
// CM_Init
//
//==============================================================================
procedure CM_Init;

//==============================================================================
//
// CM_InitLevel
//
//==============================================================================
procedure CM_InitLevel;

//==============================================================================
//
// CM_ShutDown
//
//==============================================================================
procedure CM_ShutDown;

//==============================================================================
//
// CM_DialogID
//
//==============================================================================
function CM_DialogID(const s: string): integer;

//==============================================================================
//
// CM_PrepareComicDialog
//
//==============================================================================
procedure CM_PrepareComicDialog(const id: integer);

//==============================================================================
//
// CM_ExecComicDialog
//
//==============================================================================
procedure CM_ExecComicDialog(const actor: Pmobj_t; const id: integer);

type
  bubblemask_t = record
    fontwidth: integer;
    fontheight: integer;
    xoffset: integer;
    yoffset: integer;
    xsize: integer;
    ysize: integer;
    mask: PBooleanArray;
  end;
  Pbubblemask_t = ^bubblemask_t;
  bubblemask_tArray = array[0..$FF] of bubblemask_t;
  Pbubblemask_tArray = ^bubblemask_tArray;

  bubbledef_t = record
    name: string[64];
    texture: PTexture;
    pivotx, pivoty: integer;
    nummasks: integer;
    masks: Pbubblemask_tArray;
  end;
  Pbubbledef_t = ^bubbledef_t;
  bubbledef_tArray = array[0..$FFF] of bubbledef_t;
  Pbubbledef_tArray = ^bubbledef_tArray;

var
  bubbles: Pbubbledef_tArray;
  numbubbles: integer;

type
  fontdef_t = record
    name: string[64];
    texture: PTexture;
    width, height: integer;
    charset: integer;
  end;
  Pfontdef_t = ^fontdef_t;
  fontdef_tArray = array[0..$FFF] of fontdef_t;
  Pfontdef_tArray = ^fontdef_tArray;

var
  fonts: Pfontdef_tArray;
  numfonts: integer;
  charsets: TDStringList;

type
  dialogdef_t = record
    name: string[64];
    bubble: integer;
    maskid: integer;
    font: integer;
    cmtext: integer;
    sound: integer;
    tics: integer;
    usability: integer;
    flags: integer;
    texture: longword;
  end;
  Pdialogdef_t = ^dialogdef_t;
  dialogdef_tArray = array[0..$FFF] of dialogdef_t;
  Pdialogdef_tArray = ^dialogdef_tArray;
  dialogdef_tPArray = array[0..$FFF] of Pdialogdef_t;
  Pdialogdef_tPArray = ^dialogdef_tPArray;

const
  CMDLG_FULLSCREEN = 1;

var
  comicdialogs: Pdialogdef_tArray;
  numdialogs: integer;
  cmtexts: TDStringList;

//==============================================================================
//
// CM_DecDlgRef
//
//==============================================================================
procedure CM_DecDlgRef(const d: Pdialogdef_t);

//==============================================================================
//
// CM_ExecComicDialogInFuture
//
//==============================================================================
procedure CM_ExecComicDialogInFuture(const actor: Pmobj_t; const id: integer; const tics: integer);

//==============================================================================
//
// CM_Ticker
//
//==============================================================================
procedure CM_Ticker;

var
  dlg_mobj_no: integer = -2;

type
  futuredialog_t = record
    id: integer;
    tics: integer;
    actor: Pmobj_t;
  end;
  Pfuturedialog_t = ^futuredialog_t;

const
  NUMFUTUREDIALOGS = 8;

var
  futuredialogs: array[0..NUMFUTUREDIALOGS - 1] of futuredialog_t;

implementation

uses
  dglOpenGL,
  gamedef,
  d_main,
  d_think,
  i_system,
  info,
  info_h,
  p_mobj,
  p_tick,
  gl_tex,
  sounds,
  s_sound,
  sc_engine,
  sc_tokens,
  w_pak,
  w_wad;

// Runtime comic dialog
{type
  comicdialog_t = record
    pivotx, pivoty: integer;
    x, y, z: Integer;  // pivot point in 3d space
    texture: PTexture;
    mo: Pmobj_t;
    tics: integer;
  end;
  Pcomicdialog_t = ^comicdialog_t;
  comicdialog_tArray = array[0..$FFF] of comicdialog_t;
  Pcomicdialog_tArray = ^comicdialog_tArray;  }

{var
  comicdialogs: Pcomicdialog_tArray;
  numcomicdialogs: Integer;}

const
  SCCM_BUBBLEDEF = 0;
  SCCM_TEXTURE = 1;
  SCCM_PIVOT = 2;
  SCCM_FONTDEF = 3;
  SCCM_WIDTH = 4;
  SCCM_HEIGHT = 5;
  SCCM_CHARSET = 6; // JVAL: unused :(
  SCCM_DIALOGDEF = 7;
  SCCM_BUBBLE = 8;
  SCCM_FONT = 9;
  SCCM_TEXT = 10;
  SCCM_SOUND = 11;
  SCCM_DURATION = 12;
  SCCM_MASK = 13;
  SCCM__FLAG_FULLSCREEN = 14;

const
  COMICDEFLUMPNAME = 'COMICDEF';

//==============================================================================
//
// CM_AddBubble
//
//==============================================================================
procedure CM_AddBubble(const b: bubbledef_t);
begin
  realloc(pointer(bubbles), numbubbles * SizeOf(bubbledef_t), (numbubbles + 1) * SizeOf(bubbledef_t));
  bubbles[numbubbles] := b;
  Inc(numbubbles);
end;

//==============================================================================
//
// CM_FindBubble
//
//==============================================================================
function CM_FindBubble(const s: string): integer;
var
  i: integer;
begin
  for i := 0 to numbubbles - 1 do
    if bubbles[i].name = s then
    begin
      result := i;
      Exit;
    end;
  result := -1;
end;

//==============================================================================
//
// CM_FindFont
//
//==============================================================================
function CM_FindFont(const s: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to numfonts - 1 do
    if fonts[i].name = s then
    begin
      result := i;
      Exit;
    end;
end;

//==============================================================================
//
// CM_AddFont
//
//==============================================================================
procedure CM_AddFont(const f: fontdef_t);
begin
  realloc(pointer(fonts), numfonts * SizeOf(fontdef_t), (numfonts + 1) * SizeOf(fontdef_t));
  fonts[numfonts] := f;
  Inc(numfonts);
end;

//==============================================================================
//
// CM_AddCharSet
//
//==============================================================================
function CM_AddCharSet(const s: string): integer;
begin
  result := charsets.IndexOf(s);
  if result < 0 then
    result := charsets.Add(s)
end;

//==============================================================================
//
// CM_AddDialog
//
//==============================================================================
procedure CM_AddDialog(const d: dialogdef_t);
var
  bubble: Pbubbledef_t;
  font: Pfontdef_t;
  i: integer;
begin
  realloc(pointer(comicdialogs), numdialogs * SizeOf(dialogdef_t), (numdialogs + 1) * SizeOf(dialogdef_t));
  comicdialogs[numdialogs] := d;

  bubble := @bubbles[d.bubble];
  font := @fonts[d.font];
  comicdialogs[numdialogs].maskid := 0;

  for i := 1 to bubble.nummasks - 1 do
    if (font.width = bubble.masks[i].fontwidth) and
       (font.height = bubble.masks[i].fontheight) then
    begin
      comicdialogs[numdialogs].maskid := i;
      break;
    end;

  if (bubble.masks[comicdialogs[numdialogs].maskid].fontwidth <> font.width) and
     (bubble.masks[comicdialogs[numdialogs].maskid].fontheight <> font.height) then
    I_Warning('CM_AddDialog(): Font size mismatch, (dialogdef=%s)!'#13#10, [d.name]);

  Inc(numdialogs);
end;

//==============================================================================
//
// SC_ParseComicDef
//
//==============================================================================
procedure SC_ParseComicDef(const in_text: string);
var
  sc: TScriptEngine;
  tokens: TTokenList;
  slist: TDStringList;
  token: string;
  token_idx: integer;
  bubble: bubbledef_t;
  font: fontdef_t;
  dialog: dialogdef_t;
  pmask: Pbubblemask_t;
  bubblepending: boolean;
  fontpending: Boolean;
  dialogpending: boolean;
  i, j, cnt: integer;
  s: string;
begin
  tokens := TTokenList.Create;
  tokens.Add('BUBBLEDEF');
  tokens.Add('TEXTURE');
  tokens.Add('PIVOT');
  tokens.Add('FONTDEF');
  tokens.Add('WIDTH');
  tokens.Add('HEIGHT');
  tokens.Add('CHARSET'); // JVAL: unused :(
  tokens.Add('DIALOGDEF');
  tokens.Add('BUBBLE');
  tokens.Add('FONT');
  tokens.Add('TEXT');
  tokens.Add('SOUND');
  tokens.Add('DURATION');
  tokens.Add('MASK');
  tokens.Add('CMDLG_FULLSCREEN, FULLSCREEN');

  if devparm then
  begin
    printf('--------'#13#10);
    printf('SC_ParseComicDef(): Parsing %s lump:'#13#10, [COMICDEFLUMPNAME]);

    slist := TDStringList.Create;
    try
      slist.Text := in_text;
      for i := 0 to slist.Count - 1 do
        printf('%s: %s'#13#10, [IntToStrZFill(6, i + 1), slist[i]]);
    finally
      slist.Free;
    end;

    printf('--------'#13#10);
  end;

  sc := TScriptEngine.Create(in_text);

  bubblepending := false;
  fontpending := false;
  dialogpending := false;

  while sc.GetString do
  begin
    token := strupper(sc._String);
    token_idx := tokens.IndexOfToken(token);
    case token_idx of
      SCCM_BUBBLEDEF: // BUBBLE DEFINITION
        begin
          bubblepending := true;
          bubble.name := '';
          bubble.texture := nil;
          bubble.pivotx := 0;
          bubble.pivoty := 0;
          bubble.nummasks := 0;
          bubble.masks := nil;
          if not sc.GetString then
          begin
            I_Warning('SC_ParseComicDef(): Token expected at line %d'#13#10, [sc._Line]);
            break;
          end;
          bubble.name := strupper(sc._String);

          while sc.GetString do
          begin
            token := strupper(sc._String);
            token_idx := tokens.IndexOfToken(token);
            case token_idx of
              SCCM_TEXTURE:  // Texture
                begin
                  sc.MustGetString;
                  bubble.texture := T_LoadHiResTexture(sc._String);
                  bubble.texture.ConvertTo32bit;
                end;
              SCCM_PIVOT:  // Pivor
                begin
                  sc.MustGetInteger;
                  bubble.pivotx := sc._Integer;
                  sc.MustGetInteger;
                  bubble.pivoty := sc._Integer;
                end;
              SCCM_MASK: // Text Mask
                begin
                  realloc(Pointer(bubble.masks),
                    bubble.nummasks * SizeOf(bubblemask_t),
                    (1 + bubble.nummasks) * SizeOf(bubblemask_t));
                  pmask := @bubble.masks[bubble.nummasks];
                  Inc(bubble.nummasks);

                  sc.MustGetString;
                  if strupper(sc._String) <> 'FONTWIDTH' then
                    I_Error('SC_ParseComicDef(): Token "FONTWIDTH" expected at line %d', [sc._Line]);
                  sc.MustGetInteger;
                  pmask.fontwidth := sc._Integer;

                  sc.MustGetString;
                  if strupper(sc._String) <> 'FONTHEIGHT' then
                    I_Error('SC_ParseComicDef(): Token "FONTHEIGHT" expected at line %d', [sc._Line]);
                  sc.MustGetInteger;
                  pmask.fontheight := sc._Integer;

                  sc.MustGetString;
                  if strupper(sc._String) <> 'XOFFSET' then
                    I_Error('SC_ParseComicDef(): Token "XOFFSET" expected at line %d', [sc._Line]);
                  sc.MustGetInteger;
                  pmask.xoffset := sc._Integer;

                  sc.MustGetString;
                  if strupper(sc._String) <> 'YOFFSET' then
                    I_Error('SC_ParseComicDef(): Token "YOFFSET" expected at line %d', [sc._Line]);
                  sc.MustGetInteger;
                  pmask.yoffset := sc._Integer;

                  sc.MustGetString;
                  if strupper(sc._String) <> 'XSIZE' then
                    I_Error('SC_ParseComicDef(): Token "XSIZE" expected at line %d', [sc._Line]);
                  sc.MustGetInteger;
                  pmask.xsize := sc._Integer;

                  sc.MustGetString;
                  if strupper(sc._String) <> 'YSIZE' then
                    I_Error('SC_ParseComicDef(): Token "YSIZE" expected at line %d', [sc._Line]);
                  sc.MustGetInteger;
                  pmask.ysize := sc._Integer;

                  pmask.mask := malloc(pmask.xsize * pmask.ysize * SizeOf(boolean));
                  cnt := 0;
                  for i := 0 to pmask.ysize - 1 do
                  begin
                    sc.MustGetString;
                    s := sc._String;
                    if Length(s) < pmask.xsize then
                    begin
                      I_Warning('SC_ParseComicDef(): Wrong mask row size = %d at line %d'#13#10, [Length(s), sc._Line]);
                      while Length(s) < pmask.xsize do
                        s := s + '0';
                    end
                    else if Length(s) > pmask.xsize then
                    begin
                      I_Warning('SC_ParseComicDef(): Wrong mask row size = %d at line %d'#13#10, [Length(s), sc._Line]);
                      SetLength(s, pmask.xsize);
                    end;

                    for j := 1 to pmask.xsize do
                    begin
                      if s[j] = '0' then
                        pmask.mask[cnt] := false
                      else
                        pmask.mask[cnt] := True;
                      Inc(cnt);
                    end;

                  end;
                end;
            else
              begin
                CM_AddBubble(bubble);
                bubblepending := false;
                sc.UnGet;
                break;
              end;
            end;
          end;
        end;

      SCCM_FONTDEF: // FONT DEFINITION
        begin
          fontpending := true;
          font.name := '';
          font.texture := nil;
          font.width := 0;
          font.height := 0;
          font.charset := -1;
          if not sc.GetString then
          begin
            I_Warning('SC_ParseComicDef(): Token expected at line %d'#13#10, [sc._Line]);
            break;
          end;
          font.name := strupper(sc._String);

          while sc.GetString do
          begin
            token := strupper(sc._String);
            token_idx := tokens.IndexOfToken(token);
            case token_idx of
              SCCM_TEXTURE:  // Texture
                begin
                  sc.MustGetString;
                  font.texture := T_LoadHiResTexture(sc._String);
                  font.texture.SetDefaultAlphaChannel;
                end;
              SCCM_WIDTH:  // Font Width
                begin
                  sc.MustGetInteger;
                  font.width := sc._Integer;
                end;
              SCCM_HEIGHT:  // Font Height
                begin
                  sc.MustGetInteger;
                  font.height := sc._Integer;
                end;
              SCCM_CHARSET:  // Character set
                begin
                  sc.MustGetString;
                  font.charset := CM_AddCharSet(strupper(sc._String));
                end;
            else
              begin
                CM_AddFont(font);
                fontpending := false;
                sc.UnGet;
                break;
              end;
            end;
          end;
        end;

      SCCM_DIALOGDEF: // DIALOG DEFINITION
        begin
          dialogpending := true;
          dialog.name := '';
          dialog.bubble := 0;
          dialog.font := 0;
          dialog.cmtext := 0;
          dialog.sound := 0;
          dialog.tics := 0;
          dialog.usability := 0;
          dialog.flags := 0;
          dialog.texture := 0;

          if not sc.GetString then
          begin
            I_Warning('SC_ParseComicDef(): Token expected at line %d'#13#10, [sc._Line]);
            break;
          end;
          dialog.name := strupper(sc._String);

          while sc.GetString do
          begin
            token := strupper(sc._String);
            token_idx := tokens.IndexOfToken(token);
            case token_idx of
              SCCM_BUBBLE:  // bubble
                begin
                  sc.MustGetString;
                  dialog.bubble := CM_FindBubble(strupper(sc._String));
                  if dialog.bubble < 0 then
                  begin
                    I_Warning('SC_ParseComicDef(): Unknown bubble identifier (%s) at line %d, using default'#13#10, [sc._String, sc._Line]);
                    dialog.bubble := 0;
                  end;
                end;
              SCCM_FONT:  // Font
                begin
                  sc.MustGetString;
                  dialog.font := CM_FindFont(strupper(sc._String));
                  if dialog.font < 0 then
                  begin
                    I_Warning('SC_ParseComicDef(): Unknown font identifier (%s) at line %d, using default'#13#10, [sc._String, sc._Line]);
                    dialog.font := 0;
                  end;
                end;
              SCCM_TEXT:  // Text
                begin
                  sc.MustGetString;
                  dialog.cmtext := cmtexts.Add(sc._String);
                end;
              SCCM_SOUND:  // Character set
                begin
                  sc.MustGetString;
                  dialog.sound := S_GetSoundNumForName(strupper(sc._String));
                end;
              SCCM_DURATION: // duration - convert to tics
                begin
                  sc.MustGetFloat;
                  dialog.tics := Round(sc._Float * TICRATE);
                end;
              SCCM__FLAG_FULLSCREEN:
                begin
                  dialog.flags := dialog.flags or CMDLG_FULLSCREEN;
                end;
            else
              begin
                CM_AddDialog(dialog);
                dialogpending := false;
                sc.UnGet;
                break;
              end;
            end;
          end;
        end;

      else
        begin
          I_Warning('SC_ParseModelDefinition(): Unknown token "%s" at line %d'#13#10, [token, sc._Line]);
        end;
    end;
  end;

  if bubblepending then
    CM_AddBubble(bubble);
  if fontpending then
    CM_AddFont(font);
  if dialogpending then
    CM_AddDialog(dialog);

  sc.Free;
  tokens.Free;
end;

// SC_ParseComicDefinitions
// JVAL: Parse all COMICDEF lumps
//
//==============================================================================
procedure SC_ParseComicDefinitions;
var
  i: integer;
begin
// Retrive modeldef lumps
  for i := 0 to W_NumLumps - 1 do
    if char8tostring(W_GetNameForNum(i)) = COMICDEFLUMPNAME then
      SC_ParseComicDef(W_TextLumpNum(i));

  PAK_StringIterator(COMICDEFLUMPNAME, SC_ParseComicDef);
  PAK_StringIterator(COMICDEFLUMPNAME + '.txt', SC_ParseComicDef);
end;

//==============================================================================
//
// CM_InitLevel
//
//==============================================================================
procedure CM_InitLevel;
begin
  ZeroMemory(@futuredialogs, SizeOf(futuredialogs));
end;

//==============================================================================
//
// CM_Init
//
//==============================================================================
procedure CM_Init;
begin
  CM_InitLevel;
  bubbles := nil;
  numbubbles := 0;
  fonts := nil;
  numfonts := 0;
  comicdialogs := nil;
  numdialogs := 0;

  if dlg_mobj_no = -2 then
    dlg_mobj_no := Info_GetMobjNumForName('COMICDIALOG');
  if dlg_mobj_no < 0 then
    I_Error('CM_ExecComicDialog(): Missing "COMICDIALOG" definition');

  cmtexts := TDStringList.Create;
  charsets := TDStringList.Create;
  charsets.Add('DEFAULT');

  SC_ParseComicDefinitions;
end;

//==============================================================================
//
// CM_ShutDown
//
//==============================================================================
procedure CM_ShutDown;
var
  i, j: integer;
begin
  for i := 0 to numbubbles - 1 do
  begin
    if bubbles[i].texture <> nil then
      Dispose(bubbles[i].texture, Destroy);
    for j := 0 to bubbles[i].nummasks - 1 do
    begin
      memfree(pointer(bubbles[i].masks[j].mask),
        bubbles[i].masks[j].xsize * bubbles[i].masks[j].ysize * SizeOf(Boolean));
    end;
    memfree(Pointer(bubbles[i].masks), bubbles[i].nummasks * SizeOf(bubblemask_t));
  end;
  memfree(Pointer(bubbles), numbubbles * SizeOf(bubbledef_t));

{  for i := 0 to numcomicdialogs - 1 do
    if comicdialogs[i].texture <> nil then
      Dispose(comicdialogs[i].texture, Destroy);
  memfree(Pointer(comicdialogs), numcomicdialogs * SizeOf(comicdialog_t));}

  for i := 0 to numfonts - 1 do
    if fonts[i].texture <> nil then
      Dispose(fonts[i].texture, Destroy);
  memfree(Pointer(fonts), numfonts * SizeOf(fontdef_t));

  memfree(Pointer(comicdialogs), numdialogs * SizeOf(dialogdef_t));

  cmtexts.Free;
  charsets.Free;
end;

//==============================================================================
//
// CM_DialogID
//
//==============================================================================
function CM_DialogID(const s: string): integer;
var
  i: integer;
  s1: string;
begin
  s1 := strupper(s);
  for i := 0 to numdialogs - 1 do
    if comicdialogs[i].name = s1 then
    begin
      result := i;
      exit;
    end;

  result := -1;
end;

//==============================================================================
//
// string2list
//
//==============================================================================
procedure string2list(const s: string; const l: TDStringList);
var
  i: integer;
  s1: string;
  last: char;
begin
  last := #0;
  for i := 1 to Length(s) do
  begin
    if s[i] = ' ' then
    begin
      if last <> ' ' then
        s1 := s1 + #13#10;
    end
    else
      s1 := s1 + s[i];
    last := s[i];
  end;
  l.Text := s1;
end;

{function CM_AddComicDialog(const c: comicdialog_t): integer;
var
  i: integer;
begin
  for i := 0 to numcomicdialogs - 1 do
    if comicdialogs[i].texture = nil then
    begin
      comicdialogs[i] := c;
      Result := i;
      Exit;
    end;
  realloc(pointer(comicdialogs), numcomicdialogs * SizeOf(comicdialog_t), (1 + numcomicdialogs) * SizeOf(comicdialog_t));
  comicdialogs[numcomicdialogs] := c;
  Result := numcomicdialogs;
  Inc(numcomicdialogs);
end;     }

const
  TEX_WIDTH = 512;
  TEX_HEIGHT = 512;

//==============================================================================
//
// CM_PrepareComicDialog
//
//==============================================================================
procedure CM_PrepareComicDialog(const id: integer);
var
  dlg: Pdialogdef_t;
  bubble: Pbubbledef_t;
  mask: Pbubblemask_t;
  font: Pfontdef_t;
  i, j: integer;
  maskpos: integer;
  mark: integer;
  masksize: integer;
  l: TDStringList;
  s: string;
  A: PCharArray;
  fit: boolean;
  overflow: Boolean;
  xx: integer;
  pos1: integer;
  t: PTexture;
  maxcharpos: integer;
  bubblex, bubbley, fontx, fonty: integer;
//  c: comicdialog_t;

begin
  if id < 0 then
    exit;

  if id >= numdialogs then
    exit;

  dlg := @comicdialogs[id];

  if dlg.usability > 0 then
  begin
    Inc(dlg.usability);
    Exit;
  end;

  bubble := @bubbles[dlg.bubble];
  font := @fonts[dlg.font];
  mask := @bubble.masks[dlg.maskid];

  l := TDStringList.Create;
  string2list(cmtexts.Strings[dlg.cmtext], l); // Split the bubble text into words

  t := bubble.texture.Clone;

  masksize := mask.xsize * mask.ysize;

  A := mallocz(masksize * SizeOf(char));

  maskpos := 0;
  overflow := false;
  maxcharpos := -1;
  // For each word in the comic bubble....
  for i := 0 to l.Count - 1 do
  begin
    if overflow then
      break;
    s := l.Strings[i];
    while true do
    begin
      // Find next available free pos
      pos1 := -1;
      for xx := maskpos to masksize - 1 do
        if mask.mask[xx] then
        begin
          pos1 := xx;
          break;
        end;
      maskpos := pos1;

      if (maskpos < 0) or (Length(s) + maskpos > masksize) then
      begin
        I_Warning('CM_PrepareComicDialog(): Dialog text does not fit to bubble, (dialogdef=%s)!'#13#10, [dlg.name]);
        overflow := True;
        Break;
      end;

      // Check if the current word fits into the pos
      mark := maskpos;
      fit := True;
      for j := 1 to Length(s) do
      begin
        if not mask.mask[mark] then
        begin
          fit := false;
          maskpos := mark;
          break;
        end;
        Inc(mark);
      end;

      if not fit then Continue;

      for j := 1 to Length(s) do
      begin
        A[maskpos] := s[j];
        Inc(maskpos);
      end;
      maxcharpos := maskpos - 1;
      Inc(maskpos); // Add a space at the end of the word
      Break;
    end;
  end;

  // Create the runtime dialog texture
  for i := 0 to maxcharpos do
    if (A[i] <> ' ') and (A[i] <> #0) then
    begin
      bubblex := mask.xoffset + (i mod mask.xsize) * mask.fontwidth;
      bubbley := mask.yoffset + (i div mask.xsize) * mask.fontheight;
      fontx := mask.fontwidth * (Ord(A[i]) mod 16);
      fonty := mask.fontheight * (Ord(A[i]) div 16);
      for j := fonty to fonty + mask.fontheight - 1 do
      begin
        t.RasterOPAdd32Aplha(bubblex, bubbley, mask.fontwidth, font.texture.GetPointerAt(fontx, j));
        Inc(bubbley);
      end;
    end;

  dlg.texture := gld_LoadExternalTexture(t, True, GL_CLAMP);
  Dispose(t, Destroy);
  memfree(Pointer(A), masksize * SizeOf(char));
  l.Free;

  Inc(dlg.usability);
end;

//==============================================================================
//
// CM_ExecComicDialog
//
//==============================================================================
procedure CM_ExecComicDialog(const actor: Pmobj_t; const id: integer);
var
  mo: Pmobj_t;
  dlg: Pdialogdef_t;
begin
  if id < 0 then
  begin
    I_Warning('CM_ExecComicDialog(): Invalid comic dialog definition!'#13#10);
    exit;
  end;
  dlg := @comicdialogs[id];
  CM_PrepareComicDialog(id);
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + actor.height, dlg_mobj_no);
  if dlg.sound > 0 then
  begin
    if (actor._type = Ord(MT_SPIDER)) or (actor._type = Ord(MT_CYBORG)) or (actor.info.flags_ex and MF_EX_BOSS <> 0) then
      S_StartSound(nil, dlg.sound)
    else
      S_StartSound(mo, dlg.sound);
  end;
  mo.tics := dlg.tics;
  mo.comicdata := dlg;
  mo.target := actor;
end;

//==============================================================================
//
// CM_ExecComicDialogInFuture
//
//==============================================================================
procedure CM_ExecComicDialogInFuture(const actor: Pmobj_t; const id: integer; const tics: integer);
var
  i: integer;
begin
  if id < 0 then
  begin
    I_Warning('CM_ExecComicDialog(): Invalid comic dialog definition!'#13#10);
    exit;
  end;

  i := 0;
  while i < NUMFUTUREDIALOGS do
  begin
    if futuredialogs[i].tics = 0 then
    begin
      futuredialogs[i].id := id;
      futuredialogs[i].tics := tics;
      futuredialogs[i].actor := actor;
      Exit;
    end;
    Inc(i);
  end;
end;

//==============================================================================
//
// CM_Ticker
//
//==============================================================================
procedure CM_Ticker;
var
  i: integer;
//  currentthinker: Pthinker_t;
//  mobj: Pmobj_t;
begin
  i := 0;
  while i < NUMFUTUREDIALOGS do
  begin
    if futuredialogs[i].tics > 0 then
    begin
      Dec(futuredialogs[i].tics);
      if futuredialogs[i].tics = 0 then
        CM_ExecComicDialog(futuredialogs[i].actor, futuredialogs[i].id);
    end;
    Inc(i);
  end;

 { currentthinker := thinkercap.next;
  while Pointer(currentthinker) <> Pointer(@thinkercap) do
  begin
    if @currentthinker._function.acp1 = @P_MobjThinker then
    begin
      mobj := Pmobj_t(currentthinker);
      if (mobj.comicdata <> nil) and (mobj.target <> nil) then
      begin
        mobj.x := mobj.target.x;
        mobj.y := mobj.target.y;
        mobj.z := mobj.target.z + mobj.target.height;
      end;
    end;
    currentthinker := currentthinker.next;
  end;     }

end;

//==============================================================================
//
// CM_DecDlgRef
//
//==============================================================================
procedure CM_DecDlgRef(const d: Pdialogdef_t);
begin
  if d = nil then
    exit;
  if d.usability = 0 then
  begin
    I_Warning('CM_DecDlgRef(): usability is already = 0'#13#10);
    exit;
  end;
  Dec(d.usability);
  if d.usability = 0 then
    glDeleteTextures(1, @d.texture);
end;

end.
