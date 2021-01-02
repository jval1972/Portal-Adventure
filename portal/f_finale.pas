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

unit f_finale;

interface

uses
  d_event,
  info_h;

function F_Responder(ev: Pevent_t): boolean;

{ Called by main loop. }
procedure F_Ticker;

{ Called by main loop. }
procedure F_Drawer;

procedure F_StartFinale;


//
// Final DOOM 2 animation
// Casting by id Software.
//   in order of appearance
//
type
  castinfo_t = record
    name: string;
    _type: mobjtype_t;
  end;
  Pcastinfo_t = ^castinfo_t;

const
  NUM_CASTS = 18;

var
  castorder: array[0..NUM_CASTS - 1] of castinfo_t;

  bgflatE1: string = 'FLOOR4_8';  // end of DOOM Episode 1
  bgflatE2: string = 'SFLR6_1';   // end of DOOM Episode 2
  bgflatE3: string = 'MFLR8_4';   // end of DOOM Episode 3
  bgflatE4: string = 'MFLR8_3';   // end of DOOM Episode 4
  bgflat06: string = 'SLIME16';   // DOOM2 after MAP06
  bgflat11: string = 'RROCK14';   // DOOM2 after MAP11
  bgflat20: string = 'RROCK07';   // DOOM2 after MAP20
  bgflat30: string = 'RROCK17';   // DOOM2 after MAP30
  bgflat15: string = 'RROCK13';   // DOOM2 going MAP15 to MAP31
  bgflat31: string = 'RROCK19';   // DOOM2 going MAP31 to MAP32
  bgcastcall: string = 'BOSSBACK';// Panel behind cast call

implementation

uses
  d_delphi,
  d_player,
  d_main,
  g_game,
  info,
  p_pspr,
  r_data,
  r_defs,
  r_things,
// Functions.
  i_system,
  z_zone,
  v_data,
  v_video,
  w_wad,
  s_sound,
// Data.
  dstrings,
  d_englsh,
  sounds,
  gamedef,
  hu_stuff,
  p_enemy;

var
// Stage of animation:
//  0 = text, 1 = art screen, 2 = character cast
  finalestage: integer;

  finalecount: integer;

const
  TEXTSPEED = 3;
  TEXTWAIT = 250;

var
  finaletext: string;
  finaleflat: string;

procedure F_StartCast; forward;

procedure F_CastTicker; forward;

function F_CastResponder(ev: Pevent_t): boolean; forward;

var
  WINTEXT: string =
    'CONGATULATIONS!'#13#10 + #13#10 +
    'THE KNIGHT DRAGON IS DEAD, AT LAST'#13#10 + #13#10 +
    'THANKS TO YOUR EFFORTS  '#13#10 +
    'THE COUNTRY IS FREE AGAIN... '#13#10 +  #13#10 +
    'BUT... FOR HOW LONG PIECE'#13#10 +
    'WILL LAST IN THIS LAND?'#13#10;

  LOSETEXT: string =
    'DISPITE YOUR EFFORTS'#13#10 +
    'THE DRAGON KNIGHT STILL'#13#10 +
    'RULES THE COUNTRY...'#13#10 + #13#10 +
    'YOUR MAGICAL SKILLS MAYBE'#13#10 +
    'BRING YOU BACK TO LIFE'#13#10 +
    'AND GIVE YOU ANOTHER CHANCE'#13#10 +
    'TO FIGHT FOR FREEDOM....'#13#10 + #13#10 +
    'CAN YOU SUCCEED NEXT TIME?'#13#10;

procedure F_StartFinale;
begin
  if demorecording then
    G_CheckDemoStatus;

  gameaction := ga_nothing;
  gamestate := GS_FINALE;
  viewactive := false;
  finaleflat := 'FLAT19';
  if youwon then
    finaletext := 'win1'
  else
    finaletext := 'lose1';
  finalestage := 0;
  finalecount := 0;
  S_StartMusic(Ord(mus_intro));
end;

function F_Responder(ev: Pevent_t): boolean;
begin
  if finalestage = 2 then
    result := F_CastResponder(ev)
  else
    result := false;
end;

//
// F_Ticker
//
procedure F_Ticker;
begin
  inc(finalecount);

  if (finalestage = 0) and (finalecount > 2100) then
  begin
    finalecount := 0;
    finalestage := 1;
    //wipegamestate := -1;    // force a wipe
    D_StartTitle;
  end;
end;

var
  castnum: integer;
  casttics: integer;
  caststate: Pstate_t;
  castdeath: boolean;
  castframes: integer;
  castonmelee: integer;
  castattacking: boolean;

//
// F_StartCast
//
procedure F_StartCast;
begin
  wipegamestate := -1;    // force a screen wipe
  castnum := 0;
  caststate := @states[mobjinfo[Ord(castorder[castnum]._type)].seestate];
  casttics := caststate.tics;
  castdeath := false;
  finalestage := 2;
  castframes := 0;
  castonmelee := 0;
  castattacking := false;
  S_ChangeMusic(Ord(mus_intro), true);
end;

//
// F_CastTicker
//
procedure F_CastTicker;
var
  st: integer;
  sfx: integer;
begin
  dec(casttics);
  if casttics > 0 then
    exit; // not time to change state yet

  if (caststate.tics = -1) or (caststate.nextstate = S_NULL) then
  begin
    // switch from deathstate to next monster
    inc(castnum);
    castdeath := false;
    if castorder[castnum].name = '' then
      castnum := 0;
    if mobjinfo[Ord(castorder[castnum]._type)].seesound <> 0 then
      S_StartSound(nil, mobjinfo[Ord(castorder[castnum]._type)].seesound);
    caststate := @states[mobjinfo[Ord(castorder[castnum]._type)].seestate];
    castframes := 0;
  end
  else
  begin
  // just advance to next state in animation
    if caststate = @states[Ord(S_PLAY_ATK1)] then
    begin
      castattacking := false;
      castframes := 0;
      caststate := @states[mobjinfo[Ord(castorder[castnum]._type)].seestate];
      casttics := caststate.tics;
      if casttics = -1 then
        casttics := 15;
      exit;
    end;
    st := Ord(caststate.nextstate);
    caststate := @states[st];
    inc(castframes);

    // sound hacks....
    case statenum_t(st) of
      S_PLAY_ATK1:  sfx := Ord(sfx_dshtgn);
      S_POSS_ATK2:  sfx := Ord(sfx_pistol);
      S_SPOS_ATK2:  sfx := Ord(sfx_shotgn);
      S_VILE_ATK2:  sfx := Ord(sfx_vilatk);
      S_SKEL_FIST2: sfx := Ord(sfx_skeswg);
      S_SKEL_FIST4: sfx := Ord(sfx_skepch);
      S_SKEL_MISS2: sfx := Ord(sfx_skeatk);
      S_FATT_ATK8,
      S_FATT_ATK5,
      S_FATT_ATK2:  sfx := Ord(sfx_firsht);
      S_CPOS_ATK2,
      S_CPOS_ATK3,
      S_CPOS_ATK4:  sfx := Ord(sfx_shotgn);
      S_TROO_ATK3:  sfx := Ord(sfx_claw);
      S_SARG_ATK2:  sfx := Ord(sfx_sgtatk);
      S_BOSS_ATK2,
      S_BOS2_ATK2,
      S_HEAD_ATK2:  sfx := Ord(sfx_firsht);
      S_SKULL_ATK2: sfx := Ord(sfx_sklatk);
      S_SPID_ATK2,
      S_SPID_ATK3:  sfx := Ord(sfx_shotgn);
      S_BSPI_ATK2:  sfx := Ord(sfx_plasma);
      S_CYBER_ATK2,
      S_CYBER_ATK4,
      S_CYBER_ATK6: sfx := Ord(sfx_rlaunc);
      S_PAIN_ATK3:  sfx := Ord(sfx_sklatk);
    else
      sfx := 0;
    end;
    if sfx <> 0 then
      S_StartSound(nil, sfx);
  end;

  if castframes = 12 then
  begin
    // go into attack frame
    castattacking := true;
    if castonmelee <> 0 then
      caststate := @states[mobjinfo[Ord(castorder[castnum]._type)].meleestate]
    else
      caststate := @states[mobjinfo[Ord(castorder[castnum]._type)].missilestate];
    castonmelee := castonmelee xor 1;
    if caststate = @states[Ord(S_NULL)] then
    begin
      if castonmelee <> 0 then
        caststate := @states[mobjinfo[Ord(castorder[castnum]._type)].meleestate]
      else
        caststate := @states[mobjinfo[Ord(castorder[castnum]._type)].missilestate];
    end;
  end;

  if castattacking then
  begin
    if (castframes = 24) or
       (caststate = @states[mobjinfo[Ord(castorder[castnum]._type)].seestate]) then
    begin
      castattacking := false;
      castframes := 0;
      caststate := @states[mobjinfo[Ord(castorder[castnum]._type)].seestate];
    end;
  end;

  casttics := caststate.tics;
  if casttics = -1 then
    casttics := 15;
end;

//
// F_CastResponder
//
function F_CastResponder(ev: Pevent_t): boolean;
begin
  if ev._type <> ev_keydown then
  begin
    result := false;
    exit;
  end;

  if castdeath then
  begin
    result := true; // already in dying frames
    exit;
  end;

  // go into death frame
  castdeath := true;
  caststate := @states[mobjinfo[Ord(castorder[castnum]._type)].deathstate];
  casttics := caststate.tics;
  castframes := 0;
  castattacking := false;
  if mobjinfo[Ord(castorder[castnum]._type)].deathsound <> 0 then
    S_StartSound(nil, mobjinfo[Ord(castorder[castnum]._type)].deathsound);

  result := true;
end;

//
// F_DrawPatchCol
//
procedure F_DrawPatchCol(x: integer; patch: Ppatch_t; col: integer);
var
  column: Pcolumn_t;
  source: PByte;
  dest: PByte;
  desttop: PByte;
  count: integer;
begin
  column := Pcolumn_t(integer(patch) + patch.columnofs[col]);
  desttop := PByte(integer(screens[SCN_TMP]) + x);

  // step through the posts in a column
  while column.topdelta <> $ff do
  begin
    source := PByte(integer(column) + 3);
    dest := PByte(integer(desttop) + column.topdelta * 320);
    count := column.length;

    while count > 0 do
    begin
      dest^ := source^;
      inc(source);
      inc(dest, 320);
      dec(count);
    end;
    column := Pcolumn_t(integer(column) + column.length + 4);
  end;
end;

//
// F_BunnyScroll
//
var
  laststage: integer;

procedure F_BunnyScroll;
var
  scrolled: integer;
  x: integer;
  p1: Ppatch_t;
  p2: Ppatch_t;
  name: string;
  stage: integer;
begin
  p1 := W_CacheLumpName('PFUB2', PU_LEVEL);
  p2 := W_CacheLumpName('PFUB1', PU_LEVEL);

  scrolled := 320 - (finalecount - 230) div 2;
  if scrolled > 320 then
    scrolled := 320
  else if scrolled < 0 then
    scrolled := 0;

  for x := 0 to 320 - 1 do
  begin
    if x + scrolled < 320 then
      F_DrawPatchCol(x, p1, x + scrolled)
    else
      F_DrawPatchCol(x, p2, x + scrolled - 320);
  end;

  if finalecount >= 1130 then
  begin
    if finalecount < 1180 then
    begin
      V_DrawPatch((320 - 13 * 8) div 2,
                  (200 - 8 * 8) div 2,
                   SCN_TMP, 'END0', false);
      laststage := 0;
    end
    else
    begin
      stage := (finalecount - 1180) div 5;
      if stage > 6 then
        stage := 6;
      if stage > laststage then
      begin
        S_StartSound(nil, Ord(sfx_pistol));
        laststage := stage;
      end;

      sprintf(name,'END%d', [stage]);
      V_DrawPatch((320 - 13 * 8) div 2,
                  (200 - 8 * 8) div 2,
                   SCN_TMP, name, false);
    end;
  end;

  V_CopyRect(0, 0, SCN_TMP, 320, 200, 0, 0, SCN_FG, true);
end;

//
// F_Drawer
//
procedure F_Drawer;
begin
  V_PageDrawer(finaletext);
end;

initialization
  castorder[0].name := CC_ZOMBIE;
  castorder[0]._type := MT_POSSESSED;

  castorder[1].name := CC_SHOTGUN;
  castorder[1]._type := MT_SHOTGUY;

  castorder[2].name := CC_HEAVY;
  castorder[2]._type := MT_CHAINGUY;

  castorder[3].name := CC_IMP;
  castorder[3]._type := MT_TROOP;

  castorder[4].name := CC_DEMON;
  castorder[4]._type := MT_SERGEANT;

  castorder[5].name := CC_LOST;
  castorder[5]._type := MT_SKULL;

  castorder[6].name := CC_CACO;
  castorder[6]._type := MT_HEAD;

  castorder[7].name := CC_HELL;
  castorder[7]._type := MT_KNIGHT;

  castorder[8].name := CC_BARON;
  castorder[8]._type := MT_BRUISER;

  castorder[9].name := CC_ARACH;
  castorder[9]._type := MT_BABY;

  castorder[10].name := CC_PAIN;
  castorder[10]._type := MT_PAIN;

  castorder[11].name := CC_REVEN;
  castorder[11]._type := MT_UNDEAD;

  castorder[12].name := CC_MANCU;
  castorder[12]._type := MT_FATSO;

  castorder[13].name := CC_ARCH;
  castorder[13]._type := MT_VILE;

  castorder[14].name := CC_SPIDER;
  castorder[14]._type := MT_SPIDER;

  castorder[15].name := CC_CYBER;
  castorder[15]._type := MT_CYBORG;

  castorder[16].name := CC_HERO;
  castorder[16]._type := MT_PLAYER;

  castorder[17].name := '';
  castorder[17]._type := mobjtype_t(0);


  laststage := 0;

end.

