# Hallazgos

Cosas que aparecieron al desmontar el juego y que, hasta donde hemos podido
comprobar, no estaban documentadas en ninguna parte. Cada una con la evidencia
que la sostiene, para que cualquiera pueda comprobarla.

---

## El castigo del tramposo

En el binario, en la posición `0x7F94`, hay esta frase:

> POR QUE NO PRUEBAS SIN POKES

No es un mensaje suelto ni un texto de depuración. La rutina que lo usa está en
`0x8B80`, y forma parte de la secuencia del **final del juego**:

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

Es decir: te has pasado las 28 pantallas, llegas a la pantalla de victoria con su
*«Aleluya, oh fray Arnulfo»*, y en lugar de dejarte disfrutarla, el juego te
escribe el reproche encima. Un castigo reservado para el final.

### Qué línea borra exactamente

Forzamos el final del juego en el emulador, una vez con la bandera limpia y otra
encendiéndola a mano, y comparamos la última línea del área de juego:

```
final legítimo:  ¿TE ATREVERAS CON "ALEHOP!"?
con la trampa:   POR QUE NO PRUEBAS SIN POKES
```

El reproche no cae en un hueco libre: **sustituye justo a la línea donde el juego
te invita a jugar a *Alehop***, el siguiente título de la casa. Al tramposo le
quitan la invitación.

![Final legítimo](../mapas/FINAL_limpio.png)

![Final con la trampa activada](../mapas/FINAL_con_trampa.png)

### Y nunca llega a saltar

Buscamos en los cuatro binarios del juego cualquier instrucción que escriba en
`0x8F1E`, en todas sus formas: `ld (0x8F1E),a`, `ld hl,0x8F1E`, `ld de,…`,
`ld bc,…`. **La única referencia en todo el juego es la lectura de 0x8B80.**
Ninguna escritura, en ninguna parte.

La bandera vale cero en la cinta limpia y sigue valiendo cero con el juego
corriendo, así que el castigo no se dispara nunca.

### Y ahora la parte buena: se les olvidó inicializarla

Al principio dimos por hecho que Topo había dejado la trampa «armada y
esperando». Mirando los datos con más cuidado, la explicación es otra y bastante
mejor.

El arranque del juego inicializa quince variables, una detrás de otra:

```
8F09 8F0A 8F0B 8F0C 8F0D 8F0E 8F11 8F12 8F13 8F14 8F17 8F18 8F19 8F1C 8F1D
```

Falta una. **0x8F1E es la única variable que el juego lee y nunca inicializa**, y
está pegada a 0x8F1C y 0x8F1D, que sí se inicializan. Se saltaron precisamente
ésa.

¿Y por qué vale cero entonces? Porque la cinta carga algo ahí, y ese algo resulta
ser un cero. Pero no es una inicialización: es **relleno**. La zona 0x8F00-0x8FA0
viene llena de bytes sobrantes de las tablas de animación —se reconocen porque
alternan valores de patrón con bytes de color del tipo `0x04`, `0x14`, `0x34`— y
de esos 160 bytes **solo tres valen cero**. Uno de ellos, por pura casualidad,
cae justo en 0x8F1E.

Es decir: **el castigo no salta por chiripa**. Si el relleno hubiera dejado ahí
cualquier otro valor —y había un 98% de probabilidades— la comprobación daría
distinto de cero y *todo el mundo* que se pasara el juego vería el reproche, sin
haber hecho trampa ninguna.

Así que lo que hay aquí no es una trampa astuta, sino un **bug con suerte**:
escribieron la comprobación, se olvidaron de poner la variable a cero, y el azar
del relleno les salvó de que su propio juego insultara a todos los jugadores
honrados.

---

## Una errata de imprenta de 1988

El único truco publicado para *Temptations* apareció en **MSX Book II**
(Paulisoft, Brasil, 1988), página 62, en un cargador firmado `BY MBCF/88`. Dice:

```basic
POKE &HB4CC,0
```

**No hace nada.** En el binario del juego, la posición `0xB4CC` ya contiene un
cero: el poke escribe un cero encima de otro cero.

La dirección correcta es `0x84CC`, que contiene `0x3D` — la instrucción `DEC A`
dentro de la rutina que quita una vida:

```asm
QUITA_VIDA:
    ld a,(08f12h)   ; A = vidas actuales
    dec a           ; <-- 0x84CC. Poniendo 0x00 aqui (NOP), A no cambia
    cp 0ffh
    jp z,GAME_OVER
    ld (08f12h),a
```

En la tipografía de matriz de puntos de aquellos libros, el `8` y la `B` son casi
el mismo glifo. Se comparó el carácter impreso con el `8` de "88" y la `B` de
"BLOAD" de la misma página: es una `8` mal escaneada o mal compuesta.

**Comprobado en el emulador.** Se forzó la ejecución de la rutina con y sin el
parche:

| | Vidas antes | Vidas después |
|---|---|---|
| Sin parche | 9 | 8 |
| Con `0x84CC = 0x00` | 9 | **9** |

Así que el truco que se publicó en 1988 llevaba mal un dígito, y el bueno es
`POKE &H84CC,0`.

---

## Por qué el agua del nivel 4 es verde

El nivel 4 es submarino: Fray Arnulfo se convierte en pez, desaparece la gravedad
y se puede nadar libremente. Lo curioso es cómo está hecho el fondo.

En el chip de vídeo del MSX, el TMS9918, **el color 0 no es negro: es
transparente**. Donde un tile usa el color 0, se ve el color de fondo de la
pantalla, que es un solo registro del VDP.

El juego aprovecha eso. Al entrar en el nivel 4:

```asm
ENTRA_NIVEL4:
    call EMPIEZA_NIVEL
    ld a,00ch           ; color 12 = verde
    ld (0f3ebh),a       ; en el registro de color de fondo
    call 00062h         ; BIOS CHGCLR: aplicalo
    ld a,001h
    ld (08f11h),a       ; y enciende el modo flotar
```

Un byte. Con eso, todas las zonas transparentes de todos los tiles pasan de
negras a verdes de golpe, y el nivel entero se convierte en el fondo del mar sin
haber cambiado ni un gráfico.

Este hallazgo salió de una observación de un jugador veterano: al ver los mapas
que habíamos dibujado dijo *«los acuáticos están mal, el fondo es verde»*. Tenía
razón: nuestro programa pintaba el color 0 como negro. Buscando quién tocaba el
registro de fondo apareció el `ld a,00ch` de arriba.

---

## Los mapas: 29 pantallas de 512 bytes

Cada pantalla del juego es un bloque de 512 bytes a partir de `0x9000`: 32
columnas por 16 filas, un byte de tile por casilla, fila a fila. Sin compresión.

La aritmética está a la vista en la rutina que las carga:

```asm
CARGA_MAPA:
    ld a,(08f0dh)   ; A = numero de pantalla
    ld d,a
    sla d           ; SLA D con E=0 deja DE = pantalla * 512
    ld e,000h
    ld hl,09000h    ; base de la tabla de mapas
    add hl,de
    ld de,07d80h    ; buffer del mapa en RAM
    ld bc,00200h    ; 512 bytes
    ldir
```

Son **29** bloques: las 28 pantallas jugables (4 niveles × 7) más la de victoria.

Se verificó de dos maneras. Primero comparando memoria: con el juego parado en la
pantalla 0, los 512 bytes de `0x9000` coinciden **byte a byte** con lo que hay en
la memoria de vídeo. Y segundo dibujándolos: si el formato estuviera mal saldría
ruido, y salen pantallas de juego perfectamente reconocibles. Están en
[pantallas.html](../pantallas.html).

---

## Cuatro niveles de siete pantallas, dicho por el código

La estructura del juego no hay que suponerla. La rutina que decide qué pasa al
terminar una pantalla lo dice:

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
    jp z,L_8B23
    jp CAMBIO_PANT_NORMAL
```

6, 13, 20 y 27. Los cortes están cada siete pantallas: 0-6, 7-13, 14-20, 21-27.

---

## La U y la V son el mismo dibujo

El juego no usa ASCII: tiene su propia tabla de caracteres. El espacio es el
código 0 (no el 32), los dígitos empiezan en 0x5C y la puntuación anda por 0x68.

Al leer los textos del binario aparecen cosas como `PVES SERES HORRIBLES`,
`DE NUEUO SOBRE TI` o `MVSICA:GOMINOLAS`. Parecen erratas, pero en pantalla se
leen perfectamente.

El motivo es que **los códigos de la 'U' y la 'V' dibujan exactamente el mismo
glifo**. Da igual cuál escribas: sale la misma letra. Quien tecleó los textos usó
una u otra indistintamente.

De paso, la tabla de caracteres quedó confirmada por dos vías independientes: por
un lado dibujando los glifos, y por otro porque el propio código hace `ld b,05Ch`
+ `add a,b` para convertir un número en dígito, lo que fija el 0x5C como el '0'.

---

## Un guiño a otro juego de la casa

El texto del final, completo, dice:

> ALELUYA, OH FRAY ARNULFO. SUPERANDO TODOS LOS PELIGROS DEL MAL HAS GANADO EL
> CIELO. "SOLUM VICTORIUS EST GLORIA". ¿TE ATREVERÁS CON "ALEHOP"?

*Alehop* era otro juego de Topo Soft. La pantalla de victoria termina
vendiéndote el siguiente.

Y una curiosidad menor: el manual del juego llama al protagonista **Hermano
Nonato, «Noni»**, pero el texto que sale en pantalla dice **Fray Arnulfo**. En
algún momento entre el diseño y la impresión, el monje cambió de nombre.

---

## Restos de otra compilación

Entre `0xCA00` y `0xD000` hay 1.536 bytes que el análisis no reclama. Unos 729
son **código de verdad** —los tramos 0xCA00-0xCC10 y 0xCE00-0xCEC7—: se
desensamblan sin problemas y las rutinas tienen sentido. Pero no se ejecutan
nunca. El resto son tablas y relleno.

Es una versión anterior de algunas rutinas que quedó en el binario. Y es una
trampa peligrosa para quien desensambla: nosotros picamos. Un detector
automático de tablas de saltos las señaló como código del juego, se comprobó a
ojo que efectivamente *parecían* código correcto, y se incorporaron. Hizo falta
una revisión posterior para caer en que nadie las llama.

La lección quedó anotada en el proyecto: que un trozo desensamble de forma
coherente no prueba que se ejecute.

---

## Y lo que no toca nadie

Al final del análisis quedaban 642 bytes sin explicar. Se resolvieron poniendo
vigilantes de memoria sobre cada uno y jugando una partida completa en el
emulador —con vidas infinitas y empujando al monje contra el borde derecho, para
recorrer los cuatro niveles hasta la pantalla 27.

- **80 bytes** (0x8FB0-0x8FFF) eran la **pila**: recibieron escrituras desde 342
  direcciones distintas, incluida la propia ROM del BASIC. Ese patrón sólo lo
  produce el vaivén de `PUSH` y `POP`. Los 16 de debajo (0x8FA0-0x8FAF) no son
  pila: son la tabla de los cuatro puntos ocultos de la pantalla en curso.
- **1 byte** era una ranura de efectos de sonido que no habíamos contado.
- **545 bytes** no los tocó nadie en toda la partida. Entre ellos, dos `RET`
  huérfanos: instrucciones de retorno a las que no llega ningún camino, porque la
  rutina anterior ya cierra con otro.
