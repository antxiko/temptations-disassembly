#!/usr/bin/env python3
"""Comprueba que lo que afirma la documentacion sigue siendo cierto.

Un proyecto como este publica muchas afirmaciones sobre un binario: que tal
direccion contiene tal instruccion, que nadie escribe en tal variable, que hay
29 mapas. Todas son comprobables, asi que deben comprobarse solas: si algun dia
alguien cambia una nota o el binario, esto salta.

Si el binario del juego no esta disponible (no se distribuye con el
repositorio), estos tests directamente no se cargan y se avisa por pantalla. Los
de tests/test_z80.py no dependen de el y se ejecutan siempre.
"""
import functools
import operator
import os
import sys
import unittest

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))

JUEGO = os.path.join(RAIZ, "dump", "turbo2_ram.bin")
ORG = 0x4000
HAY_BINARIO = os.path.exists(JUEGO)


def cargar():
    return open(JUEGO, "rb").read()


def en(d, addr, n=1):
    return d[addr - ORG:addr - ORG + n]


class TestBinario(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.d = cargar()

    def test_tamano(self):
        self.assertEqual(len(self.d), 40449)

    def test_entrada_del_juego(self):
        """0x8000 debe empezar con 'ld sp,0efffh'."""
        self.assertEqual(en(self.d, 0x8000, 3), bytes([0x31, 0xFF, 0xEF]))

    def test_poke_de_vidas_la_direccion_buena(self):
        """El POKE publicado en 1988 dice 0xB4CC y no funciona; la buena es
        0x84CC, donde esta el DEC A que quita la vida."""
        self.assertEqual(en(self.d, 0x84CC)[0], 0x3D, "0x84CC debe ser DEC A")
        self.assertEqual(en(self.d, 0xB4CC)[0], 0x00,
                         "0xB4CC ya vale 0: por eso el poke del libro no hace nada")

    def test_tope_de_vidas_sale_sin_guardar(self):
        """El bug del tope: 'cp 0Ah / ret z' antes del 'ld (8f12),a'."""
        self.assertEqual(en(self.d, 0x8528, 8),
                         bytes([0x3A, 0x12, 0x8F,   # ld a,(8f12)
                                0x3C,                # inc a
                                0xFE, 0x0A,          # cp 0Ah
                                0xC8,                # ret z   <- sale sin guardar
                                0x32]))              # ld (8f12),a

    def test_nadie_escribe_en_la_bandera_de_tramposo(self):
        """La afirmacion central del hallazgo del castigo: 0x8F1E solo se lee."""
        escrituras = {
            bytes([0x32, 0x1E, 0x8F]): "ld (0x8F1E),a",
            bytes([0x21, 0x1E, 0x8F]): "ld hl,0x8F1E",
            bytes([0x22, 0x1E, 0x8F]): "ld (0x8F1E),hl",
            bytes([0x11, 0x1E, 0x8F]): "ld de,0x8F1E",
            bytes([0x01, 0x1E, 0x8F]): "ld bc,0x8F1E",
        }
        for pat, nom in escrituras.items():
            self.assertEqual(self.d.find(pat), -1, f"no deberia existir {nom}")
        # Y la lectura si tiene que estar, en 0x8B80
        self.assertEqual(en(self.d, 0x8B80, 3), bytes([0x3A, 0x1E, 0x8F]))

    def test_la_bandera_vale_cero_por_casualidad(self):
        """No es una inicializacion: es relleno. Solo 3 de los 160 bytes de la
        zona valen cero, y uno cae ahi."""
        zona = en(self.d, 0x8F00, 0xA0)
        self.assertEqual(zona.count(0), 3)
        self.assertEqual(en(self.d, 0x8F1E)[0], 0)

    def test_estructura_de_niveles(self):
        """0x8B09 compara la pantalla con 13, 20, 27 y 6: cuatro niveles de siete."""
        code = en(self.d, 0x8B09, 20)
        for valor in (0x0D, 0x14, 0x1B, 0x06):
            self.assertIn(bytes([0xFE, valor]), code, f"debe comparar con {valor}")

    def test_carga_de_mapa(self):
        """0x9000 + pantalla*512, 512 bytes al buffer 0x7D80."""
        self.assertEqual(en(self.d, 0x8ACE, 21),
                         bytes([0x3A, 0x0D, 0x8F,   # ld a,(8f0d)  pantalla
                                0x57,                # ld d,a
                                0xCB, 0x22,          # sla d        x512 (con e=0)
                                0x1E, 0x00,          # ld e,0
                                0x21, 0x00, 0x90,    # ld hl,9000h
                                0x19,                # add hl,de
                                0x11, 0x80, 0x7D,    # ld de,7d80h  buffer
                                0x01, 0x00, 0x02,    # ld bc,200h   512
                                0xED, 0xB0,          # ldir
                                0xC9]))

    def test_veintinueve_mapas(self):
        """De 0x9000 a 0xCA00 caben exactamente 29 mapas de 512 bytes."""
        self.assertEqual((0xCA00 - 0x9000) // 512, 29)

    def test_nivel_cuatro_pone_el_fondo_verde(self):
        """0x8B58: ld a,0Ch / ld (0f3ebh),a -> color de fondo 12."""
        self.assertEqual(en(self.d, 0x8B58, 5),
                         bytes([0x3E, 0x0C, 0x32, 0xEB, 0xF3]))

    def test_objetos_repetidos_en_las_pantallas_del_bug(self):
        """El bug del CPIR solo se ve donde hay objetos repetidos."""
        def mapa(i):
            return en(self.d, 0x9000 + i * 512, 512)
        self.assertEqual(mapa(16).count(0xAC), 2, "pantalla 16: dos municiones")
        self.assertEqual(mapa(27).count(0xAB), 6, "pantalla 27: seis vidas extra")

    def test_las_alitas_no_estan_en_ningun_mapa(self):
        """Solo se consiguen disparando a puntos ocultos invisibles."""
        for i in range(29):
            self.assertEqual(en(self.d, 0x9000 + i * 512, 512).count(0xAA), 0,
                             f"el tile de alitas no debe aparecer en el mapa {i}")


class TestTextos(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.d = cargar()

    def test_la_fuente_no_es_ascii(self):
        from charset import decode
        self.assertEqual(decode(bytes([0x00])), " ", "el espacio es 0x00, no 0x20")
        self.assertEqual(decode(bytes([0x5C])), "0", "los digitos empiezan en 0x5C")
        self.assertEqual(decode(bytes([0x64])), "8")

    def test_u_y_v_comparten_glifo(self):
        """Por eso los textos guardan 'PVES' y 'NUEUO' y se leen bien."""
        pat = en(self.d, 0x4000, 0x800)
        u = pat[0x55 * 8:0x55 * 8 + 8]
        v = pat[0x56 * 8:0x56 * 8 + 8]
        self.assertEqual(u, v, "los glifos de U y V deben ser identicos")

    def test_texto_del_castigo(self):
        from charset import decode
        self.assertIn("POR QUE NO PRUEBAS SIN POKES",
                      decode(en(self.d, 0x7F94, 32)))

    def test_pantalla_de_presentacion(self):
        from charset import decode
        menu = decode(en(self.d, 0x5CC0, 0x300))
        self.assertIn("TOPO SOFT PRESENTA", menu)
        self.assertIn("LUIGILOPEZ", menu)
        self.assertIn("GOMINOLAS", menu)


def load_tests(loader, tests, pattern):
    """Estos tests leen el binario del juego, que no se distribuye con el
    repositorio. Si no esta, no se cargan.

    Se hace asi -y no con skipIf- a proposito: un test "saltado" es
    indistinguible de un test que se ha desactivado para esconder que falla. Lo
    honesto es que no aparezca, y que el aviso se vea.
    """
    if not HAY_BINARIO:
        print(f"[tests] sin {JUEGO}: no se cargan los tests sobre el binario.\n"
              f"        Pon la cinta en el proyecto y ejecuta 'make'.")
        return unittest.TestSuite()
    return tests


if __name__ == "__main__":
    unittest.main(verbosity=2)
