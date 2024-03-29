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

unit g_game;

interface

uses
  gamedef,
  m_fixed,
  d_event,
  d_player,
  d_ticcmd;

//==============================================================================
//
// G_DeathMatchSpawnPlayer
//
//==============================================================================
procedure G_DeathMatchSpawnPlayer(playernum: integer);

//==============================================================================
//
// G_InitNew
//
//==============================================================================
procedure G_InitNew(skill: skill_t; episode: integer; map: integer);

//==============================================================================
// G_DeferedInitNew
//
// Can be called by the startup code or M_Responder.
// A normal game starts at map 1,
// but a warp test can start elsewhere
//
//==============================================================================
procedure G_DeferedInitNew(skill: skill_t; episode: integer; map: integer);

//==============================================================================
//
// G_CmdNewGame
//
//==============================================================================
procedure G_CmdNewGame(const parm1, parm2: string);

//==============================================================================
//
// G_DeferedPlayDemo
//
//==============================================================================
function G_DeferedPlayDemo(const name: string): boolean;

//==============================================================================
//
// G_CmdPlayDemo
//
//==============================================================================
procedure G_CmdPlayDemo(const name: string);

{ Can be called by the startup code or M_Responder, }
{ calls P_SetupLevel or W_EnterWorld. }

//==============================================================================
//
// G_LoadGame
//
//==============================================================================
procedure G_LoadGame(const name: string);

//==============================================================================
//
// G_DoLoadGame
//
//==============================================================================
procedure G_DoLoadGame;

{ Called by M_Responder. }

//==============================================================================
//
// G_SaveGame
//
//==============================================================================
procedure G_SaveGame(slot: integer; const description: string);

//==============================================================================
//
// G_CmdSaveGame
//
//==============================================================================
procedure G_CmdSaveGame(const sname: string; const description: string);

{ Only called by startup code. }

//==============================================================================
//
// G_RecordDemo
//
//==============================================================================
procedure G_RecordDemo(const name: string);

//==============================================================================
//
// G_BeginRecording
//
//==============================================================================
procedure G_BeginRecording;

//==============================================================================
//
// G_TimeDemo
//
//==============================================================================
procedure G_TimeDemo(const name: string);

//==============================================================================
//
// G_CheckDemoStatus
//
//==============================================================================
function G_CheckDemoStatus: boolean;

//==============================================================================
//
// G_ExitLevel
//
//==============================================================================
procedure G_ExitLevel;

//==============================================================================
//
// G_SecretExitLevel
//
//==============================================================================
procedure G_SecretExitLevel;

//==============================================================================
//
// G_WorldDone
//
//==============================================================================
procedure G_WorldDone;

//==============================================================================
//
// G_Ticker
//
//==============================================================================
procedure G_Ticker;

//==============================================================================
//
// G_Responder
//
//==============================================================================
function G_Responder(ev: Pevent_t): boolean;

//==============================================================================
//
// G_ScreenShot
//
//==============================================================================
procedure G_ScreenShot;

//==============================================================================
//
// G_IsOldDemoPlaying
//
//==============================================================================
function G_IsOldDemoPlaying: boolean;

//==============================================================================
//
// G_Quit
//
//==============================================================================
procedure G_Quit;

var
  sendpause: boolean;        // send a pause event next tic

  paused: boolean;

//
// controls (have defaults)
//
  key_right: integer;
  key_right2: integer;
  key_left: integer;
  key_left2: integer;

  key_up: integer;
  key_up2: integer;
  key_down: integer;
  key_down2: integer;

// JVAL Look Up and Down
  key_lookup: integer;
  key_lookup2: integer;
  key_lookdown: integer;
  key_lookdown2: integer;
  key_lookcenter: integer;
  key_lookcenter2: integer;
// JVAL Look Left and Right
  key_lookright: integer;
  key_lookright2: integer;
  key_lookleft: integer;
  key_lookleft2: integer;
  key_lookforward: integer;
  key_lookforward2: integer;

  key_strafeleft: integer;
  key_strafeleft2: integer;
  key_straferight: integer;
  key_straferight2: integer;
  key_fire: integer;
  key_fire2: integer;
  key_use: integer;
  key_use2: integer;
  key_strafe: integer;
  key_strafe2: integer;
  key_speed: integer;
  key_speed2: integer;
// JVAL Jump
  key_jump: integer;
  key_jump2: integer;

  usemouse: boolean;
  invertmouseturn: boolean;
  invertmouselook: boolean;
  mousebfire: integer;
  mousebjump: integer;
  mousebforward: integer;

  usejoystick: boolean;
  joybfire: integer;
  joybstrafe: integer;
  joybuse: integer;
  joybspeed: integer;
  joybjump: integer;
  joyblleft: integer;
  joyblright: integer;

  demoplayback: boolean;
  showdemoplaybackprogress: boolean;
  preparingdemoplayback: boolean = false;

  gameepisode: integer;
  gamemap: integer;

  deathmatch: integer; // only if started as net death
  netgame: boolean; // only true if packets are broadcast
  playeringame: array[0..MAXPLAYERS - 1] of boolean;

  consoleplayer: integer; // player taking events and displaying
  displayplayer: integer; // view being displayed
  gametic: integer;

  totalkills, totalitems, totalsecret: integer; // for intermission

  wminfo: wbstartstruct_t; // parms for world map / intermission

  gameskill: skill_t;

  bodyqueslot: integer;

  precache: boolean; // if true, load all graphics at start

  respawnmonsters: boolean;

  viewactive: boolean;

  singledemo: boolean; // quit after playing a demo from cmdline

  demorecording: boolean = false;

  gameaction: gameaction_t;

  usergame: boolean; // ok to save / end game

//==============================================================================
//
// G_SetKeyboardMode
//
//==============================================================================
procedure G_SetKeyboardMode;

//==============================================================================
//
// G_PlayerReborn
//
//==============================================================================
procedure G_PlayerReborn(player: integer);

//==============================================================================
//
// G_BuildTiccmd
//
//==============================================================================
procedure G_BuildTiccmd(cmd: Pticcmd_t);

var
  statcopy: pointer = nil;        // for statistics driver

var
  forwardmove: array[0..1] of shortint;
  sidemove: array[0..1] of shortint;
  angleturn: array[0..2] of smallint;

//==============================================================================
//
// G_NeedsCompatibilityMode
//
//==============================================================================
function G_NeedsCompatibilityMode: boolean;

var
  compatibilitymode: boolean = false;
  oldcompatibilitymode: boolean = false;

type
//
// LOAD GAME MENU
//
  load_e = (
    load1,
    load2,
    load3,
    load4,
    load5,
    load6,
    load7,
    load8,
    load_end
  );

var
  autorunmode: boolean = false;
  keepcheatsinplayerreborn: boolean = false;
  allowplayerjumps: boolean = true;
  majorbossdeathendsdoom1level: boolean = false;

//==============================================================================
//
// G_DoSaveGameInFile
//
//==============================================================================
procedure G_DoSaveGameInFile(name: string);

//==============================================================================
//
// G_DoLoadLevel
//
//==============================================================================
procedure G_DoLoadLevel;

//==============================================================================
//
// MAXPLMOVE
//
//==============================================================================
function MAXPLMOVE: fixed_t;

implementation

uses
  d_delphi,
  c_cmds,
  z_zone,
  p_journey,
  mapdata,
  d_net,
  d_net_h,
  d_main,
  f_finale,
  info_h,
  info,
  i_system,
  m_argv,
  m_misc,
  m_menu,
  m_rnd,
  p_setup,
  p_saveg,
  p_tick,
  p_local,
  p_mobj_h,
  p_mobj,
  p_inter,
  p_map,
  hu_stuff,
  st_stuff,
  w_wad,
  s_sound,
// Data.
  dstrings,
  sounds,
// SKY handling - still the wrong place.
  r_data,
  r_sky,
  r_defs,
  r_main,
  r_intrpl,
  tables;

const
  SAVEGAMESIZE = $800000; // Originally $2C000
  SAVESTRINGSIZE = 24;

//==============================================================================
//
// G_ReadDemoTiccmd
//
//==============================================================================
procedure G_ReadDemoTiccmd(cmd: Pticcmd_t); forward;

//==============================================================================
//
// G_WriteDemoTiccmd 
//
//==============================================================================
procedure G_WriteDemoTiccmd (cmd: Pticcmd_t); forward;

//==============================================================================
//
// G_DoReborn
//
//==============================================================================
procedure G_DoReborn(playernum: integer); forward;

//==============================================================================
//
// G_DoNewGame
//
//==============================================================================
procedure G_DoNewGame; forward;

//==============================================================================
//
// G_DoPlayDemo
//
//==============================================================================
procedure G_DoPlayDemo; forward;

//==============================================================================
//
// G_DoCompleted
//
//==============================================================================
procedure G_DoCompleted; forward;

//==============================================================================
//
// G_DoWorldDone
//
//==============================================================================
procedure G_DoWorldDone; forward;

//==============================================================================
//
// G_DoSaveGame
//
//==============================================================================
procedure G_DoSaveGame; forward;

//==============================================================================
//
// G_FinishedDemoPlayback
//
//==============================================================================
procedure G_FinishedDemoPlayback;
begin
//  demoplayback := false;
  // Restore old compatibility mode
  compatibilitymode := oldcompatibilitymode;
end;

var
  sendsave: boolean;         // send a save event next tic
  sendcmdsave: boolean;      // send a save event next tic (console)

  timingdemo: boolean;       // if true, exit with report on completion
  starttime: integer;        // for comparative timing purposes

  demoname: string;
  netdemo: boolean;
  demobuffer: PByteArray;
  demo_p: PByteArray;
  demoend: PByte;
  olddemo: boolean;

  consistency: array[0..MAXPLAYERS - 1] of array[0..BACKUPTICS - 1] of smallint;

  savebuffer: PByteArray;

const
  TURBOTHRESHOLD = $32;

//==============================================================================
//
// MAXPLMOVE
//
//==============================================================================
function MAXPLMOVE: fixed_t;
begin
  result := forwardmove[1];
end;

const
  SLOWTURNTICS = 6;
  NUMKEYS = 256;

var
  gamekeydown: array[0..NUMKEYS - 1] of boolean;
  turnheld: integer;

  lookheld: integer;  // JVAL Look UP and DOWN
  lookheld2: integer; // JVAL Look RIGHT and LEFT

  mousearray: array[0..2] of boolean;
  mousebuttons: PBooleanArray;

// mouse values are used once
  mousex: integer = 0;
  mousey: integer = 0;

  dclicktime: integer;
  dclickstate: boolean;
  dclicks: integer;
  dclicktime2: integer;
  dclickstate2: boolean;
  dclicks2: integer;

// joystick values are repeated
  joyxmove: integer;
  joyymove: integer;
  joyarray: array[0..NUMJOYBUTTONS - 1] of boolean;
  joybuttons: PBooleanArray;

  savegameslot: integer;
  savedescription: string;

const
  BODYQUESIZE  = 32;

var
  bodyque: array[0..BODYQUESIZE - 1] of Pmobj_t;

//==============================================================================
//
// G_BuildTiccmd
// Builds a ticcmd from all of the available inputs
// or reads it from the demo buffer.
// If recording a demo, write it out
//
//==============================================================================
procedure G_BuildTiccmd(cmd: Pticcmd_t);
var
  i: integer;
  strafe: boolean;
  //bstrafe: boolean;
  speed: integer;
  tspeed: integer;
  lspeed: integer;  // JVAL Look up and down
  lspeed2: integer; // JVAL look left and right
  _forward: integer;
  side: integer;
  look: integer;    // JVAL Look up and down
  look2: integer;   // JVAL look left and right
  base: Pticcmd_t;
  imousex: integer;
  imousey: integer;
begin
  base := I_BaseTiccmd;    // empty, or external driver

  memcpy(cmd, base, SizeOf(cmd^));

  cmd.consistency := consistency[consoleplayer][maketic mod BACKUPTICS];

  strafe := gamekeydown[key_strafe] {or
            (usemouse and mousebuttons[mousebstrafe]){ or
            (usejoystick and joybuttons[joybstrafe])};
  speed := intval(gamekeydown[key_speed]);// or joybuttons[joybspeed]);
  if autorunmode then
    speed := 1 - speed;

  _forward := 0;
  side := 0;
  look := 0;
  look2 := 0;

  // use two stage accelerative turning
  // on the keyboard and joystick
  if { jval: WOLF (joyxmove <> 0)  or}
     (gamekeydown[key_right]) or (gamekeydown[key_right2]) or
     (gamekeydown[key_left]) or (gamekeydown[key_left2]) then
    turnheld := turnheld + ticdup
  else
    turnheld := 0;

  if turnheld < SLOWTURNTICS then
    tspeed := 2             // slow turn
  else
    tspeed := speed;

  if gamekeydown[key_lookdown] or gamekeydown[key_lookup] then
    lookheld := lookheld + ticdup
  else
    lookheld := 0;

  if lookheld < SLOWTURNTICS then
    lspeed := 1
  else
    lspeed := 2;

  if gamekeydown[key_lookleft] or gamekeydown[key_lookright] or
    (usejoystick and (joybuttons[joyblleft] or joybuttons[joyblright])) then
    lookheld2 := lookheld2 + ticdup
  else
    lookheld2 := 0;

  if lookheld2 < SLOWTURNTICS then
    lspeed2 := 1
  else
    lspeed2 := 2;

  // let movement keys cancel each other out
  if strafe then
  begin
    if gamekeydown[key_right] or gamekeydown[key_right2] then
      side := side + sidemove[speed];
    if gamekeydown[key_left] or gamekeydown[key_left2] then
      side := side - sidemove[speed];
    if joyxmove > 0 then
      side := side + sidemove[speed];
    if joyxmove < 0 then
      side := side - sidemove[speed];
  end
  else
  begin
    if gamekeydown[key_right] or gamekeydown[key_right2] then
      cmd.angleturn := cmd.angleturn - angleturn[tspeed];
    if gamekeydown[key_left] or gamekeydown[key_left2] then
      cmd.angleturn := cmd.angleturn + angleturn[tspeed];
    if joyxmove > 0 then
      cmd.angleturn := cmd.angleturn - angleturn[tspeed];
    if joyxmove < 0 then
      cmd.angleturn := cmd.angleturn + angleturn[tspeed];
  end;

  if gamekeydown[key_up] or gamekeydown[key_up2] then
    _forward := _forward + forwardmove[speed];

  if gamekeydown[key_down] or gamekeydown[key_down2] then
    _forward := _forward - forwardmove[speed];

  // JVAL Look up/down/center keys
  if zaxisshift then
  begin
    if gamekeydown[key_lookup] then
      look := lspeed;

    if gamekeydown[key_lookdown] then
      look := -lspeed;

    if gamekeydown[key_lookcenter] then
      look := TOCENTER;
  end;

  // JVAL Look right/left/forward keys
  if gamekeydown[key_lookleft] or (usejoystick and joybuttons[joyblleft]) then
    look2 := lspeed2;

  if gamekeydown[key_lookright] or (usejoystick and joybuttons[joyblright]) then
    look2 := -lspeed2;

  if gamekeydown[key_lookforward] then
    look2 := TOFORWARD;

  if joyymove < 0 then
    _forward := _forward + forwardmove[speed];

  if joyymove > 0 then
    _forward := _forward - forwardmove[speed];

  if gamekeydown[key_straferight] or gamekeydown[key_straferight2] then
    side := side + sidemove[speed];

  if gamekeydown[key_strafeleft] or gamekeydown[key_strafeleft2] then
    side := side - sidemove[speed];

  // buttons
  cmd.chatchar := Ord(HU_dequeueChatChar);

  if gamekeydown[key_fire] or
     (usemouse and mousebuttons[mousebfire]) or
     (usejoystick and joybuttons[joybfire]) then
    cmd.buttons := cmd.buttons or BT_ATTACK;

  if gamekeydown[key_use] or (usejoystick and joybuttons[joybuse]) then
  begin
    cmd.buttons := cmd.buttons or BT_USE;
  // clear double clicks if hit use button
    dclicks := 0;
  end;

  // chainsaw overrides
  for i := 0 to Ord(NUMWEAPONS) - 2 do
    if gamekeydown[Ord('1') + i] then
    begin
      cmd.buttons := cmd.buttons or BT_CHANGE;
      cmd.buttons := cmd.buttons or _SHL(i, BT_WEAPONSHIFT);
      break;
    end;

  // mouse
  if (usemouse and mousebuttons[mousebforward]) then
    _forward := _forward + forwardmove[speed];

  // forward double click
  if usemouse and (mousebuttons[mousebforward] <> dclickstate) and (dclicktime > 1) then
  begin
    dclickstate := mousebuttons[mousebforward];
    if dclickstate then
      inc(dclicks);
    if dclicks = 2 then
    begin
      cmd.buttons := cmd.buttons or BT_USE;
      dclicks := 0;
    end
    else
      dclicktime := 0;
  end
  else
  begin
    dclicktime := dclicktime + ticdup;
    if dclicktime > 20 then
    begin
      dclicks := 0;
      dclickstate := false;
    end
  end;

  // JVAL: invert mouse
  if invertmouseturn then
    imousex := -mousex
  else
    imousex := mousex;

  if strafe then
    side := side - imousex * 2
  else
    cmd.angleturn := cmd.angleturn + imousex * $8;

  if invertmouselook then
    imousey := -mousey
  else
    imousey := mousey;

  if usemouse then
  begin
    look := look + imousey div 16;
    if imousey < 0 then
    begin
      if look < -4 then
        look := -4;
    end
    else if imousey > 0 then
    begin
      if look > 4 then
        look := 4;
    end;
  end;
  // For smooth mouse movement
  mousex := mousex div 4;
  mousey := mousey div 4;

  if _forward > MAXPLMOVE then
    _forward := MAXPLMOVE
  else if _forward < -MAXPLMOVE then
    _forward := -MAXPLMOVE;

  if side > MAXPLMOVE then
    side := MAXPLMOVE
  else if side < -MAXPLMOVE then
    side := -MAXPLMOVE;

  cmd.forwardmove := cmd.forwardmove + _forward;
  cmd.sidemove := cmd.sidemove + side;

  if players[consoleplayer].playerstate = PST_LIVE then
  begin
    if zaxisshift then
    begin
      if look < 0 then
        look := look + 16;
      cmd.look := look;
    end;
    if look2 < 0 then
      look2 := look2 + 16;
    cmd.look2 := look2;
    // JVAL
    // allowplayerjumps variable controls if we accept input for jumping
    if allowplayerjumps and (gamekeydown[key_jump] or gamekeydown[key_jump2] or
                             (usemouse and mousebuttons[mousebjump]) or (usejoystick and joybuttons[joybjump])
        ) then
    begin
      if players[consoleplayer].oldjump <> 0 then
        cmd.jump := 1
      else
        cmd.jump := 2
      end
    else
      cmd.jump := 0;
    players[consoleplayer].oldjump := cmd.jump;
  end;

  // special buttons
  if sendpause then
  begin
    sendpause := false;
    cmd.buttons := BT_SPECIAL or BTS_PAUSE;
  end;

  if sendsave then
  begin
    sendsave := false;
    cmd.buttons := BT_SPECIAL or BTS_SAVEGAME or _SHL(savegameslot, BTS_SAVESHIFT);
  end;
  if sendcmdsave then
  begin
    sendcmdsave := false;
    cmd.commands := CM_SAVEGAME;
  end;

end;

//==============================================================================
//
// G_DoLoadLevel
//
//==============================================================================
procedure G_DoLoadLevel;
var
  i: integer;
begin
  gamestate := GS_LEVEL;

  for i := 0 to MAXPLAYERS - 1 do
  begin
    if playeringame[i] and (players[i].playerstate = PST_DEAD) then
      players[i].playerstate := PST_REBORN;
    ZeroMemory(@players[i].frags, SizeOf(players[i].frags));
  end;

  if j_jump then
  begin
    gamemap := j_gamemap;
    gameepisode := j_gameepisode;
    j_jump := false;
  end;

  // Set the sky map.
  // First thing, we have a dummy sky texture name,
  //  a flat. The data is in the WAD only because
  //  we look for an actual index, instead of simply
  //  setting one.
  skyflatnum := R_FlatNumForName(SKYFLATNAME);
  skytexture := R_TextureNumForName(journeymapinfo[gamemap].skytexture);

  P_SetupLevel(gameepisode, gamemap, 0, gameskill);
  displayplayer := consoleplayer;    // view the guy you are playing
  starttime := I_GetTime;
  gameaction := ga_nothing;
  Z_CheckHeap;
  // JVAL: Extra debug check
  if debugmode then
    Z_CheckMemory;

  // clear cmd building stuff
  ZeroMemory(@gamekeydown, SizeOf(gamekeydown));
  joyxmove := 0;
  joyymove := 0;
  mousex := 0;
  mousey := 0;
  sendpause := false;
  sendsave := false;
  sendcmdsave := false;
  paused := false;
  ZeroMemory(mousebuttons, SizeOf(mousebuttons));
  ZeroMemory(joybuttons, SizeOf(joybuttons));
end;

//==============================================================================
//
// G_Responder
// Get info needed to make ticcmd_ts for the players.
//
//==============================================================================
function G_Responder(ev: Pevent_t): boolean;
begin
  // any other key pops up menu if in demos
  if (gameaction = ga_nothing) and (not singledemo) and
     (demoplayback or (gamestate = GS_DEMOSCREEN)) then
  begin
    if ((ev._type = ev_keydown)  and (ev.data1 = KEY_ESCAPE)) or
       ((ev._type = ev_mouse) and (ev.data1 <> 0)) then
    begin
      M_StartControlPanel;
      result := true;
      exit;
    end;
    result := false;
    exit;
  end;

  if gamestate = GS_LEVEL then
  begin
    if HU_Responder(ev) then
    begin
      result := true; // chat ate the event
      exit;
    end;
    if ST_Responder(ev) then
    begin
      result := true; // status window ate it
      exit;
    end;
  end;

  if gamestate = GS_FINALE then
  begin
    if F_Responder(ev) then
    begin
      result := true; // finale ate the event
      exit;
    end;
  end;

  // For smooth mouse movement
  mousex := mousex div 2;
  mousey := mousey div 2;

  case ev._type of
    ev_keydown:
      begin
        if ev.data1 < NUMKEYS then
          gamekeydown[ev.data1] := true;
        result := true; // eat key down events
        exit;
      end;
    ev_keyup:
      begin
        if ev.data1 < NUMKEYS then
          gamekeydown[ev.data1] := false;
        result := false; // always let key up events filter down
        exit;
      end;
    ev_mouse:
      begin
        if usemouse then
        begin
          mousebuttons[0] := ev.data1 and 1 <> 0;
          mousebuttons[1] := ev.data1 and 2 <> 0;
          mousebuttons[2] := ev.data1 and 4 <> 0;
          mousex := mousex + (ev.data2 * (mouseSensitivity + 5)) div 10;
          mousey := mousey + (ev.data3 * (mouseSensitivity + 5)) div 10;
        end
        else
        begin
          mousebuttons[0] := false;
          mousebuttons[1] := false;
          mousebuttons[2] := false;
          mousex := 0;
          mousey := 0;
        end;
        result := true;    // eat events
        exit;
      end;
  end;

  result := false;
end;

//==============================================================================
//
// G_Ticker
// Make ticcmd_ts for the players.
//
//==============================================================================
procedure G_Ticker;
var
  i: integer;
  buf: integer;
  cmd: Pticcmd_t;
  msg: string;
  pl: Pplayer_t;
begin
  // do player reborns if needed
  for i := 0 to MAXPLAYERS - 1 do
    if playeringame[i] and (players[i].playerstate = PST_REBORN) then
      G_DoReborn(i);

  // do things to change the game state
  while (gameaction <> ga_nothing) do
  begin
    case gameaction of
      ga_loadlevel:
        G_DoLoadLevel;
      ga_newgame:
        G_DoNewGame;
      ga_loadgame:
        G_DoLoadGame;
      ga_savegame:
        G_DoSaveGame;
      ga_playdemo:
        G_DoPlayDemo;
      ga_completed:
        G_DoCompleted;
      ga_victory:
        F_StartFinale;
      ga_worlddone:
        G_DoWorldDone;
      ga_screenshot:
        begin
          M_ScreenShot;
          gameaction := ga_nothing;
        end;
    end;
  end;

  // get commands, check consistency,
  // and build new consistency check
  buf := (gametic div ticdup) mod BACKUPTICS;

  for i := 0 to MAXPLAYERS - 1 do
  begin
    if playeringame[i] then
    begin
      pl := @players[i];
      cmd := @pl.cmd;

      memcpy(cmd, @netcmds[i][buf], SizeOf(ticcmd_t));

      if demoplayback then
        G_ReadDemoTiccmd(cmd);
      if demorecording then
        G_WriteDemoTiccmd(cmd);

      // check for turbo cheats
      if (cmd.forwardmove > TURBOTHRESHOLD) and
         ((gametic and 31) = 0) and
         (((_SHR(gametic, 5)) and 3) = i) then
      begin
        sprintf(msg, '%s is turbo!', [player_names[i]]);
      end;

      if netgame and (not netdemo) and ((gametic mod ticdup) = 0) then
      begin
        if (gametic > BACKUPTICS) and
           (consistency[i][buf] <> cmd.consistency) then
          I_Error('G_Ticker(): consistency failure (%d should be %d)',
            [cmd.consistency, consistency[i][buf]]);

        if pl.mo <> nil then
          consistency[i][buf] := pl.mo.x
        else
          consistency[i][buf] := rndindex;
      end;
    end;
  end;

  // check for special buttons
  for i := 0 to MAXPLAYERS - 1 do
  begin
    if playeringame[i] then
    begin
      pl := @players[i];
      if pl.cmd.commands and CM_SAVEGAME <> 0 then
      begin
        savegameslot := Ord(load_end);
        gameaction := ga_savegame;
      end;
      if pl.cmd.buttons and BT_SPECIAL <> 0 then
      begin
        case pl.cmd.buttons and BT_SPECIALMASK of
          BTS_PAUSE:
            begin
              paused := not paused;
              if paused then
                S_PauseSound
              else
                S_ResumeSound;
            end;
          BTS_SAVEGAME:
            begin
              if savedescription = '' then
                savedescription := 'NET GAME';
              savegameslot :=
                _SHR((pl.cmd.buttons and BTS_SAVEMASK), BTS_SAVESHIFT);
              gameaction := ga_savegame;
            end;
        end;
      end;
    end;
  end;

  // do main actions
  case gamestate of
    GS_LEVEL:
      begin
        P_Ticker;
        ST_Ticker;
        HU_Ticker;
      end;
    GS_FINALE:
      begin
        F_Ticker;
      end;
    GS_DEMOSCREEN:
      begin
        D_PageTicker;
      end;
  end;
end;

//==============================================================================
//
// PLAYER STRUCTURE FUNCTIONS
// also see P_SpawnPlayer in P_Things
//
// G_PlayerFinishLevel
// Can when a player completes a level.
//
//==============================================================================
procedure G_PlayerFinishLevel(p: Pplayer_t);
begin
  ZeroMemory(@p.powers, SizeOf(p.powers));
  ZeroMemory(@p.cards, SizeOf(p.cards));
  p.mo.flags := p.mo.flags and (not MF_SHADOW); // cancel invisibility
  p.lookdir := 0;       // JVAL cancel lookdir Up/Down
  p.centering := false;
  p.lookdir2 := 0;      // JVAL cancel lookdir Left/Right
  p.forwarding := false;
  p.extralight := 0;    // cancel gun flashes
  p.fixedcolormap := 0; // cancel ir gogles
  p.damagecount := 0;   // no palette changes
  p.bonuscount := 0;
end;

//==============================================================================
//
// G_SetKeyboardMode
//
//==============================================================================
procedure G_SetKeyboardMode;
begin
  key_right := 174;
  key_left := 172;
  key_up := 173;
  key_down := 175;
  key_strafeleft := 44;
  key_straferight := 46;
  key_jump := 113;
  key_fire := 157;
  key_use := 32;
  key_strafe := 184;
  key_speed := 182;
  key_lookup := 197;
  key_lookdown := 202;
  key_lookcenter := 199;
  key_lookright := 198;
  key_lookleft := 200;
  key_lookforward := 13;

  key_right2 := 174;
  key_left2 := 172;
  key_up2 := 119;
  key_down2 := 115;
  key_strafeleft2 := 97;
  key_straferight2 := 100;
  key_jump2 := 122;
  key_fire2 := 157;
  key_use2 := 32;
  key_strafe2 := 184;
  key_speed2 := 182;
  key_lookup2 := 197;
  key_lookdown2 := 202;
  key_lookcenter2 := 199;
  key_lookright2 := 198;
  key_lookleft2 := 200;
  key_lookforward2 := 13;
end;

//==============================================================================
//
// G_PlayerReborn
// Called after a player dies
// almost everything is cleared and initialized
//
//==============================================================================
procedure G_PlayerReborn(player: integer);
var
  p: Pplayer_t;
  i: integer;
  frags: array[0..MAXPLAYERS - 1] of integer;
  killcount: integer;
  itemcount: integer;
  secretcount: integer;
  cheats: integer;
begin
  p := @players[player];
  memcpy(@frags, @p.frags, SizeOf(frags));
  killcount := p.killcount;
  itemcount := p.itemcount;
  secretcount := p.secretcount;

  // JVAL: added option to keep cheats
  if keepcheatsinplayerreborn and not preparingdemoplayback then
  begin
    cheats := p.cheats;
    ZeroMemory(p, SizeOf(player_t));
    p.cheats := cheats;
  end
  else
    ZeroMemory(p, SizeOf(player_t));

  memcpy(@p.frags, @frags, SizeOf(players[player].frags));
  p.killcount := killcount;
  p.itemcount := itemcount;
  p.secretcount := secretcount;

  p.angletargetx := 0;
  p.angletargety := 0;
  p.angletargetticks := 0;
  p.usedown := true;
  p.attackdown := true;     // don't do anything immediately
  p.playerstate := PST_LIVE;
  p.health := mobjinfo[Ord(MT_PLAYER)].spawnhealth;
  p.readyweapon := wp_pistol;
  p.pendingweapon := wp_pistol;
  p.weaponowned[Ord(wp_pistol)] := 1;
  p.ammo[Ord(am_clip)] := 2000000000;
  p.maxammo[Ord(am_clip)] := 2000000000;

  for i := 0 to Ord(NUMAMMO) - 1 do
    p.maxammo[i] := maxammo[i];
end;

//==============================================================================
//
// G_CheckSpot
// Returns false if the player cannot be respawned
// at the given mapthing_t spot
// because something is occupying it
//
//==============================================================================
function G_CheckSpot(playernum: integer; mthing: Pmapthing_t): boolean;
var
  x: fixed_t;
  y: fixed_t;
  ss: Psubsector_t;
  an: angle_t; // JVAL was u long
  mo: Pmobj_t;
  i: integer;
begin
  x := mthing.x * FRACUNIT;
  y := mthing.y * FRACUNIT;

  if players[playernum].mo = nil then
  begin
    // first spawn of level, before corpses
    for i := 0 to playernum - 1 do
      if (players[i].mo.x = x) and
         (players[i].mo.y = x) then
      begin
        result := false;
        exit;
      end;
    result := true;
    exit;
  end;

  if not P_CheckPosition(players[playernum].mo, x, y) then
  begin
    result := false;
    exit;
  end;

  // flush an old corpse if needed
  if bodyqueslot >= BODYQUESIZE then
    P_RemoveMobj(bodyque[bodyqueslot mod BODYQUESIZE]);
  bodyque[bodyqueslot mod BODYQUESIZE] := players[playernum].mo;
  inc(bodyqueslot);

  // spawn a teleport fog
  ss := R_PointInSubsector(x, y);
  an := (ANG45 * (mthing.angle div 45)) shr ANGLETOFINESHIFT;

  mo := P_SpawnMobj(x + 20 * finecosine[an], y + 20 * finesine[an],
          ss.sector.floorheight, Ord(MT_TFOG));

  if players[consoleplayer].viewz <> 1 then
    S_StartSound(mo, Ord(sfx_telept));  // don't start sound on first frame

  result := true;
end;

//==============================================================================
//
// G_DeathMatchSpawnPlayer
// Spawns a player at one of the random death match spots
// called at level load and each death
//
//==============================================================================
procedure G_DeathMatchSpawnPlayer(playernum: integer);
var
  i, j: integer;
  selections: integer;
begin
  selections := deathmatch_p; // JVAL - deathmatchstarts;
  if selections < 4 then
    I_Error('G_DeathMatchSpawnPlayer(): Only %d deathmatch spots, 4 required', [selections]);

  for j := 0 to 19 do
  begin
    i := P_Random mod selections;
    if G_CheckSpot(playernum, @deathmatchstarts[i]) then
    begin
      deathmatchstarts[i]._type := playernum + 1;
      P_SpawnPlayer(@deathmatchstarts[i]);
      exit;
    end;
  end;

  // no good spot, so the player will probably get stuck
  P_SpawnPlayer(@playerstarts[playernum]);
end;

//==============================================================================
//
// G_DoReborn
//
//==============================================================================
procedure G_DoReborn(playernum: integer);
var
  i: integer;
begin
  if not netgame then
    // reload the level from scratch
    gameaction := ga_loadlevel
  else
  begin
    // respawn at the start

    // first dissasociate the corpse
    players[playernum].mo.player := nil;

    // spawn at random spot if in death match
    if deathmatch <> 0 then
    begin
      G_DeathMatchSpawnPlayer(playernum);
      exit;
    end;

    if G_CheckSpot(playernum, @playerstarts[playernum]) then
    begin
      P_SpawnPlayer(@playerstarts[playernum]);
      exit;
    end;

    // try to spawn at one of the other players spots
    for i := 0 to MAXPLAYERS - 1 do
    begin
      if G_CheckSpot (playernum, @playerstarts[i]) then
      begin
        playerstarts[i]._type := playernum + 1; // fake as other player
        P_SpawnPlayer(@playerstarts[i]);
        playerstarts[i]._type := i + 1; // restore
        exit;
      end;
      // he's going to be inside something.  Too bad.
    end;
    P_SpawnPlayer(@playerstarts[playernum]);
  end;
end;

//==============================================================================
//
// G_ScreenShot
//
//==============================================================================
procedure G_ScreenShot;
begin
  gameaction := ga_screenshot;
end;

//
// G_DoCompleted
//
var
  secretexit: boolean;

//==============================================================================
//
// G_ExitLevel
//
//==============================================================================
procedure G_ExitLevel;
begin
  secretexit := false;
  gameaction := ga_completed;
end;

//==============================================================================
// G_SecretExitLevel
//
// Here's for the german edition.
//
//==============================================================================
procedure G_SecretExitLevel;
begin
  // IF NO WOLF3D LEVELS, NO SECRET EXIT!
  if (gamemode = commercial) and (W_CheckNumForName('map31') < 0) then
    secretexit := false
  else
    secretexit := true;
  gameaction := ga_completed;
end;

//==============================================================================
//
// G_DoCompleted
//
//==============================================================================
procedure G_DoCompleted;
var
  i: integer;
begin
  gameaction := ga_nothing;

  for i := 0 to MAXPLAYERS - 1 do
    if playeringame[i] then
      G_PlayerFinishLevel(@players[i]); // take away cards and stuff

  gameaction := ga_victory;
end;

//==============================================================================
//
// G_WorldDone
//
//==============================================================================
procedure G_WorldDone;
begin
  gameaction := ga_worlddone;

  if secretexit then
    players[consoleplayer].didsecret := true;

  if gamemode = commercial then
  begin
    if secretexit then
    begin
      if gamemap in [15, 31, 6, 11, 20, 30] then
        F_StartFinale
    end
    else if gamemap in [6, 11, 20, 30] then
      F_StartFinale;
  end;
end;

//==============================================================================
//
// G_DoWorldDone
//
//==============================================================================
procedure G_DoWorldDone;
begin
  gamestate := GS_LEVEL;
  gamemap := wminfo.next + 1;
  G_DoLoadLevel;
  gameaction := ga_nothing;
  viewactive := true;
end;

//==============================================================================
//
// G_GetSaveName
//
//==============================================================================
function G_GetSaveName(name: string): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to Ord(load_end) - 1 do
  begin
    if name = itoa(i) then
    begin
      sprintf(result, SAVEGAMENAME + '%s.dsg', [name]);
      exit;
    end;
  end;

  if strupper(Copy(name, length(name) - 3, 4)) <> '.DSG' then
    result := name + '.DSG'
  else
    result := name;
end;

//
// G_InitFromSavegame
// Can be called by the startup code or the menu task.
//
var
  savename: string;

//==============================================================================
//
// G_LoadGame
//
//==============================================================================
procedure G_LoadGame(const name: string);
begin
  savename := name;
  gameaction := ga_loadgame;
end;

const
  VERSIONSIZE = 16;

//==============================================================================
//
// G_DoLoadGame
//
//==============================================================================
procedure G_DoLoadGame;
var
  len: integer;
  i, j: integer;
  a, b, c: integer;
  vcheck: string;
  vsaved: string;
  scheck: string;
begin
  gameaction := ga_nothing;

  savename := strupper(G_GetSaveName(savename));

  if not fexists(savename) then
  begin
    I_Warning('Can not open %s'#13#10, [savename]);
    exit;
  end;

  for i := 0 to Ord(load_end) - 1 do
  begin
    scheck := strupper(G_GetSaveName(itoa(i)));
    if (savename = scheck) or (savename = '.\' + scheck) then
    begin
      J_RestoreSaveSlot(i);
      break;
    end;
  end;

  len := M_ReadFile(savename, pointer(savebuffer));
  save_p := PByteArray(integer(savebuffer) + SAVESTRINGSIZE);

  savegameversion := VERSION; // Assume current version

  // skip the description field
  vcheck := '';
  sprintf(vcheck, 'version %d', [VERSION]);

  if len < Length(vcheck) then
  begin
    I_Warning('G_DoLoadGame(): Saved game is from an unsupported version.'#13#10);
    Z_Free(savebuffer);
    exit; // bad version // by JVAL extra checking
  end;

  for i := 0 to Length(vcheck) - 1 do
    if save_p[i] <> Ord(vcheck[i + 1]) then
    begin
      vsaved := '';
      for j := 0 to Length(vcheck) - 1 do
        vsaved := vsaved + Chr(save_p[j]);
      // JVAL
      // Check for compatible game versions here
      if vsaved <> 'version ' + itoa(VERSION) then
      begin
        I_Warning('G_DoLoadGame(): Saved game is from an unsupported version: %s!'#13#10, [vsaved]);
        Z_Free(savebuffer);
        exit; // bad version
      end;
      break;
    end;

  save_p := PByteArray(integer(save_p) + VERSIONSIZE);

  gameskill := skill_t(save_p[0]);
  save_p := PByteArray(integer(save_p) + 1);

  gameepisode := save_p[0];
  save_p := PByteArray(integer(save_p) + 1);

  gamemap := save_p[0];
  save_p := PByteArray(integer(save_p) + 1);

  for i := 0 to MAXPLAYERS - 1 do
  begin
    playeringame[i] := save_p[0] <> 0;
    save_p := PByteArray(integer(save_p) + 1);
  end;

  if j_restore then
  begin
    j_restore := false;
    G_InitNew(gameskill, gameepisode, gamemap);
    j_restore := true;
  end
  else
    G_InitNew(gameskill, gameepisode, gamemap);
  // load a base level

  // get the times
  a := save_p[0];
  save_p := PByteArray(integer(save_p) + 1);

  b := save_p[0];
  save_p := PByteArray(integer(save_p) + 1);

  c := save_p[0];
  save_p := PByteArray(integer(save_p) + 1);

  leveltime := _SHL(a, 16) + _SHL(b, 8) + c;

  // dearchive all the modifications
  P_UnArchivePlayers;
  P_UnArchiveWorld;
  P_UnArchiveThinkers;
  P_IdendifyGameParams;
  P_UnArchiveSpecials;
  P_UnArchiveExtra;

  if save_p[0] <> $1d then
    I_Error('G_DoLoadGame(): Bad savegame');

  // done
  Z_Free(savebuffer);

  if setsizeneeded then
    R_ExecuteSetViewSize;

end;

//==============================================================================
//
// G_SaveGame
// Called by the menu task.
// Description is a 24 byte text string
//
//==============================================================================
procedure G_SaveGame(slot: integer; const description: string);
begin
  savegameslot := slot;
  savedescription := description;
  sendsave := true;
end;

//==============================================================================
//
// G_DoSaveGameInFile
//
//==============================================================================
procedure G_DoSaveGameInFile(name: string);
var
  name2: string;
  description: string;
  len: integer;
  i: integer;
  maxsize: integer;
begin
  name := G_GetSaveName(name);

  description := savedescription;

  maxsize := SAVEGAMESIZE;
  repeat
    savebuffer := Z_Malloc2(maxsize, PU_STATIC, nil);
    if savebuffer = nil then
      maxsize := maxsize * 3 div 4;
  until savebuffer <> nil;

  save_p := savebuffer;

  memcpy(save_p, @description[1], SAVESTRINGSIZE);

  save_p := PByteArray(integer(save_p) + SAVESTRINGSIZE);
  name2 := '';

  sprintf(name2, 'version %d', [VERSION]);
  memcpy(save_p, @name2[1], VERSIONSIZE);
  save_p := PByteArray(integer(save_p) + VERSIONSIZE);

  save_p[0] := Ord(gameskill);
  save_p := PByteArray(integer(save_p) + 1);

  save_p[0] := gameepisode;
  save_p := PByteArray(integer(save_p) + 1);

  save_p[0] := gamemap;
  save_p := PByteArray(integer(save_p) + 1);

  for i := 0 to MAXPLAYERS - 1 do
  begin
    save_p[0] := intval(playeringame[i]);
    save_p := PByteArray(integer(save_p) + 1);
  end;

  save_p[0] := _SHR(leveltime, 16);
  save_p := PByteArray(integer(save_p) + 1);

  save_p[0] := _SHR(leveltime, 8);
  save_p := PByteArray(integer(save_p) + 1);

  save_p[0] := leveltime;
  save_p := PByteArray(integer(save_p) + 1);

  P_ArchivePlayers;
  P_ArchiveWorld;
  P_ArchiveThinkers;
  P_ArchiveSpecials;
  P_ArchiveExtra;

  save_p[0] := $1d; // consistency marker

  len := integer(save_p) - integer(savebuffer) + 1;
  if len > maxsize then
    I_Error('G_DoSaveGame(): Savegame buffer overrun');
  M_WriteFile(name, savebuffer, len);
  Z_Free(savebuffer);
  gameaction := ga_nothing;
  savedescription := '';

//  players[consoleplayer]._message := GGSAVED;

  // draw the pattern into the back screen
end;

//==============================================================================
//
// G_DoSaveGame
//
//==============================================================================
procedure G_DoSaveGame;
var
  name: string;
begin
  if savegameslot = Ord(load_end) then
    name := savename
  else
  begin
    sprintf(name, M_SaveFileName(SAVEGAMENAME) + '%d.dsg', [savegameslot]);
    J_CopySaveSlot(savegameslot);
  end;

  G_DoSaveGameInFile(name);

end;

//==============================================================================
//
// G_CmdSaveGame
//
//==============================================================================
procedure G_CmdSaveGame(const sname: string; const description: string);
begin
  if not usergame or (gamestate <> GS_LEVEL) then
  begin
    printf('You can''t save if you aren''t playing!'#13#10);
    exit;
  end;

  if sname <> '' then
  begin
    savename := sname;
    if description <> '' then
      savedescription := description
    else
      savedescription := savename;
    sendcmdsave := true;
  end
  else
    printf('Usage: savegame [slot(integer)] [description(string)]');
end;

//
// G_InitNew
// Can be called by the startup code or the menu task,
// consoleplayer, displayplayer, playeringame[] should be set.
//
var
  d_skill: skill_t;
  d_episode: integer;
  d_map: integer;

//==============================================================================
//
// G_DeferedInitNew
//
//==============================================================================
procedure G_DeferedInitNew(skill: skill_t; episode, map: integer);
begin
  d_skill := skill;
  d_episode := episode;
  d_map := map;
  gameaction := ga_newgame;
end;

//==============================================================================
//
// G_CmdNewGame
//
//==============================================================================
procedure G_CmdNewGame(const parm1, parm2: string);
var
  epsd, map: integer;
  mapname: string;
begin
  if parm1 = '' then
  begin
    printf('Please specify the level to play'#13#10);
    exit;
  end;

  mapname := strupper(parm1);

  if gamemode = commercial then
  begin
    epsd := 0;
    map := atoi(parm1);
    if (mapname[1] = 'M') then
      if length(mapname) = 5 then
        if (mapname[2] = 'A') and
           (mapname[3] = 'P') then
          map := atoi(mapname[4] + mapname[5]);
  end
  else
  begin
    epsd := atoi(parm1);
    map := atoi(parm2);
    if parm2 = '' then
      if (mapname[1] = 'E') then
        if length(mapname) = 4 then
          if (mapname[3] = 'M') then
          begin
            epsd := atoi(mapname[2]);
            map := atoi(mapname[4]);
          end;
  end;

  if W_CheckNumForName(P_GetMapName(epsd, map)) > -1 then
  begin
//    players[consoleplayer]._message := STSTR_CLEV;
    G_DeferedInitNew(gameskill, epsd, map);
    C_ExecuteCmd('closeconsole', '1');
  end
  else
    I_Warning('G_CmdNewGame(): Can not load map.'#13#10);
end;

//==============================================================================
//
// G_DoNewGame
//
//==============================================================================
procedure G_DoNewGame;
var
  i: integer;
begin
  G_FinishedDemoPlayback; // JVAL: remove???
  netdemo := false;
  netgame := false;
  deathmatch := 0;
  for i := 1 to MAXPLAYERS - 1 do
    playeringame[i] := false;
  respawnparm := false;
  fastparm := false;
  nomonsters := false;
  consoleplayer := 0;
  G_InitNew(d_skill, d_episode, d_map);
  gameaction := ga_nothing;
end;

//==============================================================================
//
// G_InitNew
//
//==============================================================================
procedure G_InitNew(skill: skill_t; episode, map: integer);
var
  i: integer;
begin
  if (episode = 1) and (map = 1) then
    J_DeleteSaveSlot(8);

  if paused then
  begin
    paused := false;
    S_ResumeSound;
  end;

  if skill > sk_nightmare then
    skill := sk_nightmare;

  // This was quite messy with SPECIAL and commented parts.
  // Supposedly hacks to make the latest edition work.
  // It might not work properly.
  if episode < 1 then
    episode := 1;

  if gamemode = retail then
  begin
    if episode > 4 then
      episode := 4;
  end
  else if gamemode = shareware then
  begin
    if episode > 1 then
      episode := 1;  // only start episode 1 on shareware
  end
  else
  begin
    if episode > 3 then
      episode := 3;
  end;

  if map < 1 then
    map := 1;

  if (map > 9) and (gamemode <> commercial) then
    map := 9;

  R_ResetInterpolationBuffer;

  M_ClearRandom;

  if (skill = sk_nightmare) or respawnparm then
    respawnmonsters := true
  else
    respawnmonsters := false;

  if fastparm or ((skill = sk_nightmare) and (gameskill <> sk_nightmare)) then
  begin
    for i := Ord(S_SARG_RUN1) to Ord(S_SARG_PAIN2) do
      states[i].tics := _SHR(states[i].tics, 1);
    mobjinfo[Ord(MT_BRUISERSHOT)].speed := 20 * FRACUNIT;
    mobjinfo[Ord(MT_HEADSHOT)].speed := 20 * FRACUNIT;
    mobjinfo[Ord(MT_TROOPSHOT)].speed := 20 * FRACUNIT;
  end
  else if (skill <> sk_nightmare) and (gameskill = sk_nightmare) then
  begin
    for i := Ord(S_SARG_RUN1) to Ord(S_SARG_PAIN2) do
      states[i].tics := _SHL(states[i].tics, 1);
    mobjinfo[Ord(MT_BRUISERSHOT)].speed := 15 * FRACUNIT;
    mobjinfo[Ord(MT_HEADSHOT)].speed := 10 * FRACUNIT;
    mobjinfo[Ord(MT_TROOPSHOT)].speed := 10 * FRACUNIT;
  end;

  // force players to be initialized upon first level load
  for i := 0 to MAXPLAYERS - 1 do
    players[i].playerstate := PST_REBORN;

  usergame := true;  // will be set false if a demo
  paused := false;
  G_FinishedDemoPlayback;
  viewactive := true;
  gameepisode := episode;
  gamemap := map;
  gameskill := skill;

  viewactive := true;

  G_DoLoadLevel;
end;

//
// DEMO PLAYBACK
//
const
  DEMOMARKER = $80;

var
  compatibility_done: boolean;

//==============================================================================
// G_SafeCompatibilityDemo
//
// Old game versions compatibility
//
//==============================================================================
procedure G_SafeCompatibilityDemo;
var
  i: integer;
begin
  if compatibility_done then
    exit;

  if players[consoleplayer].playerstate = PST_DEAD then
  begin
    compatibility_done := true;
    i := 4;
    while (integer(@demo_p[i]) < integer(demoend) - 4) and (demo_p[i] <> DEMOMARKER) do
      inc(i, 4);
    // JVAL: Leave maximum 4 seconds after player death
    if i > 4 * TICKRATE * 4 then
    begin
      i := 4 * TICKRATE * 4;
      demo_p[i] := DEMOMARKER;
    end;
    ZeroMemory(demo_p, i);
  end;
end;

//==============================================================================
//
// G_ReadDemoTiccmd
//
//==============================================================================
procedure G_ReadDemoTiccmd(cmd: Pticcmd_t);
begin
  if demo_p[0] = DEMOMARKER then
  begin
    // end of demo data stream
    demoplayback := false;
    G_CheckDemoStatus;
    exit;
  end;

  if olddemo then
    G_SafeCompatibilityDemo;

  cmd.forwardmove := shortint(demo_p[0]);
  demo_p := @demo_p[1];

  cmd.sidemove := shortint(demo_p[0]);
  demo_p := @demo_p[1];

  if olddemo then
  begin
    cmd.angleturn := shortint(demo_p[0]) * 256;
    demo_p := @demo_p[1];
  end
  else
  begin
    cmd.angleturn := PSmallInt(demo_p)^;
    demo_p := @demo_p[2];
  end;

  cmd.buttons := demo_p[0] and (not BT_SPECIAL);
  demo_p := @demo_p[1];

  if olddemo then
  begin
    cmd.look := 0;
    cmd.look2 := 0;
    cmd.jump := 0;
  end
  else
  begin
    cmd.look := demo_p[0];
    demo_p := @demo_p[1];
    cmd.look2 := demo_p[0];
    demo_p := @demo_p[1];
    cmd.jump := demo_p[0];
    demo_p := @demo_p[1];
  end;
end;

//==============================================================================
// G_WriteDemoTiccmd
//
// DEMO RECORDING
//
//==============================================================================
procedure G_WriteDemoTiccmd(cmd: Pticcmd_t);
begin
  if gamekeydown[Ord('q')] {or (leveltime > 20 * tickrate)} then // press q to end demo recording
    G_CheckDemoStatus;

  demo_p[0] := Ord(cmd.forwardmove);
  demo_p := @demo_p[1];

  demo_p[0] := Ord(cmd.sidemove);
  demo_p := @demo_p[1];

  PSmallInt(demo_p)^ := cmd.angleturn;
  demo_p := @demo_p[2];

  demo_p[0] := cmd.buttons and (not BT_SPECIAL);
  demo_p := @demo_p[1];

  demo_p[0] := cmd.look;
  demo_p := @demo_p[1];

  demo_p[0] := cmd.look2;
  demo_p := @demo_p[1];

  demo_p[0] := cmd.jump;

  demo_p := PByteArray(integer(demo_p) - 7);

  if integer(demo_p) > integer(demoend) - 16 then
  begin
    // no more space
    G_CheckDemoStatus;
    exit;
  end;
  G_ReadDemoTiccmd(cmd);  // make SURE it is exactly the same
end;

//==============================================================================
//
// G_RecordDemo
//
//==============================================================================
procedure G_RecordDemo(const name: string);
var
  i: integer;
  maxsize: integer;
begin
  usergame := false;
  demoname := name;
  if Pos('.', demoname) = 0 then
    demoname := demoname + '.lmp';

  i := M_CheckParm ('-maxdemo');
  if (i <> 0) and (i < myargc - 1) then
    maxsize := atoi(myargv[i + 1]) * 1024
  else
    maxsize := $80000; // JVAL Originally was $20000

  repeat
    demobuffer := Z_Malloc2(maxsize, PU_STATIC, nil);
    if demobuffer = nil then
      maxsize := maxsize * 3 div 4;
  until demobuffer <> nil;

  demoend := @demobuffer[maxsize];

  demorecording := true;
  Info_Init(true); // JVAL: Start thinkers

end;

const
  DEMOHDR: integer = $4F4D4544; // JVAL: DEMO in hex

//==============================================================================
//
// G_BeginRecording
//
//==============================================================================
procedure G_BeginRecording;
var
  i: integer;
begin
  demo_p := demobuffer;

  PInteger(demo_p)^ := DEMOHDR;
  demo_p := @demo_p[4];

  demo_p[0] := VERSION;
  demo_p := @demo_p[1];

  demo_p[0] := Ord(gameskill);
  demo_p := @demo_p[1];

  demo_p[0] := gameepisode;
  demo_p := @demo_p[1];

  demo_p[0] := gamemap;
  demo_p := @demo_p[1];

  demo_p[0] := deathmatch;
  demo_p := @demo_p[1];

  demo_p[0] := intval(respawnparm);
  demo_p := @demo_p[1];

  demo_p[0] := intval(fastparm);
  demo_p := @demo_p[1];

  demo_p[0] := intval(nomonsters);
  demo_p := @demo_p[1];

  demo_p[0] := intval(compatibilitymode);
  demo_p := @demo_p[1];

  demo_p[0] := intval(spawnrandommonsters);
  demo_p := @demo_p[1];

  demo_p[0] := consoleplayer;
  demo_p := @demo_p[1];

  for i := 0 to MAXPLAYERS - 1 do
  begin
    demo_p[0] := intval(playeringame[i]);
    demo_p := @demo_p[1];
  end;

end;

//
// G_PlayDemo
//
var
  defdemoname: string;
  externaldemo: boolean = false;

//==============================================================================
//
// G_DoPlayExternalDemo
//
//==============================================================================
function G_DoPlayExternalDemo(const name: string): boolean;
var
  dmname: string;
begin
  dmname := name;
  if not fexists(dmname) then
    if M_CheckParmCDROM then
      dmname := CD_WORKDIR + dmname;
  if fexists(dmname) then
  begin
    externaldemo := true;
    defdemoname := dmname;
    gameaction := ga_playdemo;
    printf('Playing demo %s'#13#10, [defdemoname]);
    result := true;
    exit;
  end;
  result := false;
end;

//==============================================================================
//
// G_DeferedPlayDemo
//
//==============================================================================
function G_DeferedPlayDemo(const name: string): boolean;
var
  dmname: string;
  dmname2: string;
  defdemoname8: char8_t;
  i: integer;
  pdot: integer;
begin
  dmname := name;
  for i := 0 to 9 do
    if itoa(i) = name then
    begin
      sprintf(dmname, 'demo%d', [i]);
      break;
    end;

  pdot := Pos('.', dmname);
  if ((Length(dmname) <= 8) and (pdot = 0)) or ((pdot < 9) and (pdot <> 0)) then
  begin
    ExtractFileBase8(dmname, defdemoname8);
    defdemoname := char8tostring(defdemoname8);
    if W_CheckNumForName(defdemoname) >= 0 then
    begin
      externaldemo := false;
      gameaction := ga_playdemo;
      printf('Playing demo %s'#13#10, [defdemoname]);
      result := true;
      exit;
    end;
  end;

  // JVAL
  // Playdemo command also looks for a filename in current or CD_WORK directory
  dmname2 := dmname;
  if pdot = 0 then
    dmname := dmname + '.lmp';
  if G_DoPlayExternalDemo(dmname) then
  begin
    result := true;
    exit;
  end;

  if pdot = 0 then
  begin
    dmname := dmname2 + '.dem';
    if G_DoPlayExternalDemo(dmname) then
    begin
      result := true;
      exit;
    end;
  end;

  result := false;
end;

//==============================================================================
//
// G_CmdPlayDemo
//
//==============================================================================
procedure G_CmdPlayDemo(const name: string);
begin
  if G_DeferedPlayDemo(name) then
    C_ExecuteCmd('closeconsole', '1');
end;

var
  demoversion: byte;
  demotickstart: pointer = nil;

//==============================================================================
//
// G_DoPlayDemo
//
//==============================================================================
procedure G_DoPlayDemo;
var
  skill: skill_t;
  i, episode, map: integer;
  lump: integer;
  len: integer;
  oldspawnrandommonsters: boolean;
begin
  gameaction := ga_nothing;
  if externaldemo then
    len := M_ReadFile(defdemoname, pointer(demobuffer))
  else
  begin
    lump := W_GetNumForName(defdemoname);
    demobuffer := W_CacheLumpNum(lump, PU_STATIC);
    len := W_LumpLength(lump);
  end;

  demo_p := demobuffer;
  demoend := @demo_p[len];

  if PInteger(demo_p)^ = DEMOHDR then
  begin
    demo_p := @demo_p[4];
    demoversion := demo_p[0];
  end
  else
  begin
    demoversion := demobuffer[0];
    olddemo := (demoversion <= 99 {110 jval: Wolf}) and (demoversion >= 100);
    if olddemo then
      I_Warning('G_DoPlayDemo(): Playing demo from partial compatible version = %d.%d'#13#10,
        [demo_p[0] div 100, demo_p[0] mod 100])
    else if demo_p[0] <> VERSION then
    begin
      I_Warning('G_DoPlayDemo(): Demo is from an unsupported game version = %d.%d' + #13#10,
        [demo_p[0] div 100, demo_p[0] mod 100]);
      gameaction := ga_nothing;
      exit;
    end;
  end;

  demo_p := @demo_p[1];

  skill := skill_t(demo_p[0]);
  demo_p := @demo_p[1];

  episode := demo_p[0];
  demo_p := @demo_p[1];

  map := demo_p[0];
  demo_p := @demo_p[1];

  deathmatch := demo_p[0];
  demo_p := @demo_p[1];

  respawnparm := demo_p[0] <> 0;
  demo_p := @demo_p[1];

  fastparm := demo_p[0] <> 0;
  demo_p := @demo_p[1];

  nomonsters := demo_p[0] <> 0;
  demo_p := @demo_p[1];

  oldcompatibilitymode := compatibilitymode;
  if olddemo then
    compatibilitymode := true // force old compatibility mode
  else
  begin
    compatibilitymode := demo_p[0] <> 0;
    demo_p := @demo_p[1];
  end;

  oldspawnrandommonsters := spawnrandommonsters;
  spawnrandommonsters := demo_p[0] <> 0;
  demo_p := @demo_p[1];

  consoleplayer := demo_p[0];
  demo_p := @demo_p[1];

  for i := 0 to MAXPLAYERS - 1 do
  begin
    playeringame[i] := demo_p[0] <> 0;
    demo_p := @demo_p[1];
  end;

  if playeringame[1] then
  begin
    netgame := true;
    netdemo := true;
  end;

  preparingdemoplayback := true;
  // don't spend a lot of time in loadlevel if not singledemo
  precache := singledemo; // JVAL original code: precache := false
  G_InitNew(skill, episode, map);
  preparingdemoplayback := false;
  spawnrandommonsters := oldspawnrandommonsters;  // Back to default
  precache := true;
  usergame := false;
  demoplayback := true;
  demotickstart := demo_p;
  Info_Init(true); // JVAL: Start thinkers

  compatibility_done := false;

end;

//==============================================================================
//
// G_TimeDemo
//
//==============================================================================
procedure G_TimeDemo(const name: string);
begin
  timingdemo := true;
  singletics := true;

  defdemoname := name;
  gameaction := ga_playdemo;
end;

(*
===================
=
= G_CheckDemoStatus
=
= Called after a death or level completion to allow demos to be cleaned up
= Returns true if a new demo loop action will take place
===================
*)

//==============================================================================
//
// G_CheckDemoStatus
//
//==============================================================================
function G_CheckDemoStatus: boolean;
var
  endtime: integer;
  i: integer;
begin
  if timingdemo then
  begin
    endtime := I_GetTime;
    I_Error('G_CheckDemoStatus(): timed %d gametics in %d realtics', [gametic, endtime - starttime]);
  end;

  if demoplayback then
  begin
    if singledemo then
      I_Quit;

    Z_Free(demoBuffer);
    G_FinishedDemoPlayback;
    netdemo := false;
    netgame := false;
    deathmatch := 0;
    for i := 1 to MAXPLAYERS - 1 do
      playeringame[i] := false;
    respawnparm := false;
    fastparm := false;
    nomonsters := false;
    consoleplayer := 0;
    D_AdvanceDemo;
    result := true;
    exit;
  end;

  if demorecording then
  begin
    demo_p[0] := DEMOMARKER;
    demo_p := @demo_p[1];

    M_WriteFile(demoname, demobuffer, pDiff(demo_p, demobuffer, SizeOf(byte)));
    Z_Free(demobuffer);
    demorecording := false;
    I_Error('G_CheckDemoStatus(): Demo %s recorded', [demoname]);
  end;

  result := false;
end;

//==============================================================================
//
// G_IsOldDemoPlaying
//
//==============================================================================
function G_IsOldDemoPlaying: boolean;
begin
  result := demoplayback and olddemo;
end;

//==============================================================================
//
// G_NeedsCompatibilityMode
//
//==============================================================================
function G_NeedsCompatibilityMode: boolean;
begin
  result := compatibilitymode or (demoplayback and olddemo);
end;

//==============================================================================
//
// G_Quit
//
//==============================================================================
procedure G_Quit;
begin
  I_Quit;
end;

initialization

  forwardmove[0] := 12;
  forwardmove[1] := 18;
  sidemove[0] := 8;
  sidemove[1] := 12;
  angleturn[0] := 500;
  angleturn[1] := 1000;
  angleturn[2] := 250;

  mousebuttons := PBooleanArray(@mousearray[0]);
  joybuttons := PBooleanArray(@joyarray[0]);

  precache := true;

end.

