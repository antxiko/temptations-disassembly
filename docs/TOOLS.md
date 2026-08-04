# Tools

What each program in the project does. They are all Python 3 with no external
dependencies, except the openMSX ones, which are TCL scripts.

## The main path

This is what `make` runs, in order:

### `tsx_parse.py` — opening the tape

```sh
python3 tools/tsx_parse.py cinta.tsx extracted
```

Reads the TSX file, identifies its blocks and pulls out the programs it
contains. It recognises the MSX file headers, so it can tell you that a
block is "a binary called SLOTS that loads at 0xC350 and runs at 0xC58F".

It also writes a manifest so the tape can be rebuilt afterwards.

### `z80trace.py` — telling code from data

```sh
python3 tools/z80trace.py juego.bin 0x4000 entradas.txt salida [zonas.nocode]
```

This is the heart of the project. Disassembling 40 KB straight through doesn't
work: the moment you hit a graphic, the pixels get read as instructions, and
from there on everything is misaligned.

So instead of reading straight through, it **follows the flow of the program**:
it starts at a known entry point, decodes each instruction, and follows the
jumps and the calls. Whatever it reaches that way is code; the rest is data.

It has two quirks that were learned the hard way:

- **`HALT` does not end the flow.** It looks like it does —the processor
  stops— but when the interrupt arrives it carries on at the next instruction.
  Treating it as the end of a routine left the analysis stuck at 2%.
- **Forbidden zones.** You can hand it a list of ranges that we know are data,
  and it will not go into them. Without that, a single wrongly deduced
  destination drops the tracer into the graphics, and from there it never stops.

Indirect jumps (`JP (HL)`, pointer tables) cannot be followed without running
the program. The tracer marks them as a **blind spot** and lists them, so they
can be resolved by hand.

### `mkasm.py` — assembling the commented listing

```sh
python3 tools/mkasm.py juego.bin 0x4000 trazado.json notas.txt simbolos.sym salida.asm "Titulo"
```

It brings together the binary, the code/data map and the annotations, and
produces the `.asm`.

It uses `z80dasm` only for the mnemonics. The BIOS labels it adds itself, as a
comment, and **only on jump instructions**: if `z80dasm` were left to place the
symbols, it would convert any number that happened to match a known address,
and you got things like `ld bc,CHRGTR` where the code actually says
`ld bc,0x0010` — a length, not an address.

### `verify_build.sh` — the check that holds everything up

```sh
./tools/verify_build.sh listado.asm original.bin 0x4000
```

Assembles the listing and compares it with the original binary. If they don't
come out identical, something has been read wrong.

### `check_trace.py` — hunting down false coverage

```sh
python3 tools/check_trace.py trazado.json zonas.nocode
```

Checks that the zones we know are data have not ended up marked as code.

It exists because it was needed. Seeding the tracer with destinations from an
automatic detector pushed coverage from 13% to 80%, and it looked like a
success. It was contamination: 100% of the colour table and of the end-game
text had been marked as code. And the worst part is that `verify_build.sh`
**does not catch it**, because the bytes don't change, only their
interpretation.

### `coverage.py` — the byte budget

```sh
python3 tools/coverage.py trazado.json notas.txt 40449 0x4000
```

Counts how many bytes are explained —either as traced code, or inside an
identified data range— and lists the gaps that are left.

This is the metric that really measures progress. The code percentage is no
use: this game is 87% data, so "12.9% code" sounds like a half-finished
disassembly when in fact it is complete.

## Looking at the game

### `render_maps.py` — drawing the screens

```sh
python3 tools/render_maps.py juego.bin docs/mapas
```

Draws the 29 maps as PNGs, using the game's own font and colours. It writes the
PNGs by hand with `zlib`, no libraries.

It works as a visual check: if the map format had been read wrong, the output
would be noise.

It respects a hardware detail that is easy to overlook: **MSX colour 0 is not
black, it is transparent**, and what shows through underneath is the backdrop
colour. That is why level 4 is drawn over green and the rest over black.

### `render_vram.py` — drawing what is on screen right now

```sh
python3 tools/render_vram.py volcado.vram salida.png
```

Same as the previous one, but starting from a dump of the emulator's VRAM: it
is literally what is on the display at that instant.

### `charset.py` — reading the text

```sh
python3 tools/charset.py juego.bin 0x4000 8
```

The game does not use ASCII. This one has its character table and searches for
strings with it.

### `inventario.py`, `make_gallery.py`

They generate the list of identified routines and the screen gallery.

## Verifying for real: the openMSX scripts

This is the difference between guessing and knowing. Instead of working out
what a routine does by reading it, you set the game running and watch.

```sh
TEMPT_TSX="$PWD/cinta.tsx" TEMPT_OUT="$PWD/dump" \
  openmsx -machine Philips_VG_8020-20 -script tools/omsx_load.tcl
```

| Script | What it is for |
|---|---|
| `omsx_load.tcl` | Loads the whole tape and dumps memory at each stage. It was used to **turn the game's original loader into the decoder**: instead of reimplementing the turbo loader, you let it do the work and capture the result. |
| `omsx_run.tcl` | Saves a savestate right as the game starts. From then on the tests are instant instead of a seven-minute wait. |
| `omsx_watch.tcl` | **Watchpoints**: tells you which code reads or writes an address. That is how the lives counter was identified: not by deduction, but by seeing that only one routine reads it and that this routine draws it in the exact cell of the status bar. |
| `omsx_pcsample.tcl` | Samples the program counter while the game runs. Every address captured is code that **really executed**. |
| `omsx_huecos.tcl` | Watches several ranges at once. This is what resolved the last 642 unexplained bytes. |
| `omsx_screen.tcl` | Dumps VRAM to see what is on the display. |
| `omsx_poke.tcl` | Writes to memory during play, to test hypotheses. |
| `omsx_testpoke.tcl` | Tests the infinite-lives POKE by forcing the death routine with and without the patch. |
| `omsx_final.tcl` | Forces the final screen, optionally with the anti-cheater trap enabled. |
| `omsx_fugapila.tcl` | Triggers several game overs in a row and measures how the stack is lost. |
| `omsx_demo.tcl` | Launches the game to play it, with loading sped up ×10. |

## Rebuilding the tape

```sh
python3 tools/build_tape.py build build/Temptations_rebuild.tsx
```

Assembles the listings, puts the blocks back together with their headers and
checksums, and writes a new TSX. The result is byte-for-byte identical to the
original.

`tsx_build.py` does the low-level part: rebuilding the file from the manifest.

## Helpers

| | |
|---|---|
| `gen_msx_syms.py` | Pulls the MSX BIOS routine table out of the MSXgl headers, instead of typing it from memory |
| `dasm_slice.py` | Disassembles in sections with different origins. Needed for `SLOTS`, which copies itself to other addresses before it runs |
| `find_tables.py` | Looks for pointer tables. **It gives false positives**: it is there to decide where to look, not as a source of truth. It was what caused the false-coverage episode |
