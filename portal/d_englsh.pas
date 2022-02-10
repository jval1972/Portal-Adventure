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

unit d_englsh;

interface

var
  D_DEVSTR: string =
    'Development mode ON.' + #13#10;
  D_CDROM: string =
    'CD-ROM Version: Doom32.ini from c:\doomdata' + #13#10;

//
//  M_Menu.C
//
  PRESSKEY: string =
    'press a key.';
  PRESSYN: string =
    'press y or n.';

  QUITMSG: string =
    'are you sure you want to' + #13#10 +
    'quit this great game?';

  LOADNET: string =
    'you can''t do load while in a net game!' + #13#10;

  QLOADNET: string =
    'you can''t quickload during a netgame!' + #13#10;

  QSAVESPOT: string =
    'you haven''t picked a quicksave slot yet!' + #13#10;

  SAVEDEAD: string =
    'you can''t save if you aren''t playing!' + #13#10;

  QSPROMPT: string =
    'quicksave over your game named' + #13#10 + #13#10 +
    '''%s''?' + #13#10;

  QLPROMPT: string =
    'do you want to quickload the game named' + #13#10 + #13#10 +
    '''%s''?' + #13#10;

  SNEWGAME: string =
    'you can''t start a new game' + #13#10 +
    'while in a network game.' + #13#10;

  SNIGHTMARE: string =
    'are you sure? this skill level' + #13#10 +
    'isn''t even remotely fair.';

  SWSTRING: string =
    'this is the shareware version of doom.' + #13#10 +
    'you need to order the entire trilogy.';

  MSGOFF: string =
    'Messages OFF';
  MSGON: string =
    'Messages ON';

  NETEND: string =
    'you can''t end a netgame!' + #13#10;
  SENDGAME : string =
    'are you sure you want to end the game?' + #13#10;

  DOSY: string =
    '(press y to quit)';

var
  DETAILULTRA: string = 'Ultra detail';
  DETAILHI: string = 'High detail';
  DETAILNORM: string = 'Normal detail';
  DETAILMED: string = 'Medium detail';
  DETAILLOW: string = 'Low detail';
  DETAILLOWEST: string = 'Lowest detail';
  GAMMALVL0: string = 'Gamma correction OFF';
  GAMMALVL1: string = 'Gamma correction level 1';
  GAMMALVL2: string = 'Gamma correction level 2';
  GAMMALVL3: string = 'Gamma correction level 3';
  GAMMALVL4: string = 'Gamma correction level 4';
  EMPTYSTRING: string = 'empty slot';

//
//  P_inter.C
//
var
  GOTARMOR: string = 'Picked up the armor.';
  GOTMEGA: string = 'Picked up the MegaArmor!';
  GOTHTHBONUS: string = 'Picked up a health bonus.';
  GOTARMBONUS: string = 'Picked up an armor bonus.';
  GOTSTIM: string = 'Picked up a stimpack.';
  GOTMEDINEED: string = 'Picked up a medikit that you REALLY need!';
  GOTMEDIKIT: string = 'Picked up a medikit.';
  GOTSUPER: string = 'Supercharge!';

  GOTBLUECARD: string = 'Picked up a blue keycard.';
  GOTYELWCARD: string = 'Picked up a yellow keycard.';
  GOTREDCARD: string = 'Picked up a red keycard.';
  GOTBLUESKUL: string = 'Picked up a blue skull key.';
  GOTYELWSKUL: string = 'Picked up a yellow skull key.';
  GOTREDSKULL: string = 'Picked up a red skull key.';

  GOTINVUL: string = 'Invulnerability!';
  GOTBERSERK: string = 'Berserk!';
  GOTINVIS: string = 'Partial Invisibility';
  GOTSUIT: string = 'Radiation Shielding Suit';
  GOTMAP: string = 'Computer Area Map';
  GOTVISOR: string = 'Light Amplification Visor';
  GOTMSPHERE: string = 'MegaSphere!';

  GOTCLIP: string = 'Picked up a clip.';
  GOTCLIPBOX: string = 'Picked up a box of bullets.';
  GOTROCKET: string = 'Picked up a rocket.';
  GOTROCKBOX: string = 'Picked up a box of rockets.';
  GOTCELL: string = 'Picked up an energy cell.';
  GOTCELLBOX: string = 'Picked up an energy cell pack.';
  GOTSHELLS: string = 'Picked up 4 shotgun shells.';
// JVAL: 7/12/2007 Correctly display the amound of picked-up shells
  GOTONESHELL: string = 'Picked up a shotgun shell.';
  GOTMANYSHELLS: string = 'Picked up %d shotgun shells.';

  GOTSHELLBOX: string = 'Picked up a box of shotgun shells.';
  GOTBACKPACK: string = 'Picked up a backpack full of ammo!';

  GOTBFG9000: string = 'You got the BFG9000!  Oh, yes.';
  GOTCHAINGUN: string = 'You got the chaingun!';
  GOTCHAINSAW: string = 'A chainsaw!  Find some meat!';
  GOTLAUNCHER: string = 'You got the rocket launcher!';
  GOTPLASMA: string = 'You got the plasma gun!';
  GOTSHOTGUN: string = 'You got the shotgun!';
  GOTSHOTGUN2: string = 'You got the super shotgun!';

  MSGSECRETSECTOR: string = 'You found a secret area.';

//
// P_Doors.C
//
var
  PD_BLUEO: string = 'You need a blue key to activate this object';
  PD_REDO: string = 'You need a red key to activate this object';
  PD_YELLOWO: string = 'You need a yellow key to activate this object';
  PD_BLUEK: string = 'You need a blue key to open this door';
  PD_REDK: string = 'You need a red key to open this door';
  PD_YELLOWK: string = 'You need a yellow key to open this door';
//jff 02/05/98 Create messages specific to card and skull keys
  PD_BLUEC: string = 'You need a blue card to open this door';
  PD_REDC: string = 'You need a red card to open this door';
  PD_YELLOWC: string = 'You need a yellow card to open this door';
  PD_BLUES: string = 'You need a blue skull to open this door';
  PD_REDS: string = 'You need a red skull to open this door';
  PD_YELLOWS: string = 'You need a yellow skull to open this door';
  PD_ANY: string = 'Any key will open this door';
  PD_ALL3: string = 'You need all three keys to open this door';
  PD_ALL6: string = 'You need all six keys to open this door';

//
// G_game.C
//
var
  GGSAVED: string = 'game saved.';

const
//
//  HU_stuff.C
//

  HUSTR_E1M1 = 'E1M1: Hangar';
  HUSTR_E1M2 = 'E1M2: Nuclear Plant';
  HUSTR_E1M3 = 'E1M3: Toxin Refinery';
  HUSTR_E1M4 = 'E1M4: Command Control';
  HUSTR_E1M5 = 'E1M5: Phobos Lab';
  HUSTR_E1M6 = 'E1M6: Central Processing';
  HUSTR_E1M7 = 'E1M7: Computer Station';
  HUSTR_E1M8 = 'E1M8: Phobos Anomaly';
  HUSTR_E1M9 = 'E1M9: Military Base';

  HUSTR_E2M1 = 'E2M1: Deimos Anomaly';
  HUSTR_E2M2 = 'E2M2: Containment Area';
  HUSTR_E2M3 = 'E2M3: Refinery';
  HUSTR_E2M4 = 'E2M4: Deimos Lab';
  HUSTR_E2M5 = 'E2M5: Command Center';
  HUSTR_E2M6 = 'E2M6: Halls of the Damned';
  HUSTR_E2M7 = 'E2M7: Spawning Vats';
  HUSTR_E2M8 = 'E2M8: Tower of Babel';
  HUSTR_E2M9 = 'E2M9: Fortress of Mystery';

  HUSTR_E3M1 = 'E3M1: Hell Keep';
  HUSTR_E3M2 = 'E3M2: Slough of Despair';
  HUSTR_E3M3 = 'E3M3: Pandemonium';
  HUSTR_E3M4 = 'E3M4: House of Pain';
  HUSTR_E3M5 = 'E3M5: Unholy Cathedral';
  HUSTR_E3M6 = 'E3M6: Mt. Erebus';
  HUSTR_E3M7 = 'E3M7: Limbo';
  HUSTR_E3M8 = 'E3M8: Dis';
  HUSTR_E3M9 = 'E3M9: Warrens';

  HUSTR_E4M1 = 'E4M1: Hell Beneath';
  HUSTR_E4M2 = 'E4M2: Perfect Hatred';
  HUSTR_E4M3 = 'E4M3: Sever The Wicked';
  HUSTR_E4M4 = 'E4M4: Unruly Evil';
  HUSTR_E4M5 = 'E4M5: They Will Repent';
  HUSTR_E4M6 = 'E4M6: Against Thee Wickedly';
  HUSTR_E4M7 = 'E4M7: And Hell Followed';
  HUSTR_E4M8 = 'E4M8: Unto The Cruel';
  HUSTR_E4M9 = 'E4M9: Fear';

  HUSTR_1 = 'level 1: entryway';
  HUSTR_2 = 'level 2: underhalls';
  HUSTR_3 = 'level 3: the gantlet';
  HUSTR_4 = 'level 4: the focus';
  HUSTR_5 = 'level 5: the waste tunnels';
  HUSTR_6 = 'level 6: the crusher';
  HUSTR_7 = 'level 7: dead simple';
  HUSTR_8 = 'level 8: tricks and traps';
  HUSTR_9 = 'level 9: the pit';
  HUSTR_10 = 'level 10: refueling base';
  HUSTR_11 = 'level 11: ''o'' of destruction!';

  HUSTR_12 = 'level 12: the factory';
  HUSTR_13 = 'level 13: downtown';
  HUSTR_14 = 'level 14: the inmost dens';
  HUSTR_15 = 'level 15: industrial zone';
  HUSTR_16 = 'level 16: suburbs';
  HUSTR_17 = 'level 17: tenements';
  HUSTR_18 = 'level 18: the courtyard';
  HUSTR_19 = 'level 19: the citadel';
  HUSTR_20 = 'level 20: gotcha!';

  HUSTR_21 = 'level 21: nirvana';
  HUSTR_22 = 'level 22: the catacombs';
  HUSTR_23 = 'level 23: barrels o'' fun';
  HUSTR_24 = 'level 24: the chasm';
  HUSTR_25 = 'level 25: bloodfalls';
  HUSTR_26 = 'level 26: the abandoned mines';
  HUSTR_27 = 'level 27: monster condo';
  HUSTR_28 = 'level 28: the spirit world';
  HUSTR_29 = 'level 29: the living end';
  HUSTR_30 = 'level 30: icon of sin';

  HUSTR_31 = 'level 31: wolfenstein';
  HUSTR_32 = 'level 32: grosse';

  PHUSTR_1 = 'level 1: congo';
  PHUSTR_2 = 'level 2: well of souls';
  PHUSTR_3 = 'level 3: aztec';
  PHUSTR_4 = 'level 4: caged';
  PHUSTR_5 = 'level 5: ghost town';
  PHUSTR_6 = 'level 6: baron''s lair';
  PHUSTR_7 = 'level 7: caughtyard';
  PHUSTR_8 = 'level 8: realm';
  PHUSTR_9 = 'level 9: abattoire';
  PHUSTR_10 = 'level 10: onslaught';
  PHUSTR_11 = 'level 11: hunted';

  PHUSTR_12 = 'level 12: speed';
  PHUSTR_13 = 'level 13: the crypt';
  PHUSTR_14 = 'level 14: genesis';
  PHUSTR_15 = 'level 15: the twilight';
  PHUSTR_16 = 'level 16: the omen';
  PHUSTR_17 = 'level 17: compound';
  PHUSTR_18 = 'level 18: neurosphere';
  PHUSTR_19 = 'level 19: nme';
  PHUSTR_20 = 'level 20: the death domain';

  PHUSTR_21 = 'level 21: slayer';
  PHUSTR_22 = 'level 22: impossible mission';
  PHUSTR_23 = 'level 23: tombstone';
  PHUSTR_24 = 'level 24: the final frontier';
  PHUSTR_25 = 'level 25: the temple of darkness';
  PHUSTR_26 = 'level 26: bunker';
  PHUSTR_27 = 'level 27: anti-christ';
  PHUSTR_28 = 'level 28: the sewers';
  PHUSTR_29 = 'level 29: odyssey of noises';
  PHUSTR_30 = 'level 30: the gateway of hell';

  PHUSTR_31 = 'level 31: cyberden';
  PHUSTR_32 = 'level 32: go 2 it';

  THUSTR_1 = 'level 1: system control';
  THUSTR_2 = 'level 2: human bbq';
  THUSTR_3 = 'level 3: power control';
  THUSTR_4 = 'level 4: wormhole';
  THUSTR_5 = 'level 5: hanger';
  THUSTR_6 = 'level 6: open season';
  THUSTR_7 = 'level 7: prison';
  THUSTR_8 = 'level 8: metal';
  THUSTR_9 = 'level 9: stronghold';
  THUSTR_10 = 'level 10: redemption';
  THUSTR_11 = 'level 11: storage facility';

  THUSTR_12 = 'level 12: crater';
  THUSTR_13 = 'level 13: nukage processing';
  THUSTR_14 = 'level 14: steel works';
  THUSTR_15 = 'level 15: dead zone';
  THUSTR_16 = 'level 16: deepest reaches';
  THUSTR_17 = 'level 17: processing area';
  THUSTR_18 = 'level 18: mill';
  THUSTR_19 = 'level 19: shipping/respawning';
  THUSTR_20 = 'level 20: central processing';

  THUSTR_21 = 'level 21: administration center';
  THUSTR_22 = 'level 22: habitat';
  THUSTR_23 = 'level 23: lunar mining project';
  THUSTR_24 = 'level 24: quarry';
  THUSTR_25 = 'level 25: baron''s den';
  THUSTR_26 = 'level 26: ballistyx';
  THUSTR_27 = 'level 27: mount pain';
  THUSTR_28 = 'level 28: heck';
  THUSTR_29 = 'level 29: river styx';
  THUSTR_30 = 'level 30: last call';

  THUSTR_31 = 'level 31: pharaoh';
  THUSTR_32 = 'level 32: caribbean';

  HUSTR_CHATMACRO1 = 'I''m ready to kick butt!';
  HUSTR_CHATMACRO2 = 'I''m OK.';
  HUSTR_CHATMACRO3 = 'I''m not looking too good!';
  HUSTR_CHATMACRO4 = 'Help!';
  HUSTR_CHATMACRO5 = 'You suck!';
  HUSTR_CHATMACRO6 = 'Next time, scumbag...';
  HUSTR_CHATMACRO7 = 'Come here!';
  HUSTR_CHATMACRO8 = 'I''ll take care of it.';
  HUSTR_CHATMACRO9 = 'Yes';
  HUSTR_CHATMACRO0 = 'No';

var
  HUSTR_TALKTOSELF1: string = 'You mumble to yourself';
  HUSTR_TALKTOSELF2: string = 'Who''s there?';
  HUSTR_TALKTOSELF3: string = 'You scare yourself';
  HUSTR_TALKTOSELF4: string = 'You start to rave';
  HUSTR_TALKTOSELF5: string = 'You''ve lost it...';

  HUSTR_MESSAGESENT: string = '[Message Sent]';
  HUSTR_MSGU: string = '[Message unsent]';

  { The following should NOT be changed unless it seems }
  { just AWFULLY necessary }
  HUSTR_PLRGREEN: string = 'Green:';
  HUSTR_PLRINDIGO: string = 'Indigo:';
  HUSTR_PLRBROWN: string = 'Brown:';
  HUSTR_PLRRED: string = 'Red:';

  HUSTR_KEYGREEN: string = 'g';
  HUSTR_KEYINDIGO: string = 'i';
  HUSTR_KEYBROWN: string = 'b';
  HUSTR_KEYRED: string = 'r';

//
//  AM_map.C
//
  AMSTR_FOLLOWON: string = 'Follow Mode ON';
  AMSTR_FOLLOWOFF: string = 'Follow Mode OFF';
  AMSTR_GRIDON: string = 'Grid ON';
  AMSTR_GRIDOFF: string = 'Grid OFF';
  AMSTR_ROTATEON: string = 'Rotate ON';
  AMSTR_ROTATEOFF: string = 'Rotate OFF';
  AMSTR_MARKEDSPOT: string = 'Marked Spot';
  AMSTR_MARKSCLEARED: string = 'All Marks Cleared';

//
//  ST_stuff.C
//
  STSTR_MUS: string = 'Music Change';
  STSTR_NOMUS: string = 'IMPOSSIBLE SELECTION';
  STSTR_DQDON: string = 'Degreelessness Mode On';
  STSTR_DQDOFF: string = 'Degreelessness Mode Off';
  STSTR_LGON: string = 'Low Gravity Mode On';
  STSTR_LGOFF: string = 'Low Gravity Mode Off';

  STSTR_KEYSADDED: string = 'Keys Added';
  STSTR_KFAADDED: string = 'Very Happy Ammo Added';
  STSTR_FAADDED: string = 'Ammo (no keys) Added';

  STSTR_NCON: string = 'No Clipping Mode ON';
  STSTR_NCOFF: string = 'No Clipping Mode OFF';

  STSTR_BEHOLD: string = 'inVuln, Str, Inviso, Rad, Allmap, or Lite-amp';
  STSTR_BEHOLDX: string = 'Power-up Toggled';

  STSTR_CHOPPERS: string = '... doesn''t suck - GM';
  STSTR_CLEV: string = 'Changing Level...';

  STSTR_WLEV: string = 'Level specified not found';

  STSTR_MASSACRE: string = 'Massacre';

const
//
// Character cast strings F_FINALE.C
//
  CC_ZOMBIE  = 'ZOMBIEMAN';
  CC_SHOTGUN = 'SHOTGUN GUY';
  CC_HEAVY = 'HEAVY WEAPON DUDE';
  CC_IMP = 'IMP';
  CC_DEMON = 'DEMON';
  CC_LOST = 'LOST SOUL';
  CC_CACO = 'CACODEMON';
  CC_HELL = 'HELL KNIGHT';
  CC_BARON = 'BARON OF HELL';
  CC_ARACH = 'ARACHNOTRON';
  CC_PAIN = 'PAIN ELEMENTAL';
  CC_REVEN = 'REVENANT';
  CC_MANCU = 'MANCUBUS';
  CC_ARCH = 'ARCH-VILE';
  CC_SPIDER = 'THE SPIDER MASTERMIND';
  CC_CYBER = 'THE CYBERDEMON';
  CC_HERO = 'OUR HERO';

implementation

end.

