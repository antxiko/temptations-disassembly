# Siguiente: Alehop

Notas de arranque para desensamblar **Alehop** (Topo Soft), el juego al que
*Temptations* invita en su pantalla final.

## Por qué es buen candidato

Mismo autor —**Luis López Navarro**— y un año más tarde. Es bastante probable
que reutilizara parte del motor de *Temptations*. Si es así, medio trabajo está
hecho: **todas las herramientas de este repositorio valen tal cual**.

## Qué comparar primero

Antes de empezar a trazar nada, comprobar si estos tres formatos se repiten. Son
los que más trabajo ahorrarían:

1. **El reproductor de sonido.** En Temptations vive en 0xD000–0xD453, con una
   tabla de saltos de 15 comandos en 0xD513. Buscar en el binario de Alehop una
   tabla de punteros parecida y comparar las rutinas.
2. **Los mapas de pantalla.** En Temptations son bloques de 512 bytes (32×16
   tiles, un byte por casilla, sin comprimir). Fácil de reconocer: basta con
   renderizar candidatos con `tools/render_maps.py` y ver si sale una pantalla
   coherente en vez de ruido.
3. **La tabla de animación y física.** Ranuras de 128 bytes indexadas por
   `estado*128 + paso*4`, cuatro bytes por fotograma (dX, dY, figura, colores) y
   `0x80` como terminador. Muy característica.

Y también: si el **cargador turbo** es el mismo, `tools/tsx_parse.py` ya lo
extrae sin tocar nada.

## Cómo empezar

```sh
# 1. Copiar el proyecto entero: las herramientas son las mismas
cp -r tools tests Makefile /ruta/al/proyecto-alehop/

# 2. Ver qué hay en la cinta
python3 tools/tsx_parse.py alehop.tsx extracted

# 3. Cargarla en openMSX y volcar la RAM, usando el cargador
#    original del juego como decodificador
TEMPT_TSX="$PWD/alehop.tsx" TEMPT_OUT="$PWD/dump" \
  openmsx -machine Philips_VG_8020-20 -script tools/omsx_load.tcl
```

A partir de ahí, el método es el de este proyecto: trazar desde el punto de
entrada, declarar las zonas de datos según se vayan confirmando, y **verificar
en el emulador en vez de suponer**.

## Lo que no hay que repetir

Cuatro errores que costaron tiempo aquí:

- **`HALT` no corta el flujo** del programa. Tratarlo como fin de rutina dejaba
  el trazado en el 2%.
- **Que un trozo desensamble de forma coherente no prueba que se ejecute.** En
  Temptations había 729 bytes de código real de otra compilación al que no llega
  ningún camino.
- **La reproducibilidad no detecta que unos gráficos se hayan marcado como
  código**: los bytes salen iguales y solo cambia su interpretación. Hace falta
  el control de sanidad aparte (`make sanity`).
- **El color 0 del MSX es transparente, no negro.** Si el juego cambia el
  registro de fondo, las pantallas renderizadas salen mal.

## Lo que quedó pendiente en Temptations

Fuera de alcance por decisión del usuario, por si algún día se retoma: arreglar
los tres bugs documentados en [BUGS.md](BUGS.md), y empaquetar el juego como ROM
o disquete para que arranque sin los siete minutos de cinta.
