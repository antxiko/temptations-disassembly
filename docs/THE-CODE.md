# The code

A map of where everything lives. For the full listing of routines and data, see
[INVENTARIO.txt](INVENTARIO.txt).

## Memory map

With the game running, the MSX looks like this:

```
0x0000 ┌──────────────────────────┐
       │  BASIC ROM               │  NOT touched: the game keeps calling
       │                          │  the BIOS (drawing on screen, reading
0x4000 ├──────────────────────────┤  the joystick, moving blocks of memory)
       │  Graphics                │  font, colours, sprites
0x5C00 │  Menu screen             │
0x5FC0 │  Status bar              │
0x60C0 │  Animation and physics   │  50 slots of 128 bytes
0x79C0 │  Hidden spots            │  per screen
0x7BA0 │  Enemies                 │  per screen
0x7D80 │  Current map buffer      │  512 bytes
0x8000 ├──────────────────────────┤
       │  GAME CODE               │  ~5 KB
0x8F00 │  Variables               │
0x8FA0 │  Stack                   │  grows downwards from 0x8FFF
0x9000 ├──────────────────────────┤
       │  29 screen maps          │  512 bytes each
0xCA00 ├──────────────────────────┤
       │  (dead code)             │  leftovers from another build
0xD000 ├──────────────────────────┤
       │  Sound player            │
0xD760 │  Menu music              │
0xDB00 │  Per-frame routine       │
0xDE01 └──────────────────────────┘
```

Leaving the BASIC ROM in place is a design decision: the game leans on the
system routines for the common jobs instead of reimplementing them, and in
exchange it gives up 16 KB of memory.

## The main loop

The whole game fits in this:

```asm
BUCLE_PARTIDA:
    call 0832ah         ; ¿han pulsado CTRL+STOP?
    halt                ; espera al barrido de pantalla
    call 0db00h         ; efectos de sonido (motor PSG)
    halt
    call 0db00h
    call DISPARA
    call MUEVE_DISPAROS
    call MUEVE_ENEMIGOS
    call COMPRUEBA_COLISION_SPRITES
    ...
    call MUEVE_JUGADOR
    call COLISIONES_MAPA
    jp BUCLE_PARTIDA
```

Two `halt`s per loop means the game runs at **25 or 30 frames per second**, half
the display refresh rate. It is deliberate: it leaves enough time to move
everything without any visible stutter.

## How the monk moves

The joystick is translated into an **action code** through a table, and that code
is at once the animation index and the character's state:

| Joystick direction | Code | What it does |
|---|---|---|
| centre, down, down±diagonal | `0x00` | idle (there is no crouching) |
| right | `0x01` | walk right |
| left | `0x02` | walk left |
| up | `0x08` | vertical jump |
| up + right | `0x09` | jump right |
| up + left | `0x0A` | jump left |

Look at the numbers: **bit 3 means "I am jumping"** and bits 0 and 1 are the
direction. `0x09` is `0x08 | 0x01`. It is designed so each thing can be checked
separately with a mask.

## The animation and physics table

This is the neatest thing in the game. At `0x60C0` there are 50 slots of 128
bytes. Each slot is a sequence of frames, and each frame takes 4 bytes:

```
byte 0:  X displacement (signed)
byte 1:  Y displacement (signed)
byte 2:  pattern number
byte 3:  the sprite's two colours, one in each half of the byte
```

A `0x80` in the first byte marks the end of the sequence.

The interesting part is that **movement and drawing are the same table**. Gravity
is not a formula: it is a sequence of frames whose Y displacements keep growing.
Neither is the jump: it is another sequence. Changing how the character moves
means changing a few bytes of data, not touching code.

Slots 0 to 13 are the monk, and 16 to 48 the enemies, in pairs: slot N and slot
N+17 are the same critter facing the other way. To turn an enemy around, the game
adds or subtracts 17 from the slot number.

There is even a slot (number 14) whose displacements trace **a full circle**: it
is the enemy that orbits.

## The screens

Each screen is a 512-byte block starting at `0x9000`: 32 columns × 16 rows, one
tile byte per cell, uncompressed. The arithmetic is straightforward:

```asm
CARGA_MAPA:
    ld a,(08f0dh)   ; número de pantalla
    ld d,a
    sla d           ; DE = pantalla * 512
    ld e,000h
    ld hl,09000h
    add hl,de
    ld de,07d80h    ; al buffer de trabajo
    ld bc,00200h
    ldir
```

There are 29 of them: the 28 playable ones plus the victory screen.

The **type** of each cell is not stored in the map: it is worked out from the
tile number. `CLASIFICA_TILE` sorts them into nine classes (air, wall, extra
life, ammo, weapon, deadly ground…) by comparing ranges.

A curious case is class 1: a tile with a blank pattern that the player walks
through without noticing, but which **makes enemies turn around**. They are
invisible walls to fence in where each critter patrols. There are 406 of them
spread across the 28 maps.

## The hidden objects

Each screen also has a list of up to four **hidden spots**, at
`0x79C0 + screen*16`, with four bytes per spot:

```
column, row, shots it takes, prize it drops
```

The shot counter is stored as a negative: the game increments it until it
overflows to zero. Same as enemy stamina.

The striking part, already covered in [THE-GAME.md](THE-GAME.md), is that the system
works **by coordinates**: it does not look at what is drawn there. That is why 13
of the game's 30 spots are invisible.

## The sound player

A three-channel engine with its own tracker-style format. The data is a byte
sequence where values below `0x80` are notes and `0x80` upwards are commands:

| Command | What it does |
|---|---|
| `0x80` | channel volume |
| `0x81` | mixer (tone, noise or both) |
| `0x82` | back to the start (loop) |
| `0x83` | note duration |
| `0x84` | rest |
| `0x85` | tempo |
| `0x86` | compound duration |
| `0x87` | load instrument |
| `0x88` | noise period |
| `0x89` | noise envelope |
| `0x8A` | repeat envelopes |
| `0x8B` | end of channel |
| `0x8C` | call a phrase |
| `0x8D` | return from phrase (closes the `0x8C`) |
| `0x8E` | channel transposition in semitones |

With reusable instruments and calls to phrases, so as not to repeat data. All of
it in a little over a kilobyte, and running inside the display interrupt without
stealing time from the game.

## The variables

They all sit together, from `0x8F00` to `0x8F9F`. The main ones:

| Address | What it is |
|---|---|
| `0x8F09` / `0x8F0A` | player X and Y, in pixels |
| `0x8F0B` | current state / animation |
| `0x8F0C` | frame within the animation |
| `0x8F0D` | screen (0–28) |
| `0x8F0E` | level (0–3) |
| `0x8F11` | float mode: wings or level 4 |
| `0x8F12` | **lives** |
| `0x8F13` / `0x8F14` | where to reappear after dying |
| `0x8F17` | ammo |
| `0x8F18` | weapon |
| `0x8F1E` | the cheater flag that nobody ever turns on |
| `0x8F20` | the 4 active enemies, 5 bytes each |
| `0x8F80` | the 7 shots in flight, 4 bytes each |

## The font

The game does not use ASCII. It has its own table:

```
space    0x00        (not 0x20)
A..Z     0x41..0x5A  (same as ASCII)
0..9     0x5C..0x65  (shifted)
"        0x68
.        0x6A
,        0x6B
:        0x6C
-        0x6D
```

That is why the status bar routine does `add 0x5C` to turn a number into its
digit.

And a quirk: **the codes for U and V draw the same glyph**, so the stored texts
say things like "PVES" or "NUEUO" (for "PUES" and "NUEVO") and read perfectly
fine on screen.
