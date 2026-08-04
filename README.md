# Temptations (1988) — a commented disassembly

*[Léeme en castellano](README.es.md)*

This project takes a 1988 cassette tape and turns it into readable, commented
source code, one instruction at a time.

*Temptations* is a platform game **Topo Soft** released in 1988 for the **MSX**,
and only for the MSX — there was never a Spectrum, Amstrad or Commodore version.
**Luis López Navarro** wrote it and **Gominolas** did the music. You play a monk,
Fray Arnulfo, shooting arrows at chests and skulls to fight his way through 28
screens.

It's all here, explained.

---

## What's in it

**All 40,449 bytes of the game are accounted for.** Every byte is either a traced
instruction or falls inside a named data block. Most of those blocks are pinned
down precisely — the screen maps, the animation tables, the font; a few of the
largest graphics areas are identified as a whole rather than field by field.

- **137 routines**, named and described
- **74 data blocks** identified: the graphics, the 29 screen maps, the animation
  tables, the music
- A **reproducible build**: the source reassembles to the original binary,
  **byte for byte**
- **All 29 screens**, rendered straight from the binary

And along the way, a few things turned up that weren't documented anywhere.

## Three things we found

**The cheater's punishment, saved by dumb luck.** Finish the game after cheating
and Topo writes `POR QUE NO PRUEBAS SIN POKES` ("why don't you try without
pokes") over your victory screen. It never fires — and not because they meant it
that way: **they forgot to initialise the flag that triggers it**. It's the only
variable in the game that gets read but never set. That it happens to read zero
is an accident of the filler the tape loads there, where only 3 bytes out of 160
are zero. With any other value, the game would have insulted every honest player.

**A 1988 typo.** The only published cheat for the game, from a Brazilian book
that year, says `POKE &HB4CC,0`. It does nothing: that address already holds
zero. The right one is `&H84CC` — in that dot-matrix typeface the `8` and the `B`
are nearly the same shape. We confirmed it in an emulator: with the corrected
address, lives stop going down.

**Why the water is green.** Level 4 is underwater, but the tiles don't change:
the game just writes a `12` into the video chip's backdrop colour register. On
the MSX, colour 0 isn't black — it's transparent — so the whole screen changes at
once. They re-skinned an entire level with one byte.

More in [docs/FINDINGS.md](docs/FINDINGS.md). And in [docs/BUGS.md](docs/BUGS.md),
three bugs the game has carried since 1988: a lives counter that never reaches
10, items that delete the wrong neighbour, and a stack leak that eats memory game
after game.

## Getting started

You'll need your own copy of the tape (a `.tsx` file), which isn't distributed
here. Drop it in the project folder and run:

```sh
make
```

That extracts the tape, generates the commented listings and checks everything
holds together. Step-by-step instructions, including what to install, are in
**[docs/GETTING-STARTED.md](docs/GETTING-STARTED.md)**.

If you only want to read, the commented `.asm` files are in [src/](src/) and
nothing needs building.

## Documentation

| | |
|---|---|
| [Getting started](docs/GETTING-STARTED.md) | Install, build, verify. Start here. |
| [The game](docs/THE-GAME.md) | What Temptations is, who made it, how it plays. |
| [The tape](docs/THE-TAPE.md) | How it loads: the TSX format and Topo's turbo loader. |
| [The code](docs/THE-CODE.md) | Memory map, routines, variables and data formats. |
| [Findings](docs/FINDINGS.md) | The oddities, each with the evidence behind it. |
| [Bugs](docs/BUGS.md) | Faults the game has had since 1988, with the code. |
| [Tools](docs/TOOLS.md) | What each program in the project does. |
| [Inventory](docs/INVENTARIO.txt) | Full listing of routines and data blocks. |
| [All 29 screens](https://antxiko.github.io/temptations-disassembly/pantallas.html) | Gallery of every map. |

**Website:** <https://antxiko.github.io/temptations-disassembly/>

Spanish documentation lives in [docs/es/](docs/es/).

## How it's put together

The `.asm` files are **generated, not hand-edited**. The comments live separately
in `src/game.notes`, anchored to the memory address they describe, so they
survive a re-analysis of the binary.

To add a comment, edit the `.notes` file and run `make`.

## Why you can trust this

A disassembly is easy to get wrong. Read some graphics as if they were
instructions and you get pages of invented code that looks perfectly real. This
project guards against that with four automatic checks, all inside `make`:

1. **Tests.** 36 of them, including a set that verifies the documentation isn't
   lying — they check against the binary that the addresses and claims in the
   docs still hold.

2. **Reproducibility.** The source is reassembled and has to produce the original
   binary, byte for byte. A wrong comment does no harm, but a misread
   *instruction* gets caught here.

3. **Trace sanity.** The check above doesn't catch everything: if graphics get
   marked as code, the binary still comes out identical and the listing lies
   anyway. So there's a separate check that regions known to be data don't show
   up as instructions. That safeguard exists because the mistake actually
   happened during the project.

4. **Byte budget.** Every byte in the binary must be accounted for. Currently:
   40,449 of 40,449.

Beyond that, much of what's claimed here wasn't deduced by reading but by
**watching the game run** under the openMSX emulator: setting watchpoints on
memory to see which code touches each variable, sampling the program counter
during play to know what actually executes, and capturing the real display to
check it against what the code says.

## Licence and credits

The game belongs to its authors; this repository publishes the analysis. Please
read [AVISO-LEGAL.md](AVISO-LEGAL.md) — it's short and it's meant seriously.

Tools and documentation are under the licence in [LICENSE](LICENSE).
