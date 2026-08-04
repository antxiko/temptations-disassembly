# Cómo empezar

Guía para tenerlo funcionando en cinco minutos. No hace falta saber ensamblador
ni haber tocado un MSX en tu vida.

## 1. Lo que necesitas instalar

Cuatro cosas. En macOS con [Homebrew](https://brew.sh):

```sh
brew install z80dasm openmsx
```

`pasmo` no está en Homebrew; se compila en dos minutos:

```sh
git clone https://github.com/nataliapc/pasmo.git /tmp/pasmo
cd /tmp/pasmo && ./configure && make && sudo make install
```

Python 3 ya viene con el sistema. En Linux, los tres están en los repositorios
habituales (`apt install z80dasm pasmo openmsx` o equivalente).

| Programa | Para qué |
|---|---|
| `z80dasm` | Traduce los bytes del juego a instrucciones |
| `pasmo` | Hace el camino inverso, para comprobar que no nos hemos equivocado |
| `openmsx` | Emulador de MSX. Sirve para *verificar* cosas, no solo para jugar |
| Python 3 | Todas las herramientas del proyecto |

`openmsx` es opcional si solo quieres leer el código, pero es lo que permite
comprobar de verdad las afirmaciones en vez de creérselas.

## 2. Consigue la cinta

Necesitas una imagen de la cinta original en formato **TSX**. Aquí no se
distribuye. Puedes buscarla en los archivos habituales de preservación de MSX;
el nombre canónico es:

```
Temptations (1988)(Topo Soft)(ES)[!][RUN'CAS-'][v0.8b].tsx
```

Déjala en la carpeta del proyecto, al lado del `Makefile`. No hace falta
renombrarla.

## 3. Ejecuta

```sh
make
```

Y ya está. Eso hace cuatro cosas seguidas:

1. Abre la cinta y saca los cuatro programas que contiene
2. Analiza cuáles de sus bytes son instrucciones y cuáles son datos
3. Genera los listados comentados en `src/`
4. Comprueba que todo cuadra

Si termina con `TODO VERDE`, funcionó.

## 4. Léelo

Abre [src/temptations_game.asm](../src/temptations_game.asm). Es el juego
principal. unas 6.000 líneas. Empieza por el principio: la primera rutina es el
arranque, y de ahí se sigue el hilo.

Un fragmento, para que veas la pinta que tiene:

```asm
PINTA_MARCADOR:         ; Redibuja el marcador (vidas / pantalla / nivel)
    ld hl,05fc0h        ; Plantilla del marcador -> VRAM 0x1A00, las filas 16..23
    ld de,01a00h
    ld bc,00100h
    call 0005ch         ; BIOS LDIRVM - copia un bloque de memoria a la VRAM
    ld a,(08f12h)       ; A = numero de vidas
    cp 009h             ; El marcador solo tiene un digito: mas de 9 se ven como 9
    jp m,L_86AE
    ld a,009h
L_86AE:
    ld b,05ch           ; 0x5C es el codigo del digito '0' en la fuente del juego...
    add a,b             ; ...asi que 0x5C+vidas da directamente el caracter
    ld hl,01a68h        ; Casilla del digito de VIDAS en la VRAM
```

Si te pierdes, [EL-CODIGO.md](EL-CODIGO.md) tiene el mapa de dónde está cada cosa.

## 5. Añadir tus propios comentarios

**No edites los `.asm`**: se regeneran cada vez y perderías el trabajo. Los
comentarios van en [../src/game.notes](../src/game.notes), anclados a la
dirección de memoria:

```
L 0x8698 PINTA_MARCADOR   Redibuja el marcador completo
C 0x86A4 A = numero de vidas
B 0x8698 Este texto sale como cabecera antes de la rutina
D 0x9000 0xCA00 mapas   Los 29 mapas de pantalla, 512 bytes cada uno
```

Cuatro tipos de línea: `L` pone nombre a una rutina, `C` añade un comentario al
final de una instrucción, `B` mete un bloque de texto antes, y `D` describe un
rango de datos.

Luego `make` y ya está en el listado.

## Otros comandos

```sh
make verify   # lo mismo que `make`: regenera si hace falta y comprueba
make sanity   # solo el control de cobertura falsa
make clean    # borra lo generado
```

Para ver las pantallas del juego dibujadas desde el binario:

```sh
python3 tools/render_maps.py dump/turbo2_ram.bin docs/mapas
```

Para jugar desde el emulador, con la cinta original:

```sh
TEMPT_TSX="$PWD/tu-cinta.tsx" openmsx -machine Philips_VG_8020-20 \
  -script tools/omsx_demo.tcl
```

(La carga tarda siete minutos de verdad, como en 1988. Ese script la acelera
×10 y vuelve a velocidad normal cuando arranca el juego.)

## Si algo falla

**`make: z80dasm: command not found`** — falta instalar las herramientas del
paso 1.

**`no es TZX/TSX`** — el fichero de cinta no es un TSX válido, o está
comprimido. Descomprímelo.

**openMSX no arranca o se queja de ROMs** — el emulador necesita la ROM de una
máquina MSX real. El proyecto usa una Philips VG-8020 (un MSX1 con 64 KB, que es
lo que el juego pide). Sin ROMs de sistema, openMSX solo trae C-BIOS, que no
tiene BASIC y por tanto no puede cargar cintas.

**`DIFIERE`** al verificar — algo se ha roto en las anotaciones. El mensaje dice
qué bytes no cuadran. Si acabas de editar el `.notes`, deshaz el último cambio.
