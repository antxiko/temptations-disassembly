# Open questions

All 40,449 bytes sit in a named range and the listing gives the tape back byte
for byte. That does not mean everything is known. What the listing itself treats
as a guess is marked with `(?)`, and this is what is still left that way.

## Two ranges the listing still calls "unidentified"

`grafdesc`, at 0x5800–0x5CC0 (1,216 bytes), is described as *"graphics data not
identified yet"*, and the stretches of `datos_juego` left at 0x5FC0–0x79C0 and
0x7F80–0x8000 say *"screen maps, tables"* with the same doubt. Part of what is
in there is known —`make sanity` knows the scoreboard template dumped to VRAM
starts at 0x5FC0—, but the listing has not split it into named blocks yet. Until
it does, those bytes have a place but no explanation.

## Does a collision between two enemies kill too?

Collision is not computed: the game reads bit 5 of STATFL (0xF3E7), the sprite
collision flag the VDP leaves. The player takes planes 0 and 1 and the enemies
6 to 13, which is why one hit kills. What has not been checked is whether two
enemies overlapping each other also set that bit and kill the player without
touching him.

## Is it a flying mode?

0x8469 sets variable 0x8F11 to 1, and while it is 1, 0x812E calls 0x857A, which
reads the joystick to move the player up and down at will. It was named "VUELO"
(flying) for what the code does; it has not been seen on screen.

## Does it write to the wrong slot?

At 0x885A, with IX already at 0x8F34, `ld (ix+005h),000h` writes 0x8F39, which is
slot 5's X, not slot 4's. Whether that is a typo in the original or something is
being missed is still undecided.

## Sound effect 6

It is called *OBJETO DESTRUIDO* (object destroyed) because 0x89DD fires it when
the target runs out of hits, and it lasts 28 frames. The name comes from who
calls it, not from hearing it. Nor is it settled how long the channel C note it
uses lasts: with the counter at 2 it takes one or two frames, depending on the
carry WRTPSG leaves before the `sbc` at 0xDC86.

## The projectile's cell (2,21)

When a projectile goes back to the stock it is parked at cell (2,21), which
0x8AA9 turns into VRAM 0x1AA2: exactly the first cell of the ammunition strip on
the scoreboard. Since it then jumps to 0x89FC, each available projectile redraws
its icon there. That this is the purpose, and not just any parking spot, is
interpretation.

## How much stack is lost when you run out of lives?

Quitting with CTRL+STOP loses **6 bytes of stack** each time, counted instruction
by instruction from 0x832A. Running out of lives does the same —the `jp z` at
0x84CF leaves a chain of CALLs without popping—, but those bytes are not counted.
And the 33-byte cushion above the stack is the one **observed** in dumps, not a
proven limit: nobody knows after how many games it would run out.

## Where the 00/FF gaps come from

Several gaps alternate 00 at even addresses and FF —or EF— at odd ones, and no data
format behaves like that. The hypothesis is uninitialised dynamic RAM on the
machine the tape was mastered on —in its favour, they all end exactly on a page
boundary—, but the bytes alone cannot prove it.

## Leftovers of an earlier version

The dead block at 0xCA00 carries two copies in a row of the `HL+=A` routine and
no longer has the shot template at 0x8CB8; the seven bytes of
`resto_epilogo_irq` repeat the end of the interrupt routine, as if the effects
engine had once hung off H.TIMI. Both fit an earlier version of the program,
and neither can be proved from the bytes.

## The sound player

The tempo is stored as `3000/(tempo*16)`, and 3000 is 50×60: that fits a tempo in
quarter notes per minute at 50 Hz with sixteen units per quarter note, but it is
a reading. The `datos_psg` tables (0xD5C8–0xD760) are given as note periods and
envelopes without having been taken apart. And the dead entry at 0xD015 drops
bit 7 of the channel number: what it was for cannot be known, because nothing
calls that routine.
