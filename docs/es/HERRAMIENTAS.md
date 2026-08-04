# Herramientas

Qué hace cada programa del proyecto. Todas son Python 3 sin dependencias
externas, salvo las de openMSX que son scripts TCL.

## El camino principal

Esto es lo que `make` ejecuta, en orden:

### `tsx_parse.py` — abrir la cinta

```sh
python3 tools/tsx_parse.py cinta.tsx extracted
```

Lee el fichero TSX, identifica sus bloques y saca los programas que contiene.
Reconoce las cabeceras de fichero del MSX, así que sabe decirte que un bloque es
"un binario llamado SLOTS que se carga en 0xC350 y se ejecuta en 0xC58F".

También escribe un manifiesto para poder reconstruir la cinta después.

### `z80trace.py` — separar el código de los datos

```sh
python3 tools/z80trace.py juego.bin 0x4000 entradas.txt salida [zonas.nocode]
```

Éste es el corazón del proyecto. Desensamblar 40 KB de corrido no funciona: en
cuanto te topas con un gráfico, los píxeles se interpretan como instrucciones y a
partir de ahí todo queda desalineado.

Así que en vez de leer de corrido, **sigue el flujo del programa**: empieza en un
punto de entrada conocido, decodifica cada instrucción, y sigue los saltos y las
llamadas. Lo que se alcanza así es código; el resto, datos.

Tiene dos particularidades que costaron sangre:

- **`HALT` no corta el flujo.** Parece que sí —el procesador se detiene— pero
  cuando llega la interrupción sigue en la instrucción siguiente. Tratarlo como
  fin de rutina dejaba el análisis en el 2%.
- **Zonas prohibidas.** Se le puede dar una lista de rangos que sabemos que son
  datos, y no entra en ellos. Sin eso, un solo destino mal deducido mete al
  trazador en los gráficos y desde ahí no para.

Los saltos indirectos (`JP (HL)`, tablas de punteros) no se pueden seguir sin
ejecutar el programa. El trazador los marca como **punto ciego** y los lista, para
que se resuelvan a mano.

### `mkasm.py` — montar el listado comentado

```sh
python3 tools/mkasm.py juego.bin 0x4000 trazado.json notas.txt simbolos.sym salida.asm "Titulo"
```

Junta el binario, el mapa de código/datos y las anotaciones, y produce el `.asm`.

Usa `z80dasm` solo para los mnemónicos. Las etiquetas de la BIOS las añade él
como comentario, y **solo en instrucciones de salto**: si se dejara a `z80dasm`
poner símbolos, convertiría cualquier número que coincidiera con una dirección
conocida, y salían cosas como `ld bc,CHRGTR` donde el código dice en realidad
`ld bc,0x0010` — una longitud, no una dirección.

### `verify_build.sh` — la comprobación que lo sostiene todo

```sh
./tools/verify_build.sh listado.asm original.bin 0x4000
```

Ensambla el listado y compara con el binario original. Si no salen idénticos,
algo se ha interpretado mal.

### `check_trace.py` — cazar la cobertura falsa

```sh
python3 tools/check_trace.py trazado.json zonas.nocode
```

Comprueba que las zonas que sabemos que son datos no hayan quedado marcadas como
código.

Existe porque hizo falta. Al sembrar el trazador con destinos sacados de un
detector automático, la cobertura saltó del 13% al 80% y pareció un éxito. Era
contaminación: había marcado como código el 100% de la tabla de colores y de los
textos del final. Y lo peor es que `verify_build.sh` **no lo detecta**, porque los
bytes no cambian, solo su interpretación.

### `coverage.py` — el presupuesto de bytes

```sh
python3 tools/coverage.py trazado.json notas.txt 40449 0x4000
```

Cuenta cuántos bytes están explicados —o como código trazado, o dentro de un
rango de datos identificado— y lista los huecos que quedan.

Es la métrica que de verdad mide el avance. El porcentaje de código no sirve:
este juego es 87% datos, así que "12,9% de código" suena a desensamblado a
medias cuando en realidad está completo.

## Para mirar el juego

### `render_maps.py` — dibujar las pantallas

```sh
python3 tools/render_maps.py juego.bin docs/mapas
```

Dibuja los 29 mapas como PNG, usando la fuente y los colores del propio juego.
Escribe los PNG a mano con `zlib`, sin librerías.

Sirve de comprobación visual: si el formato de mapa estuviera mal interpretado,
saldría ruido.

Respeta un detalle del hardware que es fácil pasar por alto: **el color 0 del
MSX no es negro, es transparente**, y por debajo se ve el color de fondo. Por eso
el nivel 4 se dibuja sobre verde y el resto sobre negro.

### `render_vram.py` — dibujar lo que se ve ahora mismo

```sh
python3 tools/render_vram.py volcado.vram salida.png
```

Igual que el anterior, pero partiendo de un volcado de la memoria de vídeo del
emulador: es lo que está literalmente en pantalla en ese instante.

### `charset.py` — leer los textos

```sh
python3 tools/charset.py juego.bin 0x4000 8
```

El juego no usa ASCII. Esto tiene su tabla de caracteres y busca cadenas con
ella.

### `inventario.py`, `make_gallery.py`

Generan el listado de rutinas identificadas y la galería de pantallas.

## Para verificar de verdad: los scripts de openMSX

Aquí está la diferencia entre suponer y saber. En vez de deducir qué hace una
rutina leyéndola, se pone el juego a correr y se observa.

```sh
TEMPT_TSX="$PWD/cinta.tsx" TEMPT_OUT="$PWD/dump" \
  openmsx -machine Philips_VG_8020-20 -script tools/omsx_load.tcl
```

| Script | Para qué |
|---|---|
| `omsx_load.tcl` | Carga la cinta entera y vuelca la memoria en cada etapa. Sirvió para **usar el cargador original del juego como decodificador**: en vez de reimplementar el turbo loader, se deja que él haga el trabajo y se captura el resultado. |
| `omsx_run.tcl` | Guarda un savestate justo cuando arranca el juego. A partir de ahí las pruebas son instantáneas en vez de esperar siete minutos. |
| `omsx_watch.tcl` | **Watchpoints**: dice qué código lee o escribe una dirección. Así se identificó el contador de vidas: no por deducción, sino viendo que solo una rutina lo lee y que esa rutina lo pinta en la casilla exacta del marcador. |
| `omsx_pcsample.tcl` | Muestrea el contador de programa mientras el juego corre. Cada dirección capturada es código **ejecutado de verdad**. |
| `omsx_huecos.tcl` | Vigila varios rangos a la vez. Con esto se resolvieron los últimos 642 bytes sin explicar. |
| `omsx_screen.tcl` | Vuelca la memoria de vídeo para ver qué hay en pantalla. |
| `omsx_poke.tcl` | Escribe en memoria durante la partida, para probar hipótesis. |
| `omsx_testpoke.tcl` | Prueba el POKE de vidas infinitas forzando la rutina de morir con y sin el parche. |
| `omsx_final.tcl` | Fuerza la pantalla final, opcionalmente con la trampa anti-tramposos activada. |
| `omsx_fugapila.tcl` | Provoca varios game over seguidos y mide cómo se pierde la pila. |
| `omsx_demo.tcl` | Lanza el juego para jugarlo, acelerando la carga ×10. |

## Reconstruir la cinta

```sh
python3 tools/build_tape.py build build/Temptations_rebuild.tsx
```

Ensambla los listados, remonta los bloques con sus cabeceras y checksums, y
escribe un TSX nuevo. El resultado es idéntico byte a byte al original.

`tsx_build.py` hace la parte de bajo nivel: reconstruir el fichero desde el
manifiesto.

## Auxiliares

| | |
|---|---|
| `gen_msx_syms.py` | Saca la tabla de rutinas de la BIOS del MSX de los headers de MSXgl, en vez de escribirla de memoria |
| `dasm_slice.py` | Desensambla por secciones con orígenes distintos. Hace falta para `SLOTS`, que se copia a sí mismo a otras direcciones antes de ejecutarse |
| `find_tables.py` | Busca tablas de punteros. **Da falsos positivos**: sirve para decidir dónde mirar, no como fuente de verdad. Fue lo que provocó el episodio de la cobertura falsa |
