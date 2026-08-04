#!/usr/bin/env python3
"""Genera la portada de la web, en ingles y en castellano.

Todo el material visual sale del propio binario -incluido el logo de la
cabecera, recortado de la pantalla de presentacion- y las imagenes van
embebidas como data URI, de modo que cada pagina es un fichero autocontenido.

  python3 tools/make_web.py <binario> <dir mapas> <salida.html> [en|es]

La inglesa se escribe en docs/index.html y la castellana en docs/es/index.html.
"""
import base64
import html as H
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_maps import render, png  # noqa: E402

ORG = 0x4000
REPO = "https://github.com/antxiko/temptations-disassembly"

# Los textos de los dos idiomas van juntos a proposito: si se toca uno, se ve
# enseguida que el otro se ha quedado descolgado.
T = {
    "en": dict(
        titulo="Temptations (1988) — a commented disassembly",
        claim="A 1988 cassette tape, taken apart one instruction at a time. "
              "<b>All 40,449 bytes of the game are accounted for</b>.",
        ficha=["Topo Soft · <b>1988</b>", "Code <b>Luis López Navarro</b>",
               "Music <b>Gominolas</b>", "MSX only"],
        nav=[("#numbers", "Numbers"), ("#findings", "Findings"), ("#bugs", "Bugs"),
             ("#screens", "All 29 screens"), ("#method", "How it was done")],
        docnav=[("GETTING-STARTED.html", "Start"), ("THE-GAME.html", "The game"),
                ("THE-TAPE.html", "The tape"), ("THE-CODE.html", "The code"),
                ("FINDINGS.html", "Findings"), ("BUGS.html", "Bugs"),
                ("TOOLS.html", "Tools"), ("pantallas.html", "Screens"),
                ("INVENTARIO.txt", "Inventory")],
        otro=("es/index.html", "Castellano"),
        h_num="The game in numbers",
        cifras=[("100%", "of the binary accounted for"), ("137", "routines identified"),
                ("29", "screen maps"), ("5,214", "bytes of code"),
                ("35,235", "bytes of data"), ("0", "bytes unidentified")],
        nota_num="Only 13% being code doesn't mean anything is missing: this game is "
                 "<b style='color:var(--tinta);font-weight:400'>87% data</b>. The graphics, "
                 "the animation tables and twenty-nine screen maps of 512 bytes each.",
        h_find="What turned up when we took it apart",
        h_bugs="Bugs the game has carried since 1988",
        h_scr="All 29 screens",
        nota_scr="Each screen is a 512-byte block: 32 columns by 16 rows, one tile byte "
                 "per cell, uncompressed. Its memory address is below each one.",
        h_met="How it was done, and why you can trust it",
        niveles=["The necropolis", "The forest", "The ruins", "The seabed"],
        nivel="Level", fin_t="Screen 29", fin_s="The ending",
        fin_d="The reward for clearing all 28 screens.",
        pie_leg="""<p><em>Temptations</em> is the work of Luis López Navarro and César
Astudillo «Gominolas», published by Topo Soft in 1988. All rights in the game remain
with their holders. This is a preservation, study and documentation effort, not
affiliated with or endorsed by Topo Soft or Erbe Software.</p>
<p>If you are one of the authors and would rather this material weren't published, say
so and it comes down, no argument.</p>""",
    ),
    "es": dict(
        titulo="Temptations (1988) — desensamblado comentado",
        claim="Una cinta de casete de 1988, desmontada instrucción a instrucción. "
              "<b>Los 40.449 bytes del juego están explicados al 100%</b>.",
        ficha=["Topo Soft · <b>1988</b>", "Programa <b>Luis López Navarro</b>",
               "Música <b>Gominolas</b>", "Exclusivo de MSX"],
        nav=[("#numbers", "Cifras"), ("#findings", "Hallazgos"), ("#bugs", "Bugs"),
             ("#screens", "Las 29 pantallas"), ("#method", "Cómo se hizo")],
        docnav=[("COMO-EMPEZAR.html", "Empezar"), ("EL-JUEGO.html", "El juego"),
                ("LA-CINTA.html", "La cinta"), ("EL-CODIGO.html", "El código"),
                ("HALLAZGOS.html", "Hallazgos"), ("BUGS.html", "Bugs"),
                ("HERRAMIENTAS.html", "Herramientas"), ("../pantallas.html", "Pantallas"),
                ("../INVENTARIO.txt", "Inventario")],
        otro=("../index.html", "English"),
        h_num="El juego en cifras",
        cifras=[("100%", "del binario explicado"), ("137", "rutinas identificadas"),
                ("29", "mapas de pantalla"), ("5.214", "bytes de código"),
                ("35.235", "bytes de datos"), ("0", "bytes sin identificar")],
        nota_num="Que solo el 13% sea código no significa que falte nada: este juego es "
                 "<b style='color:var(--tinta);font-weight:400'>87% datos</b>. Los gráficos, "
                 "las tablas de animación y veintinueve mapas de pantalla de 512 bytes cada uno.",
        h_find="Lo que apareció al desmontarlo",
        h_bugs="Bugs que el juego arrastra desde 1988",
        h_scr="Las 29 pantallas",
        nota_scr="Cada pantalla es un bloque de 512 bytes: 32 columnas por 16 filas, un "
                 "byte de tile por casilla, sin comprimir. Debajo de cada una, su "
                 "dirección en memoria.",
        h_met="Cómo se hizo, y por qué te puedes fiar",
        niveles=["La necrópolis", "El bosque", "Las ruinas", "El fondo marino"],
        nivel="Nivel", fin_t="Pantalla 29", fin_s="El final",
        fin_d="La recompensa por superar las 28 pantallas.",
        pie_leg="""<p><em>Temptations</em> es obra de Luis López Navarro y César Astudillo
«Gominolas», publicada por Topo Soft en 1988. Todos los derechos sobre el juego siguen
siendo de sus titulares. Este trabajo es de preservación, estudio y documentación, y no
está asociado ni respaldado por Topo Soft ni por Erbe Software.</p>
<p>Si eres uno de los autores y prefieres que este material no esté publicado, dilo y se
retira sin discusión.</p>""",
    ),
}

# Los comentarios de estos fragmentos van en castellano en los dos idiomas,
# porque es lo que dice el codigo fuente de verdad.
ASM = {
    "trampa": """CASTIGO_TRAMPAS:
    ld a,(08f1eh)    ; bandera de tramposo
    cp 000h
    jp z,BUCLE_FINAL ; limpia -> final normal
    ld hl,07f94h     ; si no: "POR QUE NO PRUEBAS SIN POKES"
    ld de,019e0h     ; encima de la ultima linea del area de juego
    ld bc,00020h
    call 0005ch      ; y a la pantalla""",
    "agua": """ENTRA_NIVEL4:
    call EMPIEZA_NIVEL
    ld a,00ch        ; color 12 = verde
    ld (0f3ebh),a    ; registro de color de fondo
    call 00062h      ; BIOS CHGCLR: aplicalo
    ld a,001h
    ld (08f11h),a    ; y enciende el modo flotar""",
    "vidas": """DA_VIDA:
    ld a,(08f12h)   ; A = vidas actuales
    inc a           ; una mas
    cp 00ah         ; ¿ha llegado a 10?
    ret z           ; SI -> se va... SIN GUARDAR
    ld (08f12h),a   ; NO -> guarda""",
}

CUERPO = {"en": {}, "es": {}}

CUERPO["en"]["findings"] = [
    ("The cheater's punishment", """
<p class="n">Finish the game after cheating and Topo won't let you enjoy the ending.
The routine that draws the victory screen checks a flag and, if it's set, writes a
reproach over it:</p>
{trampa}
<p class="n">And it doesn't land in empty space: it <b>overwrites exactly the line
where the game invites you to play <em>Alehop</em></b>, the company's next title. The
cheater gets the invitation withdrawn.</p>
{par}
<h4>And they got away with it by luck</h4>
<p class="n">Our first guess was that Topo had left the trap «armed and waiting». The
data says otherwise.</p>
<p class="n">Start-up initialises fifteen variables in a row —<code>8F09</code>,
<code>8F0A</code>… through <code>8F1C</code> and <code>8F1D</code>— and skips the very
next one. <b>0x8F1E is the only variable the game reads and never initialises.</b></p>
<p class="n">If it holds zero, that's because the tape loads <b>filler</b> into that
area: leftover bytes from the animation tables, of which <b>only 3 out of 160 are
zero</b>. One happens to land right there.</p>
<p class="n">So this isn't a clever trap: it's a <b>lucky bug</b>. They wrote the check,
forgot to clear the variable, and the luck of the filler saved them from their own game
insulting every honest player.</p>"""),
    ("A 1988 typo", """
<p class="n">The only published cheat for the game appeared in <em>MSX Book II</em>
(Brazil, 1988) and reads <code>POKE &amp;HB4CC,0</code>. It does nothing: that address
already holds zero. The right one is <code>&amp;H84CC</code>, where the
<code>DEC A</code> that takes your life lives. In the dot-matrix typeface of those
books, <code>8</code> and <code>B</code> are nearly the same shape.</p>
{t_poke}
<p class="n">Confirmed in the emulator by forcing the life-loss routine.</p>"""),
    ("Why the level 4 water is green", """
<p class="n">The underwater level doesn't use different tiles. On the MSX video chip,
colour 0 isn't black: it's <b>transparent</b>, and a single backdrop register shows
through. On entering level 4 the game writes a 12 into that register and the whole
display changes at once.</p>
{agua}
<p class="n">They re-skinned an entire level with one byte.</p>"""),
    ("Thirteen items you can't see", """
<p class="n">The chests and skulls that drop items don't work the way they look. The
game keeps a list of <b>coordinates</b> per screen and checks whether your shot lands on
one — without looking at what's drawn there.</p>
<p class="n">Of the 30 spots in the whole game, only 17 sit on something visible.
<b>The other 13 are invisible</b>, in mid-air or over scenery. The wings that let you fly
come from just two of them, both over plain background: the wings tile never appears in
any of the 29 maps.</p>
<p class="n">And there's a trap: on screen 26, one of those hidden spots drops a
<b>lethal</b> tile. Shooting at everything has a price.</p>"""),
    ("U and V are the same drawing", """
<p class="n">The text stored in the game reads things like
<code>PVES SERES HORRIBLES</code> or <code>MVSICA:GOMINOLAS</code>, and yet it reads
correctly on screen. The reason is that the codes for U and V draw exactly the same
glyph: it makes no difference which one you type.</p>
{menu}"""),
]
CUERPO["en"]["bugs"] = [
    ("The lives cap never reaches 10", """{vidas}
<p class="n">The <code>ret z</code> sits before the <code>ld</code> that stores. With 9
lives, picking up another does nothing. The real cap is 9.</p>"""),
    ("Picking up an item deletes another one", """
<p class="n">When you collect something, the game clears it from the map by searching
with <code>CPIR</code> from the <b>start</b> of the screen, not from where you are. It
finds the first one of that kind, whichever it is.</p>
<p class="n">Screen 27 has <b>six extra lives</b> on display: whichever you take, the
top-left one always disappears while the one you actually touched stays drawn.</p>"""),
    ("Every lost game eats a piece of the stack", """
<p class="n">The game sets the stack once, at start-up. But game over restarts with a
jump that lands <b>after</b> that instruction, so the new game begins with the pointer
wherever the previous one left it. Measured in the emulator over eight games in a
row:</p>
{t_pila}
<p class="n">It goes down and never comes back up. The game's variables start at 0x8F00,
so after enough games without a reset the stack would run into them. In 1988, with seven
minutes of loading per game, getting there was hard. Today it's trivial.</p>"""),
]
CUERPO["en"]["method"] = """
<p class="n">A disassembly is easy to get wrong. Read some graphics as if they were
instructions and you get pages of invented code that looks perfectly real. It happened
to us: an automatic detector flagged leftovers from another build as game code, a quick
eyeball said they <em>looked</em> right, and it had to be undone once we found nothing
ever calls them.</p>
<p class="n">That's why the project leans on four automatic checks:</p>
{t_metodo}
<p class="n">And on something more important: much of what's claimed here wasn't deduced
by reading but by <b>watching the game run</b>. Using the openMSX emulator we set
watchpoints on memory to see which code touched what, sampled the processor during play
to know what actually executes, and captured the real display to check it against what
the code says.</p>
<p class="n">That's how the lives counter was identified, for instance: not by deduction,
but by confirming that a single routine reads it and that this routine writes the result
into the exact status-bar cell where the number appears.</p>"""
CUERPO["en"]["t_poke"] = [("", "Lives before", "Lives after"),
                          ("Unpatched", "9", "8"), ("With <code>0x84CC = 0</code>", "9", "9")]
CUERPO["en"]["t_pila"] = [("Restart", "Stack pointer"), ("1", "0x8FFF"), ("3", "0x8FFD"),
                          ("5", "0x8FF9"), ("8", "0x8FD7")]
CUERPO["en"]["t_metodo"] = [
    ("Check", "What it catches"),
    ("Tests", "36 of them, including a set that verifies the docs aren't lying"),
    ("Reproducibility", "That the source rebuilds the original binary byte for byte"),
    ("Trace sanity", "That graphics weren't marked as code — the check above misses this"),
    ("Byte budget", "That not a single byte is left unaccounted for")]

CUERPO["es"]["findings"] = [
    ("El castigo del tramposo", """
<p class="n">Si te terminas el juego habiendo hecho trampas, Topo no te deja disfrutar
del final. La rutina que pinta la pantalla de victoria comprueba una bandera y, si está
encendida, escribe un reproche encima:</p>
{trampa}
<p class="n">Y no cae en un hueco cualquiera: <b>pisa exactamente la línea donde el
juego te invita a jugar a <em>Alehop</em></b>, el siguiente título de la casa. Al
tramposo le retiran la invitación.</p>
{par}
<h4>Y se salvaron por los pelos</h4>
<p class="n">La primera explicación que se nos ocurrió fue que Topo había dejado la
trampa «armada y esperando». Los datos dicen otra cosa.</p>
<p class="n">El arranque inicializa quince variables seguidas —<code>8F09</code>,
<code>8F0A</code>… hasta <code>8F1C</code> y <code>8F1D</code>— y se salta justo la
siguiente. <b>0x8F1E es la única variable que el juego lee y nunca inicializa.</b></p>
<p class="n">Si vale cero es porque la cinta carga <b>relleno</b> en esa zona: bytes
sobrantes de las tablas de animación, de los que <b>solo 3 de 160 son cero</b>. Uno cae
justo ahí, por casualidad.</p>
<p class="n">O sea que esto no es una trampa astuta: es un <b>bug con suerte</b>.
Escribieron la comprobación, se olvidaron de poner la variable a cero, y el azar del
relleno les salvó de que su propio juego insultara a todos los jugadores honrados.</p>"""),
    ("Un error de imprenta de 1988", """
<p class="n">El único truco publicado para el juego apareció en <em>MSX Book II</em>
(Brasil, 1988) y dice <code>POKE &amp;HB4CC,0</code>. No funciona: esa posición ya vale
cero. La correcta es <code>&amp;H84CC</code>, donde está el <code>DEC A</code> que te
quita la vida. En la tipografía de matriz de puntos de aquellos libros, el
<code>8</code> y la <code>B</code> son casi el mismo dibujo.</p>
{t_poke}
<p class="n">Comprobado en el emulador forzando la rutina de perder vida.</p>"""),
    ("Por qué el agua del nivel 4 es verde", """
<p class="n">El nivel submarino no usa tiles distintos. En el chip de vídeo del MSX el
color 0 no es negro: es <b>transparente</b>, y por debajo se ve un único registro de
color de fondo. Al entrar al nivel 4 el juego escribe un 12 en ese registro y la pantalla
entera se tiñe de golpe.</p>
{agua}
<p class="n">Cambiaron la ambientación de un nivel entero con un byte.</p>"""),
    ("Trece objetos que no se ven", """
<p class="n">Los cofres y calaveras que sueltan objetos no funcionan como parece. El
juego guarda para cada pantalla una lista de <b>coordenadas</b>, y comprueba si tu
disparo cae ahí — sin mirar qué hay dibujado.</p>
<p class="n">De los 30 puntos que existen en todo el juego, solo 17 están sobre algo
visible. <b>Los otros 13 son invisibles</b>, en el aire o sobre decorado. Las alitas que
permiten volar solo salen de dos de ellos, ambos sin nada que los delate: el tile de las
alitas no aparece ni una sola vez en los 29 mapas.</p>
<p class="n">Y hay trampa: en la pantalla 26, uno de esos puntos ocultos suelta un tile
<b>mortal</b>. Disparar a todo tiene su precio.</p>"""),
    ("La U y la V son el mismo dibujo", """
<p class="n">Los textos guardados en el juego dicen cosas como
<code>PVES SERES HORRIBLES</code> o <code>MVSICA:GOMINOLAS</code>, y sin embargo en
pantalla se leen bien. El motivo es que los códigos de la U y la V dibujan exactamente
el mismo glifo: da igual cuál escribas.</p>
{menu}"""),
]
CUERPO["es"]["bugs"] = [
    ("El tope de vidas nunca llega a 10", """{vidas}
<p class="n">El <code>ret z</code> está antes del <code>ld</code> que guarda. Con 9
vidas, coger otra no hace nada. El tope real es 9.</p>"""),
    ("Al coger un objeto desaparece otro", """
<p class="n">Al recoger algo, el juego lo borra del mapa buscándolo con
<code>CPIR</code> desde el <b>principio</b> de la pantalla, no desde donde estás.
Encuentra el primero de ese tipo, sea el que sea.</p>
<p class="n">En la pantalla 27 hay <b>seis vidas extra</b> a la vista: cojas la que
cojas, desaparece siempre la de arriba a la izquierda mientras la que acabas de tocar
sigue dibujada.</p>"""),
    ("Cada partida perdida se come un trozo de pila", """
<p class="n">El juego coloca la pila una sola vez, al arrancar. Pero el game over
reinicia con un salto que entra <b>después</b> de esa instrucción, así que la partida
nueva empieza con el puntero donde lo dejó la anterior. Medido en el emulador con ocho
partidas seguidas:</p>
{t_pila}
<p class="n">Baja y no vuelve a subir. Las variables del juego empiezan en 0x8F00, así
que tras suficientes partidas sin resetear la pila acabaría pisándolas. En 1988, con
siete minutos de carga por partida, era difícil llegar ahí. Hoy es trivial.</p>"""),
]
CUERPO["es"]["method"] = """
<p class="n">Un desensamblado es fácil de hacer mal. Basta con leer unos gráficos como si
fueran instrucciones y ya tienes páginas de código inventado que parece perfectamente
real. De hecho nos pasó: un detector automático marcó como código del juego unos restos
de otra compilación, se comprobó a ojo que <em>parecían</em> correctos, y hubo que dar
marcha atrás al descubrir que nadie los llama.</p>
<p class="n">Por eso el proyecto se apoya en cuatro comprobaciones automáticas:</p>
{t_metodo}
<p class="n">Y en algo más importante: buena parte de lo que se afirma aquí no se dedujo
leyendo, sino <b>observando el juego correr</b>. Con el emulador openMSX se pusieron
vigilantes sobre posiciones de memoria para ver qué código las tocaba, se muestreó el
procesador durante la partida para saber qué se ejecuta de verdad, y se capturó la
pantalla real para contrastarla con lo que dice el código.</p>
<p class="n">Así se identificó el contador de vidas, por ejemplo: no por deducción, sino
comprobando que una sola rutina lo lee y que esa rutina escribe el resultado en la
casilla exacta del marcador donde se ve el número.</p>"""
CUERPO["es"]["t_poke"] = [("", "Vidas antes", "Vidas después"),
                          ("Sin parche", "9", "8"), ("Con <code>0x84CC = 0</code>", "9", "9")]
CUERPO["es"]["t_pila"] = [("Reinicio", "Puntero de pila"), ("1", "0x8FFF"), ("3", "0x8FFD"),
                          ("5", "0x8FF9"), ("8", "0x8FD7")]
CUERPO["es"]["t_metodo"] = [
    ("Comprobación", "Qué caza"),
    ("Tests", "36, incluidos unos que verifican que la documentación no miente"),
    ("Reproducibilidad", "Que el fuente vuelva a dar el binario original byte a byte"),
    ("Sanidad del trazado", "Que los gráficos no se hayan marcado como código; lo anterior no lo detecta"),
    ("Presupuesto de bytes", "Que no quede ni un byte sin explicar")]

ESTILO = """
:root{--tinta:#cfd0d4;--suave:#83868f;--fondo:#000;--panel:#0c0e13;--linea:#23262e;
  --rojo:#ff897d;--cyan:#65dbef;--verde:#3eb849;--oro:#ded087}
@media (prefers-color-scheme:light){:root{--tinta:#191a1e;--suave:#5a5d66;--fondo:#e9e7e1;
  --panel:#f7f6f2;--linea:#d0cdc5;--rojo:#b23f34;--cyan:#1c6b7c;--verde:#2b7734;--oro:#8a7420}}
:root[data-theme="dark"]{--tinta:#cfd0d4;--suave:#83868f;--fondo:#000;--panel:#0c0e13;
  --linea:#23262e;--rojo:#ff897d;--cyan:#65dbef;--verde:#3eb849;--oro:#ded087}
:root[data-theme="light"]{--tinta:#191a1e;--suave:#5a5d66;--fondo:#e9e7e1;--panel:#f7f6f2;
  --linea:#d0cdc5;--rojo:#b23f34;--cyan:#1c6b7c;--verde:#2b7734;--oro:#8a7420}
*{box-sizing:border-box}
body{margin:0;background:var(--fondo);color:var(--tinta);padding:0 1.25rem 6rem;
  font:15px/1.7 ui-monospace,"SF Mono",Menlo,Consolas,monospace}
.w{max-width:1120px;margin:0 auto}
.n{max-width:68ch}
h1,h2,h3,h4{font-weight:400;text-wrap:balance}
a{color:var(--cyan)}
img{image-rendering:pixelated;max-width:100%;height:auto;display:block}
header.top{display:flex;flex-direction:column;align-items:center;gap:1.5rem;
  padding:4rem 0 2rem;text-align:center}
header.top img{width:min(100%,640px)}
.claim{max-width:60ch;color:var(--suave);font-size:1.05rem}
.claim b{color:var(--tinta);font-weight:400}
.ficha{display:flex;flex-wrap:wrap;justify-content:center;gap:0 1.5rem;width:100%;
  font-size:12px;letter-spacing:.08em;text-transform:uppercase;color:var(--suave);
  border-top:1px solid var(--linea);border-bottom:1px solid var(--linea);padding:.85rem 0}
.ficha b{color:var(--rojo);font-weight:400}
nav{display:flex;flex-wrap:wrap;gap:1.25rem;justify-content:center;padding:1.25rem 0;
  font-size:12px;letter-spacing:.08em;text-transform:uppercase}
nav a{color:var(--suave);text-decoration:none;border-bottom:1px solid transparent}
nav a:hover,nav a:focus{color:var(--tinta);border-bottom-color:var(--rojo)}
nav.docs{border-top:1px solid var(--linea);border-bottom:1px solid var(--linea);
  margin-bottom:1rem}
section{margin-top:4.5rem;scroll-margin-top:1rem}
section>h2{font-size:1rem;letter-spacing:.1em;text-transform:uppercase;
  border-left:3px solid var(--rojo);padding-left:.9rem;margin:0 0 1.5rem}
.cifras{display:grid;gap:1px;background:var(--linea);border:1px solid var(--linea);
  grid-template-columns:repeat(auto-fit,minmax(160px,1fr))}
.cifra{background:var(--panel);padding:1.1rem}
.cifra b{display:block;font-size:1.7rem;color:var(--oro);font-weight:400;
  font-variant-numeric:tabular-nums;line-height:1.2}
.cifra span{font-size:11px;letter-spacing:.07em;text-transform:uppercase;color:var(--suave)}
.hall{border-top:1px solid var(--linea);padding-top:1.75rem;margin-top:2.5rem}
.hall:first-of-type{border-top:0;padding-top:0;margin-top:0}
.hall h3{margin:0 0 .75rem;font-size:1.15rem;color:var(--rojo)}
.hall h4{color:var(--oro);margin:1.5rem 0 .5rem;font-size:.95rem}
.hall p{margin:0 0 1rem}
pre.asm{background:var(--panel);border-left:2px solid var(--verde);margin:1.25rem 0;
  padding:1rem 1.1rem;overflow-x:auto;font-size:13px;line-height:1.6;color:var(--tinta)}
.par{display:grid;gap:1.25rem;grid-template-columns:1fr}
@media(min-width:820px){.par{grid-template-columns:1fr 1fr}}
.par figure{margin:0}
table{border-collapse:collapse;width:100%;margin:1.25rem 0;font-size:13px;display:block;
  overflow-x:auto}
th,td{text-align:left;padding:.5rem .75rem;border-bottom:1px solid var(--linea)}
th{color:var(--suave);font-weight:400;font-size:11px;letter-spacing:.07em;text-transform:uppercase}
td.num{font-variant-numeric:tabular-nums;color:var(--oro)}
.nivel{margin-top:2rem}
.nivel h3{margin:0 0 .9rem;font-size:.95rem;letter-spacing:.06em;text-transform:uppercase}
.nivel em{color:var(--cyan);font-style:normal}
.sep{color:var(--suave);margin:0 .6rem}
.rejilla{display:grid;gap:.9rem;grid-template-columns:repeat(auto-fill,minmax(250px,1fr))}
.rejilla figure{margin:0;background:var(--panel);box-shadow:0 0 0 1px var(--linea)}
.rejilla figcaption{display:flex;justify-content:space-between;padding:.45rem .65rem;
  font-size:11px;color:var(--suave);border-top:1px solid var(--linea)}
.dir{font-variant-numeric:tabular-nums;color:var(--verde)}
footer{margin-top:5rem;padding-top:1.5rem;border-top:1px solid var(--linea);
  color:var(--suave);font-size:12px}
"""


def recorta(d, base_nt, col0, fila0, ncols, nfilas, escala=3):
    pat = d[0x4000 - ORG:0x4800 - ORG]
    col = d[0x4800 - ORG:0x5000 - ORG]
    nt = d[base_nt - ORG:base_nt - ORG + 0x300]
    sub = bytes(nt[(fila0 + y) * 32 + col0 + x]
                for y in range(nfilas) for x in range(ncols))
    return render(pat, col, sub, ncols, nfilas, escala, backdrop=1)


def b64(p):
    return base64.b64encode(open(p, "rb").read()).decode()


def img(p, alt):
    return f'<img src="data:image/png;base64,{b64(p)}" alt="{H.escape(alt)}" loading="lazy">'


def tabla(filas):
    cab = "".join(f"<th>{c}</th>" for c in filas[0])
    cuerpo = ""
    for f in filas[1:]:
        celdas = "".join(
            f'<td class="num">{c}</td>' if c.startswith("0x") or c.isdigit() else f"<td>{c}</td>"
            for c in f)
        cuerpo += f"<tr>{celdas}</tr>"
    return f"<table><tr>{cab}</tr>{cuerpo}</table>"


def main(binpath, mapdir, out, idioma="en"):
    d = open(binpath, "rb").read()
    t, c = T[idioma], CUERPO[idioma]

    w, h, im = recorta(d, 0x5CC0, 6, 5, 21, 9, escala=3)
    png("/tmp/_logo.png", w, h, im)
    w, h, im = recorta(d, 0x5CC0, 0, 0, 32, 24, escala=2)
    png("/tmp/_menu.png", w, h, im)

    subs = {k: f'<pre class="asm">{H.escape(v)}</pre>' for k, v in ASM.items()}
    subs.update(
        t_poke=tabla(c["t_poke"]), t_pila=tabla(c["t_pila"]), t_metodo=tabla(c["t_metodo"]),
        menu=f'<figure>{img("/tmp/_menu.png", "Title screen")}</figure>',
        par='<div class="par">'
            f'<figure>{img(os.path.join(mapdir, "FINAL_limpio.png"), "Legit ending")}</figure>'
            f'<figure>{img(os.path.join(mapdir, "FINAL_con_trampa.png"), "Ending with the trap")}</figure>'
            '</div>')

    def bloques(lista):
        return "".join(f'<div class="hall"><h3>{tit}</h3>{cu.format(**subs)}</div>'
                       for tit, cu in lista)

    galeria = ""
    for niv in range(4):
        cartas = ""
        for p in range(7):
            i = niv * 7 + p
            fn = os.path.join(mapdir, f"nivel{niv+1}_pantalla{p+1}_{i:02d}.png")
            cartas += (f'<figure>{img(fn, f"{t["nivel"]} {niv+1}")}<figcaption>'
                       f'<span>{p+1}</span><span class="dir">{0x9000+i*512:#06x}</span>'
                       f'</figcaption></figure>')
        galeria += (f'<div class="nivel"><h3>{t["nivel"]} {niv+1}<span class="sep">·</span>'
                    f'<em>{t["niveles"][niv]}</em></h3><div class="rejilla">{cartas}</div></div>')

    nav = "".join(f'<a href="{h}">{x}</a>' for h, x in t["nav"])
    docnav = "".join(f'<a href="{h}">{x}</a>' for h, x in t["docnav"])
    docnav += f'<a href="{REPO}">GitHub</a>'
    docnav += (f'<a href="{t["otro"][0]}" style="margin-left:auto;color:var(--oro)">'
               f'{t["otro"][1]}</a>')

    doc = f"""<title>{t["titulo"]}</title>
<style>{ESTILO}</style>
<div class="w">
<header class="top">
  {img("/tmp/_logo.png", "Temptations logo")}
  <p class="claim">{t["claim"]}</p>
  <div class="ficha">{"".join(f"<span>{x}</span>" for x in t["ficha"])}</div>
</header>
<nav>{nav}</nav>
<nav class="docs">{docnav}</nav>

<section id="numbers">
  <h2>{t["h_num"]}</h2>
  <div class="cifras">{"".join(f'<div class="cifra"><b>{a}</b><span>{b}</span></div>'
                                for a, b in t["cifras"])}</div>
  <p class="n" style="margin-top:1.5rem;color:var(--suave)">{t["nota_num"]}</p>
</section>

<section id="findings"><h2>{t["h_find"]}</h2>{bloques(c["findings"])}</section>
<section id="bugs"><h2>{t["h_bugs"]}</h2>{bloques(c["bugs"])}</section>

<section id="screens">
  <h2>{t["h_scr"]}</h2>
  <p class="n" style="color:var(--suave)">{t["nota_scr"]}</p>
  {galeria}
  <div class="nivel"><h3>{t["fin_t"]}<span class="sep">·</span><em>{t["fin_s"]}</em></h3>
  <p class="n" style="color:var(--suave)">{t["fin_d"]}</p>
  <div class="rejilla" style="max-width:520px">
    <figure>{img(os.path.join(mapdir, "final_28.png"), t["fin_s"])}
    <figcaption><span>29</span><span class="dir">0xc800</span></figcaption></figure>
  </div></div>
</section>

<section id="method"><h2>{t["h_met"]}</h2>{c["method"].format(**subs)}</section>

<footer>{t["pie_leg"]}</footer>
</div>
"""
    open(out, "w", encoding="utf-8").write(doc)
    print(f"  {out}: {len(doc)//1024} KB ({idioma})")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3],
         sys.argv[4] if len(sys.argv) > 4 else "en")
