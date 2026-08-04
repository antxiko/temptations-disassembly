# Carga la cinta original en openMSX y vuelca la RAM en los puntos clave.
#
# Sirve como DECODIFICADOR DE REFERENCIA: en vez de reimplementar el turbo
# loader de Topo Soft, dejamos que el cargador original haga el trabajo y
# capturamos el resultado. Asi los bloques turbo salen exactamente como el
# juego los ve en memoria.
#
# Puntos de captura:
#   0xC58F  entrada de SLOTS (el cargador turbo acaba de recibir el control)
#   0x88B8  bloque turbo 1 ya cargado, justo antes de ejecutarlo
#   0x8000  bloque turbo 2 ya cargado: el juego entero esta en RAM

# openMSX no pasa argv a los scripts de -script, asi que van por entorno.
set TSX  $::env(TEMPT_TSX)
set OUT  $::env(TEMPT_OUT)

set LOG [open "$OUT/omsx_load.log" w]
proc say {msg} { global LOG; puts $LOG "\[[format %8.2f [machine_info time]]\] $msg"; flush $LOG }

proc dump {name addr size} {
    global OUT
    set f [open "$OUT/$name" w]
    fconfigure $f -translation binary
    puts -nonewline $f [debug read_block memory $addr $size]
    close $f
    say "volcado $name  <- CPU\[[format 0x%04X $addr] .. [format 0x%04X [expr {$addr+$size-1}]]\] ($size bytes)"
}

set throttle off
catch {set renderer none}

cassetteplayer insert $TSX
say "cinta insertada: $TSX"

# Sondas: registran el paso por cada etapa de la cadena de carga.
debug set_bp 0x9470 {} { say "TOPO en marcha (pantalla de presentacion)" }

debug set_bp 0xC58F {} {
    say "SLOTS: entrada del cargador turbo"
}

debug set_bp 0x88B8 {} {
    say "bloque turbo 1 cargado; PC va a entrar en 0x88B8"
    # 0x88B8 + 0x3064 = 0xB91C es el final segun el cargador
    dump "turbo1_ram.bin" 0x88B8 0x3064
    dump "full_at_88B8.bin" 0x0000 0x10000
}

debug set_bp 0x8000 {} {
    say "bloque turbo 2 cargado; arrancando el juego en 0x8000"
    dump "turbo2_ram.bin" 0x4000 0x9E01
    dump "full_at_8000.bin" 0x0000 0x10000
    say "OK: la cinta original carga y el juego arranca"
    exit 0
}

# El BASIC tarda un poco en estar listo para aceptar teclas.
after time 4 {
    say "tecleando RUN\"CAS:\""
    type "RUN\"CAS:\"\r"
}

after time 900 { say "TIMEOUT: no se llego a 0x8000"; exit 1 }
