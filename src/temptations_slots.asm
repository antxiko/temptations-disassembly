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
	ldir			;c373
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
	in a,(0a8h)		;c39d
	ld (hl),a		;c39f
	inc hl			;c3a0
	ld a,(0ffffh)		;c3a1
	cpl			;c3a4
	ld (hl),a		;c3a5
	ret			;c3a6
SONDEA_PAGINA:		; Prueba todos los slots de la pagina HL y se queda con el que tenga RAM
	ld a,080h		;c3a7   ; 0x80 = marca de slot expandido
	ld c,004h		;c3a9   ; 4 slots primarios
L_C3AB:
	and 083h		;c3ab
	ld b,004h		;c3ad   ; 4 slots secundarios por cada primario
L_C3AF:
	push af			;c3af
	push bc			;c3b0
	push hl			;c3b1
	call 00024h		;c3b2   ; BIOS ENASLT - Switches to specified slot and page definitively | ENASLT o su copia en RAM (ver 0xC358 y 0xC375)
	pop hl			;c3b5
	ld (hl),020h		;c3b6   ; Prueba de RAM: escribe 0x20 y lo relee...
	ld a,(hl)		;c3b8
	cp 020h			;c3b9
	jr nz,L_C3C4		;c3bb
	ld (hl),0fah		;c3bd   ; ...y luego 0xFA, para descartar que sea ROM o bus flotante
	ld a,(hl)		;c3bf
	cp 0fah			;c3c0
	jr z,L_C3CF		;c3c2
L_C3C4:
	pop bc			;c3c4
	pop af			;c3c5
	add a,004h		;c3c6
	djnz L_C3AF		;c3c8
	inc a			;c3ca
	dec c			;c3cb
	jr nz,L_C3AB		;c3cc
	ret			;c3ce
L_C3CF:
	pop bc			;c3cf
	pop af			;c3d0
	ret			;c3d1

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc3d2..0xc418  (70 bytes)
; ----------------------------------------------------------------------
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c3d2  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c3e2  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c3f2  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c402  ................
	defb 000h,000h,000h,000h,000h,000h	; c412  ......

; ======================================================================
; CODIGO 0xc418..0xc425  (13 bytes)
; ======================================================================


L_C418:
	call 09c60h		;c418
	jp m,09c4dh		;c41b
	in a,(0a8h)		;c41e
	and c			;c420
	or b			;c421
	out (0a8h),a		;c422
	ret			;c424

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc425..0xc490  (107 bytes)
; ----------------------------------------------------------------------
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


L_C490:
	ld hl,0e291h		;c490
	jr $+27			;c493

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc495..0xc4ae  (25 bytes)
; ----------------------------------------------------------------------
	defb 021h,091h,0e2h,018h,01ah,021h,091h,0e2h,018h,01bh,021h,093h,0e2h,018h,00ah,021h	; c495  !....!....!....!
	defb 093h,0e2h,018h,00bh,021h,093h,0e2h,018h,00ch	; c4a5  ....!....

; ======================================================================
; CODIGO 0xc4ae..0xc4b4  (6 bytes)
; ======================================================================


L_C4AE:
	ld d,003h		;c4ae
	ld e,0fch		;c4b0
	jr $+12			;c4b2

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc4b4..0xc4be  (10 bytes)
; ----------------------------------------------------------------------
	defb 016h,00ch,01eh,0f3h,018h,004h,016h,030h,01eh,0cfh	; c4b4  .......0..

; ======================================================================
; CODIGO 0xc4be..0xc4d6  (24 bytes)
; ======================================================================


L_C4BE:
	di			;c4be
	ld a,(hl)		;c4bf
	and d			;c4c0
	ld b,a			;c4c1
	ld a,(0ffffh)		;c4c2
	cpl			;c4c5
	and e			;c4c6
	or b			;c4c7
	ld (0ffffh),a		;c4c8
	dec hl			;c4cb
	ld a,(hl)		;c4cc
	and d			;c4cd
	ld b,a			;c4ce
	in a,(0a8h)		;c4cf
	and e			;c4d1
	or b			;c4d2
	out (0a8h),a		;c4d3
	ret			;c4d5

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc4d6..0xc4d7  (1 bytes)
; ----------------------------------------------------------------------
	defb 000h	; c4d6  .

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
	ld a,008h		;c4dc
	out (0abh),a		;c4de
	ld a,00eh		;c4e0
	out (0a0h),a		;c4e2
	pop af			;c4e4
	inc d			;c4e5
	ex af,af'		;c4e6
	dec d			;c4e7
	di			;c4e8
	ld a,005h		;c4e9
	ld c,a			;c4eb
	cp a			;c4ec
L_C4ED:
	call 0e37ah		;c4ed
	jr nc,L_C4ED		;c4f0
	ld hl,00415h		;c4f2
L_C4F5:
	djnz L_C4F5		;c4f5
	dec hl			;c4f7
	ld a,h			;c4f8
	or l			;c4f9   ; Escribe en el PPI para arrancar el motor del cassette
	jr nz,L_C4F5		;c4fa
	call 0e376h		;c4fc
	jr nc,L_C4ED		;c4ff
L_C501:
	ld b,09ch		;c501
	call 0e376h		;c503
	jr nc,L_C4ED		;c506
	ld a,0c6h		;c508
	cp b			;c50a
	jr nc,L_C4ED		;c50b
	inc h			;c50d
	jr nz,L_C501		;c50e
L_C510:
	ld b,0c9h		;c510
	call 0e37ah		;c512
	jr nc,L_C4ED		;c515
	ld a,b			;c517
	cp 0d4h			;c518
	jr nc,L_C510		;c51a
	call 0e37ah		;c51c
	ret nc			;c51f
	ld h,000h		;c520
	ld b,0b0h		;c522
	jr L_C53E		;c524
L_C526:
	ex af,af'		;c526
	jr nz,L_C52E		;c527
	ld (ix+000h),l		;c529
	jr L_C538		;c52c
L_C52E:
	rr c			;c52e
	xor l			;c530
	ret nz			;c531
	ld a,c			;c532
	rla			;c533
	ld c,a			;c534
	inc de			;c535
	jr L_C53A		;c536
L_C538:
	inc ix			;c538
L_C53A:
	dec de			;c53a
	ex af,af'		;c53b
	ld b,0b2h		;c53c
L_C53E:
	ld l,001h		;c53e
	call 0e376h		;c540
	ret nc			;c543
	ld a,0cbh		;c544
	cp b			;c546
	rl l			;c547
	ld b,0b0h		;c549
	jp nc,0e35dh		;c54b
	ld a,h			;c54e
	xor l			;c54f
	ld h,a			;c550
	ld a,d			;c551
	or e			;c552
	jr nz,L_C526		;c553
	ld a,h			;c555
	cp 001h			;c556
	ret			;c558

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc559..0xc58f  (54 bytes)
; ----------------------------------------------------------------------
	defb 0cdh,07ah,0e3h,0d0h,03eh,016h,03dh,020h,0fdh,0a7h,004h,000h,0c8h,03eh,000h,0dbh	; c559  .z..>.= .....>..
	defb 0a2h,02fh,0a9h,0e6h,080h,0cah,080h,0e3h,079h,02fh,04fh,0edh,05fh,0e6h,00fh,0d3h	; c569  ./......y/O._...
	defb 099h,03eh,087h,0d3h,099h,037h,0c9h,01eh,013h,03eh,009h,0d3h,0abh,03eh,001h,0d3h	; c579  .>...7...>...>..
	defb 099h,03eh,087h,0d3h,099h,0c9h	; c589  .>....

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
	ld hl,0dac0h		;c590
	ld de,0dea8h		;c593
	ld bc,00064h		;c596
	ldir			;c599
	call 00041h		;c59b   ; BIOS DISSCR - Inhibits the screen display | DISSCR: apaga la pantalla durante la carga
	call BUSCA_RAM		;c59e   ; Localiza la RAM de todas las paginas
	di			;c5a1
	ld hl,0c490h		;c5a2   ; Copia el selector de slots a 0xE22C
	ld de,0e22ch		;c5a5
	ld bc,00047h		;c5a8
	ldir			;c5ab
	ld hl,0c4d7h		;c5ad   ; Copia el cargador turbo a 0xE2F4
	ld de,0e2f4h		;c5b0
	ld bc,000b8h		;c5b3
	ldir			;c5b6
	ld hl,SECUENCIA_CARGA		;c5b8   ; Copia la secuencia de carga a 0xE3BC
	ld de,0e3bch		;c5bb
	ld bc,0003ch		;c5be
	ldir			;c5c1
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
	ld a,(hl)		;c5ec
	cp 0c9h			;c5ed
	jr nz,L_C5FF		;c5ef
	inc hl			;c5f1
	djnz L_C5EC		;c5f2
	ld b,(hl)		;c5f4   ; ...lee un contador y aplica esa cantidad de parches (direccion, valor)
	inc hl			;c5f5
L_C5F6:
	ld e,(hl)		;c5f6
	inc hl			;c5f7
	ld d,(hl)		;c5f8
	inc hl			;c5f9
	ld a,(hl)		;c5fa
	inc hl			;c5fb
	ld (de),a		;c5fc
	djnz L_C5F6		;c5fd
L_C5FF:
	jp 08000h		;c5ff   ; Arranca el juego

; ----------------------------------------------------------------------
; DATOS sin identificar  0xc602..0xc60c  (10 bytes)
; ----------------------------------------------------------------------
	defb 0c9h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c602  ..........
