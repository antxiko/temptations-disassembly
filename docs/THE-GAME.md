# The game

## What it is

*Temptations* is a single-screen platform game that **Topo Soft** published in
1988 for the **MSX**. Distributed by Erbe Software on tape, for 875 pesetas.

You control a monk —the manual calls him Brother Nonato, "Noni", although the
game itself calls him **Fray Arnulfo**— who has to get through 28 screens
infested with creatures of evil to earn his place in his order.

The intro text puts it like this:

> «No intentes pasar, te dijo el viejo monje, pues seres horribles acechan en la
> oscuridad. Mas mantén la calma y al final del camino la luz brillará de nuevo
> sobre ti, prevaleciendo sobre las tentaciones.»

(*"Do not try to pass, the old monk told you, for horrible beings lurk in the
darkness. But keep calm and at the end of the road the light will shine on you
again, prevailing over the temptations."*)

## MSX only

This is worth saying plainly, because almost every Spanish game of the period
came out for several machines: **Temptations is MSX-exclusive**. There is no ZX
Spectrum version, no Amstrad CPC version, no Commodore 64 version.

It is one of only three titles Topo Soft made for the MSX alone, and one of the
reasons the game had less impact than it deserved: the press of the day gave far
more space to the Spectrum.

## Who made it

| | |
|---|---|
| Code and graphics | **Luis López Navarro** ("LuigiLopez") |
| Music | **Gominolas** (César Astudillo) |
| Loading screen | Javier Cano *(attribution disputed)* |
| Cover art | Alfonso Azpiri |

The credits appear on the game's own title screen:
`LUIGILOPEZ '88 - MUSICA:GOMINOLAS`.

*Micromanía* no. 34 (April 1988) reviewed it with an overall score of **8**, in a
review by Marcos Jourón Berzosa: addictiveness 6, graphics 9, originality 9.

## How you play

| | Keyboard | Joystick |
|---|---|---|
| Move | left / right cursor keys | stick |
| Jump | up cursor | up |
| Fire | **space** | button |
| Quit | CTRL + STOP | CTRL + STOP |

There is no key redefinition. The game reads the joystick on port 1 and the
cursor keys at the same time and ORs the two together: either one works.

**One detail about jumping**: from a standing start you can only jump straight
up. To jump sideways you have to press the diagonal (up + left, or up + right).
The reason is in the code: the horizontal direction of the jump is taken from the
position of the controls **at that very moment**, not from whether you were
already walking.

**And one about firing**: standing completely still, you cannot fire. The
direction of the shot comes from the monk's animation state, and the "idle" and
"straight-up jump" states have no side defined, so the game blocks the shot.

## Structure

**4 levels of 7 screens = 28 screens**, plus the final victory screen.

| Level | Screens | Setting |
|---|---|---|
| 1 | 0–6 | Necropolis: broken columns, skulls, grass |
| 2 | 7–13 | Forest and caverns |
| 3 | 14–20 | Ruins of an ancient city |
| 4 | 21–27 | **Sea bed** |

In level 4 the hero turns into a fish: gravity disappears and you can swim in all
eight directions.

You can see all 29 screens drawn out in [pantallas.html](pantallas.html).

## Items

You shoot chests and skulls to reveal items: **ammunition**, **better weapons**,
**extra lives** and a pair of **little wings** that let you fly for a while and
skip past obstacles.

Here is a detail that is in no manual: the spots that drop items **do not depend
on the tile drawn there**. For each screen the game keeps a list of coordinates,
and checks whether your shot lands on one of them. Of the 30 spots that exist in
the whole game, only 17 are on top of a skull or a chest: **the other 13 are
invisible**, in mid-air or over scenery.

The wings in particular can only be obtained at **two hidden spots in the entire
game** —one on screen 7 and one on screen 10— and both of them are over
background, with nothing drawn to give them away. The wings tile does not appear
even once in the 29 maps: the only way to get them is to shoot the exact spot.

There are traps too: on screen 26, one of those hidden spots drops a **deadly**
tile. Shooting at everything has its price.

## Status bar

Just three figures: **lives**, **screen** and **level**. No score, no energy bar,
no timer. One hit and you die.

You start with 9 lives. And it really is 9: although the code looks like it means
to allow 10, a bug means you never get to have more than 9
(see [BUGS.md](BUGS.md)).

## Sound

Gominolas's music plays on the intro screen and the menu. **There is no music
during play**, only sound effects, played by the same engine.

That engine is surprisingly complete for a tape game: three channels, fifteen
commands, pitch, volume and noise envelopes, reusable instruments and calls to
musical phrases, all in a little over a kilobyte. It is described in
[THE-CODE.md](THE-CODE.md).

## How it ends

Once the 28 screens are beaten, the victory screen appears:

> ALELUYA, OH FRAY ARNULFO. SUPERANDO TODOS LOS PELIGROS DEL MAL HAS GANADO EL
> CIELO. "SOLUM VICTORIUS EST GLORIA". ¿TE ATREVERÁS CON "ALEHOP"?

(*"Hallelujah, oh Fray Arnulfo. By overcoming all the perils of evil you have won
heaven. 'SOLUM VICTORIUS EST GLORIA'. Will you dare to take on 'ALEHOP'?"*)

*Alehop* was the company's next game. And that last line, the invitation, is
exactly the one the game erases if it detects that you have cheated — although
that detection never actually fires. The full story is in
[FINDINGS.md](FINDINGS.md).
