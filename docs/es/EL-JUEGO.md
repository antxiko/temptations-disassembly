# El juego

## Qué es

*Temptations* es un juego de plataformas de pantalla fija que **Topo Soft**
publicó en 1988 para **MSX**. Distribuido por Erbe Software en cinta, a 875
pesetas.

Manejas a un monje —el manual lo llama Hermano Nonato, «Noni», aunque el propio
juego lo llama **Fray Arnulfo**— que tiene que atravesar 28 pantallas plagadas de
criaturas del mal para ganarse el ingreso en su orden.

El texto de presentación lo cuenta así:

> «No intentes pasar, te dijo el viejo monje, pues seres horribles acechan en la
> oscuridad. Mas mantén la calma y al final del camino la luz brillará de nuevo
> sobre ti, prevaleciendo sobre las tentaciones.»

## Solo para MSX

Esto conviene decirlo claro porque casi todos los juegos españoles de la época
salían para varias máquinas: **Temptations es exclusivo de MSX**. No existe
versión de ZX Spectrum, ni de Amstrad CPC, ni de Commodore 64.

Es uno de los tres únicos títulos que Topo Soft hizo solo para MSX, y una de las
razones por las que el juego tuvo menos repercusión de la que merecía: la prensa
de la época daba mucho más espacio al Spectrum.

## Quién lo hizo

| | |
|---|---|
| Programa y gráficos | **Luis López Navarro** ("LuigiLopez") |
| Música | **Gominolas** (César Astudillo) |
| Pantalla de carga | Javier Cano *(atribución discutida)* |
| Carátula | Alfonso Azpiri |

Los créditos aparecen en la propia pantalla de presentación del juego:
`LUIGILOPEZ '88 - MUSICA:GOMINOLAS`.

*Micromanía* nº34 (abril de 1988) lo reseñó con un **8** de nota global, firmado
por Marcos Jourón Berzosa: adicción 6, gráficos 9, originalidad 9.

## Cómo se juega

| | Teclado | Joystick |
|---|---|---|
| Moverse | cursores izquierda / derecha | palanca |
| Saltar | cursor arriba | arriba |
| Disparar | **espacio** | botón |
| Abandonar | CTRL + STOP | CTRL + STOP |

No hay redefinición de teclas. El juego lee el joystick del puerto 1 y los
cursores a la vez, y hace un OR de ambos: valen indistintamente.

**Un detalle del salto**: estando parado solo puedes saltar recto hacia arriba.
Para saltar hacia un lado hay que pulsar la diagonal (arriba + izquierda, o
arriba + derecha). El motivo está en el código: la dirección horizontal del salto
se toma de la posición del mando **en ese mismo instante**, no de si venías
andando.

**Y otro del disparo**: parado del todo no se puede disparar. La dirección del
tiro sale del estado de animación del monje, y los estados "quieto" y "saltando
recto" no tienen lado definido, así que el juego bloquea el disparo.

## Estructura

**4 niveles de 7 pantallas = 28 pantallas**, más la pantalla final de victoria.

| Nivel | Pantallas | Ambientación |
|---|---|---|
| 1 | 0–6 | Necrópolis: columnas rotas, calaveras, hierba |
| 2 | 7–13 | Bosque y cavernas |
| 3 | 14–20 | Ruinas de una ciudad antigua |
| 4 | 21–27 | **Fondo marino** |

En el nivel 4 el protagonista se convierte en un pez: desaparece la gravedad y se
puede nadar en las ocho direcciones.

Puedes ver las 29 pantallas dibujadas en [pantallas.html](../pantallas.html).

## Objetos

Se disparan cofres y calaveras para revelar objetos: **munición**, **armas
mejores**, **vidas extra** y unas **alitas** que permiten volar durante un rato y
saltarse obstáculos.

Aquí hay un detalle que no está en ningún manual: los puntos que sueltan objetos
**no dependen del tile que hay dibujado**. El juego guarda para cada pantalla una
lista de coordenadas, y comprueba si tu disparo cae en una de ellas. De los 30
puntos que existen en todo el juego, solo 17 están sobre una calavera o un cofre:
**los otros 13 son invisibles**, en el aire o sobre decorado.

Las alitas, en concreto, solo se consiguen en **dos puntos ocultos de todo el
juego** —uno en la pantalla 7 y otro en la 10—, y los dos están sobre fondo, sin
nada dibujado que los delate. El tile de las alitas no aparece ni una sola vez en
los 29 mapas: la única forma de conseguirlas es disparar al sitio exacto.

También hay trampas: en la pantalla 26, uno de esos puntos ocultos suelta un tile
**mortal**. Disparar a todo tiene su precio.

## Marcador

Solo tres cifras: **vidas**, **pantalla** y **nivel**. No hay puntuación, ni
barra de energía, ni tiempo. Un impacto y mueres.

Empiezas con 9 vidas. Y son 9 de verdad: aunque el código parece querer permitir
10, un fallo hace que nunca llegues a tener más de 9
(ver [BUGS.md](BUGS.md)).

## Sonido

La música de Gominolas suena en la presentación y el menú. **Durante la partida
no hay música**, solo efectos de sonido, reproducidos por el mismo motor.

Ese motor es sorprendentemente completo para un juego de cinta: tres canales,
quince comandos, envolventes de tono, volumen y ruido, instrumentos reutilizables
y llamadas a frases musicales, todo en poco más de un kilobyte. Está descrito en
[EL-CODIGO.md](EL-CODIGO.md).

## Cómo termina

Superadas las 28 pantallas aparece la pantalla de victoria:

> ALELUYA, OH FRAY ARNULFO. SUPERANDO TODOS LOS PELIGROS DEL MAL HAS GANADO EL
> CIELO. "SOLUM VICTORIUS EST GLORIA". ¿TE ATREVERÁS CON "ALEHOP"?

*Alehop* era el siguiente juego de la casa. Y esa última línea, la de la
invitación, es exactamente la que el juego te borra si detecta que has hecho
trampas — aunque esa detección nunca llega a activarse. La historia completa está
en [HALLAZGOS.md](HALLAZGOS.md).
