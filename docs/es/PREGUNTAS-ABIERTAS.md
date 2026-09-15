# Preguntas abiertas

Los 40.449 bytes están asignados a un rango con nombre y el listado vuelve a dar
la cinta byte a byte. Eso no quiere decir que se sepa todo. Lo que el propio
listado da como suposición lo marca con `(?)`, y esto es lo que queda así.

## Dos rangos que el listado aún llama «sin identificar»

`grafdesc`, en 0x5800–0x5CC0 (1.216 bytes), lleva por descripción *«datos
gráficos sin identificar todavía»*, y los tramos de `datos_juego` que quedan en
0x5FC0–0x79C0 y 0x7F80–0x8000 dicen *«mapas de pantallas, tablas»* con la misma
duda. Parte de lo que hay dentro sí se conoce —`make sanity` sabe que en 0x5FC0
empieza la plantilla del marcador que se vuelca a la VRAM—, pero el listado no
lo ha partido todavía en bloques con nombre. Mientras no se haga, esos bytes
tienen sitio pero no explicación.

## ¿Mata también el choque entre dos enemigos?

La colisión no se calcula: el juego mira el bit 5 de STATFL (0xF3E7), el flag de
colisión de sprites que deja el VDP. El jugador ocupa los planos 0 y 1 y los
enemigos del 6 al 13, y por eso muere de un solo impacto. Lo que no está
comprobado es que dos enemigos que se solapan entre sí no enciendan también ese
bit y maten al jugador sin tocarlo.

## ¿Es un modo de vuelo?

0x8469 pone a 1 la variable 0x8F11, y mientras valga 1, 0x812E llama a 0x857A,
que lee el joystick para mover al jugador arriba y abajo a voluntad. Se ha
bautizado «modo VUELO» por lo que hace el código; no se ha visto en pantalla.

## ¿Escribe en el hueco equivocado?

En 0x885A, con IX ya apuntando a 0x8F34, `ld (ix+005h),000h` escribe en 0x8F39,
que es la X del hueco 5 y no la del 4. Si es una errata del original o hay algo
que se escapa, está sin decidir.

## El efecto de sonido 6

Se le llama *OBJETO DESTRUIDO* porque lo dispara 0x89DD cuando el objetivo agota
sus impactos, y dura 28 cuadros. El nombre sale de quién lo llama, no de oírlo.
Tampoco está cerrado cuánto dura la nota del canal C que usa: con el contador a 2
dura uno o dos cuadros, según el acarreo que deje WRTPSG antes del `sbc` de
0xDC86.

## La casilla (2,21) del proyectil

Al devolver un proyectil al depósito se aparca en la casilla (2,21), que 0x8AA9
traduce a la VRAM 0x1AA2: justo la primera casilla de la tira de munición del
marcador. Como después se salta a 0x89FC, cada proyectil disponible repinta ahí
su icono. Que ese sea el propósito, y no un aparcadero cualquiera, es
interpretación.

## ¿Cuánta pila se pierde al quedarse sin vidas?

Abandonar la partida con CTRL+STOP pierde **6 bytes de pila** cada vez, contados
instrucción a instrucción desde 0x832A. Por el camino de quedarse sin vidas pasa
lo mismo —el `jp z` de 0x84CF sale de una cadena de CALL sin desapilar—, pero
esos bytes no están contados. Y el colchón de 33 bytes que queda por encima de
la pila es el que se ha **observado** en volcados, no un límite demostrado: no
se sabe tras cuántas partidas se acabaría.

## De dónde salen los huecos con patrón 00/FF

Varios huecos alternan 00 en dirección par y FF —o EF— en impar, y ningún formato de
datos se comporta así. La hipótesis es que sean RAM dinámica sin inicializar de
la máquina donde se montó la cinta —a favor: todos mueren justo en frontera de
página—, pero con los bytes solos no se puede demostrar.

## Restos de una versión anterior

El bloque muerto de 0xCA00 lleva dos copias seguidas de la rutina `HL+=A` y ya
no tiene la plantilla de disparos de 0x8CB8; los siete bytes de
`resto_epilogo_irq` repiten el final de la rutina de interrupción, como si el
motor de efectos hubiera colgado antes de H.TIMI. Las dos cosas encajan con una
versión anterior del programa, y ninguna se puede probar con los bytes.

## El reproductor de sonido

El tempo se guarda como `3000/(tempo*16)`, y 3000 es 50×60: encaja con un tempo
en negras por minuto a 50 Hz y dieciséis unidades por negra, pero es lectura.
Las tablas de `datos_psg` (0xD5C8–0xD760) se dan como periodos de nota y
envolventes sin haberlas despiezado. Y la entrada muerta de 0xD015 descarta el
bit 7 del número de canal: para qué servía no se puede saber, porque nadie llama
a esa rutina.
