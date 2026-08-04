# Context

*Temptations* (Topo Soft, 1988, MSX1) — disassembly context.

Reference document for anyone (human or agent) working on this project.
Everything here is **verified**; anything that is a hypothesis is marked
with "(?)".

## The game

MSX exclusive. There is no ZX Spectrum, Amstrad CPC or C64 version — don't go
looking for POKEs from other platforms, there aren't any.

- Code and graphics: **Luis Lopez Navarro** ("LuigiLopez")
- Music: **Gominolas** (Cesar Astudillo)
- Loading screen: Javier Cano (attribution disputed)
- Cover art: Alfonso Azpiri
- Publisher: Erbe Software, tape, Spain, 1988. Micromania issue 34 gave it an 8.

Single-screen (flick-screen) platformer. The player character shoots chests and
skulls to reveal items: fireballs, crystals, auto-repeat arrows, extra lives and
little wings that let you fly. One hit kills him. Sideways movement has inertia.

**Structure (confirmed by the user, a fan of the game): 4 levels x 7 screens
= 28 screens.** It matches the `mod 7` that the status bar routine does.
On **level 4** the player's sprite changes and becomes a **fish**: it is an
underwater level, **no gravity**, you can float.

The main character's name: the manual calls him "Hermano Nonato (Noni)"
(Brother Nonato), but the game's own ending text says "FRAY ARNULFO"
(Friar Arnulfo). A genuine discrepancy, unresolved.

Sound: the music only plays on the intro and the menu. During play the same
player is reused for sound effects (confirmed by the user).

## Controls (manual + verified in the code)

| | Keyboard | Joystick |
|---|---|---|
| Left / Right / Jump | cursor keys | stick |
| Fire | SPACE | button |
| Quit | CTRL+STOP | CTRL+STOP |

There is no key redefinition: the game never calls `SNSMAT` (0x0141). It reads
`GTSTCK` (0x00D5) with A=1 (joystick) and A=0 (cursor keys) and ORs the two
together; same with `GTTRIG` (0x00D8). Verified example at 0x818C.

## Load chain (verified end to end in openMSX)

The TSX contains 12 blocks. The KCS ones (0x4B) carry the bytes already
demodulated, so the extraction is exact and there is no audio to decode.

| File | Load | Run | Size | What it is |
|---|---|---|---|---|
| `TEMPT` (ASCII) | — | — | 256 B | BASIC loader: `COLOR 1,1,1:SCREEN 2` + two `BLOAD"cas:",R` |
| `TOPO` (BIN) | 0x9470 | 0x9470 | 4254 B | Topo Soft logo |
| `SLOTS` (BIN) | 0xC350 | 0xC58F | 700 B | Finds RAM in the slots + turbo loader |
| turbo 1 (block 0x10) | 0x88B8 | 0x88B8 | 12388 B | Title screen |
| turbo 2 (block 0x10) | 0x4000 | **0x8000** | 40449 B | The game |

The turbo blocks have **one 0x00 byte in front and one XOR checksum byte
behind** (the XOR of data+checksum comes out 0). Verified by comparing the RAM
dumped by openMSX against the bytes in the TSX: identical with an offset of 1.

Turbo block 2 (0x4000..0xDE00) **overwrites** turbo 1, which by then has already
done its job.

## Memory map with the game running

    0x0000-0x3FFF   BASIC ROM. It is NOT switched to RAM: the game keeps calling
                    the BIOS (INIGRP, LDIRVM, WRTVRM, GTSTCK, GTTRIG...).
                    Verified: a 100% match with the VG-8020 ROM.
    0x4000-0x7FFF   Game graphics and data
    0x8000-0xDE00   Game code + variables
    0x8FFF          Stack
    0xFD9F          BIOS H.TIMI hook: the game writes `jp 0xD000` there

## Identified data

| Range | What it is |
|---|---|
| 0x4000-0x47FF | Pattern table (font): 256 glyphs x 8 bytes |
| 0x4800-0x4FFF | Colour table |
| 0x5000-0x57FF | Sprite patterns (they go to VRAM 0x3800) |
| 0x5CC0-0x5FBF | Name table for the intro screen (32x24) |
| 0x5FC0-0x60FF | Status bar template (goes to VRAM 0x1A00, rows 16-23) |
| 0xD513-0xD530 | Jump table for the player's 15 commands (0x80..0x8E) |
| 0xD53E-0xD5C7 | Structures for the 3 PSG channels, 46 bytes each |
| 0xD760 / 0xD891 / 0xD8F8 | Menu tunes, channels 0/1/2 |

## Game variables (0x8F00-0x8F2F)

| Address | Variable | How it was verified |
|---|---|---|
| 0x8F09 / 0x8F0A | Player X / Y | init 0x80 / 0x68 at 0x80CE / 0x80D6 |
| 0x8F0D | Screen (global counter) | init 0 at 0x8114; drawn as `(value mod 7)+1` |
| 0x8F0E | Level | init 0xFF at 0x80F3; drawn `+1` |
| 0x8F12 | **LIVES** | watchpoint: only written at 0x80FD (A=9) and only read at 0x86A4 |
| 0x8F13 / 0x8F14 | Respawn X / Y | init 0x80 / 0x68 |
| 0x8F17 | Ammo icons | init 1 at 0x8102 |
| 0x8F18 | Weapon type | init 0 at 0x8107; tile = 0xF7 + 2*type |
| 0x8F1E | Anti-POKE trap flag | see below |

## Identified routines

| Address | Routine |
|---|---|
| 0x8000 | Game entry point |
| 0x805E | Border colour, sprites and turn the display on |
| 0x8076 | Main initialisation |
| 0x8117 | **Main game loop** (two frames per iteration) |
| 0x818C | Reads the controls (GTSTCK joystick + cursor keys, OR) |
| 0x84CC | Takes a life away: `dec a / cp 0FFh / jp z,0x8C1E` (game over) |
| 0x8528 | Gives a life: `inc a / cp 0Ah / ret z` (caps at 10) |
| 0x8698 | **Draws the status bar** (lives / screen / level) |
| 0x8B80 | Shows the anti-POKE message if 0x8F1E != 0 |
| 0x8C1E | Game over |
| 0xD000 | Interrupt routine (60 Hz), hooked into H.TIMI |
| 0xD041 | Assigns the sound data at DE to channel A |
| 0xD060 | Advances the 3 channels by one tick |
| 0xD431 | Indexes a jump table: HL = word at (HL + A*2) |
| 0xDA00 | Main menu: music + wait for fire |
| 0xDB00 | Per-frame routine (called twice per loop iteration) |

VRAM cells the status bar writes to:
`0x1A68` = LIVES digit, `0x1A7D` = SCREEN, `0x1ABB` = LEVEL,
`0x1AA2` = ammo strip.

## The anti-POKE trap

At 0x7F94 there is the string `POR QUE NO PRUEBAS SIN POKES` ("why don't you try
without POKEs"). It is shown by the routine at 0x8B80, which only does so if the
variable 0x8F1E is non-zero.

The interesting part: **no instruction in the binary ever writes to 0x8F1E**
(neither `32 1E 8F` nor any equivalent shows up) and in the clean tape image it
is 0. It is a dormant trap that never fires in the original game, and that would
only be triggered if somebody poked that byte. It is not documented anywhere.

## The game's character set

**It is not ASCII.** Verified two independent ways: by rendering the glyphs from
the pattern table, and because the code itself does `ld b,05Ch / add a,b` to turn
a number into a digit.

    space    0x00        (not 0x20!)
    A..Z     0x41..0x5A  (normal ASCII position)
    0..9     0x5C..0x65  (shifted)
    "        0x68
    .        0x6A
    ,        0x6B
    :        0x6C
    -        0x6D

A verified curiosity: the codes 'U' (0x55) and 'V' (0x56) draw **the same
glyph**, which is why the text data stores "PVES", "NUEUO", "MVSICA" or "NIUEL"
and it still reads fine on screen.

Game text: `PANTALLA:` (0x6034, "SCREEN:"), ` NIVEL:` (0x7F80, "LEVEL:"),
`ACABOSE` (0x7F8B, roughly "it's all over"),
`POR QUE NO PRUEBAS SIN POKES` (0x7F94), and the ending at 0xC93B:
`ALELUYA, OH FRAY ARNULFO / SUPERANDO TODOS LOS PELIGROS DEL MAL HAS GANADO EL
CIELO / "SOLUM VICTORIUS EST GLORIA" / TE ATREVERAS CON "ALEHOP"`.
(Roughly: "Hallelujah, oh Friar Arnulfo / by overcoming all the perils of evil
you have won heaven / 'SOLUM VICTORIUS EST GLORIA' / will you dare take on
'ALEHOP'" — Alehop being another Topo Soft game.)

## Project tools

| Tool | What for |
|---|---|
| `tools/tsx_parse.py` | Parses the TSX and extracts the files |
| `tools/z80trace.py` | Recursive tracer: separates code from data by following the flow |
| `tools/mkasm.py` | Generates the commented listing from the trace + the notes |
| `tools/charset.py` | The game's character set and a text finder |
| `tools/gen_msx_syms.py` | MSX BIOS symbol table (from MSXgl) |
| `tools/dasm_slice.py` | Disassembles in sections with different ORGs (for SLOTS) |
| `tools/omsx_*.tcl` | openMSX harness: loading, savestates, watchpoints, PC sampling |

Data files: `dump/turbo2_ram.bin` is the game exactly as it ends up in RAM
(org 0x4000, 40449 bytes); `src/game.notes` holds the address-anchored
annotations; `src/temptations_game.asm` is the generated listing.

**openMSX savestate**: `tempt_boot` (the game right as it starts at 0x8000).
Saves reloading the 7 minutes of tape for every test.

## Level structure (verified in the code)

The routine at 0x8B09 compares the screen counter (0x8F0D) against 6, 13, 20 and
27. Those are the last screens of each level, that is, **4 levels of 7 screens**:

    level 1 -> screens  0..6
    level 2 -> screens  7..13
    level 3 -> screens 14..20     (0x8B29: switches the sprite bank)
    level 4 -> screens 21..27     (0x8B55: turns float mode on)
    screen 28                     the victory one

The **underwater level 4** is at 0x8B55: it sets flag 0x8F11 to 1 (float, no
gravity), the animation state to 0x0B (swim) and the border to colour 12.

## Screen maps

29 consecutive 512-byte blocks starting at **0x9000** (32 columns x 16 rows, one
tile byte per cell, row by row). The routine at 0x8ACE computes
`0x9000 + screen*512` and copies 512 bytes to the buffer at 0x7D80.

VERIFIED: with the game frozen on screen 0, the 512 bytes at 0x9000 match byte
for byte (512/512) with VRAM 0x1800-0x19FF and with the buffer at 0x7D80.

## Animation and physics table (0x60C0)

128-byte entries indexed by `state*128 + step*4`. Each frame is 4 bytes: signed
dX and dY, the pattern number divided by 4, and the sprite's two colours packed
together. A dX of 0x80 ends the sequence. 0x82BE reads it.
It is used both by the player (states 0-13) and by the enemies (16-48).

## The punishment for cheating

The string "POR QUE NO PRUEBAS SIN POKES" (0x7F94) is not a stray message: the
routine at 0x8B80 writes it **over the last line of the final victory screen**
if the variable 0x8F1E is non-zero. It is a punishment reserved for anyone who
finishes the game by cheating.

But **no instruction in the binary ever writes to 0x8F1E**, so in the original
game it never fires: it was left armed in case somebody poked that byte.

## Infinite-lives POKE

The only published one is in "MSX Book II" (Paulisoft, Brazil, 1988, p. 62) and
says `POKE &HB4CC,0`. **It is a typo**: 0xB4CC is already 0 in the binary. The
right address is **0x84CC**, which holds 0x3D = DEC A in the routine that takes
a life away. Verified experimentally (tools/omsx_testpoke.tcl): without the patch
9->8, with the patch 9->9.

## State of the disassembly

**98.4% of the binary explained**: 5214 bytes of traced code and 34593 of
identified data; 642 bytes (1.6%) are left in small gaps.

Careful with the "12.9% code" figure: it does not mean the disassembly is
incomplete, it means this game is ~87% data (16 KB of graphics and 29 maps of
512 B).

0xCA00-0xD000 is **code from another build** that was left in the binary and
never runs. It disassembles cleanly because it is real code, and that is exactly
why it fooled a heuristic pointer-table detector.
