# The tape

How *Temptations* loads from a cassette, and why it takes seven minutes.

## What is inside the file

The **TSX** format is the MSX version of TZX, a preservation format that does
not store audio but the *description* of the pulses that were on the tape, plus
metadata. That makes it much smaller and much more exact than a WAV.

Our file has 12 blocks:

| | Contents |
|---|---|
| 3 blocks | Metadata: who dumped it, the load command, the TOSEC name |
| 1 block | Game record: title, publisher, year, language |
| 6 blocks | The first three programs, in header + data pairs |
| 2 blocks | The two big blocks, in turbo format |

Blocks of type **KCS** (`0x4B`, the MSX's own extension) carry the bytes
**already demodulated**. So there is no audio to decode: the extraction is
exact, with no margin for error.

## The four programs

| Name | Loads at | Runs at | Size | What it is |
|---|---|---|---|---|
| `TEMPT` | — | — | 256 B | BASIC loader |
| `TOPO` | 0x9470 | 0x9470 | 4,254 B | The Topo Soft logo |
| `SLOTS` | 0xC350 | 0xC58F | 700 B | RAM finder + turbo loader |
| *(turbo 1)* | 0x88B8 | 0x88B8 | 12,388 B | The title screen |
| *(turbo 2)* | 0x4000 | **0x8000** | 40,449 B | The game |

The BASIC loader is disarmingly simple:

```basic
10 COLOR 1,1,1:SCREEN 2
20 BLOAD"cas:",R
30 BLOAD"cas:",R
```

It sets the display to black on black (so you do not see the mess while it
loads), switches to graphics mode, and loads the next two programs, running
them.

## SLOTS: the interesting piece

`SLOTS` does two jobs, and both of them have their charm.

### Finding the RAM

The game needs the MSX's full 64 KB. But on an MSX the memory is spread across
slots, and every machine organises them its own way. So `SLOTS` walks through
all of them, writing and reading back to work out where there is real RAM:

```asm
SONDEA_PAGINA:
    ld a,080h       ; marca de slot expandido
    ld c,004h       ; 4 slots primarios
    ...
    ld (hl),020h    ; escribe 0x20 y lo relee
    ld a,(hl)
    cp 020h
    jr nz,siguiente
    ld (hl),0fah    ; y luego 0xFA, para descartar ROM
```

And here comes the nice detail: probing the first page of memory is a
chicken-and-egg problem. That page is where the BIOS lives, and the routine you
need in order to switch slots **is in the BIOS**. If you switch it out to test
the RAM, you are left without the routine.

Topo's solution: **carry its own copy of the routine**. `SLOTS` copies its own
version of that function into high memory, rewrites on the fly the destination
of its own `CALL` instruction so that it points at the copy, and only then can
it probe page 0 without depending on the BIOS.

```asm
    ld hl,00024h        ; primero, la de la BIOS
    ld (0c3b3h),hl      ; escrita como operando del CALL de 0xC3B2
    ...
    ld hl,lc418h        ; ahora copia la nuestra a RAM
    ld de,09c40h
    ld bc,000c8h
    ldir
    ld hl,09c40h
    ld (0c3b3h),hl      ; y reescribe el CALL para usarla
```

### Reading the tape the raw way

The second half is a **turbo loader**: it reads the tape much faster than the
system routines do, measuring the width of the pulses by hand.

It reads bit 7 of register 14 of the sound chip, which is where the MSX hooks
up the cassette input, and counts how long it takes to change level. Short
pulse, one bit; long pulse, the other.

And while it is at it, this detail:

```asm
    ld a,r          ; el registro R del Z80: un valor practicamente aleatorio
    and 00fh
    out (099h),a    ; ...escrito en el registro de color del video
```

The Z80's `R` register increments on its own with every instruction. Taking it
and dumping it into the backdrop colour produces **the coloured stripes you see
while it loads**. It is not decoration that somebody added: it is a by-product
of the read loop itself, for free.

## Turbo block format

Each turbo block is:

```
[ 0x00 ] [ ......data...... ] [ checksum ]
```

A sync byte, the data, and a check byte worked out so that the XOR of the whole
block comes out zero.

This was verified by comparing the memory the emulator had loaded after reading
the tape against the bytes in the TSX file: **identical**, with the one-byte
offset that corresponds to the sync byte.

## The full sequence

Timed in the emulator, in real machine time:

| Moment | What happens |
|---|---|
| 0 s | The tape starts |
| 65 s | The Topo Soft logo appears |
| 96 s | `SLOTS` starts up: it finds the RAM and takes over the loading |
| 181 s | The title screen is in; it gets drawn on the display |
| **406 s** | The game starts |

Almost seven minutes. That is how it was.

## Rebuilding the tape

The project can go the other way round: take the commented listings, assemble
them, and put the whole tape back together with its headers, sync bytes and
checksums.

```sh
python3 tools/build_tape.py build build/Temptations_rebuild.tsx
```

The result is **byte-for-byte identical** to the original TSX, and it loads in
the emulator with the same timings. That is the proof that the format is
understood all the way through: nothing is left uninterpreted.
