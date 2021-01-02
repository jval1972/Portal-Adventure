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

{$i portal.inc}

unit r_procs;

interface

uses
  d_delphi;

type
  rproc_t = record
    proc: Pprocedure;
    name: string;
  end;

const
  NUMRPROCS = 128;

procedure R_InitProcs;

function R_FindProc(const name: string): Pprocedure;

function R_E1M6Sealevel: integer;

implementation

uses
  dglOpenGL,
  gamedef,
  r_intrpl,
  r_defs,
  r_main,
  m_fixed,
  m_rnd,
  tables,
  p_tick,
  p_maputl,
  sc_engine,
  gl_models,
  gl_render,
  gl_types,
  gl_defs;

var
  rprocs: array[0..NUMRPROCS - 1] of rproc_t;

function R_LevelTime: float;
begin
  if isgamesuspended then
    result := leveltime
  else
    result := leveltime + ticfrac / FRACUNIT;
end;

procedure R_BindProcTexture(const texname: string; var tex: GLuint);
begin
  if tex = 0 then
    tex := gld_GetModelTexture(texname);
  glBindTexture(GL_TEXTURE_2D, tex);
end;

function X(const xx: float): float;
begin
  result := -xx / MAP_COEFF;
end;

function Y(const yy: float): float;
begin
  result := yy / MAP_COEFF;
end;

function Z(const zz: float): float;
begin
  result := zz / MAP_COEFF;
end;

procedure R_Vertex(const xx, yy, zz: float);
begin
  glVertex3f(X(xx), Z(zz), Y(yy));
end;

var
  waterfalltexture: GLuint = 0;

procedure R_E1M5WaterFall;
var
  dv: float;
  s, c: float;
begin
  R_BindProcTexture('wfall1.jpg', waterfalltexture);

  dv := -R_LevelTime / (4 * TICRATE);

  glBegin(GL_TRIANGLE_FAN);

    glTexCoord2f(0.0, dv);
    R_Vertex(-7466, -17879, 512);

    glTexCoord2f(1.0, dv);
    R_Vertex(-7366, -17921, 512);

    glTexCoord2f(1.0, 1.0 + dv);
    R_Vertex(-7366, -17921, -8);

    glTexCoord2f(0.0, 1.0 + dv);
    R_Vertex(-7466, -17879, -8);

  glEnd;

  s := 0.1 * sin(dv);
  c := 0.1 * cos(dv);

  glBegin(GL_TRIANGLE_FAN);

    glTexCoord2f(0.0, s);
    R_Vertex(-7936, -17856, -4 + 3 * Sin(10 * dv));

    glTexCoord2f(1.0, c);
    R_Vertex(-7269, -17856, -4 - 3 * Sin(10 * dv));

    glTexCoord2f(1.0, 2 + s);
    R_Vertex(-7269, -18608, -4 + 2 * Sin(2 * dv));

    glTexCoord2f(0.0, 2 + c);
    R_Vertex(-7936, -18608, -4 - 2 * Sin(2 * dv));

  glEnd;


end;


var
  e1m6sealevel: fixed_t = 0;

function R_E1M6Sealevel: integer;
begin
  result := e1m6sealevel;
end;

procedure R_E1M6Sea;
var
  dv: float;
  s, c: float;
  wv: float;
begin
  R_BindProcTexture('wfall1.jpg', waterfalltexture);

  dv := R_LevelTime / (2 * TICRATE);
  s := 0.1 * sin(dv / 10);
  c := 0.1 * cos(dv / 10);

  wv := 4 * Sin(4 * dv);

  e1m6sealevel := Round((16 + wv) * FRACUNIT);

  glBegin(GL_TRIANGLE_FAN);

    glTexCoord2f(0.0, s);
    R_Vertex(-14000, 1498, 16 + wv);

    glTexCoord2f(1.0, c);
    R_Vertex(2800, 1498, 16 + wv);

    glTexCoord2f(1.0, 2 + s);
    R_Vertex(2800, -12000, 16 + wv);

    glTexCoord2f(0.0, 2 + c);
    R_Vertex(-14000, -12000, 16 + wv);

  glEnd;

  glBegin(GL_QUADS);
  // left
    glTexCoord2f(0.0, 0.0);
    R_Vertex(-50000, -50000, 300);

    glTexCoord2f(0.0, 0);
    R_Vertex(-11000, -9600, 0);

    glTexCoord2f(0.0, 0);
    R_Vertex(-11000, 0, 0);

    glTexCoord2f(0.0, 0.0);
    R_Vertex(-50000, 50000, 300);

  // top
    glTexCoord2f(0.0, 0.0);
    R_Vertex(-50000, 50000, 300);

    glTexCoord2f(0.0, 0);
    R_Vertex(-11000, 0, 0);

    glTexCoord2f(0.0, 0);
    R_Vertex(0, 0, 0);

    glTexCoord2f(0.0, 0.0);
    R_Vertex(50000, 50000, 300);

  // right
    glTexCoord2f(0.0, 0.0);
    R_Vertex(50000, 50000, 300);

    glTexCoord2f(0.0, 0);
    R_Vertex(0, 0, 0);

    glTexCoord2f(0.0, 0);
    R_Vertex(0, -9600, 0);

    glTexCoord2f(0.0, 0.0);
    R_Vertex(50000, -50000, 256);
    
  // bottom
    glTexCoord2f(0.0, 0.0);
    R_Vertex(50000, -50000, 256);

    glTexCoord2f(0.0, 0);
    R_Vertex(0, -9600, 0);

    glTexCoord2f(0.0, 0);
    R_Vertex(-11000, -9600, 0);

    glTexCoord2f(0.0, 0.0);
    R_Vertex(-50000, -50000, 300);

  glEnd;
end;

var
  e1m6crate1tex: GLuint = 0;

procedure R_E1M6Crate;
begin
  if viewz > 16 * FRACUNIT then
    exit;

  R_BindProcTexture('FCRATE1.png', e1m6crate1tex);

  glBegin(GL_TRIANGLE_FAN);

    glTexCoord2f(0.0, 0.0);
    R_Vertex(-2483, -7924, -448);

    glTexCoord2f(0.0, 1.0);
    R_Vertex(-2438, -7879, -448);

    glTexCoord2f(0.125, 1.0);
    R_Vertex(-2432, -7885, -448);

    glTexCoord2f(0.125, 0.125);
    R_Vertex(-2471, -7924, -448);

    glTexCoord2f(0.125, 0.875);
    R_Vertex(-2438, -7957, -448);

    glTexCoord2f(0.0, 1.0);
    R_Vertex(-2438, -7969, -448);

  glEnd;

  glBegin(GL_TRIANGLE_FAN);

    glTexCoord2f(0.125, 0.125);
    R_Vertex(-2438, -7957, -448);

    glTexCoord2f(0.0, 0.0);
    R_Vertex(-2438, -7969, -448);

    glTexCoord2f(0.0, 1.0);
    R_Vertex(-2393, -7924, -448);

    glTexCoord2f(0.125, 1.0);
    R_Vertex(-2399, -7918, -448);

  glEnd;

end;

var
  e1m6gstex: GLuint = 0;

procedure R_E1M6GS;
begin
  if viewz < -16 * FRACUNIT then
    exit;

  R_BindProcTexture('GENERALSTORE.png', e1m6gstex);

  glBegin(GL_TRIANGLE_FAN);

    glTexCoord2f(0.0, 0.0);
    R_Vertex(-5807, -2431, 220);

    glTexCoord2f(0.529295, 0.0);
    R_Vertex(-5737, -2391, 220);

    glTexCoord2f(0.529295, 0.8125);
    R_Vertex(-5737, -2391, 195);

    glTexCoord2f(0.0, 0.8125);
    R_Vertex(-5807, -2431, 195);

  glEnd;

end;


////////////////////////////////////////////////////////////////////////////////
// Procedural generation
////////////////////////////////////////////////////////////////////////////////
type
  rprocvertex_t = record
    x, y, z: fixed_t;
    angle: angle_t;
  end;

  rprocvertex_tArray = array[0..$FF] of rprocvertex_t;
  Prprocvertex_tArray = ^rprocvertex_tArray;


procedure QuickSortVertexes(const A: Prprocvertex_tArray; iLo, iHi: Integer) ;
var
  Lo, Hi: Integer;
  Pivot: angle_t;
  T: rprocvertex_t;
begin
  Lo := iLo;
  Hi := iHi;
  Pivot := A[(Lo + Hi) div 2].angle;
  repeat
    while A[Lo].angle < Pivot do Inc(Lo);
    while A[Hi].angle > Pivot do Dec(Hi);
    if Lo <= Hi then
    begin
      T := A[Lo];
      A[Lo] := A[Hi];
      A[Hi] := T;
      Inc(Lo) ;
      Dec(Hi) ;
    end;
  until Lo > Hi;
  if Hi > iLo then QuickSortVertexes(A, iLo, Hi);
  if Lo < iHi then QuickSortVertexes(A, Lo, iHi);
end;
 

type
  rproclayerparams_t = record
    height: fixed_t;
    height_rnd: fixed_t;
    width: fixed_t;
    width_rnd: fixed_t;
  end;

  rproclayer_t = record
    params: rproclayerparams_t;
    vertexes: rprocvertex_tArray;
  end;
  Prproclayer_t = ^rproclayer_t;

const
  MAXLAYERS = 5;

//
// params:
//
// <numlayers>
// <height> <height_rnd> <width> <width_rnd>
// <height> <height_rnd> <width> <width_rnd>
// ....
//
procedure R_CreateProceduralRock(const xx, yy: fixed_t; const sparams: string; const rndbase: integer = 0; const top: Boolean = True);
var
  flayers: array[0..MAXLAYERS - 1] of rproclayer_t;
  fnumlayers: integer;
  sc: TScriptEngine;
  i, j, j1: integer;
  vertexes: Prprocvertex_tArray;
  layer: Prproclayer_t;
  prevlayer: Prproclayer_t;
  layersize: integer;
  sec: Psector_t;
  dist: fixed_t;
  xp, yp: fixed_t;
  x, y: fixed_t;
  basez: fixed_t;
  line: Pline_t;
  rnd: integer;
  V: array[0..$FF] of single;
  vv: float;
begin
  ZeroMemory(@flayers, SizeOf(flayers));

  x := xx * FRACUNIT;
  y := yy * FRACUNIT;
// Parse parameters
  sc := TScriptEngine.Create(sparams);
  sc.MustGetInteger;
  fnumlayers := sc._Integer;
  for i := 1 to fnumlayers do
  begin
    sc.MustGetInteger;
    flayers[i].params.height := sc._Integer * FRACUNIT;
    sc.MustGetInteger;
    flayers[i].params.height_rnd := sc._Integer * FRACUNIT;
    sc.MustGetInteger;
    flayers[i].params.width := sc._Integer * FRACUNIT;
    sc.MustGetInteger;
    flayers[i].params.width_rnd := sc._Integer * FRACUNIT;
  end;
  sc.Free;

// Create first layer - Height is from mo.sector
  layersize := 0;
  sec := R_PointInSubsector(x, y).sector;
  vertexes := @flayers[0].vertexes;
  for i := 0 to sec.linecount - 1 do
  begin
    line := sec.lines[i];

    if not line.v1.glbsp then
    begin
      j := 0;
      while j < layersize do
      begin
        if (vertexes[j].x = line.v1.x) and (vertexes[j].y = line.v1.y) then
          break;
        inc(j);
      end;
      vertexes[j].x := line.v1.x;
      vertexes[j].y := line.v1.y;
      vertexes[j].z := sec.floorheight - 1 * FRACUNIT;
      vertexes[j].angle := R_PointToAngle2(x, y, vertexes[j].x, vertexes[j].y);
      if layersize <= j then layersize := j + 1;
    end;

    if not line.v1.glbsp then
    begin
      j := 0;
      while j < layersize do
      begin
        if (vertexes[j].x = line.v2.x) and (vertexes[j].y = line.v2.y) then
          break;
        inc(j);
      end;
      vertexes[j].x := line.v2.x;
      vertexes[j].y := line.v2.y;
      vertexes[j].z := sec.floorheight;
      vertexes[j].angle := R_PointToAngle2(x, y, vertexes[j].x, vertexes[j].y);
      if layersize <= j then layersize := j + 1;
    end;
  end;

  QuickSortVertexes(vertexes, 0, layersize - 1);

  vv := 0.0;
  for j := 0 to layersize do
  begin
    j1 := (j + 1) mod layersize;
    V[j] := vv;
    vv := vv + P_Distance(vertexes[j1].x - vertexes[j].x, vertexes[j1].y - vertexes[j].y) / (64 * FRACUNIT);
  end;


// Create additional layers
  rnd := rndbase;
  basez := sec.floorheight;
  for i := 1 to fnumlayers do
  begin
    prevlayer := @flayers[i - 1];
    layer := @flayers[i];
    basez := basez + layer.params.height;
    for j := 0 to layersize - 1 do
    begin
      dist := P_Distance(prevlayer.vertexes[j].x - x, prevlayer.vertexes[j].y - y) + layer.params.width;
      xp := x + FixedMul(finecosine[prevlayer.vertexes[j].angle shr ANGLETOFINESHIFT], dist);
      yp := y + FixedMul(finesine[prevlayer.vertexes[j].angle shr ANGLETOFINESHIFT], dist);
      layer.vertexes[j].x := xp + round(layer.params.width_rnd * (C_Random(rnd) / 255) - layer.params.width_rnd / 2);
      layer.vertexes[j].y := yp + round(layer.params.width_rnd * (C_Random(rnd) / 255) - layer.params.width_rnd / 2);
      layer.vertexes[j].z := basez + round(layer.params.height_rnd * (C_Random(rnd) / 255) - layer.params.height_rnd / 2);
      layer.vertexes[j].angle := prevlayer.vertexes[j].angle;
    end;
  end;


    glBegin(GL_QUADS);

      for i := 1 to fnumlayers do
      begin
        prevlayer := @flayers[i - 1];
        layer := @flayers[i];

        for j := 0 to layersize - 1 do
        begin
          j1 := (j + 1) mod layersize;

          glTexCoord2f(0.0, v[j]);
          glVertex3f(-layer.vertexes[j].x / MAP_SCALE, layer.vertexes[j].z / MAP_SCALE, layer.vertexes[j].y / MAP_SCALE);
          glTexCoord2f(0.0, v[j + 1]);
          glVertex3f(-layer.vertexes[j1].x / MAP_SCALE, layer.vertexes[j1].z / MAP_SCALE, layer.vertexes[j1].y / MAP_SCALE);
          glTexCoord2f(1.0, v[j + 1]);
          glVertex3f(-prevlayer.vertexes[j1].x / MAP_SCALE, prevlayer.vertexes[j1].z / MAP_SCALE, prevlayer.vertexes[j1].y / MAP_SCALE);
          glTexCoord2f(1.0, v[j]);
          glVertex3f(-prevlayer.vertexes[j].x / MAP_SCALE, prevlayer.vertexes[j].z / MAP_SCALE, prevlayer.vertexes[j].y / MAP_SCALE);
        end;

      end;

    glEnd;

  if top then
  begin
    glBegin(GL_TRIANGLE_FAN);

      glTexCoord2f(x / (64 * FRACUNIT), y / (64 * FRACUNIT));
      glVertex3f(x / MAP_SCALE, y / MAP_SCALE, basez / MAP_SCALE);

      for j := 0 to layersize - 1 do
      begin
        glTexCoord2f(layer.vertexes[j].x / (64 * FRACUNIT), layer.vertexes[j].y / (64 * FRACUNIT));
        glVertex3f(layer.vertexes[j].x / MAP_SCALE, layer.vertexes[j].y / MAP_SCALE, layer.vertexes[j].z / MAP_SCALE);
      end;
      glTexCoord2f(layer.vertexes[0].x / (64 * FRACUNIT), layer.vertexes[0].y / (64 * FRACUNIT));
      glVertex3f(layer.vertexes[0].x / MAP_SCALE, layer.vertexes[0].y / MAP_SCALE, layer.vertexes[0].z / MAP_SCALE);

    glEnd;

  end;

end;

////////////////////////////////////////////////////////////////////////////////

var
  e1m7grondtex: GLuint = 0;
  list1: GLuint = 0;

procedure R_E1M7Rocks;
begin

  if list1 = 0 then
  begin
    list1 := glGenLists(1);

    glNewList(list1, GL_COMPILE);

      R_CreateProceduralRock(-6918, -1594, '3'#13#10'64 16 64 32'#13#10'64 16 -32 8'#13#10'64 16 -64 32', 0, false);
      R_CreateProceduralRock(-6500,  -650, '2'#13#10'64 32 64 32'#13#10'64 32 -32 16', 0, true);
      R_CreateProceduralRock(-6200,  -640, '2'#13#10'64 32 64 32'#13#10'64 32 -32 16', 0, true);
      R_CreateProceduralRock(-4596,  -1535, '4'#13#10'64 32 64 32'#13#10'64 32 -16 4'#13#10'64 32 -64 16'#13#10'96 48 -128 64', 0, false);
      R_CreateProceduralRock(-6865,  -3105, '4'#13#10'16 8 128 32'#13#10'64 32 8 4'#13#10'16 4 -128 32'#13#10'64 48 32 8', 0, false);
      R_CreateProceduralRock(-4332, -2780, '3'#13#10'64 16 64 32'#13#10'64 16 -32 16'#13#10'64 16 -64 32', 0, false);
      R_CreateProceduralRock(-6550, -4125, '2'#13#10'64 32 64 32'#13#10'64 32 -32 16', 0, true);
      R_CreateProceduralRock(-5176, -4374, '2'#13#10'64 32 64 32'#13#10'64 32 -32 16', 0, true);

      R_CreateProceduralRock(-6016, -4604, '3'#13#10'64 32 128 32'#13#10'64 32 16 16'#13#10'64 32 -64 16', 1, false);
      R_CreateProceduralRock(-5712, -4600, '3'#13#10'64 32 128 32'#13#10'64 32 16 16'#13#10'64 32 -64 16', 2, false);
      R_CreateProceduralRock(-5694, -4940, '3'#13#10'64 32 128 32'#13#10'64 32 16 16'#13#10'64 32 -64 16', 3, false);
      R_CreateProceduralRock(-6012, -4918, '3'#13#10'64 32 128 32'#13#10'64 32 16 16'#13#10'64 32 -64 16', 4, false);

      R_CreateProceduralRock(-6058, -5517, '2'#13#10'64 32 64 32'#13#10'80 32 -32 16', 0, false);
      R_CreateProceduralRock(-4516, -5641, '2'#13#10'64 32 64 32'#13#10'80 32 -32 16', 0, false);
      R_CreateProceduralRock(-3366, -5051, '2'#13#10'64 32 64 32'#13#10'80 32 -32 16', 0, false);

    glEndList;
  end;

  R_BindProcTexture('grondp.png', e1m7grondtex);

  glCallList(list1);

end;

const
  TUNEL_TEXTURE_SPEED = 1 / 200;
  TUNEL_LENGTH = 48;

var
  e1m8kal: GLuint = 0;
  Tunnels: array[0..TUNEL_LENGTH, 0..TUNEL_LENGTH] of GLVertex;



procedure R_E1M8Drawer;
var
  angle: float;
  i, j: integer;
  C, J1, J2 : float;
begin
  R_BindProcTexture('grottebl.jpg', e1m8kal);

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix;
  glLoadIdentity;

  if isgamesuspended then
    angle := leveltime
  else
    angle := leveltime + ticfrac / FRACUNIT;

  // setup tunnel coordinates
  for i := 0 to 12 do
  begin
    for j := 0 to TUNEL_LENGTH do
    begin
      Tunnels[i, j].X := 2.5 * ((3 - j / 12) * cos(2 * pi / 12 * i) + 2 * sin((Angle + 2 * j) / 29) + cos((Angle + 2 * j) / 13) - 2 * sin(Angle / 29) - cos(Angle / 13));
      Tunnels[i, j].Y := 1.8 + 0.16 * j + (3 - j / 12) * sin(2 * pi / 12 * i) + 2 * cos((Angle + 2 * j) / 33) + sin((Angle + 2 * j) / 17) - 2 * cos(Angle / 33) - sin(Angle / 17);
      if j > 0 then
        Tunnels[i, j].Z := -j - 2
      else
        Tunnels[i, j].Z := 0;
    end;
  end;

  // draw tunnel
  for j := 0 to TUNEL_LENGTH - 2 do
  begin
    J1 := j / 32 + Angle * TUNEL_TEXTURE_SPEED;
    J2 := (j + 1) / 32 + Angle * TUNEL_TEXTURE_SPEED;

    // near the end of the tunnel, fade the effect away
    if j > TUNEL_LENGTH / 2 then
      C := 1.0 - (j - TUNEL_LENGTH / 2) / 10
    else
      C := 1.0;

    glColor3f(C, C, C);

    glBegin(GL_QUADS);
      for i := 0 to 11 do
      begin
        glTexCoord2f((i - 3) / 12, J1); glVertex3f(Tunnels[i, j].X, Tunnels[i, j].Y, Tunnels[i, j].Z);
        glTexCoord2f((i - 2) / 12, J1); glVertex3f(Tunnels[i + 1, j].X, Tunnels[i + 1,  j ].Y, Tunnels[i + 1, j].Z);
        glTexCoord2f((i - 2) / 12, J2); glVertex3f(Tunnels[i + 1, j + 1].X, Tunnels[i + 1, j + 1].Y, Tunnels[i + 1, j + 1].Z);
        glTexCoord2f((i - 3) / 12, J2); glVertex3f(Tunnels[i, j + 1].X, Tunnels[i, j + 1].Y, Tunnels[i, j + 1].Z);
      end;
    glEnd();
  end;


  glMatrixMode(GL_MODELVIEW);
  glPopMatrix;


  glEnable(GL_LINE_SMOOTH);
  glLineWidth(SCREENWIDTH / 320);
  glColor3f(1.0, 1.0, 0.2);


  glBegin(GL_LINES);
    for i := 0 to 60 do
    begin
      R_Vertex(-8000, -1500 -i * 100, 0);
      R_Vertex(-1000, -1500 -i * 100, 0);
    end;
    for i := 0 to 60 do
    begin
      R_Vertex(-1500 -i * 100, -1000, 0);
      R_Vertex(-1500 -i * 100, -8000, 0);
    end;
  glEnd;
end;

procedure R_InitProcs;
var
  i: integer;
begin
  for i := 0 to NUMRPROCS - 1 do
  begin
    rprocs[i].proc := nil;
    rprocs[i].name := 'NULL';
  end;

  rprocs[0].proc := @R_E1M5WaterFall;
  rprocs[0].name := strupper('E1M5WaterFall');
  rprocs[1].proc := @R_E1M6Sea;
  rprocs[1].name := strupper('E1M6Sea');
  rprocs[2].proc := @R_E1M6Crate;
  rprocs[2].name := strupper('E1M6Crate');
  rprocs[3].proc := @R_E1M6GS;
  rprocs[3].name := strupper('E1M6GS');
  rprocs[4].proc := @R_E1M7Rocks;
  rprocs[4].name := strupper('E1M7Rocks');
  rprocs[5].proc := @R_E1M8Drawer;
  rprocs[5].name := strupper('E1M8Drawer');
end;


function R_FindProc(const name: string): Pprocedure;
var
  i: integer;
  ch: string;
begin
  ch := strupper(name);
  for i := 0 to NUMRPROCS - 1 do
  begin
    if (rprocs[i].name = ch) or (rprocs[i].name = 'R_' + ch) or ('R_' + rprocs[i].name = ch) then
    begin
      result := rprocs[i].proc;
      exit;
    end;
  end;
  result := nil;
end;


end.
