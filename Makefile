# Temptations (Topo Soft, 1988, MSX1) - desensamblado
#
# `make` regenera los cuatro listados comentados desde el binario y comprueba
# que al reensamblarlos sale EXACTAMENTE el original, byte a byte.
#
# Esa comprobacion es lo que hace utilizable el desensamblado: mientras este en
# verde, cualquier cambio en el juego se puede atribuir con seguridad a lo que
# hemos tocado y no a un error de interpretacion del binario.

TSX  := Temptations (1988)(Topo Soft)(ES)[!][RUN'CAS-'][v0.8b].tsx
SYMS := work/msx.sym
MSXGL := /Users/fx-media/Documents/BARCOEMESEKS/MSXgl/engine/src

.PHONY: all verify clean extract syms listados

all: verify

# ---------------------------------------------------------------- extraccion
extract: extracted/.stamp
# El nombre del TSX lleva espacios y corchetes, asi que no puede ir como
# dependencia de make; el .stamp hace de testigo de que la extraccion se hizo.
extracted/.stamp: tools/tsx_parse.py
	python3 tools/tsx_parse.py "$(TSX)" extracted
	mkdir -p work
	python3 -c "import sys; d=open('extracted/07_TOPO.bin','rb').read(); open('work/TOPO.raw','wb').write(d[6:])"
	python3 -c "import sys; d=open('extracted/09_SLOTS.bin','rb').read(); open('work/SLOTS.raw','wb').write(d[6:])"
	touch $@

syms: $(SYMS)
$(SYMS): tools/gen_msx_syms.py
	mkdir -p work
	python3 tools/gen_msx_syms.py $(MSXGL) $@

# ------------------------------------------------------------------ trazado
work/game.trace.json: tools/z80trace.py src/game.entries src/game_dynamic.entries \
                     src/game_tables.entries src/game.nocode
	cat src/game.entries src/game_dynamic.entries src/game_tables.entries > work/game_all.entries
	python3 tools/z80trace.py dump/turbo2_ram.bin 0x4000 work/game_all.entries work/game src/game.nocode

work/slots.trace.json: tools/z80trace.py src/slots.entries extract
	python3 tools/z80trace.py work/SLOTS.raw 0xC350 src/slots.entries work/slots

work/topo.trace.json: tools/z80trace.py src/topo.entries extract
	python3 tools/z80trace.py work/TOPO.raw 0x9470 src/topo.entries work/topo

work/turbo1.trace.json: tools/z80trace.py src/turbo1.entries
	python3 tools/z80trace.py dump/turbo1_ram.bin 0x88B8 src/turbo1.entries work/turbo1

# ----------------------------------------------------------------- listados
listados: src/temptations_game.asm src/temptations_slots.asm \
          src/temptations_topo.asm src/temptations_portada.asm

src/temptations_game.asm: work/game.trace.json src/game.notes tools/mkasm.py $(SYMS)
	python3 tools/mkasm.py dump/turbo2_ram.bin 0x4000 work/game.trace.json \
	  src/game.notes $(SYMS) $@ "TEMPTATIONS (Topo Soft, 1988) - MSX - juego principal"

src/temptations_slots.asm: work/slots.trace.json src/slots.notes tools/mkasm.py $(SYMS)
	python3 tools/mkasm.py work/SLOTS.raw 0xC350 work/slots.trace.json \
	  src/slots.notes $(SYMS) $@ "TEMPTATIONS - MSX - SLOTS: buscador de RAM y cargador turbo"

src/temptations_topo.asm: work/topo.trace.json src/topo.notes tools/mkasm.py $(SYMS)
	python3 tools/mkasm.py work/TOPO.raw 0x9470 work/topo.trace.json \
	  src/topo.notes $(SYMS) $@ "TEMPTATIONS - MSX - TOPO: logo de Topo Soft"

src/temptations_portada.asm: work/turbo1.trace.json src/turbo1.notes tools/mkasm.py $(SYMS)
	python3 tools/mkasm.py dump/turbo1_ram.bin 0x88B8 work/turbo1.trace.json \
	  src/turbo1.notes $(SYMS) $@ "TEMPTATIONS - MSX - bloque turbo 1: pantalla de portada"

# -------------------------------------------------------------- verificacion
verify: listados sanity test
	@echo "=================================================================="
	@echo " Reproducibilidad: ensamblar el listado debe dar el binario exacto"
	@echo "=================================================================="
	@./tools/verify_build.sh src/temptations_slots.asm   work/SLOTS.raw       0xC350
	@./tools/verify_build.sh src/temptations_topo.asm    work/TOPO.raw        0x9470
	@./tools/verify_build.sh src/temptations_portada.asm dump/turbo1_ram.bin  0x88B8
	@./tools/verify_build.sh src/temptations_game.asm    dump/turbo2_ram.bin  0x4000
	@echo "=================================================================="
	@echo " TODO VERDE: los cuatro modulos reensamblan al original"
	@echo "=================================================================="

# El control de sanidad va aparte de la reproducibilidad porque detecta un fallo
# que esta NO ve: si el trazador marca graficos como codigo, el binario sigue
# saliendo identico (los bytes son los mismos) pero el listado miente.
sanity: work/game.trace.json
	@echo "=================================================================="
	@echo " Sanidad del trazado: las zonas de datos no pueden salir como codigo"
	@echo "=================================================================="
	@python3 tools/check_trace.py work/game.trace.json src/game.nocode
	@echo ""
	@echo "=================================================================="
	@echo " Presupuesto del binario: no deben quedar bytes sin explicar"
	@echo "=================================================================="
	@python3 tools/coverage.py work/game.trace.json src/game.notes 40449 0x4000

.PHONY: sanity

# Los tests no dependen de tener la cinta: los del decodificador Z80 corren
# siempre, y los que necesitan el binario se saltan indicandolo.
test:
	@echo "=================================================================="
	@echo " Tests"
	@echo "=================================================================="
	@python3 -m unittest discover -s tests -v

.PHONY: test

clean:
	rm -f work/*.trace.json work/*.blocks work/game_all.entries
	rm -f src/temptations_*.asm
