# Temptations (1988) — desensamblado comentado

Este proyecto coge una cinta de casete de 1988 y la convierte en código fuente
legible y comentado, línea por línea.

*Temptations* es un juego de plataformas que **Topo Soft** publicó en 1988 para
**MSX**, y solo para MSX: nunca hubo versión de Spectrum, Amstrad ni Commodore.
Lo programó **Luis López Navarro** y la música es de **Gominolas**. Manejas a un
monje, Fray Arnulfo, que dispara flechas a cofres y calaveras para abrirse paso
por 28 pantallas.

Aquí está entero, explicado.

---

## Qué encontrarás

**Los 40.449 bytes del juego están asignados.** Cada byte es o una instrucción
trazada o cae dentro de un bloque de datos con nombre. La mayoría de esos bloques
están acotados con precisión —los mapas, las tablas de animación, la fuente—; unas
pocas zonas grandes de gráficos están identificadas en conjunto, no campo a campo.

- **137 rutinas** con nombre y descripción
- **74 bloques de datos** identificados: los gráficos, los 29 mapas de pantalla,
  las animaciones, la música
- Un **build reproducible**: el código fuente vuelve a producir el binario
  original **byte a byte**
- **Las 29 pantallas** del juego, dibujadas desde el binario

Y por el camino salieron cosas que no estaban documentadas en ninguna parte.

## Tres cosas que descubrimos

**El castigo del tramposo, que se salvó por los pelos.** Si te terminas el juego
habiendo hecho trampas, Topo escribe encima de tu pantalla de victoria un
`POR QUE NO PRUEBAS SIN POKES`. Nunca llega a saltar — y no porque lo dejaran
así a propósito: **se olvidaron de inicializar la variable que lo dispara**. Es
la única del juego que se lee y nunca se pone a cero. Que valga cero es
casualidad del relleno que arrastra la cinta, donde solo 3 de 160 bytes son cero.
Con cualquier otro valor, el juego habría insultado a todos los jugadores
honrados.

**Un error de imprenta de 1988.** El único truco publicado para el juego, en un
libro brasileño de aquel año, dice `POKE &HB4CC,0`. No funciona: esa dirección ya
vale cero. La buena es `&H84CC` — en aquella tipografía de matriz de puntos el
`8` y la `B` se confunden. Lo comprobamos en el emulador: con la dirección
corregida, las vidas dejan de bajar.

**Por qué el agua es verde.** El nivel 4 es submarino, pero los tiles no cambian:
el juego solo escribe un `12` en el registro de color de fondo del vídeo. En el
chip del MSX el color 0 no es negro, es transparente, así que toda la pantalla se
tiñe de golpe. Cambiaron la ambientación de un nivel entero tocando un byte.

Hay más en [docs/HALLAZGOS.md](docs/HALLAZGOS.md). Y en
[docs/BUGS.md](docs/BUGS.md), tres fallos que el juego arrastra desde 1988: el
tope de vidas que nunca llega a 10, los objetos que borran al vecino equivocado,
y una fuga de pila que se come la memoria partida tras partida.

## Empezar

Necesitas tu propia copia de la cinta (un fichero `.tsx`), que no se distribuye
aquí. Déjala en la carpeta del proyecto y:

```sh
make
```

Eso extrae la cinta, genera los listados comentados y comprueba que todo cuadra.
La guía paso a paso, con lo que hay que instalar, está en
**[docs/COMO-EMPEZAR.md](docs/COMO-EMPEZAR.md)**.

Si solo quieres leer, los `.asm` comentados están en [src/](src/) y no hace falta
compilar nada.

## La documentación

| | |
|---|---|
| [Cómo empezar](docs/COMO-EMPEZAR.md) | Instalar, generar y verificar. Empieza por aquí. |
| [El juego](docs/EL-JUEGO.md) | Qué es Temptations, quién lo hizo, cómo se juega. |
| [La cinta](docs/LA-CINTA.md) | Cómo carga: el formato TSX y el cargador turbo de Topo. |
| [El código](docs/EL-CODIGO.md) | Mapa de memoria, rutinas, variables y formatos de datos. |
| [Hallazgos](docs/HALLAZGOS.md) | Las curiosidades, con la evidencia de cada una. |
| [Bugs](docs/BUGS.md) | Fallos que el juego tiene desde 1988, con su código. |
| [Herramientas](docs/HERRAMIENTAS.md) | Qué hace cada programa del proyecto. |
| [Inventario](docs/INVENTARIO.txt) | Listado completo de rutinas y datos. |
| [Lo siguiente](docs/SIGUIENTE-ALEHOP.md) | Notas de arranque para *Alehop*, el siguiente juego del mismo autor. |
| [Las 29 pantallas](docs/pantallas.html) | Galería de todos los mapas. |

## Cómo está montado

Los ficheros `.asm` **se generan, no se editan a mano**. Los comentarios viven
aparte, en `src/game.notes`, anclados a la dirección de memoria a la que se
refieren. Así sobreviven cuando se vuelve a analizar el binario.

Para añadir un comentario, edita el `.notes` y ejecuta `make`.

## Por qué te puedes fiar de esto

Un desensamblado es fácil de hacer mal: basta con interpretar unos gráficos como
si fueran instrucciones y ya tienes páginas de código inventado que parece real.
Este proyecto se defiende de eso con tres comprobaciones automáticas, todas
dentro de `make`:

1. **Reproducibilidad.** El código fuente se vuelve a ensamblar y tiene que dar
   el binario original, byte a byte. Si un comentario está equivocado no pasa
   nada, pero si una *instrucción* está mal leída, esto lo caza.

2. **Sanidad del trazado.** La comprobación anterior no lo pilla todo: si los
   gráficos se marcan como código, el binario sigue saliendo idéntico y el
   listado miente igualmente. Por eso se comprueba aparte que las zonas que
   sabemos que son datos no aparezcan como instrucciones. Esta salvaguarda existe
   porque el error ocurrió de verdad, durante el proyecto.

3. **Presupuesto de bytes.** Cada byte del binario tiene que estar explicado.
   Hoy: 40.449 de 40.449.

Además, buena parte de lo que se afirma aquí no se dedujo leyendo, sino
**observando el juego correr** en el emulador openMSX: poniendo vigilantes sobre
posiciones de memoria para ver qué código las toca, y capturando la pantalla real
para contrastarla con lo que dice el código.

## Licencia y créditos

El juego es de sus autores; este repositorio publica el análisis. Léete
[AVISO-LEGAL.md](AVISO-LEGAL.md) — es corto y va en serio.

Las herramientas y la documentación, bajo la licencia de [LICENSE](LICENSE).
