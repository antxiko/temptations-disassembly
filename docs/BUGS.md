# Bugs

Bugs that *Temptations* has had since 1988. They are not disassembly mistakes:
they are in the code exactly as it went on sale.

Each one comes with the code that produces it and, where it was possible, the
check in the emulator. They go from least to most serious.

---

## 1. The lives cap is 9, even though the code means it to be 10

The routine that gives you an extra life:

```asm
DA_VIDA:
    ld a,(08f12h)   ; A = vidas actuales
    inc a           ; una mas
    cp 00ah         ; ¿ha llegado a 10?
    ret z           ; SI -> se va... SIN GUARDAR
    ld (08f12h),a   ; NO -> guarda el valor nuevo
    call PINTA_MARCADOR
    ret
```

The `ret z` comes **before** the `ld` that stores. So if you have 9 lives and
pick up another one, the `inc a` gives 10, the `ret z` fires, and the life is
lost along the way.

You will never see 10 in the status bar. **The real cap is 9.**

It may be intentional — the status bar only has one digit, and the routine that
draws it also clamps to 9 — but in that case the comparison would have to be
with 10 and the order of the instructions the other way round. As it stands, the
code says one thing and does another.

---

## 2. Picking up one item makes another one disappear

You can see this one just by playing.

When you pick up an item, the game has to erase it from the map. It does it like
this:

```asm
BORRA_OBJETO_MAPA:
    ld hl,07d80h    ; SIEMPRE desde el principio del mapa
    ld bc,00200h    ; los 512 bytes de la pantalla
    cpir            ; busca el primer byte igual a A
    ...
    ld (hl),000h    ; y lo borra
```

`cpir` searches from the **start of the buffer**, not from where the player is.
It finds the first tile of that type anywhere on the screen, whichever one it
happens to be.

On a screen with a single item of each kind you don't notice. But:

| Screen | Repeated items |
|---|---|
| 16 | **2** ammo |
| 27 | **6** extra lives |

On screen 27, with six extra lives in plain sight, whichever one you pick up,
the one that vanishes is always the first in scan order — top left. If you take
the last one, you will see one on the other side of the screen disappear while
the one you just touched is still drawn.

### And there is a second bug chained to it

The routines that pick up items clear the tile **before** checking whether your
counter is already at the cap. That is: if you pick up an extra life when you
already have 9, or ammo when you are at the maximum, or the weapon you are
already carrying, the item **disappears from the map without giving you
anything**.

---

## 3. Every lost game eats a piece of the stack

This is the most serious one, and it takes a while to show up.

The game sets up the stack only once, during startup:

```asm
GAME_START:
    ld sp,0efffh    ; pila provisional
    ...
    ld sp,08fffh    ; pila definitiva del juego   <- 0x8058
    jp INIT_PRINCIPAL
```

But when you lose your last life, the game over ends like this:

```asm
    call 08bfdh
    jp 08076h       ; reinicia... entrando DESPUES del ld sp
```

`0x8076` is the main initialisation, which is **below** the instruction that
sets up the stack. So the new game starts with the stack pointer wherever the
previous one left it.

### Measured in the emulator

Triggering eight game overs in a row and noting where the stack was left at each
restart:

| Restart | Stack pointer |
|---|---|
| 1 | `0x8FFF` |
| 2 | `0x8FFF` |
| 3 | `0x8FFD` |
| 4 | `0x8FFB` |
| 5 | `0x8FF9` |
| 6 | `0x8FDB` |
| 7 | `0x8FD9` |
| 8 | `0x8FD7` |

It goes down and never comes back up.

The stack grows downwards from `0x8FFF`, and the game variables start at
`0x8F00`. So there are about 255 bytes of headroom: after enough lost games in a
row **without resetting the machine**, the stack would end up writing over the
game variables, with everything that implies.

In 1988, playing from a tape that took seven minutes to load, it was unlikely
that anyone would string that many games together in one sitting. Today, with an
emulator and instant loading, getting there is trivial.

**Fix:** change the destination of the jump from `0x8076` to an address that
puts the stack back before carrying on.

---

## 4. The ending has no way out

When you finish the game, the victory screen goes into this loop:

```asm
BUCLE_FINAL:
    call MUEVE_ENEMIGOS
    halt
    halt
    halt
    jp BUCLE_FINAL
```

It doesn't read the keyboard. Not even CTRL+STOP works, because the game only
checks that combination from the in-game routine, and that isn't called here.

Once the game is finished, the only way back is to **reset the machine**. It
isn't exactly a bug — it may be deliberate, so that the final screen stays put —
but it is worth knowing.

---

## An oddity that is not a bug

On screen 26 there is a hidden spot whose prize is a **deadly** tile.

Hidden spots are tiles that drop an item when you shoot them. Nearly all of them
give ammo, weapons or lives. That one doesn't: it kills you.

It is in the data exactly like that, so it is intentional: a trap for anyone who
goes around shooting at everything that moves. Very much in the spirit of a game
that also keeps a telling-off for cheaters on the final screen.
