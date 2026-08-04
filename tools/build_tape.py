#!/usr/bin/env python3
"""Construye una cinta TSX jugable a partir de los binarios que produce el build.

Es la prueba de fuego del proyecto: coge los .asm comentados, los ensambla, y
vuelve a montar la cinta con ese resultado. Si esa cinta carga y el juego
arranca en el emulador, el desensamblado sirve de verdad para modificar el
juego, no solo para leerlo.

Reconstruye cada bloque con el formato que espera el MSX:
  - Ficheros normales: cabecera de 10 bytes iguales + 6 de nombre, en un bloque
    KCS aparte, y los datos en el siguiente (los BIN llevan delante las tres
    direcciones de carga/fin/ejecucion).
  - Bloques turbo: un 0x00 de sincronismo, los datos, y un byte de checksum tal
    que el XOR de todo el bloque de.
"""
import functools
import json
import operator
import os
import shutil
import subprocess
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# listado .asm -> (binario de referencia, indice del bloque de datos en la cinta,
#                  cabecera BIN a anteponer o None, es_turbo)
MODULOS = [
    ("src/temptations_topo.asm",    7,  (0x9470, 0xA50D, 0x9470), False),
    ("src/temptations_slots.asm",   9,  (0xC350, 0xC60B, 0xC58F), False),
    ("src/temptations_portada.asm", 10, None, True),
    ("src/temptations_game.asm",    11, None, True),
]


def ensambla(asm):
    out = f"/tmp/{os.path.basename(asm)}.bin"
    r = subprocess.run(["pasmo", "--bin", asm, out], capture_output=True, text=True)
    if r.returncode != 0:
        print(f"FALLO al ensamblar {asm}:\n{r.stderr[:600]}")
        sys.exit(1)
    return open(out, "rb").read()


def main(outdir, tsxout):
    src = os.path.join(RAIZ, "extracted")
    os.makedirs(outdir, exist_ok=True)
    # Se parte de los bloques originales y solo se sustituyen los que generamos.
    for fn in os.listdir(src):
        if fn.endswith(".raw") or fn == "manifest.json":
            shutil.copy(os.path.join(src, fn), os.path.join(outdir, fn))

    man = json.load(open(os.path.join(outdir, "manifest.json")))

    for asm, idx, binhdr, turbo in MODULOS:
        data = ensambla(os.path.join(RAIZ, asm))
        if binhdr:
            ld, end, exe = binhdr
            blob = bytes([ld & 255, ld >> 8, end & 255, end >> 8,
                          exe & 255, exe >> 8]) + data
        else:
            # Bloque turbo: 0x00 de sincronismo + datos + checksum XOR
            chk = functools.reduce(operator.xor, data, 0)
            blob = b"\x00" + data + bytes([chk])
        fn = man["blocks"][idx]["data"]
        antes = open(os.path.join(outdir, fn), "rb").read()
        open(os.path.join(outdir, fn), "wb").write(blob)
        estado = "identico" if blob == antes else f"DISTINTO ({len(antes)}->{len(blob)})"
        print(f"  bloque {idx:2d} <- {os.path.basename(asm):32s} {len(blob):6d} bytes  {estado}")

    subprocess.run([sys.executable, os.path.join(RAIZ, "tools/tsx_build.py"),
                    os.path.join(outdir, "manifest.json"), tsxout, outdir], check=True)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
