# Findings

Things that turned up while taking the game apart and that, as far as we have
been able to check, were not documented anywhere. Each one comes with the
evidence behind it, so that anyone can verify it.

---

## The cheater's punishment

In the binary, at address `0x7F94`, there is this sentence:

> POR QUE NO PRUEBAS SIN POKES

("Why don't you try it without pokes.") It is not a stray message or a debug
string. The routine that uses it sits at `0x8B80`, and it is part of the
**end-of-game** sequence:

```asm
FINAL_JUEGO:
    ld a,(08f0dh)       ; avanza a la pantalla 28, la de victoria
    inc a
    ld (08f0dh),a
    call CARGA_MAPA     ; la carga como cualquier otra pantalla
    call VUELCA_BUFFER
    call INIT_PANTALLA  ; y la enciende

CASTIGO_TRAMPAS:
    ld a,(08f1eh)       ; bandera de tramposo
    cp 000h
    jp z,BUCLE_FINAL    ; si esta limpia, final normal
    ld hl,07f94h        ; si no: el reproche...
    ld de,019e0h        ; ...encima de la ultima linea del area de juego
    ld bc,00020h
    call 0005ch
```

In other words: you have cleared all 28 screens, you reach the victory screen
with its *«Aleluya, oh fray Arnulfo»*, and instead of letting you enjoy it the
game writes the telling-off right on top of it. A punishment saved for the very
end.

### Which line it wipes out, exactly

We forced the end of the game in the emulator, once with the flag clear and once
with it set by hand, and compared the last line of the play area:

```
legitimate ending:  ¿TE ATREUERAS CON "ALEHOP"?
with the cheat:     POR QUE NO PRUEBAS SIN POKES
```

The telling-off does not land in free space: **it replaces exactly the line
where the game invites you to play *Alehop***, the company's next title. The
cheater has the invitation taken away.

![Legitimate ending](mapas/FINAL_limpio.png)

![Ending with the cheat flag set](mapas/FINAL_con_trampa.png)

### And it never fires

We searched all four of the game's binaries for any instruction that writes to
`0x8F1E`, in every form: `ld (0x8F1E),a`, `ld hl,0x8F1E`, `ld de,…`,
`ld bc,…`. **The only reference in the whole game is the read at 0x8B80.**
No write, anywhere.

The flag is zero on a clean tape and stays zero with the game running, so the
punishment never triggers.

### And now the good part: they forgot to initialise it

The game's start-up initialises fifteen variables, one after another:

```
8F09 8F0A 8F0B 8F0C 8F0D 8F0E 8F11 8F12 8F13 8F14 8F17 8F18 8F19 8F1C 8F1D
```

One is missing. **0x8F1E is the only variable the game reads and never
initialises**, and it sits right next to 0x8F1C and 0x8F1D, which are
initialised. That is precisely the one they skipped.

So why is it zero, then? Because the tape loads something there, and that
something happens to be a zero. But it is not an initialisation: it is
**padding**. The area 0x8F00-0x8FA0 comes filled with leftover bytes from the
animation tables — you can recognise them because they alternate pattern values
with colour bytes of the `0x04`, `0x14`, `0x34` kind — and out of those 160
bytes **only three are zero**. One of them, by pure chance, falls exactly on
0x8F1E.

That is: **the punishment fails to fire by sheer luck**. If the padding had left
any other value there — and there was a 98% chance of that — the check would
have come out non-zero and *everybody* who finished the game would see the
telling-off, without having cheated at all.

So what we have here is not a clever trap but a **lucky bug**: they wrote the
check, forgot to zero the variable, and the randomness of the padding saved them
from having their own game insult every honest player.

---

## A 1988 misprint

The only published cheat for *Temptations* appeared in **MSX Book II**
(Paulisoft, Brazil, 1988), page 62, in a loader signed `BY MBCF/88`. It says:

```basic
POKE &HB4CC,0
```

**It does nothing.** In the game's binary, address `0xB4CC` already holds a
zero: the poke writes a zero over a zero.

The correct address is `0x84CC`, which holds `0x3D` — the `DEC A` instruction
inside the routine that takes a life away:

```asm
QUITA_VIDA:
    ld a,(08f12h)   ; A = vidas actuales
    dec a           ; <-- 0x84CC. Poniendo 0x00 aqui (NOP), A no cambia
    cp 0ffh
    jp z,GAME_OVER
    ld (08f12h),a
```

In the dot-matrix type used in those books, `8` and `B` are almost the same
glyph. We compared the printed character with the `8` in "88" and the `B` in
"BLOAD" on the same page: it is an `8` that was badly scanned or badly typeset.

**Verified in the emulator.** We forced the routine to run with and without the
patch:

| | Lives before | Lives after |
|---|---|---|
| Without the patch | 9 | 8 |
| With `0x84CC = 0x00` | 9 | **9** |

So the cheat published in 1988 had one digit wrong, and the good one is
`POKE &H84CC,0`.

---

## Why the water in level 4 is green

Level 4 is underwater: Fray Arnulfo turns into a fish, gravity disappears and
you can swim freely. The interesting bit is how the background is done.

On the MSX video chip, the TMS9918, **colour 0 is not black: it is
transparent**. Wherever a tile uses colour 0, what shows through is the backdrop
colour, which is a single VDP register.

The game takes advantage of that. On entering level 4:

```asm
ENTRA_NIVEL4:
    call EMPIEZA_NIVEL
    ld a,00ch           ; color 12 = verde
    ld (0f3ebh),a       ; en el registro de color de fondo
    call 00062h         ; BIOS CHGCLR: aplicalo
    ld a,001h
    ld (08f11h),a       ; y enciende el modo flotar
```

One byte. With that, every transparent area of every tile goes from black to
green all at once, and the whole level turns into the bottom of the sea without
a single graphic having changed.

---

## Four levels of seven screens, straight from the code

The structure of the game does not have to be guessed at. The routine that
decides what happens when a screen is finished says it:

```asm
FIN_DE_PANTALLA:
    ld a,(08f0dh)       ; pantalla que se acaba de terminar
    cp 00dh             ; 13 -> entra al nivel 3
    jp z,ENTRA_NIVEL3
    cp 014h             ; 20 -> entra al nivel 4
    jp z,ENTRA_NIVEL4
    cp 01bh             ; 27 -> se acabo el juego
    jp z,FINAL_JUEGO
    cp 006h             ; 6  -> entra al nivel 2
    jp z,CEREMONIA_NIVEL
    jp CAMBIO_PANT_NORMAL
```

6, 13, 20 and 27. The cuts come every seven screens: 0-6, 7-13, 14-20, 21-27.

---

## Leftovers from another build

Between `0xCA00` and `0xD000` there are 1,536 bytes the analysis does not claim.
About 729 of them —`0xCA00-0xCC10` and `0xCE00-0xCEC7`— are real code: they
disassemble cleanly and the routines make sense. But nothing calls them. The rest
is tables and padding.

It is an earlier version of some routines, left behind in the binary. And it is
worth a warning: a chunk disassembling coherently is no proof that it ever runs.

---

## And the bytes nobody touches

642 bytes were left unexplained. They were settled by putting memory watchpoints
on every one of them and playing a full game in the emulator, with infinite lives
and the monk pushed against the right-hand edge, to run through all four levels
up to screen 27.

- **80 bytes** (`0x8FB0-0x8FFF`) were the **stack**: they took writes from 342
  different addresses, including the BASIC ROM itself. Only the back-and-forth
  of `PUSH` and `POP` produces that pattern.
- **16 bytes** (`0x8FA0-0x8FAF`) are not stack: they are the table of the four
  hidden points of the current screen.
- **1 byte** was a sound-effect slot that had not been counted.
- **545 bytes** were not touched by anything for the whole game. Among them, two
  orphan `RET`s: return instructions no path ever reaches, because the routine
  before them already ends with one of its own.
