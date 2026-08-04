#!/usr/bin/env python3
"""Genera la web publica del proyecto: analisis, hallazgos, bugs y las 29 pantallas.

Todo el material visual sale del propio binario -incluido el logo de la cabecera,
recortado de la pantalla de presentacion- y las imagenes van embebidas como data
URI para que la pagina sea un solo fichero autocontenido.
"""
import base64
import html
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_maps import render, png  # noqa: E402

ORG = 0x4000


def recorta(d, base_nt, col0, fila0, ncols, nfilas, escala=3):
    pat = d[0x4000 - ORG:0x4800 - ORG]
    col = d[0x4800 - ORG:0x5000 - ORG]
    nt = d[base_nt - ORG:base_nt - ORG + 0x300]
    sub = bytes(nt[(fila0 + y) * 32 + col0 + x]
                for y in range(nfilas) for x in range(ncols))
    return render(pat, col, sub, ncols, nfilas, escala, backdrop=1)


def b64(p):
    return base64.b64encode(open(p, "rb").read()).decode()


def img(p, alt, clase=""):
    return (f'<img src="data:image/png;base64,{b64(p)}" alt="{html.escape(alt)}"'
            f'{f" class={clase}" if clase else ""} loading="lazy">')


def asm(codigo):
    return f'<pre class="asm">{html.escape(codigo.strip())}</pre>'


def main(binpath, mapdir, out):
    d = open(binpath, "rb").read()
    w, h, im = recorta(d, 0x5CC0, 6, 5, 21, 9, escala=3)
    png("/tmp/logo.png", w, h, im)
    w, h, im = recorta(d, 0x5CC0, 0, 0, 32, 24, escala=2)
    png("/tmp/menu.png", w, h, im)

    NIV = ["La necropolis", "El bosque", "Las ruinas", "El fondo marino"]
    galeria = []
    for niv in range(4):
        cartas = "".join(
            f'<figure>{img(os.path.join(mapdir, f"nivel{niv+1}_pantalla{p+1}_{niv*7+p:02d}.png"), f"Nivel {niv+1} pantalla {p+1}")}'
            f'<figcaption><span>{p+1}</span><span class="dir">{0x9000+(niv*7+p)*512:#06x}</span></figcaption></figure>'
            for p in range(7))
        galeria.append(
            f'<div class="nivel"><h3>Nivel {niv+1}<span class="sep">·</span>'
            f'<em>{NIV[niv]}</em></h3><div class="rejilla">{cartas}</div></div>')

    doc = f"""<title>Temptations (1988) — desensamblado comentado</title>
<style>
:root {{
  /* Los colores son literalmente los del TMS9918, el chip de video del MSX1 */
  --tinta:#cfd0d4; --suave:#83868f; --fondo:#000; --panel:#0c0e13; --linea:#23262e;
  --rojo:#ff897d; --cyan:#65dbef; --verde:#3eb849; --oro:#ded087;
}}
@media (prefers-color-scheme:light){{:root{{
  --tinta:#191a1e; --suave:#5a5d66; --fondo:#e9e7e1; --panel:#f7f6f2; --linea:#d0cdc5;
  --rojo:#b23f34; --cyan:#1c6b7c; --verde:#2b7734; --oro:#8a7420;}}}}
:root[data-theme="dark"]{{--tinta:#cfd0d4;--suave:#83868f;--fondo:#000;--panel:#0c0e13;
  --linea:#23262e;--rojo:#ff897d;--cyan:#65dbef;--verde:#3eb849;--oro:#ded087;}}
:root[data-theme="light"]{{--tinta:#191a1e;--suave:#5a5d66;--fondo:#e9e7e1;--panel:#f7f6f2;
  --linea:#d0cdc5;--rojo:#b23f34;--cyan:#1c6b7c;--verde:#2b7734;--oro:#8a7420;}}

*{{box-sizing:border-box}}
body{{margin:0;background:var(--fondo);color:var(--tinta);padding:0 1.25rem 6rem;
  font:15px/1.7 ui-monospace,"SF Mono",Menlo,Consolas,monospace}}
.w{{max-width:1120px;margin:0 auto}}
.n{{max-width:68ch}}
h1,h2,h3{{font-weight:400;text-wrap:balance}}
a{{color:var(--cyan)}}
img{{image-rendering:pixelated;max-width:100%;height:auto;display:block}}

header.top{{display:flex;flex-direction:column;align-items:center;gap:1.5rem;
  padding:4rem 0 2rem;text-align:center}}
header.top img{{width:min(100%,640px)}}
.claim{{max-width:60ch;color:var(--suave);font-size:1.05rem}}
.claim b{{color:var(--tinta);font-weight:400}}
.ficha{{display:flex;flex-wrap:wrap;justify-content:center;gap:0 1.5rem;width:100%;
  font-size:12px;letter-spacing:.08em;text-transform:uppercase;color:var(--suave);
  border-top:1px solid var(--linea);border-bottom:1px solid var(--linea);padding:.85rem 0}}
.ficha b{{color:var(--rojo);font-weight:400}}

nav{{display:flex;flex-wrap:wrap;gap:1.25rem;justify-content:center;padding:1.5rem 0;
  font-size:12px;letter-spacing:.08em;text-transform:uppercase}}
nav a{{color:var(--suave);text-decoration:none;border-bottom:1px solid transparent}}
nav a:hover,nav a:focus{{color:var(--tinta);border-bottom-color:var(--rojo)}}

section{{margin-top:4.5rem;scroll-margin-top:1rem}}
section>h2{{font-size:1rem;letter-spacing:.1em;text-transform:uppercase;
  border-left:3px solid var(--rojo);padding-left:.9rem;margin:0 0 1.5rem}}

.cifras{{display:grid;gap:1px;background:var(--linea);border:1px solid var(--linea);
  grid-template-columns:repeat(auto-fit,minmax(160px,1fr))}}
.cifra{{background:var(--panel);padding:1.1rem}}
.cifra b{{display:block;font-size:1.7rem;color:var(--oro);font-weight:400;
  font-variant-numeric:tabular-nums;line-height:1.2}}
.cifra span{{font-size:11px;letter-spacing:.07em;text-transform:uppercase;color:var(--suave)}}

.hall{{border-top:1px solid var(--linea);padding-top:1.75rem;margin-top:2.5rem}}
.hall:first-of-type{{border-top:0;padding-top:0;margin-top:0}}
.hall h3{{margin:0 0 .75rem;font-size:1.15rem;color:var(--rojo)}}
.hall p{{margin:0 0 1rem}}

pre.asm{{background:var(--panel);border-left:2px solid var(--verde);margin:1.25rem 0;
  padding:1rem 1.1rem;overflow-x:auto;font-size:13px;line-height:1.6;color:var(--tinta)}}

.par{{display:grid;gap:1.25rem;grid-template-columns:1fr}}
@media(min-width:820px){{.par{{grid-template-columns:1fr 1fr}}}}
.par figure{{margin:0}}
.par figcaption{{padding-top:.5rem;font-size:12px;color:var(--suave)}}

table{{border-collapse:collapse;width:100%;margin:1.25rem 0;font-size:13px}}
th,td{{text-align:left;padding:.5rem .75rem;border-bottom:1px solid var(--linea)}}
th{{color:var(--suave);font-weight:400;font-size:11px;letter-spacing:.07em;text-transform:uppercase}}
td.num{{font-variant-numeric:tabular-nums;color:var(--oro)}}

.nivel{{margin-top:2rem}}
.nivel h3{{margin:0 0 .9rem;font-size:.95rem;letter-spacing:.06em;text-transform:uppercase}}
.nivel em{{color:var(--cyan);font-style:normal}}
.sep{{color:var(--suave);margin:0 .6rem}}
.rejilla{{display:grid;gap:.9rem;grid-template-columns:repeat(auto-fill,minmax(250px,1fr))}}
.rejilla figure{{margin:0;background:var(--panel);box-shadow:0 0 0 1px var(--linea)}}
.rejilla figcaption{{display:flex;justify-content:space-between;padding:.45rem .65rem;
  font-size:11px;color:var(--suave);border-top:1px solid var(--linea)}}
.dir{{font-variant-numeric:tabular-nums;color:var(--verde)}}

footer{{margin-top:5rem;padding-top:1.5rem;border-top:1px solid var(--linea);
  color:var(--suave);font-size:12px}}
</style>

<div class="w">
<header class="top">
  {img('/tmp/logo.png','Logo de Temptations')}
  <p class="claim">Una cinta de casete de 1988, desmontada instrucción a
    instrucción. <b>Los 40.449 bytes del juego están explicados al 100%</b>.</p>
  <div class="ficha">
    <span>Topo Soft · <b>1988</b></span>
    <span>Programa <b>Luis López Navarro</b></span>
    <span>Música <b>Gominolas</b></span>
    <span>Exclusivo de MSX</span>
  </div>
</header>

<nav>
  <a href="#cifras">Cifras</a><a href="#hallazgos">Hallazgos</a>
  <a href="#bugs">Bugs</a><a href="#pantallas">Las 29 pantallas</a>
  <a href="#metodo">Cómo se hizo</a>
</nav>
<nav style="border-top:1px solid var(--linea);border-bottom:1px solid var(--linea);
            margin-bottom:1rem">
  <a href="COMO-EMPEZAR.html">Empezar</a><a href="EL-JUEGO.html">El juego</a>
  <a href="LA-CINTA.html">La cinta</a><a href="EL-CODIGO.html">El código</a>
  <a href="HALLAZGOS.html">Hallazgos</a><a href="BUGS.html">Bugs</a>
  <a href="HERRAMIENTAS.html">Herramientas</a><a href="pantallas.html">Pantallas</a>
  <a href="INVENTARIO.txt">Inventario</a>
</nav>

<section id="cifras">
  <h2>El juego en cifras</h2>
  <div class="cifras">
    <div class="cifra"><b>100%</b><span>del binario explicado</span></div>
    <div class="cifra"><b>135</b><span>rutinas identificadas</span></div>
    <div class="cifra"><b>29</b><span>mapas de pantalla</span></div>
    <div class="cifra"><b>5.214</b><span>bytes de código</span></div>
    <div class="cifra"><b>35.235</b><span>bytes de datos</span></div>
    <div class="cifra"><b>0</b><span>bytes sin identificar</span></div>
  </div>
  <p class="n" style="margin-top:1.5rem;color:var(--suave)">Que solo el 13% sea
  código no significa que falte nada: este juego es <b style="color:var(--tinta);
  font-weight:400">87% datos</b>. Dieciséis kilobytes de gráficos y veintinueve
  mapas de pantalla de 512 bytes cada uno.</p>
</section>

<section id="hallazgos">
  <h2>Lo que apareció al desmontarlo</h2>

  <div class="hall">
    <h3>El castigo del tramposo</h3>
    <p class="n">Si te terminas el juego habiendo hecho trampas, Topo no te deja
    disfrutar del final. La rutina que pinta la pantalla de victoria comprueba
    una bandera y, si está encendida, escribe un reproche encima:</p>
    {asm('''CASTIGO_TRAMPAS:
    ld a,(08f1eh)    ; bandera de tramposo
    cp 000h
    jp z,BUCLE_FINAL ; limpia -> final normal
    ld hl,07f94h     ; si no: "POR QUE NO PRUEBAS SIN POKES"
    ld de,019e0h     ; encima de la ultima linea del area de juego
    ld bc,00020h
    call 0005ch      ; y a la pantalla''')}
    <p class="n">Y no cae en un hueco cualquiera: <b>pisa exactamente la línea
    donde el juego te invita a jugar a <em>Alehop</em></b>, el siguiente título
    de la casa. Al tramposo le retiran la invitación.</p>
    <div class="par">
      <figure>{img(os.path.join(mapdir,'FINAL_limpio.png'),'Final legitimo')}
        <figcaption>El final que te has ganado.</figcaption></figure>
      <figure>{img(os.path.join(mapdir,'FINAL_con_trampa.png'),'Final con la trampa')}
        <figcaption>El final si te pillan.</figcaption></figure>
    </div>
    <p class="n"><b>Y nunca llega a saltar.</b> Buscamos en los cuatro binarios
    del juego cualquier instrucción que escriba en esa bandera, en todas sus
    formas posibles. La única referencia que existe es la lectura de arriba.</p>
    <h4 style="color:var(--oro);font-weight:400;margin:1.5rem 0 .5rem">Y se
    salvaron por los pelos</h4>
    <p class="n">La primera explicación que se nos ocurrió fue que Topo había
    dejado la trampa «armada y esperando». Los datos dicen otra cosa.</p>
    <p class="n">El arranque inicializa quince variables seguidas —<code>8F09</code>,
    <code>8F0A</code>… hasta <code>8F1C</code> y <code>8F1D</code>— y se salta
    justo la siguiente. <b>0x8F1E es la única variable que el juego lee y nunca
    inicializa.</b></p>
    <p class="n">Si vale cero es porque la cinta carga <b>relleno</b> en esa zona:
    bytes sobrantes de las tablas de animación, de los que <b>solo 3 de 160 son
    cero</b>. Uno cae justo ahí, por casualidad.</p>
    <p class="n">O sea que esto no es una trampa astuta: es un <b>bug con
    suerte</b>. Escribieron la comprobación, se olvidaron de poner la variable a
    cero, y el azar del relleno les salvó de que su propio juego insultara a
    todos los jugadores honrados.</p>
  </div>

  <div class="hall">
    <h3>Un error de imprenta de 1988</h3>
    <p class="n">El único truco publicado para el juego apareció en
    <em>MSX Book II</em> (Brasil, 1988) y dice <code>POKE &amp;HB4CC,0</code>.
    No funciona: esa posición ya vale cero. La correcta es <code>&amp;H84CC</code>,
    donde está el <code>DEC A</code> que te quita la vida. En la tipografía de
    matriz de puntos de aquellos libros, el <code>8</code> y la <code>B</code> son
    casi el mismo dibujo.</p>
    <table>
      <tr><th></th><th>Vidas antes</th><th>Vidas después</th></tr>
      <tr><td>Sin parche</td><td class="num">9</td><td class="num">8</td></tr>
      <tr><td>Con <code>0x84CC = 0</code></td><td class="num">9</td><td class="num">9</td></tr>
    </table>
    <p class="n">Comprobado en el emulador forzando la rutina de perder vida.</p>
  </div>

  <div class="hall">
    <h3>Por qué el agua del nivel 4 es verde</h3>
    <p class="n">El nivel submarino no usa tiles distintos. En el chip de vídeo
    del MSX el color 0 no es negro: es <b>transparente</b>, y por debajo se ve un
    único registro de color de fondo. Al entrar al nivel 4 el juego escribe un 12
    en ese registro y la pantalla entera se tiñe de golpe.</p>
    {asm('''ENTRA_NIVEL4:
    call EMPIEZA_NIVEL
    ld a,00ch        ; color 12 = verde
    ld (0f3ebh),a    ; registro de color de fondo
    call 00062h      ; BIOS CHGCLR: aplicalo
    ld a,001h
    ld (08f11h),a    ; y enciende el modo flotar''')}
    <p class="n">Cambiaron la ambientación de un nivel entero con un byte.</p>
  </div>

  <div class="hall">
    <h3>Trece objetos que no se ven</h3>
    <p class="n">Los cofres y calaveras que sueltan objetos no funcionan como
    parece. El juego guarda para cada pantalla una lista de <b>coordenadas</b>, y
    comprueba si tu disparo cae ahí — sin mirar qué hay dibujado.</p>
    <p class="n">De los 30 puntos que existen en todo el juego, solo 17 están
    sobre algo visible. <b>Los otros 13 son invisibles</b>, en el aire o sobre
    decorado. Las alitas que permiten volar solo salen de dos de ellos, ambos sin
    nada que los delate: el tile de las alitas no aparece ni una sola vez en los
    29 mapas.</p>
    <p class="n">Y hay trampa: en la pantalla 26, uno de esos puntos ocultos
    suelta un tile <b>mortal</b>. Disparar a todo tiene su precio.</p>
  </div>

  <div class="hall">
    <h3>La U y la V son el mismo dibujo</h3>
    <p class="n">Los textos guardados en el juego dicen cosas como
    <code>PVES SERES HORRIBLES</code> o <code>MVSICA:GOMINOLAS</code>, y sin
    embargo en pantalla se leen bien. El motivo es que los códigos de la U y la V
    dibujan exactamente el mismo glifo: da igual cuál escribas.</p>
    <figure>{img('/tmp/menu.png','Pantalla de presentacion del juego')}
      <figcaption style="padding-top:.5rem;font-size:12px;color:var(--suave)">
      La pantalla de presentación, dibujada desde el binario.</figcaption></figure>
  </div>
</section>

<section id="bugs">
  <h2>Bugs que el juego arrastra desde 1988</h2>

  <div class="hall">
    <h3>El tope de vidas nunca llega a 10</h3>
    {asm('''DA_VIDA:
    ld a,(08f12h)   ; A = vidas actuales
    inc a           ; una mas
    cp 00ah         ; ¿ha llegado a 10?
    ret z           ; SI -> se va... SIN GUARDAR
    ld (08f12h),a   ; NO -> guarda''')}
    <p class="n">El <code>ret z</code> está antes del <code>ld</code> que guarda.
    Con 9 vidas, coger otra no hace nada. El tope real es 9.</p>
  </div>

  <div class="hall">
    <h3>Al coger un objeto desaparece otro</h3>
    <p class="n">Al recoger algo, el juego lo borra del mapa buscándolo con
    <code>CPIR</code> desde el <b>principio</b> de la pantalla, no desde donde
    estás. Encuentra el primero de ese tipo, sea el que sea.</p>
    <p class="n">En la pantalla 27 hay <b>seis vidas extra</b> a la vista: cojas
    la que cojas, desaparece siempre la de arriba a la izquierda mientras la que
    acabas de tocar sigue dibujada.</p>
  </div>

  <div class="hall">
    <h3>Cada partida perdida se come un trozo de pila</h3>
    <p class="n">El juego coloca la pila una sola vez, al arrancar. Pero el game
    over reinicia con un salto que entra <b>después</b> de esa instrucción, así
    que la partida nueva empieza con el puntero donde lo dejó la anterior.
    Medido en el emulador con ocho partidas seguidas:</p>
    <table>
      <tr><th>Reinicio</th><th>Puntero de pila</th></tr>
      <tr><td class="num">1</td><td class="num">0x8FFF</td></tr>
      <tr><td class="num">3</td><td class="num">0x8FFD</td></tr>
      <tr><td class="num">5</td><td class="num">0x8FF9</td></tr>
      <tr><td class="num">8</td><td class="num">0x8FD7</td></tr>
    </table>
    <p class="n">Baja y no vuelve a subir. Las variables del juego empiezan en
    0x8F00, así que tras suficientes partidas sin resetear la pila acabaría
    pisándolas. En 1988, con siete minutos de carga por partida, era difícil
    llegar ahí. Hoy es trivial.</p>
  </div>
</section>

<section id="pantallas">
  <h2>Las 29 pantallas</h2>
  <p class="n" style="color:var(--suave)">Cada pantalla es un bloque de 512 bytes:
  32 columnas por 16 filas, un byte de tile por casilla, sin comprimir. Debajo de
  cada una, su dirección en memoria.</p>
  {''.join(galeria)}
  <div class="nivel"><h3>Y el final</h3><div class="rejilla" style="max-width:520px">
    <figure>{img(os.path.join(mapdir,'final_28.png'),'Pantalla final')}
    <figcaption><span>victoria</span><span class="dir">0xc800</span></figcaption></figure>
  </div></div>
</section>

<section id="metodo">
  <h2>Cómo se hizo, y por qué te puedes fiar</h2>
  <p class="n">Un desensamblado es fácil de hacer mal. Basta con leer unos
  gráficos como si fueran instrucciones y ya tienes páginas de código inventado
  que parece perfectamente real. De hecho nos pasó: un detector automático marcó
  como código del juego unos restos de otra compilación, se comprobó a ojo que
  <em>parecían</em> correctos, y hubo que dar marcha atrás al descubrir que nadie
  los llama.</p>
  <p class="n">Por eso el proyecto se apoya en tres comprobaciones automáticas:</p>
  <table>
    <tr><th>Comprobación</th><th>Qué caza</th></tr>
    <tr><td>Reproducibilidad</td><td>Que el fuente vuelva a dar el binario original byte a byte</td></tr>
    <tr><td>Sanidad del trazado</td><td>Que los gráficos no se hayan marcado como código — lo anterior no lo detecta</td></tr>
    <tr><td>Presupuesto de bytes</td><td>Que no quede ni un byte sin explicar</td></tr>
  </table>
  <p class="n">Y en algo más importante: buena parte de lo que se afirma aquí no
  se dedujo leyendo, sino <b>observando el juego correr</b>. Con el emulador
  openMSX se pusieron vigilantes sobre posiciones de memoria para ver qué código
  las tocaba, se muestreó el procesador durante la partida para saber qué se
  ejecuta de verdad, y se capturó la pantalla real para contrastarla con lo que
  dice el código.</p>
  <p class="n">Así se identificó el contador de vidas, por ejemplo: no por
  deducción, sino comprobando que una sola rutina lo lee y que esa rutina escribe
  el resultado en la casilla exacta del marcador donde se ve el número.</p>
</section>

<footer>
  <p><em>Temptations</em> es obra de Luis López Navarro y César Astudillo
  «Gominolas», publicada por Topo Soft en 1988. Todos los derechos sobre el juego
  siguen siendo de sus titulares. Este trabajo es de preservación, estudio y
  documentación, y no está asociado ni respaldado por Topo Soft ni por Erbe
  Software.</p>
  <p>Si eres uno de los autores y prefieres que este material no esté publicado,
  dilo y se retira sin discusión.</p>
</footer>
</div>
"""
    open(out, "w", encoding="utf-8").write(doc)
    print(f"{out}: {len(doc)//1024} KB")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3])
