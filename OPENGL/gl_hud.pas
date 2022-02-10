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

unit gl_hud;

interface

uses
  d_player;

//==============================================================================
//
// gld_InitHud
//
//==============================================================================
procedure gld_InitHud;

//==============================================================================
//
// gld_HudDone
//
//==============================================================================
procedure gld_HudDone;

//==============================================================================
//
// gld_UpdateHud
//
//==============================================================================
procedure gld_UpdateHud(const p: Pplayer_t);

//==============================================================================
//
// gld_HudTicker
//
//==============================================================================
procedure gld_HudTicker(const p: Pplayer_t);

//==============================================================================
//
// gld_ReInit
//
//==============================================================================
procedure gld_ReInit;

implementation

uses
  dglOpenGL,
  d_delphi,
  gamedef,
  g_game,
  i_system,
  p_mobj,
  p_tick,
  m_rnd,
  gl_tex,
  t_main;

var
  hud_tex: PTexture;
  tex_progress: PTexture;
  prog1, prog2: Pointer;
  hud_tex_gl: LongWord;
  hudTime_tex_gl: LongWord;
  hudDemo_tex_gl: LongWord;
  heal_tex_gl: LongWord;
  bkey_tex_gl: LongWord;
  rkey_tex_gl: LongWord;
  ykey_tex_gl: LongWord;
  gkey_tex_gl: LongWord;
  wkey_tex_gl: LongWord;
  money_tex_gl: LongWord;
  papyrus_tex_gl: LongWord;
  astrolabe_tex_gl: LongWord;
  antigravrock_tex_gl: LongWord;
  diving_tex_gl: LongWord;
  ind_diving_tex_gl: LongWord;
  ind_gun_tex_gl: LongWord;
  numbers_tex_gl: LongWord;
  glhudInitialized: Boolean = false;
  hud_health: integer;
  hud_power: integer;

const
  HUDTEXNAME = 'glhud.material';
  HUDPROGRESSTEXNAME = 'glhud_1.material';

//==============================================================================
//
// gld_InitHud
//
//==============================================================================
procedure gld_InitHud;
begin
  if not glhudInitialized then
  begin
    hud_tex := T_LoadHiResTexture(HUDTEXNAME);
    if hud_tex = nil then
      I_Error('gld_InitHud(): Can not load HUD texture %s', [HUDTEXNAME]);
    hud_tex.SwapRGB;

    tex_progress := T_LoadHiResTexture(HUDPROGRESSTEXNAME);
    if tex_progress = nil then
      I_Error('gld_InitHud(): Can not load HUD progress texture %s', [HUDPROGRESSTEXNAME]);
    tex_progress.SwapRGB;

    prog1 := tex_progress.GetImage;
    prog2 := tex_progress.GetPointerAt(0, 11);
    glhudInitialized := true;
    hud_health := MININT;
    hud_power := MININT;
    hud_tex_gl := 0;
    hudTime_tex_gl := gld_LoadExternalTexture('glhud_time.material', false, GL_CLAMP);
    hudDemo_tex_gl := gld_LoadExternalTexture('glhud_demo.material', false, GL_CLAMP);
    heal_tex_gl := gld_LoadExternalTexture('heal1.png', false, GL_CLAMP);
    bkey_tex_gl := gld_LoadExternalTexture('hub_bkey.png', false, GL_CLAMP);
    rkey_tex_gl := gld_LoadExternalTexture('hub_rkey.png', false, GL_CLAMP);
    gkey_tex_gl := gld_LoadExternalTexture('hub_gkey.png', false, GL_CLAMP);
    ykey_tex_gl := gld_LoadExternalTexture('hub_ykey.png', false, GL_CLAMP);
    wkey_tex_gl := gld_LoadExternalTexture('hub_wkey.png', false, GL_CLAMP);
    money_tex_gl := gld_LoadExternalTexture('glhud_money.png', false, GL_CLAMP);
    papyrus_tex_gl := gld_LoadExternalTexture('hud_papyrus.png', false, GL_CLAMP);
    astrolabe_tex_gl := gld_LoadExternalTexture('glhud_astrolabe.png', false, GL_CLAMP);
    antigravrock_tex_gl := gld_LoadExternalTexture('glhud_rock.png', false, GL_CLAMP);
    diving_tex_gl := gld_LoadExternalTexture('glhud_diving.png', false, GL_CLAMP);
    ind_diving_tex_gl := gld_LoadExternalTexture('ind_diving.material', false, GL_CLAMP);
    ind_gun_tex_gl := gld_LoadExternalTexture('ind_gun.material', false, GL_CLAMP);
    numbers_tex_gl := gld_LoadExternalTexture('glhud_numbers.png', false, GL_CLAMP);
  end;
end;

//==============================================================================
//
// gld_HudDone
//
//==============================================================================
procedure gld_HudDone;
begin
  if not glhudInitialized then
    exit;

  Dispose(hud_tex, Destroy);
  Dispose(tex_progress, Destroy);

  if hud_tex_gl <> 0 then
    glDeleteTextures(1, @hud_tex_gl);
  if hudTime_tex_gl <> 0 then
    glDeleteTextures(1, @hud_tex_gl);
  if hudDemo_tex_gl <> 0 then
    glDeleteTextures(1, @hudDemo_tex_gl);

  if heal_tex_gl <> 0 then
    glDeleteTextures(1, @heal_tex_gl);
  if bkey_tex_gl <> 0 then
    glDeleteTextures(1, @bkey_tex_gl);
  if rkey_tex_gl <> 0 then
    glDeleteTextures(1, @rkey_tex_gl);
  if gkey_tex_gl <> 0 then
    glDeleteTextures(1, @gkey_tex_gl);
  if ykey_tex_gl <> 0 then
    glDeleteTextures(1, @ykey_tex_gl);
  if wkey_tex_gl <> 0 then
    glDeleteTextures(1, @wkey_tex_gl);
  if money_tex_gl <> 0 then
    glDeleteTextures(1, @money_tex_gl);
  if papyrus_tex_gl <> 0 then
    glDeleteTextures(1, @papyrus_tex_gl);
  if astrolabe_tex_gl <> 0 then
    glDeleteTextures(1, @astrolabe_tex_gl);
  if antigravrock_tex_gl <> 0 then
    glDeleteTextures(1, @antigravrock_tex_gl);
  if diving_tex_gl <> 0 then
    glDeleteTextures(1, @diving_tex_gl);
  if ind_diving_tex_gl <> 0 then
    glDeleteTextures(1, @ind_diving_tex_gl);
  if ind_gun_tex_gl <> 0 then
    glDeleteTextures(1, @ind_gun_tex_gl);
  if numbers_tex_gl <> 0 then
    glDeleteTextures(1, @numbers_tex_gl);
end;

var
  glhud_curmoney: integer = 0;
  moneygoal: integer = 0;

//==============================================================================
//
// gld_ReInit
//
//==============================================================================
procedure gld_ReInit;
begin
  glhud_curmoney := 0;
end;

//==============================================================================
//
// gld_HudTicker
//
//==============================================================================
procedure gld_HudTicker(const p: Pplayer_t);
var
  diff: integer;
begin
  if p.mo = nil then
  begin
    moneygoal := 0;
    glhud_curmoney := 0;
    Exit;
  end;

  moneygoal := P_GetMobjCustomParamValue(p.mo, 'MONEY');
  if glhud_curmoney > moneygoal then
  begin
    diff := (glhud_curmoney - moneygoal) div 10;
    glhud_curmoney := glhud_curmoney - (diff + (M_Random mod 20));
    if glhud_curmoney < moneygoal then
      glhud_curmoney := moneygoal;
  end
  else if glhud_curmoney < moneygoal then
  begin
    diff := (moneygoal - glhud_curmoney) div 10;
    glhud_curmoney := glhud_curmoney + (diff + (M_Random mod 20));
    if glhud_curmoney > moneygoal then
      glhud_curmoney := moneygoal;
  end
end;

//==============================================================================
//
// gld_UpdateHud
//
//==============================================================================
procedure gld_UpdateHud(const p: Pplayer_t);
var
  h1, p1: integer;
  i, j: integer;
  money: integer;
  moneys: string;
  a, b, c, d: float;
  l: integer;
  keystart: integer;
  hh, mm, ss: integer;
  time: integer;
  curtime: integer;
  timestr: string;
  curtimestr: string;
begin
  if not glhudInitialized then
    exit;

  if p.health >= 50 then
    h1 := 42 - (50 - p.health div 2)
  else
    h1 := p.health div 3;
  if (h1 = 0) and (p.health > 0) then
    h1 := 1;

  if p.ammo[Ord(am_cell)] >= 40 then
    p1 := 36 - (30 - p.ammo[Ord(am_cell)] div 10)
  else
    p1 := p.ammo[Ord(am_cell)] div 4;
  if (p1 = 0) and (p.ammo[Ord(am_cell)] > 0) then
    p1 := 1;

  if (h1 <> hud_health) or (p1 <> hud_power) then
  begin
    if hud_tex_gl <> 0 then
      glDeleteTextures(1, @hud_tex_gl);

    if h1 <> hud_health then
    begin
      hud_health := h1;
      for i := 0 to h1 - 1 do
        for j := 0 to 10 do
          hud_tex.RasterOPAdd32Aplha(17 + 11 * i, 23 + j, 8, prog1);
      for i := h1 to 41 do
        for j := 0 to 10 do
          hud_tex.RasterOPAdd32Aplha(17 + 11 * i, 23 + j, 8, prog2);
    end;

    if p1 <> hud_power then
    begin
      hud_power := p1;
      for i := 0 to p1 - 1 do
        for j := 0 to 10 do
          hud_tex.RasterOPAdd32Aplha(94 + 11 * i, 48 + j, 8, prog1);
      for i := p1 to 35 do
        for j := 0 to 10 do
          hud_tex.RasterOPAdd32Aplha(94 + 11 * i, 48 + j, 8, prog2);
    end;

    hud_tex_gl := gld_LoadExternalTexture(hud_tex, True, GL_CLAMP)
  end;

  glBindTexture(GL_TEXTURE_2D, hud_tex_gl);
  glBegin(GL_QUADS);
    glTexCoord2f(0.0, 1.0);
    glVertex2i(10, 32);
    glTexCoord2f(1.0, 1.0);
    glVertex2i(522, 32);
    glTexCoord2f(1.0, 0.0);
    glVertex2i(522, 96);
    glTexCoord2f(0.0, 0.0);
    glVertex2i(10, 96);
  glEnd;

  if p.autohealcount > 0 then
  begin
    glBindTexture(GL_TEXTURE_2D, heal_tex_gl);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0, 1.0);
      glVertex2i(102, 76);
      glTexCoord2f(1.0, 1.0);
      glVertex2i(118, 76);
      glTexCoord2f(1.0, 0.0);
      glVertex2i(118, 92);
      glTexCoord2f(0.0, 0.0);
      glVertex2i(102, 92);
    glEnd;
  end;

  keystart := 120;

  if p.cards[Ord(it_yellowcard)] then
  begin
    glBindTexture(GL_TEXTURE_2D, ykey_tex_gl);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0, 1.0);
      glVertex2i(keystart, 76);
      glTexCoord2f(1.0, 1.0);
      glVertex2i(keystart + 16, 76);
      glTexCoord2f(1.0, 0.0);
      glVertex2i(keystart + 16, 92);
      glTexCoord2f(0.0, 0.0);
      glVertex2i(keystart, 92);
    glEnd;
    keystart := keystart + 18;
  end;

  if p.cards[Ord(it_greencard)] then
  begin
    glBindTexture(GL_TEXTURE_2D, gkey_tex_gl);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0, 1.0);
      glVertex2i(keystart, 76);
      glTexCoord2f(1.0, 1.0);
      glVertex2i(keystart + 16, 76);
      glTexCoord2f(1.0, 0.0);
      glVertex2i(keystart + 16, 92);
      glTexCoord2f(0.0, 0.0);
      glVertex2i(keystart, 92);
    glEnd;
    keystart := keystart + 18;
  end;

  if p.cards[Ord(it_bluecard)] or
     p.cards[Ord(it_blueskull)] then
  begin
    glBindTexture(GL_TEXTURE_2D, bkey_tex_gl);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0, 1.0);
      glVertex2i(keystart, 76);
      glTexCoord2f(1.0, 1.0);
      glVertex2i(keystart + 16, 76);
      glTexCoord2f(1.0, 0.0);
      glVertex2i(keystart + 16, 92);
      glTexCoord2f(0.0, 0.0);
      glVertex2i(keystart, 92);
    glEnd;
    keystart := keystart + 18;
  end;

  if p.cards[Ord(it_whitecard)] then
  begin
    glBindTexture(GL_TEXTURE_2D, wkey_tex_gl);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0, 1.0);
      glVertex2i(keystart, 76);
      glTexCoord2f(1.0, 1.0);
      glVertex2i(keystart + 16, 76);
      glTexCoord2f(1.0, 0.0);
      glVertex2i(keystart + 16, 92);
      glTexCoord2f(0.0, 0.0);
      glVertex2i(keystart, 92);
    glEnd;
    keystart := keystart + 18;
  end;

  if p.cards[Ord(it_redcard)] or
     p.cards[Ord(it_redskull)] then
  begin
    glBindTexture(GL_TEXTURE_2D, rkey_tex_gl);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0, 1.0);
      glVertex2i(keystart, 76);
      glTexCoord2f(1.0, 1.0);
      glVertex2i(keystart + 16, 76);
      glTexCoord2f(1.0, 0.0);
      glVertex2i(keystart + 16, 92);
      glTexCoord2f(0.0, 0.0);
      glVertex2i(keystart, 92);
    glEnd;
    keystart := keystart + 18;
  end;

  if p.mo <> nil then
  begin
    if P_GetMobjCustomParamValue(p.mo, 'ASTROLABE') > 0 then
    begin
      glBindTexture(GL_TEXTURE_2D, astrolabe_tex_gl);
      glBegin(GL_QUADS);
        glTexCoord2f(0.0, 1.0);
        glVertex2i(keystart, 76);
        glTexCoord2f(1.0, 1.0);
        glVertex2i(keystart + 16, 76);
        glTexCoord2f(1.0, 0.0);
        glVertex2i(keystart + 16, 92);
        glTexCoord2f(0.0, 0.0);
        glVertex2i(keystart, 92);
      glEnd;
      keystart := keystart + 18;
    end;

    if P_GetMobjCustomParamValue(p.mo, 'ANTIGRAVROCK') > 0 then
    begin
      glBindTexture(GL_TEXTURE_2D, antigravrock_tex_gl);
      glBegin(GL_QUADS);
        glTexCoord2f(0.0, 1.0);
        glVertex2i(keystart, 76);
        glTexCoord2f(1.0, 1.0);
        glVertex2i(keystart + 16, 76);
        glTexCoord2f(1.0, 0.0);
        glVertex2i(keystart + 16, 92);
        glTexCoord2f(0.0, 0.0);
        glVertex2i(keystart, 92);
      glEnd;
      keystart := keystart + 18;
    end;

    if P_GetMobjCustomParamValue(p.mo, 'E1M6DIVING') > 0 then
    begin
      glBindTexture(GL_TEXTURE_2D, diving_tex_gl);
      glBegin(GL_QUADS);
        glTexCoord2f(0.0, 1.0);
        glVertex2i(keystart, 76);
        glTexCoord2f(1.0, 1.0);
        glVertex2i(keystart + 16, 76);
        glTexCoord2f(1.0, 0.0);
        glVertex2i(keystart + 16, 92);
        glTexCoord2f(0.0, 0.0);
        glVertex2i(keystart, 92);
      glEnd;
      keystart := keystart + 18;
    end;

    if P_GetMobjCustomParamValue(p.mo, 'PAPYRUS') > 0 then
    begin
      glBindTexture(GL_TEXTURE_2D, papyrus_tex_gl);
      glBegin(GL_QUADS);
        glTexCoord2f(0.0, 1.0);
        glVertex2i(keystart, 76);
        glTexCoord2f(1.0, 1.0);
        glVertex2i(keystart + 16, 76);
        glTexCoord2f(1.0, 0.0);
        glVertex2i(keystart + 16, 92);
        glTexCoord2f(0.0, 0.0);
        glVertex2i(keystart, 92);
      glEnd;
      keystart := keystart + 18;
    end;

    money := glhud_curmoney; // P_GetMobjCustomParamValue(p.mo, 'MONEY');
    if money > 0 then
    begin
      glBindTexture(GL_TEXTURE_2D, money_tex_gl);
      glBegin(GL_QUADS);
        glTexCoord2f(0.0, 1.0);
        glVertex2i(keystart, 76);
        glTexCoord2f(1.0, 1.0);
        glVertex2i(keystart + 16, 76);
        glTexCoord2f(1.0, 0.0);
        glVertex2i(keystart + 16, 92);
        glTexCoord2f(0.0, 0.0);
        glVertex2i(keystart, 92);
      glEnd;
      moneys := itoa(money);
      l := keystart + 16;
      for i := 1 to Length(moneys) do
      begin
        glBindTexture(GL_TEXTURE_2D, numbers_tex_gl);
        a := 0.0;
        b := 1.0;
        c := 16 * (Ord(moneys[i]) - Ord('0')) / 256;
        d := c + 16 / 256;
        glBegin(GL_QUADS);
          glTexCoord2f(a, d);
          glVertex2i(l, 76);
          glTexCoord2f(b, d);
          glVertex2i(l + 16, 76);
          glTexCoord2f(b, c);
          glVertex2i(l + 16, 92);
          glTexCoord2f(a, c);
          glVertex2i(l, 92);
        glEnd;
        l := l + 15;
      end;
    end;

    if demoplayback and (leveltime mod TICRATE > 10) then
    begin
      // Draw leveltime and total time
      glBindTexture(GL_TEXTURE_2D, hudDemo_tex_gl);
      glBegin(GL_QUADS);
        glTexCoord2f(0.0, 1.0);
        glVertex2i(SCREENWIDTH - 192, SCREENHEIGHT - 74);
        glTexCoord2f(1.0, 1.0);
        glVertex2i(SCREENWIDTH + 64, SCREENHEIGHT - 74);
        glTexCoord2f(1.0, 0.0);
        glVertex2i(SCREENWIDTH + 64, SCREENHEIGHT - 12);
        glTexCoord2f(0.0, 0.0);
        glVertex2i(SCREENWIDTH - 192, SCREENHEIGHT - 12);
      glEnd;
    end;

    if gamemap > 1 then
    begin
      // Draw leveltime and total time
      glBindTexture(GL_TEXTURE_2D, hudTime_tex_gl);
      glBegin(GL_QUADS);
        glTexCoord2f(0.0, 1.0);
        glVertex2i(10, 80);
        glTexCoord2f(1.0, 1.0);
        glVertex2i(266, 80);
        glTexCoord2f(1.0, 0.0);
        glVertex2i(266, 144);
        glTexCoord2f(0.0, 0.0);
        glVertex2i(10, 144);
      glEnd;

      time := leveltime;
      for i := 1 to 9 do
        if i <> gamemap then
          time := time + P_GetMobjCustomParamValue(p.mo, 'LEVELTIME' + itoa(gameepisode) + itoa(i));
      curtime := leveltime;

      ss := time div TICRATE;
      mm := ss div 60;
      ss := ss mod 60;
      hh := mm div 60;
      mm := mm mod 60;

      timestr := itoa(hh) + ':' + IntToStrZfill(2, mm) + ':' + IntToStrZfill(2, ss);

      ss := curtime div TICRATE;
      mm := ss div 60;
      ss := ss mod 60;
      hh := mm div 60;
      mm := mm mod 60;

      curtimestr := itoa(hh) + ':' + IntToStrZfill(2, mm) + ':' + IntToStrZfill(2, ss);

      l := 132;
      if Length(curtimestr) > 7 then
        l := l - 16;
      for i := 1 to Length(curtimestr) do
      begin
        glBindTexture(GL_TEXTURE_2D, numbers_tex_gl);
        a := 0.0;
        b := 1.0;
        if curtimestr[i] = ':' then
          c := 160 / 256
        else
          c := 16 * (Ord(curtimestr[i]) - Ord('0')) / 256;
        d := c + 16 / 256;
        glBegin(GL_QUADS);
          glTexCoord2f(a, d);
          glVertex2i(l, 124);
          glTexCoord2f(b, d);
          glVertex2i(l + 16, 124);
          glTexCoord2f(b, c);
          glVertex2i(l + 16, 140);
          glTexCoord2f(a, c);
          glVertex2i(l, 140);
        glEnd;
        if curtimestr[i] = ':' then
          l := l + 6
        else
          l := l + 15;
      end;

      l := 132;
      if Length(timestr) > 7 then
        l := l - 16;
      for i := 1 to Length(timestr) do
      begin
        glBindTexture(GL_TEXTURE_2D, numbers_tex_gl);
        a := 0.0;
        b := 1.0;
        if timestr[i] = ':' then
          c := 160 / 256
        else
          c := 16 * (Ord(timestr[i]) - Ord('0')) / 256;
        d := c + 16 / 256;
        glBegin(GL_QUADS);
          glTexCoord2f(a, d);
          glVertex2i(l, 106);
          glTexCoord2f(b, d);
          glVertex2i(l + 16, 106);
          glTexCoord2f(b, c);
          glVertex2i(l + 16, 122);
          glTexCoord2f(a, c);
          glVertex2i(l, 122);
        glEnd;
        if timestr[i] = ':' then
          l := l + 6
        else
          l := l + 15;
      end;

      l := SCREENWIDTH;

      if (gamemap = 6) and
         (P_GetMobjCustomParamValue(p.mo, 'E1M6DIVING') > 0) and
         (P_GetMobjCustomParamValue(p.mo, 'SWIMMING') > 0) then
      begin
        glBindTexture(GL_TEXTURE_2D, ind_diving_tex_gl);
        glBegin(GL_QUADS);
          glTexCoord2f(0.0, 1.0);
          glVertex2i(l - 74, 10);
          glTexCoord2f(1.0, 1.0);
          glVertex2i(l - 10, 10);
          glTexCoord2f(1.0, 0.0);
          glVertex2i(l - 10, 74);
          glTexCoord2f(0.0, 0.0);
          glVertex2i(l - 74, 74);
        glEnd;
        l := l - 74;
      end;

      if p.weaponowned[Ord(wp_chaingun)] <> 0 then
      begin
        glBindTexture(GL_TEXTURE_2D, ind_gun_tex_gl);
        glBegin(GL_QUADS);
          glTexCoord2f(0.0, 1.0);
          glVertex2i(l - 74, 10);
          glTexCoord2f(1.0, 1.0);
          glVertex2i(l - 10, 10);
          glTexCoord2f(1.0, 0.0);
          glVertex2i(l - 10, 74);
          glTexCoord2f(0.0, 0.0);
          glVertex2i(l - 74, 74);
        glEnd;
      end;
    end;
  end;
end;

end.

