#!/usr/bin/env python3
"""Convierte los documentos .md a HTML con el estilo del proyecto.

Asi la web de GitHub Pages es navegable entera, sin depender de Jekyll ni de
ninguna gema: se publica HTML plano y ya esta.

Soporta lo que usamos de Markdown: encabezados, parrafos, listas, tablas,
bloques de codigo, citas, enlaces, imagenes, negrita, cursiva, codigo en linea
y separadores.
"""
import html
import os
import re
import sys

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
  font:15px/1.75 ui-monospace,"SF Mono",Menlo,Consolas,monospace}
.w{max-width:78ch;margin:0 auto}
a{color:var(--cyan)}
img{max-width:100%;height:auto;display:block;image-rendering:pixelated;margin:1.5rem 0}
h1,h2,h3,h4{font-weight:400;text-wrap:balance;line-height:1.35}
h1{font-size:1.6rem;margin:2.5rem 0 .5rem}
h2{font-size:1.05rem;letter-spacing:.08em;text-transform:uppercase;margin:3rem 0 1rem;
  border-left:3px solid var(--rojo);padding-left:.9rem}
h3{font-size:1.1rem;color:var(--rojo);margin:2rem 0 .6rem}
h4{font-size:.95rem;color:var(--oro);margin:1.5rem 0 .4rem}
hr{border:0;border-top:1px solid var(--linea);margin:2.5rem 0}
blockquote{margin:1.25rem 0;padding:.6rem 0 .6rem 1.1rem;border-left:2px solid var(--oro);
  color:var(--suave)}
pre{background:var(--panel);border-left:2px solid var(--verde);padding:1rem 1.1rem;
  overflow-x:auto;font-size:13px;line-height:1.6;margin:1.25rem 0}
code{color:var(--oro);font-size:.94em}
pre code{color:var(--tinta)}
table{border-collapse:collapse;width:100%;margin:1.25rem 0;font-size:13px;display:block;
  overflow-x:auto}
th,td{text-align:left;padding:.5rem .75rem;border-bottom:1px solid var(--linea)}
th{color:var(--suave);font-weight:400;font-size:11px;letter-spacing:.07em;text-transform:uppercase}
ul,ol{padding-left:1.4rem}
li{margin:.3rem 0}
nav.top{display:flex;flex-wrap:wrap;gap:1.25rem;padding:1.5rem 0;margin-bottom:1rem;
  border-bottom:1px solid var(--linea);font-size:12px;letter-spacing:.08em;
  text-transform:uppercase}
nav.top a{color:var(--suave);text-decoration:none}
nav.top a:hover{color:var(--tinta)}
footer{margin-top:4rem;padding-top:1.25rem;border-top:1px solid var(--linea);
  color:var(--suave);font-size:12px}
"""

# Un menu por idioma. La web se publica en ingles en la raiz de docs/ y en
# castellano bajo docs/es/.
NAV_EN = [("index.html", "Home"), ("GETTING-STARTED.html", "Start"),
          ("THE-GAME.html", "The game"), ("THE-TAPE.html", "The tape"),
          ("THE-CODE.html", "The code"), ("FINDINGS.html", "Findings"),
          ("BUGS.html", "Bugs"), ("TOOLS.html", "Tools"),
          ("pantallas.html", "Screens")]
NAV_ES = [("index.html", "Portada"), ("COMO-EMPEZAR.html", "Empezar"),
          ("EL-JUEGO.html", "El juego"), ("LA-CINTA.html", "La cinta"),
          ("EL-CODIGO.html", "El código"), ("HALLAZGOS.html", "Hallazgos"),
          ("BUGS.html", "Bugs"), ("HERRAMIENTAS.html", "Herramientas"),
          ("../pantallas.html", "Pantallas")]

# Cada documento tiene su pareja en el otro idioma, para el selector.
PAREJA = {
    "index.html": "index.html",
    "GETTING-STARTED.html": "COMO-EMPEZAR.html", "COMO-EMPEZAR.html": "GETTING-STARTED.html",
    "THE-GAME.html": "EL-JUEGO.html",   "EL-JUEGO.html": "THE-GAME.html",
    "THE-TAPE.html": "LA-CINTA.html",   "LA-CINTA.html": "THE-TAPE.html",
    "THE-CODE.html": "EL-CODIGO.html",  "EL-CODIGO.html": "THE-CODE.html",
    "FINDINGS.html": "HALLAZGOS.html",  "HALLAZGOS.html": "FINDINGS.html",
    "BUGS.html": "BUGS.html",
    "TOOLS.html": "HERRAMIENTAS.html",  "HERRAMIENTAS.html": "TOOLS.html",
    "CONTEXT.html": "CONTEXTO.html",    "CONTEXTO.html": "CONTEXT.html",
}


def enlinea(t):
    """Formato dentro de una linea: codigo, negrita, cursiva, enlaces, imagenes."""
    trozos = re.split(r"(`[^`]+`)", t)
    out = []
    for i, tr in enumerate(trozos):
        if i % 2:                                   # dentro de comillas: literal
            out.append(f"<code>{html.escape(tr[1:-1])}</code>")
            continue
        s = html.escape(tr)
        s = re.sub(r"!\[([^\]]*)\]\(([^)]+)\)", r'<img src="\2" alt="\1">', s)
        s = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", lambda m:
                   f'<a href="{ruta(m.group(2))}">{m.group(1)}</a>', s)
        s = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", s)
        s = re.sub(r"(?<![\w*])\*([^*\n]+)\*(?![\w*])", r"<em>\1</em>", s)
        out.append(s)
    return "".join(out)


# La web se sirve desde docs/, asi que lo que este fuera de esa carpeta no
# existe para el navegador: esos enlaces se mandan al repositorio.
REPO = os.environ.get("TEMPT_REPO", "https://github.com/antxiko/temptations-disassembly")


def ruta(href):
    """Los enlaces entre documentos apuntan a .md; en la web van a .html."""
    if href.startswith(("http", "#", "mailto:")):
        return href
    h = href.replace("docs/", "")
    if h.startswith("../") and not h.startswith("../src") and not h.startswith("../tools"):
        return h if h.endswith((".html", ".png", ".txt")) else h.replace("../", "")
    h = h.replace("../", "")
    # Codigo fuente, herramientas y ficheros de la raiz: no estan bajo docs/
    if h.startswith(("src/", "tools/")) or h in (
            "README.md", "LICENSE", "AVISO-LEGAL.md", "Makefile"):
        return f"{REPO}/blob/main/{h}"
    if h.endswith(".md"):
        h = h[:-3] + ".html"
    return h


def convierte(texto, titulo, actual, idioma="en"):
    ln = texto.split("\n")
    out, i = [], 0
    while i < len(ln):
        l = ln[i]
        if l.startswith("```"):                     # bloque de codigo
            j = i + 1
            cuerpo = []
            while j < len(ln) and not ln[j].startswith("```"):
                cuerpo.append(ln[j]); j += 1
            out.append("<pre><code>" + html.escape("\n".join(cuerpo)) + "</code></pre>")
            i = j + 1; continue
        if re.match(r"^\s*\|", l) and i + 1 < len(ln) and re.match(r"^\s*\|[\s:|-]+\|?\s*$", ln[i + 1]):
            filas = []                              # tabla
            while i < len(ln) and re.match(r"^\s*\|", ln[i]):
                filas.append([c.strip() for c in ln[i].strip().strip("|").split("|")])
                i += 1
            cab, cuerpo = filas[0], filas[2:]
            t = "<table><tr>" + "".join(f"<th>{enlinea(c)}</th>" for c in cab) + "</tr>"
            for f in cuerpo:
                t += "<tr>" + "".join(f"<td>{enlinea(c)}</td>" for c in f) + "</tr>"
            out.append(t + "</table>"); continue
        m = re.match(r"^(#{1,4})\s+(.*)$", l)
        if m:
            n = len(m.group(1))
            out.append(f"<h{n}>{enlinea(m.group(2))}</h{n}>"); i += 1; continue
        if re.match(r"^---+\s*$", l):
            out.append("<hr>"); i += 1; continue
        if l.startswith(">"):
            cita = []
            while i < len(ln) and ln[i].startswith(">"):
                cita.append(ln[i].lstrip("> ").rstrip()); i += 1
            out.append(f"<blockquote>{enlinea(' '.join(cita))}</blockquote>"); continue
        m = re.match(r"^\s*([-*]|\d+\.)\s+", l)
        if m:
            orden = not m.group(1) in "-*"
            items, sangria = [], []
            while i < len(ln) and (re.match(r"^\s*([-*]|\d+\.)\s+", ln[i]) or
                                   (sangria and ln[i].startswith("  ") and ln[i].strip())):
                mm = re.match(r"^\s*(?:[-*]|\d+\.)\s+(.*)$", ln[i])
                if mm:
                    items.append(mm.group(1)); sangria = True
                else:
                    items[-1] += " " + ln[i].strip()
                i += 1
            tag = "ol" if orden else "ul"
            out.append(f"<{tag}>" + "".join(f"<li>{enlinea(x)}</li>" for x in items) + f"</{tag}>")
            continue
        if not l.strip():
            i += 1; continue
        parr = []                                   # parrafo
        while i < len(ln) and ln[i].strip() and not re.match(
                r"^(#{1,4}\s|```|>|\s*([-*]|\d+\.)\s|---+\s*$|\s*\|)", ln[i]):
            parr.append(ln[i].strip()); i += 1
        out.append(f"<p>{enlinea(' '.join(parr))}</p>")

    menu = NAV_EN if idioma == "en" else NAV_ES
    nav = "".join(f'<a href="{h}"{" style=color:var(--tinta)" if h == actual else ""}>{t}</a>'
                  for h, t in menu)
    # Selector de idioma: lleva al documento equivalente, no a la portada
    otro = PAREJA.get(actual, "index.html")
    if idioma == "en":
        nav += f'<a href="es/{otro}" style="margin-left:auto;color:var(--oro)">Castellano</a>'
    else:
        nav += f'<a href="../{otro}" style="margin-left:auto;color:var(--oro)">English</a>' 
    return (f"<title>{html.escape(titulo)}</title>\n<style>{ESTILO}</style>\n"
            f'<div class="w"><nav class="top">{nav}</nav>\n' + "\n".join(out) +
            '\n<footer><p><em>Temptations</em> es obra de Luis López Navarro y César '
            'Astudillo «Gominolas», publicada por Topo Soft en 1988. Todos los derechos '
            'sobre el juego siguen siendo de sus titulares. Este trabajo es de '
            'preservación, estudio y documentación.</p></footer></div>\n')


def main(docdir, idioma="en"):
    n = 0
    for fn in sorted(os.listdir(docdir)):
        if not fn.endswith(".md"):
            continue
        src = os.path.join(docdir, fn)
        dst = os.path.join(docdir, fn[:-3] + ".html")
        texto = open(src, encoding="utf-8").read()
        m = re.search(r"^#\s+(.*)$", texto, re.M)
        titulo = (m.group(1) if m else fn[:-3]) + " — Temptations (1988)"
        open(dst, "w", encoding="utf-8").write(
            convierte(texto, titulo, fn[:-3] + ".html", idioma))
        print(f"  {fn} -> {os.path.basename(dst)}")
        n += 1
    print(f"{n} documentos convertidos ({idioma})")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "en")
