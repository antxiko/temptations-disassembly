; ==========================================================================
; TEMPTATIONS - MSX - SLOTS: buscador de RAM y cargador turbo
; ==========================================================================
; Generado por tools/mkasm.py a partir del trazado de flujo real.
; Los comentarios provienen de tools/../src/*.notes y estan anclados a
; direccion, de modo que sobreviven a un retrazado.
; ==========================================================================

	org 0x0c350


; ======================================================================
; CODIGO 0xc350..0xc3d2  (130 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; BUSCADOR DE RAM EN LOS SLOTS
; ############################################################
; Recorre los 4 slots primarios x 4 secundarios probando a
; escribir y releer, para localizar RAM en cada pagina. Guarda
; los identificadores de slot encontrados en 0xE290..0xE293 y
; deja los slots como estaban al salir: quien conmuta de verdad
; es luego la secuencia de carga.
; ----------------------------------------------------------------------
BUSCA_RAM:		; Localiza RAM en todas las paginas y anota los slots
	di			;c350   ; Nada de interrupciones mientras se toquetean los slots
	ld a,(08000h)		;c351   ; Guarda un byte de 0x8000 para restaurarlo: la prueba lo machaca
	push af			;c354
	call GUARDA_SLOTS_A		;c355
	ld hl,00024h		;c358   ; Codigo automodificable: escribe 0x0024 (ENASLT) como destino del CALL de 0xC3B2
	ld (0c3b3h),hl		;c35b
	ld hl,04000h		;c35e   ; Sondea la pagina 1 (0x4000)
	call SONDEA_PAGINA		;c361
	ld hl,08000h		;c364   ; Sondea la pagina 2 (0x8000)
	call SONDEA_PAGINA		;c367
	ld hl,0c418h		;c36a   ; Copia el buscador a 0x9C40, en RAM...
	ld de,09c40h		;c36d
	ld bc,000c8h		;c370
	ldir		;c373
	ld hl,09c40h		;c375   ; ...y reescribe el CALL para usar esa copia en vez de la BIOS
	ld (0c3b3h),hl		;c378
	ld hl,00000h		;c37b   ; Ahora ya se puede sondear la pagina 0, donde la BIOS dejaria de estar mapeada
	call SONDEA_PAGINA		;c37e
	call GUARDA_SLOTS_B		;c381
	ld a,(0e290h)		;c384   ; Restaura los slots tal y como estaban
	out (0a8h),a		;c387
	ld a,(0e291h)		;c389
	ld (0ffffh),a		;c38c
	pop af			;c38f
	ld (08000h),a		;c390
	ei			;c393
	ret			;c394
GUARDA_SLOTS_A:		; Anota en 0xE290 el estado actual de slots
	ld hl,0e290h		;c395
	jr L_C39D		;c398
GUARDA_SLOTS_B:		; Anota en 0xE292 el estado actual de slots
	ld hl,0e292h		;c39a
L_C39D:
	in a,(0a8h)		;c39d   ; Lee el registro de slots primarios de las cuatro paginas
	ld (hl),a			;c39f   ; Lo deja en 0xE290 (llamada A) o 0xE292 (llamada B)
	inc hl			;c3a0
	ld a,(0ffffh)		;c3a1   ; El registro de subslots de 0xFFFF se lee INVERTIDO...
	cpl			;c3a4   ; ...asi que hay que complementarlo para anotar el valor de verdad
	ld (hl),a			;c3a5   ; Queda en 0xE291 / 0xE293: de ahi lo saca luego el conmutador de 0xE25A
	ret			;c3a6
SONDEA_PAGINA:		; Prueba todos los slots de la pagina HL y se queda con el que tenga RAM
	ld a,080h		;c3a7   ; 0x80 = marca de slot expandido
	ld c,004h		;c3a9   ; 4 slots primarios
L_C3AB:
	and 083h		;c3ab   ; Limpia los bits 2-3 (subslot) y conserva el bit 7 y el primario
	ld b,004h		;c3ad   ; 4 slots secundarios por cada primario
L_C3AF:
	push af			;c3af   ; Se guarda todo porque ENASLT machaca A, BC y HL
	push bc			;c3b0
	push hl			;c3b1
	call 00024h		;c3b2   ; BIOS ENASLT - Switches to specified slot and page definitively | ENASLT o su copia en RAM (ver 0xC358 y 0xC375)
	pop hl			;c3b5
	ld (hl),020h		;c3b6   ; Prueba de RAM: escribe 0x20 y lo relee...
	ld a,(hl)			;c3b8   ; Si no vuelve el 0x20 aqui no hay RAM: siguiente slot
	cp 020h		;c3b9
	jr nz,L_C3C4		;c3bb
	ld (hl),0fah		;c3bd   ; ...y luego 0xFA, para descartar que sea ROM o bus flotante
	ld a,(hl)			;c3bf
	cp 0fah		;c3c0
	jr z,L_C3CF		;c3c2
L_C3C4:
	pop bc			;c3c4   ; Sin RAM en este: recupera los dos contadores y sigue
	pop af			;c3c5
	add a,004h		;c3c6   ; +4 avanza los bits 2-3 del identificador: siguiente slot secundario
	djnz L_C3AF		;c3c8   ; Los cuatro secundarios del primario en curso
	inc a			;c3ca   ; El cuarto +4 desborda a los bits altos; este INC pasa al siguiente primario y el AND 0x83 de 0xC3AB limpia lo que sobra
	dec c			;c3cb   ; Los cuatro primarios
	jr nz,L_C3AB		;c3cc
	ret			;c3ce   ; Ninguno de los 16 tenia RAM: se sale con los slots como los dejo el ultimo intento
L_C3CF:
	pop bc			;c3cf   ; Encontrada: se sale con esa pagina ya conmutada por ENASLT y con el identificador en A
	pop af			;c3d0
	ret			;c3d1

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc3d2..0xc418  (70 bytes)
DATA_C3D2:
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c3d2  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c3e2  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c3f2  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c402  ................
	defb 000h,000h,000h,000h,000h,000h	; c412

; ======================================================================
; CODIGO 0xc418..0xc425  (13 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; ENASLT COPIADA A RAM  (se ejecuta en 0x9C40)
; ############################################################
; Los 120 bytes de 0xC418 a 0xC48F son la rutina ENASLT de la BIOS
; copiada literalmente. Comprobado contra las ROM de la VG-8020, la
; VG-8010 y la NMS-801: la ENASLT de las tres arranca en 0x025E y solo
; se diferencia de esta copia en diez bytes, que son los operandos de
; los cinco CALL/JP internos, reubicados a 0x9C40. Topo le quito ademas
; el DI que la BIOS tiene en 0x027E, justo donde entra el CALL.
; Hace falta la copia porque el sondeo de la pagina 0 (0xC37B) conmuta
; esa pagina a RAM y deja la BIOS sin mapear a mitad de la rutina.
; ----------------------------------------------------------------------
ENASLT_RAM:		; ENASLT de la BIOS, copiada para poder sondear la pagina 0
	call 09c60h		;c418   ; 0x9C60 es este mismo listado en 0xC438: descompone el identificador de A en B (valor) y C (mascara), segun la pagina que pida HL
	jp m,09c4dh		;c41b   ; Bit 7 del identificador: si el slot es expandido hay que tocar tambien 0xFFFF (0x9C4D = 0xC425)
	in a,(0a8h)		;c41e   ; Slot sin expandir: basta con reescribir los dos bits de la pagina...
	and c			;c420
	or b			;c421
	out (0a8h),a		;c422   ; ...en el registro de slots primarios
	ret			;c424

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc425..0xc490  (107 bytes)
DATA_C425:
	defb 0e5h,0cdh,084h,09ch,04fh,006h,000h,07dh,0a4h,0b2h,021h,0c5h,0fch,009h,077h,0e1h	; c425  ....O..}..!...w.
	defb 079h,018h,0e0h,0f5h,07ch,007h,007h,0e6h,003h,05fh,03eh,0c0h,007h,007h,01dh,0f2h	; c435  y...|...._>.....
	defb 069h,09ch,05fh,02fh,04fh,0f1h,0f5h,0e6h,003h,03ch,047h,03eh,0abh,0c6h,055h,010h	; c445  i._/O....<G>..U.
	defb 0fch,057h,0a3h,047h,0f1h,0a7h,0c9h,0f5h,07ah,0e6h,0c0h,04fh,0f1h,0f5h,057h,0dbh	; c455  .W.G....z..O..W.
	defb 0a8h,047h,0e6h,03fh,0b1h,0d3h,0a8h,07ah,00fh,00fh,0e6h,003h,057h,03eh,0abh,0c6h	; c465  .G.?...z....W>..
	defb 055h,015h,0f2h,09ch,09ch,0a3h,057h,07bh,02fh,067h,03ah,0ffh,0ffh,02fh,06fh,0a4h	; c475  U.....W{/g:../o.
	defb 0b2h,032h,0ffh,0ffh,078h,0d3h,0a8h,0f1h,0e6h,003h,0c9h	; c485  .2..x......

; ======================================================================
; CODIGO 0xc490..0xc495  (5 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; SELECTOR DE PAGINA  (se ejecuta en 0xE22C)
; ############################################################
; Seis entradas de cinco bytes, una por combinacion de {estado que se
; quiere} x {pagina}. Cada una carga HL con el par de bytes que
; anotaron 0xC395 y 0xC39A, y salta a la plantilla de mascara:
; 0xE22C  original, pagina 0     0xE23B  RAM, pagina 0
; 0xE231  original, pagina 1     0xE240  RAM, pagina 1
; 0xE236  original, pagina 2     0xE245  RAM, pagina 2
; La secuencia de carga solo usa las dos ultimas (0xE240 y 0xE245).
; ----------------------------------------------------------------------
SEL_ORIG_P0:		; Deja la pagina 0 como estaba antes de la busqueda
	ld hl,0e291h		;c490   ; 0xE291/0xE290: la pareja de registros de slot ANTES de tocar nada
	jr $+27		;c493   ; A la plantilla de la pagina 0

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc495..0xc4ae  (25 bytes)
DATA_C495:
	defb 021h,091h,0e2h,018h,01ah,021h,091h,0e2h,018h,01bh,021h,093h,0e2h,018h,00ah,021h	; c495  !....!....!....!
	defb 093h,0e2h,018h,00bh,021h,093h,0e2h,018h,00ch	; c4a5  ....!....

; ======================================================================
; CODIGO 0xc4ae..0xc4b4  (6 bytes)
; ======================================================================


MASCARA_P0:		; Bits 0-1: pagina 0
	ld d,003h		;c4ae   ; D = bits que se copian del valor guardado
	ld e,0fch		;c4b0   ; E = bits que se conservan de lo que hay puesto ahora
	jr $+12		;c4b2

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc4b4..0xc4be  (10 bytes)
DATA_C4B4:
	defb 016h,00ch,01eh,0f3h,018h,004h,016h,030h,01eh,0cfh	; c4b4  .......0..

; ======================================================================
; CODIGO 0xc4be..0xc4d6  (24 bytes)
; ======================================================================


CONMUTA_PAGINA:		; Mueve una sola pagina, sin tocar las otras tres
	di			;c4be   ; Ni una interrupcion entre los dos registros de slot
	ld a,(hl)			;c4bf   ; Byte de subslots guardado (0xE291 o 0xE293)
	and d			;c4c0   ; Se queda solo con los dos bits de la pagina que se mueve
	ld b,a			;c4c1
	ld a,(0ffffh)		;c4c2   ; Lee el subslot que hay puesto, invertido como siempre en 0xFFFF
	cpl			;c4c5
	and e			;c4c6   ; E conserva las otras tres paginas
	or b			;c4c7
	ld (0ffffh),a		;c4c8   ; Escribir en 0xFFFF va sin invertir
	dec hl			;c4cb   ; Un byte por debajo esta el registro de slots primarios (0xE290 o 0xE292)
	ld a,(hl)			;c4cc
	and d			;c4cd
	ld b,a			;c4ce
	in a,(0a8h)		;c4cf   ; Misma mezcla, ahora sobre el puerto 0xA8
	and e			;c4d1
	or b			;c4d2
	out (0a8h),a		;c4d3
	ret			;c4d5

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc4d6..0xc4d7  (1 bytes)
DATA_C4D6:
	defb 000h	; c4d6

; ======================================================================
; CODIGO 0xc4d7..0xc559  (130 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; CARGADOR TURBO  (se ejecuta en 0xE2F4)
; ############################################################
; Lee un bloque de cinta a (IX) con longitud DE. No usa la BIOS
; de cassette: mide a mano la anchura de los pulsos leyendo el
; bit 7 del registro 14 del PSG.
; Formato del bloque, verificado comparando con la RAM que vuelca
; openMSX: un byte 0x00 de sincronismo, los datos, y un byte de
; checksum tal que el XOR de todo da cero.
; ----------------------------------------------------------------------
CARGA_TURBO:		; Lee un bloque de cinta a (IX), longitud DE
	ld hl,0e39dh		;c4d7   ; Mete 0xE39D en la pila: al hacer RET se ira a apagar el motor
	push hl			;c4da
	push af			;c4db
	ld a,008h		;c4dc   ; PPI en modo bit: pone a 0 el bit 4, que arranca el motor del cassette
	out (0abh),a		;c4de
	ld a,00eh		;c4e0   ; PSG: selecciona el registro 14, cuyo bit 7 es la entrada de cinta
	out (0a0h),a		;c4e2
	pop af			;c4e4   ; Recupera el AF del llamador: A trae el byte de sincronismo que se espera (0x00) y el carry, su SCF
	inc d			;c4e5   ; Fuerza NZ -D nunca vale 0xFF- y lo guarda en AF': con eso la primera vuelta del bucle COMPARA en vez de almacenar
	ex af,af'			;c4e6
	dec d			;c4e7   ; Deshace el INC: DE tiene que seguir siendo la longitud
	di			;c4e8   ; Ni una interrupcion: la carga se hace contando ciclos
	ld a,005h		;c4e9   ; C lleva el estado esperado de la senal; solo importa su bit 7, que aqui empieza a 0
	ld c,a			;c4eb
	cp a			;c4ec
L_C4ED:
	call 0e37ah		;c4ed   ; Espera a la primera transicion; mientras no la haya, insiste
	jr nc,L_C4ED		;c4f0
	ld hl,00415h		;c4f2   ; 1045 vueltas del bucle de abajo
L_C4F5:
	djnz L_C4F5		;c4f5   ; 1045 x 256 DJNZ a 13 T son unos 3,5 millones de ciclos: cerca de un segundo a 3,58 MHz esperando a que el motor coja velocidad (?)
	dec hl			;c4f7
	ld a,h			;c4f8   ; HL a cero deja tambien H a cero, que es lo que cuenta el bucle de 0xC501
	or l			;c4f9
	jr nz,L_C4F5		;c4fa
	call 0e376h		;c4fc   ; Vuelve a engancharse a la senal
	jr nc,L_C4ED		;c4ff
L_C501:
	ld b,09ch		;c501   ; B es el contador de anchura: la rutina de medida lo va incrementando desde este 0x9C
	call 0e376h		;c503   ; Mide un pulso entero (0xE376 = 0xC559 en este listado)
	jr nc,L_C4ED		;c506
	ld a,0c6h		;c508   ; Pulso largo es B por encima de 0xC6; si sale corto, esto no era la cabecera
	cp b			;c50a
	jr nc,L_C4ED		;c50b
	inc h			;c50d   ; 256 pulsos largos seguidos de tono piloto antes de dar la cabecera por buena
	jr nz,L_C501		;c50e
L_C510:
	ld b,0c9h		;c510   ; Ahora al reves: espera el primer pulso CORTO, que es el que marca el fin del tono
	call 0e37ah		;c512   ; Mide medio pulso (0xE37A = 0xC55D)
	jr nc,L_C4ED		;c515
	ld a,b			;c517   ; Aun es largo (B por encima de 0xD4): sigue esperando
	cp 0d4h		;c518
	jr nc,L_C510		;c51a
	call 0e37ah		;c51c   ; Se traga el medio pulso que queda
	ret nc			;c51f   ; Sin senal: aborta y el RET va a 0xE39D, que apaga el motor
	ld h,000h		;c520   ; H es el checksum: XOR de todos los bytes que se lean
	ld b,0b0h		;c522   ; Anchura de partida del primer bit
	jr L_C53E		;c524
L_C526:
	ex af,af'			;c526   ; Recupera el flag guardado en 0xC4E6: la primera vuelta viene con NZ, de la segunda en adelante con Z
	jr nz,L_C52E		;c527
	ld (ix+000h),l		;c529   ; Byte bueno: a la RAM, en (IX)
	jr L_C538		;c52c
L_C52E:
	rr c		;c52e   ; Rota C con el carry; el RLA de 0xC533 lo deshace, asi que el estado de la senal no cambia (?)
	xor l			;c530   ; A sigue trayendo el 0x00 del llamador: comprueba el byte de sincronismo del bloque
	ret nz			;c531   ; No era 0x00: aborta la carga
	ld a,c			;c532
	rla			;c533
	ld c,a			;c534
	inc de			;c535   ; Compensa el DEC DE de 0xC53A, porque el sincronismo no cuenta como dato
	jr L_C53A		;c536
L_C538:
	inc ix		;c538   ; Solo avanza el destino el camino que ha almacenado de verdad
L_C53A:
	dec de			;c53a   ; Un byte menos por leer
	ex af,af'			;c53b   ; Devuelve a AF' el flag Z que decide la rama de la vuelta siguiente
	ld b,0b2h		;c53c   ; Anchura de partida del primer bit del byte que viene
L_C53E:
	ld l,001h		;c53e   ; L = 00000001: los bits entran por la derecha y ese 1 sale por el carry justo al octavo
	call 0e376h		;c540   ; Mide el pulso de un bit
	ret nc			;c543   ; Timeout: se acabo la cinta
	ld a,0cbh		;c544   ; Mas ancho que 0xCB es un uno; mas estrecho, un cero
	cp b			;c546
	rl l		;c547   ; Mete el bit por la derecha de L
	ld b,0b0h		;c549   ; Reinicia la anchura para el bit siguiente
	jp nc,0e35dh		;c54b   ; Mientras el 1 marcador no haya salido quedan bits (0xE35D = 0xC540)
	ld a,h			;c54e   ; Acumula el byte en el checksum
	xor l			;c54f
	ld h,a			;c550
	ld a,d			;c551   ; Quedan bytes por meter en RAM?
	or e			;c552
	jr nz,L_C526		;c553
	ld a,h			;c555   ; Se acabo: el ultimo byte leido era el checksum y por eso no se ha almacenado
	cp 001h		;c556   ; H tiene que valer 0 -medido: el XOR de los dos bloques de la cinta da 0x00-, y el CP deja carry solo en ese caso: mismo convenio que los RET NC de arriba
	ret			;c558

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc559..0xc58f  (54 bytes)
DATA_C559:
	defb 0cdh,07ah,0e3h,0d0h,03eh,016h,03dh,020h,0fdh,0a7h,004h,000h,0c8h,03eh,000h,0dbh	; c559  .z..>.= .....>..
	defb 0a2h,02fh,0a9h,0e6h,080h,0cah,080h,0e3h,079h,02fh,04fh,0edh,05fh,0e6h,00fh,0d3h	; c569  ./......y/O._...
	defb 099h,03eh,087h,0d3h,099h,037h,0c9h,01eh,013h,03eh,009h,0d3h,0abh,03eh,001h,0d3h	; c579  .>...7...>...>..
	defb 099h,03eh,087h,0d3h,099h,0c9h	; c589

; ======================================================================
; CODIGO 0xc58f..0xc602  (115 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; ENTRADA DEL CARGADOR  (BLOAD "cas:",R)
; ############################################################
; Verificado en openMSX: breakpoint alcanzado a los 96,4 s de
; tiempo emulado, justo despues del logo de Topo.
; ----------------------------------------------------------------------
SLOTS_START:		; Punto de entrada: relocaliza todo y arranca la carga
	di			;c58f   ; Apaga interrupciones para el resto del proceso
	ld hl,0dac0h		;c590   ; Copia 100 bytes de 0xDAC0 a 0xDEA8 ANTES de cargar el juego (el LDIR esta en 0xC599 y la carga del bloque en 0xC5E4): 0xDAC0 cae dentro de lo que la carga 0x4000-0xDE00 va a machacar y 0xDEA8 no. Sirve para poner a salvo una tabla de parches que se haya dejado en 0xDAC0 antes de arrancar (?)
	ld de,0dea8h		;c593
	ld bc,00064h		;c596
	ldir		;c599
	call 00041h		;c59b   ; BIOS DISSCR - Inhibits the screen display | DISSCR: apaga la pantalla durante la carga
	call BUSCA_RAM		;c59e   ; Localiza la RAM de todas las paginas
	di			;c5a1   ; BUSCA_RAM sale con EI: hay que volver a apagarlas
	ld hl,0c490h		;c5a2   ; Copia el selector de slots a 0xE22C
	ld de,0e22ch		;c5a5
	ld bc,00047h		;c5a8
	ldir		;c5ab
	ld hl,0c4d7h		;c5ad   ; Copia el cargador turbo a 0xE2F4
	ld de,0e2f4h		;c5b0
	ld bc,000b8h		;c5b3
	ldir		;c5b6
	ld hl,SECUENCIA_CARGA		;c5b8   ; Copia la secuencia de carga a 0xE3BC
	ld de,0e3bch		;c5bb
	ld bc,0003ch		;c5be
	ldir		;c5c1
	jp 0e3bch		;c5c3   ; Y salta a ella: a partir de aqui se ejecuta desde RAM alta

; ----------------------------------------------------------------------
; ############################################################
; SECUENCIA DE CARGA  (se ejecuta en 0xE3BC)
; ############################################################
; Conmuta a RAM las paginas 1 y 2 y carga los dos bloques turbo.
; La pagina 0 se deja como esta -con la ROM del BASIC- porque el
; juego sigue llamando a la BIOS. Verificado: el volcado de
; 0x0000-0x3FFF coincide al 100% con la ROM del VG-8020.
; ----------------------------------------------------------------------
SECUENCIA_CARGA:		; Carga los dos bloques turbo y arranca el juego
	call 0e240h		;c5c6   ; Conmuta la pagina 1 (0x4000) a RAM
	call 0e245h		;c5c9   ; Conmuta la pagina 2 (0x8000) a RAM
	ld ix,088b8h		;c5cc   ; Destino del bloque 1: la pantalla de portada
	ld de,03064h		;c5d0   ; 12388 bytes
	xor a			;c5d3
	scf			;c5d4
	call 0e2f4h		;c5d5
	call 088b8h		;c5d8   ; Ejecuta la portada, que la vuelca a la VRAM y vuelve
	ld ix,04000h		;c5db   ; Destino del bloque 2: el juego entero
	ld de,09e01h		;c5df   ; 40449 bytes
	xor a			;c5e2
	scf			;c5e3
	call 0e2f4h		;c5e4
	ld hl,0dea8h		;c5e7   ; Mecanismo de parcheo: si en 0xDEA8 hay tres 0xC9 seguidos...
	ld b,003h		;c5ea
L_C5EC:
	ld a,(hl)			;c5ec   ; Los tres 0xC9 de firma
	cp 0c9h		;c5ed
	jr nz,L_C5FF		;c5ef
	inc hl			;c5f1
	djnz L_C5EC		;c5f2
	ld b,(hl)			;c5f4   ; Formato de la tabla: tres 0xC9 de marca en 0xDEA8-0xDEAA, un byte de contador y luego repeticiones de (direccion baja, direccion alta, valor) que se aplican con 'ld (de),a'. Los 100 bytes copiados dan justo para 3 + 1 + 32*3, o sea sitio para 32 parches, pero el codigo NO comprueba el contador: con uno mayor leeria mas alla de lo copiado. Ojo: lo que decide si hay marca es lo que el BASIC dejara en 0xDAC0 al arrancar, no el contenido del juego, que en ese momento aun no esta cargado; no consta ningun cargador ni entrenador publicado que use esta tabla
	inc hl			;c5f5
L_C5F6:
	ld e,(hl)			;c5f6   ; Cada parche son tres bytes: la direccion en little endian...
	inc hl			;c5f7
	ld d,(hl)			;c5f8
	inc hl			;c5f9
	ld a,(hl)			;c5fa   ; ...y el valor
	inc hl			;c5fb
	ld (de),a			;c5fc   ; Lo escribe en su sitio
	djnz L_C5F6		;c5fd   ; Tantos parches como dijo el contador
L_C5FF:
	jp 08000h		;c5ff   ; Arranca el juego

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc602..0xc60c  (10 bytes)
DATA_C602:
	defb 0c9h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c602  ..........
