# El código

Mapa de dónde está cada cosa. Para el listado completo de rutinas y datos,
[INVENTARIO.txt](../INVENTARIO.txt).

## Mapa de memoria

Con el juego corriendo, el MSX queda así:

```
0x0000 ┌──────────────────────────┐
       │  ROM del BASIC           │  NO se toca: el juego sigue llamando
       │                          │  a la BIOS (dibujar en pantalla, leer
0x4000 ├──────────────────────────┤  el mando, mover bloques de memoria)
       │  Gráficos                │  fuente, colores, sprites
0x5C00 │  Pantalla de menú        │
0x5FC0 │  Marcador                │
0x60C0 │  Animaciones y física    │  50 ranuras de 128 bytes
0x79C0 │  Puntos ocultos          │  por pantalla
0x7BA0 │  Enemigos                │  por pantalla
0x7D80 │  Buffer del mapa actual  │  512 bytes
0x8000 ├──────────────────────────┤
       │  CÓDIGO DEL JUEGO        │  ~5 KB
0x8F00 │  Variables               │
0x8FA0 │  Pila                    │  crece hacia abajo desde 0x8FFF
0x9000 ├──────────────────────────┤
       │  29 mapas de pantalla    │  512 bytes cada uno
0xCA00 ├──────────────────────────┤
       │  (código muerto)         │  restos de otra compilación
0xD000 ├──────────────────────────┤
       │  Reproductor de sonido   │
0xD760 │  Música del menú         │
0xDB00 │  Rutina de cada frame    │
0xDE01 └──────────────────────────┘
```

Que la ROM del BASIC siga puesta es una decisión de diseño: el juego se apoya en
las rutinas del sistema para las tareas comunes en vez de reimplementarlas, y a
cambio renuncia a 16 KB de memoria.

## El bucle principal

Todo el juego cabe en esto:

```asm
BUCLE_PARTIDA:
    call 0832ah         ; ¿han pulsado CTRL+STOP?
    halt                ; espera al barrido de pantalla
    call 0db00h         ; sprites y vídeo
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

Dos `halt` por vuelta significa que el juego va a **25 o 30 fotogramas por
segundo**, la mitad del refresco de pantalla. Es una decisión deliberada: da
tiempo a mover todo sin que se note tirones.

## Cómo se mueve el monje

El mando se traduce a un **código de acción** con una tabla, y ese código es a la
vez el índice de la animación y el estado del personaje:

| Dirección del mando | Código | Qué hace |
|---|---|---|
| centro, abajo, abajo±diagonal | `0x00` | quieto (agacharse no existe) |
| derecha | `0x01` | andar derecha |
| izquierda | `0x02` | andar izquierda |
| arriba | `0x08` | salto vertical |
| arriba + derecha | `0x09` | salto a la derecha |
| arriba + izquierda | `0x0A` | salto a la izquierda |

Fíjate en los números: **el bit 3 es "estoy saltando"** y los bits 0 y 1 son la
dirección. `0x09` es `0x08 | 0x01`. Está pensado para poder consultar cada cosa
por separado con una máscara.

## La tabla de animación y física

Aquí está lo más elegante del juego. En `0x60C0` hay 50 ranuras de 128 bytes.
Cada ranura es una secuencia de fotogramas, y cada fotograma ocupa 4 bytes:

```
byte 0:  desplazamiento en X (con signo)
byte 1:  desplazamiento en Y (con signo)
byte 2:  número de dibujo
byte 3:  los dos colores del sprite, uno en cada mitad del byte
```

Un `0x80` en el primer byte marca el final de la secuencia.

Lo interesante es que **el movimiento y el dibujo son la misma tabla**. La
gravedad no es una fórmula: es una secuencia de fotogramas cuyos desplazamientos
en Y van creciendo. El salto tampoco: es otra secuencia. Cambiar cómo se mueve el
personaje es cambiar unos bytes de datos, no tocar código.

Las ranuras 0 a 13 son el monje, y de la 16 a la 48 los enemigos, emparejadas: la
ranura N y la N+17 son el mismo bicho mirando al otro lado. Para que un enemigo se
dé la vuelta, el juego suma o resta 17 al número de ranura.

Hay incluso una ranura (la 14) cuyos desplazamientos describen **una
circunferencia completa**: es el enemigo que orbita.

## Las pantallas

Cada pantalla es un bloque de 512 bytes desde `0x9000`: 32 columnas × 16 filas,
un byte de tile por casilla, sin comprimir. La cuenta es directa:

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

Son 29: las 28 jugables y la de victoria.

El **tipo** de cada casilla no está en el mapa: se deduce del número de tile.
`CLASIFICA_TILE` los reparte en nueve clases (aire, pared, vida extra, munición,
arma, terreno mortal…) comparando rangos.

Un caso curioso es la clase 1: un tile con dibujo vacío que el jugador atraviesa
sin enterarse, pero que **hace girar a los enemigos**. Son paredes invisibles
para acotar por dónde patrulla cada bicho. Hay 406 repartidas por los 28 mapas.

## Los objetos ocultos

Cada pantalla tiene además una lista de hasta cuatro **puntos ocultos**, en
`0x79C0 + pantalla*16`, con cuatro bytes por punto:

```
columna, fila, disparos que aguanta, premio que suelta
```

El contador de disparos está guardado en negativo: el juego lo incrementa hasta
que desborda a cero. Igual que la resistencia de los enemigos.

Lo llamativo, ya contado en [EL-JUEGO.md](EL-JUEGO.md), es que el sistema
funciona **por coordenadas**: no mira qué hay dibujado. De ahí que 13 de los 30
puntos del juego sean invisibles.

## El reproductor de sonido

Un motor de tres canales con formato propio, tipo tracker. Los datos son una
secuencia de bytes donde los valores por debajo de `0x80` son notas y los de
`0x80` en adelante son comandos:

| Comando | Qué hace |
|---|---|
| `0x80` | volumen del canal |
| `0x81` | mezclador (tono, ruido o ambos) |
| `0x82` | volver al principio (bucle) |
| `0x83` | duración de nota |
| `0x84` | silencio |
| `0x85` | tempo |
| `0x86` | duración compuesta |
| `0x87` | cargar instrumento |
| `0x88` | periodo de ruido |
| `0x89` | envolvente de ruido |
| `0x8A` | repetir envolventes |
| `0x8B` | fin del canal |
| `0x8C` | llamar a una frase |
| `0x8D`, `0x8E` | control de envolventes |

Con instrumentos reutilizables y llamadas a frases, para no repetir datos. Todo
en algo más de un kilobyte, y funcionando dentro de la interrupción de pantalla
sin robarle tiempo al juego.

## Las variables

Están todas juntas, de `0x8F00` a `0x8F9F`. Las principales:

| Dirección | Qué es |
|---|---|
| `0x8F09` / `0x8F0A` | X e Y del jugador, en píxeles |
| `0x8F0B` | estado / animación actual |
| `0x8F0C` | fotograma dentro de la animación |
| `0x8F0D` | pantalla (0–28) |
| `0x8F0E` | nivel (0–3) |
| `0x8F11` | modo flotar: alitas o nivel 4 |
| `0x8F12` | **vidas** |
| `0x8F13` / `0x8F14` | dónde reaparecer al morir |
| `0x8F17` | munición |
| `0x8F18` | arma |
| `0x8F1E` | la bandera de tramposo que nadie enciende |
| `0x8F20` | los 4 enemigos activos, 5 bytes cada uno |
| `0x8F80` | los 7 disparos en vuelo, 4 bytes cada uno |

## La fuente

El juego no usa ASCII. Tiene su propia tabla:

```
espacio  0x00        (no 0x20)
A..Z     0x41..0x5A  (como en ASCII)
0..9     0x5C..0x65  (desplazados)
"        0x68
.        0x6A
,        0x6B
:        0x6C
-        0x6D
```

Por eso la rutina del marcador hace `add 0x5C` para convertir un número en su
dígito.

Y una curiosidad: **los códigos de la U y la V dibujan el mismo glifo**, así que
los textos guardados dicen cosas como "PVES" o "NUEUO" y en pantalla se leen
perfectamente.
