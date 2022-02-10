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

unit st_stuff;

interface

uses
  gamedef,
  d_event;

// Size of statusbar.
// Now sensitive for scaling.
const
  ST_HEIGHT = 32;
  ST_WIDTH = 320;
  ST_Y = 200 - ST_HEIGHT;

type
  stdrawoptions_t = (stdo_no, stdo_small, stdo_full);

//==============================================================================
// ST_Responder
//
// STATUS BAR
//
// Called by main loop.
//
//==============================================================================
function ST_Responder(ev: Pevent_t): boolean;

//==============================================================================
// ST_Ticker
//
// Called by main loop.
//
//==============================================================================
procedure ST_Ticker;

//==============================================================================
// ST_Drawer
//
// Called by main loop.
//
//==============================================================================
procedure ST_Drawer(dopt: stdrawoptions_t; refresh: boolean);

//==============================================================================
// ST_Start
//
// Called when the console player is spawned on each level.
//
//==============================================================================
procedure ST_Start;

//==============================================================================
// ST_Init
//
// Called by startup code.
//
//==============================================================================
procedure ST_Init;

// States for status bar code.
type
  st_stateenum_t = (
    st_automapstate,
    st_firstpersonstate
  );

// States for the chat code.
  st_chatstateenum_t = (
    StartChatState,
    WaitDestState,
    GetChatState
  );

implementation

uses
  d_delphi,
  tables,
  c_cmds,
  d_items,
  i_system,
  z_zone,
  w_wad,
  info,
  info_h,
  gl_main,
  gl_render,
  g_game,
  p_local,
  p_inter,
  p_setup,
  p_enemy,
  d_player,
  r_defs,
  r_main,
  r_draw,
  r_hires,
  m_cheat,
  m_rnd,
  m_fixed,
  s_sound,
// Needs access to LFB.
  v_data,
  v_video,
// Data.
  dstrings,
  d_englsh,
  sounds,
// for mapnames
  hu_stuff;

//
// STATUS BAR DATA
//

const
// Palette indices.
// For damage/bonus red-/gold-shifts
  STARTREDPALS = 1;
  STARTBONUSPALS = 9;
  NUMREDPALS = 8;
  NUMBONUSPALS = 4;
// Radiation suit, green shift.
  RADIATIONPAL = 13;

// N/256*100% probability
//  that the normal face state will change
  ST_FACEPROBABILITY = 96;

// For Responder
  ST_TOGGLECHAT = KEY_ENTER;

// Location of status bar
  ST_X = 0;
  ST_X2 = 104;

  ST_FX = 143;
  ST_FY = ST_Y + 1; // JVAL was 169;

// Number of status faces.
  ST_NUMPAINFACES = 5;
  ST_NUMSTRAIGHTFACES = 3;
  ST_NUMTURNFACES = 2;
  ST_NUMSPECIALFACES = 3;

  ST_FACESTRIDE = ST_NUMSTRAIGHTFACES + ST_NUMTURNFACES + ST_NUMSPECIALFACES;

  ST_NUMEXTRAFACES = 2;

  ST_NUMFACES = ST_FACESTRIDE * ST_NUMPAINFACES + ST_NUMEXTRAFACES;

  ST_TURNOFFSET = ST_NUMSTRAIGHTFACES;
  ST_OUCHOFFSET = ST_TURNOFFSET + ST_NUMTURNFACES;
  ST_EVILGRINOFFSET = ST_OUCHOFFSET + 1;
  ST_RAMPAGEOFFSET = ST_EVILGRINOFFSET + 1;
  ST_GODFACE = ST_NUMPAINFACES * ST_FACESTRIDE;
  ST_DEADFACE = ST_GODFACE + 1;

  ST_FACESX = 143;
  ST_FACESY = ST_Y; // JVAL was 168;

  ST_EVILGRINCOUNT = 2 * TICRATE;
  ST_STRAIGHTFACECOUNT = TICRATE div 2;
  ST_TURNCOUNT = 1 * TICRATE;
  ST_OUCHCOUNT = 1 * TICRATE;
  ST_RAMPAGEDELAY = 2 * TICRATE;

  ST_MUCHPAIN = 20;

// Location and size of statistics,
//  justified according to widget type.
// Problem is, within which space? STbar? Screen?
// Note: this could be read in by a lump.
//       Problem is, is the stuff rendered
//       into a buffer,
//       or into the frame buffer?

// AMMO number pos.
  ST_AMMOWIDTH = 3;
  ST_AMMOX = 44;
  ST_AMMOY = ST_Y + 3; // JVAL was 171;

// HEALTH number pos.
  ST_HEALTHWIDTH = 3;
  ST_HEALTHX = 90;
  ST_HEALTHY = ST_Y + 3; // JVAL was 171;

// Weapon pos.
  ST_ARMSX = 111;
  ST_ARMSY = ST_Y + 4; // JVAL was 172;
  ST_ARMSBGX = 104;
  ST_ARMSBGY = ST_Y; // JVAL was 168;
  ST_ARMSXSPACE = 12;
  ST_ARMSYSPACE = 10;

// Frags pos.
  ST_FRAGSX = 138;
  ST_FRAGSY = ST_Y + 3; // JVAL was 171;
  ST_FRAGSWIDTH = 2;

// ARMOR number pos.
  ST_ARMORWIDTH = 3;
  ST_ARMORX = 221;
  ST_ARMORY = ST_Y + 3; // JVAL was 171;

// Key icon positions.
  ST_KEY0WIDTH = 8;
  ST_KEY0HEIGHT = 5;
  ST_KEY0X = 239;
  ST_KEY0Y = ST_Y + 3; // JVAL was 171;
  ST_KEY1WIDTH = ST_KEY0WIDTH;
  ST_KEY1X = 239;
  ST_KEY1Y = ST_Y + 13; // JVAL was 181;
  ST_KEY2WIDTH = ST_KEY0WIDTH;
  ST_KEY2X = 239;
  ST_KEY2Y = ST_Y + 23; // JVAL was 191;

// Ammunition counter.
  ST_AMMO0WIDTH = 3;
  ST_AMMO0HEIGHT = 6;
  ST_AMMO0X = 288;
  ST_AMMO0Y = ST_Y + 5; // JVAL was 173;
  ST_AMMO1WIDTH = ST_AMMO0WIDTH;
  ST_AMMO1X = 288;
  ST_AMMO1Y = ST_Y + 11; // JVAL was 179;
  ST_AMMO2WIDTH = ST_AMMO0WIDTH;
  ST_AMMO2X = 288;
  ST_AMMO2Y = ST_Y + 23; // JVAL was 191;
  ST_AMMO3WIDTH = ST_AMMO0WIDTH;
  ST_AMMO3X = 288;
  ST_AMMO3Y = ST_Y + 17; // JVAL was 185;

// Indicate maximum ammunition.
// Only needed because backpack exists.
  ST_MAXAMMO0WIDTH = 3;
  ST_MAXAMMO0HEIGHT = 5;
  ST_MAXAMMO0X = 314;
  ST_MAXAMMO0Y = ST_Y + 5; // JVAL was 173;
  ST_MAXAMMO1WIDTH = ST_MAXAMMO0WIDTH;
  ST_MAXAMMO1X = 314;
  ST_MAXAMMO1Y = ST_Y + 11; // JVAL was 179;
  ST_MAXAMMO2WIDTH = ST_MAXAMMO0WIDTH;
  ST_MAXAMMO2X = 314;
  ST_MAXAMMO2Y = ST_Y + 23; // JVAL was 191;
  ST_MAXAMMO3WIDTH = ST_MAXAMMO0WIDTH;
  ST_MAXAMMO3X = 314;
  ST_MAXAMMO3Y = ST_Y + 17; // JVAL was 185;

// pistol
  ST_WEAPON0X = 110;
  ST_WEAPON0Y = ST_Y + 4; // JVAL was 172;

// shotgun
  ST_WEAPON1X = 122;
  ST_WEAPON1Y = ST_Y + 4; // JVAL was 172;

// chain gun
  ST_WEAPON2X = 134;
  ST_WEAPON2Y = ST_Y + 4; // JVAL was 172;

// missile launcher
  ST_WEAPON3X = 110;
  ST_WEAPON3Y = ST_Y + 13; // JVAL was 181;

// plasma gun
  ST_WEAPON4X = 122;
  ST_WEAPON4Y = ST_Y + 13; // JVAL was 181;

 // bfg
  ST_WEAPON5X = 134;
  ST_WEAPON5Y = ST_Y + 13; // JVAL was 181;

// WPNS title
  ST_WPNSX = 109;
  ST_WPNSY = ST_Y + 23; // JVAL was 191;

 // DETH title
  ST_DETHX = 109;
  ST_DETHY = ST_Y + 23; // JVAL was 191;

//Incoming messages window location
//UNUSED
//   ST_MSGTEXTX     (viewwindowx)
//   ST_MSGTEXTY     (viewwindowy+viewheight-18)
  ST_MSGTEXTX = 0;
  ST_MSGTEXTY = 0;
// Dimensions given in characters.
  ST_MSGWIDTH = 52;
// Or shall I say, in lines?
  ST_MSGHEIGHT = 1;

  ST_OUTTEXTX = 0;
  ST_OUTTEXTY = 6;

// Width, in characters again.
  ST_OUTWIDTH = 52;
 // Height, in lines.
  ST_OUTHEIGHT = 1;

  ST_MAPTITLEY = 0;
  ST_MAPHEIGHT = 1;

// Minimum (small display constants)
// Location of medikit
  ST_MX = 8;
  ST_MY = 29;
// Location of healt percentage
  ST_MHEALTHX = 60;
  ST_MHEALTHY = ST_Y + 14;
// Location of ammo number
  ST_MAMMOX = 298;
  ST_MAMMOY = ST_Y + 14;
  ST_MAMMOWIDTH = 3;
// Location of ammo patch
  ST_MWX = 308;
  ST_MWY = 29;

var
  st_palette: integer;

var

// main player in game
  plyr: Pplayer_t;

// ST_Start() has just been called
  st_firsttime: boolean;

// lump number for PLAYPAL
  lu_palette: integer;

// used for timing
  st_clock: LongWord;

// used for making messages go away
  st_msgcounter: integer;

// used when in chat
  st_chatstate: st_chatstateenum_t;

// whether in automap or first-person
  st_gamestate: st_stateenum_t;

// whether left-side main status bar is active
  st_statusbaron: boolean;

// whether status bar chat is active
  st_chat: boolean;

// value of st_chat before message popped up
  st_oldchat: boolean;

// whether chat window has the cursor on
  st_cursoron: boolean;

// used to use appopriately pained face
  st_oldhealth: integer;

// used for evil grin
  oldweaponsowned: array[0..Ord(NUMWEAPONS) - 1] of integer;

 // count until face changes
  st_facecount: integer;

// current face index, used by w_faces
  st_faceindex: integer;

// holds key-type for each key box on bar
  keyboxes: array[0..2] of integer;

// a random number per tick
  st_randomnumber: integer;

const
// Massive bunches of cheat shit
//  to keep it from being easy to figure them out.
// Yeah, right...
  cheat_mus_seq: array[0..8] of char = (
    Chr($66), Chr($26), Chr($b6), Chr($ae), Chr($ea),
    Chr($1),  Chr($0),  Chr($0),  Chr($ff)
  ); // fdmus

  cheat_choppers_seq: array[0..10] of char = (
    Chr($66), Chr($26), Chr($e2), Chr($32), Chr($f6),
    Chr($2a), Chr($2a), Chr($a6), Chr($6a), Chr($ea),
    Chr($ff) // fd...
  );

  cheat_god_seq: array[0..5] of char = (
    Chr($66), Chr($26), Chr($26), Chr($aa), Chr($26),
    Chr($ff)  // fddqd
  );

  cheat_ammo_seq: array[0..5] of char = (
    Chr($66), Chr($26), Chr($f2), Chr($66), Chr($a2),
    Chr($ff)  // fdkfa
  );

  cheat_ammonokey_seq: array[0..4] of char = (
    Chr($66), Chr($26), Chr($66), Chr($a2), Chr($ff) // fdfa
  );

// Smashing Pumpkins Into Samml Piles Of Putried Debris.
  cheat_noclip_seq: array[0..10] of char = (
    Chr($66), Chr($26), Chr($ea), Chr($2a), Chr($b2), // fdspispopd
    Chr($ea), Chr($2a), Chr($f6), Chr($2a), Chr($26),
    Chr($ff)
  );

//
  cheat_commercial_noclip_seq: array[0..6] of char = (
    Chr($66), Chr($26), Chr($e2), Chr($36), Chr($b2),
    Chr($2a), Chr($ff)  // idclip
  );

  cheat_powerup_seq0: array[0..9] of char = (
    Chr($66), Chr($26), Chr($62), Chr($a6), Chr($32),
    Chr($f6), Chr($36), Chr($26), Chr($6e), Chr($ff)  // fdbeholdv
  );

  cheat_powerup_seq1: array[0..9] of char = (
    Chr($66), Chr($26), Chr($62), Chr($a6), Chr($32),
    Chr($f6), Chr($36), Chr($26), Chr($ea), Chr($ff)  // fdbeholds
  );

  cheat_powerup_seq2: array[0..9] of char = (
    Chr($66), Chr($26), Chr($62), Chr($a6), Chr($32),
    Chr($f6), Chr($36), Chr($26), Chr($b2), Chr($ff)  // fdbeholdi
  );

  cheat_powerup_seq3: array[0..9] of char = (
    Chr($66), Chr($26), Chr($62), Chr($a6), Chr($32),
    Chr($f6), Chr($36), Chr($26), Chr($6a), Chr($ff)  // fdbeholdr
  );

  cheat_powerup_seq4: array[0..9] of char = (
    Chr($66), Chr($26), Chr($62), Chr($a6), Chr($32),
    Chr($f6), Chr($36), Chr($26), Chr($a2), Chr($ff)  // fdbeholda
  );

  cheat_powerup_seq5: array[0..9] of char = (
    Chr($66), Chr($26), Chr($62), Chr($a6), Chr($32),
    Chr($f6), Chr($36), Chr($26), Chr($36), Chr($ff)  // fdbeholdl
  );

  cheat_powerup_seq6: array[0..8] of char = (
    Chr($66), Chr($26), Chr($62), Chr($a6), Chr($32),
    Chr($f6), Chr($36), Chr($26), Chr($ff)  // fdbehold
  );

  cheat_clev_seq: array[0..9] of char = (
    Chr($66), Chr($26), Chr($e2), Chr($36), Chr($a6),
    Chr($6e), Chr($1),  Chr($0),  Chr($0),  Chr($ff)  // idclev
  );

// JVAL: Give All Keys cheat
  cheat_idkeys_seq: array[0..6] of char = (
    Chr($66), Chr($26), Chr($f2), Chr($a6), Chr($ba),
    Chr($ea), Chr($ff) // idkeys
  );

var
// Now what?
  cheat_mus: cheatseq_t;
  cheat_god: cheatseq_t;
  cheat_ammo: cheatseq_t;
  cheat_ammonokey: cheatseq_t;
  cheat_keys: cheatseq_t;
  cheat_noclip: cheatseq_t;
  cheat_commercial_noclip: cheatseq_t;

  cheat_powerup: array[0..6] of cheatseq_t;

  cheat_choppers: cheatseq_t;
  cheat_clev: cheatseq_t;

//==============================================================================
// ST_CmdCheckPlayerStatus
//
// Commands
//
//==============================================================================
function ST_CmdCheckPlayerStatus: boolean;
begin
  if (plyr = nil) or (plyr.mo = nil) or (gamestate <> GS_LEVEL) or demoplayback or netgame then
  begin
    printf('You can''t specify the command at this time.'#13#10);
    result := false;
  end
  else
    result := true;
end;

//==============================================================================
//
// ST_CmdGod
//
//==============================================================================
procedure ST_CmdGod;
begin
  if not ST_CmdCheckPlayerStatus then
    exit;

  if plyr.playerstate <> PST_DEAD then
  begin
    plyr.cheats := plyr.cheats xor CF_GODMODE;
    if plyr.cheats and CF_GODMODE <> 0 then
    begin
      if plyr.mo <> nil then
        plyr.mo.health := mobjinfo[Ord(MT_PLAYER)].spawnhealth;

      plyr.health := mobjinfo[Ord(MT_PLAYER)].spawnhealth;
    end
    else
  end
  else
  begin
    C_ExecuteCmd('closeconsole');
    plyr.playerstate := PST_REBORN;
  end;
end;

//==============================================================================
//
// ST_CmdMassacre
//
//==============================================================================
procedure ST_CmdMassacre;
begin
  if not ST_CmdCheckPlayerStatus then
    exit;

  if (gamestate = GS_LEVEL) and (plyr.mo <> nil) then
    P_Massacre;
end;

//==============================================================================
//
// ST_CmdLowGravity
//
//==============================================================================
procedure ST_CmdLowGravity;
begin
  if not ST_CmdCheckPlayerStatus then
    exit;

  plyr.cheats := plyr.cheats xor CF_LOWGRAVITY;
end;

//==============================================================================
//
// ST_CmdIDFA
//
//==============================================================================
procedure ST_CmdIDFA;
var
  i: integer;
begin
  if not ST_CmdCheckPlayerStatus then
    exit;

  plyr.armorpoints := 200;
  plyr.armortype := 2;

  if gamemode = shareware then
  begin
    for i := 0 to Ord(wp_missile) do
      plyr.weaponowned[i] := 1;

    for i := 0 to Ord(NUMAMMO) - 1 do
      if i <> Ord(am_cell) then
        plyr.ammo[i] := plyr.maxammo[i];
  end
  else
  begin
    for i := 0 to Ord(NUMWEAPONS) - 1 do
      plyr.weaponowned[i] := 1;

    for i := 0 to Ord(NUMAMMO) - 1 do
      plyr.ammo[i] := plyr.maxammo[i];
  end;
end;

//==============================================================================
//
// ST_CmdIDKFA
//
//==============================================================================
procedure ST_CmdIDKFA;
var
  i: integer;
begin
  if not ST_CmdCheckPlayerStatus then
    exit;

  plyr.armorpoints := 200;
  plyr.armortype := 2;

  if gamemode = shareware then
  begin
    for i := 0 to Ord(wp_missile) - 1 do
      plyr.weaponowned[i] := 1;

    for i := 0 to Ord(NUMAMMO) - 1 do
      if i <> Ord(am_cell) then
        plyr.ammo[i] := plyr.maxammo[i];
  end
  else
  begin
    for i := 0 to Ord(NUMWEAPONS) - 1 do
      plyr.weaponowned[i] := 1;

    for i := 0 to Ord(NUMAMMO) - 1 do
      plyr.ammo[i] := plyr.maxammo[i];
  end;

  for i := 0 to Ord(NUMCARDS) - 1 do
    plyr.cards[i] := true;
end;

//==============================================================================
//
// ST_CmdIDKEYS
//
//==============================================================================
procedure ST_CmdIDKEYS;
var
  i: integer;
begin
  if not ST_CmdCheckPlayerStatus then
    exit;

  for i := 0 to Ord(NUMCARDS) - 1 do
    plyr.cards[i] := true;
end;

//==============================================================================
//
// ST_CmdIDNoClip
//
//==============================================================================
procedure ST_CmdIDNoClip;
begin
  if not ST_CmdCheckPlayerStatus then
    exit;

  plyr.cheats := plyr.cheats xor CF_NOCLIP;

end;

//==============================================================================
// ST_Responder
//
// Respond to keyboard input events,
//  intercept cheats.
//
//==============================================================================
function ST_Responder(ev: Pevent_t): boolean;
var
  i: integer;
  buf: string;
  musnum: integer;
  epsd: integer;
  map: integer;
  ateit: boolean; // JVAL Cheats ate the event

  function check_cheat(cht: Pcheatseq_t; key: char): boolean;
  var
    cht_ret: cheatstatus_t;
  begin
    cht_ret := cht_CheckCheat(cht, key);
    result := cht_ret = cht_acquired;
    if not ateit then
      ateit := (cht_ret in [cht_pending, cht_acquired])
  end;

begin
  result := false;
  ateit := false;
  if ev._type = ev_keydown then
  begin
    if not netgame then
    begin
      // b. - enabled for more debug fun.
      // if (gameskill != sk_nightmare) {

      // 'fddqd' cheat for toggleable god mode
      if check_cheat(@cheat_god, Chr(ev.data1)) then
      begin
        ST_CmdGod;
      end
      // 'fdfa' cheat for killer fucking arsenal
      else if check_cheat(@cheat_ammonokey, Chr(ev.data1)) then
      begin
        ST_CmdIDFA;
      end
      // JVAL: 'fdkeys' cheat
      else if check_cheat(@cheat_keys, Chr(ev.data1)) then
      begin
        ST_CmdIDKEYS;
      end
      // 'fdkfa' cheat for key full ammo
      else if check_cheat(@cheat_ammo, Chr(ev.data1)) then
      begin
        ST_CmdIDKFA;
      end
      // 'fdmus' cheat for changing music
      else if check_cheat(@cheat_mus, Chr(ev.data1)) then
      begin
        cht_GetParam(@cheat_mus, buf);

        if gamemode = commercial then
        begin
          musnum := Ord(mus_runnin) + (Ord(buf[1]) - Ord('0')) * 10 + Ord(buf[2]) - Ord('0') - 1;

          if (Ord(buf[1]) - Ord('0')) * 10 + Ord(buf[2]) - Ord('0') > 35 then
          else
            S_ChangeMusic(musnum, true);
        end
        else
        begin
          musnum := Ord(mus_e1m1) + (Ord(buf[1]) - Ord('1')) * 9 + Ord(buf[2]) - Ord('1');

          if (musnum > 0) and (buf[2] <> '0') and
             ( ((musnum < 28) and (gamemode <> shareware)) or
               ((musnum < 10) and (gamemode = shareware))) then
            S_ChangeMusic(musnum, true)
        end;
      end
      // Simplified, accepting both "noclip" and "fdspispopd".
      // no clipping mode cheat
      else if check_cheat(@cheat_noclip, Chr(ev.data1)) or
              check_cheat(@cheat_commercial_noclip, Chr(ev.data1)) then
      begin
        ST_CmdIDNoClip;
      end;
      // 'fdbehold?' power-up cheats
      for i := 0 to 5 do
      begin
        if check_cheat(@cheat_powerup[i], Chr(ev.data1)) then
        begin
          if plyr.powers[i] = 0 then
            P_GivePower(plyr, i)
          else if i <> Ord(pw_strength) then
            plyr.powers[i] := 1
          else
            plyr.powers[i] := 0;

        end;
      end;

      // 'fdbehold' power-up menu
      if check_cheat(@cheat_powerup[6], Chr(ev.data1)) then
      begin
      end
      // 'fdchoppers' invulnerability & chainsaw
      else if check_cheat(@cheat_choppers, Chr(ev.data1)) then
      begin
        plyr.weaponowned[Ord(wp_chainsaw)] := 1;
        plyr.powers[Ord(pw_invulnerability)] := INVULNTICS;
      end;
    end;

    // 'fdclev' change-level cheat
    if check_cheat(@cheat_clev, Chr(ev.data1)) then
    begin
      cht_GetParam(@cheat_clev, buf);

      if gamemode = commercial then
      begin
        epsd := 0;
        map := (Ord(buf[1]) - Ord('0')) * 10 + Ord(buf[2]) - Ord('0');
      end
      else
      begin
        epsd := Ord(buf[1]) - Ord('0');
        map := Ord(buf[2]) - Ord('0');
        // Catch invalid maps.
        if epsd < 1 then
          exit;
      end;

      if map < 1 then
        exit;

      // Ohmygod - this is not going to work.
      if (gamemode = retail) and
         ((epsd > 4) or (map > 9)) then
        exit;

      if (gamemode = registered) and
         ((epsd > 3) or (map > 9)) then
        exit;

      if (gamemode = shareware) and
         ((epsd > 1) or (map > 9)) then
        exit;

      if (gamemode = commercial) and
         ((epsd > 1) or (map > 34)) then
        exit;

      // So be it.
      if W_CheckNumForName(P_GetMapName(epsd, map)) > -1 then
      begin
        G_DeferedInitNew(gameskill, epsd, map);
      end;
    end;
  end;
  result := result or ateit;
end;

//==============================================================================
//
// ST_Ticker
//
//==============================================================================
procedure ST_Ticker;
begin
  inc(st_clock);
  st_randomnumber := M_Random;
  st_oldhealth := plyr.health;
end;

//==============================================================================
//
// ST_doPaletteStuff
//
//==============================================================================
procedure ST_doPaletteStuff;
var
  palette: integer;
  pal: PByteArray;
  cnt: integer;
  bzc: integer;
  p: pointer;
begin
  if plyr = nil then
    exit;

  cnt := plyr.damagecount;

  if plyr.powers[Ord(pw_strength)] <> 0 then
  begin
    // slowly fade the berzerk out
    bzc := 12 - _SHR(plyr.powers[Ord(pw_strength)], 6);

    if bzc > cnt then
      cnt := bzc;
  end;

  if cnt <> 0 then
  begin
    palette := _SHR(cnt + 7, 3);

    if palette >= NUMREDPALS then
      palette := NUMREDPALS - 1;

    palette := palette + STARTREDPALS;
  end
  else if plyr.bonuscount <> 0 then
  begin
    palette := _SHR(plyr.bonuscount + 7, 3);

    if palette >= NUMBONUSPALS then
      palette := NUMBONUSPALS - 1;

    palette := palette + STARTBONUSPALS;
  end
  else if (plyr.powers[Ord(pw_ironfeet)] > 4 * 32) or
          (plyr.powers[Ord(pw_ironfeet)] and 8 <> 0) then
    palette := RADIATIONPAL
  else
    palette := 0;

  if palette <> st_palette then
  begin
    st_palette := palette;
    gld_SetPalette(palette);
    p := W_CacheLumpNum(lu_palette, PU_STATIC);
    pal := PByteArray(integer(p) + palette * 768);
    I_SetPalette(pal);
    V_SetPalette(pal);
    Z_ChangeTag(p, PU_CACHE);
  end;
end;

//==============================================================================
//
// ST_Drawer
//
//==============================================================================
procedure ST_Drawer(dopt: stdrawoptions_t; refresh: boolean);
begin
  ST_doPaletteStuff;
end;

//==============================================================================
//
// ST_loadData
//
//==============================================================================
procedure ST_loadData;
begin
  lu_palette := W_GetNumForName(PLAYPAL);
end;

//==============================================================================
//
// ST_InitData
//
//==============================================================================
procedure ST_InitData;
var
  i: integer;
begin
  st_firsttime := true;
  plyr := @players[consoleplayer];

  st_clock := 0;
  st_chatstate := StartChatState;
  st_gamestate := st_firstpersonstate;

  st_statusbaron := true;
  st_oldchat := false;
  st_chat := false;
  st_cursoron := false;

  st_faceindex := 0;
  st_palette := -1;

  st_oldhealth := -1;

  for i := 0 to Ord(NUMWEAPONS) - 1 do
    oldweaponsowned[i] := plyr.weaponowned[i];

  for i := 0 to 2 do
    keyboxes[i] := -1;

end;

var
  st_stopped: boolean;

//==============================================================================
//
// ST_Stop
//
//==============================================================================
procedure ST_Stop;
var
  pal: PByteArray;
begin
  if st_stopped then
    exit;

  pal := PByteArray(W_CacheLumpNum(lu_palette, PU_STATIC));
  I_SetPalette(pal);
  V_SetPalette(pal);
  Z_ChangeTag(pal, PU_CACHE);

  st_stopped := true;
end;

//==============================================================================
//
// ST_Start
//
//==============================================================================
procedure ST_Start;
begin
  if not st_stopped then
    ST_Stop;

  ST_InitData;
  st_stopped := false;
end;

//==============================================================================
//
// ST_Init
//
//==============================================================================
procedure ST_Init;
begin
////////////////////////////////////////////////////////////////////////////////
  st_msgcounter := 0;
  st_oldhealth := -1;
  st_facecount := 0;
  st_faceindex := 0;

////////////////////////////////////////////////////////////////////////////////
// Now what?
  cheat_mus.sequence := get_cheatseq_string(cheat_mus_seq);
  cheat_mus.p := get_cheatseq_string(0);
  cheat_god.sequence := get_cheatseq_string(cheat_god_seq);
  cheat_god.p := get_cheatseq_string(0);
  cheat_ammo.sequence := get_cheatseq_string(cheat_ammo_seq);
  cheat_ammo.p := get_cheatseq_string(0);
  cheat_ammonokey.sequence := get_cheatseq_string(cheat_ammonokey_seq);
  cheat_ammonokey.p := get_cheatseq_string(0);
  cheat_keys.sequence := get_cheatseq_string(cheat_idkeys_seq);
  cheat_keys.p := get_cheatseq_string(0);
  cheat_noclip.sequence := get_cheatseq_string(cheat_noclip_seq);
  cheat_noclip.p := get_cheatseq_string(0);
  cheat_commercial_noclip.sequence := get_cheatseq_string(cheat_commercial_noclip_seq);
  cheat_commercial_noclip.p := get_cheatseq_string(0);

  cheat_powerup[0].sequence := get_cheatseq_string(cheat_powerup_seq0);
  cheat_powerup[0].p := get_cheatseq_string(0);
  cheat_powerup[1].sequence := get_cheatseq_string(cheat_powerup_seq1);
  cheat_powerup[1].p := get_cheatseq_string(0);
  cheat_powerup[2].sequence := get_cheatseq_string(cheat_powerup_seq2);
  cheat_powerup[2].p := get_cheatseq_string(0);
  cheat_powerup[3].sequence := get_cheatseq_string(cheat_powerup_seq3);
  cheat_powerup[3].p := get_cheatseq_string(0);
  cheat_powerup[4].sequence := get_cheatseq_string(cheat_powerup_seq4);
  cheat_powerup[4].p := get_cheatseq_string(0);
  cheat_powerup[5].sequence := get_cheatseq_string(cheat_powerup_seq5);
  cheat_powerup[5].p := get_cheatseq_string(0);
  cheat_powerup[6].sequence := get_cheatseq_string(cheat_powerup_seq6);
  cheat_powerup[6].p := get_cheatseq_string(0);

  cheat_choppers.sequence := get_cheatseq_string(cheat_choppers_seq);
  cheat_choppers.p := get_cheatseq_string(0);
  cheat_clev.sequence := get_cheatseq_string(cheat_clev_seq);
  cheat_clev.p := get_cheatseq_string(0);

  st_palette := 0;

  st_stopped := true;
////////////////////////////////////////////////////////////////////////////////

  ST_loadData;
  C_AddCmd('god, iddqd', @ST_CmdGod);
  C_AddCmd('massacre', @ST_CmdMassacre);
  C_AddCmd('givefullammo, rambo, idfa', @ST_CmdIDFA);
  C_AddCmd('giveallkeys, idkeys', @ST_CmdIDKEYS);
  C_AddCmd('lowgravity', @ST_CmdLowGravity);
  C_AddCmd('givefullammoandkeys, idkfa', @ST_CmdIDKFA);
  C_AddCmd('idspispopd, idclip', @ST_CmdIDNoClip);
end;

end.

