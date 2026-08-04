# Temptations (Topo Soft, 1988, MSX1) — contexto del desensamblado

Documento de referencia para cualquiera (persona o agente) que trabaje en este
proyecto. Todo lo que aparece aqui esta **verificado**; lo que sea hipotesis va
marcado con "(?)".

## El juego

Exclusivo de MSX. No existe version de ZX Spectrum, Amstrad CPC ni C64 — no
busques POKEs de otras plataformas, no los hay.

- Programa y graficos: **Luis Lopez Navarro** ("LuigiLopez")
- Musica: **Gominolas** (Cesar Astudillo)
- Pantalla de carga: Javier Cano (atribucion discutida)
- Caratula: Alfonso Azpiri
- Editor: Erbe Software, cinta, Espana, 1988. Micromania nº34 le dio un 8.

Plataformas de pantalla fija (flick-screen). El protagonista dispara a cofres y
calaveras para revelar objetos: bolas de fuego, cristales, flechas de
autorrepeticion, vidas extra y alitas que permiten volar. Muere de un solo
impacto. Los movimientos laterales tienen inercia.

**Estructura (confirmada por el usuario, fan del juego): 4 niveles x 7 pantallas
= 28 pantallas.** Encaja con el `mod 7` que hace la rutina del marcador.
En el **nivel 4** el sprite del protagonista cambia y se convierte en un **pez**:
es un nivel acuatico, **sin gravedad**, se puede flotar.

Nombre del protagonista: el manual lo llama "Hermano Nonato (Noni)", pero el
texto final del propio juego dice "FRAY ARNULFO". Discrepancia real, sin resolver.

Sonido: la musica solo suena en la presentacion y el menu. Durante la partida el
mismo reproductor se usa para efectos (confirmado por el usuario).

## Controles (manual + verificado en el codigo)

| | Teclado | Joystick |
|---|---|---|
| Izquierda / Derecha / Salto | cursores | palanca |
| Disparo | ESPACIO | boton |
| Abandonar | CTRL+STOP | CTRL+STOP |

No hay redefinicion de teclas: el juego nunca llama a `SNSMAT` (0x0141). Lee
`GTSTCK` (0x00D5) con A=1 (joystick) y A=0 (cursores) y hace OR de ambos; igual
con `GTTRIG` (0x00D8). Ejemplo verificado en 0x818C.

## Cadena de carga (verificada en openMSX de principio a fin)

El TSX contiene 12 bloques. Los KCS (0x4B) traen los bytes ya desmodulados, asi
que la extraccion es exacta y no hay que decodificar audio.

| Fichero | Carga | Ejecuta | Tamano | Que es |
|---|---|---|---|---|
| `TEMPT` (ASCII) | — | — | 256 B | Cargador BASIC: `COLOR 1,1,1:SCREEN 2` + dos `BLOAD"cas:",R` |
| `TOPO` (BIN) | 0x9470 | 0x9470 | 4254 B | Logo de Topo Soft |
| `SLOTS` (BIN) | 0xC350 | 0xC58F | 700 B | Busca RAM en slots + cargador turbo |
| turbo 1 (bloque 0x10) | 0x88B8 | 0x88B8 | 12388 B | Pantalla de portada |
| turbo 2 (bloque 0x10) | 0x4000 | **0x8000** | 40449 B | El juego |

Los bloques turbo llevan **1 byte 0x00 delante y 1 byte de checksum XOR detras**
(el XOR de datos+checksum da 0). Verificado comparando la RAM volcada por
openMSX con los bytes del TSX: identicos con offset 1.

El bloque turbo 2 (0x4000..0xDE00) **sobreescribe** al turbo 1, que para entonces
ya ha hecho su trabajo.

## Mapa de memoria con el juego corriendo

    0x0000-0x3FFF   ROM del BASIC. NO se conmuta a RAM: el juego sigue llamando
                    a la BIOS (INIGRP, LDIRVM, WRTVRM, GTSTCK, GTTRIG...).
                    Verificado: coincide al 100% con la ROM del VG-8020.
    0x4000-0x7FFF   Graficos y datos del juego
    0x8000-0xDE00   Codigo del juego + variables
    0x8FFF          Pila
    0xFD9F          Hook H.TIMI de la BIOS: el juego escribe ahi `jp 0xD000`

## Datos identificados

| Rango | Que es |
|---|---|
| 0x4000-0x47FF | Tabla de patrones (fuente): 256 glifos x 8 bytes |
| 0x4800-0x4FFF | Tabla de colores |
| 0x5000-0x57FF | Patrones de sprites (van a VRAM 0x3800) |
| 0x5CC0-0x5FBF | Tabla de nombres de la pantalla de presentacion (32x24) |
| 0x5FC0-0x60FF | Plantilla del marcador (va a VRAM 0x1A00, filas 16-23) |
| 0xD513-0xD530 | Tabla de saltos de los 15 comandos del reproductor (0x80..0x8E) |
| 0xD53E-0xD5C7 | Estructuras de los 3 canales PSG, 46 bytes cada una |
| 0xD760 / 0xD891 / 0xD8F8 | Melodias del menu, canales 0/1/2 |

## Variables del juego (0x8F00-0x8F2F)

| Direccion | Variable | Como se verifico |
|---|---|---|
| 0x8F09 / 0x8F0A | X / Y del jugador | init 0x80 / 0x68 en 0x80CE / 0x80D6 |
| 0x8F0D | Pantalla (contador global) | init 0 en 0x8114; se pinta como `(valor mod 7)+1` |
| 0x8F0E | Nivel | init 0xFF en 0x80F3; se pinta `+1` |
| 0x8F12 | **VIDAS** | watchpoint: solo se escribe en 0x80FD (A=9) y solo se lee en 0x86A4 |
| 0x8F13 / 0x8F14 | X / Y de reaparicion | init 0x80 / 0x68 |
| 0x8F17 | Iconos de municion | init 1 en 0x8102 |
| 0x8F18 | Tipo de arma | init 0 en 0x8107; tile = 0xF7 + 2*tipo |
| 0x8F1E | Flag de la trampa anti-POKE | ver abajo |

## Rutinas identificadas

| Direccion | Rutina |
|---|---|
| 0x8000 | Entrada del juego |
| 0x805E | Color de borde, sprites y encender pantalla |
| 0x8076 | Inicializacion principal |
| 0x8117 | **Bucle principal de la partida** (dos frames por vuelta) |
| 0x818C | Lee el control (GTSTCK joystick + cursores, OR) |
| 0x84CC | Quita una vida: `dec a / cp 0FFh / jp z,0x8C1E` (game over) |
| 0x8528 | Da una vida: `inc a / cp 0Ah / ret z` (tope 10) |
| 0x8698 | **Pinta el marcador** (vidas / pantalla / nivel) |
| 0x8B80 | Muestra el mensaje anti-POKE si 0x8F1E != 0 |
| 0x8C1E | Game over |
| 0xD000 | Rutina de interrupcion (60 Hz), enganchada en H.TIMI |
| 0xD041 | Asigna al canal A los datos de sonido de DE |
| 0xD060 | Avanza los 3 canales un tick |
| 0xD431 | Indexa una tabla de saltos: HL = word en (HL + A*2) |
| 0xDA00 | Menu principal: musica + espera de disparo |
| 0xDB00 | Rutina de cada frame (llamada 2 veces por vuelta del bucle) |

Casillas de VRAM que escribe el marcador:
`0x1A68` = digito de VIDAS, `0x1A7D` = PANTALLA, `0x1ABB` = NIVEL,
`0x1AA2` = tira de municion.

## La trampa anti-POKE

En 0x7F94 hay la cadena `POR QUE NO PRUEBAS SIN POKES`. La muestra la rutina de
0x8B80, que solo lo hace si la variable 0x8F1E es distinta de 0.

Lo interesante: **ninguna instruccion del binario escribe en 0x8F1E** (no aparece
`32 1E 8F` ni equivalente) y en la imagen limpia de cinta vale 0. Es una trampa
latente que en el juego original nunca salta, y que solo se dispararia si alguien
pokease ese byte. No esta documentada en ninguna parte.

## Tabla de caracteres del juego

**No es ASCII.** Verificada por dos vias independientes: renderizando los glifos
de la tabla de patrones, y porque el propio codigo hace `ld b,05Ch / add a,b`
para convertir un numero en digito.

    espacio  0x00        (¡no 0x20!)
    A..Z     0x41..0x5A  (posicion ASCII normal)
    0..9     0x5C..0x65  (desplazados)
    "        0x68
    .        0x6A
    ,        0x6B
    :        0x6C
    -        0x6D

Curiosidad verificada: los codigos 'U' (0x55) y 'V' (0x56) dibujan **el mismo
glifo**, por eso los textos guardan "PVES", "NUEUO", "MVSICA" o "NIUEL" y aun asi
se leen bien en pantalla.

Textos del juego: `PANTALLA:` (0x6034), ` NIVEL:` (0x7F80), `ACABOSE` (0x7F8B),
`POR QUE NO PRUEBAS SIN POKES` (0x7F94), y el final en 0xC93B:
`ALELUYA, OH FRAY ARNULFO / SUPERANDO TODOS LOS PELIGROS DEL MAL HAS GANADO EL
CIELO / "SOLUM VICTORIUS EST GLORIA" / TE ATREVERAS CON "ALEHOP"`.

## Herramientas del proyecto

| Herramienta | Para que |
|---|---|
| `tools/tsx_parse.py` | Parsea el TSX y extrae los ficheros |
| `tools/z80trace.py` | Trazador recursivo: separa codigo de datos siguiendo el flujo |
| `tools/mkasm.py` | Genera el listado comentado desde el trazado + las notas |
| `tools/charset.py` | Tabla de caracteres del juego y buscador de textos |
| `tools/gen_msx_syms.py` | Tabla de simbolos de la BIOS MSX (desde MSXgl) |
| `tools/dasm_slice.py` | Desensambla por secciones con ORG distintos (para SLOTS) |
| `tools/omsx_*.tcl` | Arnes de openMSX: carga, savestate, watchpoints, muestreo de PC |

Ficheros de datos: `dump/turbo2_ram.bin` es el juego tal cual queda en RAM
(org 0x4000, 40449 bytes); `src/game.notes` son las anotaciones ancladas a
direccion; `src/temptations_game.asm` es el listado generado.

**Savestate de openMSX**: `tempt_boot` (el juego justo al arrancar en 0x8000).
Evita recargar los 7 minutos de cinta en cada prueba.

## Estructura de niveles (verificada en el codigo)

La rutina 0x8B09 compara el contador de pantalla (0x8F0D) con 6, 13, 20 y 27.
Son las ultimas pantallas de cada nivel, o sea **4 niveles de 7 pantallas**:

    nivel 1 -> pantallas  0..6
    nivel 2 -> pantallas  7..13
    nivel 3 -> pantallas 14..20     (0x8B29: cambia el banco de sprites)
    nivel 4 -> pantallas 21..27     (0x8B55: enciende el modo flotar)
    pantalla 28                      la de victoria

El **nivel 4 acuatico** esta en 0x8B55: pone el flag 0x8F11 a 1 (flotar, sin
gravedad), el estado de animacion a 0x0B (nadar) y el borde de color 12.

## Mapas de pantalla

29 bloques de 512 bytes seguidos desde **0x9000** (32 columnas x 16 filas, un
byte de tile por casilla, fila a fila). La rutina 0x8ACE calcula
`0x9000 + pantalla*512` y copia 512 bytes al buffer 0x7D80.

VERIFICADO: con el juego parado en la pantalla 0, los 512 bytes de 0x9000
coinciden byte a byte (512/512) con la VRAM 0x1800-0x19FF y con el buffer 0x7D80.

## Tabla de animacion y fisica (0x60C0)

Ranuras de 128 bytes indexadas por `estado*128 + paso*4`. Cada fotograma son
4 bytes: dX y dY con signo, numero de patron entre 4, y los dos colores del
sprite empaquetados. Un dX de 0x80 termina la secuencia. La lee 0x82BE.
La usan tanto el jugador (estados 0-13) como los enemigos (16-48).

## El castigo por hacer trampas

La cadena "POR QUE NO PRUEBAS SIN POKES" (0x7F94) no es un mensaje suelto: la
rutina 0x8B80 la escribe **encima de la ultima linea de la pantalla final de
victoria** si la variable 0x8F1E no es cero. Es un castigo reservado a quien se
termine el juego haciendo trampas.

Pero **ninguna instruccion del binario escribe nunca en 0x8F1E**, asi que en el
juego original no salta jamas: quedo armado por si alguien pokeaba ese byte.

## POKE de vidas infinitas

El unico publicado esta en "MSX Book II" (Paulisoft, Brasil, 1988, pag. 62) y
dice `POKE &HB4CC,0`. **Es una errata**: 0xB4CC ya vale 0 en el binario. La
direccion buena es **0x84CC**, que contiene 0x3D = DEC A en la rutina de quitar
vida. Verificado experimentalmente (tools/omsx_testpoke.tcl): sin parche 9->8,
con parche 9->9.

## Estado del desensamblado

**98,4% del binario explicado**: 5214 bytes de codigo trazado y 34593 de datos
identificados; quedan 642 bytes (1,6%) en huecos pequenos.

Cuidado con la metrica "12,9% de codigo": no significa desensamblado incompleto,
significa que este juego es ~87% datos (16 KB de graficos y 29 mapas de 512 B).

0xCA00-0xD000 es **codigo de otra compilacion** que quedo en el binario y no se
ejecuta nunca. Desensambla bien porque es codigo real, y por eso engano a un
detector heuristico de tablas de punteros.
