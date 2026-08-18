# Getting started

A guide to having it running in five minutes. You don't need to know assembly,
or to have ever touched an MSX in your life.

## 1. What you need to install

Four things. On macOS, with [Homebrew](https://brew.sh):

```sh
brew install z80dasm openmsx
```

`pasmo` isn't in Homebrew; it builds in a couple of minutes:

```sh
git clone https://github.com/nataliapc/pasmo.git /tmp/pasmo
cd /tmp/pasmo && ./configure && make && sudo make install
```

Python 3 already comes with the system. On Linux, the three of them are in the
usual repositories (`apt install z80dasm pasmo openmsx` or equivalent).

| Program | What it's for |
|---|---|
| `z80dasm` | Turns the game's bytes into instructions |
| `pasmo` | Goes the other way round, to check we haven't got it wrong |
| `openmsx` | MSX emulator. It's there to *verify* things, not just to play |
| Python 3 | All the project's tools |

`openmsx` is optional if you only want to read the code, but it's what lets you
really check the claims instead of just taking them on trust.

## 2. Get the tape

You need an image of the original tape in **TSX** format. It isn't distributed
here. You can look for it in the usual MSX preservation archives; the canonical
name is:

```
Temptations (1988)(Topo Soft)(ES)[!][RUN'CAS-'][v0.8b].tsx
```

Leave it in the project folder, next to the `Makefile`. There's no need to
rename it.

## 3. Run it

```sh
make
```

And that's it. That does four things in a row:

1. Opens the tape and pulls out the five blocks it contains
2. Works out which of their bytes are instructions and which are data
3. Generates the commented listings in `src/`
4. Checks that everything adds up

If it finishes with `TODO VERDE` (all green), it worked.

## 4. Read it

Open [src/temptations_game.asm](../src/temptations_game.asm). That's the main
game, about 6,000 lines. Start at the beginning: the first routine is the boot
code, and from there you can follow the thread.

A snippet, so you can see what it looks like:

```asm
PINTA_MARCADOR:         ; Redibuja el marcador (vidas / pantalla / nivel)
    ld hl,05fc0h        ; Plantilla del marcador -> VRAM 0x1A00, las filas 16..23
    ld de,01a00h
    ld bc,00100h
    call 0005ch         ; BIOS LDIRVM - copia un bloque de memoria a la VRAM
    ld a,(08f12h)       ; A = numero de vidas
    cp 009h             ; El marcador solo tiene un digito: mas de 9 se ven como 9
    jp m,L_86AE
    ld a,009h
L_86AE:
    ld b,05ch           ; 0x5C es el codigo del digito '0' en la fuente del juego...
    add a,b             ; ...asi que 0x5C+vidas da directamente el caracter
    ld hl,01a68h        ; Casilla del digito de VIDAS en la VRAM
```

If you get lost, [THE-CODE.md](THE-CODE.md) has the map of where everything is.

### How the data blocks are laid out

Every data range declared in the notes comes out as a block of its own: its own
heading saying what it is for, its own label, and the dump aligned to its first
byte, so where one table ends and the next begins is visible at a glance. An
optional line gives the block the row width of its real structure, and that is
what makes the twenty-nine screen maps readable: 32 bytes per row is one row of
the map, so the walls and the platforms can be seen in the listing itself. The
font, the colour table and the sprites go eight bytes per row -one pattern- and
the jump tables come out as `defw` with the destination named next to them.

## 5. Adding your own comments

**Don't edit the `.asm` files**: they're regenerated every time and you'd lose
the work. Comments go in [../src/game.notes](../src/game.notes), anchored to the
memory address:

```
L 0x8698 PINTA_MARCADOR   Redibuja el marcador completo
C 0x86A4 A = numero de vidas
B 0x8698 Este texto sale como cabecera antes de la rutina
D 0x9000 0xCA00 mapas   Los 29 mapas de pantalla, 512 bytes cada uno
```

Four kinds of line: `L` gives a routine a name, `C` adds a comment at the end of
an instruction, `B` puts a block of text before it, and `D` describes a range of
data.

Then `make`, and it's in the listing.

## Other commands

```sh
make verify   # same as `make`: rebuilds if needed, then checks
make sanity   # just the fake-coverage check
make clean    # deletes what was generated
```

To see the game's screens drawn straight from the binary:

```sh
python3 tools/render_maps.py dump/turbo2_ram.bin docs/mapas
```

To play from the emulator, with the original tape:

```sh
TEMPT_TSX="$PWD/tu-cinta.tsx" openmsx -machine Philips_VG_8020-20 \
  -script tools/omsx_demo.tcl
```

(Loading really does take seven minutes, just like in 1988. That script speeds
it up ×10 and goes back to normal speed when the game starts.)

## If something goes wrong

**`make: z80dasm: command not found`** — the tools from step 1 haven't been
installed.

**`no es TZX/TSX`** ("not a TZX/TSX") — the tape file isn't a valid TSX, or it's
compressed. Uncompress it.

**openMSX doesn't start, or complains about ROMs** — the emulator needs the ROM
of a real MSX machine. The project uses a Philips VG-8020 (an MSX1 with 64 KB,
which is what the game asks for). Without system ROMs, openMSX only ships
C-BIOS, which has no BASIC and therefore can't load tapes.

**`DIFIERE`** ("differs") when verifying — something has broken in the
annotations. The message says which bytes don't match. If you've just edited the
`.notes`, undo the last change.
