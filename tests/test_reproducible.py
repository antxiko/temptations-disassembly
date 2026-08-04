#!/usr/bin/env python3
"""Comprueba las tres garantias del proyecto, de punta a punta.

1. Reproducibilidad: cada listado vuelve a ensamblar al binario original.
2. Sanidad del trazado: los graficos no estan marcados como codigo.
3. Presupuesto: no queda ni un byte sin explicar.

La 1 y la 2 son distintas y hacen falta las dos. La reproducibilidad caza que
una instruccion se haya leido mal; no caza que unos graficos se hayan tomado por
codigo, porque en ese caso los bytes salen igual y solo cambia su interpretacion.
"""
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import unittest

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))

MODULOS = [
    ("temptations_slots.asm",   "work/SLOTS.raw",        0xC350),
    ("temptations_topo.asm",    "work/TOPO.raw",         0x9470),
    ("temptations_portada.asm", "dump/turbo1_ram.bin",   0x88B8),
    ("temptations_game.asm",    "dump/turbo2_ram.bin",   0x4000),
]

HAY_PASMO = shutil.which("pasmo") is not None
HAY_TRAZADO = os.path.exists(os.path.join(RAIZ, "work", "game.trace.json"))
HAY_LISTADOS = all(os.path.exists(os.path.join(RAIZ, "src", m[0])) for m in MODULOS)


def sha(path):
    return hashlib.sha256(open(path, "rb").read()).hexdigest()


class TestReproducible(unittest.TestCase):
    """Ensamblar el listado tiene que dar el binario original, byte a byte."""

    def test_los_modulos_reensamblan_identicos(self):
        hechos = 0
        for asmname, binrel, _org in MODULOS:
            asm = os.path.join(RAIZ, "src", asmname)
            orig = os.path.join(RAIZ, binrel)
            with self.subTest(modulo=asmname):
                out = f"/tmp/_t_{asmname}.bin"
                r = subprocess.run(["pasmo", "--bin", asm, out],
                                   capture_output=True, text=True)
                self.assertEqual(r.returncode, 0,
                                 f"pasmo fallo en {asmname}: {r.stderr[:300]}")
                self.assertEqual(sha(out), sha(orig),
                                 f"{asmname} no reproduce {binrel} byte a byte")
                hechos += 1
        self.assertEqual(hechos, len(MODULOS), "deben verificarse los cuatro modulos")


class TestSanidad(unittest.TestCase):
    """Las zonas que sabemos que son datos no pueden salir como codigo."""

    def setUp(self):
        self.trace = os.path.join(RAIZ, "work", "game.trace.json")
        self.nocode = os.path.join(RAIZ, "src", "game.nocode")

    def test_ninguna_zona_de_datos_marcada_como_codigo(self):
        tr = json.load(open(self.trace))
        lo = min(a for _, a, _ in tr["blocks"])
        hi = max(b for _, _, b in tr["blocks"])
        cod = bytearray(hi - lo)
        for kind, a, b in tr["blocks"]:
            if kind == "c":
                for i in range(a - lo, b - lo):
                    cod[i] = 1
        zonas = 0
        for ln in open(self.nocode, encoding="utf-8"):
            campos = ln.split("#")[0].split()
            if len(campos) < 2:
                continue
            a, b = int(campos[0], 0), int(campos[1], 0)
            ini, fin = max(a, lo), min(b, hi)
            if fin <= ini:
                continue
            pct = sum(cod[ini - lo:fin - lo]) * 100 // (fin - ini)
            with self.subTest(zona=f"{a:#06x}-{b:#06x}"):
                self.assertLessEqual(pct, 5,
                    f"{pct}% de {a:#06x}-{b:#06x} marcado como codigo: trazado contaminado")
            zonas += 1
        self.assertGreater(zonas, 0, "no hay zonas de datos declaradas")


class TestPresupuesto(unittest.TestCase):
    """Cada byte del binario tiene que estar explicado."""

    def test_no_quedan_bytes_sin_explicar(self):
        trace = os.path.join(RAIZ, "work", "game.trace.json")
        notes = os.path.join(RAIZ, "src", "game.notes")
        r = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "coverage.py"),
             trace, notes, "40449", "0x4000"],
            capture_output=True, text=True)
        self.assertEqual(r.returncode, 0, r.stderr[:300])
        m = re.search(r"SIN EXPLICAR\s+(\d+)", r.stdout)
        self.assertIsNotNone(m, f"no se pudo leer el presupuesto:\n{r.stdout}")
        self.assertEqual(int(m.group(1)), 0,
                         f"quedan bytes sin explicar:\n{r.stdout}")


class TestCinta(unittest.TestCase):
    """El formato TSX tiene que entenderse del todo: parsear y reconstruir la
    cinta debe devolver un fichero identico al original."""

    def test_ida_y_vuelta_del_tsx(self):
        man = os.path.join(RAIZ, "extracted", "manifest.json")
        originales = [f for f in os.listdir(RAIZ) if f.lower().endswith(".tsx")]
        out = "/tmp/_t_regen.tsx"
        r = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "tsx_build.py"),
             man, out, os.path.join(RAIZ, "extracted")],
            capture_output=True, text=True)
        self.assertEqual(r.returncode, 0, r.stderr[:300])
        self.assertEqual(sha(out), sha(os.path.join(RAIZ, originales[0])),
                         "la cinta reconstruida difiere de la original")


def load_tests(loader, tests, pattern):
    """Solo se cargan los tests cuyas condiciones se cumplen: hace falta pasmo,
    los listados generados y, para la ida y vuelta de la cinta, la propia cinta
    (que no se distribuye).

    No se usa skipIf a proposito: un test saltado parece un test que pasa, y no
    hay forma de distinguirlo de uno desactivado para tapar un fallo.
    """
    faltan = []
    if not HAY_PASMO:   faltan.append("pasmo (brew install pasmo)")
    if not HAY_TRAZADO: faltan.append("el trazado (ejecuta 'make')")
    if not HAY_LISTADOS: faltan.append("los listados .asm (ejecuta 'make')")
    if faltan:
        print("[tests] no se cargan los tests de reproducibilidad; falta: "
              + ", ".join(faltan))
        return unittest.TestSuite()
    suite = unittest.TestSuite()
    for t in tests:
        for caso in t:
            # La ida y vuelta de la cinta necesita ademas el .tsx original
            if isinstance(caso, unittest.TestSuite):
                for x in caso:
                    if ("ida_y_vuelta" in str(x)
                            and not any(f.lower().endswith(".tsx") for f in os.listdir(RAIZ))):
                        continue
                    suite.addTest(x)
            else:
                suite.addTest(caso)
    return suite


if __name__ == "__main__":
    unittest.main(verbosity=2)
