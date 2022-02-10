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

unit gl_models;

// JVAL: Support for MD2 models

interface

uses
  d_delphi,
  m_fixed,
  dglOpenGL,
  p_mobj_h,
  gl_types;

var
  gl_drawmodels: boolean = true;
  gl_smoothmodelmovement: boolean = true;
  gl_precachemodeltextures: boolean = true;

type
  TModel = class
  protected
    fNumFrames: integer;
    fNumVertexes: integer;
    TheVectorsArray: PGLVertexArraysP;
    UV: PGLTexcoordArray;
    fTops: PFloatArray;
    precalc: PGLuintArray;
    precalc_s: PGLuintArray;
    findex: integer;
    fname: string;
    fshadow: Boolean;
    procedure fCalcFrameTop(const frm: integer);
  public
    constructor Create(const name: string; const offset, xx, yy, zz, scale: float;
      const flags: integer; const index: integer; const additionalframes: TDStringList); virtual;
    destructor Destroy; override;
    function MergeFrames(const model: TModel): boolean;
    procedure Draw(const frm1, frm2: integer; const offset: float; const shadow: boolean; const shadowplane: float);
    function GetTop(const frm: integer): float;
    procedure DrawSimple(const frm: integer; const shadow: boolean; const shadowplane: float);
    procedure DrawShadow(const frm: integer);
    procedure ReduceMemory;
  end;

//==============================================================================
//
// gld_InitModels
//
//==============================================================================
procedure gld_InitModels;

//==============================================================================
//
// gld_CleanModelTextures
//
//==============================================================================
procedure gld_CleanModelTextures;

//==============================================================================
//
// gld_ModelsDone
//
//==============================================================================
procedure gld_ModelsDone;

//==============================================================================
//
// gld_Init3DFloors
//
//==============================================================================
procedure gld_Init3DFloors(const lumpname: string);

//==============================================================================
//
// gld_Draw3DFloors
//
//==============================================================================
procedure gld_Draw3DFloors;

const
  MDSTRLEN = 64;

type
  modelmanageritem_t = record
    name: string[MDSTRLEN];
    offset: float;
    offsetx, offsety, offsetz: float;
    scale: float;
    framemerge: TDStringList;
    model: TModel;
    flags: integer;
  end;
  Pmodelmanageritem_t = ^modelmanageritem_t;
  modelmanageritem_tArray = array[0..$FFF] of modelmanageritem_t;
  Pmodelmanageritem_tArray = ^modelmanageritem_tArray;

  modelmanager_t = record
    size: integer;
    items: Pmodelmanageritem_tArray;
  end;

const
  MMFLAG_XZY = 1;
  MMFLAG_YXZ = 2;
  MMFLAG_YZX = 4;
  MMFLAG_ZXY = 8;
  MMFLAG_ZYX = 16;
  MMFLAG_NEGX = 32;
  MMFLAG_NEGY = 64;
  MMFLAG_NEGZ = 128;
  MMFLAG_SHADOW = 256;

type
  texturemanagetitem_t = record
    name: string[MDSTRLEN];
    mode: Integer;
    tex: GLUint;
  end;
  Ptexturemanagetitem_t = ^texturemanagetitem_t;
  texturemanagetitem_tArray = array[0..$FFF] of texturemanagetitem_t;
  Ptexturemanagetitem_tArray = ^texturemanagetitem_tArray;

  modeltexturemanager_t = record
    size: integer;
    items: Ptexturemanagetitem_tArray;
  end;

type
  modelstate_t = record
    modelidx: integer;  // index to modelmanager item
    texture: integer;   // index to modeltexturemanager item
    texture2: integer;
    startframe,
    endframe: integer;
    nextframe: integer;
    state: integer;
    transparency: float;
  end;
  Pmodelstate_t = ^modelstate_t;
  modelstate_tArray = array[0..$FFF] of modelstate_t;
  Pmodelstate_tArray = ^modelstate_tArray;

var
  modelmanager: modelmanager_t;
  modeltexturemanager: modeltexturemanager_t;
  modelstates: Pmodelstate_tArray;
  nummodelstates: integer;

const
  MODELINTERPOLATERANGE = 512 * FRACUNIT;
  MODELSHADOWRANGE = 1024 * FRACUNIT;

//==============================================================================
//
// gld_GetModelTexture
//
//==============================================================================
function gld_GetModelTexture(const texturename: string): GLuint;

implementation

uses
  gamedef,
  d_main,
  g_game,
  i_system,
  info,
  r_procs,
  gl_md2,
  gl_tex,
  gl_defs,
  sc_engine,
  sc_tokens,
  sc_states,
  p_journey,
  w_pak,
  w_wad;

//==============================================================================
//
// gld_AddModel
//
//==============================================================================
function gld_AddModel(const item: modelmanageritem_t): integer;
var
  i: integer;
  modelinf: Pmodelmanageritem_t;
begin
  i := 0;
  while i < modelmanager.size do
  begin
    if modelmanager.items[i].name = item.name then
    begin
      result := i;
      exit;
    end;
    inc(i);
  end;
  realloc(pointer(modelmanager.items), modelmanager.size * SizeOf(modelmanageritem_t), (1 + modelmanager.size) * SizeOf(modelmanageritem_t));
  result := modelmanager.size;
  modelinf := @modelmanager.items[result];
  modelinf.name := item.name;
  modelinf.offset := item.offset;
  modelinf.offsetx := item.offsetx;
  modelinf.offsety := item.offsety;
  modelinf.offsetz := item.offsetz;
  modelinf.scale := item.scale;
  modelinf.flags := item.flags;
  if item.framemerge.Count > 0 then
  begin
    modelinf.framemerge := TDStringList.Create;
    modelinf.framemerge.AddStrings(item.framemerge);
  end
  else
    modelinf.framemerge := nil;
  modelinf.model := TModel.Create(modelinf.name, modelinf.offset,
    modelinf.offsetx, modelinf.offsety, modelinf.offsetz,
    modelinf.scale, modelinf.flags, Result, modelinf.framemerge);

  inc(modelmanager.size);
end;

//==============================================================================
//
// gld_AddModelState
//
//==============================================================================
procedure gld_AddModelState(const item: modelstate_t);
begin
  if item.state < 0 then
    exit;

  realloc(pointer(modelstates), nummodelstates * SizeOf(modelstate_t), (1 + nummodelstates) * SizeOf(modelstate_t));
  modelstates[nummodelstates] := item;
  if states[item.state].models = nil then
    states[item.state].models := TDNumberList.Create;
  states[item.state].models.Add(nummodelstates);
  inc(nummodelstates);
end;

//==============================================================================
//
// gld_AddModelTexture
//
//==============================================================================
function gld_AddModelTexture(const texturename: string; const mode: Integer = GL_CLAMP): integer;
var
  i: integer;
begin
  i := 0;
  while i < modeltexturemanager.size do
  begin
    if (modeltexturemanager.items[i].name = texturename) and (modeltexturemanager.items[i].mode = mode) then
    begin
      result := i;
      exit;
    end;
    inc(i);
  end;
  realloc(pointer(modeltexturemanager.items), modeltexturemanager.size * SizeOf(texturemanagetitem_t), (1 + modeltexturemanager.size) * SizeOf(texturemanagetitem_t));
  result := modeltexturemanager.size;
  modeltexturemanager.items[result].name := texturename;
  modeltexturemanager.items[result].mode := mode;
  if gl_precachemodeltextures then
    modeltexturemanager.items[result].tex := gld_LoadExternalTexture(texturename, true, mode)
  else
    modeltexturemanager.items[result].tex := 0;
  inc(modeltexturemanager.size);
end;

//==============================================================================
//
// gld_GetModelTexture
//
//==============================================================================
function gld_GetModelTexture(const texturename: string): GLuint;
var
  id: integer;
begin
  id := gld_AddModelTexture(strupper(texturename), GL_REPEAT);
  result := modeltexturemanager.items[id].tex;
  if result = 0 then
  begin
    result := gld_LoadExternalTexture(texturename, true, GL_REPEAT);
    modeltexturemanager.items[id].tex := result;
  end;
end;

const
  MODELDEFLUMPNAME = 'MODELDEF';

//==============================================================================
//
// SC_ParseModelDefinition
// JVAL: Parse MODELDEF LUMP
//
//==============================================================================
procedure SC_ParseModelDefinition(const in_text: string);
var
  sc: TScriptEngine;
  tokens: TTokenList;
  slist: TDStringList;
  token: string;
  token_idx: integer;
  modelstate: modelstate_t;
  modelitem: modelmanageritem_t;
  modelpending: boolean;
  statepending: boolean;
  i: integer;
begin
  tokens := TTokenList.Create;
  modelitem.framemerge := TDStringList.Create;
  tokens.Add('MODELDEF, MODELDEFINITION');
  tokens.Add('STATE');
  tokens.Add('OFFSET');
  tokens.Add('SCALE');
  tokens.Add('TEXTURE');
  tokens.Add('FRAME, FRAME1, STARTFRAME');
  tokens.Add('FRAME2, ENDFRAME, NEXTFRAME'); // JVAL: unused :(
  tokens.Add('MODEL');
  tokens.Add('FRAMEMERGE');
  tokens.Add('TRANSPARENCY');
  tokens.Add('MMFLAG_XZY');
  tokens.Add('MMFLAG_YXZ');
  tokens.Add('MMFLAG_YZX');
  tokens.Add('MMFLAG_ZXY');
  tokens.Add('MMFLAG_ZYX');
  tokens.Add('MMFLAG_NEGX');
  tokens.Add('MMFLAG_NEGY');
  tokens.Add('MMFLAG_NEGZ');
  tokens.Add('OFFSETX, XOFFSET');
  tokens.Add('OFFSETY, YOFFSET');
  tokens.Add('OFFSETZ, ZOFFSET');
  tokens.Add('MMFLAG_SHADOW, SHADOW, RENDERSHADOW');
  tokens.Add('TEXTURE_REPEAT, TEXTUREREPEAT');
  tokens.Add('ALTERNATETEXTURE');

  if devparm then
  begin
    printf('--------'#13#10);
    printf('SC_ParseModelDefinition(): Parsing %s lump:'#13#10, [MODELDEFLUMPNAME]);

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

  modelpending := false;
  statepending := false;

  while sc.GetString do
  begin
    token := strupper(sc._String);
    token_idx := tokens.IndexOfToken(token);
    case token_idx of
      0: // MODEL DEFINITION
        begin
          modelpending := true;
          modelitem.name := '';
          modelitem.offset := 0.0;
          modelitem.offsetx := 0.0;
          modelitem.offsety := 0.0;
          modelitem.offsetz := 0.0;
          modelitem.scale := 1.0;
          modelitem.flags := 0;
          modelitem.framemerge.Clear;
          if not sc.GetString then
          begin
            I_Warning('SC_ParseModelDefinition(): Token expected at line %d'#13#10, [sc._Line]);
            break;
          end;
          modelitem.name := strupper(sc._String);

          while sc.GetString do
          begin
            token := strupper(sc._String);
            token_idx := tokens.IndexOfToken(token);
            case token_idx of
              2:  // Offset
                begin
                  sc.MustGetFloat;
                  modelitem.offset := sc._Float;
                end;
              3:  // Scale
                begin
                  sc.MustGetFloat;
                  modelitem.scale := sc._Float;
                end;
              8:  // FRAMEMERGE
                begin
                  sc.MustGetString;
                  modelitem.framemerge.Add(strupper(sc._String));
                end;
             10:  // MMFLAG_XZY
                begin
                  modelitem.flags := modelitem.flags or MMFLAG_XZY;
                end;
             11:  // MMFLAG_YXZ
                begin
                  modelitem.flags := modelitem.flags or MMFLAG_YXZ;
                end;
             12:  // MMFLAG_YZX
                begin
                  modelitem.flags := modelitem.flags or MMFLAG_YZX;
                end;
             13:  // MMFLAG_ZXY
                begin
                  modelitem.flags := modelitem.flags or MMFLAG_ZXY;
                end;
             14:  // MMFLAG_ZYX
                begin
                  modelitem.flags := modelitem.flags or MMFLAG_ZYX;
                end;
             15:  // MMFLAG_NEGX
                begin
                  modelitem.flags := modelitem.flags or MMFLAG_NEGX;
                end;
             16:  // MMFLAG_NEGY
                begin
                  modelitem.flags := modelitem.flags or MMFLAG_NEGY;
                end;
             17:  // MMFLAG_NEGZ
                begin
                  modelitem.flags := modelitem.flags or MMFLAG_NEGZ;
                end;
             18:  // Offsetx
                begin
                  sc.MustGetFloat;
                  modelitem.offsetx := sc._Float;
                end;
             19:  // Offsety
                begin
                  sc.MustGetFloat;
                  modelitem.offsety := sc._Float;
                end;
             20:  // Offsetz
                begin
                  sc.MustGetFloat;
                  modelitem.offsetz := sc._Float;
                end;
             21:  // MMFLAG_SHADOW
                begin
                  modelitem.flags := modelitem.flags or MMFLAG_SHADOW;
                end;
            else
              begin
                gld_AddModel(modelitem);
                modelpending := false;
                sc.UnGet;
                break;
              end;
            end;
          end;
        end;

      1: // STATE DEFINITION
        begin
          statepending := true;
          ZeroMemory(@modelstate, SizeOf(modelstate_t));
          modelitem.offset := 0.0;
          modelitem.scale := 1.0;
          modelitem.framemerge.Clear;

          modelstate.modelidx := -1;
          modelstate.texture := -1;
          modelstate.texture2 := -1;
          modelstate.startframe := -1;
          modelstate.endframe := -1;
          modelstate.nextframe := -1; // JVAL: runtime only!
          modelstate.transparency := 1.0;
          if not sc.GetString then
          begin
            I_Warning('SC_ParseModelDefinition(): Token expected at line %d'#13#10, [sc._Line]);
            break;
          end;
          modelstate.state := statenames.IndexOf(strupper(sc._String));
          if modelstate.state < 0 then
          begin
            I_Warning('SC_ParseModelDefinition(): Unknown state "%s" at line %d'#13#10, [sc._String, sc._Line]);
            modelstate.state := 0; // S_NULL
          end;

          while sc.GetString do
          begin
            token := strupper(sc._String);
            token_idx := tokens.IndexOfToken(token);
            case token_idx of
              7:  // Model
                begin
                  sc.MustGetString;
                  modelitem.name := strupper(sc._String);
                  modelitem.offset := 0.0;
                  modelitem.scale := 1.0;
                  modelstate.modelidx := gld_AddModel(modelitem);
                end;
              4:  // Texture
                begin
                  sc.MustGetString;
                  modelstate.texture := gld_AddModelTexture(strupper(sc._String));
                end;
             23:  // Alternate Texture
                begin
                  sc.MustGetString;
                  modelstate.texture2 := gld_AddModelTexture(strupper(sc._String));
                end;
             22:  // TextureRepeat
                begin
                  sc.MustGetString;
                  modelstate.texture := gld_AddModelTexture(strupper(sc._String), GL_REPEAT);
                end;
              5:  // startframe
                begin
                  sc.MustGetInteger;
                  modelstate.startframe := sc._Integer;
                  if modelstate.endframe < 0 then
                    modelstate.endframe := modelstate.startframe;
                end;
              6:  // endframe
                begin
                  sc.MustGetInteger;
                  modelstate.endframe := sc._Integer;
                end;
              9:  // transparency
                begin
                  sc.MustGetFloat;
                  modelstate.transparency := sc._Float;
                end;
            else
              begin
                gld_AddModelState(modelstate);
                statepending := false;
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

  if statepending then
    gld_AddModelState(modelstate);
  if modelpending then
    gld_AddModel(modelitem);

  sc.Free;
  tokens.Free;
  modelitem.framemerge.Free;
end;

//==============================================================================
// SC_ParseModelDefinitions
//
// SC_ParceDynamicLights
// JVAL: Parse all MODELDEF lumps
//
//==============================================================================
procedure SC_ParseModelDefinitions;
var
  i: integer;
begin
// Retrive modeldef lumps
  for i := 0 to W_NumLumps - 1 do
    if char8tostring(W_GetNameForNum(i)) = MODELDEFLUMPNAME then
      SC_ParseModelDefinition(W_TextLumpNum(i));

  PAK_StringIterator(MODELDEFLUMPNAME, SC_ParseModelDefinition);
  PAK_StringIterator(MODELDEFLUMPNAME + '.txt', SC_ParseModelDefinition);

  for i := 0 to modelmanager.size - 1 do
    if modelmanager.items[i].model <> nil then
      modelmanager.items[i].model.ReduceMemory;
end;

//==============================================================================
//
// gld_InitModels
//
//==============================================================================
procedure gld_InitModels;
begin
  modelmanager.size := 0;
  modelmanager.items := nil;
  modeltexturemanager.size := 0;
  modeltexturemanager.items := nil;
  nummodelstates := 0;
  modelstates := nil;
  printf('SC_ParseModelDefinitions: Parsing MODELDEF lumps.'#13#10);
  SC_ParseModelDefinitions;
end;

//==============================================================================
//
// gld_CleanModelTextures
//
//==============================================================================
procedure gld_CleanModelTextures;
var
  i: integer;
begin
  if gl_precachemodeltextures then
    exit;

  for i := 0 to modeltexturemanager.size - 1 do
  begin
    if modeltexturemanager.items[i].tex <> 0 then
    begin
      glDeleteTextures(1, @modeltexturemanager.items[i].tex);
      modeltexturemanager.items[i].tex := 0;
    end;
  end;
end;

//==============================================================================
//
// gld_ModelsDone
//
//==============================================================================
procedure gld_ModelsDone;
var
  i: integer;
begin
  for i := 0 to modelmanager.size - 1 do
  begin
    if modelmanager.items[i].model <> nil then
    begin
      modelmanager.items[i].model.Free;
      modelmanager.items[i].model := nil;
    end;
    modelmanager.items[i].framemerge.Free;
  end;

  memfree(pointer(modelmanager.items), modelmanager.size * SizeOf(modelmanageritem_t));
  modelmanager.size := 0;

  for i := 0 to modeltexturemanager.size - 1 do
  begin
    if modeltexturemanager.items[i].tex <> 0 then
    begin
      glDeleteTextures(1, @modeltexturemanager.items[i].tex);
      modeltexturemanager.items[i].tex := 0;
    end;
  end;
  memfree(pointer(modeltexturemanager.items), modeltexturemanager.size * SizeOf(texturemanagetitem_t));
  modeltexturemanager.size := 0;

  if nummodelstates > 0 then
  begin
    memfree(pointer(modelstates), nummodelstates * SizeOf(modelstate_t));
    nummodelstates := 0;
  end;
end;

const
  MAX3DVERTS = 32;

type
  floor3d_t = record
    vertexes: array[0..MAX3DVERTS - 1] of GLVertex;
    tri: boolean;
    texid: integer;
    numtris: Integer;
    texrepeat: integer;
  end;
  Pfloor3d_t = ^floor3d_t;

  floor3d_tArray = array[0..$FFF] of floor3d_t;
  Pfloor3d_tArray = ^floor3d_tArray;

var
  floors3d: floor3d_tArray;
  numfloors3d: integer;

// Static due to limited time :(
const
  MAXTERRAINVERTS = 961 * 4;
  MAXTERRAINS = 4;

type
  terrain3d_t = record
    vertexes: array[0..MAXTERRAINVERTS - 1] of GLVertex;
    uv: array[0..MAXTERRAINVERTS - 1] of GLTexcoord;
    numverts: Integer;
    texid: integer;
  end;
  Pterrain3d_t = ^terrain3d_t;

var
  terrains3d: array[0..MAXTERRAINS - 1] of terrain3d_t;
  numterrains3d: integer;

const
  MAXLEVELPROCS = 16;

var
  procs3d: array[0..MAXLEVELPROCS - 1] of Pprocedure;
  numprocs3d: integer;

//==============================================================================
//
// gld_Init3DFloors
//
//==============================================================================
procedure gld_Init3DFloors(const lumpname: string);
var
  sc: TScriptEngine;
  tokens: TTokenList;
  slist: TDStringList;
  token: string;
  token_idx: integer;
  i: integer;
  in_text: string;
  floorp: Pfloor3d_t;
  num: Integer;
  terrainp: Pterrain3d_t;
begin
  numfloors3d := 0;
  numterrains3d := 0;
  numprocs3d := 0;

  if W_CheckNumForName(lumpname) < 0 then
  begin
    printf(' Level specific 3D mesh info not found'#13#10);
    exit;
  end;

  printf(' Level specific 3D mesh info found!'#13#10);

  tokens := TTokenList.Create;
  tokens.Add('RECT');
  tokens.Add('TRI');
  tokens.Add('TRIFAN');
  tokens.Add('TERRAIN');
  tokens.Add('PROC');

  in_text := W_TextLumpName(lumpname);

  if devparm then
  begin
    printf('--------'#13#10);
    printf('gld_Init3DFloors(): Parsing %s lump:'#13#10, [lumpname]);

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

  while sc.GetString do
  begin
    token := strupper(sc._String);
    token_idx := tokens.IndexOfToken(token);
    case token_idx of
      0: // RECT
        begin
          floorp := @floors3d[numfloors3d];

          floorp.tri := false;

          sc.MustGetString;
          floorp.texid := gld_AddModelTexture(strupper(sc._String), GL_REPEAT);

          sc.MustGetInteger;
          floorp.texrepeat := sc._Integer;
          for i := 0 to 3 do
          begin
            sc.MustGetInteger;
            floorp.vertexes[i].x := -sc._Integer / MAP_COEFF;
            sc.MustGetInteger;
            floorp.vertexes[i].z := sc._Integer / MAP_COEFF;
            sc.MustGetInteger;
            floorp.vertexes[i].y := sc._Integer / MAP_COEFF;
          end;
          inc(numfloors3d);
        end;

      1: // TRI
        begin
          floorp := @floors3d[numfloors3d];

          floorp.tri := true;
          floorp.numtris := 3;

          sc.MustGetString;
          floorp.texid := gld_AddModelTexture(strupper(sc._String), GL_REPEAT);

          sc.MustGetInteger;
          floorp.texrepeat := sc._Integer;
          for i := 0 to 2 do
          begin
            sc.MustGetInteger;
            floorp.vertexes[i].x := -sc._Integer / MAP_COEFF;
            sc.MustGetInteger;
            floorp.vertexes[i].z := sc._Integer / MAP_COEFF;
            sc.MustGetInteger;
            floorp.vertexes[i].y := sc._Integer / MAP_COEFF;
          end;
          inc(numfloors3d);
        end;

      2: // TRISTRIP
        begin
          floorp := @floors3d[numfloors3d];

          floorp.tri := true;

          sc.MustGetInteger;
          num := sc._Integer;
          if num > MAX3DVERTS then
          begin
            I_Warning('gld_Init3DFloors(): trifun has %d points > MAX3DVERTS=%d'#13#10, [num , MAX3DVERTS]);
            num := MAX3DVERTS - num;
          end
          else
          begin
            floorp.numtris := num;
            num := 0;
          end;

          sc.MustGetString;
          floorp.texid := gld_AddModelTexture(strupper(sc._String), GL_REPEAT);

          sc.MustGetInteger;
          floorp.texrepeat := sc._Integer;
          for i := 0 to floorp.numtris - 1 do
          begin
            sc.MustGetInteger;
            floorp.vertexes[i].x := -sc._Integer / MAP_COEFF;
            sc.MustGetInteger;
            floorp.vertexes[i].z := sc._Integer / MAP_COEFF;
            sc.MustGetInteger;
            floorp.vertexes[i].y := sc._Integer / MAP_COEFF;
          end;
          for i := 0 to num - 1 do
          begin
            sc.MustGetInteger;
            sc.MustGetInteger;
            sc.MustGetInteger;
          end;
          inc(numfloors3d);
        end;

      3: // TERRAIN
        begin
          terrainp := @terrains3d[numterrains3d];
          Inc(numterrains3d);
          if numterrains3d > MAXTERRAINS then
            I_Error('gld_Init3DFloors(): numterrains3d > MAXTERRAINS');

          sc.MustGetString;
          terrainp.texid := gld_AddModelTexture(strupper(sc._String), GL_REPEAT);

          sc.MustGetInteger;
          terrainp.numverts := sc._Integer;

          for i := 0 to terrainp.numverts - 1 do
          begin
            sc.MustGetInteger;
            terrainp.vertexes[i].x := -sc._Integer / MAP_COEFF;
            sc.MustGetInteger;
            terrainp.vertexes[i].z := sc._Integer / MAP_COEFF;
            sc.MustGetInteger;
            terrainp.vertexes[i].y := sc._Integer / MAP_COEFF;
            sc.MustGetFloat;
            terrainp.uv[i].u := sc._Float;
            sc.MustGetFloat;
            terrainp.uv[i].v := sc._Float;
          end;

        end;
      4: // Custom proc
        begin
          sc.MustGetString;
          procs3d[numprocs3d] := R_FindProc(sc._string);
          if Assigned(procs3d[numprocs3d]) then
          begin
            Inc(numprocs3d);
            if numprocs3d > MAXLEVELPROCS then
              I_Error('gld_Init3DFloors(): numprocs3d > MAXLEVELPROCS');
          end
          else
            I_Warning('gld_Init3DFloors(): Can not find procedure %s'#13#10, [sc._string]);
        end;

      else
        begin
          I_Warning('gld_Init3DFloors(): Unknown token "%s" at line %d'#13#10, [token, sc._Line]);
        end;
    end;
  end;

  sc.Free;
  tokens.Free;
end;

//==============================================================================
//
// gld_Draw3DFloors
//
//==============================================================================
procedure gld_Draw3DFloors;
var
  i, j: integer;
  nverts: integer;
  floorp: Pfloor3d_t;
  terrainp: Pterrain3d_t;
  texitem: Ptexturemanagetitem_t;
  lasttex: GLuint;
begin
  lasttex := 0;

  if numfloors3d > 0 then
  begin

    glActiveTextureARB(GL_TEXTURE0_ARB);

    floorp := @floors3d[0];
    for i := 0 to numfloors3d - 1 do
    begin
      texitem := @modeltexturemanager.items[floorp.texid];

      if texitem.tex = 0 then
        texitem.tex := gld_LoadExternalTexture(texitem.name, true, GL_REPEAT);

      if texitem.tex <> lasttex then
      begin
        glBindTexture(GL_TEXTURE_2D, texitem.tex);
        lasttex := texitem.tex;
      end;

      if floorp.tri then
      begin
        nverts := floorp.numtris;
        glBegin(GL_TRIANGLE_FAN);
      end
      else
      begin
        nverts := 4;
        glBegin(GL_QUADS);
      end;

        for j := 0 to nverts - 1 do
        begin
          glTexCoord2f(floorp.vertexes[j].x / floorp.texrepeat, floorp.vertexes[j].z / floorp.texrepeat);
          glVertex3fv(@floorp.vertexes[j]);
        end;

      glEnd;

      inc(floorp);
    end;
  end;

  if numterrains3d > 0 then
  begin
    glActiveTextureARB(GL_TEXTURE0_ARB);

    terrainp := @terrains3d[0];

    for i := 0 to numterrains3d - 1 do
    begin
      texitem := @modeltexturemanager.items[terrainp.texid];

      if texitem.tex = 0 then
        texitem.tex := gld_LoadExternalTexture(texitem.name, true, GL_REPEAT);

      if texitem.tex <> lasttex then
      begin
        glBindTexture(GL_TEXTURE_2D, texitem.tex);
        lasttex := texitem.tex;
      end;

      glBegin(GL_QUADS);

        for j := 0 to terrainp.numverts - 1 do
        begin
          glTexCoord2fv(@terrainp.uv[j]);
          glVertex3fv(@terrainp.vertexes[j]);
        end;

      glEnd;

      inc(terrainp);

    end;

  end;

  glActiveTextureARB(GL_TEXTURE0_ARB);
  for i := 0 to numprocs3d - 1 do
    procs3d[i];

end;

//------------------------------------------------------------------------------
//--------------------------- MD2 Model Class ----------------------------------
//------------------------------------------------------------------------------

constructor TModel.Create(const name: string; const offset, xx, yy, zz, scale: float;
      const flags: integer; const index: integer; const additionalframes: TDStringList);
var
  strm: TPakStream;
  base_st: PMD2DstVert_TArray;
  tri: TMD2Triangle_T;
  out_t: PMD2AliasFrame_T;
  i, j, k, idx1: Integer;
  vert{, vertn}: PGLVertex;
  frameName: string;
  m_index_list: PMD2_Index_List_Array;
  m_frame_list: PMD2_Frame_List_Array;
  fm_iTriangles: integer;
  foffset, fscale: single;
  modelheader: TDmd2_T;
  m: TModel;
begin
  fname := name;
  findex := index;
  fshadow := flags and MMFLAG_SHADOW <> 0;
  printf('  Found external model %s'#13#10, [fname]);
  UV := nil;
  TheVectorsArray := nil;
  fNumFrames := 0;
  fNumVertexes := 0;
  foffset := offset / MAP_COEFF;
  fscale := scale / MAP_COEFF;
  strm := TPakStream.Create(fname, pm_prefered, gamedirectories);
  if strm.IOResult <> 0 then
    I_Error('TModel.Create(): Can not find model %s!', [fname]);

  strm.Read(modelheader, SizeOf(modelheader));

  if modelheader.ident <> MD2_MAGIC then
    I_Error('TModel.Create(): Invalid MD2 model magic (%d)!', [modelheader.ident]);

  fNumFrames := modelheader.num_frames;
  fm_iTriangles := modelheader.num_tris;
  fNumVertexes := fm_iTriangles * 3;

  m_index_list := malloc(SizeOf(TMD2_Index_List) * modelheader.num_tris);
  m_frame_list := malloc(SizeOf(TMD2_Frame_List) * modelheader.num_frames);

  for i := 0 to modelheader.num_frames - 1 do
  begin
    m_frame_list[i].vertex := malloc(SizeOf(TMD2_Vertex_List) * modelheader.num_xyz);
  end;

  strm.Seek(modelheader.ofs_st, sFromBeginning);
  if modelheader.num_st > 0 then
  begin
    base_st := malloc(modelheader.num_st * SizeOf(base_st[0]));
    strm.Read(base_st^, modelheader.num_st * SizeOf(base_st[0]));

    for i := 0 to modelheader.num_tris - 1 do
    begin
      strm.Read(Tri, SizeOf(TMD2Triangle_T));
      with m_index_list[i] do
      begin
        a := tri.index_xyz[2];
        b := tri.index_xyz[1];
        c := tri.index_xyz[0];
        a_s := base_st[tri.index_st[2]].s / modelheader.skinWidth;
        a_t := base_st[tri.index_st[2]].t / modelheader.skinHeight;
        b_s := base_st[tri.index_st[1]].s / modelheader.skinWidth;
        b_t := base_st[tri.index_st[1]].t / modelheader.skinHeight;
        c_s := base_st[tri.index_st[0]].s / modelheader.skinWidth;
        c_t := base_st[tri.index_st[0]].t / modelheader.skinHeight;
      end;
    end;
    memfree(pointer(base_st), modelheader.num_st * SizeOf(base_st[0]));
  end;

  out_t := malloc(modelheader.framesize);
  for i := 0 to modelheader.num_frames - 1 do
  begin
    strm.Read(out_t^, modelheader.framesize);

    if flags and MMFLAG_ZYX <> 0 then
    begin
      for j := 0 to modelheader.num_xyz - 1 do
      begin
        with m_frame_list[i].vertex[j] do
        begin
          z := (out_t^.verts[j].v[0] * out_t^.scale[0] + out_t^.translate[0]) * fscale;
          y := (out_t^.verts[j].v[1] * out_t^.scale[1] + out_t^.translate[1]) * fscale;
          x := (out_t^.verts[j].v[2] * out_t^.scale[2] + out_t^.translate[2]) * fscale + foffset;
        end;
      end
    end
    else if flags and MMFLAG_ZXY <> 0 then
    begin
      for j := 0 to modelheader.num_xyz - 1 do
      begin
        with m_frame_list[i].vertex[j] do
        begin
          z := (out_t^.verts[j].v[0] * out_t^.scale[0] + out_t^.translate[0]) * fscale;
          x := (out_t^.verts[j].v[1] * out_t^.scale[1] + out_t^.translate[1]) * fscale;
          y := (out_t^.verts[j].v[2] * out_t^.scale[2] + out_t^.translate[2]) * fscale + foffset;
        end;
      end
    end
    else if flags and MMFLAG_YZX <> 0 then
    begin
      for j := 0 to modelheader.num_xyz - 1 do
      begin
        with m_frame_list[i].vertex[j] do
        begin
          y := (out_t^.verts[j].v[0] * out_t^.scale[0] + out_t^.translate[0]) * fscale;
          z := (out_t^.verts[j].v[1] * out_t^.scale[1] + out_t^.translate[1]) * fscale;
          x := (out_t^.verts[j].v[2] * out_t^.scale[2] + out_t^.translate[2]) * fscale + foffset;
        end;
      end
    end
    else if flags and MMFLAG_YXZ <> 0 then
    begin
      for j := 0 to modelheader.num_xyz - 1 do
      begin
        with m_frame_list[i].vertex[j] do
        begin
          y := (out_t^.verts[j].v[0] * out_t^.scale[0] + out_t^.translate[0]) * fscale;
          x := (out_t^.verts[j].v[1] * out_t^.scale[1] + out_t^.translate[1]) * fscale;
          z := (out_t^.verts[j].v[2] * out_t^.scale[2] + out_t^.translate[2]) * fscale + foffset;
        end;
      end
    end
    else if flags and MMFLAG_XZY <> 0 then
    begin
      for j := 0 to modelheader.num_xyz - 1 do
      begin
        with m_frame_list[i].vertex[j] do
        begin
          x := (out_t^.verts[j].v[0] * out_t^.scale[0] + out_t^.translate[0]) * fscale;
          z := (out_t^.verts[j].v[1] * out_t^.scale[1] + out_t^.translate[1]) * fscale;
          y := (out_t^.verts[j].v[2] * out_t^.scale[2] + out_t^.translate[2]) * fscale + foffset;
        end;
      end
    end
    else
    begin
      for j := 0 to modelheader.num_xyz - 1 do
      begin
        with m_frame_list[i].vertex[j] do
        begin
          x := (out_t^.verts[j].v[0] * out_t^.scale[0] + out_t^.translate[0]) * fscale;
          y := (out_t^.verts[j].v[1] * out_t^.scale[1] + out_t^.translate[1]) * fscale;
          z := (out_t^.verts[j].v[2] * out_t^.scale[2] + out_t^.translate[2]) * fscale + foffset;
        end;
      end;
    end;

    if flags and MMFLAG_NEGX <> 0 then
    begin
      for j := 0 to modelheader.num_xyz - 1 do
      begin
        with m_frame_list[i].vertex[j] do
          x := -x;
      end
    end;
    if flags and MMFLAG_NEGY <> 0 then
    begin
      for j := 0 to modelheader.num_xyz - 1 do
      begin
        with m_frame_list[i].vertex[j] do
          y := -y;
      end
    end;
    if flags and MMFLAG_NEGZ <> 0 then
    begin
      for j := 0 to modelheader.num_xyz - 1 do
      begin
        with m_frame_list[i].vertex[j] do
          z := -z;
      end
    end;

    for j := 0 to modelheader.num_xyz - 1 do
    begin
      with m_frame_list[i].vertex[j] do
      begin
        x := x + xx / MAP_COEFF;
        y := y + yy / MAP_COEFF;
        z := z + zz / MAP_COEFF;
      end;
    end

  end;

  memfree(pointer(out_t), modelheader.framesize);

  UV := malloc(fNumVertexes * SizeOf(GLTexcoord));
  TheVectorsArray := malloc(fNumFrames * SizeOf(PGLVertexArray));

  if modelheader.num_st > 0 then
  begin
    k := 0;
    for j := 0 to fm_iTriangles - 1 do
    begin
      UV[k].u := m_index_list[j].a_s;
      UV[k].v := m_index_list[j].a_t;
      inc(k);

      UV[k].u := m_index_list[j].b_s;
      UV[k].v := m_index_list[j].b_t;
      inc(k);

      UV[k].u := m_index_list[j].c_s;
      UV[k].v := m_index_list[j].c_t;
      inc(k);
    end;
  end;

  for i := 0 to fNumFrames - 1 do
  begin
    TheVectorsArray[i] := malloc(fNumVertexes * SizeOf(TGLVectorf3));
    vert := @TheVectorsArray[i][0];
    for j := 0 to fm_iTriangles - 1 do
    begin
      idx1 := m_index_list[j].a;
      vert.x := m_frame_list[i].vertex[idx1].y;
      vert.y := m_frame_list[i].vertex[idx1].z;
      vert.z := m_frame_list[i].vertex[idx1].x;

      inc(vert);

      idx1 := m_index_list[j].b;
      vert.x := m_frame_list[i].vertex[idx1].y;
      vert.y := m_frame_list[i].vertex[idx1].z;
      vert.z := m_frame_list[i].vertex[idx1].x;

      inc(vert);

      idx1 := m_index_list[j].c;
      vert.x := m_frame_list[i].vertex[idx1].y;
      vert.y := m_frame_list[i].vertex[idx1].z;
      vert.z := m_frame_list[i].vertex[idx1].x;

      inc(vert);
    end;
  end;

  for i := 0 to fNumFrames - 1 do
  begin
    memfree(pointer(m_frame_list[i].vertex), SizeOf(TMD2_Vertex_List) * modelheader.num_xyz);
  end;
  memfree(pointer(m_frame_list), SizeOf(TMD2_Frame_List) * modelheader.num_frames);
  memfree(pointer(m_index_list), SizeOf(TMD2_Index_List) * modelheader.num_tris);

  precalc := mallocz(fNumFrames * SizeOf(GLuint));
  precalc_s := mallocz(fNumFrames * SizeOf(GLuint));
  fTops := mallocz(fNumFrames * SizeOf(float));

  strm.Free;

  if additionalframes <> nil then
    for i := 0 to additionalframes.Count - 1 do
    begin
      m := TModel.Create(additionalframes.strings[i], offset, xx, yy, zz, scale, flags, -1, nil);
      if not MergeFrames(m) then
        I_Error('TModel.MergeFrames(): Can not merge model "%s" into model "%s"', [additionalframes.strings[i], fname]);
      m.Free;
    end;

end;

//==============================================================================
// TModel.MergeFrames
//
//------------------------------------------------------------------------------
//
//==============================================================================
function TModel.MergeFrames(const model: TModel): boolean;
var
  i: integer;
begin
  if model.fNumVertexes <> fNumVertexes then
  begin
    result := false;
    exit;
  end;

  realloc(pointer(TheVectorsArray),
    fNumFrames * SizeOf(PGLVertexArray),
    (model.fNumFrames + fNumFrames) * SizeOf(PGLVertexArray));

  realloc(pointer(precalc),
    fNumFrames * SizeOf(GLuint),
    (model.fNumFrames + fNumFrames) * SizeOf(GLuint));

  realloc(pointer(precalc_s),
    fNumFrames * SizeOf(GLuint),
    (model.fNumFrames + fNumFrames) * SizeOf(GLuint));

  for i := fNumFrames to model.fNumFrames + fNumFrames - 1 do
  begin
    precalc[i] := model.precalc[fNumFrames - i];
    precalc_s[i] := model.precalc_s[fNumFrames - i];
    TheVectorsArray[i] := malloc(fNumVertexes * SizeOf(TGLVectorf3));
    memcpy(TheVectorsArray[i], model.TheVectorsArray[fNumFrames - i], fNumVertexes * SizeOf(TGLVectorf3));
  end;

  fNumFrames := model.fNumFrames + fNumFrames;

  result := true;
end;

//------------------------------------------------------------------------------

destructor TModel.Destroy;
var
  i: integer;
begin
  for i := 0 to fNumFrames - 1 do
  begin
    if precalc[i] > 0 then
      glDeleteLists(precalc[i], 1);
    if precalc_s[i] > 0 then
      glDeleteLists(precalc_s[i], 1);
  end;
  memfree(pointer(precalc), fNumFrames * SizeOf(GLuint));
  memfree(pointer(precalc_s), fNumFrames * SizeOf(GLuint));
  memfree(pointer(fTops), fNumFrames * SizeOf(float));
  memfree(pointer(UV), fNumVertexes * SizeOf(GLTexcoord));
  for i := 0 to fNumFrames - 1 do
  begin
    if TheVectorsArray[i] <> nil then
      memfree(pointer(TheVectorsArray[i]), fNumVertexes * SizeOf(TGLVectorf3));
  end;
  memfree(pointer(TheVectorsArray), fNumFrames * SizeOf(GLVertexArraysP));
end;

//==============================================================================
//
// TModel.ReduceMemory
//
//==============================================================================
procedure TModel.ReduceMemory;
var
  i: integer;
  frames_in_use: PBooleanArray;
begin
  if findex < 0 then
    Exit;

  frames_in_use := mallocz(SizeOf(Boolean) * fNumFrames);
  for i := 0 to nummodelstates - 1 do
    if modelstates[i].modelidx = findex then
    begin
      if modelstates[i].startframe >= 0 then
        frames_in_use[modelstates[i].startframe] := true;
      if modelstates[i].endframe >= 0 then
        frames_in_use[modelstates[i].endframe] := true;
      if modelstates[i].nextframe >= 0 then
        frames_in_use[modelstates[i].nextframe] := true;
    end;

  for i := 0 to fNumFrames - 1 do
  begin
    if (not frames_in_use[i]) and (TheVectorsArray[i] <> nil) then
      memfree(pointer(TheVectorsArray[i]), fNumVertexes * SizeOf(TGLVectorf3))
    else if TheVectorsArray[i] <> nil then
      fCalcFrameTop(i);
  end;
  memfree(Pointer(frames_in_use), SizeOf(Boolean) * fNumFrames);
end;

//------------------------------------------------------------------------------
var
  dbg_frm1, dbg_frm2: integer;
  dbg_offset: float;

//==============================================================================
//
// TModel.Draw
//
//==============================================================================
procedure TModel.Draw(const frm1, frm2: integer; const offset: float; const shadow: boolean; const shadowplane: float);
var
  w2: float;
  v1, v2, mark: PGLVertex;
  x, y, z: float;
  coord: PGLTexcoord;
begin
{$IFDEF DEBUG}
  printf('gametic=%d, frm1=%d, frm2=%d, offset=%2.2f'#13#10, [gametic, frm1, frm2, offset]);
{$ENDIF}
  dbg_frm1 := frm1;
  dbg_frm2 := frm2;
  dbg_offset := offset;

  if (frm1 = frm2) or (frm2 < 0) or (offset < 0.01) then
  begin
    DrawSimple(frm1, shadow, shadowplane);
    exit;
  end;

  if offset > 0.99 then
  begin
    DrawSimple(frm2, shadow, shadowplane);
    exit;
  end;

  w2 := 1.0 - offset;

  v1 := @TheVectorsArray[frm1][0];
  mark := @TheVectorsArray[frm1][fNumVertexes];
  v2 := @TheVectorsArray[frm2][0];
  coord := @UV[0];
  glBegin(GL_TRIANGLES);
    while integer(v1) < integer(mark) do
    begin
      glTexCoord2fv(@coord.u);
      x := v1.x * w2 + v2.x * offset;
      y := v1.y * w2 + v2.y * offset;
      z := v1.z * w2 + v2.z * offset;
      glVertex3f(x, y, z);
      inc(v1);
      inc(v2);
      inc(coord);
    end;
  glEnd;

  if shadow then
  begin
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix;
    glTranslatef(shadowplane/5, shadowplane, shadowplane/10);
    if offset > 0.5 then
      DrawShadow(frm2)
    else
      DrawShadow(frm1);
    glPopMatrix;
  end;
end;

//==============================================================================
// TModel.DrawSimple
//
//------------------------------------------------------------------------------
//
//==============================================================================
procedure TModel.DrawSimple(const frm: integer; const shadow: boolean; const shadowplane: float);
var
  i: integer;
begin
  if precalc[frm] > 0 then
    glCallList(precalc[frm])
  else
  begin
    precalc[frm] := glGenLists(1);

    glNewList(precalc[frm], GL_COMPILE_AND_EXECUTE);

      glBegin(GL_TRIANGLES);
        for i := 0 to fNumVertexes - 1 do
        begin
          glTexCoord2f(UV[i].u, UV[i].v);
          glVertex3fv(@TheVectorsArray[frm][i]);
        end;
      glEnd;

    glEndList;
  end;
  if shadow then
  begin
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix;
    glTranslatef(shadowplane/10, shadowplane, shadowplane/10);
    DrawShadow(frm);
    glPopMatrix;
  end;
end;

//==============================================================================
//
// TModel.fCalcFrameTop
//
//==============================================================================
procedure TModel.fCalcFrameTop(const frm: integer);
var
  i: integer;
  m: float;
  c: float;
begin
  m := -99999.99;
  for i := 0 to fNumVertexes - 1 do
  begin
    c := TheVectorsArray[frm][i].y;
    if c > m then
      m := c;
  end;
  fTops[frm] := m;
end;

//==============================================================================
//
// TModel.GetTop
//
//==============================================================================
function TModel.GetTop(const frm: integer): float;
begin
  result := fTops[frm];
end;

//==============================================================================
//
// TModel.DrawShadow
//
//==============================================================================
procedure TModel.DrawShadow(const frm: Integer);
var
  i: integer;
  zz: float;
begin
  if not journeymapinfo[gamemap].drawshadows then
    exit;

  glDisable(GL_TEXTURE_2D);
          glAlphaFunc(GL_LESS, 0.5);
  glColor4f(0.01, 0.01, 0.01, 0.2);

  if precalc_s[frm] > 0 then
    glCallList(precalc_s[frm])
  else
  begin
    precalc_s[frm] := glGenLists(1);

    glNewList(precalc_s[frm], GL_COMPILE_AND_EXECUTE);
    glBegin(GL_TRIANGLES);

      zz := 0.003;
      for i := 0 to fNumVertexes - 1 do
      begin
        glVertex3f(TheVectorsArray[frm][i].x + 0.1 * TheVectorsArray[frm][i].z, zz, TheVectorsArray[frm][i].z + 0.1 * TheVectorsArray[frm][i].z);
        zz := zz + 0.000001;
      end;

    glEnd;

    glEndList;
  end;

  glAlphaFunc(GL_GEQUAL, 0.5);
  glEnable(GL_TEXTURE_2D);
  glColor4f(1, 1, 1, 1);
end;
end.
