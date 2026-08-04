# La cinta

Cómo se carga *Temptations* desde un casete, y por qué tarda siete minutos.

## Qué hay dentro del fichero

El formato **TSX** es la versión para MSX del TZX, un formato de preservación que
no guarda audio sino la *descripción* de los pulsos que había en la cinta, más
metadatos. Eso lo hace mucho más pequeño y exacto que un WAV.

Nuestro fichero tiene 12 bloques:

| | Contenido |
|---|---|
| 3 bloques | Metadatos: quién la volcó, el comando de carga, el nombre TOSEC |
| 1 bloque | Ficha del juego: título, editor, año, idioma |
| 6 bloques | Los tres primeros programas, en pares de cabecera + datos |
| 2 bloques | Los dos bloques grandes, en formato turbo |

Los bloques de tipo **KCS** (`0x4B`, la extensión propia del MSX) traen los bytes
**ya desmodulados**. O sea que no hace falta decodificar audio: la extracción es
exacta, sin margen de error.

## Los cuatro programas

| Nombre | Carga en | Ejecuta en | Tamaño | Qué es |
|---|---|---|---|---|
| `TEMPT` | — | — | 256 B | Cargador BASIC |
| `TOPO` | 0x9470 | 0x9470 | 4.254 B | El logo de Topo Soft |
| `SLOTS` | 0xC350 | 0xC58F | 700 B | Buscador de RAM + cargador turbo |
| *(turbo 1)* | 0x88B8 | 0x88B8 | 12.388 B | La pantalla de portada |
| *(turbo 2)* | 0x4000 | **0x8000** | 40.449 B | El juego |

El cargador BASIC es de una simplicidad desarmante:

```basic
10 COLOR 1,1,1:SCREEN 2
20 BLOAD"cas:",R
30 BLOAD"cas:",R
```

Pone la pantalla en negro sobre negro (para que no se vea el desorden mientras
carga), pasa a modo gráfico, y carga los dos programas siguientes ejecutándolos.

## SLOTS: la pieza interesante

`SLOTS` hace dos trabajos, y los dos tienen su gracia.

### Buscar la RAM

El juego necesita los 64 KB del MSX. Pero en un MSX la memoria está repartida en
"slots", y cada máquina los organiza a su manera. Así que `SLOTS` los recorre
todos, probando a escribir y releer para averiguar dónde hay RAM de verdad:

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

Y aquí viene el detalle bonito: para sondear la primera página de memoria hay un
problema de la pescadilla. Esa página es donde vive la BIOS, y la rutina que
necesitas para cambiar de slot **está en la BIOS**. Si la desconectas para
probar la RAM, te quedas sin rutina.

La solución de Topo: **copiarse la rutina a sí mismo**. `SLOTS` copia una versión
propia de esa función a memoria alta, reescribe sobre la marcha el destino de su
propia instrucción `CALL` para que apunte a la copia, y entonces sí puede sondear
la página 0 sin depender de la BIOS.

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

### Leer la cinta a lo bruto

La segunda mitad es un **cargador turbo**: lee la cinta mucho más rápido que las
rutinas del sistema, midiendo a mano la anchura de los pulsos.

Lee el bit 7 del registro 14 del chip de sonido, que es donde el MSX conecta la
entrada del casete, y cuenta cuánto tarda en cambiar de nivel. Pulso corto, un
bit; pulso largo, el otro.

Y mientras lo hace, este detalle:

```asm
    ld a,r          ; el registro R del Z80: un valor practicamente aleatorio
    and 00fh
    out (099h),a    ; ...escrito en el registro de color del video
```

El registro `R` del Z80 se incrementa solo con cada instrucción. Cogerlo y
volcarlo al color de fondo produce **las rayas de colores que se ven mientras
carga**. No es decoración añadida: es un subproducto del propio bucle de lectura,
gratis.

## Formato de los bloques turbo

Cada bloque turbo es:

```
[ 0x00 ] [ ......datos...... ] [ checksum ]
```

Un byte de sincronismo, los datos, y un byte de comprobación calculado de forma
que el XOR de todo el bloque dé cero.

Esto se verificó comparando la memoria que el emulador tenía cargada tras leer la
cinta con los bytes del fichero TSX: **idénticos**, con el desplazamiento de un
byte que corresponde al sincronismo.

## La secuencia completa

Cronometrado en el emulador, en tiempo de máquina real:

| Momento | Qué pasa |
|---|---|
| 0 s | Empieza la cinta |
| 65 s | Aparece el logo de Topo Soft |
| 96 s | Arranca `SLOTS`: busca la RAM y toma el control de la carga |
| 181 s | Ya está la portada; se dibuja en pantalla |
| **406 s** | El juego arranca |

Casi siete minutos. Así era esto.

## Reconstruir la cinta

El proyecto puede hacer el camino inverso: coger los listados comentados,
ensamblarlos, y volver a montar la cinta entera con sus cabeceras, sincronismos y
checksums.

```sh
python3 tools/build_tape.py build build/Temptations_rebuild.tsx
```

El resultado es **idéntico byte a byte** al TSX original, y carga en el emulador
con los mismos tiempos. Ésa es la prueba de que el formato está entendido del
todo: no queda nada sin interpretar.
