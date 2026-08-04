; ==========================================================================
; TEMPTATIONS (Topo Soft, 1988) - MSX - juego principal
; ==========================================================================
; Generado por tools/mkasm.py a partir del trazado de flujo real.
; Los comentarios provienen de tools/../src/*.notes y estan anclados a
; direccion, de modo que sobreviven a un retrazado.
; ==========================================================================

	org 0x04000


; ----------------------------------------------------------------------
; Etiquetas que no caen en ninguna posicion emitida del listado
; (destinos fuera del binario o dentro de una instruccion).
; ----------------------------------------------------------------------
VAR_ATRIB_SPRITE:	equ 0x08f01
VAR_JUGADOR_Y:	equ 0x08f0a
VAR_ESTADO_JUGADOR:	equ 0x08f0b
VAR_PASO_ANIM:	equ 0x08f0c
VAR_PANTALLA:	equ 0x08f0d
VAR_NIVEL:	equ 0x08f0e
VAR_DX_FRAME:	equ 0x08f0f
VAR_DY_FRAME:	equ 0x08f10
VAR_MODO_VUELO:	equ 0x08f11
VAR_VIDAS:	equ 0x08f12
VAR_REAPARECE_X:	equ 0x08f13
VAR_REAPARECE_Y:	equ 0x08f14
VAR_CONTADOR_BUCLE2:	equ 0x08f16
VAR_MUNICION:	equ 0x08f17
VAR_ARMA:	equ 0x08f18
VAR_GATILLO_USADO:	equ 0x08f19
VAR_CONT_MUERTE:	equ 0x08f1a
VAR_CONTADOR_ENEMIGO:	equ 0x08f1b
VAR_REAPARECE_ESTADO:	equ 0x08f1c
VAR_REAPARECE_PASO:	equ 0x08f1d
VAR_ENEMIGOS:	equ 0x08f20
VAR_SFX_PASO:	equ 0x0ddac
VAR_SFX_SALTO:	equ 0x0ddad
VAR_SFX_DISPARO:	equ 0x0ddae
VAR_SFX_MUERTE:	equ 0x0ddaf
VAR_SFX_IMPACTO:	equ 0x0ddb0
VAR_SFX_ROTURA:	equ 0x0ddb1
VAR_SFX_RECOGER:	equ 0x0ddb2
VAR_SFX_RUIDO_VUELO:	equ 0x0ddb3

; ----------------------------------------------------------------------
; DATOS fuente: Tabla de PATRONES: 256 glifos de 8 bytes. Se copia a los tres tercios de la pantalla (VRAM 0x0000/0x0800/0x1000), por eso los tres se ven iguales.
;   0x4000..0x4800  (2048 bytes)
; DATOS colores: Tabla de COLORES de los patrones, uno por linea de glifo. Va a VRAM 0x2000/0x2800/0x3000.
;   0x4800..0x5000  (2048 bytes)
; DATOS sprites: Patrones de SPRITES. Se copian a VRAM 0x3800 desde la rutina 0x805E.
;   0x5000..0x5800  (2048 bytes)
; DATOS grafdesc: Datos graficos sin identificar todavia (?)
;   0x5800..0x5cc0  (1216 bytes)
; DATOS pantalla_menu: Tabla de NOMBRES de la pantalla de presentacion (32x24 = 768 bytes). Copiada tal cual a VRAM 0x1800. Contiene el texto del monje y los creditos.
;   0x5cc0..0x5fc0  (768 bytes)
; DATOS datos_juego: Datos del juego sin identificar todavia (mapas de pantallas, tablas) (?)
;   0x5fc0..0x8000  (8256 bytes)
; DATOS tabla_puntos_ocultos: 29 grupos de 16 bytes indexados como 0x79C0 + pantalla*16, cuatro entradas de 4 bytes cada uno: columna, fila, contador de impactos NEGATIVO (disparos necesarios = 0x100 menos el byte) y tile del premio. Una entrada a ceros esta vacia. Los datos utiles acaban en 0x7B90 (29*16); de 0x7B90 a 0x7BA0 ya es el relleno 00/EB que llena todos los huecos del binario, y las cuatro entradas de la pantalla 28 (0x7B80) son igual de inertes: la primera tiene fila 0x42 y las otras tres son ese mismo relleno. [SUSTITUYE a la D 0x79C0 anterior: el tercer byte NO es 'impactos que aguanta' sin mas, es el complemento a 256]
;   0x79c0..0x7ba0  (480 bytes)
; DATOS tabla_enemigos: 29 grupos de 16 bytes indexados como 0x7BA0 + pantalla*16, cuatro entradas de 4 bytes: X en pixeles, Y en pixeles, numero de animacion de la tabla de 0x60C0 y resistencia (tambien negativa: aguanta 0x100 menos el byte). Una X y una Y a cero cortan la lista, por eso hay pantallas de 2 y de 3 enemigos. Los datos acaban en 0x7D70 y de ahi a 0x7D80 hay relleno 00/FF. OJO con el ultimo grupo: 0x7D60 son los CUATRO enemigos de la pantalla de victoria (20 20 0E 64 / D8 20 0E 64 / 40 50 0E 64 / A8 50 0E 64), animacion 0x0E y resistencia 0x64; existen de verdad y son los que anima el bucle infinito de 0x8B94. [SUSTITUYE a la D 0x7BA0 anterior]
;   0x7ba0..0x7d80  (480 bytes)
; DATOS buffer_mapa: Buffer del mapa de la pantalla actual (512 bytes). Se llena desde 0x9000+pantalla*512 y se vuelca a VRAM 0x1800.
;   0x7d80..0x7f80  (512 bytes)
; ----------------------------------------------------------------------
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,003h,001h,00fh,066h,066h,018h,018h	; 4000  ............ff..
	defb 000h,000h,01ch,01eh,01fh,064h,07ch,07ch,03ch,03ch,018h,018h,000h,000h,024h,024h	; 4010  .....d||<<....$$
	defb 07eh,07eh,000h,07fh,001h,000h,07eh,07eh,003h,001h,008h,01ch,01ch,008h,07eh,07ch	; 4020  ~~....~~......~|
	defb 000h,07fh,042h,03ch,03ch,03ch,03ch,03ch,03ch,07eh,01fh,07fh,018h,03ch,03ch,018h	; 4030  ..B<<<<<<~...<<.
	defb 038h,03ch,01ch,00ch,00ch,004h,004h,003h,018h,018h,03ch,03ch,03ch,07eh,07eh,07eh	; 4040  8<........<<<~~~
	defb 068h,060h,060h,060h,01eh,01ch,00fh,000h,03ch,03ch,03ch,03ch,03ch,03ch,018h,018h	; 4050  h```....<<<<<<..
	defb 060h,060h,070h,070h,00fh,007h,007h,007h,03ch,03ch,03ch,03ch,03ch,042h,007h,000h	; 4060  ``pp....<<<<<B..
	defb 07eh,07eh,07eh,07eh,07eh,07eh,07eh,07eh,003h,007h,01fh,000h,000h,000h,07eh,03ch	; 4070  ~~~~~~~~......~<
	defb 020h,020h,030h,030h,038h,038h,03ch,01ch,003h,007h,01fh,000h,018h,03ch,03ch,018h	; 4080    0088<......<<.
	defb 03fh,07fh,000h,002h,007h,007h,003h,001h,000h,003h,007h,00eh,01dh,03bh,077h,06fh	; 4090  ?............;wo
	defb 001h,000h,000h,001h,001h,003h,007h,01fh,000h,001h,00fh,000h,000h,000h,000h,07fh	; 40a0  ................
	defb 07fh,011h,023h,047h,070h,01fh,03fh,000h,07fh,03fh,01ch,01fh,010h,000h,000h,07fh	; 40b0  ..#Gp.?..?......
	defb 000h,000h,066h,066h,066h,000h,000h,000h,001h,003h,03bh,004h,00bh,007h,000h,001h	; 40c0  ..fff.....;.....
	defb 07fh,007h,01fh,03fh,03fh,07fh,07fh,07fh,000h,03fh,01fh,070h,047h,023h,011h,009h	; 40d0  ...??....?.pG#..
	defb 010h,077h,03bh,01dh,00eh,007h,003h,000h,003h,007h,007h,00fh,03fh,000h,000h,001h	; 40e0  .w;.........?...
	defb 014h,008h,008h,014h,036h,07fh,07bh,03eh,003h,003h,003h,003h,003h,03ch,042h,07eh	; 40f0  ....6.{>.....<B~
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,03ch,07eh,000h,000h	; 4100  ............<~..
	defb 001h,003h,007h,00fh,00fh,01fh,01fh,03fh,07fh,03fh,01fh,00fh,00fh,007h,007h,003h	; 4110  .......?.?......
	defb 03fh,03fh,07fh,07fh,07fh,000h,000h,000h,003h,003h,001h,001h,001h,000h,000h,000h	; 4120  ??..............
	defb 073h,031h,079h,07fh,07fh,07fh,037h,07fh,018h,01ch,000h,000h,000h,000h,040h,040h	; 4130  s1y...7.......@@
	defb 019h,01ch,001h,001h,001h,021h,063h,001h,001h,001h,003h,003h,007h,007h,00fh,00fh	; 4140  .....!c.........
	defb 07fh,07fh,03fh,03fh,01fh,01fh,00fh,00fh,01fh,01fh,00fh,003h,000h,01fh,07fh,000h	; 4150  ..??............
	defb 007h,007h,00fh,03fh,000h,007h,001h,000h,000h,000h,03fh,03fh,03fh,03fh,03fh,03fh	; 4160  ...?......??????
	defb 000h,001h,001h,001h,001h,001h,001h,001h,03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh	; 4170  ........????????
	defb 001h,003h,006h,00ch,01ch,03ch,06ch,033h,033h,033h,033h,033h,033h,033h,033h,033h	; 4180  .....<l333333333
	defb 000h,000h,033h,033h,033h,033h,033h,033h,000h,000h,000h,000h,003h,00fh,03ch,003h	; 4190  ..333333......<.
	defb 000h,000h,03ch,003h,033h,033h,033h,033h,033h,033h,033h,033h,033h,033h,033h,033h	; 41a0  ..<.333333333333
	defb 001h,001h,001h,001h,001h,001h,001h,001h,008h,008h,008h,058h,05ah,025h,001h,000h	; 41b0  ...........XZ%..
	defb 06fh,06fh,02dh,025h,025h,025h,001h,000h,000h,020h,024h,024h,025h,06dh,06dh,000h	; 41c0  oo-%%%... $$%mm.
	defb 00ch,00ch,018h,030h,060h,060h,030h,018h,000h,000h,000h,000h,000h,000h,001h,003h	; 41d0  ...0``0.........
	defb 000h,001h,002h,007h,03dh,01eh,07dh,003h,000h,000h,07fh,01fh,03ch,007h,07eh,07fh	; 41e0  ....=.}.....<.~.
	defb 000h,000h,000h,000h,000h,000h,07fh,03fh,006h,004h,00ch,008h,008h,018h,010h,038h	; 41f0  .......?.......8
	defb 060h,020h,030h,010h,010h,018h,008h,01ch,000h,018h,018h,024h,024h,042h,07eh,07eh	; 4200  ` 0........$$B~~
	defb 000h,078h,044h,078h,044h,04ch,07ch,078h,000h,00ch,030h,060h,070h,03ch,00eh,002h	; 4210  .xDxDL|x..0`p<..
	defb 000h,060h,058h,046h,046h,05eh,078h,060h,000h,07eh,022h,010h,010h,022h,07eh,07eh	; 4220  .`XFF^x`.~".."~~
	defb 000h,07ch,07ch,044h,040h,07ch,044h,040h,000h,01eh,022h,040h,04eh,066h,03ch,018h	; 4230  .||D@|D@.."@Nf<.
	defb 000h,066h,042h,05ah,066h,042h,066h,066h,000h,07eh,05ah,018h,018h,05ah,07eh,07eh	; 4240  .fBZfBff.~Z..Z~~
	defb 000h,07eh,042h,042h,002h,066h,03ch,018h,000h,062h,04ch,070h,078h,04ch,066h,066h	; 4250  .~BB.f<..bLpxLff
	defb 000h,010h,010h,020h,020h,042h,07eh,07eh,000h,042h,066h,05ah,042h,042h,066h,066h	; 4260  ...  B~~.BfZBBff
	defb 000h,062h,046h,04eh,05ah,072h,066h,046h,000h,018h,024h,05ah,05ah,066h,03ch,018h	; 4270  .bFNZrfF..$ZZf<.
	defb 000h,078h,07eh,056h,016h,078h,050h,010h,000h,018h,024h,042h,04ah,066h,03eh,01ah	; 4280  .x~V.xP...$BJf>.
	defb 000h,078h,07eh,056h,016h,078h,054h,012h,000h,008h,010h,020h,07ch,018h,030h,060h	; 4290  .x~V.xT.... |.0`
	defb 000h,008h,01ch,03eh,06bh,008h,008h,008h,000h,066h,042h,066h,024h,03ch,018h,018h	; 42a0  ...>k....fBf$<..
	defb 000h,066h,042h,066h,024h,03ch,018h,018h,000h,066h,042h,042h,05ah,07eh,024h,024h	; 42b0  .fBf$<...fBBZ~$$
	defb 000h,066h,07eh,05ah,018h,05ah,07eh,066h,000h,066h,042h,07eh,018h,018h,03ch,03ch	; 42c0  .f~Z.Z~f.fB~..<<
	defb 000h,07eh,046h,00ch,018h,032h,07eh,07eh,000h,07eh,000h,066h,04eh,05ah,072h,066h	; 42d0  .~F..2~~.~.fNZrf
	defb 000h,018h,024h,04ah,052h,066h,03ch,018h,000h,010h,030h,010h,010h,010h,07ch,07ch	; 42e0  ..$JRf<...0...||
	defb 000h,038h,06ch,00ch,018h,032h,07eh,07eh,000h,07eh,044h,002h,042h,042h,07eh,03ch	; 42f0  .8l..2~~.~D.BB~<
	defb 000h,008h,010h,020h,07eh,07eh,00ah,008h,000h,07eh,020h,03ch,006h,006h,07eh,07ch	; 4300  ... ~~...~ <..~|
	defb 000h,03eh,040h,07ch,042h,042h,07eh,03ch,000h,07eh,046h,00ch,00ch,018h,018h,018h	; 4310  .>@|BB~<.~F.....
	defb 000h,03ch,042h,03ch,042h,042h,07eh,03ch,000h,03eh,07eh,044h,044h,03eh,004h,004h	; 4320  .<B<BB~<.>~DD>..
	defb 000h,018h,000h,018h,038h,040h,044h,03ch,000h,03ch,022h,002h,01ch,018h,000h,018h	; 4330  ....8@D<.<".....
	defb 000h,06ch,06ch,06ch,06ch,000h,000h,000h,000h,01ch,01ch,01ch,018h,018h,000h,018h	; 4340  .llll...........
	defb 000h,000h,000h,000h,000h,018h,018h,018h,000h,000h,000h,01ch,01ch,004h,01ch,018h	; 4350  ................
	defb 000h,01ch,01ch,01ch,000h,01ch,01ch,01ch,000h,000h,000h,07eh,07eh,07eh,000h,000h	; 4360  ...........~~~..
	defb 000h,07fh,07fh,07fh,07fh,040h,040h,040h,03fh,060h,020h,04fh,050h,048h,05bh,000h	; 4370  .....@@@?` OPH[.
	defb 000h,001h,001h,001h,001h,001h,003h,003h,003h,003h,007h,007h,00fh,01fh,03fh,000h	; 4380  ..............?.
	defb 01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,000h,04ah,00ah,002h,012h,012h,04ah,008h	; 4390  .........J....J.
	defb 00ah,002h,012h,010h,002h,075h,00ah,00ah,000h,03eh,00dh,042h,058h,018h,000h,000h	; 43a0  .....u...>.BX...
	defb 000h,03eh,061h,03fh,002h,03fh,003h,013h,000h,05ch,05ch,040h,003h,034h,033h,000h	; 43b0  .>a?.?...\\@.43.
	defb 000h,072h,072h,000h,000h,073h,00ch,001h,000h,000h,000h,000h,000h,000h,000h,000h	; 43c0  .rr..s..........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 43d0  ................
	defb 07eh,03fh,003h,03bh,023h,023h,013h,013h,013h,02bh,02bh,013h,013h,02bh,02bh,013h	; 43e0  ~?.;##...++..++.
	defb 013h,013h,03bh,023h,023h,007h,000h,07eh,000h,07fh,07fh,07fh,06fh,06fh,037h,000h	; 43f0  ..;##..~....oo7.
	defb 000h,001h,001h,000h,07ah,07ah,074h,000h,017h,017h,017h,017h,017h,017h,017h,017h	; 4400  ....zzt.........
	defb 074h,074h,074h,074h,074h,074h,074h,074h,000h,037h,06fh,06fh,000h,07fh,07fh,07fh	; 4410  tttttttt.7oo....
	defb 000h,074h,07ah,07ah,000h,001h,001h,000h,000h,03fh,01fh,019h,06fh,02ch,028h,038h	; 4420  .tzz.....?..o,(8
	defb 018h,00ch,00ch,013h,027h,018h,030h,030h,067h,06fh,07eh,060h,060h,030h,030h,018h	; 4430  ....'.00go~``00.
	defb 00ch,00eh,039h,01dh,032h,036h,03fh,07fh,007h,01fh,03fh,073h,063h,007h,00fh,00bh	; 4440  ..9.26?...?sc...
	defb 030h,070h,063h,047h,04ch,06ch,003h,001h,01fh,007h,003h,031h,039h,01fh,00fh,02fh	; 4450  0pcGLl.....19../
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4460  ................
	defb 003h,00fh,03fh,01fh,01fh,040h,001h,003h,000h,000h,000h,000h,000h,000h,000h,000h	; 4470  ..?..@..........
	defb 000h,024h,024h,024h,024h,024h,024h,000h,000h,000h,000h,001h,07ch,018h,000h,000h	; 4480  .$$$$$$.....|...
	defb 000h,07fh,07fh,07fh,07fh,07fh,07fh,07fh,000h,000h,000h,000h,000h,000h,000h,000h	; 4490  ................
	defb 000h,001h,001h,001h,001h,001h,001h,000h,008h,008h,04ah,042h,07eh,042h,042h,024h	; 44a0  ..........JB~BB$
	defb 01fh,007h,003h,001h,001h,000h,000h,000h,003h,001h,001h,001h,000h,000h,000h,000h	; 44b0  ................
	defb 000h,07fh,07fh,07fh,07fh,07fh,07fh,000h,004h,00ch,02eh,03eh,020h,004h,048h,03ch	; 44c0  ...........> .H<
	defb 038h,07fh,07eh,03ch,018h,03ch,018h,018h,040h,040h,03fh,01bh,013h,06ch,064h,064h	; 44d0  8.~<.<..@@?..ldd
	defb 020h,062h,062h,072h,00dh,009h,019h,064h,000h,000h,000h,003h,00fh,01fh,01fh,03fh	; 44e0   bbr...d.......?
	defb 007h,01fh,000h,000h,000h,000h,000h,000h,01fh,007h,000h,000h,000h,000h,000h,000h	; 44f0  ................
	defb 000h,000h,000h,03fh,00fh,007h,007h,003h,07fh,03fh,03fh,07fh,07fh,07fh,07fh,07fh	; 4500  ...?.....??.....
	defb 001h,001h,003h,003h,001h,001h,001h,001h,000h,000h,001h,003h,007h,00fh,01fh,03fh	; 4510  ...............?
	defb 00fh,07fh,01fh,000h,000h,000h,000h,000h,00fh,001h,000h,000h,000h,000h,000h,000h	; 4520  ................
	defb 000h,000h,07fh,03fh,01fh,00fh,007h,003h,03fh,07fh,07fh,07fh,000h,000h,000h,000h	; 4530  ...?....?.......
	defb 007h,01fh,03fh,07fh,07fh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4540  ..?.............
	defb 038h,07eh,061h,018h,03fh,047h,03fh,007h,07eh,03fh,06bh,07fh,05dh,063h,07fh,07eh	; 4550  8~a.?G?.~?k.]c.~
	defb 078h,03ch,01eh,01fh,07fh,01eh,03ch,078h,00fh,017h,03fh,07dh,007h,00fh,05fh,000h	; 4560  x<....<x..?}.._.
	defb 03fh,07fh,050h,028h,00fh,00fh,00dh,00fh,000h,000h,000h,000h,000h,004h,000h,020h	; 4570  ?.P(........... 
	defb 003h,001h,001h,007h,00fh,00fh,00fh,00fh,00fh,00dh,00fh,00fh,00fh,00bh,00fh,00fh	; 4580  ................
	defb 000h,002h,040h,000h,000h,004h,000h,020h,00fh,00fh,00fh,00fh,00fh,00fh,00fh,00fh	; 4590  ..@.... ........
	defb 00fh,00dh,00fh,00fh,03fh,07fh,07fh,03fh,000h,002h,040h,000h,000h,000h,000h,000h	; 45a0  ....?..?..@.....
	defb 00fh,00fh,00fh,00fh,008h,004h,001h,003h,07fh,040h,03fh,03dh,02fh,03eh,07fh,07fh	; 45b0  .........@?=/>..
	defb 000h,000h,040h,002h,010h,001h,000h,000h,001h,003h,003h,003h,003h,003h,000h,001h	; 45c0  ..@.............
	defb 07eh,001h,003h,003h,003h,007h,000h,07eh,07fh,004h,00ch,01ch,02ch,03ch,018h,000h	; 45d0  ~......~....,<..
	defb 01fh,00bh,033h,043h,005h,008h,000h,000h,055h,055h,000h,03fh,000h,03fh,07fh,003h	; 45e0  ..3C....UU.?.?..
	defb 001h,007h,001h,007h,000h,003h,001h,000h,03ch,002h,040h,000h,000h,004h,020h,000h	; 45f0  ........<.@... .
	defb 07eh,03fh,000h,000h,001h,07ch,018h,000h,03ch,002h,040h,000h,000h,004h,020h,000h	; 4600  ~?...|..<.@... .
	defb 01fh,07fh,07fh,000h,008h,021h,000h,000h,007h,001h,001h,013h,050h,07fh,000h,000h	; 4610  .....!......P...
	defb 000h,000h,000h,000h,001h,07ch,018h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4620  .....|..........
	defb 000h,000h,000h,002h,077h,021h,000h,000h,007h,01fh,03fh,07fh,07fh,004h,020h,000h	; 4630  ....w!....?... .
	defb 000h,002h,040h,000h,000h,004h,020h,000h,01fh,007h,003h,001h,001h,020h,004h,000h	; 4640  ..@... ...... ..
	defb 000h,000h,05eh,010h,01fh,01fh,01fh,01fh,03ch,042h,066h,05eh,05eh,07eh,042h,03ch	; 4650  ..^.....<Bf^^~B<
	defb 003h,007h,00eh,03eh,05ch,078h,000h,004h,00ch,043h,003h,003h,047h,05fh,000h,07fh	; 4660  ...>\x...C..G_..
	defb 03fh,01fh,070h,07ch,03ah,01eh,000h,035h,03dh,03fh,03fh,03dh,01dh,018h,000h,001h	; 4670  ?.p|:..5=??=....
	defb 03ch,07fh,06ch,048h,000h,053h,057h,057h,070h,000h,030h,03fh,03fh,03fh,03fh,03fh	; 4680  <.lH.SWWp.0?????
	defb 03eh,000h,01fh,003h,003h,003h,003h,003h,03fh,03fh,03fh,03fh,03fh,07fh,000h,07ch	; 4690  >.......?????..|
	defb 003h,003h,003h,003h,007h,000h,000h,03eh,07fh,03fh,07fh,07fh,07fh,07fh,000h,07fh	; 46a0  .......>.?......
	defb 010h,018h,000h,000h,002h,046h,000h,040h,001h,001h,003h,003h,013h,017h,000h,011h	; 46b0  .....F.@........
	defb 03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,007h,003h,003h,003h,003h,003h,003h,003h	; 46c0  ????????........
	defb 009h,049h,049h,04bh,04bh,024h,004h,000h,003h,003h,003h,003h,03ch,042h,042h,07eh	; 46d0  .IIKK$......<BB~
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,07fh,043h,05fh,05fh,05fh,05fh,05fh	; 46e0  ..........C_____
	defb 000h,07fh,040h,05fh,05fh,05fh,07fh,07fh,05fh,020h,01fh,000h,000h,007h,004h,005h	; 46f0  ..@___.._ ......
	defb 001h,001h,005h,005h,005h,002h,001h,000h,025h,025h,025h,025h,025h,025h,025h,025h	; 4700  ........%%%%%%%%
	defb 000h,07fh,07fh,03fh,03fh,03fh,03fh,03fh,000h,000h,000h,000h,000h,000h,000h,000h	; 4710  ...?????........
	defb 000h,001h,000h,003h,003h,003h,003h,003h,000h,000h,000h,000h,000h,000h,000h,000h	; 4720  ................
	defb 03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,003h,003h,003h,003h,003h,003h,003h,003h	; 4730  ????????........
	defb 001h,001h,043h,053h,053h,05bh,000h,000h,03fh,000h,03fh,03fh,01fh,01fh,01fh,01fh	; 4740  ..CSS[..?.??....
	defb 003h,000h,003h,000h,002h,04ah,00ah,00ah,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh	; 4750  .....J..........
	defb 07dh,00ah,02ah,028h,002h,04ah,00ah,00ah,013h,001h,001h,004h,014h,012h,034h,034h	; 4760  }.*(.J........44
	defb 020h,020h,008h,00ch,01ch,038h,001h,001h,07eh,07fh,010h,030h,062h,066h,046h,042h	; 4770    ...8..~..0bfFB
	defb 012h,010h,008h,008h,018h,010h,040h,040h,07bh,044h,022h,01ah,01fh,030h,037h,00fh	; 4780  ......@@{D"..07.
	defb 042h,042h,062h,062h,066h,019h,009h,000h,021h,022h,044h,058h,007h,00ch,003h,00fh	; 4790  BBbbf...!"DX....
	defb 007h,03fh,03fh,01fh,001h,01fh,01fh,003h,01fh,007h,007h,01fh,07fh,00fh,007h,007h	; 47a0  .??.............
	defb 07eh,038h,000h,07eh,038h,000h,07eh,038h,000h,05fh,052h,000h,052h,05fh,000h,000h	; 47b0  ~8.~8.~8._R.R_..
	defb 000h,005h,04ah,000h,04ah,005h,000h,000h,037h,034h,01eh,001h,003h,01eh,034h,037h	; 47c0  ..J.J...74....47
	defb 013h,02ch,078h,07fh,03fh,078h,02ch,013h,000h,004h,01eh,07fh,000h,07fh,01eh,004h	; 47d0  .,x.?x,.........
	defb 000h,020h,078h,001h,000h,001h,078h,020h,007h,07ch,03eh,01fh,01fh,03eh,07ch,007h	; 47e0  . x...x .|>..>|.
	defb 01fh,03eh,07ch,007h,007h,07ch,03eh,01fh,000h,000h,000h,000h,000h,000h,000h,000h	; 47f0  .>|..|>.........
	defb 0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,09fh,0afh,09ah,09ah,019h,019h,0a1h,0a1h	; 4800  ................
	defb 0afh,0afh,01ah,01ah,01ah,0a1h,0a1h,0a1h,01fh,01fh,01ah,01ah,01ah,01ah,01ah,01ah	; 4810  ................
	defb 0b0h,0b0h,0bfh,0afh,09ah,099h,0a0h,0a0h,01fh,01fh,01ah,01ah,01ah,01ah,0a1h,091h	; 4820  ................
	defb 09fh,0afh,019h,0a1h,0a1h,0a1h,0a1h,0a1h,0f1h,0f1h,0afh,0afh,01ah,01ah,01ah,01ah	; 4830  ................
	defb 01fh,01fh,01ah,01ah,01ah,01ah,01ah,09ah,0a1h,0a1h,0a1h,0a1h,0a1h,091h,091h,091h	; 4840  ................
	defb 091h,0a1h,0a1h,0a1h,01ah,01ah,09ah,099h,01ah,01ah,019h,019h,019h,019h,019h,019h	; 4850  ................
	defb 091h,091h,091h,091h,019h,019h,019h,019h,0a1h,0a1h,0a1h,0a1h,0a1h,01ah,09ah,099h	; 4860  ................
	defb 0f0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,090h,09ah,09ah,09ah,099h,099h,099h,091h,091h	; 4870  ................
	defb 019h,019h,019h,019h,019h,019h,019h,019h,09ah,09ah,09ah,099h,019h,019h,019h,019h	; 4880  ................
	defb 0f1h,0f1h,0fah,01ah,01ah,01ah,01ah,09ah,011h,0f1h,0e1h,0e1h,0e1h,0e1h,0e1h,0e1h	; 4890  ................
	defb 01fh,01eh,01eh,05eh,05eh,05eh,05eh,05eh,05eh,05eh,05eh,055h,055h,055h,055h,051h	; 48a0  ...^^^^^^^^UUUUQ
	defb 05eh,015h,015h,015h,051h,015h,015h,011h,0f1h,0efh,04eh,05eh,05eh,05eh,055h,051h	; 48b0  ^...Q.....N^^^UQ
	defb 01fh,01eh,04eh,0e5h,05eh,05eh,055h,055h,01fh,05eh,05eh,0e5h,05eh,05eh,055h,015h	; 48c0  ..N.^^UU.^^.^^U.
	defb 0f1h,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0e1h,01eh,01eh,0e1h,01eh,01eh,01eh,01eh	; 48d0  ................
	defb 01eh,0e1h,0e1h,0e1h,0e1h,051h,051h,051h,05eh,05eh,05eh,05eh,05eh,055h,055h,015h	; 48e0  .....QQQ^^^^^UU.
	defb 090h,090h,080h,030h,030h,030h,020h,020h,068h,068h,068h,068h,068h,008h,008h,080h	; 48f0  ...000  hhhhh...
	defb 08bh,08bh,08bh,08bh,08bh,08bh,08bh,08bh,080h,080h,080h,080h,0b0h,0b0h,0bbh,0bbh	; 4900  ................
	defb 00fh,00ah,00ah,00ah,00ah,00ah,00ah,009h,0f0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,090h	; 4910  ................
	defb 00fh,00ah,00ah,00ah,00ah,000h,000h,000h,0f0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h	; 4920  ................
	defb 0fbh,0afh,0afh,0afh,0afh,0afh,0a9h,09bh,0bfh,0fah,0fah,0fah,0fah,0fah,09ah,0b9h	; 4930  ................
	defb 0bfh,0fah,09ah,09ah,09ah,09ah,09ah,0b9h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 4940  ................
	defb 00bh,00bh,00bh,00bh,00bh,00bh,00bh,00bh,0f0h,0f0h,0a0h,0a0h,0a0h,0f0h,0a0h,0a0h	; 4950  ................
	defb 00bh,00bh,009h,009h,000h,00bh,009h,000h,00fh,00fh,0afh,0afh,0afh,0afh,0afh,0afh	; 4960  ................
	defb 09fh,09fh,09ah,09ah,09ah,09ah,09ah,09ah,0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh	; 4970  ................
	defb 05ah,05ah,05ah,05ah,05ah,05ah,05ah,0a5h,005h,005h,005h,005h,005h,005h,005h,005h	; 4980  ZZZZZZZ.........
	defb 007h,005h,004h,005h,005h,005h,005h,005h,0a0h,0a0h,0a0h,0a0h,050h,050h,050h,005h	; 4990  ............PPP.
	defb 000h,000h,050h,005h,005h,005h,005h,005h,0a5h,0a5h,0a5h,0a5h,0a5h,0a5h,0a5h,0a5h	; 49a0  ..P.............
	defb 09ah,09ah,09ah,09ah,09ah,09ah,09ah,09ah,03bh,03bh,02bh,02bh,02bh,0b2h,0b2h,0b2h	; 49b0  ........;;+++...
	defb 003h,003h,002h,002h,002h,002h,002h,002h,000h,030h,030h,030h,020h,020h,020h,022h	; 49c0  .........000   "
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,020h,020h,020h,020h,020h,020h,0e0h,0e0h	; 49d0  ........      ..
	defb 000h,0f0h,0f0h,0e0h,0e0h,00eh,00eh,070h,070h,070h,00fh,00eh,0e0h,0e0h,00eh,007h	; 49e0  .......ppp......
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,00eh,00eh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,050h	; 49f0  ...............P
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,050h,081h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a00  .......P........
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a10  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a20  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a30  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a40  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a50  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a60  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a70  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a80  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4a90  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4aa0  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4ab0  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4ac0  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4ad0  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4ae0  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4af0  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4b00  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4b10  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4b20  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4b30  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4b40  ................
	defb 011h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4b50  ................
	defb 081h,0a1h,0a1h,091h,091h,091h,081h,081h,011h,0a1h,0a1h,091h,091h,091h,081h,081h	; 4b60  ................
	defb 080h,006h,006h,006h,006h,060h,060h,060h,006h,060h,060h,006h,060h,060h,006h,006h	; 4b70  .....```.``.``..
	defb 000h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,099h	; 4b80  ................
	defb 089h,089h,089h,089h,089h,089h,089h,089h,086h,006h,006h,006h,006h,006h,006h,006h	; 4b90  ................
	defb 006h,006h,006h,006h,006h,060h,006h,006h,009h,096h,096h,096h,096h,096h,096h,096h	; 4ba0  .....`..........
	defb 099h,096h,069h,096h,069h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h	; 4bb0  ..i.i...........
	defb 096h,096h,096h,096h,096h,069h,096h,096h,09dh,09dh,09dh,090h,09dh,09dh,09dh,090h	; 4bc0  .....i..........
	defb 09dh,090h,095h,090h,09dh,090h,097h,090h,090h,090h,095h,090h,090h,090h,097h,090h	; 4bd0  ................
	defb 0f1h,0efh,05eh,05eh,05eh,05eh,05eh,05eh,05eh,05eh,05eh,05eh,05eh,05eh,05eh,05eh	; 4be0  ..^^^^^^^^^^^^^^
	defb 05eh,05eh,05eh,05eh,05eh,05eh,055h,051h,05fh,07fh,07fh,05fh,070h,070h,070h,070h	; 4bf0  ^^^^^^UQ_.._pppp
	defb 05fh,057h,057h,055h,050h,050h,050h,050h,070h,070h,070h,070h,070h,070h,070h,070h	; 4c00  _WWUPPPPpppppppp
	defb 050h,050h,050h,050h,050h,050h,050h,050h,070h,070h,070h,070h,07fh,07fh,07fh,05fh	; 4c10  PPPPPPPPpppp..._
	defb 050h,050h,050h,050h,05fh,057h,057h,055h,050h,00bh,003h,00bh,030h,030h,030h,030h	; 4c20  PPPP_WWUP...0000
	defb 030h,030h,030h,00bh,003h,030h,030h,030h,0b0h,030h,030h,030h,030h,030h,030h,030h	; 4c30  000..000.0000000
	defb 030h,030h,003h,003h,020h,020h,020h,020h,030h,030h,020h,0c0h,0c0h,030h,020h,0c0h	; 4c40  00..    00 ..0 .
	defb 030h,030h,030h,020h,020h,020h,002h,002h,003h,003h,002h,00ch,00ch,003h,002h,00ch	; 4c50  000   ..........
	defb 0f1h,0f1h,0f1h,0f1h,0f1h,0f1h,0f1h,0f1h,057h,05fh,05fh,05fh,05fh,05fh,05fh,05fh	; 4c60  ........W_______
	defb 09ah,09ah,091h,091h,091h,019h,019h,019h,00eh,00fh,00eh,005h,007h,007h,00fh,00fh	; 4c70  ................
	defb 00fh,0f7h,0feh,0feh,0feh,0f7h,0f5h,0ffh,0f0h,0f0h,0f0h,050h,005h,005h,005h,005h	; 4c80  ...........P....
	defb 047h,057h,057h,057h,057h,057h,057h,047h,047h,045h,045h,045h,045h,045h,045h,044h	; 4c90  GWWWWWWGGEEEEEED
	defb 047h,045h,045h,045h,045h,045h,045h,044h,0f0h,0f0h,0f0h,00fh,0f0h,00eh,0e0h,0e0h	; 4ca0  GEEEEEED........
	defb 090h,090h,090h,090h,090h,090h,090h,090h,0f9h,0f9h,0f9h,0f9h,0f9h,0f9h,0f9h,0f9h	; 4cb0  ................
	defb 09ah,09ah,09ah,09ah,09ah,09ah,09ah,098h,0b0h,0b0h,0b0h,0b0h,09bh,09bh,09bh,08bh	; 4cc0  ................
	defb 08ah,0a0h,030h,0c0h,020h,0e0h,020h,020h,0a0h,0a0h,00ah,00ah,00ah,0a0h,0a0h,0a0h	; 4cd0  ..0. .  ........
	defb 0a0h,0a0h,0a0h,0a0h,00ah,00ah,00ah,0a0h,0c7h,0c5h,0c5h,005h,005h,005h,004h,004h	; 4ce0  ................
	defb 007h,005h,000h,000h,000h,000h,000h,000h,070h,050h,050h,050h,050h,050h,050h,050h	; 4cf0  ........pPPPPPPP
	defb 007h,005h,005h,050h,050h,050h,040h,040h,005h,005h,004h,004h,004h,004h,004h,004h	; 4d00  ...PPP@@........
	defb 070h,070h,070h,050h,050h,050h,050h,050h,09fh,09fh,0afh,0afh,09fh,09fh,09fh,09fh	; 4d10  pppPPPPP........
	defb 0afh,0afh,09ah,099h,099h,099h,099h,099h,0fah,0f9h,0f9h,0f9h,0f9h,0f9h,0f9h,0f9h	; 4d20  ................
	defb 00fh,00fh,0f9h,0f9h,0f9h,0f9h,0f9h,0f9h,09fh,09fh,09fh,09fh,099h,099h,099h,099h	; 4d30  ................
	defb 009h,009h,009h,009h,009h,000h,000h,000h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 4d40  ................
	defb 0f0h,0b0h,00bh,00bh,0a0h,0a0h,0a0h,090h,0f0h,0afh,0afh,0afh,0afh,0afh,0afh,090h	; 4d50  ................
	defb 0f0h,0a0h,0a0h,0afh,0afh,090h,090h,090h,0f0h,0a0h,0a0h,0a0h,00ah,009h,009h,000h	; 4d60  ................
	defb 0f0h,0f0h,0efh,0efh,07fh,07fh,07fh,07fh,05fh,05fh,05fh,05fh,057h,0f7h,0f7h,0f7h	; 4d70  ........____W...
	defb 00fh,00fh,05fh,05fh,057h,057h,057h,057h,07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh	; 4d80  ..__WWWW........
	defb 0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,057h,057h,057h,057h,057h,057h,057h,057h	; 4d90  ........WWWWWWWW
	defb 07fh,07fh,07fh,07fh,05fh,05fh,050h,050h,0f7h,0f7h,0f7h,0f7h,0f5h,0f5h,0f5h,0f5h	; 4da0  ....__PP........
	defb 057h,057h,057h,057h,005h,005h,005h,005h,0f0h,07fh,07fh,07fh,07fh,07fh,05fh,050h	; 4db0  WWWW.........._P
	defb 05fh,05fh,0f7h,0f7h,0f7h,0f7h,0f5h,0f5h,00fh,05fh,057h,057h,057h,057h,055h,005h	; 4dc0  __......._WWWWU.
	defb 0f0h,057h,057h,057h,057h,057h,055h,040h,090h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h	; 4dd0  .WWWWWU@........
	defb 009h,008h,008h,008h,008h,008h,008h,008h,00eh,0f0h,0f8h,080h,080h,070h,0f0h,045h	; 4de0  .............p.E
	defb 068h,068h,006h,006h,000h,005h,00eh,004h,069h,006h,006h,006h,006h,006h,006h,006h	; 4df0  hh......i.......
	defb 0f0h,0efh,0eeh,0eeh,05eh,0e5h,0e5h,0e5h,096h,009h,009h,009h,009h,009h,009h,009h	; 4e00  ....^...........
	defb 0f0h,0f0h,0f0h,0ffh,0efh,0efh,0eeh,0eeh,00fh,00fh,00fh,0efh,0feh,0efh,0eeh,0eeh	; 4e10  ................
	defb 0eeh,0eeh,0eeh,0eeh,05eh,0e5h,0e5h,0e5h,0eeh,0eeh,0eeh,0eeh,0eeh,0eeh,0eeh,0eeh	; 4e20  ....^...........
	defb 0efh,0efh,0efh,0efh,0feh,0efh,0eeh,0eeh,060h,060h,060h,060h,060h,096h,096h,096h	; 4e30  ........`````...
	defb 096h,096h,096h,096h,096h,096h,096h,096h,006h,006h,006h,006h,006h,096h,096h,096h	; 4e40  ................
	defb 090h,090h,0f0h,00fh,057h,057h,057h,057h,0f0h,0f0h,00fh,00fh,007h,007h,070h,050h	; 4e50  ....WWWW......pP
	defb 090h,080h,0f0h,0f0h,0f0h,0e0h,0e8h,008h,008h,080h,080h,080h,080h,080h,086h,060h	; 4e60  ...............`
	defb 003h,002h,0f0h,0f0h,0f0h,0e0h,0e2h,002h,002h,002h,002h,002h,002h,002h,00ch,00ch	; 4e70  ................
	defb 0f0h,0e0h,00eh,00eh,00eh,00eh,00ah,00ah,090h,099h,089h,089h,089h,089h,089h,089h	; 4e80  ................
	defb 090h,099h,089h,068h,068h,068h,068h,068h,089h,089h,089h,089h,089h,069h,066h,060h	; 4e90  ...hhhhh.....if`
	defb 068h,068h,068h,068h,068h,066h,066h,060h,090h,089h,089h,089h,089h,089h,086h,060h	; 4ea0  hhhhhff`.......`
	defb 009h,098h,098h,098h,068h,068h,066h,006h,009h,068h,068h,068h,068h,068h,066h,006h	; 4eb0  ....hhf..hhhhhf.
	defb 089h,089h,089h,089h,089h,089h,089h,089h,068h,068h,068h,068h,068h,068h,068h,068h	; 4ec0  ........hhhhhhhh
	defb 03bh,03bh,02bh,02bh,02bh,0b2h,0b2h,0b2h,068h,068h,068h,068h,008h,008h,080h,008h	; 4ed0  ;;+++...hhhh....
	defb 00ch,00ch,00ch,00ch,00ch,00ch,00ch,00ch,00fh,0afh,0afh,0afh,0afh,0afh,0afh,0afh	; 4ee0  ................
	defb 0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh,0fah,0afh,0aah,0aah,09ah,09ah,09ah	; 4ef0  ................
	defb 09ah,09ah,09ah,09ah,09ah,0a9h,09ah,099h,09ah,09ah,09ah,09ah,09ah,09ah,09ah,09ah	; 4f00  ................
	defb 09fh,0afh,09fh,0a0h,0a0h,0b0h,0b0h,0b0h,00fh,00ah,009h,00ah,00ah,00ah,00bh,00bh	; 4f10  ................
	defb 0bfh,09ah,099h,00ah,00ah,00ah,00ah,00bh,0abh,0abh,0abh,0abh,0abh,0abh,0abh,0abh	; 4f20  ................
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,0b0h,00bh,00bh,00bh,00bh,00bh,00bh,00bh,00bh	; 4f30  ................
	defb 036h,036h,036h,036h,026h,026h,022h,022h,090h,099h,096h,069h,089h,089h,089h,089h	; 4f40  6666&&""...i....
	defb 009h,009h,069h,066h,006h,006h,006h,006h,089h,089h,089h,089h,089h,089h,089h,089h	; 4f50  ..if............
	defb 060h,006h,006h,006h,006h,006h,006h,006h,00ah,00ah,00ah,08ah,08ah,08ah,08ah,08ah	; 4f60  `...............
	defb 06ah,06ah,08ah,08ah,08ah,06ah,00ah,00ah,0a0h,0a0h,08ah,08ah,08ah,08ah,08ah,08ah	; 4f70  jj...j..........
	defb 08ah,08ah,08ah,06ah,06ah,06ah,00ah,00ah,00fh,0f0h,070h,070h,070h,007h,070h,050h	; 4f80  ...jjj....ppp.pP
	defb 0f0h,0f0h,070h,070h,070h,007h,005h,005h,0f0h,070h,070h,070h,007h,007h,005h,005h	; 4f90  ..ppp....ppp....
	defb 070h,070h,07fh,050h,070h,070h,05fh,050h,007h,007h,057h,005h,007h,007h,057h,005h	; 4fa0  pp.Ppp_P..W...W.
	defb 053h,053h,053h,03ch,03ch,03ch,0c5h,0c5h,000h,00fh,0f0h,0ffh,0e0h,00eh,000h,000h	; 4fb0  SSS<<<..........
	defb 000h,0f0h,0f0h,0ffh,0e0h,0e0h,0e0h,0e0h,00bh,0b0h,0b0h,09ah,09ah,090h,090h,009h	; 4fc0  ................
	defb 0b0h,0b0h,0b0h,0a9h,0a9h,090h,090h,090h,050h,0f0h,0f0h,0f0h,0f7h,070h,050h,050h	; 4fd0  ........P....pPP
	defb 050h,0f0h,0f0h,00fh,007h,007h,050h,050h,00ah,090h,090h,090h,090h,090h,080h,006h	; 4fe0  P.....PP........
	defb 0a0h,090h,090h,009h,009h,090h,080h,060h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h	; 4ff0  .......`........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5000  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5010  ................
	defb 000h,000h,000h,001h,001h,001h,003h,0ffh,003h,001h,001h,001h,000h,000h,000h,000h	; 5020  ................
	defb 000h,000h,000h,000h,000h,000h,080h,0f0h,080h,000h,000h,000h,000h,000h,000h,000h	; 5030  ................
	defb 01ch,004h,000h,000h,000h,000h,037h,076h,06eh,02eh,01fh,000h,01fh,01fh,01fh,000h	; 5040  ......7vn.......
	defb 060h,050h,030h,000h,000h,000h,0f0h,0c4h,0fah,0fah,07ah,000h,0fch,0fch,0fch,000h	; 5050  `P0.......z.....
	defb 003h,01bh,03fh,03fh,01bh,007h,000h,000h,000h,000h,000h,00fh,000h,000h,000h,003h	; 5060  ..??............
	defb 080h,080h,0ceh,0ffh,0ffh,0eeh,000h,000h,000h,000h,000h,080h,000h,000h,000h,0e0h	; 5070  ................
	defb 000h,01ch,004h,000h,000h,000h,000h,037h,06eh,06eh,01fh,01fh,000h,01fh,01fh,000h	; 5080  .......7nn......
	defb 000h,060h,050h,030h,000h,000h,000h,0f8h,0e0h,0feh,07eh,09eh,000h,0feh,0feh,000h	; 5090  .`P0......~.....
	defb 000h,003h,01bh,03fh,03fh,01bh,007h,000h,000h,000h,000h,000h,00fh,000h,000h,00fh	; 50a0  ...??...........
	defb 000h,080h,080h,0ceh,0ffh,0ffh,0eeh,000h,000h,000h,000h,000h,0e0h,000h,000h,0b8h	; 50b0  ................
	defb 006h,00ah,00ch,000h,000h,000h,00fh,023h,05fh,05fh,05eh,000h,03fh,03fh,03fh,000h	; 50c0  .......#__^.???.
	defb 038h,020h,000h,000h,000h,000h,0ech,06eh,076h,074h,0f8h,000h,0f8h,0f8h,0f8h,000h	; 50d0  8 .....nvt......
	defb 001h,001h,073h,0ffh,0ffh,077h,000h,000h,000h,000h,000h,001h,000h,000h,000h,007h	; 50e0  ..s..w..........
	defb 0c0h,0d8h,0fch,0fch,0d8h,0e0h,000h,000h,000h,000h,000h,0f0h,000h,000h,000h,0c0h	; 50f0  ................
	defb 000h,006h,00ah,00ch,000h,000h,000h,01fh,007h,07fh,07eh,079h,000h,07fh,07fh,000h	; 5100  ..........~y....
	defb 000h,038h,020h,000h,000h,000h,000h,0ech,076h,076h,0f8h,0f8h,000h,0f8h,0f8h,000h	; 5110  .8 .....vv......
	defb 000h,001h,001h,073h,0ffh,0ffh,077h,000h,000h,000h,000h,000h,007h,000h,000h,01dh	; 5120  ...s..w.........
	defb 000h,0c0h,0d8h,0fch,0fch,0d8h,0e0h,000h,000h,000h,000h,000h,0f0h,000h,000h,0f0h	; 5130  ................
	defb 016h,014h,004h,000h,000h,000h,018h,03fh,070h,07eh,03eh,00eh,070h,07fh,07fh,000h	; 5140  .......?p~>.p...
	defb 0d0h,050h,040h,000h,000h,000h,030h,0f8h,01ch,0fch,0f8h,0e0h,01ch,0fch,0fch,000h	; 5150  .P@...0.........
	defb 009h,029h,03bh,037h,017h,00bh,004h,000h,000h,000h,000h,020h,000h,000h,000h,00eh	; 5160  .);7....... ....
	defb 020h,028h,0b8h,0d8h,0d0h,0a0h,040h,000h,000h,000h,000h,004h,000h,000h,000h,0e0h	; 5170   (....@.........
	defb 007h,001h,000h,020h,070h,04eh,03dh,053h,0efh,0eeh,065h,022h,01fh,00fh,007h,003h	; 5180  ... pN=S..e"....
	defb 000h,01ch,014h,00ch,000h,000h,080h,0e0h,060h,0e0h,0e0h,0e0h,040h,080h,000h,000h	; 5190  ........`...@...
	defb 000h,006h,00fh,00fh,006h,001h,000h,020h,000h,000h,010h,059h,060h,030h,010h,000h	; 51a0  ....... ...Y`0..
	defb 0f8h,0e0h,0e0h,0f0h,0feh,0ffh,05fh,00eh,000h,000h,000h,000h,080h,000h,000h,000h	; 51b0  ......_.........
	defb 000h,038h,028h,030h,000h,000h,001h,007h,006h,007h,007h,007h,002h,001h,000h,000h	; 51c0  .8(0............
	defb 0e0h,080h,000h,004h,00eh,072h,0bch,0cah,0f7h,077h,0a6h,044h,0f8h,0f0h,0e0h,0c0h	; 51d0  .....r...w.D....
	defb 01fh,007h,007h,00fh,07fh,0ffh,0fah,070h,000h,000h,000h,000h,001h,000h,000h,000h	; 51e0  .......p........
	defb 000h,060h,0f0h,0f0h,060h,080h,000h,004h,000h,000h,008h,09ah,006h,00ch,008h,000h	; 51f0  .`..`...........
	defb 016h,014h,004h,000h,000h,000h,018h,03fh,07fh,07fh,0efh,0e0h,0edh,01dh,07fh,01fh	; 5200  .......?........
	defb 0d0h,050h,040h,000h,000h,000h,030h,0f8h,0fch,0fch,0eeh,00eh,06eh,0f0h,0fch,0f0h	; 5210  .P@...0.....n...
	defb 009h,029h,03bh,037h,017h,00bh,004h,000h,000h,000h,000h,00fh,002h,062h,000h,000h	; 5220  .);7.........b..
	defb 020h,028h,0b8h,0d8h,0d0h,0a0h,040h,000h,000h,000h,000h,0e0h,080h,00ch,000h,000h	; 5230   (....@.........
	defb 000h,000h,000h,000h,000h,001h,003h,007h,007h,003h,000h,000h,000h,000h,000h,000h	; 5240  ................
	defb 000h,000h,000h,000h,000h,080h,080h,080h,080h,000h,000h,000h,000h,000h,000h,000h	; 5250  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,000h,000h,000h,000h,000h	; 5260  ................
	defb 000h,000h,000h,000h,000h,000h,040h,060h,060h,0c0h,080h,000h,000h,000h,000h,000h	; 5270  ......@``.......
	defb 000h,000h,003h,00ch,010h,010h,021h,023h,023h,020h,000h,000h,000h,000h,000h,000h	; 5280  ......!## ......
	defb 000h,000h,0c0h,000h,000h,000h,080h,080h,090h,010h,020h,0c0h,000h,000h,000h,000h	; 5290  .......... .....
	defb 000h,000h,000h,003h,00fh,00ch,018h,018h,018h,019h,01ch,01fh,00fh,003h,000h,000h	; 52a0  ................
	defb 000h,000h,000h,0f0h,0f8h,038h,01ch,05ch,04ch,08ch,018h,038h,0f0h,0c0h,000h,000h	; 52b0  .....8.\L..8....
	defb 000h,000h,000h,003h,00fh,00ch,018h,018h,018h,018h,00ch,00fh,003h,000h,000h,000h	; 52c0  ................
	defb 000h,000h,000h,0c0h,0f0h,030h,018h,018h,018h,018h,030h,0f0h,0c0h,000h,000h,000h	; 52d0  .....0....0.....
	defb 007h,01fh,03ch,070h,060h,0e0h,0c0h,0c0h,0c0h,0c0h,0e0h,060h,070h,03ch,01fh,007h	; 52e0  ..<p`......`p<..
	defb 0e0h,0f8h,03ch,00eh,006h,007h,003h,003h,003h,003h,007h,006h,00eh,03ch,0f8h,0e0h	; 52f0  ..<..........<..
	defb 007h,01ch,030h,060h,040h,0c0h,080h,080h,080h,080h,0e0h,060h,070h,03ch,01fh,006h	; 5300  ..0`@......`p<..
	defb 0e0h,038h,03ch,00eh,006h,007h,003h,002h,002h,002h,006h,004h,00ch,038h,0e0h,000h	; 5310  .8<..........8..
	defb 000h,003h,00ch,010h,020h,020h,040h,040h,040h,040h,000h,000h,000h,000h,000h,001h	; 5320  ....  @@@@......
	defb 000h,0c0h,000h,000h,000h,000h,000h,001h,001h,001h,001h,002h,002h,004h,018h,0e0h	; 5330  ................
	defb 007h,001h,000h,000h,000h,010h,02fh,057h,02fh,00fh,033h,07ch,07fh,07fh,03fh,007h	; 5340  ....../W/.3|..?.
	defb 000h,01ch,014h,00ch,000h,000h,080h,0e0h,0f0h,0f0h,0f0h,0f0h,000h,0e0h,0e0h,0c0h	; 5350  ................
	defb 000h,006h,00fh,00fh,006h,001h,000h,000h,000h,000h,00ch,003h,000h,000h,040h,000h	; 5360  ..............@.
	defb 0f8h,0e0h,0e0h,0f0h,0feh,0ffh,05fh,00eh,000h,000h,000h,000h,0e0h,000h,000h,000h	; 5370  ......_.........
	defb 007h,001h,000h,000h,070h,0d8h,0bfh,06fh,057h,00fh,033h,07ch,07fh,07fh,03fh,007h	; 5380  ....p..oW.3|..?.
	defb 000h,01ch,014h,00ch,000h,000h,080h,0e0h,0f0h,0f0h,0f0h,0f0h,000h,0e0h,0e0h,0c0h	; 5390  ................
	defb 000h,006h,00fh,00fh,006h,001h,000h,000h,000h,000h,00ch,003h,000h,000h,040h,000h	; 53a0  ..............@.
	defb 0f8h,0e0h,0e0h,0f0h,0feh,0ffh,05fh,00eh,000h,000h,000h,000h,0e0h,000h,000h,000h	; 53b0  ......_.........
	defb 000h,038h,028h,030h,000h,000h,001h,007h,00fh,00fh,00fh,00fh,000h,007h,007h,003h	; 53c0  .8(0............
	defb 0e0h,080h,000h,000h,000h,008h,0f4h,0eah,0f4h,0f0h,0cch,03eh,0feh,0feh,0fch,0e0h	; 53d0  ...........>....
	defb 01fh,007h,007h,00fh,07fh,0ffh,0fah,070h,000h,000h,000h,000h,007h,000h,000h,000h	; 53e0  .......p........
	defb 000h,060h,0f0h,0f0h,060h,080h,000h,000h,000h,000h,030h,0c0h,000h,000h,002h,000h	; 53f0  .`..`.....0.....
	defb 000h,038h,028h,030h,000h,000h,001h,007h,00fh,00fh,00fh,00fh,000h,007h,007h,003h	; 5400  .8(0............
	defb 0e0h,080h,000h,000h,00eh,01bh,0fdh,0f6h,0eah,0f0h,0cch,03eh,0feh,0feh,0fch,0e0h	; 5410  ...........>....
	defb 01fh,007h,007h,00fh,07fh,0ffh,0fah,070h,000h,000h,000h,000h,007h,000h,000h,000h	; 5420  .......p........
	defb 000h,060h,0f0h,0f0h,060h,080h,000h,000h,000h,000h,030h,0c0h,000h,000h,002h,000h	; 5430  .`..`.....0.....
	defb 000h,000h,000h,002h,006h,006h,000h,003h,007h,007h,003h,000h,000h,000h,000h,000h	; 5440  ................
	defb 000h,00eh,01ch,038h,070h,030h,080h,080h,038h,0e0h,080h,000h,000h,000h,000h,000h	; 5450  ...8p0..8.......
	defb 000h,000h,003h,00dh,019h,0f1h,0ffh,01ch,068h,000h,000h,000h,000h,000h,000h,000h	; 5460  ........h.......
	defb 000h,000h,000h,080h,080h,0c0h,063h,07eh,0c0h,000h,000h,000h,000h,000h,000h,000h	; 5470  ......c~........
	defb 000h,000h,000h,002h,006h,006h,000h,003h,007h,007h,003h,000h,000h,000h,000h,000h	; 5480  ................
	defb 000h,000h,070h,078h,078h,028h,088h,080h,038h,0e0h,080h,000h,000h,000h,000h,000h	; 5490  ..pxx(..8.......
	defb 000h,000h,003h,00dh,019h,0f1h,0ffh,07ch,008h,000h,000h,000h,000h,000h,000h,000h	; 54a0  .......|........
	defb 000h,000h,000h,080h,080h,0c0h,060h,07ch,0c7h,001h,000h,000h,000h,000h,000h,000h	; 54b0  ......`|........
	defb 000h,070h,038h,01ch,00eh,00ch,001h,001h,01ch,007h,001h,000h,000h,000h,000h,000h	; 54c0  .p8.............
	defb 000h,000h,000h,040h,060h,060h,000h,0c0h,0e0h,0e0h,0c0h,000h,000h,000h,000h,000h	; 54d0  ...@``..........
	defb 000h,000h,000h,001h,001h,003h,0c6h,07eh,003h,000h,000h,000h,000h,000h,000h,000h	; 54e0  .......~........
	defb 000h,000h,0c0h,0b0h,098h,08fh,0ffh,038h,016h,000h,000h,000h,000h,000h,000h,000h	; 54f0  .......8........
	defb 000h,000h,00eh,01eh,01eh,014h,011h,001h,01ch,007h,001h,000h,000h,000h,000h,000h	; 5500  ................
	defb 000h,000h,000h,040h,060h,060h,000h,0c0h,0e0h,0e0h,0c0h,000h,000h,000h,000h,000h	; 5510  ...@``..........
	defb 000h,000h,000h,001h,001h,003h,006h,03eh,0e3h,080h,000h,000h,000h,000h,000h,000h	; 5520  .......>........
	defb 000h,000h,0c0h,0b0h,098h,08fh,0ffh,03eh,010h,000h,000h,000h,000h,000h,000h,000h	; 5530  .......>........
	defb 03eh,07fh,0ffh,0f8h,0f0h,0f1h,060h,064h,0e0h,0e0h,0f1h,0e0h,0e0h,0e0h,0c0h,000h	; 5540  >.....`d........
	defb 03ch,0feh,0fch,0f8h,010h,000h,000h,040h,000h,000h,020h,000h,000h,000h,000h,000h	; 5550  <......@.. .....
	defb 000h,000h,000h,007h,00fh,00eh,01fh,01bh,01fh,01fh,00eh,01fh,01fh,01ah,035h,068h	; 5560  ..............5h
	defb 000h,001h,003h,002h,0edh,0fah,0fdh,0bah,0f5h,0fah,0ddh,0fah,0f5h,0aah,055h,02ah	; 5570  ..............U*
	defb 010h,038h,078h,0f8h,0b8h,0f8h,070h,001h,001h,004h,014h,000h,002h,000h,000h,000h	; 5580  .8x...p.........
	defb 000h,000h,000h,040h,000h,080h,000h,060h,000h,060h,000h,0c0h,000h,000h,000h,000h	; 5590  ...@...`.`......
	defb 000h,003h,007h,007h,007h,007h,00fh,03eh,03ch,038h,000h,000h,000h,003h,003h,001h	; 55a0  .......><8......
	defb 000h,0f0h,0fch,0beh,0bfh,03fh,01fh,01fh,01fh,01fh,03fh,03eh,07eh,0fch,0f8h,0e0h	; 55b0  .....?....?>~...
	defb 000h,000h,018h,03ch,07ch,0dch,0f8h,070h,001h,002h,02ah,029h,005h,000h,000h,000h	; 55c0  ...<|..p..*)....
	defb 000h,000h,000h,000h,040h,000h,040h,080h,020h,000h,060h,000h,000h,000h,000h,000h	; 55d0  ....@.@. .`.....
	defb 000h,000h,000h,003h,003h,003h,007h,00fh,07eh,078h,000h,000h,000h,00fh,00fh,007h	; 55e0  ........~x......
	defb 000h,000h,0f0h,0fch,0beh,0beh,0bfh,03fh,01fh,01fh,01fh,03eh,0fch,0f8h,0f0h,0c0h	; 55f0  .......?...>....
	defb 000h,000h,000h,002h,000h,001h,000h,006h,000h,006h,000h,003h,000h,000h,000h,000h	; 5600  ................
	defb 008h,01ch,01eh,01fh,01dh,01fh,00eh,080h,080h,020h,028h,000h,040h,000h,000h,000h	; 5610  ......... (.@...
	defb 000h,00fh,03fh,07dh,0fdh,0fch,0f8h,0f8h,0f8h,0f8h,0fch,07ch,07eh,03fh,01fh,007h	; 5620  ..?}.......|~?..
	defb 000h,0c0h,0e0h,0e0h,0e0h,0e0h,0f0h,07ch,03ch,01ch,000h,000h,000h,0c0h,0c0h,080h	; 5630  .......|<.......
	defb 000h,000h,000h,000h,002h,000h,002h,001h,004h,000h,006h,000h,000h,000h,000h,000h	; 5640  ................
	defb 000h,000h,018h,03ch,03eh,03bh,01fh,00eh,080h,040h,054h,094h,0a0h,000h,000h,000h	; 5650  ...<>;...@T.....
	defb 000h,000h,00fh,03fh,07dh,07dh,0fdh,0fch,0f8h,0f8h,0f8h,07ch,03fh,01fh,00fh,003h	; 5660  ...?}}.....|?...
	defb 000h,000h,000h,0c0h,0c0h,0c0h,0e0h,0f0h,07eh,01eh,000h,000h,000h,0f0h,0f0h,0e0h	; 5670  ........~.......
	defb 000h,000h,003h,007h,003h,00dh,00fh,00fh,006h,003h,001h,001h,001h,000h,000h,000h	; 5680  ................
	defb 000h,000h,080h,0c0h,0a0h,070h,0f0h,020h,040h,0e0h,0c0h,0c0h,080h,000h,000h,000h	; 5690  .....p. @.......
	defb 002h,007h,00ch,008h,018h,010h,000h,000h,000h,000h,000h,000h,000h,003h,003h,004h	; 56a0  ................
	defb 000h,000h,000h,000h,000h,000h,008h,01ch,01ch,01ch,038h,038h,070h,0e0h,080h,000h	; 56b0  ..........88p...
	defb 000h,000h,000h,000h,001h,006h,00fh,01ch,01ah,03fh,01fh,01ch,000h,000h,000h,000h	; 56c0  .........?......
	defb 000h,000h,070h,0f0h,0d0h,0b0h,0e0h,0c0h,000h,000h,000h,000h,000h,000h,000h,000h	; 56d0  ..p.............
	defb 000h,000h,001h,003h,004h,008h,010h,020h,020h,000h,000h,003h,00fh,007h,001h,000h	; 56e0  .......  .......
	defb 040h,0e0h,080h,000h,008h,008h,010h,030h,060h,0c0h,080h,080h,080h,0c0h,0c0h,020h	; 56f0  @......0`...... 
	defb 000h,000h,000h,003h,003h,00dh,01fh,01ch,01bh,01fh,00fh,004h,000h,000h,000h,000h	; 5700  ................
	defb 000h,000h,080h,0c0h,0a0h,060h,0e0h,0c0h,040h,080h,000h,000h,000h,000h,000h,000h	; 5710  .....`..@.......
	defb 000h,001h,007h,00ch,018h,030h,020h,020h,000h,000h,000h,003h,003h,001h,001h,001h	; 5720  .....0  ........
	defb 080h,080h,000h,000h,000h,010h,010h,030h,030h,060h,0e0h,0c0h,0c0h,080h,000h,000h	; 5730  .......00`......
	defb 000h,000h,000h,000h,000h,01ch,02ch,039h,000h,002h,008h,000h,000h,000h,000h,000h	; 5740  ......,9........
	defb 000h,000h,000h,000h,000h,008h,000h,000h,000h,080h,002h,000h,000h,000h,000h,000h	; 5750  ................
	defb 000h,000h,000h,000h,01fh,063h,0c3h,0c6h,0feh,07ch,010h,000h,000h,000h,000h,000h	; 5760  .....c...|......
	defb 000h,000h,000h,000h,021h,0c0h,0e0h,0f2h,068h,070h,060h,000h,000h,000h,000h,000h	; 5770  ....!...hp`.....
	defb 000h,000h,000h,000h,000h,000h,060h,0a0h,0c0h,002h,000h,000h,000h,000h,000h,000h	; 5780  ......`.........
	defb 000h,000h,000h,000h,000h,040h,000h,000h,000h,000h,000h,008h,000h,000h,000h,000h	; 5790  .....@..........
	defb 000h,000h,000h,000h,030h,072h,099h,01ch,03ch,0f8h,098h,074h,000h,000h,000h,000h	; 57a0  ....0r..<..t....
	defb 000h,000h,000h,000h,004h,000h,000h,000h,000h,080h,000h,000h,000h,000h,000h,000h	; 57b0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,010h,000h,000h,000h,000h,000h,000h	; 57c0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,000h,000h,000h,000h	; 57d0  ................
	defb 000h,000h,000h,000h,040h,0c0h,0c8h,0c0h,080h,080h,080h,0c0h,000h,010h,000h,000h	; 57e0  ....@...........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,080h,000h,000h,000h,000h,000h,000h	; 57f0  ................
	defb 000h,000h,000h,000h,001h,080h,0ceh,05eh,07fh,0ffh,0dfh,007h,000h,000h,000h,000h	; 5800  .......^........
	defb 000h,000h,000h,000h,0d8h,054h,00ch,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5810  .....T..........
	defb 000h,000h,000h,000h,000h,001h,001h,001h,000h,000h,000h,000h,000h,000h,000h,000h	; 5820  ................
	defb 000h,000h,000h,000h,020h,0a0h,0f3h,07fh,0dfh,0eeh,0f0h,0c0h,000h,000h,000h,000h	; 5830  .... ...........
	defb 000h,000h,000h,000h,000h,043h,060h,03ch,0bch,0feh,03eh,01fh,007h,000h,000h,000h	; 5840  .....C`<..>.....
	defb 000h,000h,000h,000h,000h,0b0h,0a8h,018h,000h,000h,000h,000h,000h,000h,000h,000h	; 5850  ................
	defb 000h,000h,000h,000h,000h,000h,003h,003h,002h,001h,001h,000h,000h,000h,000h,000h	; 5860  ................
	defb 000h,000h,000h,000h,000h,040h,040h,0e6h,0ffh,0dfh,0eeh,0f0h,0c0h,000h,000h,000h	; 5870  .....@@.........
	defb 000h,000h,000h,000h,01bh,02ah,030h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5880  .....*0.........
	defb 000h,000h,000h,000h,080h,001h,073h,07ah,0feh,0ffh,0fbh,0e0h,000h,000h,000h,000h	; 5890  ......sz........
	defb 000h,000h,000h,000h,004h,005h,0cfh,0feh,0fbh,077h,00fh,003h,000h,000h,000h,000h	; 58a0  .........w......
	defb 000h,000h,000h,000h,000h,080h,080h,080h,000h,000h,000h,000h,000h,000h,000h,000h	; 58b0  ................
	defb 000h,000h,000h,000h,000h,00dh,015h,018h,000h,000h,000h,000h,000h,000h,000h,000h	; 58c0  ................
	defb 000h,000h,000h,000h,000h,0c2h,006h,03ch,03dh,07fh,07ch,0f8h,0e0h,000h,000h,000h	; 58d0  .......<=.|.....
	defb 000h,000h,000h,000h,000h,002h,002h,067h,0ffh,0fbh,077h,00fh,003h,000h,000h,000h	; 58e0  .......g..w.....
	defb 000h,000h,000h,000h,000h,000h,0c0h,0c0h,040h,080h,080h,000h,000h,000h,000h,000h	; 58f0  ........@.......
	defb 000h,000h,010h,030h,050h,060h,028h,008h,048h,043h,04ch,000h,000h,000h,002h,000h	; 5900  ...0P`(.HCL.....
	defb 000h,000h,000h,000h,000h,030h,078h,07ch,092h,008h,000h,000h,000h,000h,000h,000h	; 5910  .....0x|........
	defb 03fh,07eh,0edh,0cfh,08eh,09fh,0d7h,0f7h,003h,03ch,033h,00fh,00fh,00fh,00dh,007h	; 5920  ?~.......<3.....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,060h,0f0h,0fch,0fch,0fch,0f8h,0ech,090h	; 5930  ........`.......
	defb 000h,000h,010h,030h,050h,060h,020h,008h,048h,048h,043h,00ch,000h,000h,002h,000h	; 5940  ...0P` .HHC.....
	defb 000h,000h,000h,000h,000h,03ch,07eh,07fh,079h,09ch,000h,000h,000h,000h,000h,000h	; 5950  .....<~.y.......
	defb 03fh,07eh,0edh,0cfh,08eh,09fh,0dfh,0f7h,003h,007h,03ch,003h,00fh,00fh,00dh,007h	; 5960  ?~........<.....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,060h,0f8h,0fch,0fch,0f8h,0e4h,09ch	; 5970  .........`......
	defb 000h,000h,000h,000h,000h,00ch,01eh,03eh,049h,010h,000h,000h,000h,000h,000h,000h	; 5980  .......>I.......
	defb 000h,000h,008h,00ch,00ah,006h,014h,010h,012h,0c2h,032h,000h,000h,000h,040h,000h	; 5990  ..........2...@.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,006h,00fh,03fh,03fh,03fh,01fh,037h,009h	; 59a0  ..........???.7.
	defb 0fch,07eh,0b7h,0f3h,071h,0f9h,0ebh,0efh,0c0h,03ch,0cch,0f0h,0f0h,0f0h,0b0h,0e0h	; 59b0  .~..q....<......
	defb 000h,000h,000h,000h,000h,03ch,07eh,0feh,09eh,039h,000h,000h,000h,000h,000h,000h	; 59c0  .....<~..9......
	defb 000h,000h,008h,00ch,00ah,006h,004h,010h,012h,012h,0c2h,030h,000h,000h,040h,000h	; 59d0  ...........0..@.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,006h,01fh,03fh,03fh,01fh,027h,039h	; 59e0  ...........??.'9
	defb 0fch,07eh,0b7h,0f3h,071h,0f9h,0fbh,0efh,0c0h,0e0h,03ch,0c0h,0f0h,0f0h,0b0h,0e0h	; 59f0  .~..q.....<.....
	defb 006h,000h,000h,000h,000h,003h,000h,03ch,060h,040h,040h,000h,000h,000h,000h,000h	; 5a00  .......<`@@.....
	defb 0e0h,0a0h,0e0h,000h,000h,0c0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5a10  ................
	defb 000h,01fh,03fh,03fh,00fh,000h,03fh,043h,09fh,0bfh,0bfh,0ffh,0ffh,07fh,00dh,01bh	; 5a20  ..??..?C........
	defb 000h,010h,018h,0f8h,0f0h,000h,0f0h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f0h,0c0h,0c0h	; 5a30  ................
	defb 000h,006h,000h,000h,000h,000h,003h,000h,038h,060h,040h,000h,000h,000h,000h,000h	; 5a40  ........8`@.....
	defb 000h,0e0h,0a0h,0e0h,000h,000h,0c0h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5a50  ................
	defb 000h,000h,01fh,03fh,03fh,00fh,000h,03fh,047h,09fh,0bfh,0ffh,07fh,03fh,007h,00fh	; 5a60  ...??..?G....?..
	defb 000h,000h,010h,018h,0f8h,0f0h,000h,0f0h,0f8h,0f8h,0f8h,0f8h,0f8h,0f0h,080h,080h	; 5a70  ................
	defb 007h,005h,007h,000h,000h,003h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5a80  ................
	defb 060h,000h,000h,000h,000h,0c0h,000h,03ch,006h,002h,002h,000h,000h,000h,000h,000h	; 5a90  `......<........
	defb 000h,008h,018h,01fh,00fh,000h,00fh,01fh,01fh,01fh,01fh,01fh,01fh,00fh,003h,003h	; 5aa0  ................
	defb 000h,0f8h,0fch,0fch,0f0h,000h,0fch,0c2h,0f9h,0fdh,0fdh,0ffh,0ffh,0feh,0b0h,0d8h	; 5ab0  ................
	defb 000h,007h,005h,007h,000h,000h,003h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5ac0  ................
	defb 000h,060h,000h,000h,000h,000h,0c0h,000h,01ch,006h,002h,000h,000h,000h,000h,000h	; 5ad0  .`..............
	defb 000h,000h,008h,018h,01fh,00fh,000h,00fh,01fh,01fh,01fh,01fh,01fh,00fh,001h,001h	; 5ae0  ................
	defb 000h,000h,0f8h,0fch,0fch,0f0h,000h,0fch,0e2h,0f9h,0fdh,0ffh,0feh,0fch,0e0h,0f0h	; 5af0  ................
	defb 000h,000h,03bh,02ah,03bh,000h,020h,020h,040h,040h,040h,040h,040h,000h,000h,000h	; 5b00  ..;*;.  @@@@@...
	defb 000h,000h,080h,080h,080h,000h,000h,000h,000h,000h,000h,000h,080h,000h,000h,000h	; 5b10  ................
	defb 000h,000h,000h,004h,044h,07fh,05fh,0dfh,0bfh,0bfh,0bfh,0bfh,0bfh,0ffh,07fh,01fh	; 5b20  ....D._.........
	defb 000h,000h,000h,000h,060h,0f0h,0f8h,0f8h,0fch,0fch,0fch,0feh,07eh,0feh,0fch,0f0h	; 5b30  ....`.......~...
	defb 000h,000h,00eh,00ah,00eh,000h,000h,010h,020h,020h,040h,040h,040h,000h,000h,000h	; 5b40  ........  @@@...
	defb 000h,000h,0e0h,0a0h,0e0h,000h,000h,000h,000h,000h,000h,000h,040h,000h,000h,000h	; 5b50  ............@...
	defb 000h,000h,000h,001h,011h,01fh,03fh,02fh,05fh,05fh,0bfh,0bfh,0bfh,0ffh,07fh,01fh	; 5b60  ......?/__......
	defb 000h,000h,000h,000h,010h,0f0h,0f8h,0f8h,0fch,0fch,0feh,0feh,0beh,0feh,0fch,0f0h	; 5b70  ................
	defb 000h,000h,003h,002h,003h,000h,010h,010h,020h,020h,020h,040h,040h,000h,000h,000h	; 5b80  ........   @@...
	defb 000h,000h,0b8h,0a8h,0b8h,000h,000h,000h,000h,000h,000h,000h,020h,000h,000h,000h	; 5b90  ............ ...
	defb 000h,000h,000h,000h,00ch,01fh,02fh,02fh,05fh,05fh,05fh,0bfh,0bfh,0ffh,07fh,01fh	; 5ba0  ......//___.....
	defb 000h,000h,000h,040h,044h,0fch,0fch,0feh,0feh,0feh,0feh,0feh,0deh,0feh,0fch,0f0h	; 5bb0  ...@D...........
	defb 00ch,00ah,00eh,000h,007h,003h,003h,001h,001h,001h,001h,003h,003h,007h,000h,000h	; 5bc0  ................
	defb 060h,0a0h,0e0h,000h,0c0h,080h,080h,000h,000h,000h,000h,080h,080h,0c0h,000h,000h	; 5bd0  `...............
	defb 000h,000h,011h,01fh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,01fh,01fh	; 5be0  ................
	defb 000h,000h,010h,0f0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0f0h,0f0h	; 5bf0  ................
	defb 000h,000h,006h,00ah,00eh,000h,003h,007h,00fh,00fh,007h,003h,000h,000h,000h,000h	; 5c00  ................
	defb 000h,000h,0c0h,0a0h,0e0h,000h,080h,0c0h,0e0h,0e0h,0c0h,080h,000h,000h,000h,000h	; 5c10  ................
	defb 000h,000h,000h,000h,011h,01fh,000h,000h,000h,000h,000h,000h,01fh,01fh,000h,000h	; 5c20  ................
	defb 000h,000h,000h,000h,010h,0f0h,000h,000h,000h,000h,000h,000h,0f0h,0f0h,000h,000h	; 5c30  ................
	defb 000h,001h,00fh,01fh,01fh,03fh,03fh,01eh,000h,000h,000h,000h,000h,000h,000h,000h	; 5c40  .....??.........
	defb 000h,0c0h,0e0h,0c0h,0c0h,080h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c50  ................
	defb 003h,01eh,030h,060h,060h,0c0h,0c0h,0e1h,07fh,07fh,07fh,03fh,03fh,01fh,007h,001h	; 5c60  ..0``......??...
	defb 0e0h,038h,01ch,03ch,03eh,07eh,07fh,0ffh,0ffh,0ffh,0ffh,0feh,0feh,0fch,0f8h,0e0h	; 5c70  .8.<>~..........
	defb 000h,000h,007h,00fh,00fh,01fh,01fh,03fh,03fh,01ch,000h,000h,000h,000h,000h,000h	; 5c80  .......??.......
	defb 000h,000h,0e0h,0f0h,0f0h,0e0h,0c0h,080h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c90  ................
	defb 003h,00fh,018h,030h,030h,060h,060h,040h,040h,063h,07fh,07fh,03fh,03fh,01fh,007h	; 5ca0  ...00``@@c..??..
	defb 0c0h,0f0h,018h,00ch,00ch,01eh,03eh,07eh,0ffh,0ffh,0ffh,0feh,0feh,0fch,0f0h,080h	; 5cb0  ......>~........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5cc0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5cd0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5ce0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5cf0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,054h,04fh,050h,04fh,000h,053h,04fh,046h,054h	; 5d00  .......TOPO.SOFT
	defb 000h,050h,052h,045h,053h,045h,04eh,054h,041h,06ch,000h,000h,000h,000h,000h,000h	; 5d10  .PRESENTAl......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5d20  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5d30  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,013h,014h,017h,018h,018h,018h,018h,018h	; 5d40  ................
	defb 018h,018h,018h,018h,018h,018h,019h,01ah,01bh,000h,000h,000h,000h,000h,000h,000h	; 5d50  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,015h,016h,000h,000h,000h,000h,000h,000h	; 5d60  ................
	defb 000h,000h,000h,000h,000h,000h,000h,01ch,01dh,000h,000h,000h,000h,000h,000h,000h	; 5d70  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,07ch,000h,000h,001h,002h,003h,005h,001h	; 5d80  ........|.......
	defb 007h,001h,006h,007h,008h,012h,000h,000h,07ch,000h,000h,000h,000h,000h,000h,000h	; 5d90  ........|.......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,07eh,000h,000h,009h,00ah,00bh,00ch,009h	; 5da0  ........~.......
	defb 011h,009h,00dh,00fh,010h,08eh,000h,000h,07eh,000h,000h,000h,000h,000h,000h,000h	; 5db0  ........~.......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,01ah,01bh,000h,000h,000h,000h,000h,000h	; 5dc0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,013h,014h,000h,000h,000h,000h,000h,000h,000h	; 5dd0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,01ch,01dh,017h,018h,018h,018h,018h,018h	; 5de0  ................
	defb 018h,018h,018h,018h,018h,018h,019h,015h,016h,000h,000h,000h,000h,000h,000h,000h	; 5df0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5e00  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5e10  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5e20  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5e30  ................
	defb 000h,000h,000h,000h,068h,04eh,04fh,000h,049h,04eh,054h,045h,04eh,054h,045h,053h	; 5e40  ....hNO.INTENTES
	defb 000h,050h,041h,053h,041h,052h,06bh,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5e50  .PASARk.........
	defb 000h,000h,000h,000h,000h,054h,045h,000h,044h,049h,04ah,04fh,000h,045h,04ch,000h	; 5e60  .....TE.DIJO.EL.
	defb 055h,049h,045h,04ah,04fh,000h,04dh,04fh,04eh,04ah,045h,06dh,000h,000h,000h,000h	; 5e70  UIEJO.MONJEm....
	defb 000h,000h,000h,000h,000h,050h,056h,045h,053h,000h,053h,045h,052h,045h,053h,000h	; 5e80  .....PVES.SERES.
	defb 048h,04fh,052h,052h,049h,042h,04ch,045h,053h,000h,000h,000h,000h,000h,000h,000h	; 5e90  HORRIBLES.......
	defb 000h,000h,000h,000h,000h,041h,043h,045h,043h,048h,041h,04eh,000h,045h,04eh,000h	; 5ea0  .....ACECHAN.EN.
	defb 04ch,041h,000h,04fh,053h,043h,055h,052h,049h,044h,041h,044h,06ah,000h,000h,000h	; 5eb0  LA.OSCURIDADj...
	defb 000h,000h,000h,000h,000h,04dh,041h,053h,000h,04dh,041h,04eh,054h,045h,04eh,000h	; 5ec0  .....MAS.MANTEN.
	defb 04ch,041h,000h,043h,041h,04ch,04dh,041h,000h,000h,000h,000h,000h,000h,000h,000h	; 5ed0  LA.CALMA........
	defb 000h,000h,000h,000h,000h,059h,000h,041h,04ch,000h,046h,049h,04eh,041h,04ch,000h	; 5ee0  .....Y.AL.FINAL.
	defb 044h,045h,04ch,000h,043h,041h,04dh,049h,04eh,04fh,000h,000h,000h,000h,000h,000h	; 5ef0  DEL.CAMINO......
	defb 000h,000h,000h,000h,000h,04ch,041h,000h,04ch,055h,05ah,000h,042h,052h,049h,04ch	; 5f00  .....LA.LUZ.BRIL
	defb 04ch,041h,052h,041h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5f10  LARA............
	defb 000h,000h,000h,000h,000h,044h,045h,000h,04eh,055h,045h,055h,04fh,000h,053h,04fh	; 5f20  .....DE.NUEUO.SO
	defb 042h,052h,045h,000h,054h,049h,06bh,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5f30  BRE.TIk.........
	defb 000h,000h,000h,000h,000h,050h,052h,045h,055h,041h,04ch,045h,043h,049h,045h,04eh	; 5f40  .....PREUALECIEN
	defb 044h,04fh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5f50  DO..............
	defb 000h,000h,000h,000h,000h,053h,04fh,042h,052h,045h,000h,04ch,041h,053h,000h,054h	; 5f60  .....SOBRE.LAS.T
	defb 045h,04eh,054h,041h,043h,049h,04fh,04eh,045h,053h,06ah,068h,000h,000h,000h,000h	; 5f70  ENTACIONESjh....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,06ah,000h,000h,000h,000h	; 5f80  ...........j....
	defb 000h,06ah,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5f90  .j..............
	defb 000h,04ch,055h,049h,047h,049h,04ch,04fh,050h,045h,05ah,000h,064h,064h,06dh,000h	; 5fa0  .LUIGILOPEZ.ddm.
	defb 04dh,056h,053h,049h,043h,041h,06ch,047h,04fh,04dh,049h,04eh,04fh,04ch,041h,053h	; 5fb0  MVSICAlGOMINOLAS
	defb 08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch	; 5fc0  ................
	defb 08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch	; 5fd0  ................
	defb 013h,014h,017h,018h,018h,018h,018h,018h,018h,018h,019h,01ah,01bh,08ch,08ch,08ch	; 5fe0  ................
	defb 08ch,08ch,013h,014h,017h,018h,018h,018h,018h,018h,018h,018h,018h,019h,01ah,01bh	; 5ff0  ................
	defb 015h,016h,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,01ch,01dh,017h,018h,018h	; 6000  ................
	defb 018h,019h,015h,016h,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,01ch,01dh	; 6010  ................
	defb 07ch,08ch,055h,049h,044h,041h,053h,06ch,05ch,08ch,08ch,08ch,07ch,08ch,07ch,017h	; 6020  |.UIDASl\...|.|.
	defb 019h,08ch,07ch,08ch,050h,041h,04eh,054h,041h,04ch,04ch,041h,06ch,05dh,08ch,07ch	; 6030  ..|.PANTALLAl].|
	defb 07dh,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,07dh,08ch,07eh,08ch	; 6040  }...........}.~.
	defb 07ch,08ch,07dh,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,07dh	; 6050  |.}............}
	defb 07eh,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,07eh,08ch,017h,019h	; 6060  ~...........~...
	defb 07eh,08ch,07eh,08ch,08ch,04eh,049h,055h,045h,04ch,06ch,05dh,08ch,08ch,08ch,07eh	; 6070  ~.~..NIUELl]...~
	defb 01ah,01bh,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,013h,014h,017h,018h,018h	; 6080  ................
	defb 018h,019h,01ah,01bh,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,08ch,013h,014h	; 6090  ................
	defb 01ch,01dh,017h,018h,018h,018h,018h,018h,018h,018h,019h,015h,016h,08ch,08ch,08ch	; 60a0  ................
	defb 08ch,08ch,01ch,01dh,017h,018h,018h,018h,018h,018h,018h,018h,018h,019h,015h,016h	; 60b0  ................
	defb 000h,000h,00ah,09fh,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 60c0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 60d0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 60e0  ................
	defb 000h,000h,000h,000h,000h,000h,0bdh,040h,0bdh,044h,0bdh,044h,0b9h,044h,0b9h,044h	; 60f0  .......@.D.D.D.D
	defb 0bfh,056h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h	; 6100  .V.T.T.T.T.T.T.T
	defb 0bfh,054h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bdh,044h	; 6110  .T.D.D.D.D.D.D.D
	defb 0bfh,004h,0bfh,000h,0bdh,044h,0bfh,040h,0bfh,000h,0bfh,040h,0bdh,040h,0bdh,040h	; 6120  .....D.@...@.@.@
	defb 0bdh,000h,0bdh,000h,0bch,040h,0bch,040h,0bdh,040h,088h,044h,09ch,044h,098h,0ffh	; 6130  .....@.@.@.D.D..
	defb 002h,000h,002h,09fh,002h,000h,002h,09fh,002h,000h,004h,09fh,002h,000h,004h,09fh	; 6140  ................
	defb 080h,044h,0ffh,040h,0ffh,042h,0bfh,042h,0ffh,044h,0ffh,040h,0bfh,040h,0bfh,040h	; 6150  .D.@.B.B.D.@.@.@
	defb 0ffh,000h,0ffh,040h,0bfh,040h,0bfh,040h,0f9h,000h,0b9h,040h,0bbh,040h,0bbh,040h	; 6160  ...@.@.@...@.@.@
	defb 0b9h,040h,0b9h,040h,0b9h,040h,0b9h,040h,0b9h,040h,0b9h,040h,0b9h,000h,0b9h,042h	; 6170  .@.@.@.@.@.@...B
	defb 0bfh,056h,0bfh,054h,0ffh,054h,0ffh,044h,0bfh,044h,0bfh,040h,0bfh,044h,0bfh,040h	; 6180  .V.T.T.D.D.@.D.@
	defb 0ffh,044h,0bfh,040h,0bfh,044h,0bfh,040h,0bfh,040h,0bfh,040h,0bfh,040h,0bfh,040h	; 6190  .D.@.D.@.@.@.@.@
	defb 0ffh,000h,0fbh,000h,0ffh,040h,0ffh,000h,0bfh,000h,0bfh,000h,0ffh,000h,09fh,040h	; 61a0  .....@.........@
	defb 0b9h,000h,0b9h,000h,099h,040h,09dh,040h,0b9h,040h,089h,000h,099h,040h,099h,0ffh	; 61b0  .....@.@.@...@..
	defb 0feh,000h,006h,09fh,0feh,000h,006h,09fh,0feh,000h,008h,09fh,0feh,000h,008h,09fh	; 61c0  ................
	defb 080h,054h,0bfh,044h,0bfh,054h,0bfh,046h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,040h	; 61d0  .T.D.T.F.D.D.D.@
	defb 0bfh,040h,0bfh,040h,0bfh,040h,0bfh,040h,0bdh,040h,0bdh,040h,0bfh,040h,0b9h,040h	; 61e0  .@.@.@.@.@.@.@.@
	defb 0bdh,040h,099h,040h,0b9h,040h,0b9h,040h,0b9h,040h,099h,040h,0b9h,000h,098h,044h	; 61f0  .@.@.@.@.@.@...D
	defb 0bfh,056h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,044h	; 6200  .V.T.T.T.T.T.T.D
	defb 0bfh,054h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,040h,0bfh,040h,0bfh,044h,09dh,040h	; 6210  .T.D.D.D.@.@.D.@
	defb 0bfh,000h,0bfh,000h,09fh,040h,09fh,040h,0bfh,000h,0bfh,000h,09fh,000h,09eh,040h	; 6220  .....@.@.......@
	defb 0b9h,000h,098h,000h,09ch,040h,09ch,040h,099h,000h,088h,000h,098h,040h,098h,0ffh	; 6230  .....@.@.....@..
	defb 002h,000h,00ch,09fh,002h,001h,00ch,09fh,002h,001h,00ch,09fh,002h,001h,00ch,09fh	; 6240  ................
	defb 002h,002h,00ch,09fh,002h,004h,00ch,09fh,001h,003h,00ch,09fh,001h,004h,00ch,09fh	; 6250  ................
	defb 001h,004h,00ch,09fh,001h,004h,00ch,09fh,080h,003h,00ch,09fh,002h,003h,00ch,09fh	; 6260  ................
	defb 002h,003h,00ch,09fh,002h,004h,00ch,09fh,002h,004h,00ch,09fh,002h,004h,00ch,09fh	; 6270  ................
	defb 080h,056h,0bfh,056h,0bfh,054h,0ffh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h	; 6280  .V.V.T.D.D.D.D.D
	defb 0ffh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,000h,0bfh,040h,0bfh,044h,0bfh,040h	; 6290  .D.D.D.D...@.D.@
	defb 0ffh,000h,0bfh,000h,0ffh,000h,0ffh,000h,0bfh,000h,0bfh,000h,0ffh,000h,09eh,000h	; 62a0  ................
	defb 0bdh,000h,0b9h,000h,09ch,040h,09ch,000h,09dh,000h,088h,000h,098h,040h,09ah,0ffh	; 62b0  .....@.......@..
	defb 0feh,000h,00eh,09fh,0feh,001h,00eh,09fh,0feh,001h,00eh,09fh,0feh,001h,00eh,09fh	; 62c0  ................
	defb 0feh,002h,00eh,09fh,0feh,004h,00eh,09fh,0ffh,003h,00eh,09fh,0ffh,004h,00eh,09fh	; 62d0  ................
	defb 0ffh,004h,00eh,09fh,0ffh,004h,00eh,09fh,080h,003h,00eh,09fh,0feh,003h,00eh,09fh	; 62e0  ................
	defb 0feh,003h,00eh,09fh,0feh,004h,00eh,09fh,0feh,004h,00eh,09fh,0feh,004h,00eh,09fh	; 62f0  ................
	defb 080h,056h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,014h,0bfh,014h,0bfh,054h,0bfh,044h	; 6300  .V.T.T.T.....T.D
	defb 0bfh,054h,0bbh,004h,0bfh,044h,0bdh,044h,0bbh,000h,0bfh,000h,0bfh,040h,09dh,000h	; 6310  .T...D.D.....@..
	defb 0bfh,000h,0bbh,000h,0bdh,000h,0bdh,000h,0bdh,000h,0b9h,000h,0bdh,000h,09dh,000h	; 6320  ................
	defb 0b9h,000h,099h,000h,098h,000h,09dh,000h,099h,000h,088h,000h,098h,000h,098h,0ffh	; 6330  ................
	defb 001h,004h,00ch,09fh,001h,004h,00ch,09fh,080h,056h,0ffh,046h,0bfh,076h,0bfh,046h	; 6340  .........V.F.v.F
	defb 0ffh,046h,0ffh,046h,0ffh,046h,0bfh,046h,0efh,046h,0bfh,046h,0bfh,002h,0bfh,002h	; 6350  .F.F.F.F.F.F....
	defb 0bfh,000h,0bfh,040h,0bfh,042h,0bfh,042h,0bfh,000h,0bfh,040h,0bfh,002h,0bfh,042h	; 6360  ...@.B.B...@...B
	defb 0bfh,040h,0bfh,040h,0bfh,042h,0bbh,002h,0bfh,042h,0bbh,000h,0bbh,002h,0abh,042h	; 6370  .@.@.B...B.....B
	defb 0bfh,076h,0bfh,046h,0bfh,046h,0bfh,046h,0bfh,046h,0bfh,046h,0bfh,046h,0bfh,046h	; 6380  .v.F.F.F.F.F.F.F
	defb 0bfh,046h,0bfh,046h,0bfh,044h,0bfh,044h,0bfh,002h,0bfh,042h,0bfh,044h,0bfh,040h	; 6390  .F.F.D.D...B.D.@
	defb 0bfh,002h,0bfh,002h,0ffh,000h,0ffh,000h,0bfh,002h,0bfh,000h,0bfh,000h,0bfh,000h	; 63a0  ................
	defb 0bfh,002h,0abh,002h,0aeh,000h,0afh,000h,0afh,000h,0aah,002h,0aah,040h,0aah,0ffh	; 63b0  .............@..
	defb 0ffh,004h,00eh,09fh,0ffh,004h,00eh,09fh,080h,054h,0bfh,054h,0bfh,054h,0bfh,054h	; 63c0  .........T.T.T.T
	defb 0bfh,044h,0bfh,044h,0bfh,054h,0bfh,044h,0bfh,044h,0bdh,044h,0bfh,004h,0bfh,000h	; 63d0  .D.D.T.D.D.D....
	defb 0bdh,000h,0bfh,040h,0bfh,040h,0bfh,040h,0bdh,000h,0bdh,040h,0bdh,040h,0bdh,040h	; 63e0  ...@.@.@...@.@.@
	defb 0bdh,040h,0b9h,040h,0bdh,040h,0b9h,000h,0b9h,040h,0b9h,000h,0b9h,000h,0b9h,044h	; 63f0  .@.@.@...@.....D
	defb 0bfh,056h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h	; 6400  .V.T.T.T.D.D.D.D
	defb 0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,000h,0bfh,040h,0bfh,044h,0bdh,040h	; 6410  .D.D.D.D...@.D.@
	defb 0bfh,000h,0bfh,000h,0bdh,000h,0bfh,000h,0bfh,000h,0bfh,000h,0bfh,000h,09dh,040h	; 6420  ...............@
	defb 0bdh,000h,0b9h,000h,09ch,040h,09ch,000h,099h,000h,088h,000h,088h,040h,088h,0ffh	; 6430  .....@.......@..
	defb 000h,000h,010h,09fh,000h,001h,010h,09fh,000h,001h,010h,09fh,000h,002h,010h,09fh	; 6440  ................
	defb 000h,002h,010h,09fh,000h,003h,010h,09fh,000h,003h,010h,09fh,000h,004h,010h,09fh	; 6450  ................
	defb 000h,004h,010h,09fh,000h,004h,010h,09fh,080h,003h,010h,09fh,000h,003h,010h,09fh	; 6460  ................
	defb 000h,003h,010h,09fh,000h,004h,010h,09fh,000h,004h,010h,09fh,000h,004h,010h,09fh	; 6470  ................
	defb 080h,004h,010h,09fh,000h,004h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h	; 6480  .......T.T.T.T.T
	defb 0ffh,054h,0bfh,054h,0bfh,054h,0bfh,044h,0bfh,050h,0bfh,040h,0bfh,040h,0bdh,040h	; 6490  .T.T.T.D.P.@.@.@
	defb 0ffh,000h,0bfh,000h,0bfh,000h,0ffh,000h,0bfh,000h,0bfh,000h,0bfh,000h,0bfh,000h	; 64a0  ................
	defb 0bdh,000h,0bdh,000h,09ch,000h,0bch,000h,0bdh,000h,098h,000h,098h,040h,098h,0ffh	; 64b0  .............@..
	defb 000h,0fch,010h,09fh,000h,0fch,010h,09fh,000h,0fch,010h,09fh,000h,0fdh,010h,09fh	; 64c0  ................
	defb 000h,0fdh,010h,09fh,000h,0feh,010h,09fh,000h,0feh,010h,09fh,000h,0ffh,010h,09fh	; 64d0  ................
	defb 000h,0ffh,010h,09fh,000h,000h,010h,09fh,080h,000h,010h,09fh,080h,0ffh,010h,09fh	; 64e0  ................
	defb 000h,0ffh,010h,09fh,000h,000h,010h,09fh,000h,000h,010h,09fh,000h,000h,010h,09fh	; 64f0  ................
	defb 080h,056h,0bfh,056h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h	; 6500  .V.V.T.T.T.T.T.T
	defb 0bfh,054h,0bfh,054h,0bfh,054h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h,09fh,044h	; 6510  .T.T.T.D.D.D.D.D
	defb 0bfh,004h,0bfh,000h,09eh,040h,09fh,040h,0beh,000h,0bfh,040h,09fh,040h,09eh,040h	; 6520  .....@.@...@.@.@
	defb 0bfh,000h,098h,000h,09ch,040h,09ch,040h,09dh,040h,09ah,042h,098h,044h,09ah,0feh	; 6530  .....@.@.@.B.D..
	defb 001h,0fch,00ch,09fh,001h,0fch,00ch,09fh,001h,0fch,00ch,09fh,001h,0fdh,00ch,09fh	; 6540  ................
	defb 002h,0fch,00ch,09fh,002h,0feh,00ch,09fh,002h,0ffh,00ch,09fh,002h,0ffh,00ch,09fh	; 6550  ................
	defb 002h,0ffh,00ch,09fh,002h,000h,00ch,09fh,080h,0ffh,00ch,09fh,002h,0ffh,00ch,09fh	; 6560  ................
	defb 002h,0ffh,00ch,09fh,002h,000h,00ch,09fh,002h,000h,00ch,09fh,002h,000h,00ch,09fh	; 6570  ................
	defb 080h,056h,0bfh,052h,0bfh,042h,0bbh,040h,0bbh,042h,0bfh,040h,0bfh,040h,0bbh,040h	; 6580  .V.R.B.@.B.@.@.@
	defb 0ffh,042h,0bbh,042h,0bbh,040h,0bbh,040h,0bbh,002h,0bbh,040h,0bfh,040h,0bfh,040h	; 6590  .B.B.@.@...@.@.@
	defb 0bfh,002h,0bbh,000h,0bfh,000h,0bfh,000h,0bbh,000h,0bbh,000h,0bfh,000h,0bah,000h	; 65a0  ................
	defb 0bbh,002h,0abh,002h,0a8h,000h,0a8h,000h,0abh,000h,0aah,002h,088h,040h,08ah,0ffh	; 65b0  .............@..
	defb 0ffh,0fch,00eh,09fh,0ffh,0fch,00eh,09fh,0ffh,0fch,00eh,09fh,0ffh,0fdh,00eh,09fh	; 65c0  ................
	defb 0feh,0fch,00eh,09fh,0feh,0feh,00eh,09fh,0feh,0ffh,00eh,09fh,0feh,0ffh,00eh,09fh	; 65d0  ................
	defb 0feh,0ffh,00eh,09fh,0feh,000h,00eh,09fh,080h,0ffh,00eh,09fh,0feh,0ffh,00eh,09fh	; 65e0  ................
	defb 0feh,0ffh,00eh,09fh,0feh,000h,00eh,09fh,0feh,000h,00eh,09fh,0feh,000h,00eh,09fh	; 65f0  ................
	defb 080h,056h,0bfh,054h,0ffh,054h,0ffh,054h,0bfh,044h,0bfh,040h,0ffh,044h,0ffh,044h	; 6600  .V.T.T.T.D.@.D.D
	defb 0ffh,044h,0bbh,040h,0ffh,044h,0ffh,040h,0bfh,040h,0bfh,040h,0bfh,040h,0fdh,040h	; 6610  .D.@.D.@.@.@.@.@
	defb 0ffh,040h,0fbh,040h,0fdh,040h,0ffh,040h,0bdh,040h,0ffh,040h,0fdh,040h,09dh,040h	; 6620  .@.@.@.@.@.@.@.@
	defb 0b9h,040h,0b9h,040h,098h,040h,09ch,040h,0b9h,040h,088h,040h,098h,040h,098h,0ffh	; 6630  .@.@.@.@.@.@.@..
	defb 000h,000h,01ah,09fh,000h,000h,01ah,09fh,000h,000h,01ch,09fh,000h,000h,01ch,09fh	; 6640  ................
	defb 080h,054h,0ffh,044h,0ffh,056h,0bfh,056h,0ffh,044h,0bfh,044h,0bfh,004h,0bfh,000h	; 6650  .T.D.V.V.D.D....
	defb 0bfh,000h,0bfh,040h,0bfh,040h,0bfh,040h,0bfh,000h,0bfh,040h,0bfh,040h,0bfh,040h	; 6660  ...@.@.@...@.@.@
	defb 0bdh,040h,0bfh,040h,0bfh,040h,0b9h,042h,0bbh,040h,0b9h,000h,0bbh,000h,0b8h,042h	; 6670  .@.@.@.B.@.....B
	defb 0bfh,056h,0bfh,056h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h	; 6680  .V.V.T.T.T.T.T.T
	defb 0ffh,056h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,040h,0bfh,040h,0bfh,044h,0bfh,040h	; 6690  .V.D.D.D.@.@.D.@
	defb 0ffh,000h,0bfh,000h,0ffh,000h,0bfh,000h,0bfh,000h,0bfh,000h,0bfh,000h,0bfh,000h	; 66a0  ................
	defb 0bfh,000h,0bbh,000h,09ch,040h,09ch,000h,0bfh,000h,09ah,002h,098h,040h,09ah,0f7h	; 66b0  .....@.......@..
	defb 000h,000h,01eh,09fh,000h,000h,01eh,09fh,000h,000h,020h,09fh,000h,000h,020h,09fh	; 66c0  .......... ... .
	defb 080h,054h,0ffh,044h,0ffh,056h,0bfh,056h,0ffh,044h,0ffh,054h,0bfh,056h,0bfh,054h	; 66d0  .T.D.V.V.D.T.V.T
	defb 0ffh,040h,0ffh,044h,0bfh,044h,0bfh,044h,0ffh,040h,0bfh,044h,0bfh,044h,0bfh,040h	; 66e0  .@.D.D.D.@.D.D.@
	defb 0bfh,040h,0bfh,040h,0bfh,040h,0bdh,040h,0bfh,040h,0bfh,044h,0bbh,044h,0b9h,056h	; 66f0  .@.@.@.@.@.D.D.V
	defb 0bfh,056h,0bfh,056h,0ffh,054h,0ffh,054h,0bfh,054h,0bfh,054h,0ffh,054h,0ffh,054h	; 6700  .V.V.T.T.T.T.T.T
	defb 0ffh,054h,0bfh,054h,0ffh,054h,0ffh,044h,0bfh,044h,0bfh,044h,0ffh,044h,0ffh,044h	; 6710  .T.T.T.D.D.D.D.D
	defb 0ffh,044h,0ffh,040h,0ffh,044h,0ffh,040h,0ffh,000h,0ffh,040h,0ffh,040h,0dfh,040h	; 6720  .D.@.D.@...@.@.@
	defb 0bfh,040h,0bfh,040h,09eh,040h,09ch,040h,0bfh,040h,09ah,046h,098h,044h,09ah,0f7h	; 6730  .@.@.@.@.@.F.D..
	defb 000h,000h,012h,0afh,000h,000h,014h,0afh,000h,000h,012h,0afh,000h,000h,014h,0afh	; 6740  ................
	defb 000h,000h,016h,0a9h,000h,000h,014h,0afh,000h,000h,016h,0a9h,000h,000h,018h,068h	; 6750  ...............h
	defb 000h,000h,016h,0a9h,000h,000h,018h,068h,080h,000h,0bdh,040h,0bfh,040h,0bfh,040h	; 6760  .......h...@.@.@
	defb 0bdh,040h,0b9h,040h,0bdh,040h,0b9h,040h,0b9h,040h,0b9h,000h,0b9h,000h,0b9h,050h	; 6770  .@.@.@.@.@.....P
	defb 0bfh,056h,0bfh,054h,0bfh,054h,0ffh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h	; 6780  .V.T.T.T.T.T.T.T
	defb 0ffh,054h,0bfh,054h,0bfh,054h,0bfh,044h,0bfh,000h,0bfh,040h,0bfh,040h,0bdh,040h	; 6790  .T.T.T.D...@.@.@
	defb 0ffh,000h,0bfh,000h,0ffh,000h,0ffh,000h,0bfh,000h,0bfh,000h,0ffh,000h,0bfh,000h	; 67a0  ................
	defb 0bdh,000h,0b9h,000h,09ch,040h,09ch,000h,0b9h,000h,098h,000h,098h,040h,09ah,0ffh	; 67b0  .....@.......@..
	defb 0fch,001h,01eh,07fh,0fch,002h,01eh,07fh,0feh,004h,020h,07fh,0ffh,005h,020h,07fh	; 67c0  .......... ... .
	defb 001h,004h,01eh,07fh,002h,004h,01eh,07fh,004h,002h,020h,07fh,005h,001h,020h,07fh	; 67d0  .......... ... .
	defb 004h,0ffh,01eh,07fh,004h,0feh,01eh,07fh,002h,0fch,020h,07fh,001h,0fbh,020h,07fh	; 67e0  .......... ... .
	defb 0ffh,0fch,01eh,07fh,0feh,0fch,01eh,07fh,0fch,0feh,020h,07fh,0fbh,0ffh,020h,07fh	; 67f0  .......... ... .
	defb 080h,056h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h	; 6800  .V.T.T.T.D.D.D.D
	defb 0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,040h,0bfh,040h,0bfh,044h,0bdh,040h	; 6810  .D.D.D.D.@.@.D.@
	defb 0bfh,000h,0bfh,000h,0bfh,040h,0bfh,040h,0bfh,000h,0bfh,000h,0bfh,000h,0bfh,040h	; 6820  .....@.@.......@
	defb 0bdh,000h,0b9h,000h,09dh,040h,09dh,040h,0b9h,000h,089h,000h,098h,040h,099h,0ffh	; 6830  .....@.@.....@..
	defb 0feh,056h,0dfh,0d6h,0feh,076h,0bfh,076h,0ffh,056h,0ffh,056h,0ffh,056h,0bfh,056h	; 6840  .V...v.v.V.V.V.V
	defb 0ffh,054h,0ffh,044h,0ffh,056h,0bfh,056h,0ffh,044h,0ffh,044h,0bfh,052h,0ffh,052h	; 6850  .T.D.V.V.D.D.R.R
	defb 0ffh,040h,0ffh,040h,0bfh,040h,0bfh,040h,0ffh,040h,0bfh,040h,0bfh,040h,0bfh,040h	; 6860  .@.@.@.@.@.@.@.@
	defb 0bfh,040h,0bfh,040h,0bfh,040h,0bfh,042h,0bfh,040h,0bbh,040h,0bbh,000h,0b9h,046h	; 6870  .@.@.@.B.@.@...F
	defb 0bfh,056h,0bfh,056h,0ffh,054h,0ffh,054h,0bfh,056h,0bfh,054h,0ffh,054h,0ffh,054h	; 6880  .V.V.T.T.V.T.T.T
	defb 0ffh,056h,0ffh,056h,0ffh,054h,0ffh,044h,0ffh,042h,0bfh,040h,0bfh,040h,0ffh,040h	; 6890  .V.V.T.D.B.@.@.@
	defb 0ffh,002h,0ffh,002h,0ffh,040h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,040h	; 68a0  .....@.........@
	defb 0bfh,002h,0bbh,000h,0beh,040h,0bdh,040h,0bbh,040h,0bah,002h,09ah,040h,09ah,0ffh	; 68b0  .....@.@.@...@..
	defb 000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh	; 68c0  ..*...*...*...*.
	defb 000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh	; 68d0  ..*...*...*...*.
	defb 000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh	; 68e0  ..*...*...*...*.
	defb 000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,002h,02ah,07fh	; 68f0  ..*...*...*...*.
	defb 000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh	; 6900  ..*...*...*...*.
	defb 000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh	; 6910  ..*...*...*...*.
	defb 000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh	; 6920  ..*...*...*...*.
	defb 000h,002h,02ah,07fh,000h,002h,02ah,07fh,080h,002h,02ah,07fh,080h,002h,02ah,07fh	; 6930  ..*...*...*...*.
	defb 0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh	; 6940  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh	; 6950  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh	; 6960  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh	; 6970  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh	; 6980  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh	; 6990  ..:...:...:...:.
	defb 000h,000h,03ch,0dfh,000h,000h,03ch,0dfh,000h,000h,03eh,0dfh,000h,000h,03eh,0dfh	; 69a0  ..<...<...>...>.
	defb 030h,000h,03ah,0dfh,080h,040h,0fch,040h,0fbh,040h,0cah,040h,0d8h,040h,09ah,0ffh	; 69b0  0.:..@.@.@.@.@..
	defb 0feh,0f8h,02ch,08fh,0feh,0f9h,02ch,08fh,0feh,0fch,02ch,08fh,0feh,0feh,02ch,08fh	; 69c0  ..,...,...,...,.
	defb 0feh,0ffh,02ch,08fh,0feh,0ffh,02ch,08fh,0feh,0ffh,02ch,08fh,0feh,000h,02ch,08fh	; 69d0  ..,...,...,...,.
	defb 0feh,000h,02ch,08fh,0feh,001h,02ch,08fh,0feh,001h,02ch,08fh,0feh,001h,02ch,08fh	; 69e0  ..,...,...,...,.
	defb 0feh,002h,02ch,08fh,0feh,004h,02ch,08fh,0feh,007h,02ch,08fh,0feh,008h,02ch,08fh	; 69f0  ..,...,...,...,.
	defb 000h,0f8h,02eh,08fh,000h,0f9h,02eh,08fh,000h,0fch,02ch,08fh,000h,0feh,02ch,08fh	; 6a00  ..........,...,.
	defb 000h,0ffh,02eh,08fh,000h,0ffh,02eh,08fh,000h,000h,02ch,08fh,000h,000h,02ch,08fh	; 6a10  ..........,...,.
	defb 000h,001h,02eh,08fh,000h,001h,02eh,08fh,000h,002h,02ch,08fh,000h,004h,02ch,08fh	; 6a20  ..........,...,.
	defb 000h,007h,02eh,08fh,000h,008h,02eh,08fh,080h,040h,098h,040h,098h,040h,0b8h,0ffh	; 6a30  .........@.@.@..
	defb 0feh,000h,02ch,05fh,0feh,000h,02ch,05fh,0feh,000h,02eh,05fh,0feh,000h,02eh,05fh	; 6a40  ..,_..,_..._..._
	defb 080h,054h,0ffh,044h,0ffh,056h,0bfh,056h,0ffh,044h,0bfh,054h,0bfh,016h,0bfh,016h	; 6a50  .T.D.V.V.D.T....
	defb 0bfh,000h,0ffh,044h,0bfh,044h,0bfh,044h,0bfh,000h,0bfh,040h,0bfh,040h,0bfh,040h	; 6a60  ...D.D.D...@.@.@
	defb 0bdh,040h,0bfh,040h,0bfh,040h,0bdh,040h,0bdh,040h,0bdh,004h,0bbh,004h,0b9h,016h	; 6a70  .@.@.@.@.@......
	defb 0bfh,056h,0bfh,056h,0bfh,054h,0ffh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h	; 6a80  .V.V.T.T.T.T.T.T
	defb 0ffh,056h,0bfh,054h,0bfh,054h,0bfh,044h,0bfh,004h,0bfh,044h,0bfh,044h,0bfh,044h	; 6a90  .V.T.T.D...D.D.D
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0bfh,000h,0bfh,000h,0ffh,000h,09fh,000h	; 6aa0  ................
	defb 0bfh,000h,0bdh,000h,09eh,040h,09ch,000h,0bdh,000h,098h,002h,098h,044h,09ah,0ffh	; 6ab0  .....@.......D..
	defb 0feh,002h,034h,07fh,0feh,002h,038h,07fh,0feh,001h,036h,07fh,0feh,001h,038h,07fh	; 6ac0  ..4...8...6...8.
	defb 0feh,001h,034h,07fh,0feh,001h,038h,07fh,0feh,000h,036h,07fh,0feh,000h,038h,07fh	; 6ad0  ..4...8...6...8.
	defb 0feh,000h,034h,07fh,0feh,000h,038h,07fh,0feh,0ffh,036h,07fh,0feh,0ffh,038h,07fh	; 6ae0  ..4...8...6...8.
	defb 0feh,0ffh,034h,07fh,0feh,0ffh,038h,07fh,0feh,0feh,036h,07fh,0feh,0feh,038h,07fh	; 6af0  ..4...8...6...8.
	defb 080h,056h,0bfh,054h,09fh,054h,0dfh,054h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h	; 6b00  .V.T.T.T.D.D.D.D
	defb 0bfh,054h,0bfh,044h,09fh,044h,0bfh,044h,0bfh,040h,0bfh,040h,0bfh,044h,09fh,040h	; 6b10  .T.D.D.D.@.@.D.@
	defb 0ffh,000h,0bfh,000h,09fh,040h,0dfh,040h,0bfh,000h,0bfh,000h,09fh,000h,09fh,040h	; 6b20  .....@.@.......@
	defb 09dh,000h,099h,000h,09ch,040h,09dh,040h,099h,040h,088h,040h,098h,040h,098h,0f7h	; 6b30  .....@.@.@.@.@..
	defb 0feh,0feh,034h,07fh,0feh,0feh,038h,07fh,0feh,0ffh,036h,07fh,0feh,0ffh,038h,07fh	; 6b40  ..4...8...6...8.
	defb 0feh,0ffh,034h,07fh,0feh,0ffh,038h,07fh,0feh,000h,036h,07fh,0feh,000h,038h,07fh	; 6b50  ..4...8...6...8.
	defb 0feh,000h,034h,07fh,0feh,000h,038h,07fh,0feh,001h,036h,07fh,0feh,001h,038h,07fh	; 6b60  ..4...8...6...8.
	defb 0feh,001h,034h,07fh,0feh,001h,038h,07fh,0feh,002h,036h,07fh,0feh,002h,038h,07fh	; 6b70  ..4...8...6...8.
	defb 080h,046h,0bfh,044h,0ffh,044h,0ffh,044h,0bfh,044h,0bfh,040h,0ffh,044h,0ffh,040h	; 6b80  .F.D.D.D.D.@.D.@
	defb 0ffh,044h,0fbh,040h,0fbh,040h,0ffh,040h,0fbh,040h,0bbh,040h,0bfh,040h,0fdh,040h	; 6b90  .D.@.@.@.@.@.@.@
	defb 0ffh,000h,0fbh,000h,0fdh,040h,0fdh,000h,0fdh,000h,0f9h,000h,0fdh,000h,0edh,040h	; 6ba0  .....@.........@
	defb 0a9h,000h,0a9h,000h,089h,040h,089h,040h,0a9h,040h,088h,000h,088h,040h,088h,0ffh	; 6bb0  .....@.@.@...@..
	defb 0feh,000h,022h,0cfh,0feh,000h,022h,0cfh,0feh,0ffh,024h,0cfh,0feh,0ffh,024h,0cfh	; 6bc0  .."..."...$...$.
	defb 0feh,000h,022h,0cfh,0feh,000h,022h,0cfh,0feh,001h,024h,0cfh,0feh,001h,024h,0cfh	; 6bd0  .."..."...$...$.
	defb 080h,040h,0ffh,044h,0ffh,040h,0bfh,044h,0fdh,040h,0fdh,040h,0bdh,044h,0bdh,040h	; 6be0  .@.D.@.D.@.@.D.@
	defb 0fdh,040h,0bdh,040h,0bdh,040h,0bdh,040h,0bdh,040h,0b9h,044h,0b9h,044h,0b8h,044h	; 6bf0  .@.@.@.@.@.D.D.D
	defb 0ffh,056h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,044h,0ffh,044h,0ffh,044h,0ffh,044h	; 6c00  .V.T.T.T.D.D.D.D
	defb 0ffh,044h,0ffh,044h,0ffh,044h,0ffh,044h,0ffh,044h,0ffh,044h,0ffh,044h,0fdh,044h	; 6c10  .D.D.D.D.D.D.D.D
	defb 0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0deh,040h	; 6c20  .@.@.@.@.@.@.@.@
	defb 0fdh,040h,0bdh,040h,0dch,040h,09ch,040h,09dh,040h,088h,040h,088h,044h,098h,0ffh	; 6c30  .@.@.@.@.@.@.D..
	defb 000h,0ffh,022h,06fh,000h,0ffh,024h,06fh,000h,0ffh,022h,06fh,000h,0ffh,024h,06fh	; 6c40  .."o..$o.."o..$o
	defb 000h,0feh,022h,06fh,000h,0feh,024h,06fh,000h,0feh,022h,06fh,000h,0feh,024h,06fh	; 6c50  .."o..$o.."o..$o
	defb 000h,0feh,022h,06fh,000h,0feh,024h,06fh,000h,0ffh,024h,06fh,000h,0ffh,022h,06fh	; 6c60  .."o..$o..$o.."o
	defb 000h,0ffh,022h,06fh,000h,000h,024h,06fh,000h,000h,024h,06fh,000h,001h,024h,06fh	; 6c70  .."o..$o..$o..$o
	defb 000h,001h,024h,06fh,000h,001h,024h,06fh,000h,001h,024h,06fh,000h,002h,024h,06fh	; 6c80  ..$o..$o..$o..$o
	defb 000h,002h,024h,06fh,000h,002h,024h,06fh,000h,002h,024h,06fh,000h,002h,024h,06fh	; 6c90  ..$o..$o..$o..$o
	defb 000h,002h,022h,06fh,000h,001h,022h,06fh,000h,001h,024h,06fh,000h,001h,022h,06fh	; 6ca0  .."o.."o..$o.."o
	defb 000h,000h,024h,06fh,000h,000h,022h,06fh,000h,000h,024h,06fh,080h,044h,09bh,0f7h	; 6cb0  ..$o.."o..$o.D..
	defb 0feh,000h,02ah,07fh,080h,076h,0bfh,076h,0ffh,056h,0ffh,054h,0bfh,056h,0bfh,056h	; 6cc0  ..*..v.v.V.T.V.V
	defb 0ffh,054h,0ffh,054h,0bfh,056h,0bfh,056h,0ffh,044h,0bfh,054h,0bfh,050h,0bfh,050h	; 6cd0  .T.T.V.V.D.T.P.P
	defb 0bfh,040h,0bfh,040h,0bfh,040h,0bfh,050h,0bdh,040h,0bdh,040h,0bbh,040h,0b9h,040h	; 6ce0  .@.@.@.P.@.@.@.@
	defb 0bdh,040h,0b9h,040h,0b9h,040h,0b9h,040h,0b9h,040h,0b9h,040h,0b9h,000h,0b8h,052h	; 6cf0  .@.@.@.@.@.@...R
	defb 0bfh,056h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,054h	; 6d00  .V.T.T.T.T.T.T.T
	defb 0ffh,054h,0bfh,054h,0bfh,054h,0bfh,044h,0bfh,050h,0bfh,050h,0bfh,044h,0bfh,040h	; 6d10  .T.T.T.D.P.P.D.@
	defb 0bfh,000h,0bfh,000h,0feh,040h,0bfh,000h,0beh,000h,0bfh,000h,0bfh,000h,0beh,040h	; 6d20  .....@.........@
	defb 0b8h,000h,0b8h,000h,09ch,040h,09ch,040h,0b9h,040h,098h,000h,098h,040h,098h,0ffh	; 6d30  .....@.@.@...@..
	defb 0feh,0feh,03ah,05fh,0feh,0feh,038h,05fh,0feh,0feh,038h,05fh,0feh,0feh,038h,05fh	; 6d40  ..:_..8_..8_..8_
	defb 0feh,0feh,038h,05fh,0feh,0feh,038h,05fh,0feh,0feh,038h,05fh,0feh,0feh,038h,05fh	; 6d50  ..8_..8_..8_..8_
	defb 0feh,0feh,038h,05fh,0feh,0feh,038h,05fh,0feh,0feh,038h,05fh,0feh,0feh,03ah,05fh	; 6d60  ..8_..8_..8_..:_
	defb 0feh,000h,03ah,05fh,0feh,002h,03ah,05fh,0feh,002h,038h,05fh,0feh,002h,038h,05fh	; 6d70  ..:_..:_..8_..8_
	defb 0feh,002h,038h,05fh,0feh,002h,038h,05fh,0feh,002h,038h,05fh,0feh,002h,038h,05fh	; 6d80  ..8_..8_..8_..8_
	defb 0feh,002h,038h,05fh,0feh,002h,038h,05fh,0feh,002h,038h,05fh,0feh,002h,038h,05fh	; 6d90  ..8_..8_..8_..8_
	defb 0feh,002h,03ah,05fh,0feh,000h,03ah,05fh,080h,040h,0ffh,040h,0ffh,040h,0ffh,040h	; 6da0  ..:_..:_.@.@.@.@
	defb 0fbh,040h,0f9h,040h,0f8h,040h,0fdh,040h,0f9h,040h,0f8h,040h,0d8h,040h,0b8h,0ffh	; 6db0  .@.@.@.@.@.@.@..
	defb 0feh,000h,02ah,02fh,0feh,000h,02ch,02fh,0feh,000h,02ah,03fh,0feh,000h,02ch,03fh	; 6dc0  ..*/..,/..*?..,?
	defb 080h,054h,0ffh,044h,0ffh,056h,0bfh,054h,0ffh,044h,0ffh,044h,0bfh,044h,0bfh,040h	; 6dd0  .T.D.V.T.D.D.D.@
	defb 0ffh,040h,0ffh,040h,0bfh,040h,0bfh,040h,0ffh,040h,0bdh,040h,0bfh,040h,0bdh,040h	; 6de0  .@.@.@.@.@.@.@.@
	defb 0bdh,040h,0bfh,040h,0bdh,040h,0b9h,040h,0bdh,040h,0b9h,040h,0b9h,040h,0b9h,042h	; 6df0  .@.@.@.@.@.@.@.B
	defb 0bfh,056h,0bfh,054h,0ffh,054h,0ffh,054h,0bfh,044h,0bfh,054h,0ffh,054h,0bfh,054h	; 6e00  .V.T.T.T.D.T.T.T
	defb 0ffh,054h,0bfh,044h,0bfh,044h,0ffh,044h,0bfh,040h,0bfh,040h,0bfh,044h,0bfh,040h	; 6e10  .T.D.D.D.@.@.D.@
	defb 0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0bfh,000h,0bfh,040h,0ffh,000h,09fh,040h	; 6e20  .@.@.@.@...@...@
	defb 0bdh,040h,0b9h,000h,09ch,040h,09ch,040h,0b9h,040h,088h,040h,098h,040h,09ah,0ffh	; 6e30  .@...@.@.@.@.@..
	defb 001h,0fch,036h,07fh,001h,0feh,036h,07fh,002h,0feh,036h,07fh,002h,002h,036h,07fh	; 6e40  ..6...6...6...6.
	defb 001h,002h,036h,07fh,001h,004h,036h,07fh,002h,000h,034h,07fh,002h,000h,032h,07fh	; 6e50  ..6...6...4...2.
	defb 002h,000h,034h,07fh,002h,000h,036h,07fh,002h,000h,034h,07fh,002h,000h,032h,07fh	; 6e60  ..4...6...4...2.
	defb 002h,000h,034h,07fh,002h,000h,036h,07fh,080h,040h,099h,040h,0bbh,000h,0b9h,052h	; 6e70  ..4...6..@.@...R
	defb 0bfh,056h,0bfh,054h,0ffh,054h,0ffh,054h,0bfh,054h,0bfh,054h,0ffh,054h,0bfh,054h	; 6e80  .V.T.T.T.T.T.T.T
	defb 0ffh,054h,0bfh,054h,0ffh,054h,0ffh,054h,0bfh,050h,0bfh,050h,0bfh,040h,0ffh,040h	; 6e90  .T.T.T.T.P.P.@.@
	defb 0ffh,010h,0ffh,000h,0ffh,000h,0ffh,000h,0bfh,000h,0bfh,000h,0ffh,000h,09fh,040h	; 6ea0  ...............@
	defb 0bfh,000h,0bdh,000h,09ch,040h,09dh,040h,099h,000h,098h,000h,098h,040h,09ah,0f7h	; 6eb0  .....@.@.....@..
	defb 001h,0fch,03ch,07fh,000h,0fch,03eh,07fh,0ffh,0fch,03eh,07fh,000h,0fch,03ch,07fh	; 6ec0  ..<...>...>...<.
	defb 0ffh,0fch,03ch,07fh,000h,0fch,03eh,07fh,001h,0fch,03ch,07fh,000h,0fch,03ch,07fh	; 6ed0  ..<...>...<...<.
	defb 001h,0fch,03eh,07fh,000h,0fch,03eh,07fh,0ffh,0fch,03ch,07fh,000h,0fch,03ch,07fh	; 6ee0  ..>...>...<...<.
	defb 000h,030h,03eh,07fh,080h,040h,0bdh,040h,0bdh,040h,099h,044h,0b9h,000h,0b9h,056h	; 6ef0  .0>..@.@.@.D...V
	defb 0bfh,056h,0bfh,054h,0bfh,054h,0bfh,054h,0bfh,044h,0bfh,054h,0bfh,054h,0bfh,044h	; 6f00  .V.T.T.T.D.T.T.D
	defb 0bfh,054h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh,044h	; 6f10  .T.D.D.D.D.D.D.D
	defb 0bfh,000h,0bfh,000h,0bfh,000h,0bfh,000h,0bfh,000h,0bfh,000h,0bfh,000h,09dh,040h	; 6f20  ...............@
	defb 0bdh,000h,0bdh,000h,09dh,040h,095h,000h,09dh,000h,081h,002h,081h,044h,091h,0f7h	; 6f30  .....@.......D..
	defb 0feh,000h,022h,0dfh,0feh,001h,022h,0dfh,0feh,000h,024h,0dfh,0feh,001h,024h,0dfh	; 6f40  .."..."...$...$.
	defb 0feh,001h,022h,0dfh,0feh,001h,022h,0dfh,0ffh,002h,024h,0dfh,0ffh,002h,024h,0dfh	; 6f50  .."..."...$...$.
	defb 000h,002h,022h,0dfh,001h,002h,022h,0dfh,001h,002h,024h,0dfh,002h,001h,024h,0dfh	; 6f60  .."..."...$...$.
	defb 002h,001h,022h,0dfh,002h,0ffh,022h,0dfh,002h,0ffh,024h,0dfh,001h,0feh,024h,0dfh	; 6f70  .."..."...$...$.
	defb 001h,0feh,022h,0dfh,000h,0feh,022h,0dfh,0ffh,0feh,024h,0dfh,0ffh,0feh,024h,0dfh	; 6f80  .."..."...$...$.
	defb 0feh,0ffh,022h,0dfh,0feh,0ffh,024h,0dfh,0feh,0ffh,024h,0dfh,0feh,000h,022h,0dfh	; 6f90  .."...$...$...".
	defb 0feh,0ffh,022h,0dfh,0feh,000h,024h,0dfh,080h,002h,0bbh,002h,0bfh,002h,0bfh,002h	; 6fa0  .."...$.........
	defb 0bbh,002h,0bbh,002h,09bh,002h,0bbh,002h,0bbh,002h,08bh,002h,09bh,000h,09bh,0ffh	; 6fb0  ................
	defb 0fch,0fch,012h,0afh,0fch,0fch,014h,0afh,0fch,0fch,016h,0a9h,0fch,0fch,014h,0afh	; 6fc0  ................
	defb 0fch,0fch,012h,0afh,0fch,0fch,014h,0afh,0fch,0fch,016h,0a9h,0fch,0fch,014h,0afh	; 6fd0  ................
	defb 0fch,004h,012h,0afh,0fch,004h,014h,0afh,0fch,004h,016h,0a9h,0fch,004h,014h,0afh	; 6fe0  ................
	defb 0fch,004h,012h,0afh,0fch,004h,014h,0afh,0fch,004h,016h,0a9h,0fch,004h,014h,0afh	; 6ff0  ................
	defb 080h,056h,0bfh,054h,0ffh,054h,0ffh,054h,0bfh,044h,0bfh,054h,0ffh,044h,0ffh,054h	; 7000  .V.T.T.T.D.T.D.T
	defb 0ffh,054h,0ffh,044h,0ffh,044h,0ffh,044h,0ffh,040h,0bfh,040h,0ffh,044h,0ffh,040h	; 7010  .T.D.D.D.@.@.D.@
	defb 0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0ffh,000h,0ffh,040h,0ffh,040h,0dfh,040h	; 7020  .@.@.@.@...@.@.@
	defb 0bfh,040h,0b9h,040h,0ddh,040h,09dh,040h,09dh,040h,088h,040h,098h,040h,09bh,0ffh	; 7030  .@.@.@.@.@.@.@..
	defb 0ffh,0f8h,038h,05fh,0ffh,0fah,038h,05fh,0ffh,0fah,038h,05fh,0ffh,0fch,038h,05fh	; 7040  ..8_..8_..8_..8_
	defb 0feh,0fch,038h,05fh,0feh,0feh,038h,05fh,0feh,0feh,038h,05fh,0feh,000h,038h,05fh	; 7050  ..8_..8_..8_..8_
	defb 0feh,000h,038h,05fh,0feh,002h,038h,05fh,0feh,002h,038h,05fh,0feh,004h,038h,05fh	; 7060  ..8_..8_..8_..8_
	defb 0ffh,004h,038h,05fh,0ffh,006h,038h,05fh,0ffh,006h,038h,05fh,0ffh,008h,038h,05fh	; 7070  ..8_..8_..8_..8_
	defb 000h,002h,03ah,05fh,000h,000h,03ah,05fh,000h,0feh,038h,05fh,080h,054h,0ffh,054h	; 7080  ..:_..:_..8_.T.T
	defb 0ffh,054h,0ffh,054h,0ffh,054h,0ffh,044h,0ffh,050h,0ffh,040h,0ffh,044h,0fdh,040h	; 7090  .T.T.T.D.P.@.D.@
	defb 0ffh,000h,0ffh,000h,0ffh,040h,0ffh,040h,0ffh,000h,0ffh,040h,0ffh,000h,0ffh,040h	; 70a0  .....@.@...@...@
	defb 0fdh,000h,0bdh,000h,0ddh,040h,0ddh,040h,0bdh,040h,099h,040h,0d9h,040h,099h,0ffh	; 70b0  .....@.@.@.@.@..
	defb 080h,056h,0d9h,056h,0d8h,076h,0f9h,056h,0d9h,054h,0fdh,054h,0ffh,054h,0fdh,054h	; 70c0  .V.V.v.V.T.T.T.T
	defb 0fdh,054h,0ffh,054h,0fdh,054h,0fbh,050h,0fdh,044h,0fdh,050h,0fdh,050h,0f9h,050h	; 70d0  .T.T.T.P.D.P.P.P
	defb 0f9h,040h,0fdh,040h,0fdh,040h,0fdh,050h,0f9h,040h,0b9h,040h,0b9h,040h,0b9h,050h	; 70e0  .@.@.@.P.@.@.@.P
	defb 0f9h,040h,0b9h,040h,0b9h,040h,0b9h,040h,0b9h,040h,099h,040h,0b9h,040h,0b9h,050h	; 70f0  .@.@.@.@.@.@.@.P
	defb 0ffh,056h,0bfh,054h,0ffh,054h,0ffh,054h,0bfh,054h,0ffh,054h,0ffh,054h,0ffh,054h	; 7100  .V.T.T.T.T.T.T.T
	defb 0ffh,054h,0fbh,054h,0ffh,054h,0ffh,040h,0fbh,050h,0bfh,050h,0ffh,040h,0ddh,040h	; 7110  .T.T.T.@.P.P.@.@
	defb 0ffh,040h,0fbh,040h,0fdh,040h,0fdh,040h,0fdh,040h,0f9h,040h,0fdh,040h,0ddh,040h	; 7120  .@.@.@.@.@.@.@.@
	defb 0b9h,040h,0b9h,040h,0d8h,040h,09ch,040h,099h,040h,098h,040h,098h,040h,098h,0ffh	; 7130  .@.@.@.@.@.@.@..
	defb 000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh	; 7140  ..*...*...*...*.
	defb 000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh	; 7150  ..*...*...*...*.
	defb 000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh	; 7160  ..*...*...*...*.
	defb 000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,0feh,02ah,07fh,000h,002h,02ah,07fh	; 7170  ..*...*...*...*.
	defb 000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh	; 7180  ..*...*...*...*.
	defb 000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh	; 7190  ..*...*...*...*.
	defb 000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh,000h,002h,02ah,07fh	; 71a0  ..*...*...*...*.
	defb 000h,002h,02ah,07fh,000h,002h,02ah,07fh,080h,002h,02ah,07fh,080h,002h,02ah,07fh	; 71b0  ..*...*...*...*.
	defb 0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh	; 71c0  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh	; 71d0  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh	; 71e0  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh	; 71f0  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,0ffh,03ah,0dfh	; 7200  ..:...:...:...:.
	defb 0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh,0feh,000h,03ah,0dfh,0feh,001h,03ah,0dfh	; 7210  ..:...:...:...:.
	defb 000h,000h,03ch,0dfh,000h,000h,03ch,0dfh,000h,000h,03eh,0dfh,000h,000h,03eh,0dfh	; 7220  ..<...<...>...>.
	defb 030h,000h,03ah,0dfh,080h,040h,09ch,040h,09dh,040h,09ch,004h,09ch,044h,09ch,0ffh	; 7230  0.:..@.@.@...D..
	defb 002h,0f8h,030h,08fh,002h,0f9h,030h,08fh,002h,0fch,030h,08fh,002h,0feh,030h,08fh	; 7240  ..0...0...0...0.
	defb 002h,0ffh,030h,08fh,002h,0ffh,030h,08fh,002h,0ffh,030h,08fh,002h,000h,030h,08fh	; 7250  ..0...0...0...0.
	defb 002h,000h,030h,08fh,002h,001h,030h,08fh,002h,001h,030h,08fh,002h,001h,030h,08fh	; 7260  ..0...0...0...0.
	defb 002h,002h,030h,08fh,002h,004h,030h,08fh,002h,007h,030h,08fh,002h,008h,030h,08fh	; 7270  ..0...0...0...0.
	defb 000h,0f8h,032h,08fh,000h,0f9h,032h,08fh,000h,0fch,030h,08fh,000h,0feh,030h,08fh	; 7280  ..2...2...0...0.
	defb 000h,0ffh,032h,08fh,000h,0ffh,032h,08fh,000h,000h,030h,08fh,000h,000h,030h,08fh	; 7290  ..2...2...0...0.
	defb 000h,001h,032h,08fh,000h,001h,032h,08fh,000h,002h,030h,08fh,000h,004h,030h,08fh	; 72a0  ..2...2...0...0.
	defb 000h,007h,032h,08fh,000h,008h,032h,08fh,080h,000h,099h,000h,099h,040h,099h,0ffh	; 72b0  ..2...2......@..
	defb 002h,000h,030h,05fh,002h,000h,030h,05fh,002h,000h,032h,05fh,002h,000h,032h,05fh	; 72c0  ..0_..0_..2_..2_
	defb 080h,054h,0ffh,054h,0ffh,056h,0ffh,054h,0ffh,054h,0fdh,054h,0bfh,050h,0ffh,050h	; 72d0  .T.T.V.T.T.T.P.P
	defb 0fdh,040h,0ffh,040h,0bfh,040h,0ffh,050h,0fdh,040h,0bdh,040h,0bfh,040h,0bdh,040h	; 72e0  .@.@.@.P.@.@.@.@
	defb 0fdh,040h,0b9h,040h,0b9h,040h,0b9h,040h,0b9h,040h,099h,040h,0b9h,040h,0b9h,056h	; 72f0  .@.@.@.@.@.@.@.V
	defb 0ffh,056h,0bfh,054h,0ffh,054h,0ffh,054h,0bfh,054h,0bfh,054h,0ffh,054h,0ffh,054h	; 7300  .V.T.T.T.T.T.T.T
	defb 0ffh,054h,0ffh,054h,0ffh,054h,0ffh,044h,0ffh,050h,0bfh,050h,0ffh,044h,0ddh,040h	; 7310  .T.T.T.D.P.P.D.@
	defb 0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0ffh,040h,0dfh,040h	; 7320  .@.@.@.@.@.@.@.@
	defb 0bdh,040h,099h,040h,0ddh,040h,09dh,040h,099h,040h,098h,040h,098h,040h,098h,0ffh	; 7330  .@.@.@.@.@.@.@..
	defb 002h,002h,034h,07fh,002h,002h,038h,07fh,002h,001h,036h,07fh,002h,001h,038h,07fh	; 7340  ..4...8...6...8.
	defb 002h,001h,034h,07fh,002h,001h,038h,07fh,002h,000h,036h,07fh,002h,000h,038h,07fh	; 7350  ..4...8...6...8.
	defb 002h,000h,034h,07fh,002h,000h,038h,07fh,002h,0ffh,036h,07fh,002h,0ffh,038h,07fh	; 7360  ..4...8...6...8.
	defb 002h,0ffh,034h,07fh,002h,0ffh,038h,07fh,002h,0feh,036h,07fh,002h,0feh,038h,07fh	; 7370  ..4...8...6...8.
	defb 080h,076h,0bfh,054h,0ffh,044h,0ffh,044h,0bfh,044h,0bfh,044h,0ffh,044h,0ffh,040h	; 7380  .v.T.D.D.D.D.D.@
	defb 0ffh,044h,0bfh,040h,0bfh,040h,0ffh,040h,0bfh,000h,0bfh,040h,0bfh,040h,0fdh,000h	; 7390  .D.@.@.@...@.@..
	defb 0ffh,000h,0fbh,000h,0ffh,000h,0ffh,000h,0bfh,000h,0bfh,000h,0ffh,000h,0bfh,000h	; 73a0  ................
	defb 0b9h,000h,0b9h,000h,0b9h,000h,0bdh,000h,0b9h,000h,0a9h,000h,0b9h,040h,0b9h,0ffh	; 73b0  .............@..
	defb 002h,0feh,034h,07fh,002h,0feh,038h,07fh,002h,0ffh,036h,07fh,002h,0ffh,038h,07fh	; 73c0  ..4...8...6...8.
	defb 002h,0ffh,034h,07fh,002h,0ffh,038h,07fh,002h,000h,036h,07fh,002h,000h,038h,07fh	; 73d0  ..4...8...6...8.
	defb 002h,000h,034h,07fh,002h,000h,038h,07fh,002h,001h,036h,07fh,002h,001h,038h,07fh	; 73e0  ..4...8...6...8.
	defb 002h,001h,034h,07fh,002h,001h,038h,07fh,002h,002h,036h,07fh,002h,002h,038h,07fh	; 73f0  ..4...8...6...8.
	defb 080h,056h,0bfh,056h,0beh,054h,0bfh,078h,007h,0edh,007h,0edh,007h,0edh,007h,0edh	; 7400  .V.V.T.x........
	defb 0c7h,0fbh,0a6h,047h,03fh,0f4h,007h,0edh,006h,0ech,006h,0c6h,006h,0ech,006h,0e8h	; 7410  ...G?...........
	defb 007h,088h,006h,08ch,006h,088h,006h,0e8h,006h,0e8h,006h,088h,00ch,08ch,006h,008h	; 7420  ................
	defb 007h,088h,00ch,00ch,00ch,0d8h,00ch,010h,00ch,008h,00ch,00ch,08ch,01fh,0e8h,024h	; 7430  ...............$
	defb 002h,000h,026h,0cfh,002h,000h,026h,0cfh,002h,0ffh,028h,0cfh,002h,0ffh,028h,0cfh	; 7440  ..&...&...(...(.
	defb 002h,000h,026h,0cfh,002h,000h,026h,0cfh,002h,001h,028h,0cfh,002h,001h,028h,0cfh	; 7450  ..&...&...(...(.
	defb 080h,050h,04eh,050h,052h,055h,020h,000h,000h,000h,000h,000h,0a0h,000h,0a2h,000h	; 7460  .PNPRU .........
	defb 0a0h,0bah,000h,000h,000h,000h,000h,000h,000h,000h,0d1h,0d2h,000h,000h,000h,000h	; 7470  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0b7h	; 7480  ................
	defb 0b9h,0bah,000h,000h,000h,000h,000h,000h,000h,000h,0d3h,0d4h,000h,000h,000h,000h	; 7490  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0b7h	; 74a0  ................
	defb 0b9h,0bah,000h,000h,000h,000h,000h,000h,000h,000h,0d1h,0d2h,000h,000h,000h,000h	; 74b0  ................
	defb 000h,000h,017h,0ffh,080h,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h	; 74c0  ................
	defb 0ffh,014h,0ffh,004h,0ffh,014h,0fbh,014h,0ffh,004h,0ffh,014h,0ffh,014h,0ffh,014h	; 74d0  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0fbh,000h,0fbh,000h,0ffh,000h,0fbh,000h	; 74e0  ................
	defb 0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0ebh,014h	; 74f0  ................
	defb 0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h	; 7500  ................
	defb 0ffh,014h,0ffh,014h,0ffh,014h,0ffh,004h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,004h	; 7510  ................
	defb 0ffh,000h,0fbh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0fbh,000h,0ffh,000h,0ffh,000h	; 7520  ................
	defb 0fbh,000h,0fbh,000h,0fbh,000h,0ffh,000h,0fbh,000h,0ebh,000h,0fbh,000h,0ebh,056h	; 7530  ...............V
	defb 002h,000h,02ah,07fh,080h,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h	; 7540  ..*.............
	defb 0ffh,014h,0ffh,004h,0ffh,014h,0ffh,014h,0ffh,004h,0ffh,014h,0ffh,014h,0ffh,014h	; 7550  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,010h	; 7560  ................
	defb 0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,014h	; 7570  ................
	defb 0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h	; 7580  ................
	defb 0ffh,014h,0ffh,014h,0ffh,014h,0ffh,004h,0ffh,010h,0ffh,014h,0ffh,000h,0ffh,004h	; 7590  ................
	defb 0ffh,004h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; 75a0  ................
	defb 0fbh,000h,0fbh,000h,0fbh,000h,0ffh,000h,0fbh,000h,0ebh,010h,0fbh,000h,0fbh,056h	; 75b0  ...............V
	defb 002h,0feh,03ah,05fh,002h,0feh,038h,05fh,002h,0feh,038h,05fh,002h,0feh,038h,05fh	; 75c0  ..:_..8_..8_..8_
	defb 002h,0feh,038h,05fh,002h,0feh,038h,05fh,002h,0feh,038h,05fh,002h,0feh,038h,05fh	; 75d0  ..8_..8_..8_..8_
	defb 002h,0feh,038h,05fh,002h,0feh,038h,05fh,002h,0feh,038h,05fh,002h,0feh,03ah,05fh	; 75e0  ..8_..8_..8_..:_
	defb 002h,000h,03ah,05fh,002h,002h,03ah,05fh,002h,002h,038h,05fh,002h,002h,038h,05fh	; 75f0  ..:_..:_..8_..8_
	defb 002h,002h,038h,05fh,002h,002h,038h,05fh,002h,002h,038h,05fh,002h,002h,038h,05fh	; 7600  ..8_..8_..8_..8_
	defb 002h,002h,038h,05fh,002h,002h,038h,05fh,002h,002h,038h,05fh,002h,002h,038h,05fh	; 7610  ..8_..8_..8_..8_
	defb 002h,002h,03ah,05fh,002h,000h,03ah,05fh,080h,000h,0ffh,004h,0ffh,000h,0ffh,000h	; 7620  ..:_..:_........
	defb 0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0ebh,004h,0ebh,004h,0ebh,056h	; 7630  ...............V
	defb 002h,000h,02eh,02fh,002h,000h,030h,02fh,002h,000h,02eh,03fh,002h,000h,030h,03fh	; 7640  .../..0/...?..0?
	defb 080h,004h,0ffh,004h,0ffh,014h,0ffh,004h,0ffh,004h,0ffh,004h,0ffh,004h,0ffh,014h	; 7650  ................
	defb 0ffh,000h,0ffh,004h,0ffh,004h,0ffh,004h,0ffh,000h,0ffh,000h,0ffh,004h,0ffh,000h	; 7660  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,004h,0fbh,000h,0ffh,014h	; 7670  ................
	defb 0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,004h,0ffh,014h,0ffh,004h,0ffh,004h	; 7680  ................
	defb 0ffh,014h,0ffh,004h,0ffh,004h,0ffh,004h,0ffh,004h,0ffh,004h,0ffh,004h,0ffh,004h	; 7690  ................
	defb 0ffh,004h,0ffh,000h,0ffh,004h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; 76a0  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ebh,004h,0efh,004h,0efh,056h	; 76b0  ...............V
	defb 0ffh,0fch,032h,07fh,0ffh,0feh,032h,07fh,0feh,0feh,032h,07fh,0feh,002h,032h,07fh	; 76c0  ..2...2...2...2.
	defb 0ffh,002h,032h,07fh,0ffh,004h,032h,07fh,0feh,000h,034h,07fh,0feh,000h,036h,07fh	; 76d0  ..2...2...4...6.
	defb 0feh,000h,034h,07fh,0feh,000h,032h,07fh,0feh,000h,034h,07fh,0feh,000h,036h,07fh	; 76e0  ..4...2...4...6.
	defb 0feh,000h,034h,07fh,0feh,000h,032h,07fh,080h,0efh,010h,0efh,010h,0ffh,000h,000h	; 76f0  ..4...2.........
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,000h,000h,0efh,000h,0efh,000h,0efh	; 7700  ................
	defb 000h,0efh,000h,0efh,000h,000h,000h,0efh,000h,0efh,000h,000h,000h,0efh,000h,0ffh	; 7710  ................
	defb 000h,0ffh,000h,0ffh,000h,0efh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0efh	; 7720  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0efh,010h,0ffh,010h,0efh,000h,0efh,010h,029h	; 7730  ...............)
	defb 001h,0fch,03ch,07fh,000h,0fch,03eh,07fh,0ffh,0fch,03ch,07fh,000h,0fch,03eh,07fh	; 7740  ..<...>...<...>.
	defb 0ffh,0fch,03ch,07fh,000h,0fch,03eh,07fh,001h,0fch,03eh,07fh,000h,0fch,03ch,07fh	; 7750  ..<...>...>...<.
	defb 001h,0fch,03eh,07fh,000h,0fch,03ch,07fh,0ffh,0fch,03eh,07fh,000h,0fch,03ch,07fh	; 7760  ..>...<...>...<.
	defb 000h,030h,03eh,07fh,080h,0ffh,000h,0ffh,000h,0efh,000h,0efh,000h,0ffh,000h,0efh	; 7770  .0>.............
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh	; 7780  ................
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0ffh,000h,0efh,000h,0efh	; 7790  ................
	defb 000h,0ffh,000h,0ffh,000h,0efh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0efh	; 77a0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0efh,000h,0ffh,000h,0efh,000h,0efh,000h,0a9h	; 77b0  ................
	defb 002h,000h,026h,0dfh,002h,001h,026h,0dfh,002h,000h,028h,0dfh,002h,001h,028h,0dfh	; 77c0  ..&...&...(...(.
	defb 002h,001h,026h,0dfh,002h,001h,026h,0dfh,001h,002h,028h,0dfh,001h,002h,028h,0dfh	; 77d0  ..&...&...(...(.
	defb 000h,002h,026h,0dfh,0ffh,002h,026h,0dfh,0ffh,002h,028h,0dfh,0feh,001h,028h,0dfh	; 77e0  ..&...&...(...(.
	defb 0feh,001h,026h,0dfh,0feh,0ffh,026h,0dfh,0feh,0ffh,028h,0dfh,0ffh,0feh,028h,0dfh	; 77f0  ..&...&...(...(.
	defb 0ffh,0feh,026h,0dfh,000h,0feh,026h,0dfh,001h,0feh,028h,0dfh,001h,0feh,028h,0dfh	; 7800  ..&...&...(...(.
	defb 002h,0ffh,026h,0dfh,002h,0ffh,026h,0dfh,002h,0ffh,028h,0dfh,002h,000h,028h,0dfh	; 7810  ..&...&...(...(.
	defb 002h,0ffh,026h,0dfh,002h,000h,026h,0dfh,080h,0ffh,000h,0ffh,000h,0ffh,000h,0efh	; 7820  ..&...&.........
	defb 000h,0ffh,000h,0efh,000h,0ffh,000h,0efh,000h,0ffh,000h,0efh,000h,0efh,010h,0a9h	; 7830  ................
	defb 004h,0fch,012h,0afh,004h,0fch,014h,0afh,004h,0fch,016h,0a9h,004h,0fch,014h,0afh	; 7840  ................
	defb 004h,0fch,012h,0afh,004h,0fch,014h,0afh,004h,0fch,016h,0a9h,004h,0fch,014h,0afh	; 7850  ................
	defb 004h,004h,012h,0afh,004h,004h,014h,0afh,004h,004h,016h,0a9h,004h,004h,014h,0afh	; 7860  ................
	defb 004h,004h,012h,0afh,004h,004h,014h,0afh,004h,004h,016h,0a9h,004h,004h,014h,0afh	; 7870  ................
	defb 080h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh	; 7880  ................
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh	; 7890  ................
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh	; 78a0  ................
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0a9h	; 78b0  ................
	defb 001h,0f8h,038h,05fh,001h,0fah,038h,05fh,001h,0fah,038h,05fh,001h,0fch,038h,05fh	; 78c0  ..8_..8_..8_..8_
	defb 002h,0fch,038h,05fh,002h,0feh,038h,05fh,002h,0feh,038h,05fh,002h,000h,038h,05fh	; 78d0  ..8_..8_..8_..8_
	defb 002h,000h,038h,05fh,002h,002h,038h,05fh,002h,002h,038h,05fh,002h,004h,038h,05fh	; 78e0  ..8_..8_..8_..8_
	defb 001h,004h,038h,05fh,001h,006h,038h,05fh,001h,006h,038h,05fh,001h,008h,038h,05fh	; 78f0  ..8_..8_..8_..8_
	defb 000h,002h,03ah,05fh,000h,000h,03ah,05fh,000h,0feh,038h,05fh,080h,0efh,000h,0efh	; 7900  ..:_..:_..8_....
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0ffh,053h,047h,0feh,03fh	; 7910  ............SG.?
	defb 008h,000h,002h,000h,000h,0efh,000h,0efh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0efh	; 7920  ................
	defb 000h,0ffh,000h,0efh,000h,0ffh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,010h,0a9h	; 7930  ................
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh	; 7940  ................
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0ffh	; 7950  ................
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0ffh	; 7960  ................
	defb 000h,0efh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0efh,000h,0efh,010h,0ffh,010h,0efh	; 7970  ................
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh	; 7980  ................
	defb 000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0efh,000h,0ffh,000h,0efh,000h,0ffh	; 7990  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 79a0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0efh,000h,0ffh,000h,0ffh,000h,0efh,010h,0a9h	; 79b0  ................
	defb 004h,00ah,0ffh,0ach,014h,005h,0feh,0adh,000h,000h,000h,000h,000h,000h,000h,000h	; 79c0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 79d0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 79e0  ................
	defb 00dh,00eh,0fbh,0ach,001h,007h,0feh,0abh,000h,000h,000h,000h,000h,000h,000h,000h	; 79f0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7a00  ................
	defb 006h,00bh,0fch,0adh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7a10  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7a20  ................
	defb 014h,004h,0fdh,0aah,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7a30  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7a40  ................
	defb 01ch,00ah,0ffh,0adh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7a50  ................
	defb 00eh,00ah,0f9h,0ach,013h,00eh,0feh,0aah,000h,000h,000h,000h,000h,000h,000h,000h	; 7a60  ................
	defb 01ah,002h,0fbh,0adh,01ch,007h,0fch,0ach,000h,000h,000h,000h,000h,000h,000h,000h	; 7a70  ................
	defb 00ch,006h,0fbh,0ach,00bh,00bh,0fbh,0abh,000h,000h,000h,000h,000h,000h,000h,000h	; 7a80  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7a90  ................
	defb 00ah,005h,0ffh,0ach,014h,006h,0fah,0abh,000h,000h,000h,000h,000h,000h,000h,000h	; 7aa0  ................
	defb 01eh,00bh,0fah,0adh,010h,007h,0fah,0abh,000h,000h,000h,000h,000h,000h,000h,000h	; 7ab0  ................
	defb 002h,00eh,0ffh,0abh,015h,005h,0feh,0adh,000h,000h,000h,000h,000h,000h,000h,000h	; 7ac0  ................
	defb 00ah,00eh,0fah,0ach,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7ad0  ................
	defb 009h,008h,0fdh,0ach,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7ae0  ................
	defb 002h,00ah,0feh,0adh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7af0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7b00  ................
	defb 00bh,009h,0fah,0adh,00fh,008h,0feh,0ach,000h,000h,000h,000h,000h,000h,000h,000h	; 7b10  ................
	defb 009h,00ah,0fah,0ach,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7b20  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7b30  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7b40  ................
	defb 005h,005h,0fah,0abh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7b50  ................
	defb 003h,004h,0fah,0f4h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7b60  ................
	defb 008h,00ch,0ffh,000h,00ah,00ah,0ffh,000h,009h,008h,0ffh,000h,000h,000h,000h,000h	; 7b70  ................
	defb 000h,042h,000h,043h,000h,0ebh,000h,0ebh,000h,0ebh,000h,0ebh,000h,0ebh,000h,0ebh	; 7b80  .B.C............
	defb 000h,0ebh,000h,0ebh,000h,0ebh,000h,0ebh,000h,0ebh,000h,0ebh,000h,0ebh,000h,0ebh	; 7b90  ................
	defb 030h,048h,016h,0ffh,0c0h,030h,016h,0ffh,000h,000h,000h,000h,000h,000h,000h,000h	; 7ba0  0H...0..........
	defb 080h,02ch,016h,0ffh,038h,044h,016h,0ffh,030h,068h,013h,0fdh,000h,000h,000h,000h	; 7bb0  .,..8D..0h......
	defb 020h,030h,016h,0ffh,0c7h,068h,013h,0fdh,000h,000h,000h,000h,000h,000h,000h,000h	; 7bc0   0...h..........
	defb 010h,034h,016h,0ffh,058h,01eh,016h,0f1h,078h,068h,013h,0fbh,000h,000h,000h,000h	; 7bd0  .4..X...xh......
	defb 060h,068h,013h,0fah,09eh,050h,012h,0feh,0d8h,040h,017h,0ffh,000h,000h,000h,000h	; 7be0  `h...P...@......
	defb 020h,068h,010h,0feh,068h,048h,016h,0ffh,078h,058h,027h,0ffh,000h,000h,000h,000h	; 7bf0   h..hH..xX'.....
	defb 048h,00ch,027h,0fbh,0a0h,01ch,016h,0f5h,046h,058h,012h,0fdh,068h,068h,013h,0fdh	; 7c00  H.'.....FX..hh..
	defb 03eh,058h,012h,001h,05ch,034h,017h,0ffh,08eh,068h,012h,0feh,0b8h,00eh,025h,0feh	; 7c10  >X..\4...h....%.
	defb 058h,018h,016h,0fdh,060h,058h,018h,001h,090h,058h,018h,001h,000h,000h,000h,000h	; 7c20  X...`X...X......
	defb 060h,018h,016h,0fah,028h,060h,018h,001h,068h,050h,018h,001h,000h,000h,000h,000h	; 7c30  `...(`..hP......
	defb 0d8h,068h,013h,001h,080h,00ch,016h,0fdh,0a0h,058h,011h,0ffh,0e0h,040h,015h,0fdh	; 7c40  .h.......X...@..
	defb 050h,024h,011h,0ffh,070h,010h,014h,0fdh,090h,048h,029h,001h,0c0h,058h,018h,001h	; 7c50  P$..p....H)..X..
	defb 058h,020h,015h,0fdh,0c0h,038h,011h,0fbh,0c0h,048h,011h,0fbh,050h,060h,015h,0fdh	; 7c60  X ...8...H..P`..
	defb 010h,010h,025h,0fdh,06ah,030h,023h,0fbh,068h,048h,013h,0fbh,010h,064h,016h,0f6h	; 7c70  ..%.j0#.hH...d..
	defb 030h,068h,02bh,000h,0e0h,050h,01fh,0f0h,060h,016h,027h,0ffh,000h,000h,000h,000h	; 7c80  0h+..P..`.'.....
	defb 03fh,050h,01ah,001h,058h,036h,016h,0fch,080h,046h,016h,0feh,090h,070h,016h,0ffh	; 7c90  ?P..X6...F...p..
	defb 040h,010h,01ah,0feh,080h,020h,01ah,0feh,0e0h,004h,016h,0ffh,030h,03ch,016h,0ffh	; 7ca0  @.... ......0<..
	defb 038h,020h,01ah,001h,0a0h,010h,01ah,0f0h,030h,03ch,01dh,0ffh,0d0h,060h,019h,001h	; 7cb0  8 ......0<...`..
	defb 018h,050h,016h,0fah,050h,068h,01ah,001h,0b8h,038h,01eh,0fah,000h,000h,000h,000h	; 7cc0  .P..Ph...8......
	defb 060h,029h,017h,0fah,060h,004h,016h,019h,080h,068h,01ah,0fdh,088h,038h,016h,0fdh	; 7cd0  `)..`....h...8..
	defb 040h,008h,02eh,0fah,0b0h,028h,016h,0ffh,028h,038h,027h,0eah,0f0h,068h,019h,000h	; 7ce0  @....(..(8'..h..
	defb 078h,068h,01ah,0f6h,0f0h,058h,01ah,0f6h,08ch,058h,01ch,001h,000h,000h,000h,000h	; 7cf0  xh...X...X......
	defb 040h,068h,01ah,0f6h,0c0h,050h,01ch,0fdh,0a4h,05ch,01ch,0fdh,000h,000h,000h,000h	; 7d00  @h...P...\......
	defb 0c0h,010h,02ch,0f7h,080h,038h,02ch,0f0h,018h,070h,01bh,001h,0b0h,060h,01bh,0fah	; 7d10  ..,..8,..p...`..
	defb 0e8h,010h,02ch,0fah,0e8h,040h,02ch,0fah,080h,068h,02bh,0ffh,000h,000h,000h,000h	; 7d20  ..,..@,..h+.....
	defb 01fh,068h,01ah,0f6h,0e0h,018h,01bh,0f0h,0e1h,040h,01bh,0f0h,000h,000h,000h,000h	; 7d30  .h.......@......
	defb 060h,050h,01ch,0fah,088h,050h,01bh,0f0h,098h,028h,01ah,0fah,0d8h,068h,01bh,0fah	; 7d40  `P...P...(...h..
	defb 05ch,038h,02bh,000h,05ch,048h,02bh,000h,05ch,058h,02bh,000h,0d0h,068h,02ch,0c8h	; 7d50  \8+.\H+.\X+..h,.
	defb 020h,020h,00eh,064h,0d8h,020h,00eh,064h,040h,050h,00eh,064h,0a8h,050h,00eh,064h	; 7d60    .d. .d@P.d.P.d
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7d70  ................
	defb 002h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7d80  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7d90  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7da0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7db0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7dc0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7dd0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7de0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7df0  ................
	defb 009h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e00  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e10  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e20  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e30  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e40  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e50  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e60  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e70  ................
	defb 003h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e80  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7e90  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7ea0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7eb0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7ec0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7ed0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7ee0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7ef0  ................
	defb 029h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7f00  )...............
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7f10  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7f20  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7f30  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7f40  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7f50  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7f60  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7f70  ................
	defb 000h,04eh,049h,056h,045h,04ch,06ch,000h,000h,000h,000h,041h,043h,041h,042h,04fh	; 7f80  .NIVELl....ACABO
	defb 053h,045h,069h,000h,000h,000h,050h,04fh,052h,000h,051h,055h,045h,000h,04eh,04fh	; 7f90  SEi...POR.QUE.NO
	defb 000h,050h,052h,055h,045h,042h,041h,053h,000h,053h,049h,04eh,000h,050h,04fh,04bh	; 7fa0  .PRUEBAS.SIN.POK
	defb 045h,053h,067h,067h,000h,000h,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7fb0  ESgg............
	defb 03eh,0a8h,0d3h,0a8h,021h,000h,090h,001h,0ffh,03fh,011h,000h,040h,0edh,0b0h,03eh	; 7fc0  >...!....?..@..>
	defb 0a0h,0d3h,0a8h,0c9h,0a8h,0c9h,000h,000h,000h,000h,000h,0ffh,000h,0ffh,000h,0ffh	; 7fd0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7fe0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 7ff0  ................

; ======================================================================
; CODIGO 0x8000..0x856e  (1390 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; ENTRADA DEL JUEGO
; ############################################################
; Aqui salta el cargador turbo (SLOTS) con 'jp 08000h' una vez
; tiene los 40449 bytes del juego en 0x4000..0xDE00.
;
; Mapa de memoria en este punto (verificado en openMSX):
; 0x0000-0x3FFF  ROM del BASIC  <- NO se conmuta: el juego sigue
; llamando a la BIOS (LDIRVM, etc.)
; 0x4000-0xDE00  el juego (codigo + graficos)
; 0xEFFF         pila inicial
; ----------------------------------------------------------------------
GAME_START:		; Punto de entrada del juego
	ld sp,0efffh		;8000   ; Pila provisional en 0xEFFF
	ld b,0f2h		;8003   ; B=dato, C=nº de registro: escribe 0xF2 en el registro 1 del VDP
	ld c,001h		;8005
	call 00047h		;8007   ; BIOS WRTVDP - Writes data in the VDP-register
	call 00072h		;800a   ; BIOS INIGRP - Switches to SCREEN 2 (high resolution screen with 256*192 pixels) | Inicializa SCREEN 2 (modo grafico de 256x192)
	call 00041h		;800d   ; BIOS DISSCR - Inhibits the screen display | Apaga la pantalla mientras se vuelca la VRAM (evita ver el destrozo)
	ld hl,04000h		;8010   ; Fuente -> tercio 1 de la tabla de patrones
	ld de,00000h		;8013
	ld bc,00800h		;8016
	call 0005ch		;8019   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld hl,04000h		;801c   ; Fuente -> tercio 2 (mismo origen: los tres tercios son identicos)
	ld de,00800h		;801f
	ld bc,00800h		;8022
	call 0005ch		;8025   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld hl,04000h		;8028   ; Fuente -> tercio 3
	ld de,01000h		;802b
	ld bc,00800h		;802e
	call 0005ch		;8031   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld hl,04800h		;8034   ; Colores -> tercio 1
	ld de,02000h		;8037
	ld bc,00800h		;803a
	call 0005ch		;803d   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld hl,04800h		;8040   ; Colores -> tercio 2
	ld de,02800h		;8043
	ld bc,00800h		;8046
	call 0005ch		;8049   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld hl,04800h		;804c   ; Colores -> tercio 3
	ld de,03000h		;804f
	ld bc,00800h		;8052
	call 0005ch		;8055   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld sp,08fffh		;8058   ; Pila definitiva en 0x8FFF, justo debajo de los mapas de 0x9000; crece hacia abajo y en la practica no baja de 0x8FD1. NO llega hasta 0x8FA0: ahi viven los cuatro puntos ocultos de la pantalla, que serian lo primero en corromperse [SUSTITUYE]
	jp INIT_PRINCIPAL		;805b
INIT_PANTALLA:		; Color de borde, sprites y encender pantalla
	ld hl,0f3ebh		;805e
	ld (hl),001h		;8061   ; Fondo negro: es el valor normal de todas las pantallas
	call 00062h		;8063   ; BIOS CHGCLR - Changes the screen colors
	ld hl,05000h		;8066   ; Patrones de sprites -> VRAM 0x3800
	ld de,03800h		;8069
	ld bc,00800h		;806c
	call 0005ch		;806f   ; BIOS LDIRVM - Block transfers to VRAM from memory
	call 00044h		;8072   ; BIOS ENASCR - Displays the screen | Ya esta todo en VRAM: se puede encender la pantalla
	ret			;8075
INIT_PRINCIPAL:		; Continuacion del arranque: prepara el menu
	call INIT_PANTALLA		;8076
	ld a,000h		;8079
	ld (0f3dbh),a		;807b   ; Desactiva el "click" de teclado
	call OCULTA_SPRITES		;807e   ; Deja los 64 sprites fuera de pantalla antes de pintar nada
	ld hl,05cc0h		;8081   ; Pinta la pantalla de presentacion (texto del monje y creditos)
	ld de,01800h		;8084
	ld bc,00300h		;8087
	call 0005ch		;808a   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld de,01b00h		;808d   ; Atributos de sprites -> VRAM 0x1B00
	ld hl,08c60h		;8090
	ld bc,00010h		;8093
	call 0005ch		;8096   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld hl,08cd4h		;8099   ; Pone a cero las 8 ranuras de efectos de sonido (0x8CD4 son 8 bytes a cero)
	ld de,0ddach		;809c
	ld bc,00008h		;809f
	ldir			;80a2
	ld hl,08cd4h		;80a4   ; Limpia 16 bytes mas en 0x8F34 y 0x8F3C, justo detras de los 4 registros de enemigos (0x8F20+4*5 = 0x8F34): el barrido de 0x8A5A recorre 8 ranuras y estas cuatro sobran (?)
	ld de,08f34h		;80a7
	ld bc,00008h		;80aa
	ldir			;80ad
	ld hl,08cd4h		;80af
	ld de,08f3ch		;80b2
	ld bc,00008h		;80b5
	ldir			;80b8
	ld hl,08cb8h		;80ba   ; Siembra las 7 ranuras de disparo (7 registros de 4 bytes)
	ld bc,0001ch		;80bd
	ld de,08f80h		;80c0
	ldir			;80c3
	call MENU_PRINCIPAL		;80c5   ; Menu de presentacion: no vuelve hasta que pulsan disparo
	call 00090h		;80c8   ; BIOS GICINI - Initialises PSG and sets initial value for the PLAY statement | BIOS GICINI: reinicia el PSG, o sea corta la musica del menu
	call OCULTA_SPRITES		;80cb   ; Vuelve a esconder los sprites: empieza la partida
	ld a,080h		;80ce   ; X inicial del jugador, en pixeles
	ld (08f09h),a		;80d0
	ld (08f13h),a		;80d3   ; La misma X en la copia de REAPARICION: al morir se vuelve aqui
	ld a,068h		;80d6   ; Y inicial del jugador
	ld (08f0ah),a		;80d8
	ld (08f14h),a		;80db   ; La misma Y en la copia de reaparicion
	ld a,000h		;80de
	ld (08f0bh),a		;80e0   ; Estado 0 = PARADO (su unico fotograma es dX=0, dY=0)
	ld (08f1ch),a		;80e3   ; Estado de reaparicion, tambien parado
	ld (08f0ch),a		;80e6   ; Paso 0 dentro de la secuencia de animacion
	ld (08f1dh),a		;80e9
	ld hl,08f11h		;80ec   ; Modo de movimiento NORMAL (con gravedad). A 1 seria modo vuelo
	ld (hl),000h		;80ef
	ld a,0ffh		;80f1   ; Nivel = 0xFF porque 0x8B9D lo incrementa antes de empezar: acaba en 0 y se pinta como NIVEL 1
	ld (08f0eh),a		;80f3
	ld a,0ffh		;80f6   ; Igual con la pantalla; luego 0x8114 la deja en 0
	ld (08f0dh),a		;80f8
	ld a,009h		;80fb   ; 9 vidas iniciales: el marcador solo tiene un digito
	ld (08f12h),a		;80fd
	ld a,001h		;8100   ; Un solo icono de municion al empezar
	ld (08f17h),a		;8102
	ld a,000h		;8105   ; Arma tipo 0, la mas basica
	ld (08f18h),a		;8107
	ld a,0ffh		;810a   ; Gatillo marcado como YA PULSADO: hay que soltar el boton antes de poder disparar la primera vez
	ld (08f19h),a		;810c
	call EMPIEZA_NIVEL		;810f   ; Entra en el nivel 1 (incrementa el nivel y pinta el rotulo NIVEL:1)
	ld a,000h		;8112
	ld (08f0dh),a		;8114

; ----------------------------------------------------------------------
; ############################################################
; BUCLE PRINCIPAL DE LA PARTIDA
; ############################################################
; Verificado por muestreo del PC en openMSX: con el juego en
; partida (marcador "VIDAS:9 PANTALLA:1 NIVEL:1" en pantalla)
; el PC pasa casi todo el tiempo en los dos HALT de aqui.
; Cada vuelta procesa DOS frames (dos halt + dos llamadas a
; 0xDB00), de modo que el juego va a 25/30 Hz y no a 50/60.
; ----------------------------------------------------------------------
BUCLE_PARTIDA:		; Bucle de juego: se repite mientras dura la partida
	call CHK_ABANDONAR		;8117   ; BIOS BREAKX: si han pulsado CTRL+STOP, abandona la partida
	halt			;811a   ; Espera al barrido de pantalla (sincroniza y deja correr la IRQ)
L_811B:
	call SFX_FRAME		;811b   ; Rutina de cada frame (sprites / VDP)
	halt			;811e
L_811F:
	call SFX_FRAME		;811f
	call DISPARA		;8122   ; Rutinas de la logica del juego, una por frame doble
	call MUEVE_DISPAROS		;8125   ; Mueve y dibuja los DISPAROS (tabla 0x8F80): son tiles escritos en la tabla de nombres, no sprites
	call MUEVE_ENEMIGOS		;8128   ; Mueve y dibuja los ENEMIGOS de la pantalla (tabla 0x8F20, 4 registros de 5 bytes)
L_812B:
	call COMPRUEBA_COLISION_SPRITES		;812b   ; Comprueba el flag de COLISION DE SPRITES del VDP; si toca, mata al jugador
	ld a,(08f11h)		;812e   ; Si esta variable no es 0, hay algo extra que atender
L_8131:
	cp 000h			;8131
	jr z,L_8138		;8133
	call VUELO_CONTROL		;8135   ; Movimiento libre de 8 direcciones: solo en modo vuelo
L_8138:
	call MUEVE_JUGADOR		;8138   ; Avanza un fotograma la animacion/movimiento del jugador
L_813B:
	call COLISIONES_MAPA		;813b   ; Colisiones con el escenario, gravedad y limites de la pantalla
L_813E:
	jp BUCLE_PARTIDA		;813e   ; Cierra el bucle: vuelve al principio

; ----------------------------------------------------------------------
; ############################################################
; MOVIMIENTO DEL JUGADOR: maquina de estados
; ############################################################
; El jugador no se mueve con formulas sino ejecutando una
; SECUENCIA de fotogramas sacada de la tabla de 0x60C0.
; 0x8F0B = estado (que secuencia se esta ejecutando)
; 0x8F0C = paso dentro de la secuencia
; Cada fotograma trae su propio dX y dY, asi que la fisica
; entera (impulso del salto, aceleracion de la caida, inercia)
; es DATO, no codigo.
;
; Estados del jugador, deducidos de la tabla de direcciones
; 0x8CA2, de la de transiciones 0x8C70 y de los propios datos:
; 0 parado          1 andar derecha     2 andar izquierda
; 3 caer derecha    4 caer izquierda    (fase de arranque)
; 5 caer derecha    6 caer izquierda    (bucle, en bucle)
; 7 caida vertical  8 salto vertical
; 9 salto derecha  10 salto izquierda
; 11 volar derecha  12 volar izquierda  13 morir
; El 13 lo comparten los enemigos: 0x87DA les pone ese mismo
; estado cuando se les agota la resistencia.
;
; LA INERCIA DEL MANUAL: en 0x8182 se comprueba 'estado >= 3'
; y si lo es NO SE LEE EL CONTROL aqui. Todos los estados
; aereos son >= 3, o sea que mientras estas en el aire el mando
; no hace nada y el dX de la secuencia de caida te sigue
; arrastrando de lado. (La excepcion es el modo vuelo: los
; estados 11 y 12 tambien son >= 3, pero ahi el control lo lee
; antes 0x857A desde el bucle principal.) Ademas el control
; solo se lee cuando la secuencia entera termina, nunca a
; mitad, asi que el paso minimo andando son los 4 fotogramas
; x 2 px = 8 px.
; ----------------------------------------------------------------------
MUEVE_JUGADOR:		; Avanza un fotograma la secuencia de movimiento del jugador
	ld a,(08f0bh)		;8141   ; Estado actual
L_8144:
	cp 000h			;8144
L_8146:
	jp z,L_8169		;8146   ; Estado 0 (parado): no suena nada
	ld a,(08f0bh)		;8149
	cp 003h			;814c
	jp m,L_8164		;814e   ; Estados 1 y 2 (andando)
	ld a,(08f0bh)		;8151
	cp 00bh			;8154
	jp m,L_815C		;8156   ; Estados 3..10 (en el aire); del 11 en adelante tampoco suena
	jp L_8169		;8159
L_815C:
	ld a,001h		;815c
	ld (0ddadh),a		;815e   ; Arranca el efecto de SALTO/CAIDA: estados 3..10 de 0x8F0B. Dura un frame y se repone en cada vuelta de 0x8141
	jp L_8169		;8161
L_8164:
	ld a,008h		;8164
	ld (0ddach),a		;8166   ; Arranca el efecto de PASO, 8 frames: estados 1 y 2 de 0x8F0B, o sea andando a derecha o a izquierda
L_8169:
	ld a,(08f09h)		;8169   ; B = X del jugador
	ld b,a			;816c
L_816D:
	ld a,(08f0ah)		;816d   ; C = Y del jugador
	ld c,a			;8170
	ld a,(08f0bh)		;8171   ; E = estado
L_8174:
	ld e,a			;8174
	ld a,(08f0ch)		;8175   ; A = paso dentro de la secuencia
L_8178:
	call ANIMA_JUGADOR		;8178   ; Lee el fotograma de la tabla y le suma el desplazamiento a B y C
	jr nz,L_81BF		;817b   ; Z quiere decir que la secuencia se ha agotado (dX = 0x80)
	ld hl,08f0ch		;817d   ; Secuencia agotada: se vuelve al paso 0 de la que venga ahora
L_8180:
	ld (hl),000h		;8180
	ld a,(08f0bh)		;8182   ; Estados 3 en adelante = jugador EN EL AIRE...
L_8185:
	cp 003h			;8185
	jp nc,L_81B3		;8187   ; ...y en el aire el control no se lee aqui: cero control aereo, esa es la inercia
	ld a,001h		;818a   ; BIOS GTSTCK con A=1: joystick del puerto 1

; ----------------------------------------------------------------------
; ############################################################
; LECTURA DEL CONTROL
; ############################################################
; Lee el joystick del puerto 1 y los cursores y hace OR de los
; dos, de modo que valen indistintamente. GTSTCK devuelve la
; direccion en 0..8 (0=centro, 1=arriba y luego en sentido
; horario hasta 8=arriba-izquierda).
; ----------------------------------------------------------------------
LEE_CONTROL:		; Lee joystick + cursores y traduce a codigo de accion
	call 000d5h		;818c   ; BIOS GTSTCK - Returns the joystick status
	ld b,a			;818f   ; Guarda la lectura del joystick...
	ld a,000h		;8190   ; BIOS GTSTCK con A=0: teclas de cursor
	call 000d5h		;8192   ; BIOS GTSTCK - Returns the joystick status | ...y la combina con la de los cursores
	or b			;8195   ; OR de los dos: no hay que elegir control en ningun menu
	cp 000h			;8196   ; Centro: no hay direccion
L_8198:
	jp z,L_81B3		;8198
	cp 004h			;819b   ; Abajo-derecha, abajo y abajo-izquierda se ignoran igual que el centro:
	jp z,L_81B3		;819d
	cp 005h			;81a0   ; el juego no tiene agacharse, asi que las tres cuentan como centro
	jp z,L_81B3		;81a2
	cp 006h			;81a5
	jp z,L_81B3		;81a7
	ld hl,08ca2h		;81aa   ; Traduce la direccion a codigo de accion con la tabla de 0x8CA2
	call INDEXA_TABLA_B		;81ad   ; HL = 0x8CA2 + A (indexado simple, un byte por direccion)
	ld a,(hl)		;81b0
	jr L_81B9		;81b1
L_81B3:
	ld a,(08f0bh)		;81b3   ; Sin direccion util: rutina de "quieto"
L_81B6:
	call SIG_ESTADO		;81b6   ; (asi es como el salto pasa a caida y la caida corta a caida larga)
L_81B9:
	ld (08f0bh),a		;81b9   ; Guarda el codigo de accion como estado del jugador
L_81BC:
	jp MUEVE_JUGADOR		;81bc   ; Vuelve a entrar: ya con el estado nuevo se ejecuta su primer fotograma
L_81BF:
	ld e,000h		;81bf   ; El jugador ocupa las entradas 0 y 1 de la tabla de atributos de sprites
L_81C1:
	push af			;81c1
	ld a,b			;81c2
	ld (08f09h),a		;81c3   ; X ya desplazada
	ld a,c			;81c6
	ld (08f0ah),a		;81c7   ; Y ya desplazada
L_81CA:
	pop af			;81ca
L_81CB:
	call PON_SPRITES		;81cb   ; Escribe los atributos de los dos sprites en la VRAM
L_81CE:
	ld a,(08f0ch)		;81ce
L_81D1:
	inc a			;81d1   ; Siguiente paso de la secuencia
	ld (08f0ch),a		;81d2
	ret			;81d5

; ----------------------------------------------------------------------
; ############################################################
; COLISIONES CONTRA EL MAPA: paredes, suelo, objetos
; ############################################################
; Toda la rutina se gobierna con un BYTE DE FLAGS que depende
; del estado del jugador (tabla 0x8CAB, la lee 0x856F):
; bit 0 -> comprobar la pared IZQUIERDA
; bit 1 -> comprobar el SUELO
; bit 2 -> comprobar la pared DERECHA
; bits 3-5 -> estado al que se pasa si NO hay suelo
; bits 6-7 -> estado al que se pasa al pisar suelo solido
;
; AQUI ESTA LA GRAVEDAD, y es puramente tabular: si no hay
; suelo bajo los pies se conmuta al estado de caida que diga
; el propio byte de flags. Ningun estado aereo lleva el bit 1,
; asi que mientras dura un salto o un vuelo no se mira el suelo
; (flags: 8 = 0x00, 9 = 0x04, 10 = 0x01, 11 y 12 = 0x00). Lo
; que hace que el vuelo no acabe cayendo no es solo eso, sino
; que 0x8C70 encadena 11->11 y 12->12 y que sus fotogramas
; tienen dX = dY = 0. No existe ningun 'si nivel == 4 no
; apliques gravedad': el nivel (0x8F0E) no se lee en ninguna
; parte de la fisica, solo en el marcador y al cambiar de nivel.
; ----------------------------------------------------------------------
COLISIONES_MAPA:		; Choques con el escenario, gravedad y limites de pantalla
	call LEE_FLAGS_ESTADO		;81d6   ; Byte de flags del estado actual
L_81D9:
	srl a			;81d9   ; Bit 0: hay que mirar a la izquierda
	jr nc,L_81EB		;81db
	ld a,(08f09h)		;81dd
	ld b,a			;81e0
	ld a,(08f0ah)		;81e1
	ld c,a			;81e4
	call COLISION_IZQ		;81e5   ; Lee los dos tiles pegados al costado izquierdo del sprite
	call REACCION_TILE		;81e8   ; Y decide: pared que frena, objeto que se coge o nada
L_81EB:
	call LEE_FLAGS_ESTADO		;81eb   ; Bit 2: hay que mirar a la derecha
	srl a			;81ee
	srl a			;81f0
	srl a			;81f2
	jr nc,L_8204		;81f4
	ld a,(08f09h)		;81f6
	ld b,a			;81f9
	ld a,(08f0ah)		;81fa
	ld c,a			;81fd
	call COLISION_DER		;81fe   ; Lee los dos tiles pegados al costado derecho
	call REACCION_TILE		;8201
L_8204:
	call LEE_FLAGS_ESTADO		;8204   ; Byte de flags otra vez...
	ld (08f00h),a		;8207   ; ...y se guarda entero porque hacen falta sus bits altos
L_820A:
	srl a			;820a   ; Bit 1: hay que mirar el suelo
	srl a			;820c
L_820E:
	jr nc,L_826E		;820e
	ld a,(08f09h)		;8210
	ld b,a			;8213
	ld a,(08f0ah)		;8214
	ld c,a			;8217
	call COLISION_SUELO		;8218   ; Tipo de los dos tiles que hay justo bajo los pies
	cp 002h			;821b   ; Tipos 0 y 1 = aire: NO HAY SUELO
	jr nc,L_8241		;821d
	ld a,(08f00h)		;821f   ; Bits 3..5 del byte de flags = estado de caida de este estado
	srl a			;8222
	srl a			;8224
	srl a			;8226
	and 007h		;8228
	ld d,a			;822a
	ld e,a			;822b
	ld a,(08f0bh)		;822c
	sbc a,d			;822f   ; Si ya esta en ese estado no se toca nada (no reinicia la caida)
	cp 000h			;8230
	jp z,L_826E		;8232
	ld hl,08f0bh		;8235   ; Empieza a caer...
	ld (hl),e		;8238
	ld hl,08f0ch		;8239   ; ...desde el primer fotograma de la secuencia
	ld (hl),000h		;823c
	jp L_826E		;823e
L_8241:
	cp 006h			;8241   ; Tipo 6 = suelo/pared solida. El tipo 8 frena de lado pero no sostiene
	jr nz,L_826B		;8243
	ld a,(08f00h)		;8245   ; Bits 6..7 = estado al que se aterriza (1 andar derecha, 2 izquierda, 0 parado)
	srl a			;8248
	srl a			;824a
	srl a			;824c
	srl a			;824e
	srl a			;8250
	srl a			;8252
	and 003h		;8254
	ld d,a			;8256
	ld e,a			;8257
	ld a,(08f0bh)		;8258   ; Si ya estaba en ese estado, seguir sin mas
	sbc a,d			;825b
	cp 000h			;825c
	jr z,L_826E		;825e
	ld hl,08f0bh		;8260
	ld (hl),e		;8263
	ld hl,08f0ch		;8264
	ld (hl),000h		;8267
	jr L_826E		;8269
L_826B:
	call EVENTO_TILE		;826b   ; Cualquier otro tipo de tile: es un objeto o una trampa
L_826E:
	ld a,(08f0bh)		;826e   ; Estados 0..2 = con los pies en el suelo...
L_8271:
	cp 003h			;8271
	jr nc,L_827D		;8273
	ld a,(08f0ah)		;8275   ; ...y entonces la Y se cuadricula a multiplo de 8 para que ande pegado al tile
	and 0f8h		;8278
L_827A:
	ld (08f0ah),a		;827a
L_827D:
	ld a,(08f09h)		;827d   ; El borde IZQUIERDO de la pantalla es un muro: no se puede salir por ahi
L_8280:
	cp 004h			;8280
	jr nc,L_8289		;8282
	ld a,004h		;8284   ; X minima 4 pixeles
	ld (08f09h),a		;8286
L_8289:
	ld a,(08f0ah)		;8289   ; Tocando el techo (Y por debajo de 3)
	cp 003h			;828c
	jr nc,L_82A9		;828e
	ld a,(08f11h)		;8290   ; En modo vuelo el techo no rebota...
	cp 000h			;8293
	jr z,L_829E		;8295
	ld a,004h		;8297   ; ...simplemente se queda pegado a Y=4 y puede flotar ahi
	ld (08f0ah),a		;8299
	jr L_82A9		;829c
L_829E:
	ld a,(08f10h)		;829e   ; Modo normal: se deshace el desplazamiento vertical del fotograma
	ld b,a			;82a1
	ld a,(08f0ah)		;82a2
	sbc a,b			;82a5
	ld (08f0ah),a		;82a6
L_82A9:
	ld a,(08f09h)		;82a9   ; X >= 0xF0: se ha salido por la derecha
L_82AC:
	cp 0f0h			;82ac
	jr c,L_82B3		;82ae
	call SALE_POR_DERECHA		;82b0   ; Cambio de pantalla lateral
L_82B3:
	ld a,(08f0ah)		;82b3   ; Y >= 0x70: se ha caido por debajo del escenario
	cp 070h			;82b6
	jr c,L_82BD		;82b8
	call SALE_POR_ABAJO		;82ba   ; Cambio de pantalla hacia abajo (0x8702 hace el scroll de 17 filas)
L_82BD:
	ret			;82bd

; ----------------------------------------------------------------------
; Entra E = numero de animacion, A = fotograma, B/C = X/Y actuales.
; Sale HL = 0x60C0 + E*128 + A*4, con la entrada de 4 bytes:
; +0 dx  +1 dy  +2 figura de sprite  +3 colores empaquetados
; Si dx vale 0x80 la secuencia ha terminado y vuelve con Z.
; ############################################################
; MOTOR DE ANIMACION Y MOVIMIENTO (tabla de 0x60C0)
; ############################################################
; Entra:  B = X, C = Y, E = estado, A = paso
; Sale:   B,C = posicion ya desplazada; D = patron; A = colores
; Z si la secuencia se ha terminado (dX == 0x80)
; La usan tanto el jugador (0x8178) como los enemigos (0x874A).
; Cuidado al tocar la salida: los flags con los que vuelve por
; el camino normal son los del 'add a,c' de 0x8304, asi que si
; la Y resultante fuese 0 devolveria Z y el llamador creeria
; que la secuencia se ha agotado. En la practica no pasa porque
; la Y nunca baja de 3.
; ----------------------------------------------------------------------
ANIMA_JUGADOR:		; Motor de animacion: indexa estado*128 + paso*4; 4 bytes por fotograma y 0x80 como terminador
	ld d,000h		;82be   ; Los siete desplazamientos siguientes hacen DE = estado * 128
L_82C0:
	sla e			;82c0   ; Siete desplazamientos: DE = animacion * 128 (una ranura por animacion)
L_82C2:
	rl d			;82c2
L_82C4:
	sla e			;82c4
	rl d			;82c6
L_82C8:
	sla e			;82c8
L_82CA:
	rl d			;82ca
L_82CC:
	sla e			;82cc
L_82CE:
	rl d			;82ce
L_82D0:
	sla e			;82d0
L_82D2:
	rl d			;82d2
L_82D4:
	sla e			;82d4
L_82D6:
	rl d			;82d6
L_82D8:
	sla e			;82d8
	rl d			;82da
L_82DC:
	sla a			;82dc   ; A*4 porque cada fotograma ocupa 4 bytes
L_82DE:
	sla a			;82de
L_82E0:
	ld h,000h		;82e0
	ld l,a			;82e2
	add hl,de		;82e3
L_82E4:
	ld de,060c0h		;82e4   ; Base de la tabla de animaciones
L_82E7:
	add hl,de		;82e7
L_82E8:
	ld d,h			;82e8
L_82E9:
	ld e,l			;82e9
	ld iy,00000h		;82ea
	add iy,de		;82ee
L_82F0:
	ld a,(iy+000h)		;82f0   ; Byte 0 del fotograma: desplazamiento en X
L_82F3:
	ld (08f0fh),a		;82f3   ; Deja el dx del fotograma en 0x8F0F, que usa el codigo de colisiones
L_82F6:
	cp 080h			;82f6   ; 0x80 no es un desplazamiento valido: marca el final de la secuencia
L_82F8:
	ret z			;82f8
L_82F9:
	ld a,(iy+000h)		;82f9
L_82FC:
	add a,b			;82fc   ; dx se suma a la X que traia el llamante
	ld b,a			;82fd
L_82FE:
	ld a,(iy+001h)		;82fe   ; Byte 1: desplazamiento en Y
L_8301:
	ld (08f10h),a		;8301   ; Y el dy queda en 0x8F10 antes de sumarse a la Y
	add a,c			;8304   ; Y += dY
	ld c,a			;8305
L_8306:
	ld d,(iy+002h)		;8306   ; D = figura, A = colores; los usa 0x8333 para montar los sprites
L_8309:
	ld a,(iy+003h)		;8309   ; Byte 3: los dos colores del sprite, un nibble cada uno
L_830C:
	ret			;830c
SIG_ESTADO:		; Tabla 0x8C70: que estado sigue cuando la secuencia se agota
	ld hl,08c70h		;830d
	call INDEXA_TABLA_B		;8310
	ld a,(hl)		;8313
	ret			;8314

; ----------------------------------------------------------------------
; Escribe 0xD1 en la coordenada Y de las 64 entradas de la
; tabla de atributos. 0xD1 deja el sprite por debajo de la
; pantalla y, a diferencia de 0xD0, no le dice al VDP que deje
; de dibujar sprites a partir de esa entrada.
; ----------------------------------------------------------------------
OCULTA_SPRITES:		; Manda los 64 sprites fuera de la pantalla
	ld hl,01b00h		;8315
L_8318:
	ld a,0d1h		;8318   ; 0xD1: por debajo del borde inferior
	call 0004dh		;831a   ; BIOS WRTVRM - Writes data in VRAM
	ld bc,00004h		;831d   ; Cuatro bytes por entrada de la tabla de atributos
	add hl,bc		;8320
	ld a,h			;8321
	cp 01ch			;8322   ; Hasta 0x1C00, o sea las 64 entradas
	jr z,L_8329		;8324
	jp L_8318		;8326
L_8329:
	ret			;8329
CHK_ABANDONAR:		; Comprueba CTRL+STOP y si esta pulsado abandona la partida
	push af			;832a
	call 000b7h		;832b   ; BIOS BREAKX - Tests status of CTRL-STOP | BIOS BREAKX: devuelve carry si CTRL+STOP esta pulsado
L_832E:
	call c,GAME_OVER		;832e   ; Confirma lo que dice el manual: se abandona con CTRL+STOP
L_8331:
	pop af			;8331
L_8332:
	ret			;8332

; ----------------------------------------------------------------------
; El jugador se dibuja con DOS sprites superpuestos de 16x16,
; truco clasico del MSX1 para tener dos colores. El byte de
; color de la tabla de animacion trae los dos empaquetados.
; En los estados 0..12 vale siempre 0x9F (blanco delante,
; rojo claro detras); el estado 13, el de morir, va alternando
; 0xAF, 0xA9 y 0x68 fotograma a fotograma para que parpadee.
; ----------------------------------------------------------------------
PON_SPRITES:		; Monta el par de sprites de una figura en VRAM
	ld iy,08f01h		;8333   ; Buffer de 8 bytes = 2 entradas de la tabla de atributos
	ld (iy+000h),c		;8337   ; Coordenada Y, la misma para los dos sprites
L_833A:
	ld (iy+004h),c		;833a
L_833D:
	ld (iy+001h),b		;833d   ; Coordenada X, tambien compartida
L_8340:
	ld (iy+005h),b		;8340
L_8343:
	sla d			;8343   ; La figura se multiplica por 4: es el numero de patron de un sprite 16x16
L_8345:
	sla d			;8345
L_8347:
	ld (iy+002h),d		;8347
L_834A:
	inc d			;834a   ; El segundo sprite va 4 patrones despues: cada bicho son dos capas superpuestas
	inc d			;834b
L_834C:
	inc d			;834c
	inc d			;834d
	ld (iy+006h),d		;834e
L_8351:
	push af			;8351
L_8352:
	and 00fh		;8352   ; Nibble bajo = color del plano E, que al ser el de numero menor va delante
	ld (iy+003h),a		;8354
L_8357:
	pop af			;8357
L_8358:
	and 0f0h		;8358   ; Nibble alto = color del plano E+1, el de detras
	srl a			;835a
L_835C:
	srl a			;835c
L_835E:
	srl a			;835e
L_8360:
	srl a			;8360
L_8362:
	ld (iy+007h),a		;8362
L_8365:
	ld d,000h		;8365   ; DE = numero de sprite * 4 = desplazamiento en la tabla de atributos
	sla e			;8367
L_8369:
	rl d			;8369
	sla e			;836b
	rl d			;836d
L_836F:
	ld hl,01b00h		;836f   ; Atributos de sprite en VRAM 0x1B00, 8 bytes = planos E y E+1
L_8372:
	add hl,de		;8372
L_8373:
	ld d,h			;8373
	ld e,l			;8374
L_8375:
	ld hl,08f01h		;8375
	ld bc,00008h		;8378
	call 0005ch		;837b   ; BIOS LDIRVM - Block transfers to VRAM from memory | BIOS LDIRVM: sube las dos entradas de golpe
	ret			;837e

; ----------------------------------------------------------------------
; ############################################################
; QUE HAY EN ESTE PUNTO DEL ESCENARIO
; ############################################################
; Entra A = coordenada Y en pixeles, C = coordenada X en
; pixeles. Sale A = tipo de tile, de 0 a 8.
; El mapa de la pantalla actual vive en 0x7D80: 16 filas de 32
; columnas, un byte por casilla. Lo rellena 0x8ACE desde
; 0x9000 + pantalla*512 y 0x8AFC lo vuelca a VRAM 0x1800.
;
; Clasificacion (los cortes salen de las comparaciones de aqui
; abajo y el efecto de cada tipo, de 0x8446 y 0x8463):
; tipo 0  tile < 0xA9    fondo, se atraviesa
; tipo 1  tile = 0xA9    tampoco hace nada
; tipo 2  tile = 0xAA    ALITAS: activan el modo vuelo
; tipo 3  tile = 0xAB    VIDA EXTRA
; tipo 4  tile = 0xAC    MUNICION
; tipo 5  tile = 0xAD    ARMA
; tipo 6  0xAE..0xEC    SOLIDO: pared y suelo
; tipo 7  0xED..0xF6    MATA de un toque
; tipo 8  >= 0xF7       frena de lado pero no cuenta como suelo
; ----------------------------------------------------------------------
LEE_TILE:		; Devuelve el tipo (0..8) del tile que hay en (C=X, A=Y)
	srl c			;837f   ; Columna = X / 8 (C trae la X)
L_8381:
	srl c			;8381
L_8383:
	srl c			;8383
L_8385:
	and 0f8h		;8385   ; A trae la Y: quitandole los 3 bits bajos queda fila*8...
L_8387:
	ld d,000h		;8387
L_8389:
	ld e,a			;8389
L_838A:
	sla e			;838a   ; ...y multiplicado por 4 da fila*32, porque el mapa tiene 32 columnas
L_838C:
	rl d			;838c
L_838E:
	sla e			;838e
L_8390:
	rl d			;8390
L_8392:
	ld hl,07d80h		;8392   ; Buffer del mapa de la pantalla actual
L_8395:
	add hl,de		;8395
L_8396:
	ld a,c			;8396
L_8397:
	call INDEXA_TABLA_B		;8397   ; Suma la columna
L_839A:
	ld a,(hl)		;839a   ; Codigo del tile
L_839B:
	push af			;839b
L_839C:
	ld a,0ffh		;839c   ; Secuencia muerta: el push af / pop af restaura tambien los flags, asi que estas cuatro instrucciones no hacen absolutamente nada
L_839E:
	rl a			;839e
L_83A0:
	pop af			;83a0
CLASIFICA_TILE:		; Entrada suelta: convierte el tile que hay en A en un tipo 0..8
	cp 0a9h			;83a1   ; A partir de aqui, una escalera de comparaciones que traduce el codigo de tile a tipo
L_83A3:
	jr nc,L_83A8		;83a3
L_83A5:
	ld a,000h		;83a5
L_83A7:
	ret			;83a7
L_83A8:
	cp 0aah			;83a8
	jr nc,L_83AF		;83aa
	ld a,001h		;83ac
	ret			;83ae
L_83AF:
	cp 0abh			;83af
	jr nc,L_83B6		;83b1
	ld a,002h		;83b3
	ret			;83b5
L_83B6:
	cp 0ach			;83b6
	jr nc,L_83BD		;83b8
	ld a,003h		;83ba
	ret			;83bc
L_83BD:
	cp 0adh			;83bd
	jr nc,L_83C4		;83bf
	ld a,004h		;83c1
	ret			;83c3
L_83C4:
	cp 0aeh			;83c4
	jr nc,L_83CB		;83c6
	ld a,005h		;83c8
	ret			;83ca
L_83CB:
	cp 0edh			;83cb
	jr nc,L_83D2		;83cd
	ld a,006h		;83cf
	ret			;83d1
L_83D2:
	cp 0f7h			;83d2
	jr nc,L_83D9		;83d4
	ld a,007h		;83d6
	ret			;83d8
L_83D9:
	ld a,008h		;83d9
	ret			;83db

; ----------------------------------------------------------------------
; Las cuatro rutinas que siguen leen DOS tiles cada una, los
; dos extremos del lado del sprite que toca comprobar, y
; devuelven el MAYOR de los dos tipos (0x843A). Como los tipos
; estan ordenados de menos a mas importante, gana siempre lo
; mas peligroso: si un pie pisa aire y el otro un pincho, mata.
; ----------------------------------------------------------------------
COLISION_IZQ:		; Tipo de tile en el costado izquierdo: (X-1,Y) y (X-1,Y+15)
	push bc			;83dc
L_83DD:
	dec b			;83dd
	ld a,c			;83de
	ld c,b			;83df
	call LEE_TILE		;83e0
	pop bc			;83e3
L_83E4:
	push af			;83e4
	ld a,00fh		;83e5
L_83E7:
	add a,c			;83e7
L_83E8:
	dec b			;83e8
	ld c,b			;83e9
L_83EA:
	call LEE_TILE		;83ea
L_83ED:
	jp MAX_TIPO		;83ed
COLISION_SUELO:		; Tipo de tile bajo los pies: (X+2,Y+16) y (X+13,Y+16)
	push bc			;83f0
	inc b			;83f1
	inc b			;83f2
	ld a,010h		;83f3
	add a,c			;83f5
	ld c,b			;83f6
	call LEE_TILE		;83f7
	pop bc			;83fa
	push af			;83fb
	ld a,00dh		;83fc
	add a,b			;83fe
	ld d,a			;83ff
	ld a,010h		;8400
	add a,c			;8402
	ld c,d			;8403
	call LEE_TILE		;8404
	jp MAX_TIPO		;8407
COLISION_DER:		; Tipo de tile en el costado derecho: (X+16,Y) y (X+16,Y+15)
	push bc			;840a
L_840B:
	ld a,010h		;840b
L_840D:
	add a,b			;840d
	ld d,a			;840e
	ld a,c			;840f
L_8410:
	ld c,d			;8410
	call LEE_TILE		;8411
	pop bc			;8414
	push af			;8415
L_8416:
	ld a,010h		;8416
	add a,b			;8418
	ld d,a			;8419
	ld a,00fh		;841a
L_841C:
	add a,c			;841c
	ld c,d			;841d
L_841E:
	call LEE_TILE		;841e
	jp MAX_TIPO		;8421

; ----------------------------------------------------------------------
; Solo la llama la rutina de vuelo (0x85D1): en el juego
; normal nunca hace falta mirar hacia arriba porque el salto
; no comprueba techos.
; ----------------------------------------------------------------------
COLISION_ARRIBA:		; Tipo de tile sobre la cabeza: (X,Y-1) y (X+15,Y-1)
	push bc			;8424
	dec c			;8425
	ld a,c			;8426
	ld c,b			;8427
	call LEE_TILE		;8428
	pop bc			;842b
	push af			;842c
	dec c			;842d
	ld a,00fh		;842e
	add a,b			;8430
	ld d,c			;8431
	ld c,a			;8432
	ld a,d			;8433
	call LEE_TILE		;8434
	jp MAX_TIPO		;8437
MAX_TIPO:		; Se queda con el mayor de los dos tipos leidos
	pop de			;843a
L_843B:
	push de			;843b
L_843C:
	push af			;843c
L_843D:
	sbc a,d			;843d
L_843E:
	jr c,L_8443		;843e
	pop af			;8440
	pop de			;8441
	ret			;8442
L_8443:
	pop de			;8443
L_8444:
	pop af			;8444
L_8445:
	ret			;8445
REACCION_TILE:		; Decide que hacer con el tipo de tile que se ha tocado de lado
	cp 000h			;8446   ; Tipo 0: aire, nada que hacer
	ret z			;8448
	cp 001h			;8449   ; Tipo 1: tampoco
	ret z			;844b
	cp 006h			;844c   ; Tipos 6 y 8 son solidos: frenan
	jr z,L_8456		;844e
	cp 008h			;8450
	jr z,L_8456		;8452
	jr EVENTO_TILE		;8454   ; El resto son objetos o trampas
L_8456:
	ld a,(08f0fh)		;8456   ; dX del fotograma que se acaba de aplicar...
	ld d,a			;8459
	ld a,(08f09h)		;845a
	sbc a,d			;845d   ; ...se le resta a la X, o sea se deshace el paso contra la pared
	ld hl,08f09h		;845e
	ld (hl),a		;8461
	ret			;8462

; ----------------------------------------------------------------------
; ############################################################
; OBJETOS Y TRAMPAS
; ############################################################
; Punto unico por el que pasan todos los objetos: lo llaman
; las cuatro rutinas de vuelo y el sondeo del suelo (0x826B),
; y ademas se entra por salto desde 0x8446 en los laterales,
; siempre con A = tipo del tile en el que ha entrado el jugador.
; ----------------------------------------------------------------------
EVENTO_TILE:		; Aplica el efecto del objeto o la trampa que se ha tocado
	cp 002h			;8463   ; Tipo 2 = las ALITAS (tile 0xAA)
	jr nz,OBJETO_TIPO_7		;8465
	ld a,001h		;8467   ; Activa el MODO VUELO...
	ld (08f11h),a		;8469   ; Enciende el modo VUELO (?): 0x812E llama a 0x857A mientras esto valga 1, y 0x857A lee GTSTCK para mover al jugador arriba y abajo a voluntad
	ld a,00bh		;846c   ; ...y pasa al estado 11, que se encadena consigo mismo y no comprueba suelo: se flota
	ld (08f0bh),a		;846e
	ld a,000h		;8471
	ld (08f0ch),a		;8473
	ld a,0aah		;8476   ; Borra del mapa el tile de las alitas (0x8AE3 lo busca con CPIR y lo pone a 0) para que no se pueda coger dos veces
	call BORRA_OBJETO_MAPA		;8478   ; Borra las alitas del mapa
	ld a,073h		;847b
	ld (0ddb3h),a		;847d   ; Ruido pulsante de 115 frames al recoger el objeto de tipo 2: 0x8AE3 le acaba de borrar el tile 0xAA de la pantalla y 0x8F11 queda a 1. NO es la muerte: aqui no se pierde vida
	ld a,0fbh		;8480
	ld (0ddb2h),a		;8482   ; El mismo barrido ascendente que los otros tres objetos: es una recogida mas
	ld a,(08f0ah)		;8485
	and 0feh		;8488   ; Cuadricula la Y a par para que el vuelo no quede a medio pixel
	ld (08f0ah),a		;848a
	ret			;848d
OBJETO_TIPO_7:		; Sigue el reparto por tipos: el 7 es terreno mortal
	cp 007h			;848e   ; Tipo 7 = tile mortal (0xED..0xF6)
	jp nz,COGE_VIDA		;8490

; ----------------------------------------------------------------------
; ############################################################
; MUERTE Y REAPARICION DEL JUGADOR
; ############################################################
; La animacion de morir son 10 vueltas de dos fotogramas, y la
; secuencia 0x0D de la tabla de 0x60C0 tiene exactamente 10
; pasos: dX y dY a cero y el sprite alternando cuatro patrones
; (0x12, 0x14, 0x16, 0x18) con cambios de color. Los enemigos y
; los proyectiles siguen moviendose durante toda la muerte y
; toda la espera.
; ----------------------------------------------------------------------
MUERE_JUGADOR:		; Animacion de muerte, resta de vida y reaparicion
	ld a,(08f11h)		;8493   ; Guarda el modo de vuelo: al reaparecer se recupera tal cual, asi que en el nivel 4 se sigue nadando
	push af			;8496
	ld a,0ech		;8497   ; Efecto de sonido de la muerte (ranura 3)
	ld (0ddafh),a		;8499   ; Trino de MUERTE del jugador en el canal B, 20 frames. Se llega aqui desde 0x87F4, que mira el bit de colision de sprites de STATFL, y 20 instrucciones despues 0x84C9 quita la vida
	ld a,000h		;849c
	ld (08f0ch),a		;849e
	ld a,00dh		;84a1   ; Estado 13 = animacion de morir
	ld (08f0bh),a		;84a3
	ld a,00ah		;84a6   ; Diez pasadas de esa animacion antes de descontar la vida
	ld (08f1ah),a		;84a8
L_84AB:
	call MUEVE_JUGADOR		;84ab   ; Solo se anima y se pinta: durante la muerte no se leen ni control ni colisiones
	call MUEVE_ENEMIGOS		;84ae   ; Los enemigos siguen a lo suyo mientras el jugador muere
	call MUEVE_DISPAROS		;84b1
	call SFX_FRAME		;84b4
	halt			;84b7   ; Dos fotogramas por vuelta, igual que el bucle principal
	call SFX_FRAME		;84b8
	halt			;84bb
	ld a,(08f1ah)		;84bc
	dec a			;84bf
	ld (08f1ah),a		;84c0
	cp 000h			;84c3
	jr z,QUITA_VIDA		;84c5
	jr L_84AB		;84c7

; ----------------------------------------------------------------------
; ############################################################
; QUITAR UNA VIDA
; ############################################################
; Poner un NOP (0x00) en el DEC A de 0x84CC da vidas infinitas:
; A no cambia, el CP 0FFh nunca da cero y se reescribe el mismo
; valor. Es el POKE de "MSX Book II" con la direccion corregida.
; ----------------------------------------------------------------------
QUITA_VIDA:		; Resta una vida y salta a game over si no quedan
	ld a,(08f12h)		;84c9   ; A = vidas actuales
	dec a			;84cc   ; Aqui va el parche de vidas infinitas (0x3D -> 0x00)
	cp 0ffh			;84cd   ; Se compara con 0xFF porque al bajar de 0 el DEC A desborda
	jp z,GAME_OVER		;84cf   ; No quedan vidas: game over
	ld (08f12h),a		;84d2   ; Guarda el nuevo contador
	call PINTA_MARCADOR		;84d5   ; Y repinta el marcador para que se vea
	ld a,(08f13h)		;84d8   ; Reaparicion: se restauran X, Y, estado y paso guardados al entrar en la pantalla (0x8670)
	ld (08f09h),a		;84db
	ld a,(08f14h)		;84de   ; Reaparicion: Y de entrada a la pantalla
	ld (08f0ah),a		;84e1
	ld a,(08f1ch)		;84e4   ; Reaparicion: secuencia con la que entro
	ld (08f0bh),a		;84e7
	ld a,(08f1dh)		;84ea   ; Reaparicion: paso de esa secuencia
	ld (08f0ch),a		;84ed
	pop af			;84f0   ; Y tambien el modo vuelo que se habia apilado
	ld (08f11h),a		;84f1
	ld a,0c0h		;84f4   ; Rellena con 0xC0 cinco bytes desde 0x1B00: pisa las dos coordenadas Y (0x1B00 y 0x1B04) y con eso esconde los dos sprites del jugador
	ld bc,00005h		;84f6
	ld hl,01b00h		;84f9
	call 00056h		;84fc   ; BIOS FILVRM - Fills VRAM with value
L_84FF:
	call MUEVE_ENEMIGOS		;84ff   ; Se queda pintando la pantalla hasta que pulsen disparo para seguir
	call MUEVE_DISPAROS		;8502
	halt			;8505
	halt			;8506
	ld a,000h		;8507   ; GTTRIG: no se revive hasta que se vuelve a pulsar disparo
	call 000d8h		;8509   ; BIOS GTTRIG - Returns current trigger status | GTTRIG con A=0: barra espaciadora
	ld e,a			;850c
	ld a,001h		;850d
	call 000d8h		;850f   ; BIOS GTTRIG - Returns current trigger status | GTTRIG con A=1: boton del joystick
	or e			;8512
	cp 000h			;8513
	jp z,L_84FF		;8515
	ret			;8518
COGE_VIDA:		; Tipo 3: vida extra
	cp 003h			;8519   ; Tipo 3 = VIDA EXTRA (tile 0xAB)
	jp nz,COGE_MUNICION		;851b
	ld a,0fbh		;851e   ; Efecto de sonido de recogida
	ld (0ddb2h),a		;8520   ; Barrido ascendente: vida extra recogida
	ld a,0abh		;8523   ; Borra del mapa el tile 0xAB
	call BORRA_OBJETO_MAPA		;8525   ; Borra el tile del mapa
DA_VIDA:		; Suma una vida (tope 10)
	ld a,(08f12h)		;8528   ; A = vidas actuales
	inc a			;852b   ; Una vida mas...
	cp 00ah			;852c   ; Compara con 10 y sale SIN GUARDAR, asi que las vidas se quedan clavadas en 9: con 9 el INC A da 10, salta el RET Z y no se escribe nada. El tope real es 9, no 10 [SUSTITUYE]
	ret z			;852e
	ld (08f12h),a		;852f
	call PINTA_MARCADOR		;8532
	ret			;8535
COGE_MUNICION:		; Tipo 4: un icono mas de municion
	cp 004h			;8536   ; Tipo 4 = MUNICION (tile 0xAC)
	jp nz,COGE_ARMA		;8538
	ld a,0fbh		;853b
	ld (0ddb2h),a		;853d   ; Barrido ascendente: municion recogida
	ld a,0ach		;8540   ; Borra del mapa el tile 0xAC
	call BORRA_OBJETO_MAPA		;8542
	ld a,(08f17h)		;8545   ; Numero de proyectiles que pueden volar a la vez
	inc a			;8548   ; Un icono mas de municion; al llegar a 7 no se guarda, o sea tope real 6
	cp 007h			;8549   ; Tope 6: si llegara a 7 no lo guarda
	ret z			;854b
	ld (08f17h),a		;854c
	call PINTA_MARCADOR		;854f
	ret			;8552
COGE_ARMA:		; Tipo 5: pasa a la siguiente arma
	cp 005h			;8553   ; Tipo 5 = ARMA (tile 0xAD)
	ret nz			;8555
	ld a,0fbh		;8556
	ld (0ddb2h),a		;8558   ; Barrido ascendente: arma nueva recogida
	ld a,0adh		;855b   ; Borra del mapa el tile 0xAD
	call BORRA_OBJETO_MAPA		;855d
	ld a,(08f18h)		;8560   ; Tipo de arma
	inc a			;8563   ; Siguiente tipo de arma; al llegar a 4 no se guarda, o sea tope real 3
	cp 004h			;8564   ; Cuatro armas, de la 0 a la 3
	ret z			;8566
	ld (08f18h),a		;8567
	call PINTA_MARCADOR		;856a
	ret			;856d

; ----------------------------------------------------------------------
; DATOS ret_huerfano_1: Un RET (0xC9) que no se alcanza por ningun camino: la rutina de antes ya cierra con el RET de 0x856D. Ningun acceso en una partida completa.
;   0x856e..0x856f  (1 bytes)
; ----------------------------------------------------------------------
	defb 0c9h	; 856e  .

; ======================================================================
; CODIGO 0x856f..0x8a36  (1223 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; MASCARA DE SONDEOS DEL TERRENO
; ############################################################
; Devuelve el byte de 0x8CAB indexado por la secuencia en curso.
; Ese byte lo consume 0x81D6 y esta empaquetado asi:
; bit 0    hay que sondear a la IZQUIERDA
; bit 1    hay que sondear ABAJO (suelo)
; bit 2    hay que sondear a la DERECHA
; bits 3-5 secuencia a la que pasar si NO hay suelo (caer)
; bits 6-7 secuencia a la que pasar al pisar suelo (aterrizar)
; Comprobado: secuencia 1 (andar dcha) -> 0x5E = abajo+dcha,
; cae a la 3 y aterriza en la 1; secuencia 2 (andar izq) ->
; 0xA3 = izq+abajo, cae a la 4 y aterriza en la 2. Las
; secuencias de vuelo 0x0B y 0x0C dan mascara 0: en vuelo no
; se sondea nada aqui, lo hace 0x857A por su cuenta.
; ----------------------------------------------------------------------
LEE_FLAGS_ESTADO:		; Devuelve el byte de flags de colision del estado actual (tabla 0x8CAB)
	ld a,(08f0bh)		;856f   ; Indice: la secuencia de movimiento que ejecuta el jugador
L_8572:
	ld hl,08cabh		;8572   ; Tabla de mascaras, un byte por secuencia (solo indices 0x00-0x0C)
L_8575:
	call INDEXA_TABLA_B		;8575
L_8578:
	ld a,(hl)		;8578
L_8579:
	ret			;8579

; ----------------------------------------------------------------------
; ############################################################
; MODO VUELO: las 8 direcciones libres, sin gravedad
; ############################################################
; El bucle principal solo llama aqui si 0x8F11 no es 0.
; Ese flag se pone a 1 en dos sitios:
; 0x8469  al coger las alitas (tile 0xAA)
; 0x8B62  al salir de la pantalla 20, o sea al entrar en la
; 21, que es la primera del NIVEL 4
; y se apaga en 0x8B37 al entrar en el nivel 3 y en 0x80EF al
; empezar partida; 0x8493/0x84F1 lo apilan y lo restauran al
; morir, asi que en el nivel 4 se sigue nadando tras perder una
; vida. Es decir, el nivel 4 no tiene fisica propia: reutiliza
; el mismo modo de las alitas, pero encendido de entrada. Ahi
; el estado se fuerza a 11, que en 0x8C70 se encadena consigo
; mismo y cuyos fotogramas tienen dX = dY = 0, de modo que el
; jugador solo se mueve por lo que haga esta rutina. Ninguna
; instruccion de la fisica consulta el numero de nivel (0x8F0E).
; Aqui el movimiento es directo, 2 pixeles por eje y por VUELTA
; del bucle (que son dos frames de VDP), sin tabla de animacion
; ni inercia ninguna.
; ############################################################
; MOVIMIENTO LIBRE EN 8 DIRECCIONES (modo VUELO)
; ############################################################
; Solo se llama desde 0x8135, y solo si 0x8F11 != 0, o sea
; cuando el jugador lleva las alitas (tile 0xAA) o esta en el
; nivel 4, donde 0x8B55 enciende el vuelo permanente. Aqui no
; hay gravedad: el mando mueve directamente 2 pixeles por eje.
; Las secuencias 0x0B/0x0C (volar) solo animan el sprite, su
; dX y dY son 0, por eso el desplazamiento lo hace esta rutina.
; ----------------------------------------------------------------------
VUELO_CONTROL:		; Movimiento libre de 8 direcciones (nivel 4 y alitas)
	ld a,001h		;857a   ; GTSTCK con A=1 (joystick)...
	call 000d5h		;857c   ; BIOS GTSTCK - Returns the joystick status | GTSTCK joystick
	ld b,a			;857f
	ld a,000h		;8580   ; ...y con A=0 (cursores); se hace OR de los dos
	call 000d5h		;8582   ; BIOS GTSTCK - Returns the joystick status | GTSTCK cursores
	or b			;8585
	cp 000h			;8586
	ret z			;8588
	cp 001h			;8589   ; Arriba
	jr nz,L_8591		;858b
	call VUELO_ARRIBA		;858d
	ret			;8590
L_8591:
	cp 002h			;8591   ; Arriba-derecha: se combinan las dos rutinas de un eje cada una
	jr nz,L_859C		;8593
	call VUELO_ARRIBA		;8595
	call VUELO_DERECHA		;8598
	ret			;859b
L_859C:
	cp 003h			;859c   ; Derecha
	jr nz,L_85A4		;859e
	call VUELO_DERECHA		;85a0
	ret			;85a3
L_85A4:
	cp 004h			;85a4   ; Abajo-derecha
	jr nz,L_85AF		;85a6
	call VUELO_DERECHA		;85a8
	call VUELO_ABAJO		;85ab
	ret			;85ae
L_85AF:
	cp 005h			;85af   ; Abajo: en modo vuelo el abajo SI vale, al contrario que andando
	jr nz,L_85B7		;85b1
	call VUELO_ABAJO		;85b3
	ret			;85b6
L_85B7:
	cp 006h			;85b7   ; Abajo-izquierda
	jr nz,L_85C2		;85b9
	call VUELO_ABAJO		;85bb
	call VUELO_IZQUIERDA		;85be
	ret			;85c1
L_85C2:
	cp 007h			;85c2   ; Izquierda
	jr nz,L_85CA		;85c4
	call VUELO_IZQUIERDA		;85c6
	ret			;85c9
L_85CA:
	call VUELO_ARRIBA		;85ca   ; Lo que queda es arriba-izquierda
	call VUELO_IZQUIERDA		;85cd
	ret			;85d0
VUELO_ARRIBA:		; Sube 2 pixeles si el techo lo permite
	ld a,(08f09h)		;85d1
	ld b,a			;85d4
	ld a,(08f0ah)		;85d5
	ld c,a			;85d8
	call COLISION_ARRIBA		;85d9   ; Tile sobre la cabeza; solo aqui se usa la comprobacion de arriba
	cp 006h			;85dc   ; Tipo 6: pared solida, no se sube. Aqui el tipo 8 no frena, al contrario que de lado
	jr nz,L_85E1		;85de
	ret			;85e0
L_85E1:
	call EVENTO_TILE		;85e1   ; Si es un objeto se recoge al pasar, y si es mortal mata
	ld a,(08f0ah)		;85e4
	dec a			;85e7   ; Dos pixeles por vuelta
	dec a			;85e8
	ld (08f0ah),a		;85e9
	ret			;85ec
VUELO_ABAJO:		; Baja 2 pixeles si no hay suelo debajo
	ld a,(08f09h)		;85ed
	ld b,a			;85f0
	ld a,(08f0ah)		;85f1
	ld c,a			;85f4
	call COLISION_SUELO		;85f5   ; Sondea las dos esquinas de abajo del sprite
	cp 006h			;85f8
	jr nz,L_85FD		;85fa
	ret			;85fc
L_85FD:
	call EVENTO_TILE		;85fd
	ld a,(08f0ah)		;8600
	inc a			;8603
	inc a			;8604
	ld (08f0ah),a		;8605
	ret			;8608
VUELO_IZQUIERDA:		; Avanza 2 pixeles a la izquierda
	ld a,00ch		;8609   ; Estado 12 = sprite mirando a la izquierda
	ld (08f0bh),a		;860b
	ld a,(08f09h)		;860e
	ld b,a			;8611
	ld a,(08f0ah)		;8612
	ld c,a			;8615
	call COLISION_IZQ		;8616   ; Sondea el lateral izquierdo
	cp 006h			;8619
	ret z			;861b
	cp 008h			;861c   ; Tipos 6 y 8 frenan igual que andando
	ret z			;861e
	call EVENTO_TILE		;861f
	ld a,(08f09h)		;8622
	dec a			;8625
	dec a			;8626
	ld (08f09h),a		;8627
	ret			;862a
VUELO_DERECHA:		; Avanza 2 pixeles a la derecha
	ld a,00bh		;862b   ; Estado 11 = sprite mirando a la derecha
	ld (08f0bh),a		;862d
	ld a,(08f09h)		;8630
	ld b,a			;8633
	ld a,(08f0ah)		;8634
	ld c,a			;8637
	call COLISION_DER		;8638
	cp 006h			;863b
	ret z			;863d
	cp 008h			;863e
	ret z			;8640
	jr L_8643		;8641
L_8643:
	call EVENTO_TILE		;8643
	ld a,(08f09h)		;8646
	inc a			;8649
	inc a			;864a
	ld (08f09h),a		;864b
	ret			;864e

; ----------------------------------------------------------------------
; ############################################################
; CAMBIO DE PANTALLA
; ############################################################
; Dos puntos de entrada, uno por borde de salida. Los llama
; 0x82B0 / 0x82BA, que vigilan si el jugador ha rebasado
; X >= 0xF0 (borde derecho) o Y >= 0x70 (borde inferior).
; ----------------------------------------------------------------------
SALE_POR_DERECHA:		; Sale por el borde derecho: reaparece pegado al borde izquierdo
	ld a,002h		;864f   ; X = 2: entra por el lado izquierdo de la pantalla nueva
	ld (08f09h),a		;8651
	call OCULTA_SPRITES		;8654   ; Esconde todos los sprites poniendo Y = 0xD1, fuera de pantalla
	jp FIN_DE_PANTALLA		;8657   ; Filtro de fin de nivel: mira si esta pantalla cierra un nivel
CAMBIO_PANT_NORMAL:		; Transicion corriente entre pantallas del mismo nivel
	call 00090h		;865a   ; BIOS GICINI - Initialises PSG and sets initial value for the PLAY statement | GICINI: reinicia el PSG y corta el efecto que estuviera sonando
	call CORTINILLA		;865d   ; Dibuja la pantalla nueva con su efecto de entrada
	jr FIJA_REAPARICION		;8660
SALE_POR_ABAJO:		; Sale por el borde inferior: reaparece arriba
	ld a,004h		;8662   ; Y = 4: entra por la parte de arriba de la pantalla nueva
	ld (08f0ah),a		;8664
	call OCULTA_SPRITES		;8667
	call 00090h		;866a   ; BIOS GICINI - Initialises PSG and sets initial value for the PLAY statement
	call SCROLL_A_PANTALLA_SIGUIENTE		;866d   ; Transicion con desplazamiento vertical

; ----------------------------------------------------------------------
; Cola comun de las dos entradas: aqui se fija el PUNTO DE
; REAPARICION. Al morir, 0x84D8 copia estas cuatro variables
; de vuelta, o sea que el jugador revive exactamente donde
; entro en la pantalla, con la misma animacion. Ojo: la rutina
; no tiene RET, CAE dentro del marcador de 0x8698, que por eso
; se pinta dos veces (ya se llamo en 0x868F).
; ----------------------------------------------------------------------
FIJA_REAPARICION:		; Guarda la posicion y el estado de entrada como punto de reaparicion
	ld a,(08f09h)		;8670   ; X actual -> X de reaparicion
	ld (08f13h),a		;8673
	ld a,(08f0ah)		;8676   ; Y actual -> Y de reaparicion
	ld (08f14h),a		;8679
	ld a,(08f0bh)		;867c   ; Secuencia actual -> secuencia de reaparicion
	ld (08f1ch),a		;867f
	ld a,(08f0ch)		;8682   ; Paso actual -> paso de reaparicion
	ld (08f1dh),a		;8685
	ld a,(08f0dh)		;8688   ; Contador global de pantalla, 0..27 de un tiron; el NIVEL es aparte, 0x8F0E
	inc a			;868b
	ld (08f0dh),a		;868c
	call PINTA_MARCADOR		;868f   ; Repinta el marcador (el numero de pantalla ha cambiado)
	call CARGA_ENEMIGOS		;8692   ; Carga enemigos y cofres de la pantalla nueva
	call CARGA_MAPA		;8695   ; Copia el mapa de la pantalla nueva a la zona de trabajo 0x7D80

; ----------------------------------------------------------------------
; ############################################################
; MARCADOR: pinta vidas, pantalla y nivel
; ############################################################
; Verificado con watchpoints: 0x8F12 solo se escribe en 0x80FD
; (la inicializacion, con A=9) y solo se lee aqui, en 0x86A4.
; Las tres posiciones de VRAM coinciden exactamente con las
; casillas del marcador leidas de la pantalla real:
; 0x1A68 = fila 19 col  8  -> "VIDAS:x"
; 0x1A7D = fila 19 col 29  -> "PANTALLA:x"
; 0x1ABB = fila 21 col 27  -> "NIVEL:x"
; ----------------------------------------------------------------------
PINTA_MARCADOR:		; Redibuja el marcador completo (vidas / pantalla / nivel)
	ld hl,05fc0h		;8698   ; Plantilla del marcador (0x5FC0) -> VRAM 0x1A00, o sea las filas 16..23
	ld de,01a00h		;869b
	ld bc,00100h		;869e
	call 0005ch		;86a1   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld a,(08f12h)		;86a4   ; A = numero de vidas
	cp 009h			;86a7   ; El marcador solo tiene un digito: mas de 9 vidas se muestran como 9
	jp m,L_86AE		;86a9
	ld a,009h		;86ac
L_86AE:
	ld b,05ch		;86ae   ; 0x5C es el codigo del digito '0' en la fuente del juego...
	add a,b			;86b0   ; ...asi que 0x5C+vidas da directamente el caracter a pintar
	ld hl,01a68h		;86b1   ; Casilla del digito de VIDAS en la VRAM
	call 0004dh		;86b4   ; BIOS WRTVRM - Writes data in VRAM | BIOS WRTVRM: escribe el caracter A en la VRAM apuntada por HL
	ld a,(08f0dh)		;86b7   ; A = numero de pantalla
L_86BA:
	cp 007h			;86ba   ; Resto de dividir entre 7: hay 7 pantallas por nivel (?)
	jp m,L_86C4		;86bc
	sbc a,007h		;86bf
	jp L_86BA		;86c1
L_86C4:
	ld b,05dh		;86c4   ; 0x5D es el digito '1': la pantalla interna 0 se muestra como 1
	add a,b			;86c6
	ld hl,01a7dh		;86c7   ; Casilla del digito de PANTALLA
	call 0004dh		;86ca   ; BIOS WRTVRM - Writes data in VRAM
	ld a,(08f0eh)		;86cd   ; A = numero de nivel
	ld b,05dh		;86d0
	add a,b			;86d2
	ld hl,01abbh		;86d3   ; Casilla del digito de NIVEL
	call 0004dh		;86d6   ; BIOS WRTVRM - Writes data in VRAM
	ld a,000h		;86d9   ; A partir de aqui: la tira de iconos de municion del marcador
	ld (08f15h),a		;86db
	ld hl,01aa2h		;86de   ; Primera casilla de la tira, VRAM 0x1AA2 (fila 21, columna 2)
L_86E1:
	ld a,(08f18h)		;86e1   ; Tipo de arma actual (0..3)
	sla a			;86e4   ; Cada arma ocupa dos tiles (mirando a dcha y a izq)...
	ld b,0f7h		;86e6   ; ...asi que el icono del arma N es el tile 0xF7+2*N
	add a,b			;86e8
	call 0004dh		;86e9   ; BIOS WRTVRM - Writes data in VRAM
	ld a,(08f15h)		;86ec
	inc a			;86ef
	ld (08f15h),a		;86f0
	ld b,a			;86f3
	ld a,(08f17h)		;86f4   ; Se pintan tantos iconos como proyectiles simultaneos permitidos
	sbc a,b			;86f7
	cp 000h			;86f8
	jp z,L_8701		;86fa
	inc hl			;86fd   ; Siguiente casilla de la tira
	jp L_86E1		;86fe
L_8701:
	ret			;8701

; ----------------------------------------------------------------------
; ############################################################
; TRANSICION CON DESPLAZAMIENTO VERTICAL
; ############################################################
; Efecto de scroll al salir por abajo: 17 volcados de 512 bytes
; a la misma direccion de VRAM, avanzando el origen 32 bytes
; (una fila) cada vez. Como los mapas estan consecutivos en
; memoria, el ultimo volcado ya es entero el de la pantalla
; siguiente: la pantalla actual sube y la nueva entra por abajo.
; ----------------------------------------------------------------------
SCROLL_A_PANTALLA_SIGUIENTE:		; Desplaza verticalmente de una pantalla a la otra
	ld a,(08f0dh)		;8702   ; Numero de pantalla (todavia sin incrementar: lo hace 0x8688 despues)
	ld b,a			;8705
	ld c,000h		;8706
	sla b			;8708   ; *2 en el byte alto = *512, que es lo que ocupa un mapa
	ld hl,09000h		;870a   ; Base de los 28 mapas del juego
	add hl,bc		;870d
	ld a,011h		;870e   ; 17 pasos: 16 filas de la zona de juego mas una
	ld (08f15h),a		;8710
L_8713:
	ld bc,00200h		;8713   ; 512 bytes = las 16 filas visibles de juego
	ld de,01800h		;8716
	push hl			;8719
	call 0005ch		;871a   ; BIOS LDIRVM - Block transfers to VRAM from memory
	pop hl			;871d
	ld de,00020h		;871e   ; Avanza el origen una fila (32 casillas)
	add hl,de		;8721   ; Avanza una fila de 32 casillas: eso es lo que sube la imagen
	halt			;8722   ; Un fotograma por paso: el scroll dura 17 frames
	ld a,(08f15h)		;8723
	dec a			;8726
	cp 000h			;8727
	ret z			;8729
	ld (08f15h),a		;872a
	jr L_8713		;872d

; ----------------------------------------------------------------------
; ############################################################
; MOVER LOS ENEMIGOS
; ############################################################
; Trabaja sobre la tabla 0x8F20 (4 registros de 5 bytes) con
; coordenadas en pixeles, y los dibuja como SPRITES en los
; planos 6 a 13. Los enemigos de cada pantalla se cargan desde
; 0x7BA0 + pantalla*16 (ver 0x87FE).
; ----------------------------------------------------------------------
MUEVE_ENEMIGOS:		; Avanza y dibuja los enemigos de la pantalla
	ld a,003h		;872f
	ld (08f15h),a		;8731   ; El contador tambien hace de numero de plano de sprite (3..6)
	ld ix,08f20h		;8734   ; Registros de enemigo en 0x8F20, 5 bytes cada uno (X, Y, animacion, impactos, fotograma)
L_8738:
	ld a,(ix+000h)		;8738   ; Una X de 0 corta la lista: los enemigos de una pantalla van seguidos
L_873B:
	cp 000h			;873b   ; X=0 marca el final de la lista: esta pantalla tiene menos de 4
L_873D:
	ret z			;873d
	ld b,(ix+000h)		;873e
L_8741:
	ld c,(ix+001h)		;8741
L_8744:
	ld e,(ix+002h)		;8744   ; El byte +2 del registro ES el numero de animacion de la tabla 0x60C0
L_8747:
	ld a,(ix+004h)		;8747
	call ANIMA_JUGADOR		;874a   ; Avanza un paso de la secuencia; Z = la secuencia se ha acabado
	jr nz,L_876C		;874d   ; Con Z se acabo la secuencia: reinicia el fotograma y encadena la siguiente
	ld a,000h		;874f   ; Secuencia agotada: vuelve al paso 0
	ld (ix+004h),a		;8751
	ld a,(ix+002h)		;8754
	cp 00dh			;8757   ; El tipo 0x0D es el enemigo ya muerto: se lo lleva a Y=0xC0, fuera de pantalla
	jr nz,L_8760		;8759
	ld a,0c0h		;875b   ; ...y al acabarla se manda al enemigo a Y=0xC0, fuera de la pantalla
	ld (ix+001h),a		;875d
L_8760:
	ld a,(ix+002h)		;8760
	call SIG_ESTADO		;8763   ; Tabla de encadenado: que secuencia sigue a la que acaba de terminar
	ld (ix+002h),a		;8766
	jp L_8738		;8769   ; Reintenta el mismo enemigo con la secuencia nueva
L_876C:
	ld (ix+000h),b		;876c   ; Guarda la posicion nueva que ha devuelto 0x82BE
L_876F:
	ld (ix+001h),c		;876f
L_8772:
	push af			;8772
	ld a,(08f15h)		;8773   ; El mismo contador da el plano de sprite: E = contador*2, o sea planos 6, 8, 10 y 12
	sla a			;8776   ; Cada enemigo ocupa 2 planos de sprite: planos 6, 8, 10 y 12
L_8778:
	ld e,a			;8778
	pop af			;8779
L_877A:
	call PON_SPRITES		;877a   ; Vuelca los 8 bytes de atributos a la VRAM
L_877D:
	ld a,(ix+004h)		;877d
L_8780:
	inc a			;8780
L_8781:
	ld (ix+004h),a		;8781
L_8784:
	ld a,(ix+002h)		;8784
L_8787:
	cp 00dh			;8787   ; Un enemigo muerto ya no rebota contra las paredes
	jp z,L_87A4		;8789
	ld b,(ix+000h)		;878c
L_878F:
	ld c,(ix+001h)		;878f
L_8792:
	call COLISION_IZQ		;8792   ; Sondea la pared de su izquierda...
	call GIRA_ENEMIGO		;8795
L_8798:
	ld b,(ix+000h)		;8798
L_879B:
	ld c,(ix+001h)		;879b
L_879E:
	call COLISION_DER		;879e   ; ...y la de su derecha
L_87A1:
	call GIRA_ENEMIGO		;87a1
L_87A4:
	ld a,(08f15h)		;87a4
L_87A7:
	inc a			;87a7
	ld (08f15h),a		;87a8
L_87AB:
	cp 007h			;87ab   ; 4 enemigos (los contadores van del 3 al 6)
	ret z			;87ad
	ld de,00005h		;87ae   ; 5 bytes por enemigo
	add ix,de		;87b1
L_87B3:
	jp L_8738		;87b3

; ----------------------------------------------------------------------
; Rebote. Solo dejan pasar al enemigo los tipos 0, 2, 3, 4 y 5.
; El tipo 1 NO: el tile 0xA9, cuyo glifo esta completamente en
; blanco, hace rebotar al enemigo aunque el jugador lo
; atraviesa sin enterarse. Son PAREDES INVISIBLES para acotar
; la zona de patrulla: hay 406 tiles 0xA9 en los 28 mapas y
; dibujados forman columnas verticales.
; ----------------------------------------------------------------------
GIRA_ENEMIGO:		; Cambia el sentido de marcha de un enemigo
	cp 000h			;87b6   ; Tipo 0 = fondo; 2..5 son objetos: el enemigo los atraviesa
L_87B8:
	ret z			;87b8
	cp 002h			;87b9
	ret z			;87bb
	cp 003h			;87bc
	ret z			;87be
	cp 004h			;87bf
	ret z			;87c1
	cp 005h			;87c2
	ret z			;87c4
	ld a,(ix+002h)		;87c5
L_87C8:
	cp 021h			;87c8   ; Las animaciones van emparejadas: la de mirar a la derecha esta 0x11 ranuras despues
	jr nc,L_87D3		;87ca
	ld b,011h		;87cc   ; Por debajo de 0x21 se suma 17 para pasar a la version espejo...
	add a,b			;87ce
	ld (ix+002h),a		;87cf
L_87D2:
	ret			;87d2
L_87D3:
	ld b,011h		;87d3   ; ...y por encima se resta, que es volver a la original
	sbc a,b			;87d5
	ld (ix+002h),a		;87d6
	ret			;87d9
TOCADO_ENEMIGO:		; Suma un impacto al enemigo y lo mata si el contador da la vuelta
	ld a,(iy+003h)		;87da   ; Contador de resistencia; el valor de la tabla es 256 menos los tiros que aguanta
	inc a			;87dd
	ld (iy+003h),a		;87de   ; El byte +3 cuenta hacia arriba hasta desbordar: aguanta 256 menos su valor inicial; 0x00 o 0x01 = indestructible
	cp 000h			;87e1   ; Solo muere cuando el contador desborda a cero
	ret nz			;87e3
	ld a,00dh		;87e4   ; Muerto: pasa a la animacion 0x0D (la explosion de 0x6740)
	ld (iy+002h),a		;87e6
	ld a,000h		;87e9
	ld (iy+004h),a		;87eb
	ld a,0ech		;87ee   ; Efecto de sonido de la explosion, el mismo que usa la muerte del jugador en 0x8497
	ld (0ddafh),a		;87f0   ; Segundo disparador del mismo trino: una entidad de la tabla de 0x8F20 (8 entradas de 5 bytes) agota su contador y pasa al estado 0x0D
	ret			;87f3

; ----------------------------------------------------------------------
; ############################################################
; COLISION JUGADOR-ENEMIGO
; ############################################################
; No se calcula nada: el juego delega en el VDP. 0xF3E7 es
; STATFL, la copia del registro de estado del VDP que guarda
; la BIOS en cada interrupcion, y su bit 5 es el flag de
; colision entre sprites. El jugador ocupa los planos 0-1 y
; los enemigos del 6 al 13; de ahi que se muera de un solo
; impacto. (?) No esta comprobado que dos enemigos solapandose
; entre si no disparen tambien esta muerte.
; ----------------------------------------------------------------------
COMPRUEBA_COLISION_SPRITES:		; Si el VDP marca colision de sprites, mata al jugador
	ld a,(0f3e7h)		;87f4   ; STATFL: copia del registro de estado del VDP
	bit 5,a			;87f7   ; Bit 5 = colision de sprites
	ret z			;87f9
	call MUERE_JUGADOR		;87fa   ; Ha tocado a un enemigo: a morir
	ret			;87fd

; ----------------------------------------------------------------------
; ############################################################
; CARGA LOS ENEMIGOS Y LOS COFRES DE LA PANTALLA
; ############################################################
; Dos tablas paralelas, 16 bytes por pantalla cada una:
; 0x7BA0 enemigos: 4 registros de 4 bytes (X, Y, secuencia,
; resistencia). Se expanden a 5 bytes en 0x8F20
; anadiendo el paso, que arranca a 0.
; 0x79C0 cofres/calaveras: 4 registros de 4 bytes (columna,
; fila, impactos, tile que aparece al romperlo).
; Se copian tal cual a 0x8FA0.
; ----------------------------------------------------------------------
CARGA_ENEMIGOS:		; Carga en 0x8F20 los enemigos de la pantalla, desde 0x7BA0+pantalla*16
	ld d,000h		;87fe
	push ix			;8800
	push iy			;8802
	ld a,(08f0dh)		;8804   ; Numero de pantalla
	ld e,a			;8807
	sla e			;8808   ; Cuatro desplazamientos de 16 bits: DE = pantalla*16
	rl d			;880a
	sla e			;880c
	rl d			;880e
	sla e			;8810
	rl d			;8812
	sla e			;8814
	rl d			;8816
	ld iy,07ba0h		;8818   ; Enemigos: 0x7BA0 + pantalla*16, cuatro registros de 4 bytes
	add iy,de		;881c
	ld a,004h		;881e   ; Cuatro enemigos por pantalla
	ld (08f15h),a		;8820
	ld ix,08f20h		;8823   ; Se expanden a 5 bytes en 0x8F20 anadiendo el contador de fotograma
L_8827:
	ld a,(iy+000h)		;8827
	ld (ix+000h),a		;882a
	ld a,(iy+001h)		;882d
	ld (ix+001h),a		;8830
	ld a,(iy+002h)		;8833
	ld (ix+002h),a		;8836
	ld a,(iy+003h)		;8839
	ld (ix+003h),a		;883c
	ld a,000h		;883f   ; El paso dentro de la secuencia siempre empieza a 0
	ld (ix+004h),a		;8841
	ld de,00004h		;8844   ; El registro de la tabla mide 4 bytes...
	add iy,de		;8847
	inc e			;8849   ; ...pero el de RAM mide 5, por eso el INC E
	add ix,de		;884a
	ld a,(08f15h)		;884c
	dec a			;884f
	ld (08f15h),a		;8850
	cp 000h			;8853
	jr z,L_885A		;8855
	jp L_8827		;8857
L_885A:
	ld (ix+005h),000h	;885a   ; (?) Con IX ya en 0x8F34 esto escribe 0x8F39, la X del hueco 5, no la del 4
	ld hl,079c0h		;885e   ; Objetos disparables: 0x79C0 + pantalla*16, se copian tal cual a 0x8FA0
	ld d,000h		;8861
	ld a,(08f0dh)		;8863
	ld e,a			;8866
	sla e			;8867
	rl d			;8869
	sla e			;886b
	rl d			;886d
	sla e			;886f
	rl d			;8871
	sla e			;8873
	rl d			;8875
	add hl,de		;8877
	ld de,08fa0h		;8878   ; Destino de los rompibles de esta pantalla: 16 bytes justos en 0x8FA0-0x8FAF, pegados por debajo de la pila [SUSTITUYE]
	ld bc,00010h		;887b   ; 16 bytes = los 4 cofres de la pantalla, sin reformatear
	ldir			;887e
	pop iy			;8880
	pop ix			;8882
	ret			;8884

; ----------------------------------------------------------------------
; ############################################################
; DISPARO
; ############################################################
; Las armas 2 y 3 disparan solas mientras se aguanta el boton,
; las 0 y 1 obligan a soltarlo entre tiro y tiro. Es la
; 'autorrepeticion' del manual.
; ----------------------------------------------------------------------
DISPARA:		; Crea un proyectil: columna=(X+7)/8, fila=(Y+8)/8
	ld a,000h		;8885   ; GTTRIG con A=0 (barra espaciadora)...
L_8887:
	call 000d8h		;8887   ; BIOS GTTRIG - Returns current trigger status
L_888A:
	ld b,a			;888a
	push bc			;888b
L_888C:
	ld a,001h		;888c   ; ...y con A=1 (boton del joystick)
	call 000d8h		;888e   ; BIOS GTTRIG - Returns current trigger status
	pop bc			;8891
	or b			;8892
	cp 0ffh			;8893   ; GTTRIG devuelve 0xFF pulsado, 0x00 suelto
	jp z,L_889E		;8895
	ld a,000h		;8898   ; Boton suelto: se rearma el disparo y ya esta
	ld (08f19h),a		;889a
	ret			;889d
L_889E:
	ld a,(08f18h)		;889e   ; Tipo de arma
	cp 002h			;88a1   ; Las armas 2 y 3 tienen autorrepeticion: no hay que soltar el boton
	jr z,L_88B2		;88a3
	cp 003h			;88a5
	jr z,L_88B2		;88a7
	ld a,(08f19h)		;88a9   ; Las demas exigen soltar el boton entre disparo y disparo
	cp 000h			;88ac
	jp z,L_88B2		;88ae
	ret			;88b1
L_88B2:
	ld a,0ffh		;88b2   ; Marca el gatillo como ya usado
	ld (08f19h),a		;88b4
	ld a,000h		;88b7
	ld (08f15h),a		;88b9
	ld ix,08f80h		;88bc   ; Array de proyectiles
L_88C0:
	ld a,(ix+002h)		;88c0   ; Velocidad 0 = hueco libre
	cp 000h			;88c3
	jr z,PUEDE_DISPARAR		;88c5
	inc ix			;88c7
	inc ix			;88c9
	inc ix			;88cb
	inc ix			;88cd
	ld a,(08f15h)		;88cf
	inc a			;88d2
	ld (08f15h),a		;88d3
	ld b,a			;88d6
	ld a,(08f17h)		;88d7   ; No hay hueco libre: ya vuelan todos los permitidos
	sbc a,b			;88da
	cp 000h			;88db
	ret z			;88dd
	jp L_88C0		;88de

; ----------------------------------------------------------------------
; ############################################################
; QUIEN PUEDE DISPARAR
; ############################################################
; Impide disparar en los estados 0, 7 y 8 porque la direccion
; del tiro se saca del bit 0 del estado, y esos tres no tienen
; lado definido (quieto y los dos saltos verticales). Explica una
; rareza jugable: parado del todo no se puede disparar.
; ----------------------------------------------------------------------
PUEDE_DISPARAR:		; Comprueba si el estado actual permite disparar
	ld a,(08f0bh)		;88e1   ; Secuencia actual del jugador
	cp 000h			;88e4   ; Quieto, cayendo en vertical o saltando en vertical: no se puede disparar
	ret z			;88e6
	cp 007h			;88e7
	ret z			;88e9
	cp 008h			;88ea
	ret z			;88ec
	ld a,00fh		;88ed   ; Efecto de sonido del disparo
	ld (0ddaeh),a		;88ef   ; Efecto de DISPARO, 15 frames, al crear el proyectil
	ld a,(08f09h)		;88f2   ; El proyectil arranca en la casilla del jugador...
	ld b,007h		;88f5   ; ...columna = (X+7)/8, o sea redondeando hacia arriba
	add a,b			;88f7
	srl a			;88f8
	srl a			;88fa
	srl a			;88fc
	ld (ix+000h),a		;88fe
	ld a,(08f0ah)		;8901
	ld b,008h		;8904   ; ...y fila = (Y+8)/8, la del centro vertical del sprite
	add a,b			;8906
	srl a			;8907
	srl a			;8909
	srl a			;890b
	ld (ix+001h),a		;890d
	ld b,(ix+000h)		;8910
	ld c,(ix+001h)		;8913
	call VRAM_DE_CASILLA		;8916   ; HL = casilla de VRAM
	ld de,06580h		;8919   ; Sumando 0x6580 se pasa de la VRAM a la copia del mapa en 0x7D80
	add hl,de		;891c
	ld a,(hl)		;891d
	ld (ix+003h),a		;891e   ; Guarda el tile que habia debajo para poder restaurarlo
	ld a,(08f0bh)		;8921   ; La secuencia del jugador es impar mirando a la derecha (0x0B)...
	rra			;8924
	jr c,L_892D		;8925
	ld a,0ffh		;8927   ; ...asi que par = izquierda, velocidad -1
	ld (ix+002h),a		;8929
	ret			;892c
L_892D:
	ld a,001h		;892d   ; ...e impar = derecha, velocidad +1
	ld (ix+002h),a		;892f
	ret			;8932

; ----------------------------------------------------------------------
; ############################################################
; MOVER LOS DISPAROS
; ############################################################
; Trabaja sobre la tabla 0x8F80 y, a diferencia de los enemigos,
; dibuja los proyectiles como TILES con WRTVRM, no como sprites.
; Hay tantas ranuras activas como municion tenga el jugador.
; ----------------------------------------------------------------------
MUEVE_DISPAROS:		; Avanza los proyectiles y los pinta como tiles
	ld a,000h		;8933
L_8935:
	ld (08f15h),a		;8935
L_8938:
	ld ix,08f80h		;8938   ; Array de proyectiles
L_893C:
	ld b,(ix+000h)		;893c
L_893F:
	ld c,(ix+001h)		;893f
L_8942:
	push bc			;8942
L_8943:
	call VRAM_DE_CASILLA		;8943   ; Casilla de VRAM donde esta ahora
L_8946:
	ld a,(ix+003h)		;8946   ; Restaura el tile que tapaba: asi se borra el proyectil
L_8949:
	call 0004dh		;8949   ; BIOS WRTVRM - Writes data in VRAM
	pop bc			;894c
	ld a,(ix+002h)		;894d
L_8950:
	add a,b			;8950   ; Avanza una casilla en el sentido de la velocidad
L_8951:
	ld (ix+000h),a		;8951
	ld a,000h		;8954
	ld (08f16h),a		;8956
	ld iy,08fa0h		;8959   ; Los 4 cofres/calaveras de la pantalla
L_895D:
	ld a,(ix+000h)		;895d
L_8960:
	ld b,(iy+000h)		;8960
	ld c,(ix+002h)		;8963   ; Se mira la casilla siguiente, no la actual: el impacto se adelanta un paso
L_8966:
	add a,c			;8966
L_8967:
	sbc a,b			;8967
L_8968:
	cp 000h			;8968
L_896A:
	jp z,L_89B1		;896a
L_896D:
	ld a,(08f16h)		;896d
L_8970:
	inc a			;8970
	ld (08f16h),a		;8971
L_8974:
	cp 004h			;8974   ; Probados los cuatro cofres sin acertar
L_8976:
	jp z,L_8983		;8976
L_8979:
	inc iy			;8979   ; Salta al siguiente rompible; con el tope de 4 que impone el CP de 0x8974 el barrido toca 0x8FA0, 0x8FA4, 0x8FA8 y 0x8FAC y ni un byte mas
L_897B:
	inc iy			;897b
L_897D:
	inc iy			;897d
	inc iy			;897f
L_8981:
	jr L_895D		;8981
L_8983:
	ld b,(ix+000h)		;8983   ; No ha dado a ningun cofre: toca mirar el terreno
L_8986:
	ld c,(ix+001h)		;8986
L_8989:
	call VRAM_DE_CASILLA		;8989
	ld de,06580h		;898c   ; Copia del mapa en RAM
	add hl,de		;898f
L_8990:
	ld a,(hl)		;8990
	ld (ix+003h),a		;8991   ; Apunta el tile que va a tapar en la casilla nueva
L_8994:
	call CLASIFICA_TILE		;8994   ; Clasifica el tile en un tipo 0..8
	cp 006h			;8997   ; Tipo 6 = pared: el proyectil se estrella
	jp z,L_8A37		;8999
	cp 007h			;899c   ; Tipo 7 = terreno mortal: tambien lo para
L_899E:
	jp z,L_8A37		;899e
L_89A1:
	ld a,(ix+000h)		;89a1   ; Columna 0 o 32: se ha salido de la pantalla
	cp 000h			;89a4
	jp z,L_8A3F		;89a6
L_89A9:
	cp 020h			;89a9
	jp z,L_8A3F		;89ab
L_89AE:
	jp L_89FC		;89ae

; ----------------------------------------------------------------------
; Coincide la columna con un cofre; falta confirmar la fila.
; Si la fila no cuadra se abandona el barrido y se pasa al
; terreno, o sea que no se prueban los cofres siguientes.
; ----------------------------------------------------------------------
L_89B1:
	ld a,(ix+001h)		;89b1   ; Se admite el impacto si la fila coincide exactamente
	ld b,(iy+001h)		;89b4
	sbc a,b			;89b7
	cp 000h			;89b8
	jr nz,L_8983		;89ba
	ld a,002h		;89bc   ; Efecto de sonido de impacto
	ld (0ddb0h),a		;89be   ; Efecto de IMPACTO del disparo, 2 frames
	ld a,000h		;89c1
	ld (ix+002h),a		;89c3   ; Velocidad 0: el proyectil se consume
	ld a,002h		;89c6
	ld (ix+000h),a		;89c8   ; Vuelve a la casilla (2,21) del marcador; ver 0x8A45
	ld a,015h		;89cb
	ld (ix+001h),a		;89cd
	ld a,(iy+002h)		;89d0   ; Suma un impacto al cofre; solo se rompe cuando el contador desborda
	inc a			;89d3
	ld (iy+002h),a		;89d4
	cp 000h			;89d7
	jr nz,L_8A19		;89d9
	ld a,01ch		;89db
	ld (0ddb1h),a		;89dd   ; Efecto de OBJETO DESTRUIDO (?), 28 frames
	ld b,(iy+000h)		;89e0
	ld c,(iy+001h)		;89e3
	call VRAM_DE_CASILLA		;89e6
	ld de,06580h		;89e9
	add hl,de		;89ec
	ld a,(iy+003h)		;89ed   ; Byte +3 del cofre: lo que aparece al romperlo (0xAA..0xAD, y 0xF4 en la pantalla 26)
	ld (hl),a		;89f0   ; Lo escribe en el mapa, donde el jugador ya podra recogerlo
	call VUELCA_BUFFER		;89f1   ; Repinta la pantalla entera para que se vea el cambio
	ld a,019h		;89f4
	ld (iy+001h),a		;89f6   ; Fila 25: saca el cofre de la lista, ya no puede recibir mas tiros
	jp L_8A19		;89f9
L_89FC:
	ld b,(ix+000h)		;89fc   ; Pinta el proyectil en su casilla nueva
	ld c,(ix+001h)		;89ff
	call VRAM_DE_CASILLA		;8a02
L_8A05:
	ld a,(08f18h)		;8a05   ; Cada arma tiene dos tiles consecutivos...
	sla a			;8a08
	ld b,0f7h		;8a0a
	add a,b			;8a0c   ; ...el primero es el tile 0xF7+2*arma
	ld b,a			;8a0d
	ld a,(ix+002h)		;8a0e
	rr a			;8a11   ; El 'rr a' baja el bit 1 de la velocidad al bit 0: 0xFF -> segundo tile (mira a la izq)
	and 001h		;8a13
L_8A15:
	add a,b			;8a15
	call 0004dh		;8a16   ; BIOS WRTVRM - Writes data in VRAM
L_8A19:
	call BUSCA_ENEMIGO_ALCANZADO		;8a19   ; Comprueba si el proyectil ha alcanzado a algun enemigo
	ld a,(08f17h)		;8a1c   ; Se procesan tantos proyectiles como iconos de municion tenga el jugador
L_8A1F:
	ld b,a			;8a1f
	ld a,(08f15h)		;8a20
L_8A23:
	inc a			;8a23
	ld (08f15h),a		;8a24
	sbc a,b			;8a27
L_8A28:
	cp 000h			;8a28
L_8A2A:
	ret z			;8a2a
	inc ix			;8a2b
	inc ix			;8a2d
	inc ix			;8a2f
	inc ix			;8a31
	jp L_893C		;8a33

; ----------------------------------------------------------------------
; DATOS ret_huerfano_2: Otro RET inalcanzable, entre la rutina que acaba en 0x8A33 y la que empieza en 0x8A37. Ningun acceso en una partida completa.
;   0x8a36..0x8a37  (1 bytes)
; ----------------------------------------------------------------------
	defb 0c9h	; 8a36  .

; ======================================================================
; CODIGO 0x8a37..0x8c60  (553 bytes)
; ======================================================================


L_8A37:
	ld a,(08f18h)		;8a37   ; El arma 3 es la unica que atraviesa paredes y terreno mortal
	cp 003h			;8a3a
	jp z,L_89A1		;8a3c
L_8A3F:
	call APARCA_PROYECTIL		;8a3f
	jp L_89FC		;8a42

; ----------------------------------------------------------------------
; Devuelve el proyectil al deposito. La casilla (2,21) no es
; casual: 0x8AA9 la traduce a la VRAM 0x1AA2, que es justo la
; primera casilla de la tira de municion del marcador. Como
; despues de aparcar se salta a 0x89FC, cada proyectil
; disponible repinta ahi su icono. (?) Que ese sea el proposito
; y no un aparcadero cualquiera es interpretacion.
; ----------------------------------------------------------------------
APARCA_PROYECTIL:		; Devuelve el proyectil al deposito: velocidad 0 = hueco libre
	ld a,002h		;8a45
	ld (ix+000h),a		;8a47   ; Columna 2...
	ld a,015h		;8a4a
	ld (ix+001h),a		;8a4c   ; ...fila 21, o sea la VRAM 0x1AA2, primer icono de la tira de municion
	ld a,000h		;8a4f
	ld (ix+002h),a		;8a51
	ld a,000h		;8a54
	ld (ix+003h),a		;8a56
	ret			;8a59
BUSCA_ENEMIGO_ALCANZADO:		; Compara el proyectil con los enemigos y aplica el impacto
	ld iy,08f20h		;8a5a   ; Array de enemigos
	ld a,000h		;8a5e
	ld (08f1bh),a		;8a60
L_8A63:
	call CASILLA_DE_ENEMIGO		;8a63   ; Pasa la posicion en pixeles del enemigo a columna y fila
L_8A66:
	ld a,(ix+000h)		;8a66
L_8A69:
	sbc a,b			;8a69
L_8A6A:
	cp 000h			;8a6a
L_8A6C:
	call z,CONFIRMA_IMPACTO	;8a6c
L_8A6F:
	ld a,(08f1bh)		;8a6f
L_8A72:
	inc a			;8a72
L_8A73:
	ld (08f1bh),a		;8a73
L_8A76:
	cp 008h			;8a76   ; Recorre 8 huecos aunque solo se carguen 4 enemigos por pantalla
L_8A78:
	ret z			;8a78
	ld de,00005h		;8a79
L_8A7C:
	add iy,de		;8a7c
L_8A7E:
	jp L_8A63		;8a7e
CONFIRMA_IMPACTO:		; Confirma el impacto comparando tambien la fila
	call CASILLA_DE_ENEMIGO		;8a81
	ld a,(ix+001h)		;8a84
	sbc a,c			;8a87
	cp 000h			;8a88   ; Vale la misma fila...
	jp z,L_8A93		;8a8a
	cp 001h			;8a8d   ; ...o la de justo debajo: el enemigo mide 16 pixeles de alto
	jp z,L_8A93		;8a8f
	ret			;8a92
L_8A93:
	call TOCADO_ENEMIGO		;8a93   ; Le suma un impacto y, si se le acaba la resistencia, lo mata
	ld b,(ix+000h)		;8a96
	ld c,(ix+001h)		;8a99
	call VRAM_DE_CASILLA		;8a9c   ; Borra el proyectil de la pantalla restaurando el tile que tapaba
	ld a,(ix+003h)		;8a9f
	call 0004dh		;8aa2   ; BIOS WRTVRM - Writes data in VRAM
	call APARCA_PROYECTIL		;8aa5   ; Y devuelve el proyectil al deposito
	ret			;8aa8

; ----------------------------------------------------------------------
; ############################################################
; UTILIDADES DEL MAPA DE LA PANTALLA
; ############################################################
; El juego mantiene una COPIA DE TRABAJO del mapa de la
; pantalla en 0x7D80 (512 bytes, 16 filas x 32 columnas).
; Toda la fisica lee de ahi, nunca de la VRAM. La constante
; 0x6580 que aparece por todas partes es simplemente
; 0x7D80 - 0x1800: convierte una direccion de VRAM en la
; casilla equivalente de la copia en RAM. Ojo: solo vale para
; las filas 0-15; con la fila 21 del marcador se sale del mapa.
; ----------------------------------------------------------------------
VRAM_DE_CASILLA:		; HL = 0x1800 + fila*32 + columna
	push bc			;8aa9
	push de			;8aaa
	push af			;8aab
L_8AAC:
	ld e,b			;8aac
L_8AAD:
	ld d,000h		;8aad
L_8AAF:
	ld b,000h		;8aaf
	sla c			;8ab1   ; C*32: 32 casillas por fila
L_8AB3:
	rl b			;8ab3
	sla c			;8ab5
L_8AB7:
	rl b			;8ab7
L_8AB9:
	sla c			;8ab9
L_8ABB:
	rl b			;8abb
L_8ABD:
	sla c			;8abd
	rl b			;8abf
L_8AC1:
	sla c			;8ac1
L_8AC3:
	rl b			;8ac3
L_8AC5:
	ld hl,01800h		;8ac5   ; Tabla de nombres de la pantalla
	add hl,de		;8ac8
L_8AC9:
	add hl,bc		;8ac9
L_8ACA:
	pop af			;8aca
L_8ACB:
	pop de			;8acb
L_8ACC:
	pop bc			;8acc
	ret			;8acd

; ----------------------------------------------------------------------
; ############################################################
; CARGAR EL MAPA DE LA PANTALLA ACTUAL
; ############################################################
; Los mapas son 29 bloques de 512 bytes seguidos desde 0x9000.
; Aqui se ve la aritmetica: D = pantalla, SLA D y E=0 dejan
; DE = pantalla*512, se suma a 0x9000 y se copian 512 bytes al
; buffer 0x7D80.
; ----------------------------------------------------------------------
CARGA_MAPA:		; Copia el mapa de la pantalla actual al buffer de 0x7D80
	ld a,(08f0dh)		;8ace   ; A = numero de pantalla
	ld d,a			;8ad1
	sla d			;8ad2   ; DE = pantalla * 512 (SLA D con E=0 multiplica por 512)
	ld e,000h		;8ad4
	ld hl,09000h		;8ad6   ; Base de la tabla de mapas
	add hl,de		;8ad9
	ld de,07d80h		;8ada   ; Buffer del mapa en RAM
	ld bc,00200h		;8add   ; 512 bytes = 32 columnas x 16 filas
	ldir			;8ae0
	ret			;8ae2

; ----------------------------------------------------------------------
; Busca en el mapa el PRIMER tile igual a A y lo pone a 0.
; Asi desaparece un objeto al recogerlo. Ojo: busca desde el
; principio del mapa, no en la casilla del jugador, asi que si
; una pantalla repite el mismo objeto se borra el primero en
; orden de barrido. Pasa en la pantalla 16, que lleva dos tiles
; 0xAC pegados en la fila 10, columnas 7 y 8: se borra el de la
; izquierda toques el que toques.
; Ampliacion: ademas de los dos 0xAC de la pantalla 16, la 27
; lleva SEIS tiles 0xAB de vida extra, asi que ahi el fallo se ve
; seis veces seguidas: cojas el que cojas desaparece siempre el
; primero en orden de barrido.
; Y hay un segundo fallo encadenado: los cuatro llamadores borran
; la casilla ANTES de comprobar el tope (0x8523 antes de 0x8528,
; 0x8540 antes de 0x8545, 0x855B antes de 0x8560), asi que un
; objeto cogido con 9 vidas, con 6 disparos o con el arma 3 se
; pierde del mapa sin dar absolutamente nada.
; ----------------------------------------------------------------------
BORRA_OBJETO_MAPA:		; Quita del mapa el primer tile igual a A y repinta
	ld hl,07d80h		;8ae3
	ld bc,00200h		;8ae6
	cpir			;8ae9   ; CPIR: busca el tile por todo el mapa
	ld hl,001ffh		;8aeb   ; Deshace el contador de CPIR para sacar el desplazamiento del tile
	sbc hl,bc		;8aee
	ld b,h			;8af0
	ld c,l			;8af1
	ld hl,07d80h		;8af2
	add hl,bc		;8af5
	ld (hl),000h		;8af6   ; Casilla vacia
	call VUELCA_BUFFER		;8af8
	ret			;8afb
VUELCA_BUFFER:		; Copia los 512 bytes del buffer de RAM a VRAM 0x1800
	ld hl,07d80h		;8afc
	ld de,01800h		;8aff   ; Filas 0..15 de la tabla de nombres; de la 16 a la 23 esta el marcador
	ld bc,00200h		;8b02
	call 0005ch		;8b05   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ret			;8b08

; ----------------------------------------------------------------------
; ############################################################
; FIN DE PANTALLA: ¿toca cambiar de nivel?
; ############################################################
; Aqui esta la prueba en codigo de que el juego son 4 niveles de
; 7 pantallas: compara el contador de pantalla con 6, 13, 20 y 27,
; que son exactamente las ultimas de cada nivel.
; nivel 1 -> pantallas  0..6
; nivel 2 -> pantallas  7..13
; nivel 3 -> pantallas 14..20
; nivel 4 -> pantallas 21..27   (y la 28 es la de victoria)
; ----------------------------------------------------------------------
FIN_DE_PANTALLA:		; Decide si al pasar de pantalla hay ademas cambio de nivel
	ld a,(08f0dh)		;8b09   ; A = pantalla que se acaba de terminar
	cp 00dh			;8b0c   ; Ultima del nivel 2: entra al nivel 3
	jp z,ENTRA_NIVEL3		;8b0e
	cp 014h			;8b11   ; Ultima del nivel 3: entra al nivel 4, el acuatico
	jp z,ENTRA_NIVEL4		;8b13
	cp 01bh			;8b16   ; Ultima del nivel 4: se acabo el juego
	jp z,FINAL_JUEGO		;8b18
	cp 006h			;8b1b   ; Ultima del nivel 1: entra al nivel 2
	jp z,CEREMONIA_NIVEL		;8b1d
	jp CAMBIO_PANT_NORMAL		;8b20   ; Pantalla normal: solo avanzar
CEREMONIA_NIVEL:		; Cola comun del cambio de nivel (rotulo + punto de reaparicion); llegan aqui la pantalla 6 directamente y la 13 por el 'jp 08b23h' de 0x8B52
	call EMPIEZA_NIVEL		;8b23
	jp FIJA_REAPARICION		;8b26

; ----------------------------------------------------------------------
; ############################################################
; ENTRADA AL NIVEL 3
; ############################################################
; Recarga el banco de sprites: mete 0x4C0 bytes desde 0x5800 en
; la VRAM 0x3B40, o sea cambia el aspecto de los enemigos.
; ----------------------------------------------------------------------
ENTRA_NIVEL3:		; Cambia el banco de sprites y recoloca al jugador
	ld hl,05800h		;8b29   ; Banco alternativo de sprites
	ld bc,004c0h		;8b2c
	ld de,03b40h		;8b2f
	call 0005ch		;8b32   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld a,000h		;8b35
	ld (08f11h),a		;8b37   ; Apaga el modo flotar por si venia activo
	ld a,009h		;8b3a
	ld (08f0bh),a		;8b3c   ; Estado 9 = salto hacia la derecha
	ld (08f1ch),a		;8b3f
	ld a,015h		;8b42
	ld (08f09h),a		;8b44   ; X de entrada, tambien guardada como punto de reaparicion
	ld (08f13h),a		;8b47
	ld a,040h		;8b4a
	ld (08f0ah),a		;8b4c   ; Y de entrada, idem
	ld (08f14h),a		;8b4f
	jp CEREMONIA_NIVEL		;8b52

; ----------------------------------------------------------------------
; ############################################################
; NIVEL 4: EL NIVEL ACUATICO
; ############################################################
; Enciende el modo VUELO PERMANENTE al entrar en el nivel 4, que
; es lo que hace que el protagonista se convierta en pez y pueda
; flotar sin gravedad. Confirma con codigo lo que conto el
; usuario. Ademas pone BDRCLR (0xF3EB) a 12 y llama a CHGCLR,
; o sea cambia el color del BORDE de la pantalla.
; ----------------------------------------------------------------------
ENTRA_NIVEL4:		; Activa el modo acuatico: vuelo permanente y borde de otro color
	call EMPIEZA_NIVEL		;8b55
	ld a,00ch		;8b58   ; Borde de color 12 para el nivel acuatico
	ld (0f3ebh),a		;8b5a   ; Fondo VERDE: aqui empieza el agua del nivel 4
	call 00062h		;8b5d   ; BIOS CHGCLR - Changes the screen colors
	ld a,001h		;8b60
	ld (08f11h),a		;8b62   ; FLAG DE FLOTAR = 1: se acabo la gravedad, esto es el nivel del pez
	ld a,00bh		;8b65
	ld (08f0bh),a		;8b67   ; Estado 0x0B = animacion de nadar mirando a la derecha
	jp FIJA_REAPARICION		;8b6a

; ----------------------------------------------------------------------
; ############################################################
; FINAL DEL JUEGO
; ############################################################
; Avanza a la pantalla 28, que es el mapa de victoria con el
; texto "ALELUYA, OH FRAY ARNULFO...", y se queda en un bucle
; infinito: el juego no vuelve al menu.
; ----------------------------------------------------------------------
FINAL_JUEGO:		; Pantalla de victoria y bucle final
	ld a,(08f0dh)		;8b6d   ; Avanza a la pantalla 28 (la de victoria)
	inc a			;8b70
	ld (08f0dh),a		;8b71
	call CARGA_ENEMIGOS		;8b74   ; Carga las tablas de la pantalla 28: la pantalla de victoria SI tiene cuatro enemigos (0x7D60, animacion 0x0E), y son los que mueve el bucle final
	call CARGA_MAPA		;8b77   ; Carga su mapa como el de cualquier otra pantalla
	call VUELCA_BUFFER		;8b7a
	call INIT_PANTALLA		;8b7d   ; Rehace el decorado de arranque completo, no solo enciende la pantalla: 0x805E pone el borde a 1 (adios al 12 del agua) y recarga los 0x800 bytes de sprites originales de 0x5000 sobre VRAM 0x3800, con lo que el pez vuelve a ser el monje [SUSTITUYE]

; ----------------------------------------------------------------------
; ############################################################
; EL CASTIGO POR HACER TRAMPAS
; ############################################################
; Si la variable 0x8F1E no es cero, en vez de dejar disfrutar la
; pantalla final le escribe encima, en la ULTIMA LINEA del area
; de juego (VRAM 0x19E0 = fila 15), los 32 caracteres de
; "POR QUE NO PRUEBAS SIN POKES" que hay en 0x7F94.
;
; O sea que no es un mensaje cualquiera: es un castigo reservado
; para el que se termina el juego haciendo trampas.
;
; Pero NINGUNA instruccion del binario escribe jamas en 0x8F1E,
; asi que en el juego original no salta nunca. Topo lo dejo
; armado para que saltara si alguien pokeaba ese byte.
; ----------------------------------------------------------------------
CASTIGO_TRAMPAS:		; Afea la pantalla final si se detecto trampa
	ld a,(08f1eh)		;8b80   ; Bandera de tramposo; nadie la enciende en el binario original (no existe ningun LD (08F1Eh),A). Dato que refuerza que lo que hay ahi es relleno y no una inicializacion: 0x8F1E es el UNICO byte a cero de todo el tramo 0x8F00-0x8F40 [SUSTITUYE]
	cp 000h			;8b83
	jp z,BUCLE_FINAL		;8b85   ; Limpia: final normal
	ld hl,07f94h		;8b88   ; El texto del reproche
	ld de,019e0h		;8b8b   ; Ultima linea del area de juego (0x1800 + 15*32)
	ld bc,00020h		;8b8e
	call 0005ch		;8b91   ; BIOS LDIRVM - Block transfers to VRAM from memory

; ----------------------------------------------------------------------
; Este bucle no tiene salida y no lee el teclado: son un CALL a
; 0x872F, tres HALT y un JP hacia atras. Ni siquiera CTRL+STOP
; vale, porque BREAKX solo se consulta en 0x832A y aqui no se
; llama. Terminado el juego hay que resetear la maquina.
; ----------------------------------------------------------------------
BUCLE_FINAL:		; Bucle infinito del final: solo mueve los enemigos
	call MUEVE_ENEMIGOS		;8b94   ; Sigue animando los enemigos de la pantalla final
	halt			;8b97
	halt			;8b98
	halt			;8b99
	jp BUCLE_FINAL		;8b9a   ; El juego acaba aqui: no se vuelve al menu
EMPIEZA_NIVEL:		; Prepara el nivel: resetea arma y municion
	call L_8BE4		;8b9d
	call 00090h		;8ba0   ; BIOS GICINI - Initialises PSG and sets initial value for the PLAY statement
	ld a,(08f0eh)		;8ba3
	inc a			;8ba6
SUBE_NIVEL:		; Incrementa 0x8F0E (el nivel es variable propia, no se deduce de la pantalla)
	ld (08f0eh),a		;8ba7
	ld a,(08f0dh)		;8baa
	inc a			;8bad
	ld (08f0dh),a		;8bae
	ld hl,07f80h		;8bb1
	call ESCRIBE_ROTULO		;8bb4
	ld hl,01953h		;8bb7
	ld a,(08f0eh)		;8bba
	ld b,05dh		;8bbd
	add a,b			;8bbf
	call 0004dh		;8bc0   ; BIOS WRTVRM - Writes data in VRAM
	call L_8BFD		;8bc3
	call CARGA_ENEMIGOS		;8bc6
	call CARGA_MAPA		;8bc9
	call PINTA_MARCADOR		;8bcc
	call VUELCA_BUFFER		;8bcf
	ld a,(08f0dh)		;8bd2
	dec a			;8bd5
	ld (08f0dh),a		;8bd6
	ld a,000h		;8bd9
	ld (08f18h),a		;8bdb
	ld a,001h		;8bde
	ld (08f17h),a		;8be0
	ret			;8be3
L_8BE4:
	call OCULTA_SPRITES		;8be4
	ld bc,00300h		;8be7
	ld hl,01800h		;8bea
	ld a,000h		;8bed
	call 00056h		;8bef   ; BIOS FILVRM - Fills VRAM with value
	ret			;8bf2
ESCRIBE_ROTULO:		; LDIRVM de 10 bytes a VRAM 0x194B (rotulos de nivel y de fin)
	ld de,0194bh		;8bf3
	ld bc,0000ah		;8bf6
	call 0005ch		;8bf9   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ret			;8bfc
L_8BFD:
	call L_8C10		;8bfd
	call L_8C10		;8c00
	call L_8C10		;8c03
	call L_8C10		;8c06
	call L_8C10		;8c09
	call L_8C10		;8c0c
	ret			;8c0f
L_8C10:
	call L_8C1A		;8c10
	call L_8C1A		;8c13
	call L_8C1A		;8c16
	ret			;8c19
L_8C1A:
	halt			;8c1a
L_8C1B:
	halt			;8c1b
L_8C1C:
	halt			;8c1c
L_8C1D:
	ret			;8c1d

; ----------------------------------------------------------------------
; ############################################################
; EL GAME OVER NO DESHACE LA PILA
; ############################################################
; Aqui no se llega con un RET desde el bucle, se llega saltando
; desde dentro de rutinas anidadas, y al final 0x8C43 hace
; 'jp 08076h', o sea reinicia la partida SIN reponer SP. En todo
; el binario solo hay dos 'ld sp': el de 0x8000 (0xEFFF) y el de
; 0x8058 (0x8FFF), y los dos quedan por delante de 0x8076.
; Cuenta exacta del camino de CTRL+STOP: 0x832A hace PUSH AF (2),
; 0x832E hace 'call c,08c1eh' que apila su retorno (2) y nunca
; vuelve, y el propio 'call 0832ah' del bucle principal deja otros
; 2. Son 6 bytes de pila perdidos por cada partida abandonada, y
; se acumulan: el suelo de la pila baja 6 bytes cada vez.
; Por el camino de quedarse sin vidas pasa lo mismo (el 'jp z' de
; 0x84CF sale de una cadena de CALL sin desapilar), pero ahi no he
; contado los bytes exactos. (?)
; ----------------------------------------------------------------------
GAME_OVER:		; Fin de partida
	call 00090h		;8c1e   ; BIOS GICINI - Initialises PSG and sets initial value for the PLAY statement
	ld hl,01b04h		;8c21
	ld a,0c8h		;8c24
	call 0004dh		;8c26   ; BIOS WRTVRM - Writes data in VRAM
	ld hl,01b00h		;8c29
	ld a,0c8h		;8c2c
	call 0004dh		;8c2e   ; BIOS WRTVRM - Writes data in VRAM
	call L_8BFD		;8c31
	call L_8BE4		;8c34
	ld hl,07f8ah		;8c37
	call ESCRIBE_ROTULO		;8c3a
	call L_8BFD		;8c3d
	call L_8BFD		;8c40
	jp INIT_PRINCIPAL		;8c43   ; Reinicia la partida entrando por INIT_PRINCIPAL, o sea que se vuelve a ver el menu; pero como no se pasa por el 'ld sp,08fffh' de 0x8058, la pila arranca donde la dejo la partida anterior
CASILLA_DE_ENEMIGO:		; Pasa la posicion en pixeles de un enemigo a casilla: B = (iy+0)/8 y C = (iy+1)/8, a base de tres SRL cada uno
	ld b,(iy+000h)		;8c46
L_8C49:
	srl b			;8c49
L_8C4B:
	srl b			;8c4b
L_8C4D:
	srl b			;8c4d
L_8C4F:
	ld c,(iy+001h)		;8c4f
L_8C52:
	srl c			;8c52
L_8C54:
	srl c			;8c54
L_8C56:
	srl c			;8c56   ; Este ultimo SRL deja en el ACARREO el bit 2 de la Y del enemigo, y ese acarreo sobrevive hasta el SBC de 0x8A69 y el de 0x8A87: la caja de impacto del disparo se corre media casilla segun donde caiga el enemigo dentro de la suya
L_8C58:
	ret			;8c58
INDEXA_TABLA_B:		; HL = HL + A  (indexar una tabla de bytes)
	push de			;8c59
L_8C5A:
	ld e,a			;8c5a
L_8C5B:
	ld d,000h		;8c5b
L_8C5D:
	add hl,de		;8c5d
L_8C5E:
	pop de			;8c5e
L_8C5F:
	ret			;8c5f

; ----------------------------------------------------------------------
; DATOS attr_sprites_portada: Cuatro entradas (Y, X, patron, color) de la tabla de atributos de sprite: 29 61 04 0F / 29 7E 04 0F / 28 52 04 0F / 29 9E 04 0F. Las cuatro llevan el patron 4 y el color 0x0F (blanco). Como el juego trabaja con sprites de 16x16 (0x8003 escribe 0xF2 en el registro 1 del VDP, con el bit SIZE a 1), el patron 4 sale de 0x5020. Por las coordenadas caen las cuatro sobre la banda del logo del titulo, o sea que son adorno de la portada (?). [SUSTITUYE a la D 0x8c60 init_sprites]
;   0x8c60..0x8c70  (16 bytes)
; DATOS tabla_estado_sig: Tabla ESTADO -> ESTADO SIGUIENTE, 50 entradas, indexada por el estado actual. Se consulta en 0x830D cuando la secuencia de animacion se ha agotado. Encadena salto->caida y caida-inicial->caida-sostenida (8->7, 9->3, 10->4, 3->5, 5->5) y deja los estados de vuelo dando vueltas sobre si mismos (11->11, 12->12). Compartida con los enemigos: la llama tambien 0x8763.
;   0x8c70..0x8ca2  (50 bytes)
; DATOS tabla_direccion: Direccion del stick (0..8) -> codigo de accion del jugador
;   0x8ca2..0x8cab  (9 bytes)
; DATOS tabla_flags: Flags por estado del jugador, indexada igual que la tabla de direcciones.
;   0x8cab..0x8cb8  (13 bytes)
; DATOS plantilla_disparos: Plantilla de los 7 registros de proyectil (02 15 00 00 cada uno); el arranque la copia en 0x80BA.
;   0x8cb8..0x8cd4  (28 bytes)
; DATOS ceros_init: Ocho ceros que 0x8099, 0x80A4 y 0x80AF usan como fuente para limpiar tres bloques de 8 bytes.
;   0x8cd4..0x8cdc  (8 bytes)
; DATOS ceros_sobrantes: Cola de la reserva de ceros que empieza en 0x8CD4: hay 23 bytes a cero seguidos (0x8CD4-0x8CEA) y el codigo solo usa los 8 primeros, con los tres LDIR de BC=8 de 0x8099, 0x80A4 y 0x80AF. Estos 14 no los referencia ninguna instruccion. Que los emitio el ensamblador y no son el relleno de los huecos se ve en que en los 919 bytes de relleno localizados en el binario la racha mas larga de ceros es de solo 2 bytes. [SUSTITUYE a la D 0x8CDC 0x8E00 muerto_8CDC; el resto del rango lo cubre la D 0x8cea de abajo]
;   0x8cdc..0x8cea  (14 bytes)
; DATOS relleno_ram_sucia: 278 bytes de relleno que el volcado a cinta se llevo dentro. Ni codigo ni tabla: nadie los lee y nadie los escribe.
;   0x8cea..0x8e00  (278 bytes)
; ----------------------------------------------------------------------

; ----------------------------------------------------------------------
; ############################################################
; LOS CUATRO SPRITES DE LA PANTALLA DE PRESENTACION
; ############################################################
; Orden del arranque, instruccion a instruccion: 0x807E llama a
; 0x8315 y manda los 64 sprites fuera de pantalla; 0x8081 vuelca
; la presentacion entera (0x5CC0 -> VRAM 0x1800, 0x300 bytes);
; 0x808D-0x8096 copia estos 16 bytes a la tabla de atributos
; (VRAM 0x1B00) y 0x80C5 entra en el menu de 0xDA00. Al salir del
; menu, 0x80CB vuelve a llamar a 0x8315 y los borra: por eso estos
; cuatro sprites solo se ven en la portada y jamas en la partida.
; ----------------------------------------------------------------------
	defb 029h,061h,004h,00fh,029h,07eh,004h,00fh,028h,052h,004h,00fh,029h,09eh,004h,00fh	; 8c60  )a..)~..(R..)...
	defb 000h,000h,000h,005h,006h,005h,006h,000h,007h,003h,004h,00bh,00ch,00dh,00eh,000h	; 8c70  ................
	defb 010h,011h,012h,013h,015h,014h,016h,017h,018h,019h,01ah,01bh,01ch,01dh,01eh,01fh	; 8c80  ................
	defb 020h,021h,011h,023h,024h,026h,025h,027h,028h,029h,02ah,02bh,02ch,02dh,02eh,02fh	; 8c90   !.#$&%'()*+,-./
	defb 030h,031h,000h,008h,009h,001h,000h,000h,000h,002h,00ah,000h,05eh,0a3h,05eh,0a3h	; 8ca0  01..........^.^.
	defb 06eh,0b3h,03ah,000h,004h,001h,000h,000h,002h,015h,000h,000h,002h,015h,000h,000h	; 8cb0  n.:.............
	defb 002h,015h,000h,000h,002h,015h,000h,000h,002h,015h,000h,000h,002h,015h,000h,000h	; 8cc0  ................
	defb 002h,015h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 8cd0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,000h,0ffh,000h,0ffh	; 8ce0  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; 8cf0  ................
	defb 000h,0f5h,09bh,0f4h,082h,074h,09bh,074h,0bbh,074h,0bbh,074h,0dbh,054h,0bbh,054h	; 8d00  .....t.t.t.t.T.T
	defb 0fbh,0d4h,0ffh,044h,0ffh,044h,0bbh,044h,0bbh,044h,0bfh,054h,0bfh,044h,0bbh,044h	; 8d10  ...D.D.D.D.T.D.D
	defb 0bbh,040h,0bbh,044h,0bfh,044h,0bbh,044h,0abh,044h,0bbh,044h,0abh,044h,08bh,044h	; 8d20  .@.D.D.D.D.D.D.D
	defb 0bbh,044h,0bbh,044h,0abh,044h,0abh,044h,0abh,044h,0abh,004h,0abh,004h,08ah,054h	; 8d30  .D.D.D.D.D.....T
	defb 0fbh,054h,0fbh,054h,0fbh,0f4h,0fbh,074h,0fbh,044h,0fbh,044h,0bbh,054h,0bbh,054h	; 8d40  .T.T...t.D.D.T.T
	defb 0ffh,054h,0ebh,044h,0bbh,054h,0bbh,044h,0fbh,044h,0fbh,044h,0bbh,044h,0bfh,044h	; 8d50  .T.D.T.D.D.D.D.D
	defb 0ffh,044h,0fbh,040h,0bfh,040h,0bfh,000h,0dfh,040h,09bh,040h,0bfh,000h,0bbh,040h	; 8d60  .D.@.@...@.@...@
	defb 08bh,040h,08ah,040h,0abh,040h,0abh,040h,08bh,040h,082h,044h,08ah,044h,08ah,0ffh	; 8d70  .@.@.@.@.@.D.D..
	defb 0feh,0f4h,0deh,0f4h,0dah,0f4h,0deh,054h,0ffh,0f4h,0ffh,054h,0dfh,054h,0ffh,054h	; 8d80  .......T...T.T.T
	defb 0ffh,0d4h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h	; 8d90  ...T.T.T.T.T.T.T
	defb 0ffh,050h,0ffh,044h,0ffh,044h,0ffh,044h,0fbh,044h,0fbh,044h,0fbh,044h,0dbh,044h	; 8da0  .P.D.D.D.D.D.D.D
	defb 0fbh,044h,0bbh,044h,0fbh,044h,0bah,044h,0fbh,054h,0bbh,014h,0fbh,004h,08ah,054h	; 8db0  .D.D.D.D.T.....T
	defb 0feh,054h,0ffh,054h,0ffh,0d4h,0ffh,054h,0fbh,054h,0ffh,054h,0ffh,054h,0fbh,054h	; 8dc0  .T.T...T.T.T.T.T
	defb 0ffh,054h,0fbh,054h,0fbh,054h,0fbh,054h,0fbh,044h,0fbh,044h,0fbh,054h,0ffh,0d4h	; 8dd0  .T.T.T.T.D.D.T..
	defb 0feh,044h,0feh,040h,0ffh,044h,0ffh,050h,0deh,040h,0dah,040h,0ffh,000h,0feh,040h	; 8de0  .D.@.D.P.@.@...@
	defb 0dah,040h,0dah,040h,0fah,040h,0beh,040h,0dah,040h,0cah,044h,09ah,054h,09ah,0ffh	; 8df0  .@.@.@.@.@.D.T..

; ======================================================================
; CODIGO 0x8e00..0x8ed5  (213 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; 0x8F15 = paso (1..0x20), 0x8F16 = fila (0..0x0F). Por cada fila se redibuja
; lo que queda de la pantalla vieja desplazado `paso` columnas a la izquierda
; y se mete por la derecha ese mismo numero de columnas de la pantalla nueva.
; ----------------------------------------------------------------------
CORTINILLA:		; Scroll horizontal entre dos pantallas, una columna por paso
	ld a,001h		;8e00
	ld (08f15h),a		;8e02
L_8E05:
	ld a,000h		;8e05
	ld (08f16h),a		;8e07
L_8E0A:
	ld hl,07d80h		;8e0a   ; Origen de lo que queda de la pantalla vieja: el buffer de RAM, `paso` columnas adentro
	ld a,(08f16h)		;8e0d
	ld d,000h		;8e10
	ld e,a			;8e12
	sla e			;8e13
	rl d			;8e15
	sla e			;8e17
	rl d			;8e19
	sla e			;8e1b
	rl d			;8e1d
	sla e			;8e1f
	rl d			;8e21
	sla e			;8e23
	rl d			;8e25
	add hl,de		;8e27
	ld a,(08f15h)		;8e28
	ld d,000h		;8e2b
	ld e,a			;8e2d
	add hl,de		;8e2e
	ld a,(08f15h)		;8e2f
	ld b,000h		;8e32
	ld c,a			;8e34
	ld a,021h		;8e35   ; Longitud de lo que sobrevive de la fila vieja: 0x21 menos el paso
	sbc a,c			;8e37
	ld c,a			;8e38
	push hl			;8e39
	ld hl,01800h		;8e3a
	ld a,(08f16h)		;8e3d
	ld d,000h		;8e40
	ld e,a			;8e42
	sla e			;8e43
	rl d			;8e45
	sla e			;8e47
	rl d			;8e49
	sla e			;8e4b
	rl d			;8e4d
	sla e			;8e4f
	rl d			;8e51
	sla e			;8e53
	rl d			;8e55
	add hl,de		;8e57
	ld d,h			;8e58
	ld e,l			;8e59
	pop hl			;8e5a
	call 0005ch		;8e5b   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld hl,09200h		;8e5e   ; 0x9200 = 0x9000 + 512: el mapa de la pantalla SIGUIENTE, la que esta entrando
	ld a,(08f0dh)		;8e61
	ld d,a			;8e64
	sla d			;8e65
	ld e,000h		;8e67
	add hl,de		;8e69
	ld a,(08f16h)		;8e6a
	ld d,000h		;8e6d
	ld e,a			;8e6f
	sla e			;8e70
	rl d			;8e72
	sla e			;8e74
	rl d			;8e76
	sla e			;8e78
	rl d			;8e7a
	sla e			;8e7c
	rl d			;8e7e
	sla e			;8e80
	rl d			;8e82
	add hl,de		;8e84
	ld a,(08f15h)		;8e85
	ld b,000h		;8e88
	ld c,a			;8e8a
	push hl			;8e8b
	ld hl,01800h		;8e8c
	ld a,(08f16h)		;8e8f
	ld d,000h		;8e92
	ld e,a			;8e94
	sla e			;8e95
	rl d			;8e97
	sla e			;8e99
	rl d			;8e9b
	sla e			;8e9d
	rl d			;8e9f
	sla e			;8ea1
	rl d			;8ea3
	sla e			;8ea5
	rl d			;8ea7
	add hl,de		;8ea9
	ld a,(08f15h)		;8eaa
	ld e,a			;8ead
	ld a,020h		;8eae
	sbc a,e			;8eb0
	ld e,a			;8eb1
	ld d,000h		;8eb2
	add hl,de		;8eb4
	ld d,h			;8eb5
	ld e,l			;8eb6
	pop hl			;8eb7
	call 0005ch		;8eb8   ; BIOS LDIRVM - Block transfers to VRAM from memory
	ld a,(08f16h)		;8ebb
	inc a			;8ebe
	ld (08f16h),a		;8ebf
	cp 010h			;8ec2
	jp nz,L_8E0A		;8ec4
	ld a,(08f15h)		;8ec7
	inc a			;8eca
	ld (08f15h),a		;8ecb
	cp 021h			;8ece
	ret z			;8ed0
	halt			;8ed1
	jp L_8E05		;8ed2   ; Fin del codigo de verdad: salto incondicional, no se cae hacia el relleno de 0x8ED5

; ----------------------------------------------------------------------
; DATOS relleno_ram_sucia_2: 43 bytes del mismo relleno, entre el final de la cortinilla (0x8ED4) y el bloque de variables. Cuatro pruebas independientes de que estan muertos: 0x8ED2 es un JP incondicional a 0x8E05, asi que no se cae aqui; en todo el binario solo hay dos palabras cuyo valor cae en 0x8ED5-0x8F00 y las dos son falsas (la de 0x7C17 es un dato de la tabla de enemigos y la de 0xD1A9, que vale 0x8EDD, son los bytes DD 8E de un ADC A,(IX+2Ch) real); en el codigo trazado no hay ni un IX/IY con desplazamiento negativo, el mayor es +0x2D; y los cuatro volcados de RAM con el juego corriendo los dejan intactos. Son byte a byte iguales a 0xCED5-0xCF00. OJO: no es relleno de alineacion del ensamblador, es el mismo relleno de RAM sucia descrito en 0x8CEA, y continua sin corte hasta 0x8FFF, donde ya lo pisan las variables y la pila. [SUSTITUYE a la D 0x8ED5 muerto_8ED5]
;   0x8ed5..0x8f00  (43 bytes)
; DATOS vars_juego: Variables del juego. Las identificadas: 0x8F09/0x8F0A = X/Y del jugador; 0x8F0D = pantalla; 0x8F0E = nivel; 0x8F12 = vidas.
;   0x8f00..0x8f30  (48 bytes)
; DATOS enemigos_activos: Enemigos en juego: 4 registros de 5 bytes.
;   0x8f20..0x8f80  (96 bytes)
; DATOS disparos_activos: Proyectiles en vuelo: 7 registros, plantilla inicial en 0x8CB8.
;   0x8f80..0x8fa0  (32 bytes)
; DATOS objetos_activos: Los cuatro puntos ocultos de la pantalla en curso, 4 registros de 4 bytes. Los siembra el LDIR de 0x887E copiando 16 bytes desde 0x79C0 + pantalla*16 (el origen se calcula en 0x8863-0x8877 con cuatro SLA E/RL D). VERIFICADO con el juego corriendo: en dump/scr25.ram y dump/poketest.ram, parados en la pantalla 0, los 16 bytes valen 04 0A FF AC 14 05 FE AD y ocho ceros, identicos a 0x79C0-0x79CF; en dump/running_full.bin, volcado en el menu, todavia se ven los bytes de la cinta porque el LDIR aun no ha corrido. Aqui NO sobra nada: de 0x8FB0 en adelante ya es pila. [SUSTITUYE a la D 0x8FA0 0x9000 pila; la pila la declara la D de abajo]
;   0x8fa0..0x8fb0  (16 bytes)
; DATOS pila: Espacio de pila. SP arranca en 0x8FFF (0x8058) y crece hacia abajo. Como lo que se empuja se queda escrito aunque luego se haga POP, un volcado ensena la marca de agua de toda la ejecucion: en dump/scr25.ram los 46 bytes de 0x8FD1 a 0x8FFE estan cambiados TODOS respecto a la cinta, sin una sola coincidencia, y 0x8FB0-0x8FD0 sigue tal cual venia. O sea 46 bytes de pila usados de verdad, unos 23 niveles con las interrupciones incluidas, y 33 de colchon hasta los rompibles de 0x8FA0. 0x8FFF no cambia nunca, como corresponde a SP=0x8FFF: el primer PUSH ya escribe en 0x8FFE. OJO: esos 33 bytes son la holgura OBSERVADA en volcados de menu y de pantalla 0, no un limite demostrado, y ademas cada partida abandonada pierde 6 bytes de pila (ver 0x8C1E), asi que el colchon se come solo. (?)
;   0x8fb0..0x9000  (80 bytes)
; DATOS mapa_p00: Pantalla 0 (nivel 1, marcador 1/7). 2 enemigos, 1 calavera. Puntos ocultos: (4,10) a 1 disparo da 0xAC sobre la calavera; (20,5) a 2 disparos da 0xAD en el aire. [SUSTITUYE a la D 0x9000 0xCA00 mapas_pantalla: las 29 D de aqui cubren el rango entero]
;   0x9000..0x9200  (512 bytes)
; DATOS mapa_p01: Pantalla 1 (nivel 1, marcador 2/7). 3 enemigos, un 0xAC a la vista, sin puntos ocultos.
;   0x9200..0x9400  (512 bytes)
; DATOS mapa_p02: Pantalla 2 (nivel 1, marcador 3/7). 2 enemigos, un 0xAB a la vista, sin puntos ocultos.
;   0x9400..0x9600  (512 bytes)
; DATOS mapa_p03: Pantalla 3 (nivel 1, marcador 4/7). 3 enemigos, 1 calavera. Puntos ocultos: (13,14) a 5 disparos da 0xAC sobre la calavera; (1,7) a 2 disparos da 0xAB en el aire.
;   0x9600..0x9800  (512 bytes)
; DATOS mapa_p04: Pantalla 4 (nivel 1, marcador 5/7). 3 enemigos, sin recogibles ni puntos ocultos.
;   0x9800..0x9a00  (512 bytes)
; DATOS mapa_p05: Pantalla 5 (nivel 1, marcador 6/7). 3 enemigos, 1 calavera con 0xAD a los 4 disparos en (6,11).
;   0x9a00..0x9c00  (512 bytes)
; DATOS mapa_p06: Pantalla 6 (nivel 1, marcador 7/7). 4 enemigos, nada que recoger. Ultima del nivel 1: el 'cp 006h' de 0x8B09 salta desde aqui al cambio de nivel.
;   0x9c00..0x9e00  (512 bytes)
; DATOS mapa_p07: Pantalla 7 (nivel 2, marcador 1/7). 4 enemigos. Un solo punto oculto, (20,4) a 3 disparos, y da las ALITAS 0xAA; esta en el aire, no sobre cofre ni calavera.
;   0x9e00..0xa000  (512 bytes)
; DATOS mapa_p08: Pantalla 8 (nivel 2, marcador 2/7). 3 enemigos, 56 casillas mortales, un 0xAC y un 0xAD a la vista, sin puntos ocultos.
;   0xa000..0xa200  (512 bytes)
; DATOS mapa_p09: Pantalla 9 (nivel 2, marcador 3/7). 3 enemigos, 72 casillas mortales, 1 cofre en (28,10) que suelta 0xAD a un solo disparo.
;   0xa200..0xa400  (512 bytes)
; DATOS mapa_p10: Pantalla 10 (nivel 2, marcador 4/7). 4 enemigos, 3 calaveras. Puntos ocultos: (14,10) a 7 disparos, el mas duro del juego, da 0xAC sobre calavera; (19,14) a 2 disparos da las ALITAS 0xAA sobre decorado (tile 0x8A).
;   0xa400..0xa600  (512 bytes)
; DATOS mapa_p11: Pantalla 11 (nivel 2, marcador 5/7). 4 enemigos, 1 calavera. Puntos ocultos: (26,2) a 5 disparos da 0xAD sobre la calavera; (28,7) a 4 disparos da 0xAC en el aire.
;   0xa600..0xa800  (512 bytes)
; DATOS mapa_p12: Pantalla 12 (nivel 2, marcador 6/7). 4 enemigos, 1 calavera y 1 cofre. Puntos ocultos: (12,6) a 5 disparos da 0xAC sobre la calavera; (11,11) a 5 disparos da 0xAB sobre el cofre.
;   0xa800..0xaa00  (512 bytes)
; DATOS mapa_p13: Pantalla 13 (nivel 2, marcador 7/7). 4 enemigos, nada que recoger. Ultima del nivel 2: el 'cp 00dh' de 0x8B09 entra al nivel 3, que de paso recarga 0x4C0 bytes de patrones de sprite desde 0x5800 a VRAM 0x3B40.
;   0xaa00..0xac00  (512 bytes)
; DATOS mapa_p14: Pantalla 14 (nivel 3, marcador 1/7). 3 enemigos, 1 calavera, 10 casillas mortales, un 0xAD a la vista. Puntos ocultos: (10,5) a 1 disparo da 0xAC sobre la calavera; (20,6) a 6 disparos da 0xAB en el aire.
;   0xac00..0xae00  (512 bytes)
; DATOS mapa_p15: Pantalla 15 (nivel 3, marcador 2/7). 4 enemigos, 1 calavera, un 0xAB y un 0xAC a la vista. Puntos ocultos: (30,11) a 6 disparos da 0xAD sobre la calavera; (16,7) a 6 disparos da 0xAB en el aire.
;   0xae00..0xb000  (512 bytes)
; DATOS mapa_p16: Pantalla 16 (nivel 3, marcador 3/7). 4 enemigos, 1 cofre, 63 casillas mortales y DOS tiles 0xAC a la vista: al coger uno, 0x8AE3 borra siempre el primero. Puntos ocultos: (2,14) a 1 disparo da 0xAB sobre el cofre; (21,5) a 2 disparos da 0xAD en el aire.
;   0xb000..0xb200  (512 bytes)
; DATOS mapa_p17: Pantalla 17 (nivel 3, marcador 4/7). 4 enemigos, 1 calavera, 6 casillas mortales, un 0xAB a la vista. Punto oculto: (10,14) a 6 disparos da 0xAC sobre la calavera.
;   0xb200..0xb400  (512 bytes)
; DATOS mapa_p18: Pantalla 18 (nivel 3, marcador 5/7). 3 enemigos, 1 calavera, 11 casillas mortales. Punto oculto: (9,8) a 3 disparos da 0xAC sobre la calavera.
;   0xb400..0xb600  (512 bytes)
; DATOS mapa_p19: Pantalla 19 (nivel 3, marcador 6/7). 4 enemigos, 1 calavera, un 0xAB a la vista. Punto oculto: (2,10) a 2 disparos da 0xAD sobre la calavera.
;   0xb600..0xb800  (512 bytes)
; DATOS mapa_p20: Pantalla 20 (nivel 3, marcador 7/7). 4 enemigos, 19 casillas mortales, sin puntos ocultos. Ultima del nivel 3: el 'cp 014h' de 0x8B09 salta a 0x8B55, que enciende el modo flotar.
;   0xb800..0xba00  (512 bytes)
; DATOS mapa_p21: Pantalla 21 (nivel 4, marcador 1/7). 3 enemigos, 2 calaveras, un 0xAC a la vista y 126 casillas mortales, la mas hostil del juego. Puntos ocultos: (11,9) a 6 disparos da 0xAD y (15,8) a 2 disparos da 0xAC, los dos sobre calavera.
;   0xba00..0xbc00  (512 bytes)
; DATOS mapa_p22: Pantalla 22 (nivel 4, marcador 2/7). 3 enemigos, 125 casillas mortales, un 0xAC y un 0xAD a la vista. Punto oculto: (9,10) a 6 disparos da 0xAC sobre un tile 0xCB de decorado.
;   0xbc00..0xbe00  (512 bytes)
; DATOS mapa_p23: Pantalla 23 (nivel 4, marcador 3/7). 4 enemigos, sin recogibles ni puntos ocultos.
;   0xbe00..0xc000  (512 bytes)
; DATOS mapa_p24: Pantalla 24 (nivel 4, marcador 4/7). 3 enemigos, un 0xAC a la vista, sin puntos ocultos.
;   0xc000..0xc200  (512 bytes)
; DATOS mapa_p25: Pantalla 25 (nivel 4, marcador 5/7). 3 enemigos, 16 casillas mortales. Punto oculto: (5,5) a 6 disparos da 0xAB en el aire.
;   0xc200..0xc400  (512 bytes)
; DATOS mapa_p26: Pantalla 26 (nivel 4, marcador 6/7). 4 enemigos, 1 calavera y 37 casillas mortales. La calavera de (3,4) es una TRAMPA: a los 6 disparos suelta el tile 0xF4, que es de clase 7 y mata al tocarlo.
;   0xc400..0xc600  (512 bytes)
; DATOS mapa_p27: Pantalla 27 (nivel 4, marcador 7/7). 4 enemigos y SEIS tiles 0xAB de vida a la vista, el atracon final. Sus tres puntos ocultos (8,12), (10,10) y (9,8) llevan premio 0x00 sobre tiles 0xD5: no dan nada, son bloques que se rompen de un disparo para abrir paso. Ultima jugable: el 'cp 01bh' de 0x8B09 pasa a la pantalla de victoria.
;   0xc600..0xc800  (512 bytes)
; DATOS mapa_p28: Pantalla 28: la de VICTORIA. La carga la misma 0x8ACE despues de que 0x8B6D incremente 0x8F0D a 28, y 0x8B74 le carga ademas sus cuatro enemigos decorativos. Arriba hay arcos dibujados con tiles; el texto del final empieza EXACTAMENTE en 0xC962 (de 0xC93B a 0xC961 son tiles 0x00, o sea la linea en blanco anterior): la direccion 0xC93B que da docs/CONTEXTO.md apunta al hueco, no al texto.
;   0xc800..0xca00  (512 bytes)
; DATOS codigo_muerto: Codigo de OTRA COMPILACION que quedo en el binario y nunca se ejecuta. Desensambla bien porque es codigo real, pero no pertenece al juego que corre; no se traza para no ensuciar el listado.
;   0xca00..0xd000  (1536 bytes)
; ----------------------------------------------------------------------
	defb 054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,044h,0ffh,040h,0ffh	; 8ed5  T.T.T.T.T.T.D.@.
	defb 054h,0ffh,054h,0deh,044h,0dfh,044h,0ffh,044h,0ffh,040h,0deh,044h,0deh,044h,0feh	; 8ee5  T.T.D.D.D.@.D.D.
	defb 044h,0beh,044h,0deh,044h,0cah,044h,09ah,054h,09ah,0ffh	; 8ef5
VAR_FLAGS_TMP:		; Copia del byte de flags del estado, la usa 0x81D6
	defb 0deh,0b4h,0deh,0b4h,0deh	; 8f00  .....
	defb 034h,0deh,014h,0dfh	; 8f05
VAR_JUGADOR_X:
	defb 014h,0ffh,014h,0dfh,014h,0dfh,014h,0ffh,014h,0ffh,014h,0ffh	; 8f09  ............
VAR_IDX_BUCLE:		; Indice de trabajo compartido: numero de ranura en 0x872F, 0x8933, 0x8885, 0x87FE y 0x8698; en 0x872F vale ademas plano de sprite / 2
	defb 014h,0ffh,004h,0ffh,004h,0ffh,014h,0ffh,004h,000h,014h,0ffh,004h,0ffh,004h,0ffh	; 8f15  ................
	defb 004h,0ffh,004h,0ffh,004h,0fbh,004h,0dbh,004h,0cbh,004h,0fbh,004h,0fbh,004h,0fbh	; 8f25  ................
	defb 004h,0cbh,004h,0ebh,004h,0fbh,014h,0cbh,004h,0cah,014h,0ffh,014h,0dfh,014h,0ffh	; 8f35  ................
	defb 014h,0ffh,014h,0feh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,014h,0deh,004h,0ffh	; 8f45  ................
	defb 014h,0ffh,014h,0ffh,004h,0fbh,004h,0ffh,004h,0ffh,014h,0deh,004h,0deh,004h,0ffh	; 8f55  ................
	defb 004h,0ffh,000h,0deh,004h,0deh,004h,0ffh,004h,0deh,000h,0ceh,004h,0dah,004h,0dah	; 8f65  ................
	defb 004h,0ceh,004h,0cah,004h,0cah,004h,0cah,014h,0cah,0f7h	; 8f75
VAR_DISPAROS:		; 7 registros de 4 bytes (columna, fila, direccion -1/0/+1, tile de fondo que tapan); los siembra 0x80BA desde 0x8CB8
	defb 0f6h,0b4h,0deh,0b4h,0deh	; 8f80  .....
	defb 034h,0deh,014h,0ffh,034h,0ffh,014h,0ffh,014h,0ffh,014h,0ffh,094h,0ffh,004h,0ffh	; 8f85  4...4...........
	defb 014h,0ffh,004h,0ffh,004h,0ffh,014h,0ffh,004h,0ffh,004h	; 8f95
VAR_ROMPIBLES:		; 4 registros de 4 bytes (columna, fila, contador de impactos, tile que revela); los siembra 0x87FE desde 0x79C0+pantalla*16
	defb 0ffh,004h,0ffh,004h,0ffh	; 8fa0  .....
	defb 004h,0ffh,004h,0ffh,004h,0fbh,004h,0fbh,004h,0fbh,004h,0fbh,004h,0fbh,004h,0fah	; 8fa5  ................
	defb 004h,0eah,004h,0fbh,004h,0fbh,004h,0eah,004h,0cah,004h,0feh,014h,0feh,014h,0feh	; 8fb5  ................
	defb 014h,0ffh,014h,0feh,004h,0feh,004h,0ffh,014h,0ffh,014h,0feh,004h,0feh,004h,0ffh	; 8fc5  ................
	defb 014h,0ffh,004h,0fbh,004h,0fbh,004h,0ffh,004h,0feh,004h,0feh,004h,0fah,000h,0feh	; 8fd5  ................
	defb 004h,0feh,000h,0deh,000h,0deh,004h,0feh,000h,0feh,000h,0ceh,000h,0cah,004h,0fah	; 8fe5  ................
	defb 004h,0feh,000h,0cah,000h,0cah,004h,0cah,004h,0cah,0f7h,07bh,07bh,07bh,07bh,07bh	; 8ff5  ...........{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,074h,07bh,073h,07bh,07bh,07bh,07bh,07bh,073h,07bh	; 9005  {{{{{{t{s{{{{{s{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07ah,07ah,07ah,07ah,07ah	; 9015  {{{{{{{{{{{zzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,073h,07ah,074h,07ah,07ah,07ah,07ah,07ah,073h,07ah	; 9025  zzzzzzsztzzzzzsz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,079h,079h,079h,079h,079h	; 9035  zzzzzzzzzzzyyyyy
	defb 079h,079h,079h,079h,079h,079h,073h,079h,073h,079h,079h,079h,079h,079h,074h,079h	; 9045  yyyyyysysyyyyyty
	defb 079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,07ah,07ah,07ah,07ah,07ah	; 9055  yyyyyyyyyyyzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,074h,07ah,074h,07ah,07ah,07ah,07ah,07ah,073h,07ah	; 9065  zzzzzztztzzzzzsz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07bh,07bh,07bh,07bh,07bh	; 9075  zzzzzzzzzzz{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,074h,07bh,073h,07bh,07bh,07bh,07bh,07bh,074h,07bh	; 9085  {{{{{{t{s{{{{{t{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,000h,000h,000h,0a9h,000h	; 9095  {{{{{{{{{{{.....
	defb 000h,000h,000h,000h,000h,000h,073h,000h,074h,000h,000h,000h,000h,000h,073h,000h	; 90a5  ......s.t.....s.
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0a9h,000h	; 90b5  ................
	defb 000h,000h,000h,000h,000h,000h,073h,000h,073h,000h,000h,000h,000h,000h,074h,000h	; 90c5  ......s.s.....t.
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0a9h,000h	; 90d5  ................
	defb 000h,000h,000h,000h,000h,000h,074h,000h,074h,000h,000h,000h,000h,000h,073h,000h	; 90e5  ......t.t.....s.
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0a9h,0a9h	; 90f5  ................
	defb 000h,000h,000h,000h,000h,000h,073h,0a9h,074h,000h,000h,000h,000h,000h,073h,000h	; 9105  ......s.t.....s.
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0a9h,0a9h	; 9115  ................
	defb 000h,000h,000h,000h,000h,000h,073h,0a9h,074h,000h,000h,000h,000h,000h,073h,000h	; 9125  ......s.t.....s.
	defb 000h,000h,000h,000h,000h,0e9h,0eah,000h,000h,000h,000h,000h,000h,000h,0a9h,0d0h	; 9135  ................
	defb 000h,000h,000h,000h,000h,000h,074h,0a9h,074h,000h,000h,000h,000h,000h,073h,085h	; 9145  ......t.t.....s.
	defb 000h,0e9h,0eah,000h,000h,0ebh,0ech,000h,000h,000h,000h,000h,000h,000h,0e9h,0eah	; 9155  ................
	defb 000h,000h,000h,000h,000h,000h,073h,0a9h,074h,000h,000h,000h,000h,085h,074h,086h	; 9165  ......s.t.....t.
	defb 000h,0ebh,0ech,000h,000h,0ebh,0ech,000h,000h,000h,000h,000h,000h,000h,0ebh,0ech	; 9175  ................
	defb 000h,000h,0e9h,0eah,000h,000h,073h,000h,074h,000h,000h,000h,000h,087h,073h,087h	; 9185  ......s.t.....s.
	defb 0e9h,0ebh,0ech,000h,000h,0ebh,0ech,000h,000h,000h,000h,0eah,000h,000h,0ebh,0ech	; 9195  ................
	defb 000h,000h,0ebh,0ech,0eah,000h,074h,000h,0e9h,0eah,000h,000h,000h,086h,074h,086h	; 91a5  ......t.......t.
	defb 0e9h,0eah,0ech,000h,0e9h,0ebh,0ech,000h,000h,000h,000h,0ech,038h,039h,0ebh,0e8h	; 91b5  ............89..
	defb 039h,038h,0e8h,0ech,0ech,039h,074h,039h,0ebh,0ech,038h,039h,038h,087h,073h,087h	; 91c5  98...9t9..898.s.
	defb 0ebh,0ech,0e8h,039h,0ebh,0ebh,0e8h,038h,038h,039h,038h,0dch,0dch,0dch,0dch,0dch	; 91d5  ...9...8898.....
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; 91e5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,07bh,07bh,07bh,07bh,07bh	; 91f5  ...........{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh	; 9205  {{{{{{{{{{{{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07ah,07ah,07ah,07ah,07ah	; 9215  {{{{{{{{{{{zzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah	; 9225  zzzzzzzzzzzzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,079h,079h,079h,079h,079h	; 9235  zzzzzzzzzzzyyyyy
	defb 079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h	; 9245  yyyyyyyyyyyyyyyy
	defb 079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,07ah,07ah,07ah,07ah,07ah	; 9255  yyyyyyyyyyyzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah	; 9265  zzzzzzzzzzzzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07bh,07bh,07bh,07bh,07bh	; 9275  zzzzzzzzzzz{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh	; 9285  {{{{{{{{{{{{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,000h,000h,000h,000h,000h	; 9295  {{{{{{{{{{{.....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h	; 92a5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h	; 92b5  ................
	defb 000h,000h,029h,02ah,000h,000h,000h,000h,000h,0a9h,000h,000h,029h,02ah,000h,000h	; 92c5  ..)*........)*..
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h	; 92d5  ................
	defb 000h,000h,02bh,02ch,000h,000h,000h,000h,000h,000h,000h,000h,02bh,02ch,000h,000h	; 92e5  ..+,........+,..
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 92f5  ................
	defb 0a9h,000h,02dh,02eh,033h,034h,000h,000h,000h,000h,0a9h,000h,02dh,02eh,000h,000h	; 9305  ..-.34......-...
	defb 0ddh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9315  ................
	defb 0a9h,000h,02fh,030h,031h,031h,000h,000h,000h,000h,0a9h,000h,02fh,036h,032h,0deh	; 9325  ../011....../62.
	defb 0dfh,0e0h,032h,032h,0ddh,032h,032h,032h,032h,032h,032h,000h,000h,000h,0ach,000h	; 9335  ..22.222222.....
	defb 0a9h,000h,02fh,035h,031h,031h,000h,000h,000h,000h,0ddh,000h,02fh,036h,031h,031h	; 9345  ../511....../611
	defb 0e1h,031h,031h,0deh,0dfh,0e0h,031h,031h,0ddh,031h,031h,000h,000h,000h,0e9h,0eah	; 9355  .11...11.11.....
	defb 000h,000h,02fh,035h,031h,031h,000h,000h,000h,0deh,0dfh,0e0h,02fh,036h,031h,031h	; 9365  ../511....../611
	defb 0e1h,031h,031h,031h,0e1h,031h,031h,0deh,0dfh,0e0h,031h,000h,000h,000h,0ebh,0ech	; 9375  .111.11...1.....
	defb 000h,000h,02fh,035h,031h,031h,000h,000h,000h,000h,0e1h,000h,02fh,036h,031h,031h	; 9385  ../511....../611
	defb 0e1h,031h,031h,0e2h,0e3h,0e4h,031h,031h,0e1h,031h,031h,000h,000h,0e9h,0eah,0ech	; 9395  .11...11.11.....
	defb 000h,000h,02fh,035h,031h,031h,000h,000h,000h,0e2h,0e3h,0e4h,02fh,036h,031h,0e2h	; 93a5  ../511....../61.
	defb 0e3h,0e4h,031h,0e6h,0e5h,0e7h,031h,031h,0e1h,031h,031h,039h,038h,0ebh,0ech,0ech	; 93b5  ..1...11.1198...
	defb 039h,038h,037h,035h,031h,031h,038h,039h,038h,0dah,0dah,0dah,037h,037h,039h,0dah	; 93c5  987511898...779.
	defb 0dah,0dah,039h,0dah,0dah,0dah,039h,0e2h,0e3h,0e4h,039h,0dch,0dch,0dch,0dch,0dch	; 93d5  ..9...9...9.....
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; 93e5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,07bh,07bh,07bh,07bh,07bh	; 93f5  ...........{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh	; 9405  {{{{{{{{{{{{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07ah,07ah,07ah,07ah,07ah	; 9415  {{{{{{{{{{{zzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah	; 9425  zzzzzzzzzzzzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,079h,079h,079h,079h,079h	; 9435  zzzzzzzzzzzyyyyy
	defb 079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h	; 9445  yyyyyyyyyyyyyyyy
	defb 079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,07ah,07ah,07ah,07ah,07ah	; 9455  yyyyyyyyyyyzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah	; 9465  zzzzzzzzzzzzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07bh,07bh,07bh,07bh,07bh	; 9475  zzzzzzzzzzz{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh	; 9485  {{{{{{{{{{{{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,000h,000h,0a9h,000h,000h	; 9495  {{{{{{{{{{{.....
	defb 000h,000h,000h,000h,000h,000h,0a9h,000h,000h,029h,02ah,000h,000h,000h,000h,000h	; 94a5  .........)*.....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,029h,02ah,0a9h,000h,000h	; 94b5  ...........)*...
	defb 000h,000h,000h,000h,000h,000h,0a9h,000h,000h,02bh,02ch,000h,000h,000h,000h,000h	; 94c5  .........+,.....
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,029h,02ah,02bh,02ch,0a9h,000h,000h	; 94d5  .........)*+,...
	defb 000h,000h,000h,000h,000h,000h,0a9h,000h,000h,02dh,02eh,000h,000h,000h,000h,000h	; 94e5  .........-......
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,02bh,02ch,02dh,02eh,0a9h,000h,000h	; 94f5  .........+,-....
	defb 000h,000h,000h,000h,000h,000h,0ddh,000h,000h,02fh,036h,000h,000h,000h,000h,000h	; 9505  ........./6.....
	defb 000h,0ddh,000h,000h,0abh,000h,000h,000h,000h,02dh,02eh,02fh,036h,032h,032h,032h	; 9515  .........-./6222
	defb 032h,032h,032h,032h,032h,0deh,0dfh,0e0h,032h,02fh,036h,032h,032h,032h,032h,032h	; 9525  22222...2/622222
	defb 0deh,0dfh,0e0h,032h,032h,032h,032h,032h,032h,02fh,036h,02fh,036h,031h,031h,0ddh	; 9535  ...222222/6/611.
	defb 031h,031h,031h,031h,031h,031h,0e1h,031h,031h,02fh,0ddh,031h,031h,031h,031h,031h	; 9545  111111.11/.11111
	defb 031h,0e1h,031h,031h,031h,031h,031h,031h,031h,02fh,036h,02fh,036h,031h,0deh,0dfh	; 9555  1.1111111/6/61..
	defb 0e0h,031h,031h,031h,031h,031h,0e1h,031h,031h,0deh,0dfh,0e0h,031h,031h,031h,031h	; 9565  .11111.11...1111
	defb 0e2h,0e3h,0e4h,031h,031h,031h,031h,031h,031h,02fh,036h,02fh,036h,031h,031h,0e1h	; 9575  ...111111/6/611.
	defb 031h,031h,031h,031h,031h,031h,0e1h,031h,031h,02fh,0e1h,031h,031h,031h,031h,031h	; 9585  111111.11/.11111
	defb 0e6h,0e5h,0e7h,031h,031h,031h,031h,031h,031h,02fh,036h,02fh,036h,031h,0e2h,0e3h	; 9595  ...111111/6/61..
	defb 0e4h,031h,031h,031h,0e2h,0e3h,0e3h,0e3h,0e4h,02fh,0e1h,031h,031h,031h,0d1h,0d2h	; 95a5  .111...../.111..
	defb 0e6h,0e5h,0e7h,031h,031h,031h,031h,031h,031h,02fh,036h,037h,037h,039h,0dah,0dah	; 95b5  ...111111/6779..
	defb 0dah,038h,039h,038h,0dah,0dah,0dah,0dah,0dah,0e2h,0e3h,0e4h,038h,039h,0d3h,0d4h	; 95c5  .898........89..
	defb 0dah,0dah,0dah,039h,039h,038h,039h,038h,038h,02fh,036h,0dch,0dch,0dch,0dch,0dch	; 95d5  ...998988/6.....
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; 95e5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,07bh,07bh,07bh,07bh,07bh	; 95f5  ...........{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh	; 9605  {{{{{{{{{{{{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07ah,07ah,07ah,07ah,07ah	; 9615  {{{{{{{{{{{zzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah	; 9625  zzzzzzzzzzzzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,079h,079h,079h,079h,079h	; 9635  zzzzzzzzzzzyyyyy
	defb 079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h	; 9645  yyyyyyyyyyyyyyyy
	defb 079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,07ah,07ah,07ah,07ah,07ah	; 9655  yyyyyyyyyyyzzzzz
	defb 07ah,07ah,07ah,07ah,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh	; 9665  zzzz............
	defb 01fh,01fh,01fh,01fh,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07bh,07bh,07bh,07bh,07bh	; 9675  ....zzzzzzz{{{{{
	defb 07bh,07bh,07bh,07bh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh	; 9685  {{{{............
	defb 01fh,01fh,01fh,01fh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,0a9h,000h,000h,000h,000h	; 9695  ....{{{{{{{.....
	defb 000h,000h,0a9h,0a9h,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh	; 96a5  ................
	defb 01fh,01fh,01fh,01fh,000h,000h,000h,000h,000h,000h,0a9h,0a9h,000h,000h,000h,000h	; 96b5  ................
	defb 000h,000h,0a9h,0a9h,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh	; 96c5  ................
	defb 0dbh,0dbh,0dbh,0dbh,000h,000h,000h,000h,000h,000h,0a9h,0a9h,000h,000h,000h,000h	; 96d5  ................
	defb 000h,000h,0a9h,0a9h,021h,021h,021h,021h,021h,021h,021h,021h,021h,021h,021h,021h	; 96e5  ....!!!!!!!!!!!!
	defb 021h,021h,021h,021h,000h,000h,000h,000h,000h,000h,0a9h,0a9h,000h,000h,000h,000h	; 96f5  !!!!............
	defb 000h,000h,0d5h,0d7h,027h,028h,020h,026h,028h,020h,026h,028h,020h,026h,028h,020h	; 9705  ....'( &( &( &( 
	defb 026h,028h,026h,027h,000h,000h,000h,000h,000h,000h,000h,032h,032h,032h,032h,032h	; 9715  &(&'.......22222
	defb 032h,032h,0d1h,0d2h,028h,020h,020h,022h,023h,027h,022h,023h,027h,022h,023h,027h	; 9725  22..(  "#'"#'"#'
	defb 022h,023h,028h,026h,032h,032h,032h,032h,032h,032h,032h,031h,031h,031h,031h,031h	; 9735  "#(&222222211111
	defb 031h,031h,0d3h,0d4h,027h,028h,020h,024h,025h,027h,024h,025h,027h,024h,025h,027h	; 9745  11..'( $%'$%'$%'
	defb 024h,025h,026h,027h,031h,031h,031h,031h,031h,031h,031h,031h,031h,031h,031h,031h	; 9755  $%&'111111111111
	defb 031h,0d1h,0d2h,0d1h,028h,020h,020h,000h,0a9h,004h,000h,000h,004h,000h,000h,004h	; 9765  1...(  .........
	defb 000h,0a9h,020h,026h,031h,031h,031h,031h,031h,031h,031h,031h,031h,031h,031h,031h	; 9775  .. &111111111111
	defb 031h,0d3h,0d4h,0d3h,027h,028h,020h,000h,0a9h,00eh,000h,000h,00eh,000h,000h,00eh	; 9785  1...'( .........
	defb 000h,0a9h,026h,027h,031h,031h,031h,031h,031h,031h,031h,031h,031h,031h,031h,031h	; 9795  ..&'111111111111
	defb 0d1h,0d2h,0d1h,0d2h,028h,020h,020h,000h,0a9h,00eh,000h,000h,00eh,000h,000h,00eh	; 97a5  ....(  .........
	defb 000h,0a9h,020h,026h,031h,031h,031h,031h,031h,031h,031h,039h,038h,039h,038h,039h	; 97b5  .. &111111198989
	defb 0d3h,0d4h,0d3h,0d4h,027h,028h,020h,000h,0d0h,00eh,000h,000h,00eh,000h,000h,00eh	; 97c5  ....'( .........
	defb 000h,0a9h,026h,027h,038h,039h,039h,038h,038h,039h,038h,0dch,0dch,0dch,0dch,0dch	; 97d5  ..&'8998898.....
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; 97e5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,07bh,07bh,07bh,07bh,07bh	; 97f5  ...........{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh	; 9805  {{{{{{{{{{{{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07ah,07ah,07ah,07ah,07ah	; 9815  {{{{{{{{{{{zzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh	; 9825  zzzzzz..........
	defb 01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,07ah,079h,079h,079h,079h,079h	; 9835  ..........zyyyyy
	defb 079h,079h,079h,079h,079h,079h,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh	; 9845  yyyyyy..........
	defb 01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,079h,07ah,07ah,07ah,07ah,07ah	; 9855  ..........yzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh	; 9865  zzzzzz..........
	defb 01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,07ah,07bh,07bh,07bh,07bh,07bh	; 9875  ..........z{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh	; 9885  {{{{{{..........
	defb 01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh,07bh,000h,000h,000h,000h,000h	; 9895  ..........{.....
	defb 000h,000h,000h,000h,000h,000h,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh	; 98a5  ................
	defb 0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,0dbh,000h,000h,000h,000h,000h,000h	; 98b5  ................
	defb 000h,000h,000h,000h,000h,000h,021h,021h,021h,021h,021h,021h,021h,021h,021h,021h	; 98c5  ......!!!!!!!!!!
	defb 021h,021h,021h,021h,021h,021h,021h,021h,021h,021h,000h,000h,000h,000h,000h,000h	; 98d5  !!!!!!!!!!......
	defb 000h,000h,000h,000h,000h,000h,027h,028h,020h,026h,028h,020h,020h,026h,028h,020h	; 98e5  ......'( &(  &( 
	defb 020h,026h,028h,020h,020h,020h,020h,020h,020h,026h,000h,000h,000h,000h,000h,000h	; 98f5   &(      &......
	defb 000h,000h,000h,000h,000h,000h,028h,020h,026h,022h,023h,028h,026h,022h,023h,028h	; 9905  ......( &"#(&"#(
	defb 026h,022h,023h,028h,020h,020h,020h,020h,026h,027h,000h,032h,032h,032h,032h,032h	; 9915  &"#(    &'.22222
	defb 032h,032h,032h,032h,032h,032h,027h,028h,026h,024h,025h,028h,026h,024h,025h,028h	; 9925  222222'(&$%(&$%(
	defb 026h,024h,025h,028h,020h,020h,020h,020h,020h,026h,000h,031h,031h,031h,031h,031h	; 9935  &$%(     &.11111
	defb 031h,031h,031h,031h,031h,031h,028h,020h,026h,000h,0a9h,028h,026h,000h,000h,028h	; 9945  111111( &..(&..(
	defb 026h,0a9h,000h,028h,020h,020h,0d1h,0d2h,026h,027h,000h,031h,031h,031h,031h,031h	; 9955  &..(  ..&'.11111
	defb 031h,031h,031h,031h,031h,031h,027h,028h,026h,000h,0a9h,028h,026h,000h,000h,028h	; 9965  111111'(&..(&..(
	defb 026h,0a9h,000h,028h,020h,020h,0d3h,0d4h,020h,026h,000h,031h,031h,031h,031h,031h	; 9975  &..(  .. &.11111
	defb 031h,031h,031h,031h,031h,031h,028h,020h,020h,0d5h,0d7h,020h,020h,0d5h,0d7h,020h	; 9985  111111(  ..  .. 
	defb 020h,0d5h,0d7h,020h,020h,020h,0d2h,0d1h,026h,027h,000h,031h,031h,031h,031h,031h	; 9995   ..   ..&'.11111
	defb 031h,031h,031h,031h,0d1h,0d2h,027h,028h,020h,020h,020h,020h,020h,020h,020h,020h	; 99a5  1111..'(        
	defb 020h,020h,020h,020h,020h,020h,0d4h,0d3h,0d1h,0d2h,000h,039h,038h,039h,039h,038h	; 99b5        .....98998
	defb 039h,038h,038h,039h,0d3h,0d4h,028h,037h,037h,037h,037h,037h,037h,037h,037h,037h	; 99c5  9889..(777777777
	defb 037h,037h,037h,037h,037h,037h,0d5h,0d7h,0d3h,0d4h,038h,0dch,0dch,0dch,0dch,0dch	; 99d5  777777....8.....
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; 99e5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,07bh,07bh,07bh,07bh,07bh	; 99f5  ...........{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh	; 9a05  {{{{{{{{{{{{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07ah,07ah,07ah,07ah,07ah	; 9a15  {{{{{{{{{{{zzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah	; 9a25  zzzzzzzzzzzzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,079h,079h,079h,079h,079h	; 9a35  zzzzzzzzzzzyyyyy
	defb 079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h	; 9a45  yyyyyyyyyyyyyyyy
	defb 079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,079h,07ah,07ah,07ah,07ah,07ah	; 9a55  yyyyyyyyyyyzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah	; 9a65  zzzzzzzzzzzzzzzz
	defb 07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07ah,07bh,07bh,07bh,07bh,07bh	; 9a75  zzzzzzzzzzz{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh	; 9a85  {{{{{{{{{{{{{{{{
	defb 07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,07bh,000h,000h,000h,000h,000h	; 9a95  {{{{{{{{{{{.....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9aa5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9ab5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9ac5  ................
	defb 000h,000h,000h,000h,000h,0d1h,0d2h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9ad5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9ae5  ................
	defb 000h,000h,000h,000h,000h,0d3h,0d4h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h	; 9af5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9b05  ................
	defb 000h,000h,000h,000h,000h,0d2h,0d1h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h	; 9b15  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h	; 9b25  ................
	defb 000h,000h,000h,0a9h,000h,0d4h,0d3h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h	; 9b35  ................
	defb 000h,000h,000h,000h,000h,0d5h,0d7h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h	; 9b45  ................
	defb 000h,000h,000h,0a9h,000h,0d1h,0d2h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h	; 9b55  ................
	defb 000h,0d0h,000h,000h,000h,0d7h,0d5h,000h,000h,000h,000h,000h,000h,000h,0a9h,03bh	; 9b65  ...............;
	defb 03ch,03dh,03eh,0a9h,000h,0d3h,0d4h,000h,000h,000h,000h,0a9h,000h,0a9h,000h,000h	; 9b75  <=>.............
	defb 000h,0d5h,0d7h,000h,000h,0d5h,0d7h,000h,000h,000h,000h,000h,000h,000h,0a9h,03fh	; 9b85  ...............?
	defb 000h,000h,040h,0a9h,000h,0d2h,0d1h,000h,000h,000h,000h,0a9h,000h,0a9h,000h,000h	; 9b95  ..@.............
	defb 000h,0d7h,0d5h,000h,000h,0d7h,0d5h,000h,0d5h,0d7h,000h,000h,000h,000h,0a9h,0e2h	; 9ba5  ................
	defb 075h,076h,0e4h,000h,000h,0d4h,0d3h,000h,000h,000h,000h,039h,038h,0a9h,039h,038h	; 9bb5  uv.........98.98
	defb 038h,0d5h,0d7h,039h,038h,0d5h,0d7h,039h,0d7h,0d5h,038h,039h,038h,038h,039h,0e6h	; 9bc5  8..98..9..89889.
	defb 077h,078h,0e7h,039h,038h,0d5h,0d7h,038h,039h,038h,039h,0dch,0dch,0dch,0dch,0dch	; 9bd5  wx.98..8989.....
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; 9be5  ................
	defb 077h,078h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0bfh,0bfh,0d5h,0d6h	; 9bf5  wx..............
	defb 0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d7h	; 9c05  ................
	defb 077h,078h,0bfh,0bfh,0bfh,0bfh,0dch,0dch,0dch,0dch,0dch,0c1h,0c1h,0d5h,0d6h,000h	; 9c15  wx..............
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9c25  ................
	defb 000h,000h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0d5h,0d7h,000h	; 9c35  ................
	defb 000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9c45  ................
	defb 000h,000h,0d6h,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0c1h,0d5h,0d6h,000h,000h	; 9c55  ................
	defb 000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9c65  ................
	defb 000h,000h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0d5h,000h,000h	; 9c75  ................
	defb 000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9c85  ................
	defb 000h,000h,0d6h,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0c1h,0d5h,0d6h,000h,000h	; 9c95  ................
	defb 000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9ca5  ................
	defb 000h,000h,0d5h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0bfh,0bfh,0d5h,000h,000h	; 9cb5  ................
	defb 0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h	; 9cc5  ................
	defb 0d1h,0d2h,0d1h,0d2h,000h,000h,000h,000h,000h,000h,000h,0c1h,0d5h,0d6h,000h,000h	; 9cd5  ................
	defb 0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h	; 9ce5  ................
	defb 0d3h,0d4h,0d3h,0d4h,000h,000h,000h,000h,000h,0bbh,0bch,0bfh,0bfh,0d5h,000h,000h	; 9cf5  ................
	defb 000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9d05  ................
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,0bdh,0beh,0c1h,0d5h,0d6h,000h,000h	; 9d15  ................
	defb 000h,000h,000h,099h,000h,000h,0a9h,099h,000h,000h,000h,099h,000h,000h,000h,099h	; 9d25  ................
	defb 0a9h,000h,000h,099h,000h,000h,000h,099h,000h,026h,028h,078h,0bfh,0d5h,000h,000h	; 9d35  .........&(x....
	defb 000h,000h,000h,09ah,000h,000h,0a9h,09ah,000h,000h,000h,09ah,000h,000h,000h,09ah	; 9d45  ................
	defb 0a9h,000h,000h,09ah,000h,000h,000h,09ah,000h,028h,026h,076h,0d5h,0d6h,000h,000h	; 9d55  .........(&v....
	defb 000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9d65  ................
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,026h,028h,078h,0bfh,0d2h,000h,000h	; 9d75  .........&(x....
	defb 000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9d85  ................
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,028h,026h,076h,0d5h,0d6h,0d6h,0d7h	; 9d95  .........(&v....
	defb 0d5h,0d6h,0d7h,0d5h,0d6h,0d6h,0d7h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9da5  ................
	defb 0a9h,000h,000h,000h,000h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0bfh,0bfh,0bfh,0bfh,0bfh	; 9db5  ................
	defb 0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0d7h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9dc5  ................
	defb 0a9h,000h,000h,000h,000h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0c1h,0c1h,0c1h,0c1h,0c1h	; 9dd5  ................
	defb 0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0d5h,0d6h,0d5h,0d6h,0d6h,0d6h,0d5h,0d6h,0d6h,0d6h	; 9de5  ................
	defb 0d5h,0d6h,0d6h,0d6h,0d6h,0d6h,0d7h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0bfh,0bfh,0d5h	; 9df5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,072h,073h,000h,000h	; 9e05  ............rs..
	defb 073h,0a9h,073h,000h,000h,000h,000h,000h,072h,074h,000h,0c1h,0c1h,0c1h,0d1h,0d2h	; 9e15  s.s.....rt......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,072h,074h,000h,000h	; 9e25  ............rt..
	defb 074h,0a9h,074h,000h,000h,000h,000h,000h,072h,074h,000h,0d6h,0d6h,0d6h,0d3h,0d4h	; 9e35  t.t.....rt......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,072h,074h,000h,000h	; 9e45  ............rt..
	defb 074h,0a9h,074h,000h,000h,000h,000h,000h,072h,073h,000h,0a9h,000h,000h,000h,000h	; 9e55  t.t.....rs......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,072h,074h,000h,000h	; 9e65  ............rt..
	defb 073h,0a9h,073h,000h,000h,000h,000h,000h,072h,073h,000h,0a9h,000h,000h,000h,000h	; 9e75  s.s.....rs......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,072h,073h,000h,000h	; 9e85  ............rs..
	defb 074h,0a9h,074h,000h,000h,000h,088h,08ah,072h,074h,08ah,0a9h,000h,000h,000h,000h	; 9e95  t.t.....rt......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,072h,074h,000h,000h	; 9ea5  ............rt..
	defb 074h,0a9h,074h,000h,000h,089h,0dch,0dch,0dch,0dch,0dch,0a9h,000h,000h,0a9h,000h	; 9eb5  t.t.............
	defb 000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0a9h,000h,000h,072h,073h,000h,000h	; 9ec5  ............rs..
	defb 074h,000h,073h,000h,088h,089h,0dch,0dch,0dch,0dch,0dch,0ceh,000h,000h,0a9h,000h	; 9ed5  t.s.............
	defb 000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0a9h,000h,000h,072h,074h,000h,000h	; 9ee5  ............rt..
	defb 073h,000h,074h,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0cfh,000h,000h,0a9h,000h	; 9ef5  s.t.............
	defb 000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0a9h,000h,000h,072h,074h,000h,000h	; 9f05  ............rt..
	defb 074h,000h,073h,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,026h,000h,000h,0a9h,000h	; 9f15  t.s........&....
	defb 000h,000h,000h,000h,000h,0a9h,08ah,088h,08ah,0a9h,000h,000h,072h,074h,000h,0a9h	; 9f25  ............rt..
	defb 074h,000h,073h,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,028h,000h,000h,0a9h,000h	; 9f35  t.s........(....
	defb 000h,000h,000h,000h,089h,0dch,0dch,0dch,0dch,08bh,000h,000h,072h,074h,000h,0a9h	; 9f45  ............rt..
	defb 073h,000h,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,026h,000h,000h,0a9h,000h	; 9f55  s..........&....
	defb 000h,000h,000h,000h,089h,0dch,0dch,0dch,0dch,08bh,000h,000h,072h,073h,000h,0a9h	; 9f65  ............rs..
	defb 074h,000h,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,028h,000h,088h,0a9h,08ah	; 9f75  t..........(....
	defb 000h,088h,08ah,088h,088h,0dch,0dch,0dch,0dch,08bh,000h,000h,072h,073h,000h,0a9h	; 9f85  ............rs..
	defb 08ah,08ah,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0d2h,0d3h,0d4h,0d1h,0d2h	; 9f95  ................
	defb 0d5h,0d7h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,08bh,000h,000h,072h,074h,089h,0dch	; 9fa5  ............rt..
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0d4h,0bfh,0bfh,0d3h,0d4h	; 9fb5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,08ah,088h,088h,072h,073h,088h,0dch	; 9fc5  ............rs..
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0c1h,0c1h,0c1h,0c1h,0d5h	; 9fd5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; 9fe5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,073h,000h,073h,000h,000h	; 9ff5  ...........s.s..
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a005  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,074h,000h,073h,000h,000h	; a015  ...........t.s..
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a025  ................
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,073h,000h,074h,000h,000h	; a035  ...........s.t..
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a045  ................
	defb 0a9h,000h,000h,000h,088h,000h,08ah,088h,08ah,088h,088h,074h,000h,073h,000h,000h	; a055  ...........t.s..
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a065  ................
	defb 0a9h,000h,000h,0b7h,0b8h,0b8h,0b9h,0aeh,0afh,0afh,0afh,074h,088h,08ah,08ah,000h	; a075  ...........t....
	defb 000h,000h,000h,000h,0a9h,0adh,000h,0ach,000h,000h,088h,088h,000h,000h,088h,08ah	; a085  ................
	defb 0a9h,000h,000h,000h,000h,000h,000h,0b4h,0b5h,0b5h,0b5h,0dch,0dch,0dch,0dch,08bh	; a095  ................
	defb 000h,000h,000h,000h,000h,0b7h,0b8h,0b9h,000h,000h,0b7h,0b9h,000h,000h,0b7h,0b9h	; a0a5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0dch,0dch,0dch,0dch,08bh	; a0b5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a0c5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0dch,0dch,0dch,0dch,08bh	; a0d5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a0e5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0dch,0dch,0dch,0dch,08bh	; a0f5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a105  ................
	defb 000h,000h,0b7h,0b8h,0b9h,000h,000h,000h,000h,000h,000h,0dch,0dch,0dch,0dch,08bh	; a115  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a125  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0dch,0dch,0dch,0dch,08bh	; a135  ................
	defb 000h,088h,08ah,088h,088h,000h,000h,000h,000h,000h,088h,08ah,000h,000h,000h,000h	; a145  ................
	defb 088h,000h,08ah,088h,08ah,000h,000h,000h,000h,000h,000h,0dch,0dch,0dch,0dch,08bh	; a155  ................
	defb 000h,0aeh,0afh,0afh,0afh,0b0h,000h,000h,000h,000h,0b7h,0b9h,000h,000h,000h,000h	; a165  ................
	defb 0b7h,0b8h,0b8h,0b8h,0b9h,000h,000h,000h,000h,000h,000h,0dch,0dch,0dch,0dch,08bh	; a175  ................
	defb 000h,0b4h,0b5h,0b5h,0b5h,0b6h,000h,000h,000h,000h,0a9h,0a9h,000h,000h,000h,000h	; a185  ................
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0dch,0dch,0dch,0dch,091h	; a195  ................
	defb 091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,091h	; a1a5  ................
	defb 091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,0dch,0dch,0dch,0dch,0f6h	; a1b5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; a1c5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0dch,0dch,0dch,0dch,0f6h	; a1d5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; a1e5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,000h,000h,000h,000h,000h	; a1f5  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a205  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h	; a215  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a225  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,08ah,000h,088h,08ah,000h	; a235  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a245  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0afh,0afh,0afh,0b0h,000h	; a255  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a265  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0b5h,0b5h,0b5h,0b6h,000h	; a275  ................
	defb 000h,000h,000h,000h,0f1h,0f3h,000h,000h,000h,000h,000h,000h,088h,000h,000h,000h	; a285  ................
	defb 088h,08ah,000h,000h,000h,08ah,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a295  ................
	defb 000h,000h,08ah,088h,0f4h,0f5h,08ah,000h,000h,000h,000h,0b7h,0b9h,000h,000h,000h	; a2a5  ................
	defb 0aeh,0b0h,000h,000h,000h,0aeh,0b0h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a2b5  ................
	defb 000h,0b7h,0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,000h,000h,000h,000h,000h,000h,000h,000h	; a2c5  ................
	defb 0b4h,0b6h,000h,000h,000h,0b4h,0b6h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a2d5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0f1h,0f3h,000h,000h,000h	; a2e5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a2f5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0f4h,0f5h,000h,000h,000h	; a305  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a315  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0b7h,0b8h,0b8h,0b9h,000h,000h,000h	; a325  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; a335  ................
	defb 000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h	; a345  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0cah,088h,08ah,088h,000h,000h,000h,000h,000h	; a355  ................
	defb 000h,000h,000h,000h,088h,08ah,0a9h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h	; a365  ................
	defb 000h,000h,088h,08ah,000h,000h,089h,0dch,0dch,0dch,0dch,000h,000h,0c2h,0c3h,000h	; a375  ................
	defb 000h,000h,000h,0c2h,0c6h,0c6h,0c3h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h	; a385  ................
	defb 000h,0b7h,0b8h,0b9h,000h,000h,089h,0dch,0dch,0dch,0dch,091h,091h,0c4h,0c4h,091h	; a395  ................
	defb 091h,091h,091h,0c4h,0c4h,0c4h,0c4h,091h,091h,091h,091h,091h,091h,091h,091h,091h	; a3a5  ................
	defb 091h,091h,091h,091h,091h,091h,091h,0dch,0dch,0dch,0dch,0f6h,0f6h,0f6h,0f6h,0f6h	; a3b5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; a3c5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; a3d5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; a3e5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,000h,000h,095h,074h,000h	; a3f5  ..............t.
	defb 073h,000h,000h,000h,000h,086h,000h,074h,000h,0a9h,000h,000h,000h,000h,000h,000h	; a405  s......t........
	defb 000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,073h,000h	; a415  ..............s.
	defb 074h,000h,000h,000h,000h,087h,000h,073h,000h,0a9h,000h,000h,000h,000h,000h,000h	; a425  t......s........
	defb 000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,085h,074h,000h	; a435  ..............t.
	defb 074h,000h,000h,000h,000h,086h,000h,073h,000h,0a9h,000h,000h,000h,000h,000h,000h	; a445  t......s........
	defb 000h,000h,000h,0a9h,000h,000h,085h,000h,000h,000h,000h,000h,000h,087h,073h,000h	; a455  ..............s.
	defb 073h,000h,000h,000h,000h,087h,000h,073h,000h,0a9h,000h,000h,000h,000h,000h,000h	; a465  s......s........
	defb 000h,000h,000h,0a9h,000h,000h,086h,000h,000h,088h,08ah,000h,000h,086h,073h,000h	; a475  ..............s.
	defb 073h,000h,000h,000h,000h,086h,000h,074h,000h,0a9h,000h,000h,000h,000h,000h,000h	; a485  s......t........
	defb 000h,000h,000h,0a9h,000h,000h,087h,000h,089h,0dch,0dch,000h,000h,087h,073h,000h	; a495  ..............s.
	defb 074h,000h,000h,000h,000h,087h,000h,073h,000h,0a9h,000h,000h,088h,0d0h,08ah,08ah	; a4a5  t......s........
	defb 08ah,000h,000h,0a9h,000h,000h,086h,000h,089h,0dch,0dch,000h,000h,086h,073h,085h	; a4b5  ..............s.
	defb 073h,000h,000h,000h,000h,086h,000h,073h,000h,0a9h,000h,089h,0dch,0dch,0dch,0dch	; a4c5  s......s........
	defb 0dch,000h,000h,0a9h,000h,000h,087h,000h,089h,0dch,0dch,000h,000h,087h,073h,086h	; a4d5  ..............s.
	defb 074h,000h,000h,000h,000h,087h,000h,074h,000h,000h,000h,088h,0dch,0dch,0dch,0dch	; a4e5  t......t........
	defb 0dch,08ah,000h,085h,000h,000h,086h,085h,089h,0dch,0dch,000h,000h,086h,073h,087h	; a4f5  ..............s.
	defb 073h,000h,000h,000h,000h,086h,000h,074h,000h,000h,089h,0dch,0dch,0dch,0dch,0dch	; a505  s......t........
	defb 0dch,0dch,000h,086h,000h,000h,087h,086h,089h,0dch,0dch,000h,000h,087h,073h,086h	; a515  ..............s.
	defb 074h,000h,000h,085h,000h,087h,000h,073h,000h,000h,089h,0dch,0dch,0dch,0dch,0dch	; a525  t......s........
	defb 0dch,0dch,000h,087h,000h,000h,086h,087h,089h,0dch,0dch,08ah,08ah,088h,073h,087h	; a535  ..............s.
	defb 074h,000h,000h,087h,000h,086h,000h,074h,08ah,0d0h,000h,000h,000h,095h,000h,089h	; a545  t......t........
	defb 0dch,0dch,000h,086h,000h,000h,087h,086h,089h,0dch,0dch,0dch,0dch,0dch,08bh,086h	; a555  ................
	defb 073h,000h,000h,086h,000h,087h,089h,0dch,0dch,08bh,000h,000h,000h,000h,000h,089h	; a565  s...............
	defb 0dch,0dch,000h,087h,000h,000h,086h,087h,089h,0dch,0dch,0dch,0dch,0dch,08bh,087h	; a575  ................
	defb 074h,000h,000h,087h,000h,086h,089h,0dch,0dch,08bh,000h,000h,000h,000h,000h,089h	; a585  t...............
	defb 0dch,0dch,000h,086h,000h,000h,087h,086h,089h,0dch,0dch,0dch,0dch,0dch,088h,088h	; a595  ................
	defb 08ah,0d0h,088h,088h,08ah,08ah,089h,0dch,0dch,08bh,000h,000h,000h,000h,089h,0dch	; a5a5  ................
	defb 0dch,0dch,000h,087h,000h,000h,086h,087h,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; a5b5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,088h,08ah,08ah,088h,08ah,08ah,0dch	; a5c5  ................
	defb 0dch,0dch,08ah,088h,08ah,088h,08ah,088h,08ah,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; a5d5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; a5e5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,000h,000h,086h,087h,000h	; a5f5  ................
	defb 000h,089h,0dch,0dch,0dch,0dch,0dch,0dch,08bh,000h,000h,000h,000h,000h,000h,000h	; a605  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0d7h,0bfh,0bfh,0bfh,000h,000h,087h,086h,000h	; a615  ................
	defb 000h,089h,0dch,0dch,0dch,0dch,0dch,0dch,08bh,085h,000h,000h,000h,000h,0a9h,000h	; a625  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0d6h,0d7h,0c1h,0c1h,000h,085h,086h,087h,000h	; a635  ................
	defb 000h,089h,0dch,0dch,0dch,0dch,0dch,0dch,08bh,087h,000h,000h,000h,000h,0a9h,000h	; a645  ................
	defb 000h,000h,000h,000h,000h,0d0h,000h,0d7h,0bfh,0bfh,0bfh,08ah,08ah,08ah,08ah,000h	; a655  ................
	defb 000h,089h,0dch,0dch,0dch,0dch,0dch,0dch,08bh,086h,000h,000h,000h,000h,0a9h,08ah	; a665  ................
	defb 088h,08ah,088h,08ah,0d5h,0d7h,08ah,0d5h,0d7h,0c1h,0c1h,0dch,0dch,0dch,0dch,08bh	; a675  ................
	defb 000h,000h,000h,095h,000h,089h,0dch,0dch,08bh,087h,000h,000h,000h,000h,0d5h,0d1h	; a685  ................
	defb 0d2h,0d3h,0d4h,0d1h,0d2h,0d3h,0d4h,0d1h,0d2h,0bfh,0bfh,0dch,0dch,0dch,0dch,08bh	; a695  ................
	defb 000h,000h,000h,000h,000h,089h,0dch,0dch,08bh,086h,085h,000h,000h,000h,0d7h,0d3h	; a6a5  ................
	defb 0d4h,0d1h,0d2h,0d3h,0d4h,0d1h,0d2h,0d3h,0d4h,0c1h,0c1h,0dch,0dch,0dch,0dch,08ah	; a6b5  ................
	defb 000h,000h,000h,08ah,08ah,089h,0dch,0dch,08bh,087h,086h,000h,000h,000h,0d5h,0d7h	; a6c5  ................
	defb 000h,000h,000h,000h,085h,000h,000h,000h,0d5h,0d7h,0bfh,0dch,0dch,0dch,0dch,0dch	; a6d5  ................
	defb 08bh,000h,089h,0dch,0dch,0dch,0dch,0dch,08bh,086h,087h,000h,000h,000h,000h,000h	; a6e5  ................
	defb 000h,000h,000h,000h,087h,000h,000h,000h,0d7h,0c1h,0c1h,0dch,0dch,0dch,0dch,0dch	; a6f5  ................
	defb 08bh,000h,089h,0dch,0dch,08bh,000h,095h,000h,087h,086h,0a9h,000h,000h,000h,000h	; a705  ................
	defb 000h,000h,085h,000h,086h,0a9h,0d5h,0d6h,0d6h,0d7h,0bfh,0dch,0dch,0dch,0dch,0dch	; a715  ................
	defb 08bh,000h,000h,087h,085h,087h,000h,000h,000h,086h,0a9h,000h,000h,000h,000h,000h	; a725  ................
	defb 000h,000h,087h,000h,087h,0a9h,0d6h,0d7h,0c1h,0c1h,0c1h,0dch,0dch,0dch,0dch,0dch	; a735  ................
	defb 088h,08ah,08ah,088h,08ah,08ah,088h,08ah,08ah,08ah,088h,08ah,000h,000h,000h,000h	; a745  ................
	defb 000h,000h,086h,085h,086h,0a9h,0d7h,0bfh,0bfh,0bfh,0bfh,0dch,0dch,0dch,0dch,0dch	; a755  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,08bh,000h,000h,000h,000h	; a765  ................
	defb 000h,000h,087h,086h,087h,0a9h,0d6h,0d7h,0c1h,0c1h,0c1h,0dch,0dch,0dch,0dch,0dch	; a775  ................
	defb 0dch,0dch,0dch,08bh,000h,095h,000h,000h,089h,0dch,0dch,08bh,000h,000h,000h,000h	; a785  ................
	defb 000h,000h,086h,087h,086h,0a9h,0d7h,0bfh,0bfh,0bfh,0bfh,0dch,0dch,0dch,0dch,0dch	; a795  ................
	defb 0dch,0dch,0dch,08bh,000h,000h,000h,000h,000h,000h,000h,000h,000h,088h,088h,000h	; a7a5  ................
	defb 000h,000h,087h,088h,08ah,088h,0d6h,0d7h,0c1h,0c1h,0c1h,0dch,0dch,0dch,0dch,0dch	; a7b5  ................
	defb 0dch,0dch,0dch,08bh,000h,000h,000h,088h,08ah,08ah,088h,08ah,08ah,0dch,0dch,08bh	; a7c5  ................
	defb 000h,000h,089h,0dch,0dch,0dch,0d7h,0bfh,0bfh,0bfh,0bfh,0dch,0dch,0dch,0dch,0dch	; a7d5  ................
	defb 0dch,0dch,0dch,08bh,000h,000h,000h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,08bh	; a7e5  ................
	defb 000h,000h,089h,0dch,0dch,0d5h,0d6h,0d7h,0c1h,0c1h,0c1h,0dch,0dch,0dch,0dch,0dch	; a7f5  ................
	defb 0dch,0dch,0dch,08bh,000h,000h,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,08bh	; a805  ................
	defb 000h,000h,089h,0dch,0dch,0d5h,0d6h,0d7h,0bfh,0bfh,0bfh,0d5h,0d7h,0d5h,0d6h,0d6h	; a815  ................
	defb 0d7h,0dch,08bh,000h,000h,000h,089h,0dch,0d5h,0d6h,0d7h,0d1h,0d2h,0dch,0dch,08bh	; a825  ................
	defb 000h,000h,089h,0dch,0d6h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0bfh,0d5h,0d6h	; a835  ................
	defb 0dch,0dch,08bh,000h,000h,000h,089h,0dch,0dch,0d1h,0d2h,0d3h,0d4h,0dch,08bh,000h	; a845  ................
	defb 000h,000h,089h,0dch,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0c1h,0c1h,0c1h,0c1h,0d5h	; a855  ................
	defb 0dch,0dch,08bh,000h,000h,000h,000h,089h,0dch,0d3h,0d4h,0d4h,0dch,0dch,08bh,000h	; a865  ................
	defb 000h,000h,089h,0dch,0d6h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0bfh,0d5h,0d6h	; a875  ................
	defb 0dch,0dch,08bh,000h,000h,000h,085h,089h,0dch,0d5h,0d7h,0dch,0dch,08bh,000h,000h	; a885  ................
	defb 000h,000h,089h,0dch,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0c1h,0c1h,0c1h,0c1h,0d5h	; a895  ................
	defb 0dch,0dch,08bh,000h,000h,000h,086h,089h,0dch,0dch,0d5h,0d7h,0dch,08bh,000h,000h	; a8a5  ................
	defb 000h,000h,089h,0dch,0d6h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0bfh,0d5h,0d6h	; a8b5  ................
	defb 0dch,0dch,08bh,000h,000h,000h,087h,0d0h,0dch,0d5h,0d7h,0dch,0dch,08bh,085h,000h	; a8c5  ................
	defb 000h,000h,089h,0dch,0dch,0d6h,0d7h,0bfh,0bfh,0bfh,0bfh,0c1h,0c1h,0c1h,0c1h,0d5h	; a8d5  ................
	defb 0dch,0dch,08bh,000h,000h,000h,086h,089h,0dch,0dch,0d5h,0d7h,0dch,08bh,086h,000h	; a8e5  ................
	defb 000h,000h,089h,0dch,0dch,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0bfh,0d5h,0d6h	; a8f5  ................
	defb 0dch,0dch,08bh,000h,000h,000h,087h,089h,0dch,0d5h,0d7h,0dch,0dch,08bh,087h,000h	; a905  ................
	defb 000h,000h,089h,0dch,0dch,0d6h,0d7h,0bfh,0bfh,0bfh,0bfh,0c1h,0c1h,0c1h,0c1h,0d5h	; a915  ................
	defb 0dch,0dch,08bh,085h,000h,000h,086h,089h,0dch,0dch,0d5h,0d7h,0dch,08bh,087h,000h	; a925  ................
	defb 000h,000h,089h,0dch,0dch,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0bfh,0d5h,0d6h	; a935  ................
	defb 0dch,0dch,08bh,087h,000h,000h,087h,089h,0dch,0d5h,0d7h,0dch,0dch,08bh,086h,000h	; a945  ................
	defb 000h,000h,089h,0dch,0d6h,0d6h,0d7h,0bfh,0bfh,0bfh,0bfh,0c1h,0c1h,0c1h,0c1h,0d5h	; a955  ................
	defb 0d6h,0dch,08bh,086h,000h,000h,0cah,08ah,0dch,0dch,0d5h,0d7h,0dch,08bh,087h,085h	; a965  ................
	defb 000h,000h,089h,0dch,0d6h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0bfh,0bfh,0bfh	; a975  ................
	defb 0d5h,0dch,08bh,087h,000h,000h,089h,0dch,0dch,0d1h,0d2h,0dch,0dch,08bh,086h,087h	; a985  ................
	defb 000h,000h,089h,0dch,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0c1h,0c1h,0c1h,0c1h,0d5h	; a995  ................
	defb 0d6h,0dch,08bh,086h,085h,000h,089h,0dch,0dch,0d8h,0d9h,0d1h,0d2h,08ah,087h,086h	; a9a5  ................
	defb 000h,000h,089h,0dch,0d6h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0bfh,0bfh,0bfh,0bfh,0bfh	; a9b5  ................
	defb 0d5h,0dch,08ah,087h,087h,000h,089h,0dch,0d7h,0d3h,0d4h,0d3h,0d4h,0dch,08bh,087h	; a9c5  ................
	defb 000h,000h,089h,0dch,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0c1h,0c1h,0c1h,0c1h,0d5h	; a9d5  ................
	defb 0d6h,0dch,0dch,08bh,086h,000h,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,08bh,086h	; a9e5  ................
	defb 000h,000h,089h,0dch,0d6h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0dch,0dch,0dch,0dch,0d5h	; a9f5  ................
	defb 0d6h,0dch,0dch,08bh,087h,000h,000h,000h,000h,000h,000h,000h,000h,085h,000h,087h	; aa05  ................
	defb 000h,000h,089h,0dch,0d6h,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0dch,08bh,000h,000h,000h	; aa15  ................
	defb 089h,0dch,08bh,000h,086h,000h,000h,000h,000h,000h,000h,000h,000h,087h,000h,086h	; aa25  ................
	defb 000h,000h,089h,0dch,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0dch,08bh,000h,000h,000h	; aa35  ................
	defb 089h,0dch,08bh,000h,087h,08ah,088h,08ah,088h,08ah,08ah,08ah,088h,08ah,088h,087h	; aa45  ................
	defb 08ah,088h,08ah,0dch,0d6h,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0dch,08bh,000h,08ah,000h	; aa55  ................
	defb 089h,0dch,08bh,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; aa65  ................
	defb 0dch,0dch,0dch,0dch,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0dch,08bh,089h,0dch,08bh	; aa75  ................
	defb 089h,0dch,08bh,089h,0dch,08bh,000h,0a9h,095h,000h,000h,000h,000h,000h,0a9h,095h	; aa85  ................
	defb 000h,089h,0dch,0d6h,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0dch,08bh,089h,0dch,08bh	; aa95  ................
	defb 089h,0dch,08bh,089h,0dch,08bh,000h,0a9h,000h,000h,000h,000h,000h,000h,0a9h,000h	; aaa5  ................
	defb 000h,089h,0dch,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0dch,08bh,089h,0dch,08bh	; aab5  ................
	defb 089h,0dch,08bh,089h,0dch,08bh,000h,0a9h,000h,000h,000h,000h,000h,000h,0a9h,000h	; aac5  ................
	defb 085h,089h,0dch,0d6h,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0dch,08bh,089h,0dch,08bh	; aad5  ................
	defb 089h,0dch,08bh,089h,0dch,08bh,000h,088h,088h,08ah,088h,08ah,088h,088h,088h,000h	; aae5  ................
	defb 087h,089h,0dch,0d6h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0dch,08bh,089h,0dch,08bh	; aaf5  ................
	defb 000h,095h,000h,089h,0dch,08bh,089h,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,08bh	; ab05  ................
	defb 086h,089h,0dch,0d7h,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0dch,08bh,089h,0dch,08bh	; ab15  ................
	defb 000h,000h,000h,089h,0dch,08bh,000h,000h,000h,000h,000h,000h,000h,089h,0dch,08bh	; ab25  ................
	defb 087h,089h,0dch,0d6h,0d7h,0c1h,0c1h,0c1h,0c1h,0c1h,0c1h,0dch,08bh,089h,0dch,08bh	; ab35  ................
	defb 088h,08ah,088h,089h,0dch,08ah,08ah,088h,088h,08ah,088h,000h,000h,089h,0dch,08bh	; ab45  ................
	defb 086h,089h,0dch,0d7h,0bfh,0bfh,0d5h,0d6h,0d6h,0d6h,0d7h,0dch,08bh,089h,0dch,0dch	; ab55  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,08bh,000h,089h,0dch,08bh	; ab65  ................
	defb 087h,089h,0dch,0d5h,0d6h,0d6h,0d7h,000h,000h,0bbh,0bch,0dch,08bh,000h,000h,000h	; ab75  ................
	defb 000h,095h,085h,000h,000h,000h,000h,085h,089h,0dch,0dch,08bh,000h,089h,0dch,08bh	; ab85  ................
	defb 086h,085h,085h,000h,000h,000h,000h,000h,000h,0bdh,0beh,0dch,08bh,000h,000h,000h	; ab95  ................
	defb 000h,085h,087h,000h,085h,000h,000h,086h,085h,000h,087h,000h,000h,089h,0dch,08bh	; aba5  ................
	defb 087h,087h,086h,000h,000h,000h,000h,000h,000h,028h,026h,0dch,08bh,08ah,088h,08ah	; abb5  .........(&.....
	defb 08ah,088h,088h,088h,08ah,08ah,088h,08ah,088h,088h,088h,088h,08ah,089h,0dch,08bh	; abc5  ................
	defb 088h,08ah,08ah,08ah,088h,088h,08ah,088h,08ah,026h,028h,0dch,0dch,0dch,0dch,0dch	; abd5  .........&(.....
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; abe5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,000h,000h,000h,000h,000h	; abf5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; ac05  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; ac15  ................
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; ac25  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; ac35  ................
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h	; ac45  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,099h,000h	; ac55  ................
	defb 000h,0a9h,099h,000h,000h,000h,099h,000h,000h,000h,099h,0a9h,000h,000h,099h,000h	; ac65  ................
	defb 000h,000h,099h,000h,000h,000h,099h,000h,000h,000h,000h,000h,000h,000h,09ah,000h	; ac75  ................
	defb 000h,0a9h,09ah,000h,000h,000h,09ah,000h,000h,000h,09ah,0a9h,000h,000h,09ah,000h	; ac85  ................
	defb 000h,000h,09ah,000h,000h,000h,09ah,000h,000h,000h,000h,0cch,0ceh,000h,000h,000h	; ac95  ................
	defb 000h,0a9h,000h,000h,000h,0d0h,000h,0adh,000h,000h,000h,0a9h,000h,000h,000h,000h	; aca5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0cdh,0cfh,000h,000h,000h	; acb5  ................
	defb 000h,000h,000h,000h,000h,0aeh,0afh,0b0h,0b7h,0b9h,000h,000h,000h,000h,000h,000h	; acc5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,07fh,080h,000h,000h,000h	; acd5  ................
	defb 0a9h,000h,000h,000h,000h,0b4h,0b5h,0b6h,000h,000h,000h,000h,000h,0a9h,0a9h,000h	; ace5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,0a9h,081h,082h,000h,07fh,080h	; acf5  ................
	defb 0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,0a9h,000h	; ad05  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,0a9h,081h,082h,000h,081h,082h	; ad15  ................
	defb 0a9h,07fh,080h,000h,000h,000h,000h,000h,000h,000h,0b7h,0b9h,000h,0a9h,0a9h,000h	; ad25  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,0a9h,081h,082h,000h,081h,082h	; ad35  ................
	defb 0a9h,081h,082h,000h,07fh,080h,000h,000h,000h,000h,000h,000h,000h,0a9h,0a9h,000h	; ad45  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,0a9h,081h,082h,000h,081h,082h	; ad55  ................
	defb 0a9h,081h,082h,000h,081h,082h,000h,000h,000h,000h,000h,000h,000h,0a9h,0a9h,000h	; ad65  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,0a9h,081h,082h,000h,081h,082h	; ad75  ................
	defb 0a9h,081h,082h,000h,081h,082h,000h,000h,000h,000h,000h,000h,000h,0aeh,0afh,0afh	; ad85  ................
	defb 0b0h,09bh,000h,0aeh,0b0h,000h,09bh,0b7h,0aeh,0b0h,0aeh,081h,082h,000h,081h,082h	; ad95  ................
	defb 0a9h,081h,082h,000h,081h,082h,000h,000h,000h,000h,000h,000h,000h,0b1h,0b2h,0b2h	; ada5  ................
	defb 0b3h,0edh,09ch,0b1h,0b3h,09ch,0efh,0b7h,0b4h,0b6h,0b1h,083h,084h,000h,083h,084h	; adb5  ................
	defb 0a9h,083h,084h,000h,083h,084h,000h,000h,000h,000h,000h,000h,000h,0b4h,0b5h,0b5h	; adc5  ................
	defb 0b6h,0eeh,0efh,0b4h,0b6h,0edh,0f0h,0aeh,0afh,0b0h,0b1h,0b7h,0b8h,0b8h,0b8h,0b8h	; add5  ................
	defb 0b9h,0b7h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,0b7h,0b8h,0b8h,0b9h,0b7h	; ade5  ................
	defb 0b9h,0edh,0f0h,0aeh,0b0h,0eeh,0efh,0b4h,0b5h,0b6h,0b4h,000h,000h,000h,000h,000h	; adf5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; ae05  ................
	defb 095h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; ae15  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; ae25  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; ae35  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h	; ae45  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,08fh,08fh,090h,08fh,08fh	; ae55  ................
	defb 090h,08fh,08fh,08fh,0a9h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h	; ae65  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,07fh,080h,000h,07fh,080h	; ae75  ................
	defb 000h,07fh,080h,000h,0a9h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h	; ae85  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,081h,082h,000h,081h,082h	; ae95  ................
	defb 000h,081h,082h,000h,0a9h,099h,000h,000h,0a9h,099h,000h,000h,000h,099h,000h,000h	; aea5  ................
	defb 000h,099h,000h,000h,000h,099h,000h,000h,000h,000h,000h,081h,082h,000h,081h,082h	; aeb5  ................
	defb 000h,081h,082h,000h,0a9h,09ah,000h,000h,0a9h,09ah,000h,000h,000h,09ah,000h,000h	; aec5  ................
	defb 000h,09ah,000h,000h,000h,09ah,000h,000h,000h,000h,0bbh,081h,082h,000h,081h,082h	; aed5  ................
	defb 000h,081h,082h,000h,0a9h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h	; aee5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0bdh,081h,082h,000h,081h,082h	; aef5  ................
	defb 000h,081h,082h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; af05  ................
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,0b7h,081h,082h,000h,081h,082h	; af15  ................
	defb 000h,081h,082h,000h,000h,0aeh,0afh,0b0h,000h,000h,000h,000h,000h,000h,000h,000h	; af25  ................
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,0b9h,081h,082h,000h,081h,082h	; af35  ................
	defb 000h,081h,082h,000h,000h,0b1h,0b2h,0b3h,000h,000h,000h,000h,000h,000h,000h,000h	; af45  ................
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,0b7h,083h,084h,000h,083h,084h	; af55  ................
	defb 000h,083h,084h,000h,000h,0b4h,0b5h,0b6h,000h,000h,000h,000h,000h,000h,000h,000h	; af65  ................
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,0d0h,0b9h,0afh,0b0h,0aeh,0afh,0afh	; af75  ................
	defb 0b0h,0b7h,0b8h,0b9h,0b7h,0b9h,0aeh,0b0h,0b7h,0b8h,0b8h,0b8h,0b8h,0b8h,0a9h,000h	; af85  ................
	defb 000h,0b7h,0b8h,0b8h,0b9h,000h,000h,000h,000h,0ach,0b7h,0b2h,0b3h,0b4h,0b5h,0b5h	; af95  ................
	defb 0b6h,0aeh,0afh,0b0h,0bfh,0bfh,0b4h,0b6h,0aeh,0afh,0b0h,0b9h,09dh,09eh,000h,09fh	; afa5  ................
	defb 0a0h,0b9h,0b7h,09dh,09eh,000h,000h,000h,000h,000h,0b9h,0b2h,0b3h,0c1h,0c1h,0c1h	; afb5  ................
	defb 0c1h,0b4h,0b5h,0b6h,0c1h,0c1h,0c1h,0bah,0b1h,0b2h,0b3h,0b7h,0a1h,000h,000h,000h	; afc5  ................
	defb 0a2h,0b7h,0b9h,0a1h,000h,000h,000h,000h,000h,000h,0b7h,0b5h,0b6h,0bfh,0bfh,0bfh	; afd5  ................
	defb 0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0bfh,0b1h,0b2h,0b3h,0b9h,000h,000h,000h,000h	; afe5  ................
	defb 0abh,0b9h,0b7h,000h,000h,000h,000h,000h,000h,000h,0b9h,076h,0c1h,0b7h,000h,095h	; aff5  ...........v....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0b4h,0b5h,0b6h,0b7h,000h,000h,000h,000h	; b005  ................
	defb 000h,092h,094h,0a9h,000h,000h,000h,000h,000h,000h,0a9h,078h,0b7h,0b8h,000h,000h	; b015  ...........x....
	defb 000h,0a9h,000h,000h,000h,000h,0a9h,000h,000h,095h,000h,000h,000h,000h,000h,000h	; b025  ................
	defb 000h,094h,092h,0a9h,000h,000h,000h,000h,000h,000h,0a9h,076h,0c1h,0b7h,000h,000h	; b035  ...........v....
	defb 000h,0a9h,000h,000h,000h,000h,0a9h,000h,0a9h,000h,000h,000h,000h,0a9h,000h,000h	; b045  ................
	defb 000h,092h,094h,0a9h,000h,000h,000h,000h,000h,000h,0a9h,078h,0b7h,0b8h,0b8h,000h	; b055  ...........x....
	defb 000h,0a9h,000h,000h,000h,000h,0a9h,000h,0a9h,000h,000h,000h,000h,0a9h,000h,000h	; b065  ................
	defb 000h,094h,092h,0a9h,000h,000h,000h,000h,000h,000h,0a9h,076h,0c1h,0b7h,0b8h,000h	; b075  ...........v....
	defb 000h,0a9h,0b7h,0b8h,0b8h,0b9h,0a9h,000h,0a9h,000h,000h,000h,000h,0a9h,000h,000h	; b085  ................
	defb 000h,092h,094h,0a9h,000h,000h,000h,000h,000h,000h,0a9h,078h,0bfh,0bfh,0b7h,000h	; b095  ...........x....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,0a9h,000h,000h	; b0a5  ................
	defb 000h,094h,092h,0a9h,000h,000h,000h,000h,000h,000h,0a9h,0c1h,0c1h,0b7h,0b8h,000h	; b0b5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0a9h,0b8h,0b8h,0b8h,0b8h,0a9h,000h,000h	; b0c5  ................
	defb 000h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0bfh,0bfh,0bfh,0b7h,0b8h	; b0d5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0a9h,000h,09fh,0a0h,0b9h,0b7h,000h,000h,000h	; b0e5  ................
	defb 000h,0b9h,0b7h,09dh,09eh,09fh,0a0h,0b9h,0b7h,09dh,09eh,0c1h,0c1h,0b7h,0b8h,0b8h	; b0f5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,0a2h,0b7h,0b9h,000h,000h,000h	; b105  ................
	defb 000h,0b7h,0b9h,0a1h,000h,000h,0a2h,0b7h,0b9h,0a1h,000h,0bfh,0bfh,0bfh,0aeh,0b0h	; b115  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,0b9h,0b7h,000h,000h,000h	; b125  ................
	defb 000h,0b9h,0b7h,000h,000h,000h,000h,0b9h,0b7h,000h,000h,0b7h,0b8h,0b8h,0b4h,0b6h	; b135  ................
	defb 0b7h,0b9h,0ach,0ach,0d1h,0d2h,000h,0a9h,000h,000h,000h,0b7h,0b9h,000h,000h,000h	; b145  ................
	defb 000h,0b7h,0b9h,000h,000h,000h,000h,0b7h,0b9h,000h,000h,0bfh,0b7h,000h,000h,000h	; b155  ................
	defb 000h,000h,000h,000h,0d3h,0d4h,000h,000h,000h,000h,000h,0b9h,0b7h,000h,000h,000h	; b165  ................
	defb 000h,0b9h,0b7h,000h,000h,000h,000h,0b9h,0b7h,000h,000h,0b7h,0b8h,000h,000h,000h	; b175  ................
	defb 000h,000h,000h,000h,0d2h,0d1h,091h,091h,091h,091h,091h,0b7h,0b9h,091h,091h,091h	; b185  ................
	defb 091h,0b7h,0b9h,091h,091h,091h,091h,0b7h,0b9h,091h,091h,0bfh,0b7h,000h,000h,000h	; b195  ................
	defb 000h,000h,000h,0d5h,0d4h,0d3h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; b1a5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0b7h,0b8h,0cah,000h,000h	; b1b5  ................
	defb 000h,000h,000h,0d5h,0d1h,0d2h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; b1c5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0bfh,0b7h,0b8h,0b8h,0b8h	; b1d5  ................
	defb 0b8h,0b9h,0b8h,0b9h,0d3h,0d4h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; b1e5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,000h,000h,000h,000h,000h	; b1f5  ................
	defb 000h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h,0a9h,081h,082h	; b205  ................
	defb 000h,081h,082h,0a9h,081h,082h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; b215  ................
	defb 000h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h,0a9h,081h,082h	; b225  ................
	defb 000h,081h,082h,0a9h,081h,082h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; b235  ................
	defb 0a9h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h,0a9h,081h,082h	; b245  ................
	defb 000h,081h,082h,0a9h,081h,082h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; b255  ................
	defb 0a9h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h,0a9h,081h,082h	; b265  ................
	defb 000h,081h,082h,0a9h,081h,082h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; b275  ................
	defb 0a9h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h,0a9h,0aeh,0afh	; b285  ................
	defb 0afh,0afh,0b0h,0a9h,081h,082h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; b295  ................
	defb 0a9h,000h,083h,084h,000h,083h,084h,000h,083h,084h,000h,083h,084h,0a9h,0b4h,0b5h	; b2a5  ................
	defb 0b5h,0b5h,0b6h,0a9h,083h,084h,000h,000h,000h,000h,000h,0b8h,0b8h,0b8h,0b9h,000h	; b2b5  ................
	defb 0a9h,0b7h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,0b7h,0b8h,0b8h	; b2c5  ................
	defb 0b8h,0b8h,0b8h,0b9h,0b8h,0b8h,0b8h,0b9h,000h,000h,0aeh,09fh,0a0h,0b9h,0b7h,000h	; b2d5  ................
	defb 000h,000h,07fh,080h,000h,07fh,080h,0b7h,0b8h,0b8h,0b8h,0b8h,0b9h,0b7h,0b8h,0b8h	; b2e5  ................
	defb 0b8h,0b8h,0b8h,0b9h,0b8h,0b8h,0b8h,0b9h,0b8h,0b8h,0b1h,000h,0a2h,0b7h,0b9h,000h	; b2f5  ................
	defb 000h,000h,081h,082h,000h,081h,082h,08fh,08fh,08fh,090h,08fh,08fh,090h,08fh,08fh	; b305  ................
	defb 090h,08fh,08fh,090h,08fh,08fh,08fh,0b7h,000h,000h,0b1h,000h,000h,0b9h,0b7h,000h	; b315  ................
	defb 000h,000h,081h,082h,000h,081h,082h,0a9h,07fh,080h,000h,07fh,080h,000h,07fh,080h	; b325  ................
	defb 000h,07fh,080h,000h,07fh,080h,000h,0b7h,000h,000h,0b4h,000h,000h,0b7h,0b9h,000h	; b335  ................
	defb 000h,000h,081h,082h,000h,081h,082h,0a9h,081h,082h,000h,081h,082h,0abh,081h,082h	; b345  ................
	defb 000h,081h,082h,000h,081h,082h,000h,0b7h,0b8h,0b8h,0aeh,000h,000h,0b9h,0b7h,000h	; b355  ................
	defb 000h,000h,081h,082h,000h,081h,082h,0a9h,081h,082h,000h,081h,082h,000h,081h,082h	; b365  ................
	defb 000h,081h,082h,000h,081h,082h,000h,0a9h,000h,000h,0b4h,091h,091h,0b7h,0b9h,000h	; b375  ................
	defb 000h,000h,081h,082h,000h,081h,082h,0a9h,081h,082h,000h,081h,082h,000h,081h,082h	; b385  ................
	defb 000h,081h,082h,000h,081h,082h,000h,0a9h,000h,000h,0b7h,0f6h,0f6h,0b9h,0b7h,000h	; b395  ................
	defb 000h,000h,081h,082h,000h,083h,084h,0a9h,083h,084h,000h,083h,084h,000h,083h,084h	; b3a5  ................
	defb 000h,083h,084h,000h,083h,084h,000h,0a9h,000h,0aeh,0afh,0f6h,0f6h,0b7h,0b9h,000h	; b3b5  ................
	defb 000h,000h,083h,084h,000h,0d0h,0aeh,0afh,0afh,0afh,0b0h,0aeh,0afh,0afh,0afh,0afh	; b3c5  ................
	defb 0afh,0afh,0afh,0afh,0b0h,0aeh,0b0h,0aeh,0b0h,0b4h,0b5h,0f6h,0f6h,0b9h,0b7h,0b8h	; b3d5  ................
	defb 0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,0b4h,0b5h,0b5h,0b5h,0b6h,0b1h,0b2h,0b2h,0b2h,0b2h	; b3e5  ................
	defb 0b2h,0b2h,0b2h,0b2h,0b3h,0b1h,0b3h,0b4h,0b6h,0aeh,0afh,081h,082h,000h,081h,082h	; b3f5  ................
	defb 000h,000h,000h,000h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h	; b405  ................
	defb 000h,081h,082h,000h,000h,000h,000h,000h,000h,000h,000h,081h,082h,000h,081h,082h	; b415  ................
	defb 000h,000h,000h,000h,000h,083h,084h,000h,083h,084h,000h,083h,084h,000h,083h,084h	; b425  ................
	defb 000h,083h,084h,000h,000h,000h,000h,000h,000h,000h,000h,081h,082h,000h,081h,082h	; b435  ................
	defb 000h,000h,000h,0b7h,0b8h,0b8h,0b9h,0b8h,0b8h,0b8h,0b9h,0b8h,0b8h,0b9h,0b8h,0b8h	; b445  ................
	defb 0b8h,0b8h,0b8h,0b8h,0b9h,000h,000h,000h,000h,000h,000h,081h,082h,000h,081h,082h	; b455  ................
	defb 000h,000h,000h,0b7h,000h,07fh,080h,000h,07fh,080h,000h,07fh,080h,000h,07fh,080h	; b465  ................
	defb 000h,07fh,080h,000h,0a9h,000h,000h,000h,000h,000h,000h,081h,082h,000h,081h,082h	; b475  ................
	defb 000h,000h,000h,0b9h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h	; b485  ................
	defb 000h,081h,082h,000h,0a9h,000h,000h,000h,000h,000h,000h,083h,084h,000h,083h,084h	; b495  ................
	defb 000h,000h,000h,0b7h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h	; b4a5  ................
	defb 000h,081h,082h,000h,0a9h,000h,000h,000h,000h,000h,000h,0afh,0b0h,0b7h,0b8h,0b8h	; b4b5  ................
	defb 0b9h,000h,000h,0b9h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h	; b4c5  ................
	defb 000h,081h,082h,000h,0a9h,000h,000h,000h,000h,0aeh,0b0h,0b2h,0b3h,09dh,09eh,000h	; b4d5  ................
	defb 000h,000h,000h,0b7h,000h,081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h	; b4e5  ................
	defb 000h,081h,082h,000h,0a9h,000h,000h,000h,000h,0b1h,0b3h,0b2h,0b3h,0a1h,01eh,000h	; b4f5  ................
	defb 000h,000h,000h,0b9h,0d0h,083h,084h,000h,083h,084h,000h,083h,084h,000h,083h,084h	; b505  ................
	defb 000h,083h,084h,000h,0a9h,000h,000h,000h,0b7h,0b4h,0b6h,0b5h,0b6h,000h,03ah,000h	; b515  ..............:.
	defb 000h,000h,000h,0b7h,0b8h,0b8h,0b8h,0b8h,0b9h,017h,018h,019h,0aeh,0b0h,017h,018h	; b525  ................
	defb 018h,018h,018h,019h,000h,000h,000h,000h,0aeh,0afh,0b0h,0b0h,0a9h,000h,03ah,000h	; b535  ..............:.
	defb 01eh,000h,000h,0aeh,0b0h,07fh,080h,000h,07fh,080h,000h,000h,0b4h,0b6h,000h,000h	; b545  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0b4h,0b5h,0b6h,0b6h,0a9h,000h,03ah,000h	; b555  ..............:.
	defb 03ah,000h,000h,0b4h,0b6h,081h,082h,000h,081h,082h,000h,000h,0b7h,0b9h,09ch,000h	; b565  :...............
	defb 000h,000h,000h,000h,000h,000h,000h,0aeh,0b0h,0aeh,0b0h,0b9h,0a9h,000h,000h,000h	; b575  ................
	defb 03ah,000h,000h,0a9h,000h,081h,082h,000h,081h,082h,0bbh,0bch,0b8h,0b9h,0edh,000h	; b585  :...............
	defb 0aeh,0b0h,000h,09ch,000h,000h,000h,0b4h,0b6h,0b1h,0b3h,0b0h,0a9h,000h,000h,000h	; b595  ................
	defb 000h,000h,000h,0a9h,000h,081h,082h,000h,081h,082h,0bdh,0beh,0aeh,0b0h,0eeh,09bh	; b5a5  ................
	defb 0b4h,0b6h,09bh,0eeh,000h,000h,0aeh,0afh,0b0h,0b1h,0b3h,0b6h,0a9h,000h,000h,000h	; b5b5  ................
	defb 000h,000h,000h,0a9h,000h,083h,084h,000h,083h,084h,0b7h,0b9h,0b4h,0b6h,0edh,0efh	; b5c5  ................
	defb 0b7h,0b9h,0f0h,0efh,000h,000h,0b4h,0b5h,0b6h,0b4h,0b6h,0afh,0afh,0b0h,0b7h,0b8h	; b5d5  ................
	defb 0b8h,0b9h,0aeh,0afh,0afh,0afh,0b0h,0b7h,0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,0eeh,0f0h	; b5e5  ................
	defb 0aeh,0b0h,0efh,0efh,0b7h,0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,000h,000h,000h,000h,000h	; b5f5  ................
	defb 000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h	; b605  ................
	defb 000h,000h,000h,000h,000h,081h,082h,081h,082h,000h,0b7h,000h,000h,000h,000h,000h	; b615  ................
	defb 000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h	; b625  ................
	defb 000h,000h,000h,000h,000h,081h,082h,081h,082h,000h,0b9h,000h,000h,0abh,000h,000h	; b635  ................
	defb 000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h	; b645  ................
	defb 000h,000h,000h,000h,000h,081h,082h,081h,082h,000h,0b7h,000h,0b7h,0b9h,000h,000h	; b655  ................
	defb 099h,000h,000h,000h,099h,000h,0bah,000h,099h,0bbh,0bch,000h,099h,000h,000h,000h	; b665  ................
	defb 099h,000h,000h,000h,000h,081h,082h,081h,082h,000h,0b9h,000h,000h,095h,000h,000h	; b675  ................
	defb 09ah,000h,000h,000h,09ah,000h,0bah,000h,09ah,0bdh,0beh,000h,09ah,000h,000h,000h	; b685  ................
	defb 09ah,000h,000h,000h,000h,083h,084h,083h,084h,000h,0b7h,000h,000h,000h,000h,000h	; b695  ................
	defb 000h,000h,000h,000h,000h,000h,0bah,000h,000h,0b7h,0b9h,000h,000h,000h,000h,000h	; b6a5  ................
	defb 000h,000h,000h,000h,08fh,08fh,08fh,08fh,08fh,08fh,0b9h,000h,000h,000h,000h,01eh	; b6b5  ................
	defb 000h,000h,000h,000h,000h,0aeh,0b0h,000h,000h,0b9h,0b7h,000h,000h,000h,000h,0b9h	; b6c5  ................
	defb 0b7h,000h,000h,000h,07fh,080h,07fh,080h,07fh,080h,0b7h,000h,000h,000h,000h,03ah	; b6d5  ...............:
	defb 01eh,000h,000h,000h,000h,0b1h,0b3h,000h,000h,07fh,080h,000h,000h,000h,000h,0b7h	; b6e5  ................
	defb 0b9h,000h,000h,000h,081h,082h,081h,082h,081h,082h,0b9h,0aeh,0afh,0b0h,000h,03ah	; b6f5  ...............:
	defb 03ah,01eh,000h,000h,000h,0b4h,0b6h,000h,000h,081h,082h,000h,000h,000h,000h,0b9h	; b705  :...............
	defb 0b7h,000h,000h,000h,081h,082h,081h,082h,081h,082h,0b7h,0b4h,0b5h,0b6h,000h,03ah	; b715  ...............:
	defb 03ah,03ah,000h,000h,0cch,0aeh,0b0h,000h,000h,081h,082h,000h,000h,000h,0aeh,0afh	; b725  ::..............
	defb 0b0h,000h,000h,000h,081h,082h,081h,082h,081h,082h,0b9h,0aeh,0b0h,0d0h,000h,000h	; b735  ................
	defb 03ah,03ah,000h,000h,0cdh,0b4h,0b6h,000h,000h,081h,082h,000h,000h,000h,0b4h,0b5h	; b745  ::..............
	defb 0b6h,000h,000h,000h,081h,082h,081h,082h,081h,082h,0b7h,0b1h,0b3h,000h,000h,000h	; b755  ................
	defb 03ah,000h,000h,000h,0b7h,0b8h,0b9h,000h,000h,081h,082h,000h,000h,000h,0aeh,0b0h	; b765  :...............
	defb 0aeh,0b0h,000h,000h,081h,082h,081h,082h,081h,082h,0b9h,0b1h,0b3h,000h,000h,000h	; b775  ................
	defb 000h,000h,000h,0aeh,0afh,0b0h,095h,000h,000h,081h,082h,000h,000h,0bah,0b4h,0b6h	; b785  ................
	defb 0b4h,0b6h,000h,000h,081h,082h,081h,082h,081h,082h,0b7h,0b1h,0b3h,000h,000h,000h	; b795  ................
	defb 000h,000h,000h,0b1h,0b2h,0b3h,000h,000h,000h,081h,082h,000h,000h,0aeh,0afh,0afh	; b7a5  ................
	defb 0b0h,000h,000h,000h,081h,082h,081h,082h,081h,082h,0b9h,0b4h,0b6h,000h,000h,000h	; b7b5  ................
	defb 000h,000h,000h,0b4h,0b5h,0b6h,000h,000h,000h,083h,084h,000h,000h,0b4h,0b5h,0b5h	; b7c5  ................
	defb 0b6h,000h,000h,000h,083h,084h,083h,084h,083h,084h,0b7h,0b7h,0b7h,0b9h,0b7h,0b8h	; b7d5  ................
	defb 0b8h,0b9h,0b8h,0b8h,0b8h,0b8h,0b9h,0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,0b7h,0b9h,0b8h	; b7e5  ................
	defb 0b9h,000h,000h,0b7h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,095h,000h,000h,000h,000h	; b7f5  ................
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,0aeh	; b805  ................
	defb 0b0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0b9h,000h,099h,000h,000h,099h	; b815  ................
	defb 000h,0a9h,099h,000h,000h,099h,000h,000h,099h,000h,000h,099h,0a9h,000h,000h,0b4h	; b825  ................
	defb 0b6h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0b7h,000h,09ah,000h,000h,09ah	; b835  ................
	defb 000h,0a9h,09ah,000h,000h,09ah,000h,000h,09ah,000h,000h,09ah,0a9h,000h,000h,0b7h	; b845  ................
	defb 0b9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0b9h,000h,000h,000h,000h,000h	; b855  ................
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,0b7h	; b865  ................
	defb 0b8h,0b9h,0b8h,0b8h,0b9h,0b8h,0b9h,000h,000h,000h,0b7h,000h,000h,000h,000h,000h	; b875  ................
	defb 000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h	; b885  ................
	defb 000h,000h,000h,000h,095h,000h,000h,000h,000h,000h,0b9h,000h,000h,000h,000h,000h	; b895  ................
	defb 000h,0a9h,0b7h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,000h,000h,000h,0a9h	; b8a5  ................
	defb 000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,0b7h,000h,000h,000h,000h,000h	; b8b5  ................
	defb 000h,000h,000h,000h,000h,000h,095h,000h,000h,000h,000h,0b7h,000h,000h,000h,0a9h	; b8c5  ................
	defb 000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,0b9h,000h,000h,000h,0a9h,000h	; b8d5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,0aeh,0b0h,000h,0a9h	; b8e5  ................
	defb 000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,0b7h,0a9h,000h,0cch,0bch,000h	; b8f5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,0b4h,0b6h,0f2h,0f3h	; b905  ................
	defb 000h,000h,000h,000h,000h,0a9h,0f3h,000h,000h,000h,0b9h,0a9h,000h,0bdh,0beh,000h	; b915  ................
	defb 000h,0cch,0bch,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,0a9h,0b7h,0b8h	; b925  ................
	defb 0b8h,0b9h,0b8h,0b8h,0b9h,0b8h,0f5h,0b7h,0b9h,0b8h,0b9h,0a9h,000h,07fh,080h,000h	; b935  ................
	defb 000h,0bdh,0beh,000h,000h,0cch,0bch,000h,000h,000h,000h,000h,000h,0a9h,000h,000h	; b945  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0cch,0a9h,000h,081h,082h,000h	; b955  ................
	defb 000h,07fh,080h,000h,000h,0bdh,0beh,000h,000h,0cch,0bch,000h,000h,0a9h,099h,000h	; b965  ................
	defb 000h,099h,000h,000h,099h,000h,000h,099h,000h,000h,0cdh,0a9h,000h,081h,082h,000h	; b975  ................
	defb 000h,081h,082h,000h,000h,07fh,080h,000h,000h,0bdh,0beh,000h,000h,0a9h,09ah,000h	; b985  ................
	defb 000h,09ah,000h,000h,09ah,000h,000h,09ah,000h,000h,07fh,0a9h,000h,081h,082h,000h	; b995  ................
	defb 000h,081h,082h,000h,000h,081h,082h,000h,000h,07fh,080h,000h,000h,0a9h,000h,000h	; b9a5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,081h,091h,091h,081h,082h,091h	; b9b5  ................
	defb 091h,081h,082h,091h,091h,081h,082h,091h,091h,081h,082h,09ch,000h,0a9h,000h,000h	; b9c5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,083h,0f6h,0f6h,0f6h,0f6h,0f6h	; b9d5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0aeh,0b0h,0efh,09ch,0b7h,0b8h,0b9h	; b9e5  ................
	defb 0b8h,0b8h,0b8h,0b8h,0b9h,0b8h,0b8h,0b8h,0b8h,0b8h,0b9h,0f6h,0f6h,0f6h,0f6h,0f6h	; b9f5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; ba05  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; ba15  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; ba25  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; ba35  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; ba45  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0cbh,0f6h,0f6h,0f6h,0f6h,0dch,0dch,0dch,0dch,0dch	; ba55  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; ba65  ................
	defb 0dch,0cbh,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0f6h,0f6h,0f6h,0f6h,0f6h	; ba75  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; ba85  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0cbh,0f6h,0f6h,0f6h,0dch,0dch,0dch,0dch,0dch	; ba95  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; baa5  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,000h,000h,000h,085h,000h	; bab5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0d1h,0d2h,000h,000h,000h,000h,000h,000h	; bac5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,087h,000h	; bad5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0d5h,0d3h,0d4h,000h,085h,000h,000h,000h,000h	; bae5  ................
	defb 000h,000h,000h,000h,085h,000h,000h,000h,085h,000h,0a9h,000h,000h,000h,086h,000h	; baf5  ................
	defb 085h,000h,000h,000h,000h,000h,000h,0d1h,0d2h,0d7h,0d0h,087h,000h,000h,000h,000h	; bb05  ................
	defb 000h,000h,000h,000h,086h,000h,000h,000h,086h,000h,0a9h,000h,000h,000h,087h,000h	; bb15  ................
	defb 087h,000h,088h,08ah,088h,08ah,0d0h,0d3h,0d4h,0d5h,0d7h,086h,000h,000h,000h,000h	; bb25  ................
	defb 000h,000h,000h,000h,087h,000h,085h,000h,087h,000h,0a9h,000h,000h,000h,086h,000h	; bb35  ................
	defb 086h,000h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,000h,085h,000h,0a9h	; bb45  ................
	defb 000h,000h,000h,085h,086h,000h,087h,000h,086h,000h,0a9h,000h,000h,000h,087h,000h	; bb55  ................
	defb 087h,000h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,000h,087h,000h,0a9h	; bb65  ................
	defb 000h,000h,000h,087h,087h,000h,086h,000h,087h,000h,0a9h,000h,000h,085h,086h,000h	; bb75  ................
	defb 086h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,086h,000h,086h,000h,0a9h	; bb85  ................
	defb 000h,088h,088h,088h,088h,08ah,088h,08ah,088h,08ah,0a9h,000h,000h,087h,087h,000h	; bb95  ................
	defb 087h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,087h,000h,087h,000h,0a9h	; bba5  ................
	defb 0c7h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,08ah,088h,088h,088h,088h	; bbb5  ................
	defb 0ach,0a9h,088h,088h,088h,088h,088h,088h,08ah,088h,088h,088h,088h,088h,088h,0c7h	; bbc5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; bbd5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; bbe5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0f6h,0f6h,0f6h,0f6h,0f6h	; bbf5  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; bc05  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; bc15  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; bc25  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0cbh,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; bc35  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; bc45  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0cbh,0f6h,0f6h,0f6h,000h,000h,000h,000h,000h	; bc55  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; bc65  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0c7h,0f6h,0f6h,0f6h,0f6h,0f6h	; bc75  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h	; bc85  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0c8h,0dch,0dch,0dch,0dch,0dch	; bc95  ................
	defb 0dch,0dch,0dch,0dch,0dch,088h,08ah,088h,08ah,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; bca5  ................
	defb 0dch,0d7h,0d5h,0dch,0dch,0dch,0cbh,0dch,0dch,0dch,0c8h,000h,000h,000h,000h,000h	; bcb5  ................
	defb 000h,000h,000h,000h,000h,0d1h,0d2h,0d7h,0d5h,000h,000h,000h,000h,000h,000h,085h	; bcc5  ................
	defb 000h,0d5h,0d7h,000h,000h,000h,0dch,0cbh,000h,000h,0c8h,000h,000h,000h,000h,000h	; bcd5  ................
	defb 000h,000h,085h,000h,088h,0d8h,0d9h,0d5h,0d7h,08ah,000h,000h,000h,000h,000h,086h	; bce5  ................
	defb 000h,0d7h,0d5h,000h,000h,000h,0cbh,0dch,000h,000h,0c8h,000h,000h,000h,000h,000h	; bcf5  ................
	defb 000h,000h,086h,000h,0d7h,0d8h,0d9h,0d7h,0d5h,0d7h,000h,000h,000h,000h,085h,087h	; bd05  ................
	defb 000h,0d5h,0d7h,000h,000h,000h,000h,000h,085h,085h,0c8h,000h,000h,000h,000h,000h	; bd15  ................
	defb 000h,000h,087h,000h,0d5h,0d6h,0d7h,0d1h,0d2h,000h,000h,000h,000h,000h,087h,086h	; bd25  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,086h,0c7h,0c8h,000h,000h,000h,000h,000h	; bd35  ................
	defb 000h,085h,086h,000h,0cbh,0d1h,0d2h,0d3h,0d4h,000h,000h,000h,000h,000h,086h,087h	; bd45  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,087h,0c8h,0c8h,000h,000h,08ah,08ah,000h	; bd55  ................
	defb 000h,087h,087h,000h,086h,0d3h,0d4h,000h,087h,085h,000h,000h,088h,088h,08ah,086h	; bd65  ................
	defb 000h,000h,000h,088h,08ah,000h,000h,000h,086h,0c8h,0c8h,08ah,08ah,08ah,08ah,000h	; bd75  ................
	defb 000h,086h,086h,000h,087h,000h,000h,000h,086h,085h,000h,000h,0c7h,0c8h,0c9h,08ah	; bd85  ................
	defb 08ah,000h,000h,08ah,088h,000h,000h,000h,0c7h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c9h	; bd95  ................
	defb 000h,087h,087h,000h,086h,000h,000h,000h,087h,087h,000h,000h,0c8h,0c8h,0c8h,088h	; bda5  ................
	defb 08ah,000h,0adh,0c7h,0c9h,000h,000h,0ach,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; bdb5  ................
	defb 0c9h,088h,088h,088h,088h,088h,08ah,088h,088h,08ah,088h,0c7h,0c8h,0c8h,0c8h,0c8h	; bdc5  ................
	defb 0c8h,0c9h,08ah,0c8h,0c8h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; bdd5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; bde5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; bdf5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,000h	; be05  ................
	defb 0a9h,000h,000h,000h,000h,000h,0a9h,000h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; be15  ................
	defb 000h,000h,085h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,085h,000h,000h	; be25  ................
	defb 0a9h,000h,000h,000h,000h,000h,0a9h,000h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; be35  ................
	defb 000h,000h,086h,000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,087h,000h,000h	; be45  ................
	defb 0a9h,000h,085h,000h,000h,000h,0a9h,000h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; be55  ................
	defb 000h,000h,087h,000h,000h,000h,000h,0a9h,088h,088h,088h,088h,088h,08ah,088h,088h	; be65  ................
	defb 0a9h,088h,088h,08ah,088h,08ah,0a9h,000h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; be75  ................
	defb 000h,085h,086h,000h,000h,000h,000h,000h,0d1h,0d2h,0d5h,0d6h,0d6h,0d7h,0d6h,0d6h	; be85  ................
	defb 0d6h,0d6h,0d7h,0d6h,0d6h,0d7h,000h,0cch,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; be95  ................
	defb 000h,086h,087h,000h,000h,000h,000h,000h,0d3h,0d4h,000h,085h,000h,087h,000h,000h	; bea5  ................
	defb 000h,000h,087h,000h,000h,000h,000h,0cdh,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; beb5  ................
	defb 000h,087h,086h,000h,000h,000h,000h,000h,000h,000h,000h,087h,000h,086h,085h,000h	; bec5  ................
	defb 000h,000h,086h,000h,085h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c8h,0c9h,088h,08ah	; bed5  ................
	defb 088h,08ah,088h,088h,08ah,000h,000h,000h,000h,000h,000h,086h,000h,087h,087h,000h	; bee5  ................
	defb 000h,000h,087h,000h,087h,000h,000h,000h,0d7h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; bef5  ................
	defb 0c8h,0c8h,0c8h,0d5h,0d1h,0d2h,088h,088h,088h,08ah,088h,088h,088h,08ah,088h,088h	; bf05  ................
	defb 000h,000h,086h,000h,086h,085h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; bf15  ................
	defb 0c8h,0c8h,0d5h,0d7h,0d8h,0d9h,0d1h,0d2h,08ah,0d4h,0d1h,0d2h,0d3h,0d4h,0d1h,0d2h	; bf25  ................
	defb 0d7h,0d1h,0d2h,0d3h,0d4h,087h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; bf35  ................
	defb 000h,000h,000h,000h,0d3h,0d4h,0d3h,0d4h,0d1h,0d2h,0d3h,0d4h,0d1h,0d2h,0d3h,0d4h	; bf45  ................
	defb 0d7h,0d3h,0d4h,0d1h,0d2h,086h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; bf55  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,087h,000h,086h,086h,0a9h	; bf65  ................
	defb 000h,000h,087h,000h,0a9h,087h,000h,000h,088h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; bf75  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,086h,000h,087h,087h,0a9h	; bf85  ................
	defb 000h,000h,086h,000h,0a9h,0a9h,088h,08ah,0c7h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; bf95  ................
	defb 000h,000h,000h,000h,000h,08ah,08ah,08ah,08ah,08ah,08ah,08ah,08ah,088h,08ah,0a9h	; bfa5  ................
	defb 088h,08ah,08ah,088h,0c7h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; bfb5  ................
	defb 000h,000h,000h,000h,0c7h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; bfc5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; bfd5  ................
	defb 000h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; bfe5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h	; bff5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c005  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,0c8h,0c8h,000h,000h,000h	; c015  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c025  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,0c8h,0c8h,000h,000h,088h	; c035  ................
	defb 08ah,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c045  ................
	defb 000h,000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,0c8h,0c8h,0c9h,000h,02bh	; c055  ...............+
	defb 02ch,000h,088h,08ah,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c065  ,...............
	defb 000h,088h,08ah,000h,0a9h,088h,088h,08ah,088h,088h,08ah,0c8h,0c8h,0c8h,0c9h,000h	; c075  ................
	defb 000h,000h,02bh,02ch,000h,088h,08ah,000h,000h,000h,000h,000h,000h,000h,088h,08ah	; c085  ..+,............
	defb 000h,02bh,02ch,000h,000h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0c8h,0c8h,0c8h,0c8h,000h	; c095  .+,.............
	defb 000h,000h,000h,000h,000h,02bh,02ch,000h,088h,08ah,000h,088h,08ah,000h,02bh,02ch	; c0a5  .....+,.......+,
	defb 000h,000h,000h,000h,000h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0c8h,0c8h,0c8h,0c8h,000h	; c0b5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,02bh,02ch,000h,02bh,02ch,000h,000h,000h	; c0c5  ........+,.+,...
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c9h	; c0d5  ................
	defb 08ah,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,088h,088h,08ah,000h	; c0e5  ................
	defb 000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c8h	; c0f5  ................
	defb 0c8h,0c9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0c7h,0c8h,0c8h,0c9h	; c105  ................
	defb 000h,000h,000h,0a9h,000h,000h,000h,000h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c8h	; c115  ................
	defb 0c8h,0c8h,0c9h,08ah,08ah,000h,000h,000h,000h,000h,000h,0c7h,0c8h,0c8h,0c8h,0c8h	; c125  ................
	defb 0c8h,0c9h,000h,0a9h,088h,088h,088h,08ah,088h,08ah,088h,0c8h,0c8h,0c8h,0c8h,0c8h	; c135  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c9h,000h,000h,000h,000h,000h,0d6h,0d7h,0c8h,0c8h,0c8h	; c145  ................
	defb 0c8h,0c8h,0c9h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0d1h,0d2h,0c8h,0c8h,0c8h,0c8h,0c8h	; c155  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h,000h,000h,000h,0d6h,0d7h,0c8h,0c8h	; c165  ................
	defb 0c8h,0c8h,0d5h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0d3h,0d4h,0c8h,0c8h,0c8h,0c8h,0c8h	; c175  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c9h,000h,000h,08ah,000h,000h,0d7h,0d6h,0d6h,0d7h	; c185  ................
	defb 0d6h,0d7h,0d5h,000h,000h,000h,000h,000h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c8h	; c195  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c9h,0c7h,0c8h,000h,000h,000h,000h,000h,0a9h	; c1a5  ................
	defb 000h,000h,000h,000h,0ach,000h,000h,000h,000h,000h,000h,0c8h,0c8h,0c8h,0c8h,0c8h	; c1b5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0d7h,088h,088h,08ah,088h,088h,0a9h	; c1c5  ................
	defb 088h,08ah,088h,088h,08ah,08ah,088h,088h,088h,088h,088h,0c8h,0c8h,0c8h,0c8h,0c8h	; c1d5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c1e5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h,0f4h,0aeh	; c1f5  ................
	defb 0b0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h	; c205  ................
	defb 000h,000h,000h,000h,000h,081h,082h,000h,000h,000h,000h,000h,000h,000h,0f4h,0b1h	; c215  ................
	defb 0b3h,000h,000h,000h,000h,000h,000h,0dch,0cbh,000h,000h,000h,000h,000h,000h,0a9h	; c225  ................
	defb 000h,000h,000h,000h,000h,081h,082h,000h,082h,081h,000h,000h,000h,000h,0f4h,0b1h	; c235  ................
	defb 0b3h,000h,000h,000h,000h,000h,0cbh,0dch,0dch,000h,000h,000h,000h,000h,000h,0a9h	; c245  ................
	defb 000h,085h,000h,000h,000h,081h,082h,000h,082h,081h,082h,000h,000h,000h,0f4h,0b4h	; c255  ................
	defb 0b6h,000h,000h,000h,000h,000h,0dch,0dch,000h,000h,000h,000h,000h,000h,000h,0a9h	; c265  ................
	defb 000h,087h,000h,000h,085h,081h,082h,081h,082h,081h,082h,0aeh,0afh,0afh,0afh,0b0h	; c275  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0cbh,0dch,000h,000h,000h,000h,000h,0a9h	; c285  ................
	defb 000h,086h,000h,085h,086h,083h,084h,083h,084h,083h,084h,0b4h,0b5h,0b5h,0b5h,0b6h	; c295  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,0dch,0cbh,000h,000h,000h,000h,000h,0aeh	; c2a5  ................
	defb 0afh,0b0h,0b7h,0b9h,0aeh,0b0h,0aeh,0afh,0afh,0afh,0b0h,000h,000h,0f1h,0f3h,0f1h	; c2b5  ................
	defb 0f3h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0b4h	; c2c5  ................
	defb 0b5h,0b6h,000h,000h,0b4h,0b6h,0b4h,0b5h,0b5h,0b5h,0b6h,000h,000h,0f4h,0aeh,0b0h	; c2d5  ................
	defb 0f5h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0a9h	; c2e5  ................
	defb 000h,087h,000h,085h,000h,086h,085h,000h,000h,000h,000h,000h,000h,0f4h,0b1h,0b3h	; c2f5  ................
	defb 0f5h,081h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,085h,000h,000h,0a9h	; c305  ................
	defb 000h,086h,000h,086h,000h,087h,087h,000h,000h,000h,000h,088h,088h,0f4h,0b1h,0b3h	; c315  ................
	defb 0f5h,081h,000h,000h,000h,000h,000h,000h,082h,000h,000h,000h,087h,000h,000h,0a9h	; c325  ................
	defb 000h,087h,000h,087h,088h,08ah,086h,088h,08ah,088h,088h,0aeh,0afh,0b0h,0b1h,0b3h	; c335  ................
	defb 0f5h,081h,082h,000h,000h,000h,000h,081h,082h,000h,000h,000h,086h,085h,000h,000h	; c345  ................
	defb 088h,088h,08ah,08ah,0aeh,0b0h,088h,0aeh,0afh,0b0h,0aeh,0b4h,0b5h,0b6h,0b4h,0b6h	; c355  ................
	defb 0f5h,081h,082h,000h,000h,000h,000h,081h,082h,000h,000h,000h,087h,086h,000h,000h	; c365  ................
	defb 0aeh,0afh,0afh,0b0h,0b1h,0b3h,0bah,0b1h,0b2h,0b3h,0b4h,000h,000h,0a9h,000h,000h	; c375  ................
	defb 000h,081h,082h,000h,081h,000h,000h,081h,082h,000h,000h,000h,086h,087h,000h,088h	; c385  ................
	defb 0b1h,0b2h,0b2h,0b3h,0b4h,0b6h,0bah,0b1h,0b2h,0b3h,0aeh,000h,000h,0a9h,000h,000h	; c395  ................
	defb 000h,081h,082h,000h,081h,082h,08ah,081h,082h,000h,000h,000h,088h,088h,088h,0c7h	; c3a5  ................
	defb 0b1h,0b2h,0b2h,0b3h,0c8h,0c8h,0c8h,0b4h,0b5h,0b6h,0b4h,088h,088h,0a9h,088h,088h	; c3b5  ................
	defb 088h,083h,084h,08ah,083h,084h,088h,083h,084h,08ah,088h,0c7h,0c8h,0c8h,0c8h,0c8h	; c3c5  ................
	defb 0b4h,0b5h,0b5h,0b6h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c3d5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c3e5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h,0b7h,0b9h	; c3f5  ................
	defb 0dch,0dch,0cbh,000h,0dch,0dch,0cbh,0dch,0dch,0f4h,0b7h,0b9h,0f5h,0dch,0dch,0dch	; c405  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0cbh,0dch,0dch,0dch,000h,000h,000h,0b9h,0b7h	; c415  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0f4h,0b9h,0b7h,0f5h,0dch,0dch,0dch	; c425  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,000h,0cbh,0dch,0dch,000h,000h,000h,0b7h,0b9h	; c435  ................
	defb 0dch,0dch,0dch,0dch,0dch,0cbh,0dch,0dch,0dch,0f4h,0b7h,0b9h,0f5h,0dch,0dch,0dch	; c445  ................
	defb 0dch,0dch,0dch,0cbh,0dch,0dch,0dch,0dch,0dch,0dch,0dch,000h,000h,000h,0b9h,0b7h	; c455  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0cbh,0dch,0dch,0f4h,0b9h,0b7h,0f5h,0dch,0dch,0dch	; c465  ................
	defb 0dch,0dch,0dch,0dch,0dch,0cbh,0dch,0dch,0dch,0dch,0c7h,088h,088h,088h,0d0h,0b9h	; c475  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0f4h,0b7h,0b9h,0f5h,000h,000h,000h	; c485  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,085h,000h,0c8h,0aeh,0afh,0b0h,0aeh,0b0h	; c495  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0f4h,0b9h,0b7h,0f5h,000h,000h,000h	; c4a5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,086h,000h,0c8h,0b4h,0b5h,0b6h,0b4h,0b6h	; c4b5  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0f4h,0b7h,0b9h,0f5h,000h,000h,000h	; c4c5  ................
	defb 000h,000h,000h,000h,000h,085h,000h,000h,087h,000h,0c8h,000h,000h,000h,000h,000h	; c4d5  ................
	defb 000h,000h,000h,085h,000h,000h,000h,000h,000h,0f4h,0b9h,0b7h,0f5h,000h,000h,0f1h	; c4e5  ................
	defb 0f3h,000h,000h,000h,000h,087h,000h,000h,086h,000h,0c8h,000h,000h,000h,000h,000h	; c4f5  ................
	defb 000h,000h,000h,086h,000h,0c7h,0f5h,000h,000h,0f4h,0b7h,0b9h,0f5h,000h,000h,0f4h	; c505  ................
	defb 0c8h,000h,000h,000h,000h,086h,000h,000h,087h,000h,0c8h,088h,08ah,000h,000h,000h	; c515  ................
	defb 000h,000h,000h,087h,000h,0c8h,0f5h,000h,000h,0a9h,000h,000h,000h,000h,000h,0f4h	; c525  ................
	defb 0c8h,000h,000h,000h,000h,087h,000h,000h,086h,0c7h,0c8h,0aeh,0b0h,000h,000h,000h	; c535  ................
	defb 000h,085h,000h,086h,000h,0c8h,0f5h,000h,000h,0a9h,000h,000h,000h,000h,000h,0f4h	; c545  ................
	defb 0c8h,000h,000h,000h,000h,086h,000h,085h,087h,0c8h,0c8h,0b4h,0b6h,088h,08ah,000h	; c555  ................
	defb 000h,086h,000h,087h,000h,0c8h,0f5h,000h,000h,0a9h,000h,000h,000h,000h,000h,0f4h	; c565  ................
	defb 0c8h,000h,000h,0a9h,000h,087h,000h,087h,086h,0c8h,0c8h,0aeh,0afh,0afh,0b0h,000h	; c575  ................
	defb 000h,087h,085h,086h,0c7h,0c8h,0f3h,0f2h,0f2h,0a9h,0f2h,0f2h,0f2h,0f2h,0f2h,0f1h	; c585  ................
	defb 0c8h,000h,000h,0a9h,085h,086h,000h,086h,087h,0c8h,0c8h,0b4h,0b5h,0b5h,0b6h,088h	; c595  ................
	defb 08ah,086h,086h,0c7h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c5a5  ................
	defb 0c8h,000h,088h,0a9h,086h,087h,000h,087h,086h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c5b5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c5c5  ................
	defb 0c8h,0c9h,0c2h,0c3h,087h,086h,000h,086h,087h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c5d5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c5e5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c9h,087h,000h,087h,086h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c5f5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c605  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h,000h,0d7h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c615  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c625  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0d6h,0d7h,0c8h,0c8h,000h,000h,000h	; c635  ................
	defb 000h,085h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c645  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0d7h,0c8h,0c8h,0c8h,000h,000h,000h	; c655  ................
	defb 000h,087h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c665  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0d6h,0d7h,0c8h,0c8h,000h,085h,000h	; c675  ................
	defb 000h,086h,000h,000h,000h,000h,000h,000h,000h,0dch,0dch,0dch,0dch,0dch,0dch,0dch	; c685  ................
	defb 0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0dch,0c8h,0c8h,08ah,087h,000h	; c695  ................
	defb 085h,087h,000h,000h,000h,000h,000h,000h,000h,0dch,0dch,000h,000h,000h,000h,000h	; c6a5  ................
	defb 0cbh,000h,000h,000h,000h,000h,000h,000h,000h,0bbh,0bch,0c8h,0c8h,0c9h,086h,000h	; c6b5  ................
	defb 086h,086h,000h,000h,000h,000h,000h,000h,000h,088h,08ah,0cbh,000h,000h,000h,000h	; c6c5  ................
	defb 000h,000h,000h,000h,000h,000h,0bbh,0bch,000h,0bdh,0beh,0c8h,0c8h,0c8h,087h,000h	; c6d5  ................
	defb 087h,087h,000h,000h,000h,000h,000h,000h,000h,0d5h,0d7h,000h,0cbh,000h,000h,000h	; c6e5  ................
	defb 000h,000h,000h,0bbh,0bch,000h,0bdh,0beh,000h,07fh,080h,0c8h,0c8h,0c8h,08ah,085h	; c6f5  ................
	defb 086h,086h,000h,000h,0d5h,000h,000h,000h,000h,0d1h,0d2h,000h,000h,000h,000h,000h	; c705  ................
	defb 0cbh,0bch,0cbh,0bdh,0beh,000h,07fh,080h,000h,081h,082h,0c8h,0c8h,0c8h,0c9h,086h	; c715  ................
	defb 087h,087h,000h,085h,000h,000h,000h,000h,000h,0d8h,0d9h,000h,000h,0bbh,0bch,000h	; c725  ................
	defb 0bdh,0beh,000h,07fh,080h,000h,081h,082h,000h,081h,082h,0c8h,0c8h,0c8h,0c8h,087h	; c735  ................
	defb 086h,086h,000h,087h,000h,0d5h,000h,000h,000h,0d3h,0d4h,0bch,000h,0bdh,0beh,000h	; c745  ................
	defb 07fh,080h,000h,081h,082h,000h,081h,082h,000h,081h,082h,0c8h,0c8h,0c8h,0c8h,08ah	; c755  ................
	defb 087h,087h,000h,086h,000h,000h,000h,000h,000h,0d1h,0d2h,0d5h,0d6h,0d6h,0d6h,0d6h	; c765  ................
	defb 0d6h,0d6h,0d7h,0d5h,0d6h,0d6h,0d6h,0d6h,0d6h,0d6h,0d7h,0c8h,0c8h,0c8h,0c8h,0c9h	; c775  ................
	defb 08ah,08ah,08ah,0d5h,08ah,000h,000h,000h,000h,0d3h,0d4h,080h,000h,081h,082h,000h	; c785  ................
	defb 081h,082h,000h,081h,082h,000h,081h,082h,000h,081h,082h,0c8h,0c8h,0c8h,0c8h,0c8h	; c795  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c9h,000h,000h,000h,0abh,081h,082h,0abh,081h,082h,0abh	; c7a5  ................
	defb 081h,082h,0abh,081h,082h,0abh,081h,082h,0abh,081h,082h,0c8h,0c8h,0c8h,0c8h,0c8h	; c7b5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c9h,000h,000h,000h,083h,084h,000h,083h,084h,000h	; c7c5  ................
	defb 083h,084h,000h,083h,084h,000h,083h,084h,000h,083h,084h,0c8h,0c8h,0c8h,0c8h,0c8h	; c7d5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c7e5  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h	; c7f5
MAPA_FINAL:
	defb 000h,000h,000h,000h,000h	; c800  .....
	defb 08dh,08dh,08dh,08dh,08dh,08dh,000h,08dh,0a3h,0a4h,0a5h,0a6h,08dh,000h,08dh,08dh	; c805  ................
	defb 08dh,08dh,08dh,08dh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c815  ................
	defb 08dh,08dh,08dh,08dh,08dh,08dh,000h,08dh,0a7h,0a8h,096h,097h,08dh,000h,08dh,08dh	; c825  ................
	defb 08dh,08dh,08dh,08dh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c835  ................
	defb 08dh,0a3h,0a4h,0a5h,0a6h,08dh,000h,08dh,098h,000h,000h,098h,08dh,000h,08dh,0a3h	; c845  ................
	defb 0a4h,0a5h,0a6h,08dh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c855  ................
	defb 08dh,0a7h,0a8h,096h,097h,08dh,000h,08dh,098h,000h,000h,098h,08dh,000h,08dh,0a7h	; c865  ................
	defb 0a8h,096h,097h,08dh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c875  ................
	defb 08dh,098h,000h,000h,098h,08dh,000h,08dh,098h,000h,000h,098h,08dh,000h,08dh,098h	; c885  ................
	defb 000h,000h,098h,08dh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c895  ................
	defb 08dh,098h,000h,000h,098h,08dh,000h,08dh,098h,000h,000h,098h,08dh,000h,08dh,098h	; c8a5  ................
	defb 000h,000h,098h,08dh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c8b5  ................
	defb 08dh,098h,000h,000h,098h,08dh,000h,08dh,098h,000h,000h,098h,08dh,000h,08dh,098h	; c8c5  ................
	defb 000h,000h,098h,08dh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,03bh,03ch	; c8d5  ..............;<
	defb 08dh,098h,000h,000h,098h,08dh,000h,08fh,08fh,08fh,08fh,08fh,08fh,000h,08dh,098h	; c8e5  ................
	defb 000h,000h,098h,08dh,03dh,03eh,000h,000h,000h,000h,000h,000h,000h,000h,03fh,03fh	; c8f5  ....=>........??
	defb 08dh,098h,000h,000h,098h,08dh,000h,000h,000h,000h,000h,000h,000h,000h,08dh,098h	; c905  ................
	defb 000h,000h,098h,08dh,040h,040h,000h,000h,000h,000h,000h,000h,000h,000h,08fh,08fh	; c915  ....@@..........
	defb 08fh,08fh,08fh,08fh,08fh,08fh,08fh,000h,000h,000h,000h,000h,000h,08fh,08fh,08fh	; c925  ................
	defb 08fh,08fh,08fh,08fh,08fh,08fh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c935  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c945  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; c955
TEXTO_FINAL:
	defb 000h,000h,041h,04ch,045h	; c960  ..ALE
	defb 04ch,055h,059h,041h,06bh,000h,04fh,048h,000h,046h,052h,041h,059h,000h,041h,052h	; c965  LUYAk.OH.FRAY.AR
	defb 04eh,056h,04ch,046h,04fh,069h,069h,000h,000h,000h,000h,000h,000h,053h,055h,050h	; c975  NVLFOii......SUP
	defb 045h,052h,041h,04eh,044h,04fh,000h,054h,04fh,044h,04fh,053h,000h,04ch,04fh,053h	; c985  ERANDO.TODOS.LOS
	defb 000h,050h,045h,04ch,049h,047h,052h,04fh,053h,000h,000h,000h,000h,044h,045h,04ch	; c995  .PELIGROS....DEL
	defb 000h,04dh,041h,04ch,000h,048h,041h,053h,000h,047h,041h,04eh,041h,044h,04fh,000h	; c9a5  .MAL.HAS.GANADO.
	defb 045h,04ch,000h,043h,049h,045h,04ch,04fh,000h,000h,000h,000h,000h,068h,053h,04fh	; c9b5  EL.CIELO.....hSO
	defb 04ch,055h,04dh,000h,056h,049h,043h,054h,04fh,052h,049h,055h,053h,000h,045h,053h	; c9c5  LUM.VICTORIUS.ES
	defb 054h,000h,047h,04ch,04fh,052h,049h,041h,068h,000h,000h,000h,066h,066h,054h,045h	; c9d5  T.GLORIAh...ffTE
	defb 000h,041h,054h,052h,045h,055h,045h,052h,041h,053h,000h,043h,04fh,04eh,000h,068h	; c9e5  .ATREUERAS.CON.h
	defb 041h,04ch,045h,048h,04fh,050h,069h,068h,067h,067h,000h	; c9f5
BLOQUE_MUERTO:
	defb 000h,08fh,0cdh,0f7h,08bh	; ca00  .....
	defb 0ddh,07eh,000h,098h,0feh,000h,0cch,023h,08ah,0cdh,003h,083h,03ah,01bh,08fh,03ch	; ca05  .~.....#....:..<
	defb 032h,01bh,08fh,0feh,008h,0c8h,011h,005h,000h,0fdh,019h,0c3h,002h,08ah,0cdh,0f7h	; ca15  2...............
	defb 08bh,0ddh,07eh,001h,099h,0feh,000h,0cah,035h,08ah,0feh,001h,0cah,035h,08ah,0c9h	; ca25  ..~.....5....5..
	defb 0cdh,07dh,087h,0ddh,046h,000h,0ddh,04eh,001h,0cdh,04bh,08ah,0ddh,07eh,003h,0cdh	; ca35  .}..F..N..K..~..
	defb 04dh,000h,0cdh,0e9h,089h,0c9h,0c5h,0d5h,0f5h,058h,016h,000h,006h,000h,0cbh,021h	; ca45  M........X.....!
	defb 0cbh,010h,0cbh,021h,0cbh,010h,0cbh,021h,0cbh,010h,0cbh,021h,0cbh,010h,0cbh,021h	; ca55  ...!...!...!...!
	defb 0cbh,010h,021h,000h,018h,019h,009h,0f1h,0d1h,0c1h,0c9h,03ah,00dh,08fh,057h,0cbh	; ca65  ..!........:..W.
	defb 022h,01eh,000h,021h,000h,090h,019h,011h,080h,07dh,001h,000h,002h,0edh,0b0h,0c9h	; ca75  "..!.....}......
	defb 021h,080h,07dh,001h,000h,002h,0edh,0b1h,021h,0ffh,001h,0edh,042h,044h,04dh,021h	; ca85  !.}.....!...BDM!
	defb 080h,07dh,009h,036h,000h,0cdh,09eh,08ah,0c9h,021h,080h,07dh,011h,000h,018h,001h	; ca95  .}.6.....!.}....
	defb 000h,002h,0cdh,05ch,000h,0c9h,03ah,00dh,08fh,0feh,00dh,0cah,0e5h,08ah,0feh,014h	; caa5  ...\..:.........
	defb 0cah,00eh,08bh,0feh,01bh,0cah,026h,08bh,0feh,006h,0cah,0dfh,08ah,0c3h,009h,086h	; cab5  ......&.........
	defb 03ah,00dh,08fh,0feh,00dh,0cah,0e5h,08ah,0feh,014h,0cah,00eh,08bh,0feh,01bh,0cah	; cac5  :...............
	defb 026h,08bh,0feh,006h,0cah,0dfh,08ah,0c3h,01ah,086h,0cdh,045h,08bh,0c3h,01dh,086h	; cad5  &..........E....
	defb 021h,000h,058h,001h,0c0h,004h,011h,040h,03bh,0cdh,05ch,000h,03eh,000h,032h,011h	; cae5  !.X....@;.\.>.2.
	defb 08fh,03eh,008h,032h,00bh,08fh,03eh,008h,032h,009h,08fh,032h,013h,08fh,03eh,028h	; caf5  .>.2..>.2..2..>(
	defb 032h,00ah,08fh,032h,014h,08fh,0c3h,0dfh,08ah,0cdh,045h,08bh,03eh,00ch,032h,0ebh	; cb05  2..2......E.>.2.
	defb 0f3h,0cdh,062h,000h,03eh,001h,032h,011h,08fh,03eh,00bh,032h,00bh,08fh,0c3h,01dh	; cb15  ..b.>.2..>.2....
	defb 086h,03ah,00dh,08fh,03ch,032h,00dh,08fh,0cdh,0a1h,087h,0cdh,070h,08ah,0cdh,09eh	; cb25  .:..<2......p...
	defb 08ah,0cdh,05eh,080h,0cdh,0cdh,086h,0cdh,003h,083h,076h,076h,076h,0c3h,039h,08bh	; cb35  ..^.......vvv.9.
	defb 0cdh,089h,08bh,03ah,00eh,08fh,03ch,032h,00eh,08fh,03ah,00dh,08fh,03ch,032h,00dh	; cb45  ...:..<2..:..<2.
	defb 08fh,021h,080h,07fh,0cdh,098h,08bh,021h,053h,019h,03ah,00eh,08fh,006h,05dh,080h	; cb55  .!.....!S.:...].
	defb 0cdh,04dh,000h,0cdh,0a2h,08bh,0cdh,0a1h,087h,0cdh,070h,08ah,0cdh,03ah,086h,0cdh	; cb65  .M........p..:..
	defb 09eh,08ah,03ah,00dh,08fh,03dh,032h,00dh,08fh,03eh,000h,032h,018h,08fh,03eh,001h	; cb75  ..:..=2..>.2..>.
	defb 032h,017h,08fh,0c9h,0cdh,0f0h,082h,001h,000h,003h,021h,000h,018h,03eh,000h,0cdh	; cb85  2.........!..>..
	defb 056h,000h,0c9h,011h,04bh,019h,001h,00ah,000h,0cdh,05ch,000h,0c9h,0cdh,0b5h,08bh	; cb95  V...K.....\.....
	defb 0cdh,0b5h,08bh,0cdh,0b5h,08bh,0cdh,0b5h,08bh,0cdh,0b5h,08bh,0cdh,0b5h,08bh,0c9h	; cba5  ................
	defb 0cdh,0bfh,08bh,0cdh,0bfh,08bh,0cdh,0bfh,08bh,0c9h,076h,076h,076h,0c9h,0cdh,090h	; cbb5  ..........vvv...
	defb 000h,03ah,069h,08ch,032h,09fh,0fdh,02ah,06ah,08ch,022h,0a0h,0fdh,021h,004h,01bh	; cbc5  .:i.2..*j."..!..
	defb 03eh,0c8h,0cdh,04dh,000h,021h,000h,01bh,03eh,0c8h,0cdh,04dh,000h,0cdh,0a2h,08bh	; cbd5  >..M.!..>..M....
	defb 0cdh,089h,08bh,021h,08ah,07fh,0cdh,098h,08bh,0cdh,0a2h,08bh,0cdh,0a2h,08bh,0c3h	; cbe5  ...!............
	defb 076h,080h,0fdh,046h,000h,0cbh,038h,0cbh,038h,0cbh,038h,0fdh,04eh,001h,0cbh,039h	; cbf5  v..F..8.8.8.N..9
	defb 0cbh,039h,0cbh,039h,0c9h,0d5h,05fh,016h,000h,019h,0d1h,0c9h,029h,061h,004h,00fh	; cc05  .9.9.._.....)a..
	defb 029h,07eh,004h,00fh,028h,052h,004h,00fh,029h,09eh,004h,00fh,000h,000h,000h,005h	; cc15  )~..(R..).......
	defb 006h,005h,006h,000h,007h,003h,004h,00bh,00ch,00dh,00eh,000h,010h,011h,012h,013h	; cc25  ................
	defb 015h,014h,016h,017h,018h,019h,01ah,01bh,01ch,01dh,01eh,01fh,020h,021h,011h,023h	; cc35  ............ !.#
	defb 024h,026h,025h,027h,028h,029h,02ah,02bh,02ch,02dh,02eh,02fh,030h,031h,000h,008h	; cc45  $&%'()*+,-./01..
	defb 009h,001h,000h,000h,000h,002h,00ah,000h,05eh,0a3h,05eh,0a3h,06eh,0b3h,03ah,000h	; cc55  ........^.^.n.:.
	defb 004h,001h,000h,000h,000h,000h,000h,0d5h,05fh,016h,000h,019h,0d1h,0c9h,029h,061h	; cc65  ........_.....)a
	defb 004h,00fh,029h,07eh,004h,00fh,028h,052h,004h,00fh,029h,09eh,004h,00fh,000h,000h	; cc75  ..)~..(R..).....
	defb 000h,005h,006h,005h,006h,000h,007h,003h,004h,00bh,00ch,00dh,00eh,000h,010h,011h	; cc85  ................
	defb 012h,013h,015h,014h,016h,017h,018h,019h,01ah,01bh,01ch,01dh,01eh,01fh,020h,021h	; cc95  .............. !
	defb 011h,023h,024h,026h,025h,027h,028h,029h,02ah,02bh,02ch,02dh,02eh,02fh,030h,031h	; cca5  .#$&%'()*+,-./01
	defb 000h,008h,009h,001h,000h,000h,000h,002h,00ah,000h,05eh,0a3h,05eh,0a3h,06eh,0b3h	; ccb5  ..........^.^.n.
	defb 03ah,000h,004h,001h,000h,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; ccc5  :...............
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; ccd5  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; cce5  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0f5h,09bh,0f4h,082h	; ccf5  ................
	defb 074h,09bh,074h,0bbh,074h,0bbh,074h,0dbh,054h,0bbh,054h,0fbh,0d4h,0ffh,044h,0ffh	; cd05  t.t.t.t.T.T...D.
	defb 044h,0bbh,044h,0bbh,044h,0bfh,054h,0bfh,044h,0bbh,044h,0bbh,040h,0bbh,044h,0bfh	; cd15  D.D.D.T.D.D.@.D.
	defb 044h,0bbh,044h,0abh,044h,0bbh,044h,0abh,044h,08bh,044h,0bbh,044h,0bbh,044h,0abh	; cd25  D.D.D.D.D.D.D.D.
	defb 044h,0abh,044h,0abh,044h,0abh,004h,0abh,004h,08ah,054h,0fbh,054h,0fbh,054h,0fbh	; cd35  D.D.D.....T.T.T.
	defb 0f4h,0fbh,074h,0fbh,044h,0fbh,044h,0bbh,054h,0bbh,054h,0ffh,054h,0ebh,044h,0bbh	; cd45  ..t.D.D.T.T.T.D.
	defb 054h,0bbh,044h,0fbh,044h,0fbh,044h,0bbh,044h,0bfh,044h,0ffh,044h,0fbh,040h,0bfh	; cd55  T.D.D.D.D.D.D.@.
	defb 040h,0bfh,000h,0dfh,040h,09bh,040h,0bfh,000h,0bbh,040h,08bh,040h,08ah,040h,0abh	; cd65  @...@.@...@.@.@.
	defb 040h,0abh,040h,08bh,040h,082h,044h,08ah,044h,08ah,0ffh,0feh,0f4h,0deh,0f4h,0dah	; cd75  @.@.@.D.D.......
	defb 0f4h,0deh,054h,0ffh,0f4h,0ffh,054h,0dfh,054h,0ffh,054h,0ffh,0d4h,0ffh,054h,0ffh	; cd85  ..T...T.T.T...T.
	defb 054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,050h,0ffh,044h,0ffh	; cd95  T.T.T.T.T.T.P.D.
	defb 044h,0ffh,044h,0fbh,044h,0fbh,044h,0fbh,044h,0dbh,044h,0fbh,044h,0bbh,044h,0fbh	; cda5  D.D.D.D.D.D.D.D.
	defb 044h,0bah,044h,0fbh,054h,0bbh,014h,0fbh,004h,08ah,054h,0feh,054h,0ffh,054h,0ffh	; cdb5  D.D.T.....T.T.T.
	defb 0d4h,0ffh,054h,0fbh,054h,0ffh,054h,0ffh,054h,0fbh,054h,0ffh,054h,0fbh,054h,0fbh	; cdc5  ..T.T.T.T.T.T.T.
	defb 054h,0fbh,054h,0fbh,044h,0fbh,044h,0fbh,054h,0ffh,0d4h,0feh,044h,0feh,040h,0ffh	; cdd5  T.T.D.D.T...D.@.
	defb 044h,0ffh,050h,0deh,040h,0dah,040h,0ffh,000h,0feh,040h,0dah,040h,0dah,040h,0fah	; cde5  D.P.@.@...@.@.@.
	defb 040h,0beh,040h,0dah,040h,0cah,044h,09ah,054h,09ah,0ffh,03eh,001h,032h,015h,08fh	; cdf5  @.@.@.D.T..>.2..
	defb 03eh,000h,032h,016h,08fh,021h,080h,07dh,03ah,016h,08fh,016h,000h,05fh,0cbh,023h	; ce05  >.2..!.}:...._.#
	defb 0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h	; ce15  ...#...#...#...#
	defb 0cbh,012h,019h,03ah,015h,08fh,016h,000h,05fh,019h,03ah,015h,08fh,006h,000h,04fh	; ce25  ...:...._.:....O
	defb 03eh,021h,099h,04fh,0e5h,021h,000h,018h,03ah,016h,08fh,016h,000h,05fh,0cbh,023h	; ce35  >!.O.!..:...._.#
	defb 0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h	; ce45  ...#...#...#...#
	defb 0cbh,012h,019h,054h,05dh,0e1h,0cdh,05ch,000h,021h,000h,092h,03ah,00dh,08fh,057h	; ce55  ...T]..\.!..:..W
	defb 0cbh,022h,01eh,000h,019h,03ah,016h,08fh,016h,000h,05fh,0cbh,023h,0cbh,012h,0cbh	; ce65  ."...:...._.#...
	defb 023h,0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h,0cbh,012h,019h	; ce75  #...#...#...#...
	defb 03ah,015h,08fh,006h,000h,04fh,0e5h,021h,000h,018h,03ah,016h,08fh,016h,000h,05fh	; ce85  :....O.!..:...._
	defb 0cbh,023h,0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h,0cbh,012h,0cbh,023h,0cbh,012h	; ce95  .#...#...#...#..
	defb 0cbh,023h,0cbh,012h,019h,03ah,015h,08fh,05fh,03eh,020h,09bh,05fh,016h,000h,019h	; cea5  .#...:.._> ._...
	defb 054h,05dh,0e1h,0cdh,05ch,000h,03ah,016h,08fh,03ch,032h,016h,08fh,0feh,010h,0c2h	; ceb5  T]..\.:..<2.....
	defb 00ah,08eh,03ah,015h,08fh,03ch,032h,015h,08fh,0feh,021h,0c8h,076h,0c3h,005h,08eh	; cec5  ..:..<2...!.v...
	defb 054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,044h,0ffh,040h,0ffh	; ced5  T.T.T.T.T.T.D.@.
	defb 054h,0ffh,054h,0deh,044h,0dfh,044h,0ffh,044h,0ffh,040h,0deh,044h,0deh,044h,0feh	; cee5  T.T.D.D.D.@.D.D.
	defb 044h,0beh,044h,0deh,044h,0cah,044h,09ah,054h,09ah,0ffh,0deh,0f4h,09eh,0f4h,09eh	; cef5  D.D.D.D.T.......
	defb 074h,09eh,054h,0dfh,054h,0bfh,054h,0dfh,054h,09fh,054h,0ffh,0d4h,0ffh,054h,0ffh	; cf05  t.T.T.T.T.T...T.
	defb 054h,0bfh,044h,0bfh,044h,0bfh,054h,09fh,044h,0bfh,044h,0bfh,044h,0bfh,044h,0bfh	; cf15  T.D.D.T.D.D.D.D.
	defb 044h,0ffh,044h,0bfh,044h,0bbh,044h,0bbh,044h,09bh,044h,0bbh,044h,0bbh,044h,0bbh	; cf25  D.D.D.D.D.D.D.D.
	defb 044h,08bh,044h,0abh,044h,0bbh,014h,08bh,004h,08ah,054h,0deh,054h,0deh,054h,0ffh	; cf35  D.D.D.....T.T.T.
	defb 054h,0ffh,054h,0feh,054h,0ffh,054h,0ffh,054h,0bfh,054h,0ffh,054h,0deh,044h,0bfh	; cf45  T.T.T.T.T.T.T.D.
	defb 054h,0bfh,044h,0ffh,044h,0fbh,044h,0bfh,044h,0bfh,054h,0deh,044h,0deh,040h,0bfh	; cf55  T.D.D.D.D.T.D.@.
	defb 044h,0bfh,040h,0deh,044h,0deh,044h,0bfh,004h,09eh,040h,08eh,044h,09ah,044h,09ah	; cf65  D.@.D.D...@.D.D.
	defb 044h,08eh,040h,08ah,044h,08ah,044h,08ah,054h,08ah,0ffh,0feh,0f4h,0deh,0f4h,0deh	; cf75  D.@.D.D.T.......
	defb 074h,0deh,074h,0ffh,074h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,044h,0ffh	; cf85  t.t.t.T.T.T.T.D.
	defb 054h,0ffh,044h,0ffh,044h,0ffh,054h,0ffh,044h,0ffh,044h,0ffh,044h,0ffh,044h,0ffh	; cf95  T.D.D.T.D.D.D.D.
	defb 044h,0ffh,044h,0ffh,044h,0fbh,044h,0fah,044h,0fbh,044h,0fbh,044h,0fbh,044h,0fah	; cfa5  D.D.D.D.D.D.D.D.
	defb 044h,0eah,044h,0fbh,044h,0fbh,044h,0eah,044h,0cah,044h,0feh,054h,0feh,054h,0ffh	; cfb5  D.D.D.D.D.D.T.T.
	defb 054h,0ffh,054h,0feh,044h,0feh,044h,0ffh,054h,0ffh,054h,0feh,044h,0feh,044h,0ffh	; cfc5  T.T.D.D.T.T.D.D.
	defb 054h,0ffh,044h,0ffh,044h,0fbh,044h,0ffh,044h,0ffh,044h,0feh,044h,0feh,040h,0feh	; cfd5  T.D.D.D.D.D.D.@.
	defb 044h,0ffh,040h,0deh,040h,0deh,044h,0feh,040h,0feh,040h,0deh,040h,0cah,044h,0fah	; cfe5  D.@.@.D.@.@.@.D.
	defb 044h,0feh,040h,0cah,040h,0cah,044h,0cah,044h,0cah,0ffh	; cff5  D.@.@.D.D..

; ======================================================================
; CODIGO 0xd000..0xd015  (21 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; RUTINA DE INTERRUPCION (60 Hz)
; ############################################################
; Se engancha en el hook H.TIMI de la BIOS (0xFD9F), que el MSX
; llama en cada interrupcion de barrido. Verificado leyendo
; 0xFD9F con el juego en marcha: contiene C3 00 D0 (jp 0d000h).
; La instalacion la hace la rutina de menu en 0xDA00.
; ----------------------------------------------------------------------
IRQ_HANDLER:		; Manejador de la interrupcion de temporizador
	di			;d000   ; Quita de la pila la direccion de retorno que metio la BIOS
	pop hl			;d001
	call SND_UPDATE		;d002   ; Todo el trabajo real: avanzar los 3 canales de sonido
	pop ix			;d005   ; Restaura el contexto completo que la BIOS habia apilado
	pop iy			;d007
	pop af			;d009
	pop bc			;d00a
	pop de			;d00b
	pop hl			;d00c
	ex af,af'		;d00d
	exx			;d00e
	pop af			;d00f
	pop bc			;d010
	pop de			;d011
	pop hl			;d012
	ei			;d013
	ret			;d014

; ----------------------------------------------------------------------
; DATOS muerto_D015: 44 bytes entre el manejador de interrupcion y la rutina de asignar melodia, sin un solo acceso en una partida completa.
;   0xd015..0xd041  (44 bytes)
; ----------------------------------------------------------------------

; ----------------------------------------------------------------------
; ############################################################
; ENTRADA MUERTA DE LA LIBRERIA DE SONIDO
; ############################################################
; Es codigo real y bien formado (la pila cuadra por los dos
; caminos y encadena con la cola de 0xD04D), pero no lo llama
; nadie: la palabra 15 D0 no aparece ni una sola vez, ni en los
; 40449 bytes de la cinta ni en NINGUNO de los volcados de 64 KB
; con el juego vivo (turbo1_ram, full_at_8000, full_at_88B8,
; running_full, scr25, poketest, pcsample_full), ROM incluida.
; El unico salto indirecto de todo el reproductor es el 'jp (hl)'
; de 0xD09B (el unico byte E9 entre 0xD000 y 0xD460) y va por la
; tabla de 15 comandos de 0xD513, cuyos destinos estan todos
; identificados. Y 0xD014 es un RET, asi que tampoco se cae aqui
; por arrastre. El juego entra siempre por 0xD041.
; ----------------------------------------------------------------------
SND_SET_CANAL_LIBRE:		; Variante que busca canal libre si el pedido esta ocupado. CODIGO MUERTO: la palabra 0xD015 no aparece en ningun sitio del binario, nadie la llama
	defb 0f5h,0d5h,0e6h,07fh,011h,02eh,000h,0cdh,002h,0d4h,011h,03eh,0d5h,019h,0e5h,07eh	; d015  ...........>...~
	defb 023h,0b6h,028h,012h,016h,003h,021h,03eh,0d5h,001h,02eh,000h,023h,07eh,02bh,0b6h	; d025  #.(...!>....#~+.
	defb 028h,007h,009h,015h,020h,0f6h,0e1h,018h,00fh,0d1h,018h,00ch	; d035  (... .......

; ======================================================================
; CODIGO 0xd041..0xd453  (1042 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; FORMATO DE UN CANAL: 46 bytes (0x2E)
; ############################################################
; Los tres canales estan en 0xD53E, 0xD56C y 0xD59A.
; +00,+01  puntero al INICIO de los datos (lo usa el comando 0x82)
; +02,+03  puntero de lectura ACTUAL
; +04,+05  ticks que faltan para el siguiente evento (16 bits)
; +06,+07  duracion de nota vigente; recarga de +04/+05
; +08      mascara de mezclador: bit0 tono, bit3 ruido (cmd 0x81)
; +09      volumen base (cmd 0x80); el resultado se recorta a 4 bits
; +0A,+0B  periodo de la nota, sacado de la tabla 0xD453
; +0C,+0D  envolvente de VOLUMEN: contador de espera, fases 0 y 1
; +0E,+0F  envolvente de VOLUMEN: pasos que quedan, fases 0 y 1
; +10..+12 envolvente de TONO: contador de espera, fases 0,1,2
; +13..+15 envolvente de TONO: pasos que quedan, fases 0,1,2
; +16,+17  INSTRUMENTO: pasos totales de las 2 fases de volumen
; +18..+1A INSTRUMENTO: pasos totales de las 3 fases de tono
; +1B,+1C  INSTRUMENTO: incremento de volumen por paso (con signo)
; +1D..+1F INSTRUMENTO: incremento de tono por paso (con signo)
; +20,+21  INSTRUMENTO: velocidad de las 2 fases de volumen
; +22..+24 INSTRUMENTO: velocidad de las 3 fases de tono
; +25..+29 sin usar: ninguna instruccion los toca
; +2A      desplazamiento de volumen que lleva acumulado la envolvente
; +2B,+2C  desplazamiento de tono acumulado (12 bits, se enmascara)
; +2D      bit0 repetir envolvente de volumen, bit1 la de tono
; Los campos +16..+24 son los 15 bytes que copia el comando 0x87 de
; golpe desde la tabla de instrumentos; +0C..+15 son su estado vivo.
; ----------------------------------------------------------------------
SND_SET_CANAL:		; Asigna al canal A los datos de sonido que apunta DE
	push af			;d041   ; La otra entrada, y la unica que el juego usa de verdad: machaca el canal A sin mirar si esta sonando
	push de			;d042
	ld de,0002eh		;d043   ; 46 bytes por canal
	call SND_MUL		;d046   ; HL = 0xD53E + A*46 -> estructura del canal A
	ld de,0d53eh		;d049
	add hl,de		;d04c
	push hl			;d04d   ; Cola comun de 0xD015 y 0xD041: borra los 46 bytes de la estructura y siembra en ella el puntero de melodia, dos copias [SUSTITUYE]
	xor a			;d04e
	ld b,02eh		;d04f
L_D051:
	ld (hl),a		;d051
	inc hl			;d052
	djnz L_D051		;d053
	pop hl			;d055
	pop de			;d056
	ld (hl),e		;d057   ; Palabra 0 = puntero de arranque; el comando 0x82 (0xD2DA) lo copia sobre la palabra 2 para repetir la melodia desde el principio [SUSTITUYE]
	inc hl			;d058
	ld (hl),d		;d059
	inc hl			;d05a
	ld (hl),e		;d05b   ; Palabra 2 = puntero de lectura, el que avanza; 0xD082 lo carga en BC y 0xD08D lee por el el siguiente byte del flujo
	inc hl			;d05c
	ld (hl),d		;d05d
	pop af			;d05e
	ret			;d05f
SND_UPDATE:		; Avanza los 3 canales un tick; se llama desde la IRQ
	push af			;d060
	ld b,003h		;d061   ; Tres canales del PSG
	xor a			;d063
	ld ix,0d53eh		;d064   ; IX = estructura del canal 0
	ld de,0d533h		;d068   ; DE recorre la sombra R0..R5 (periodos de tono), dos bytes por canal; 0xD1A5 y 0xD1AD lo van adelantando
	ld hl,0d53bh		;d06b   ; HL recorre la sombra R8..R10 (volumenes), un byte por canal; 0xD1B7 lo adelanta
L_D06E:
	push af			;d06e
	push hl			;d06f
	push de			;d070
	push bc			;d071
	ld (0d531h),a		;d072   ; Numero del canal que se esta procesando; lo leen el mezclador, la transposicion y los comandos de frase
	ld a,(ix+004h)		;d075   ; Si el canal esta en pausa/retardo, no lo toca
	or (ix+005h)		;d078
	jp nz,L_D0D9		;d07b
	xor a			;d07e   ; Silencia el canal antes de montar el evento nuevo
	call SND_MIXER		;d07f
	ld c,(ix+002h)		;d082   ; BC = puntero a los datos de sonido del canal
	ld b,(ix+003h)		;d085
	ld a,b			;d088
	or c			;d089
	jp z,L_D192		;d08a   ; Puntero nulo: canal en silencio
L_D08D:
	ld a,(bc)		;d08d   ; Lee el siguiente byte del "tracker"
	cp 080h			;d08e   ; >= 0x80 es un COMANDO; por debajo es una NOTA
	jp c,L_D09C		;d090
	sub 080h		;d093   ; Indice de comando 0..14
	ld hl,0d513h		;d095   ; Tabla de saltos de comandos
	call SND_JUMPIDX		;d098   ; HL = word en (0xD513 + A*2)
	jp (hl)			;d09b   ; Salta al comando. El trazador no puede seguir esto: los 15 destinos se siembran a mano en game.entries
L_D09C:
	push af			;d09c
	call SND_PTR_TRANSP		;d09d   ; HL = 0xD5DC + canal: la transposicion de este canal
	pop af			;d0a0
	add a,(hl)		;d0a1   ; Nota + transposicion = indice en la tabla cromatica
	ld hl,0d453h		;d0a2   ; Tabla de 96 periodos; con el reloj REAL del PSG del MSX (1789772,5 Hz) el indice 0 es un DO de 32,70 Hz, no de 65,4 [SUSTITUYE: la nota anterior usaba el reloj sin dividir entre 2]
	call SND_JUMPIDX		;d0a5
	ld (ix+00ah),l		;d0a8
	ld (ix+00bh),h		;d0ab
	inc bc			;d0ae
L_D0AF:
	ld a,(ix+008h)		;d0af   ; Cola comun a nota y percusion: aplica mezclador, reinicia envolventes y recarga la duracion
	call SND_MIXER		;d0b2
	call SND_RESET_ENV_VOL		;d0b5
	ld (ix+02ah),000h	;d0b8
	call SND_RESET_ENV_TONO		;d0bc
	ld (ix+02bh),000h	;d0bf
	ld (ix+02ch),000h	;d0c3
L_D0C7:
	ld (ix+002h),c		;d0c7   ; Guarda el puntero de lectura y arranca la cuenta atras de la nota
	ld (ix+003h),b		;d0ca
	ld l,(ix+006h)		;d0cd
	ld h,(ix+007h)		;d0d0
	ld (ix+004h),l		;d0d3
	ld (ix+005h),h		;d0d6
L_D0D9:
	ld l,(ix+004h)		;d0d9
	ld h,(ix+005h)		;d0dc
	dec hl			;d0df
	ld (ix+004h),l		;d0e0
	ld (ix+005h),h		;d0e3
	push ix			;d0e6
	pop iy			;d0e8
	ld d,002h		;d0ea
	ld c,000h		;d0ec
L_D0EE:
	ld a,(iy+00ch)		;d0ee   ; Envolvente de VOLUMEN: dos fases, IY va recorriendo ix+0 e ix+1
	or a			;d0f1
	jr z,L_D0FB		;d0f2
	dec a			;d0f4
	ld (iy+00ch),a		;d0f5
	inc c			;d0f8
	jr L_D11C		;d0f9
L_D0FB:
	ld a,(iy+00eh)		;d0fb
	or a			;d0fe
	jr z,L_D117		;d0ff
	dec a			;d101
	ld (iy+00eh),a		;d102
	ld a,(ix+02ah)		;d105
	add a,(iy+01bh)		;d108
	ld (ix+02ah),a		;d10b
	ld a,(iy+020h)		;d10e
	ld (iy+00ch),a		;d111
	inc c			;d114
	jr L_D11C		;d115
L_D117:
	inc iy			;d117
	dec d			;d119
	jr nz,L_D0EE		;d11a
L_D11C:
	ld a,c			;d11c
	or a			;d11d
	jr nz,L_D127		;d11e
	bit 0,(ix+02dh)		;d120   ; Agotadas las dos fases, si el bit 0 de +2D esta puesto la envolvente se repite
	call nz,SND_RESET_ENV_VOL	;d124
L_D127:
	push ix			;d127
	pop iy			;d129
	ld d,003h		;d12b
	ld c,000h		;d12d
L_D12F:
	ld a,(iy+010h)		;d12f   ; Envolvente de TONO: tres fases, IY recorre ix+0, ix+1 e ix+2
	or a			;d132
	jr z,L_D13C		;d133
	dec a			;d135
	ld (iy+010h),a		;d136
	inc c			;d139
	jr L_D187		;d13a
L_D13C:
	ld a,(iy+013h)		;d13c
	or a			;d13f
	jr z,L_D182		;d140
	dec a			;d142
	ld (iy+013h),a		;d143
	ld a,(iy+01dh)		;d146
	or a			;d149
	jp p,L_D166		;d14a   ; Incremento negativo: se resta en lugar de sumarse
	ld a,(iy+01dh)		;d14d
	cpl			;d150
	inc a			;d151
	ld e,a			;d152
	ld a,(ix+02bh)		;d153
	sub e			;d156
	ld (ix+02bh),a		;d157
	ld a,(ix+02ch)		;d15a
	sbc a,000h		;d15d
	and 00fh		;d15f   ; El desplazamiento de tono se queda en 12 bits, que es lo que admite el PSG
	ld (ix+02ch),a		;d161
	jr L_D179		;d164
L_D166:
	ld a,(ix+02bh)		;d166
	add a,(iy+01dh)		;d169
	ld (ix+02bh),a		;d16c
	ld a,(ix+02ch)		;d16f
	adc a,000h		;d172
	and 00fh		;d174
	ld (ix+02ch),a		;d176
L_D179:
	ld a,(iy+022h)		;d179
	ld (iy+010h),a		;d17c
	inc c			;d17f
	jr L_D187		;d180
L_D182:
	inc iy			;d182
	dec d			;d184
	jr nz,L_D12F		;d185
L_D187:
	ld a,c			;d187
	or a			;d188
	jr nz,L_D192		;d189
	bit 1,(ix+02dh)		;d18b   ; Agotadas las tres fases, si el bit 1 de +2D esta puesto la envolvente se repite
	call nz,SND_RESET_ENV_TONO	;d18f
L_D192:
	pop bc			;d192
	pop de			;d193
	pop hl			;d194
	ld a,(ix+009h)		;d195   ; Volumen final = volumen base + lo que lleve la envolvente, recortado a 4 bits
	add a,(ix+02ah)		;d198
	and 00fh		;d19b
	ld (hl),a		;d19d
	ld a,(ix+00ah)		;d19e   ; Periodo final = periodo de la nota + desplazamiento de la envolvente de tono
	add a,(ix+02bh)		;d1a1
	ld (de),a		;d1a4
	inc de			;d1a5
	ld a,(ix+00bh)		;d1a6
	adc a,(ix+02ch)		;d1a9
	ld (de),a		;d1ac
	inc de			;d1ad
	push de			;d1ae
	ld de,0002eh		;d1af   ; Siguiente canal: 46 bytes mas alla
	add ix,de		;d1b2
	pop de			;d1b4
	pop af			;d1b5
	inc a			;d1b6
	inc hl			;d1b7
	dec b			;d1b8
	jp nz,L_D06E		;d1b9
	ld iy,0d5c8h		;d1bc   ; Envolvente GLOBAL del periodo de ruido; es una sola para los tres canales
	ld d,002h		;d1c0
	ld c,000h		;d1c2
L_D1C4:
	ld a,(iy+000h)		;d1c4
	or a			;d1c7
	jr z,L_D1D1		;d1c8
	dec a			;d1ca
	ld (iy+000h),a		;d1cb
	inc c			;d1ce
	jr L_D1F2		;d1cf
L_D1D1:
	ld a,(iy+002h)		;d1d1
	or a			;d1d4
	jr z,L_D1ED		;d1d5
	dec a			;d1d7
	ld (iy+002h),a		;d1d8
	ld a,(0d5d4h)		;d1db
	add a,(iy+006h)		;d1de
	ld (0d5d4h),a		;d1e1
	ld a,(iy+008h)		;d1e4
	ld (iy+000h),a		;d1e7
	inc c			;d1ea
	jr L_D1F2		;d1eb
L_D1ED:
	inc iy			;d1ed
	dec d			;d1ef
	jr nz,L_D1C4		;d1f0
L_D1F2:
	ld a,c			;d1f2
	or a			;d1f3
	jr nz,L_D1FE		;d1f4
	ld a,(0d5d2h)		;d1f6
	bit 2,a			;d1f9
	call nz,SND_RESET_ENV_RUIDO	;d1fb
L_D1FE:
	ld a,(0d5d3h)		;d1fe   ; Registro 6 del PSG = periodo base de ruido + su envolvente
	ld e,a			;d201
	ld a,(0d5d4h)		;d202
	add a,e			;d205
	ld (0d539h),a		;d206
	call SND_VUELCA_PSG		;d209   ; Unica llamada a 0xD43E en todo el binario: la sombra sale al chip una sola vez por vuelta del reproductor, aqui al final [SUSTITUYE]
	pop af			;d20c
	ret			;d20d
SND_RESET_ENV_VOL:		; Recarga las 2 fases de la envolvente de volumen desde el instrumento
	push ix			;d20e
	ld d,002h		;d210
L_D212:
	ld a,(ix+020h)		;d212
	ld (ix+00ch),a		;d215
	ld a,(ix+016h)		;d218
	ld (ix+00eh),a		;d21b
	inc ix			;d21e
	dec d			;d220
	jr nz,L_D212		;d221
	pop ix			;d223
	ret			;d225
SND_RESET_ENV_TONO:		; Recarga las 3 fases de la envolvente de tono desde el instrumento
	ld d,003h		;d226
	push ix			;d228
L_D22A:
	ld a,(ix+022h)		;d22a
	ld (ix+010h),a		;d22d
	ld a,(ix+018h)		;d230
	ld (ix+013h),a		;d233
	inc ix			;d236
	dec d			;d238
	jr nz,L_D22A		;d239
	pop ix			;d23b
	ret			;d23d
SND_RESET_ENV_RUIDO:		; Recarga las 2 fases de la envolvente global de ruido
	ld d,002h		;d23e
	push iy			;d240
	ld iy,0d5c8h		;d242
L_D246:
	ld a,(iy+008h)		;d246
	ld (iy+000h),a		;d249
	ld a,(iy+004h)		;d24c
	ld (iy+002h),a		;d24f
	inc iy			;d252
	dec d			;d254
	jr nz,L_D246		;d255
	pop iy			;d257
	ret			;d259

; ----------------------------------------------------------------------
; ############################################################
; LOS 15 COMANDOS DEL REPRODUCTOR (0x80..0x8E)
; ############################################################
; La tabla de saltos de 0xD513 tiene 15 entradas justas (la 16a ya
; es basura), y 0xD08D separa nota de comando con cp 080h.
; Verificados ademas decodificando con esta gramatica las 11
; frases y las 3 melodias: las 14 secuencias terminan EXACTAMENTE
; en el byte anterior a la siguiente, cada una con su 0x8D de
; retorno o su 0x82 / 0x8B final. Si el numero de operandos de un
; solo comando estuviera mal, todas se desalinearian.
; Contrastado tambien contra la RAM viva: en dump/running_full.bin
; (menu sonando) 0xD5D6 = 0xD794 y 0xD5D8 = 0xD8BB, justo detras
; de los 0x8C de 0xD792 y 0xD8B9.
; ----------------------------------------------------------------------
SND_CMD_80_VOLUMEN:		; 0x80 nn: volumen base del canal
	inc bc			;d25a
	ld a,(bc)		;d25b
	ld (ix+009h),a		;d25c
	inc bc			;d25f
	jp L_D08D		;d260
SND_CMD_83_DURACION:		; 0x83 nn: duracion de nota = nn * tempo
	inc bc			;d263
	ld a,(bc)		;d264
	ld de,(0d532h)		;d265   ; El tempo vigente esta en 0xD532
	ld d,000h		;d269
	call SND_MUL		;d26b
	ld (ix+006h),l		;d26e
	ld (ix+007h),h		;d271
	inc bc			;d274
	jp L_D08D		;d275
SND_CMD_81_MEZCLA:		; 0x81 nn: mezclador del canal, bit0 tono y bit3 ruido
	inc bc			;d278
	ld a,(bc)		;d279
	and 009h		;d27a   ; Solo valen los bits 0 y 3; el resto se tira
	ld (ix+008h),a		;d27c
	inc bc			;d27f
	jp L_D08D		;d280
SND_CMD_8B_FIN:		; 0x8B: fin del canal. Sin operando
	push ix			;d283
	pop hl			;d285
	xor a			;d286
	ld b,02eh		;d287   ; Borra los 46 bytes: con el volumen base a cero y el puntero nulo el canal queda mudo para siempre
L_D289:
	ld (hl),a		;d289
	inc hl			;d28a
	djnz L_D289		;d28b
	ld a,(0d531h)		;d28d
	ld hl,0d5d5h		;d290
	xor (hl)		;d293   ; Si este canal era el dueno del ruido, borra tambien la estructura global (pero no el periodo base de 0xD5D3)
	jp nz,L_D192		;d294
	ld hl,0d5c8h		;d297
	ld de,0d5c9h		;d29a
	ld bc,0000ah		;d29d
	ld (hl),a		;d2a0
	ldir			;d2a1
	inc de			;d2a3
	ld (de),a		;d2a4
	jp L_D192		;d2a5
SND_CMD_85_TEMPO:		; 0x85 nn: tempo. 0xD532 = 3000 / (nn*16)
	inc bc			;d2a8
	ld a,(bc)		;d2a9
	push bc			;d2aa
	ld de,00010h		;d2ab
	call SND_MUL		;d2ae
	ld bc,00bb8h		;d2b1   ; Dividendo 3000; el cociente son los ticks que dura una unidad de duracion
	push hl			;d2b4
	pop de			;d2b5
	call SND_DIV		;d2b6
	ld a,c			;d2b9
	ld (0d532h),a		;d2ba   ; Con nn = 0x64, que es lo que usa la musica del menu, sale 1 tick por unidad
	pop bc			;d2bd
	inc bc			;d2be
	jp L_D08D		;d2bf
SND_CMD_88_RUIDOPER:		; 0x88 nn: periodo base de ruido = nn and 0x1F, y reinicia su envolvente
	inc bc			;d2c2
	ld a,(bc)		;d2c3
	push af			;d2c4
	and 01fh		;d2c5   ; El generador de ruido del PSG solo tiene 5 bits de periodo
	ld (0d5d3h),a		;d2c7
	call SND_RESET_ENV_RUIDO		;d2ca
	pop af			;d2cd
	inc bc			;d2ce
	or a			;d2cf   ; Si el bit 7 del operando esta puesto sigue leyendo comandos; si no, el comando cuenta como golpe y dispara el evento. Asi se escriben percusiones sin tono
	jp m,L_D08D		;d2d0
	jp L_D0AF		;d2d3
SND_CMD_84_SILENCIO:		; 0x84: consume una duracion de nota con el canal callado. Sin operando
	inc bc			;d2d6   ; Salta directo a 0xD0C7, saltandose el mezclador: el canal se quedo mudo en 0xD07E
	jp L_D0C7		;d2d7
SND_CMD_82_BUCLE:		; 0x82: vuelve al principio de los datos del canal. Sin operando
	ld c,(ix+000h)		;d2da
	ld b,(ix+001h)		;d2dd
	ld (ix+002h),c		;d2e0
	ld (ix+003h),b		;d2e3
	jp L_D08D		;d2e6
SND_CMD_86_DURSUMA:		; 0x86 n b1..bn: duracion compuesta, suma de n valores por el tempo
	inc bc			;d2e9
	ld a,(bc)		;d2ea
	inc bc			;d2eb
	ld de,00000h		;d2ec
L_D2EF:
	push af			;d2ef
	ld a,(bc)		;d2f0
	push de			;d2f1
	ld de,(0d532h)		;d2f2
	ld d,000h		;d2f6
	call SND_MUL		;d2f8
	pop de			;d2fb
	add hl,de		;d2fc
	ex de,hl		;d2fd
	inc bc			;d2fe
	pop af			;d2ff
	dec a			;d300
	jr nz,L_D2EF		;d301
	ld (ix+006h),l		;d303
	ld (ix+007h),h		;d306
	jp L_D08D		;d309
SND_CMD_8A_REPETIR:		; 0x8A nn: activa la repeticion de envolventes. bit0 volumen, bit1 tono, bit2 ruido
	inc bc			;d30c
	ld a,(bc)		;d30d
	ld e,a			;d30e
	or (ix+02dh)		;d30f   ; Solo hace OR: los bits los quitan los comandos 0x87 y 0x89
	ld (ix+02dh),a		;d312
	ld a,(0d5d2h)		;d315   ; El operando entero cae tambien en la variable global del ruido, pero de ella solo se mira el bit 2 (en 0xD1F6)
	or e			;d318
	ld (0d5d2h),a		;d319
	inc bc			;d31c
	jp L_D08D		;d31d
SND_CMD_87_INSTRUM:		; 0x87 nn: carga el instrumento nn (15 bytes de 0xD5DF+nn*15) en +16..+24
	inc bc			;d320
	res 0,(ix+02dh)		;d321   ; Al cambiar de instrumento se quitan los dos bits de repeticion
	res 1,(ix+02dh)		;d325
	ld a,(bc)		;d329
	ld de,0000fh		;d32a
	call SND_MUL		;d32d
	ld de,0d5dfh		;d330
	add hl,de		;d333
	push ix			;d334
	ld d,00fh		;d336
L_D338:
	ld a,(hl)		;d338
	ld (ix+016h),a		;d339
	inc hl			;d33c
	inc ix			;d33d
	dec d			;d33f
	jp nz,L_D338		;d340
	pop ix			;d343
	inc bc			;d345
	ld (ix+00ch),000h	;d346   ; Y se ponen a cero los contadores de espera y los desplazamientos acumulados
	ld (ix+00dh),000h	;d34a
	ld (ix+010h),000h	;d34e
	ld (ix+011h),000h	;d352
	ld (ix+012h),000h	;d356
	ld (ix+02ah),000h	;d35a
	ld (ix+02bh),000h	;d35e
	ld (ix+02ch),000h	;d362
	jp L_D08D		;d366
SND_CMD_89_RUIDOENV:		; 0x89 nn: carga la envolvente de ruido nn (6 bytes de 0xD60C+nn*6) en la estructura global
	inc bc			;d369
	ld a,(0d5d2h)		;d36a
	res 2,a			;d36d   ; Cargar una envolvente nueva le quita la repeticion
	ld (0d5d2h),a		;d36f
	ld a,(bc)		;d372
	ld de,00006h		;d373
	call SND_MUL		;d376
	ld de,0d60ch		;d379
	add hl,de		;d37c
	ld iy,0d5c8h		;d37d
	ld (iy+000h),000h	;d381
	ld (iy+001h),000h	;d385
	ld d,006h		;d389
L_D38B:
	ld a,(hl)		;d38b
	ld (iy+004h),a		;d38c
	inc hl			;d38f
	inc iy			;d390
	dec d			;d392
	jr nz,L_D38B		;d393
	xor a			;d395
	ld (0d5d4h),a		;d396
	inc bc			;d399
	ld a,(0d531h)		;d39a   ; Apunta que canal se ha quedado con el generador de ruido
	ld (0d5d5h),a		;d39d
	jp L_D08D		;d3a0
SND_MIXER:		; Mete en el registro 7 los bits de tono y ruido de este canal
	push de			;d3a3
	cpl			;d3a4
	ld e,a			;d3a5
	ld d,009h		;d3a6   ; 0x09 = tono + ruido del canal 0; se desplaza tantas veces como canal sea
	ld a,(0d531h)		;d3a8
L_D3AB:
	dec a			;d3ab
	jp m,L_D3B6		;d3ac
	scf			;d3af
	rl e			;d3b0
	sla d			;d3b2
	jr L_D3AB		;d3b4
L_D3B6:
	ld a,(0d53ah)		;d3b6
	or d			;d3b9   ; Primero apaga los dos bits del canal y luego enciende los que pedia A
	and e			;d3ba
	ld (0d53ah),a		;d3bb
	pop de			;d3be
	ret			;d3bf
SND_CMD_8C_LLAMADA:		; 0x8C nn: llama a la frase nn de la tabla 0xD612, estilo GOSUB
	ld a,(0d531h)		;d3c0
	inc bc			;d3c3
	add a,a			;d3c4
	ld l,a			;d3c5
	ld h,000h		;d3c6
	ld a,(bc)		;d3c8
	inc bc			;d3c9
	ld de,0d5d6h		;d3ca
	add hl,de		;d3cd
	ld (hl),c		;d3ce   ; Guarda la direccion de retorno en 0xD5D6 + canal*2
	inc hl			;d3cf
	ld (hl),b		;d3d0
	ld hl,0d612h		;d3d1   ; Tabla de 11 punteros a frases. Solo hay un nivel: una frase no puede llamar a otra
	call SND_JUMPIDX		;d3d4
	ld b,h			;d3d7
	ld c,l			;d3d8
	jp L_D08D		;d3d9
SND_CMD_8D_RETORNO:		; 0x8D: vuelve de la frase. Sin operando
	ld a,(0d531h)		;d3dc
	add a,a			;d3df
	ld l,a			;d3e0
	ld h,000h		;d3e1
	ld de,0d5d6h		;d3e3
	add hl,de		;d3e6
	ld c,(hl)		;d3e7
	inc hl			;d3e8
	ld b,(hl)		;d3e9
	jp L_D08D		;d3ea
SND_CMD_8E_TRANSPON:		; 0x8E nn: transposicion del canal en semitonos, se suma al codigo de nota
	inc bc			;d3ed
	call SND_PTR_TRANSP		;d3ee
	ld a,(bc)		;d3f1
	inc bc			;d3f2
	ld (hl),a		;d3f3
	jp L_D08D		;d3f4
SND_PTR_TRANSP:		; HL = 0xD5DC + canal: la transposicion de este canal
	ld a,(0d531h)		;d3f7
	ld l,a			;d3fa
	ld h,000h		;d3fb
	ld de,0d5dch		;d3fd
	add hl,de		;d400
	ret			;d401
SND_MUL:		; Multiplica para calcular el offset de un canal
	ld hl,00000h		;d402   ; HL = A * DE por sumas y desplazamientos, preservando BC; si A es cero devuelve HL=0. La usan el offset de canal, la duracion de nota y el tempo
	and a			;d405
	ret z			;d406
	push bc			;d407
	ld b,008h		;d408
L_D40A:
	srl a			;d40a
	jr nc,L_D40F		;d40c
	add hl,de		;d40e
L_D40F:
	sla e			;d40f
	rl d			;d411
	djnz L_D40A		;d413
	pop bc			;d415
	ret			;d416
SND_DIV:		; Division de 16 bits: BC entre DE, cociente en BC
	push af			;d417
	ld hl,00000h		;d418
	ld a,b			;d41b
	ld b,010h		;d41c
L_D41E:
	rl c			;d41e
	rla			;d420
	adc hl,hl		;d421
	sbc hl,de		;d423
	jr nc,L_D428		;d425
	add hl,de		;d427
L_D428:
	ccf			;d428
	djnz L_D41E		;d429
	rl c			;d42b
	rla			;d42d
	ld b,a			;d42e
	pop af			;d42f
	ret			;d430
SND_JUMPIDX:		; HL = puntero nº A de la tabla que apunta HL
	push af			;d431
	add a,a			;d432   ; A*2 (los punteros son de 2 bytes)
	add a,l			;d433
	ld l,a			;d434
	jr nc,L_D438		;d435
	inc h			;d437
L_D438:
	ld a,(hl)		;d438
	inc hl			;d439
	ld h,(hl)		;d43a
	ld l,a			;d43b
	pop af			;d43c
	ret			;d43d
SND_VUELCA_PSG:		; Vuelca los 11 registros de 0xD533 al PSG por los puertos 0xA0/0xA1
	ld hl,0d533h		;d43e   ; Los unicos dos OUT a los puertos 0xA0/0xA1 de todo el binario estan aqui (0xD447 y 0xD44A), pero no son la unica via de escribir el PSG: el motor de efectos de 0xDB00 lo hace por la BIOS, con 39 llamadas a WRTPSG
	ld a,000h		;d441
	ld d,00bh		;d443
L_D445:
	push af			;d445
	ld c,(hl)		;d446
	out (0a0h),a		;d447
	ld a,c			;d449
	out (0a1h),a		;d44a
	pop af			;d44c
	inc a			;d44d
	inc hl			;d44e
	dec d			;d44f
	jr nz,L_D445		;d450
	ret			;d452

; ----------------------------------------------------------------------
; DATOS tabla_periodos: Tabla de periodos de nota del PSG: 96 palabras little-endian, estrictamente decrecientes, del indice 0 (periodo 3421) al 95 (periodo 14). Con el reloj REAL del PSG del MSX, que es 3579545/2 = 1789772,5 Hz, y f = reloj/(16*periodo), el indice 45 vale 254 = 440,4 Hz: la tabla esta afinada a LA4 = 440 Hz y el indice 0 es un DO de 32,70 Hz, o sea DO1. Cada octava es exactamente la mitad de periodo que la anterior redondeada, comprobadas las 84 parejas w[i+12] frente a w[i] sin una sola excepcion. Por debajo del indice 60 la desafinacion frente al temperamento igual no pasa de 4,2 centesimas; de ahi arriba el periodo entero se queda corto y llega a 37 centesimas en el indice 87, el peor de los 96. La indexa un unico sitio, 0xD0A2, y acaba justo donde empieza la tabla de comandos. [SUSTITUYE a la D 0xd453 anterior, que daba 65,4 Hz: estaba una octava alta por usar 3579545/16 en vez de 1789772,5/16]
;   0xd453..0xd513  (192 bytes)
; DATOS tabla_cmd_sonido: Tabla de saltos de los 15 comandos del reproductor (0x80..0x8E). A partir de 0xD531 ya son otros datos.
;   0xd513..0xd531  (30 bytes)
; DATOS snd_canal_actual: Canal que el reproductor esta procesando (0, 1 o 2). Lo escribe solo 0xD072, dentro del bucle de tres vueltas de 0xD060, y lo leen 0xD28D, 0xD39A, 0xD3A8, 0xD3C0, 0xD3DC y 0xD3F7 para saber sobre que canal actua cada comando. En la imagen de cinta trae un 02, pero da igual: lo primero que hace el bucle es reescribirlo. [SUSTITUYE a la D 0xd531 0xd533 psg_control, que se parte en dos]
;   0xd531..0xd532  (1 bytes)
; DATOS snd_ticks_unidad: Duracion en ticks de interrupcion de la unidad de tiempo, o sea el tempo ya convertido. Lo fija el comando 0x85 (0xD2A8) como 3000/(tempo*16) y lo leen los comandos 0x83 (0xD265) y 0x86 (0xD2F2), que multiplican por el la duracion escrita en la melodia. El 3000 es 50*60, coherente con un tempo en negras por minuto a 50 Hz y 16 unidades de duracion por negra (?). Los dos lectores hacen ld de,(0xD532), que se trae de propina 0xD533 en D, y lo tiran acto seguido con ld d,0.
;   0xd532..0xd533  (1 bytes)
; DATOS snd_regs_psg: Sombra en RAM de los 11 registros del PSG, R0 en 0xD533 y R10 en 0xD53D, en el mismo orden que el chip: R0-R5 periodos de tono A/B/C, R6 periodo de ruido, R7 mezclador y R8-R10 los tres volumenes. Verificada registro a registro: 0xD068 y 0xD06B reparten los punteros por canal, 0xD206 escribe R6, 0xD3A3-0xD3BB manipula R7 y 0xD43E la vuelca entera. Solo sale al chip una vez por vuelta de 0xD060, desde 0xD209. En la imagen de cinta esta todo a cero salvo 0xD53A = 0x3F, que es justo el mezclador con tono y ruido callados en los tres canales. [SUSTITUYE]
;   0xd533..0xd53e  (11 bytes)
; DATOS canales_psg: Estructuras de los 3 canales del PSG, 46 bytes cada una (0xD53E, 0xD56C, 0xD59A).
;   0xd53e..0xd5c8  (138 bytes)
; DATOS datos_psg: Tablas del reproductor PSG (periodos de nota, envolventes) (?)
;   0xd5c8..0xd760  (408 bytes)
; DATOS melodia_canal0: Datos de la melodia del menu, canal 0
;   0xd760..0xd891  (305 bytes)
; DATOS melodia_canal1: Datos de la melodia del menu, canal 1
;   0xd891..0xd8f8  (103 bytes)
; DATOS melodia_canal2: Datos de la melodia del menu, canal 2
;   0xd8f8..0xda00  (264 bytes)
; ----------------------------------------------------------------------
	defb 05dh,00dh,09dh,00ch,0e7h,00bh,03ch,00bh,09bh,00ah,003h,00ah,073h,009h,0ebh,008h	; d453  ].....<.....s...
	defb 06bh,008h,0f2h,007h,080h,007h,014h,007h,0aeh,006h,04eh,006h,0f4h,005h,09eh,005h	; d463  k.........N.....
	defb 04dh,005h,001h,005h,0b9h,004h,075h,004h,035h,004h,0f9h,003h,0c0h,003h,08ah,003h	; d473  M.....u.5.......
	defb 057h,003h,027h,003h,0fah,002h,0cfh,002h,0a7h,002h,081h,002h,05dh,002h,03bh,002h	; d483  W.'.........].;.
	defb 01bh,002h,0fch,001h,0e0h,001h,0c5h,001h,0ach,001h,094h,001h,07dh,001h,068h,001h	; d493  ............}.h.
	defb 053h,001h,040h,001h,02eh,001h,01dh,001h,00dh,001h,0feh,000h,0f0h,000h,0e2h,000h	; d4a3  S.@.............
	defb 0d6h,000h,0cah,000h,0beh,000h,0b4h,000h,0aah,000h,0a0h,000h,097h,000h,08fh,000h	; d4b3  ................
	defb 087h,000h,07fh,000h,078h,000h,071h,000h,06bh,000h,065h,000h,05fh,000h,05ah,000h	; d4c3  ....x.q.k.e._.Z.
	defb 055h,000h,050h,000h,04ch,000h,047h,000h,043h,000h,040h,000h,03ch,000h,039h,000h	; d4d3  U.P.L.G.C.@.<.9.
	defb 035h,000h,032h,000h,030h,000h,02dh,000h,02ah,000h,028h,000h,026h,000h,024h,000h	; d4e3  5.2.0.-.*.(.&.$.
	defb 022h,000h,020h,000h,01eh,000h,01ch,000h,01bh,000h,019h,000h,018h,000h,016h,000h	; d4f3  ". .............
	defb 015h,000h,014h,000h,013h,000h,012h,000h,011h,000h,010h,000h,00fh,000h,00eh,000h	; d503  ................
	defb 05ah,0d2h,078h,0d2h,0dah,0d2h,063h,0d2h,0d6h,0d2h,0a8h,0d2h,0e9h,0d2h,020h,0d3h	; d513  Z.x...c....... .
	defb 0c2h,0d2h,069h,0d3h,00ch,0d3h,083h,0d2h,0c0h,0d3h,0dch,0d3h,0edh,0d3h,002h,001h	; d523  ..i.............
	defb 000h,000h,000h,000h,000h,000h,000h,03fh,000h,000h,000h,000h,000h,000h,000h,000h	; d533  .......?........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; d543  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; d553  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; d563  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; d573  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; d583  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; d593  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; d5a3  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; d5b3  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00bh	; d5c3  ................
	defb 000h,000h,000h,00ch,0d8h,0e3h,0d8h,000h,000h,000h,018h,000h,004h,00fh,000h,000h	; d5d3  ................
	defb 000h,001h,0ffh,000h,000h,000h,005h,005h,000h,000h,000h,001h,00fh,000h,000h,000h	; d5e3  ................
	defb 007h,0ffh,000h,000h,000h,000h,009h,000h,000h,000h,001h,001h,001h,001h,000h,001h	; d5f3  ................
	defb 0ffh,002h,0feh,000h,002h,002h,002h,002h,000h,001h,003h,00fh,0fbh,000h,001h,028h	; d603  ...............(
	defb 0d6h,03ch,0d6h,05dh,0d6h,07ch,0d6h,08fh,0d6h,0afh,0d6h,0e0h,0d6h,0fch,0d6h,00ch	; d613  .<.].|..........
	defb 0d7h,01ch,0d7h,029h,0d7h,080h,000h,087h,001h,08ah,000h,083h,014h,021h,087h,000h	; d623  ...).........!..
	defb 080h,006h,027h,080h,000h,087h,001h,028h,08dh,083h,01eh,087h,000h,080h,006h,039h	; d633  ..'....(.......9
	defb 080h,000h,087h,001h,083h,00ah,038h,037h,036h,083h,01eh,087h,000h,080h,006h,035h	; d643  ......876......5
	defb 080h,000h,087h,001h,083h,00ah,034h,033h,032h,08dh,08eh,00ch,087h,001h,080h,000h	; d653  ......432.......
	defb 083h,00ah,024h,023h,024h,025h,024h,023h,083h,028h,087h,000h,080h,006h,024h,080h	; d663  ..$#$%$#.(....$.
	defb 000h,087h,001h,083h,014h,028h,08eh,000h,08dh,080h,000h,087h,001h,083h,014h,01ch	; d673  .....(..........
	defb 020h,028h,01ch,020h,028h,021h,01ch,018h,015h,018h,030h,08dh,080h,006h,087h,000h	; d683   (. (!....0.....
	defb 083h,01eh,02fh,083h,00ah,080h,000h,087h,001h,02eh,02fh,030h,02fh,028h,02ah,02ch	; d693  ../......./0/(*,
	defb 02dh,02fh,083h,078h,080h,009h,087h,002h,08ah,002h,02dh,08dh,080h,000h,087h,001h	; d6a3  -/.x......-.....
	defb 083h,00ah,02dh,034h,030h,034h,02fh,034h,02dh,039h,038h,039h,03bh,034h,035h,039h	; d6b3  ..-404/4-989;459
	defb 037h,035h,037h,039h,032h,035h,034h,032h,034h,035h,02fh,02ch,02dh,02fh,034h,028h	; d6c3  7579254245/,-/4(
	defb 023h,02ch,02fh,032h,02fh,02ch,02dh,02ch,02dh,02fh,030h,084h,08dh,087h,002h,080h	; d6d3  #,/2/,-,-/0.....
	defb 009h,08ah,00ah,083h,028h,028h,083h,014h,02dh,083h,028h,02ch,083h,014h,028h,024h	; d6e3  ....((..-.(,..($
	defb 028h,02dh,083h,028h,02ch,083h,014h,028h,08dh,083h,028h,029h,083h,014h,02dh,083h	; d6f3  (-.(,..(..()..-.
	defb 028h,02ch,083h,014h,029h,083h,078h,028h,08dh,083h,028h,029h,083h,014h,02dh,083h	; d703  (,..).x(..()..-.
	defb 028h,02ch,083h,014h,028h,083h,078h,02dh,08dh,087h,001h,080h,000h,083h,008h,021h	; d713  (,..(.x-.......!
	defb 02dh,02bh,02dh,026h,028h,08dh,080h,00fh,087h,001h,083h,008h,02dh,084h,02dh,02ch	; d723  -+-&(.......-.-,
	defb 02dh,084h,02dh,02ch,02dh,02fh,030h,084h,029h,028h,029h,02bh,02dh,030h,029h,035h	; d733  -.-,-/0.)()+-0)5
	defb 034h,033h,032h,031h,02bh,084h,037h,036h,037h,084h,030h,032h,034h,037h,036h,037h	; d743  4321+.767.024767
	defb 02bh,084h,02bh,02ah,02bh,02dh,02fh,084h,02bh,084h,02ch,084h,08dh,085h,064h,087h	; d753  +.+*+-/.+.,...d.
	defb 000h,081h,001h,080h,000h,08eh,000h,08ch,000h,08ch,000h,08eh,0fch,08ch,000h,08ch	; d763  ................
	defb 000h,08eh,000h,08ch,000h,08ch,000h,08eh,0fch,08ch,000h,08ch,000h,08eh,000h,08ch	; d773  ................
	defb 000h,08ch,000h,08eh,0fch,08ch,000h,08ch,000h,08eh,000h,08ch,003h,08eh,000h,08ch	; d783  ................
	defb 000h,08ch,000h,08eh,0fch,08ch,000h,08ch,000h,08eh,000h,08ch,000h,08ch,000h,08eh	; d793  ................
	defb 0fch,08ch,000h,08ch,000h,08eh,000h,08ch,000h,08ch,000h,08eh,0fch,08ch,000h,08ch	; d7a3  ................
	defb 000h,08eh,000h,08ch,003h,08eh,000h,08ch,000h,08ch,000h,08eh,0f9h,08ch,000h,08eh	; d7b3  ................
	defb 0fbh,08ch,000h,08ch,000h,08ch,000h,08eh,000h,08ch,000h,08ch,000h,08ch,000h,08eh	; d7c3  ................
	defb 0f9h,08ch,000h,08eh,0fbh,08ch,000h,08ch,000h,08ch,000h,08eh,000h,08ch,000h,08ch	; d7d3  ................
	defb 000h,08eh,0fbh,08ch,000h,08eh,000h,08ch,000h,08eh,0fbh,08ch,000h,08eh,0f9h,08ch	; d7e3  ................
	defb 000h,08eh,0fbh,08ch,000h,08eh,000h,08ch,000h,08eh,0fbh,08ch,000h,08eh,000h,08ch	; d7f3  ................
	defb 000h,08eh,0fbh,08ch,000h,08eh,000h,08ch,000h,08eh,0fbh,08ch,000h,08eh,0f9h,08ch	; d803  ................
	defb 000h,08eh,0fbh,08ch,000h,08eh,000h,08ch,000h,08eh,0fbh,08ch,000h,08eh,000h,08ch	; d813  ................
	defb 000h,08eh,0fbh,08ch,000h,08eh,000h,08ch,000h,08eh,0fbh,08ch,000h,08eh,0f9h,08ch	; d823  ................
	defb 000h,08eh,0fbh,08ch,000h,08eh,000h,08ch,000h,08eh,0fbh,08ch,000h,08eh,000h,08ch	; d833  ................
	defb 000h,08eh,0fbh,08ch,000h,08eh,000h,08ch,000h,08eh,0fbh,08ch,000h,08eh,0f9h,08ch	; d843  ................
	defb 000h,08eh,0fbh,08ch,000h,08eh,000h,08ch,000h,08eh,0fbh,08ch,000h,08eh,000h,08ch	; d853  ................
	defb 009h,08ch,009h,08eh,0fch,08ch,009h,08ch,009h,08eh,0f7h,08ch,009h,08ch,009h,08eh	; d863  ................
	defb 0feh,08ch,009h,08ch,009h,08eh,000h,08ch,009h,08ch,009h,08eh,0fch,08ch,009h,08ch	; d873  ................
	defb 009h,08eh,0f7h,08ch,009h,08ch,009h,08eh,0feh,08ch,009h,08ch,009h,082h,087h,001h	; d883  ................
	defb 081h,001h,08ah,001h,080h,000h,08eh,000h,08ch,001h,08ch,002h,08ch,001h,080h,00ah	; d893  ................
	defb 087h,002h,08ah,002h,083h,064h,033h,08ah,000h,080h,000h,087h,001h,083h,014h,034h	; d8a3  .....d3........4
	defb 08ch,001h,08ch,002h,08ch,004h,08ch,001h,08ch,002h,08ch,001h,080h,00ah,087h,002h	; d8b3  ................
	defb 08ah,002h,083h,064h,033h,08ah,000h,080h,000h,087h,001h,083h,014h,034h,08ch,001h	; d8c3  ...d3........4..
	defb 08ch,002h,08ch,004h,08ch,005h,08ch,005h,08eh,018h,08ch,006h,08ch,007h,08ch,006h	; d8d3  ................
	defb 08ch,008h,08eh,00ch,08ch,006h,08ch,007h,08ch,006h,08ch,008h,08eh,00ch,08ch,00ah	; d8e3  ................
	defb 08eh,018h,08ch,00ah,082h,087h,000h,081h,001h,080h,00dh,08bh,000h,000h,0ffh,000h	; d8f3  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d903  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d913  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d923  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d933  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d943  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d953  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d963  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d973  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d983  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d993  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d9a3  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d9b3  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d9c3  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d9d3  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h	; d9e3  ................
	defb 0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,000h,000h,000h,000h,000h	; d9f3  .............

; ======================================================================
; CODIGO 0xda00..0xda5c  (92 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; MENU PRINCIPAL: suena la musica y se espera a que pulsen
; ############################################################
; Esta es la pantalla que se ve tras el logo de Topo y la
; portada: el texto del viejo monje y los creditos
; "LUIGILOPEZ '88 - MUSICA:GOMINOLAS".
; ----------------------------------------------------------------------
MENU_PRINCIPAL:		; Pantalla de presentacion con musica; sale al pulsar disparo
	di			;da00
	ld a,(0fd9fh)		;da01   ; Guarda el hook H.TIMI original para poder restaurarlo al salir
	ld (0d9fbh),a		;da04
	ld hl,(0fda0h)		;da07
	ld (0d9fch),hl		;da0a
	ld a,0c3h		;da0d   ; Escribe un JP 0xD000 sobre el hook: engancha la interrupcion
	ld (0fd9fh),a		;da0f
	ld hl,0d000h		;da12
	ld (0fda0h),hl		;da15
	ld a,000h		;da18   ; Canal 0 <- melodia de 0xD760
	ld de,0d760h		;da1a
	call SND_SET_CANAL		;da1d
	inc a			;da20
	ld de,0d891h		;da21   ; Canal 1 <- melodia de 0xD891
	call SND_SET_CANAL		;da24
	inc a			;da27
	ld de,0d8f8h		;da28   ; Canal 2 <- melodia de 0xD8F8
	call SND_SET_CANAL		;da2b
L_DA2E:
	ei			;da2e   ; Espera un frame (la IRQ va avanzando la musica mientras tanto)
	halt			;da2f
	di			;da30
	ld a,000h		;da31
	call 000d8h		;da33   ; BIOS GTTRIG - Returns current trigger status | GTTRIG: lee el gatillo (barra espaciadora o boton del joystick)
	cp 000h			;da36
	jr z,L_DA2E		;da38   ; Si no han pulsado, sigue sonando la musica
	nop			;da3a
	ld a,000h		;da3b   ; Han pulsado: puntero nulo a los 3 canales = callar la musica
	ld de,00000h		;da3d
	call SND_SET_CANAL		;da40
	inc a			;da43
	call SND_SET_CANAL		;da44
	inc a			;da47
	call SND_SET_CANAL		;da48
	ei			;da4b
	halt			;da4c
	di			;da4d
	ld a,(0d9fbh)		;da4e   ; Devuelve el hook H.TIMI a como estaba
	ld (0fd9fh),a		;da51
	ld hl,(0d9fch)		;da54
	ld (0fda0h),hl		;da57
	ei			;da5a
	ret			;da5b

; ----------------------------------------------------------------------
; DATOS relleno_00ff: 36 bytes de 00 FF alternado, sin una sola desviacion. Es el mismo patron exacto que ocupa otras zonas no inicializadas: 0xD900-0xD9FA (250 bytes, 0 desviaciones, justo detras de la melodia del canal 2) y el buffer de mapa 0x7D82-0x7F80 (510 bytes, 0,2%). Sirve de huella para reconocer los demas huecos. [SUSTITUYE a la D 0xDA5C 0xDB00 muerto_DA5C, que queda repartida entre esta y la siguiente]
;   0xda5c..0xda80  (36 bytes)
; DATOS ram_sin_iniciar: 128 bytes del mismo patron 00/FF pero con bits sueltos cambiados: 18,9% de bits desviados del ideal. Aqui los bytes bajos solo toman siete valores (00 04 14 40 44 54 74) y los altos trece (ff fb fc f5 fa eb de db ca bf bb ba aa); los bits que se desvian son sobre todo el 2, el 4 y el 6 (75, 28 y 61 cambios, frente a 2, 3 y 4 en los bits 1, 3 y 7). Mismo tipo de patron, con porcentajes parecidos, en la zona de pila 0x8FA0-0x9000 (15,5%) y en los huecos 0x8CEB-0x8E00 (31,6%) y 0x8ED5-0x8F00 (23,5%), aunque OJO: ahi los bits que se desvian no son los mismos (la pila cambia sobre todo los bits 0, 2 y 4 y deja el 6 casi intacto), asi que no es 'exactamente el mismo aspecto'. No admite ninguna lectura coherente como codigo, texto con la fuente del juego, grafico ni musica.
;   0xda80..0xdb00  (128 bytes)
; ----------------------------------------------------------------------

; ----------------------------------------------------------------------
; ############################################################
; HUECO ENTRE EL MENU Y EL MOTOR DE EFECTOS: ESPACIO MUERTO
; ############################################################
; 164 bytes que no son codigo ni datos. El menu termina limpio en
; el RET de 0xDA5B y la rutina siguiente arranca en 0xDB00, que es
; frontera de pagina.
; VERIFICADO con partida real en openMSX (savestate tempt_boot,
; 120 s, watchpoints de lectura y escritura sobre todo el rango y
; una condicion sobre PC): 0 lecturas, 0 escrituras, 0 ejecuciones.
; La prueba no estaba muerta: el control de la misma tirada dio
; 5861 lecturas de 0xDDAB desde 0xDB00, 5861 escrituras desde
; 0xDB04, y 5861 lecturas de 0xDDAC-0xDDB3 desde cada uno de los
; nueve manejadores (0xDB07, 0xDB64, 0xDBA5, 0xDBBA, 0xDC09,
; 0xDC61, 0xDCA0, 0xDCF1, 0xDD42) mas 8 escrituras desde el LDIR
; de 0x80A2. PC al terminar: 0x811F, dentro del bucle de juego.
; Tampoco hay referencias estaticas: el listado no contiene ni un
; operando 0xDA5C..0xDAFF. Las apariciones de esos bytes en el
; binario son casualidades a caballo de dos instrucciones (0xD08F
; es el 0x80 de un 'cp 080h', 0x8A93 el 0xDA de un 'call 087dah')
; o caen en los mapas o en el codigo muerto de 0xCD83.
; AVISO para no equivocarse: 0xDAC0 cae aqui dentro y es de donde
; SLOTS copia 100 bytes a 0xDEA8, pero esa copia se hace ANTES de
; cargar el juego, asi que estos bytes del binario no llegan nunca
; al mecanismo de parcheo.
; ----------------------------------------------------------------------
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; da5c  ................
	defb 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh	; da6c  ................
	defb 000h,0ffh,000h,0ffh,000h,0f5h,0ffh,0fch,0deh,074h,0ffh,074h,0ffh,074h,0ffh,074h	; da7c  .........t.t.t.t
	defb 0ffh,054h,0ffh,054h,0ffh,054h,0ffh,044h,0ffh,054h,0ffh,044h,0ffh,044h,0ffh,054h	; da8c  .T.T.T.D.T.D.D.T
	defb 0ffh,044h,0ffh,044h,0ffh,040h,0ffh,044h,0ffh,044h,0ffh,044h,0fbh,004h,0fbh,044h	; da9c  .D.D.@.D.D.D...D
	defb 0fbh,044h,0fbh,044h,0fbh,044h,0bbh,004h,0fbh,044h,0bbh,044h,0bbh,004h,0bbh,004h	; daac  .D.D.D...D.D....
	defb 0ebh,004h,0aah,054h,0ffh,054h,0ffh,054h,0ffh,074h,0ffh,074h,0ffh,044h,0ffh,054h	; dabc  ...T.T.T.t.t.D.T
	defb 0ffh,054h,0ffh,054h,0ffh,054h,0ffh,044h,0ffh,054h,0fbh,044h,0fbh,044h,0fbh,044h	; dacc  .T.T.T.D.T.D.D.D
	defb 0fbh,044h,0ffh,054h,0ffh,044h,0ffh,040h,0ffh,004h,0ffh,000h,0ffh,000h,0ffh,040h	; dadc  .D.T.D.@.......@
	defb 0ffh,000h,0ffh,040h,0ffh,040h,0fah,000h,0ffh,044h,0bfh,000h,0dbh,040h,0cah,044h	; daec  ...@.@...D...@.D
	defb 0bah,014h,0bbh,0ffh	; dafc  ....

; ======================================================================
; CODIGO 0xdb00..0xdda8  (680 bytes)
; ======================================================================



; ----------------------------------------------------------------------
; ############################################################
; MOTOR DE EFECTOS DE SONIDO: una pasada por interrupcion
; ############################################################
; CORRIGE la suposicion anterior de que esto volcaba sprites o
; tocaba el VDP. En los 680 bytes del bloque las unicas llamadas
; que existen son 39 a WRTPSG (0x0093) y 19 a RDPSG (0x0096); no
; hay ni una a la BIOS de video, ni un OUT, ni una referencia a
; VRAM. El bloque acaba en el RET de 0xDDA7.
;
; Lo llaman cuatro sitios, siempre justo detras de un halt: el
; bucle principal en 0x811B y 0x811F, y el bucle de la animacion
; de muerte en 0x84B4 y 0x84B8. O sea, corre una vez por frame.
;
; Durante la partida el reproductor tipo tracker de 0xD000 NO
; corre: a 0xDA00 (menu) solo se llega desde 0x80C5, y al salir
; 0xDA4E devuelve el hook H.TIMI a como estaba.
; Verificado en los volcados de RAM de openMSX:
; dump/running_full.bin  (menu)    0xFD9F = C3 00 D0, 0xDDAB = 00
; dump/pcsample_full.bin (partida) 0xFD9F = C9,       0xDDAB = B3
; dump/scr25.ram         (partida) 0xFD9F = C9,       0xDDAB = 16
; dump/poketest.ram      (partida) 0xFD9F = C9,       0xDDAB = AD
; O sea: en el menu suena el tracker, en la partida solo esto.
;
; Ocho efectos, uno por byte de 0xDDAC..0xDDB3. Cada byte es a la
; vez el 'esta sonando' y el contador de frames que le quedan. Se
; recorren siempre en el mismo orden, asi que si dos comparten
; canal manda el ultimo. Se programan los registros 0,1,3,4,5,6,
; 7,8,9 y 10 del PSG; el registro 2 (byte bajo del tono B) no se
; escribe NUNCA, ni los 11..13 (envolvente por hardware). El
; registro 2 vale 0 en partida: el menu, al apagar los canales en
; 0xDA3B, deja toda la sombra 0xD533..0xD53D a cero salvo el 7.
; OJO al leer los periodos: los registros 1, 3 y 5 del PSG solo
; tienen 4 bits utiles, los otros cuatro se pierden.
; ----------------------------------------------------------------------
SFX_FRAME:		; Motor de efectos de sonido; una pasada por frame
	ld a,(0ddabh)		;db00   ; Contador de frames libre; solo se incrementa, nunca se reinicia. Los efectos lo usan para dividir la frecuencia
	inc a			;db03
	ld (0ddabh),a		;db04
L_DB07:
	ld a,(0ddach)		;db07   ; EFECTO 1 - PASO (canal A). 0 = apagado
L_DB0A:
	cp 000h			;db0a
	jp z,L_DB64		;db0c
	ld a,(0ddabh)		;db0f
	and 007h		;db12   ; El paso solo suena en 1 de cada 8 frames: de ahi el 'toc' seco
	cp 004h			;db14
	jp nz,L_DB3E		;db16
	ld a,007h		;db19
	call 00096h		;db1b   ; BIOS RDPSG - Reads value from PSG-register
	and 0feh		;db1e   ; Bit 0 a cero en el registro 7: habilita el TONO del canal A
	ld e,a			;db20
	ld a,007h		;db21
	call 00093h		;db23   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,00bh		;db26   ; Volumen 11 en el canal A
	ld a,008h		;db28
	call 00093h		;db2a   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,010h		;db2d   ; Registro 1 (afinacion gruesa de A) = 0x10, pero el PSG solo usa 4 bits: se queda en 0
	ld a,001h		;db2f
	call 00093h		;db31   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,064h		;db34   ; Con el 0x10 truncado el periodo real es 0x064 = 100, unos 2,2 kHz: un tic corto y agudo
	ld a,000h		;db36
	call 00093h		;db38   ; BIOS WRTPSG - Writes data to PSG-register
	jp L_DB4B		;db3b
L_DB3E:
	ld a,007h		;db3e
	call 00096h		;db40   ; BIOS RDPSG - Reads value from PSG-register
	or 001h			;db43   ; Los otros 7 frames de cada 8 el canal A calla
	ld e,a			;db45
	ld a,007h		;db46
	call 00093h		;db48   ; BIOS WRTPSG - Writes data to PSG-register
L_DB4B:
	ld a,(0ddach)		;db4b   ; Gasta un frame del efecto
	dec a			;db4e
	ld (0ddach),a		;db4f
	cp 000h			;db52
	jp nz,L_DB64		;db54
	ld a,007h		;db57
	call 00096h		;db59   ; BIOS RDPSG - Reads value from PSG-register
	or 001h			;db5c   ; Al agotarse deja el tono A apagado
	ld e,a			;db5e
	ld a,007h		;db5f
	call 00093h		;db61   ; BIOS WRTPSG - Writes data to PSG-register
L_DB64:
	ld a,(0ddadh)		;db64   ; EFECTO 2 - SALTO / CAIDA (canal A)
	cp 000h			;db67
	jp z,L_DBA5		;db69
	ld a,007h		;db6c
	call 00096h		;db6e   ; BIOS RDPSG - Reads value from PSG-register
	res 0,a			;db71   ; Habilita el tono del canal A
	ld e,a			;db73
	ld a,007h		;db74
	call 00093h		;db76   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,00bh		;db79   ; Volumen 11
	ld a,008h		;db7b
	call 00093h		;db7d   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(08f0ah)		;db80   ; Y del jugador: el tono del salto depende de la altura a la que este
	ld d,000h		;db83
	ld e,a			;db85
	sla e			;db86   ; DE = Y*8 con tres desplazamientos; como Y cabe en un byte, el byte alto nunca pasa de 7 y no lo trunca el PSG
	rl d			;db88
	sla e			;db8a
	rl d			;db8c
	sla e			;db8e
	rl d			;db90
	ld a,000h		;db92   ; Periodo del canal A = Y*8: cuanto mas abajo, mas grave
	call 00093h		;db94   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,d			;db97
	ld a,001h		;db98
	call 00093h		;db9a   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,000h		;db9d   ; Efecto de un solo frame: se autoborra. Mientras se salta, 0x8141 lo repone cada vuelta
	ld (0ddadh),a		;db9f
	jp L_DBBA		;dba2
L_DBA5:
	ld a,(0ddach)		;dba5   ; Solo apaga el tono A si el efecto de paso tampoco esta sonando
	cp 000h			;dba8
L_DBAA:
	jp nz,L_DBBA		;dbaa
L_DBAD:
	ld a,007h		;dbad
	call 00096h		;dbaf   ; BIOS RDPSG - Reads value from PSG-register
	or 001h			;dbb2
	ld e,a			;dbb4
	ld a,007h		;dbb5
	call 00093h		;dbb7   ; BIOS WRTPSG - Writes data to PSG-register
L_DBBA:
	ld a,(0ddaeh)		;dbba   ; EFECTO 3 - DISPARO (canal B)
L_DBBD:
	cp 000h			;dbbd
L_DBBF:
	jp z,L_DC09		;dbbf
	ld a,007h		;dbc2
	call 00096h		;dbc4   ; BIOS RDPSG - Reads value from PSG-register
	and 0fdh		;dbc7   ; Bit 1 a cero en el registro 7: habilita el TONO del canal B
	ld e,a			;dbc9
	ld a,007h		;dbca
	call 00093h		;dbcc   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddaeh)		;dbcf   ; El complemento del contador: segun baja el contador sube el periodo, o sea barrido descendente
	cpl			;dbd2
	add a,000h		;dbd3
	ld e,a			;dbd5
	ld a,003h		;dbd6   ; Byte alto del periodo del canal B. El byte bajo (registro 2) no se toca en toda la rutina y vale 0 en partida
	call 00093h		;dbd8   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddaeh)		;dbdb   ; Los ultimos 6 frames bajan el volumen de 11 a 6: desvanecido final
	cp 007h			;dbde
	jp nc,L_DBE8		;dbe0
	add a,005h		;dbe3
	jp L_DBEA		;dbe5
L_DBE8:
	ld a,00bh		;dbe8
L_DBEA:
	ld e,a			;dbea
	ld a,009h		;dbeb
	call 00093h		;dbed   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddaeh)		;dbf0   ; 15 frames de duracion (el valor que pone 0x88EF)
	dec a			;dbf3
	ld (0ddaeh),a		;dbf4
	cp 000h			;dbf7
	jp nz,L_DC09		;dbf9
	ld a,007h		;dbfc   ; Apaga el tono del canal B
	call 00096h		;dbfe   ; BIOS RDPSG - Reads value from PSG-register
	or 002h			;dc01
	ld e,a			;dc03
	ld a,007h		;dc04
	call 00093h		;dc06   ; BIOS WRTPSG - Writes data to PSG-register
L_DC09:
	ld a,(0ddafh)		;dc09   ; EFECTO 4 - MUERTE (canal B). Lo disparan 0x8499 (muere el jugador) y 0x87F0 (muere una entidad de 0x8F20)
	cp 000h			;dc0c
	jp z,L_DC61		;dc0e
	bit 0,a			;dc11   ; Trino: suena un frame si y otro no, segun la paridad del contador
	jp nz,L_DC3B		;dc13
	ld a,007h		;dc16
	call 00096h		;dc18   ; BIOS RDPSG - Reads value from PSG-register
	res 1,a			;dc1b
	ld e,a			;dc1d
	ld a,007h		;dc1e
	call 00093h		;dc20   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddafh)		;dc23   ; Complemento y mitad: el periodo va bajando, el trino sube de tono
	cpl			;dc26
	srl a			;dc27
	add a,000h		;dc29
	ld e,a			;dc2b
	ld a,003h		;dc2c
	call 00093h		;dc2e   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,00bh		;dc31
	ld a,009h		;dc33
	call 00093h		;dc35   ; BIOS WRTPSG - Writes data to PSG-register
	jp L_DC48		;dc38
L_DC3B:
	ld a,007h		;dc3b
	call 00096h		;dc3d   ; BIOS RDPSG - Reads value from PSG-register
	set 1,a			;dc40
	ld e,a			;dc42
	ld a,007h		;dc43
	call 00093h		;dc45   ; BIOS WRTPSG - Writes data to PSG-register
L_DC48:
	ld a,(0ddafh)		;dc48   ; Este contador cuenta hacia ARRIBA: con 0xEC (0x8499) son 20 frames
	inc a			;dc4b
	ld (0ddafh),a		;dc4c
	cp 000h			;dc4f
	jp nz,L_DC61		;dc51
	ld a,007h		;dc54
	call 00096h		;dc56   ; BIOS RDPSG - Reads value from PSG-register
	set 1,a			;dc59
	ld e,a			;dc5b
	ld a,007h		;dc5c
	call 00093h		;dc5e   ; BIOS WRTPSG - Writes data to PSG-register
L_DC61:
	ld a,(0ddb0h)		;dc61   ; EFECTO 5 - IMPACTO DEL DISPARO (canal C)
L_DC64:
	cp 000h			;dc64
L_DC66:
	jp z,L_DCA0		;dc66
	ld a,007h		;dc69
	call 00096h		;dc6b   ; BIOS RDPSG - Reads value from PSG-register
	res 2,a			;dc6e
	ld e,a			;dc70
	ld a,007h		;dc71
	call 00093h		;dc73   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,00bh		;dc76
	ld a,00ah		;dc78
	call 00093h		;dc7a   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddb0h)		;dc7d   ; Byte alto del periodo del canal C = contador; con 2 (0x89BE) dura uno o dos frames (?), ver el sbc de abajo
	ld e,a			;dc80
	ld a,005h		;dc81
	call 00093h		;dc83   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddb0h)		;dc86   ; Decrementa con sbc y no con sub: el acarreo es el que deje WRTPSG, o sea puede restar 1 o 2 (?)
	sbc a,001h		;dc89
	ld (0ddb0h),a		;dc8b
	cp 000h			;dc8e
	jp nz,L_DCA0		;dc90
	ld a,007h		;dc93
	call 00096h		;dc95   ; BIOS RDPSG - Reads value from PSG-register
	set 2,a			;dc98
	ld e,a			;dc9a
	ld a,007h		;dc9b
	call 00093h		;dc9d   ; BIOS WRTPSG - Writes data to PSG-register
L_DCA0:
	ld a,(0ddb1h)		;dca0   ; EFECTO 6 - OBJETO DESTRUIDO (?) (canal C); lo dispara 0x89DD cuando el objetivo agota sus impactos
	cp 000h			;dca3
	jp z,L_DCF1		;dca5
	ld a,007h		;dca8
	call 00096h		;dcaa   ; BIOS RDPSG - Reads value from PSG-register
	res 2,a			;dcad
	ld e,a			;dcaf
	ld a,007h		;dcb0
	call 00093h		;dcb2   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,001h		;dcb5   ; Periodo fijo 0x0101 en el canal C: unos 870 Hz
	ld a,004h		;dcb7
	call 00093h		;dcb9   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,001h		;dcbc
	ld a,005h		;dcbe
	call 00093h		;dcc0   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddb1h)		;dcc3   ; Volumen = contador/2; si llegase a 15 o mas se fijaria en 12, pero arrancando en 28 el maximo real es 14. Se va apagando solo
	srl a			;dcc6
	cp 00fh			;dcc8
	jp nc,L_DCD0		;dcca
	jp L_DCD2		;dccd
L_DCD0:
	ld a,00ch		;dcd0
L_DCD2:
	ld e,a			;dcd2
	ld a,00ah		;dcd3
	call 00093h		;dcd5   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddb1h)		;dcd8   ; Con 0x1C (0x89DD) son 28 frames
	dec a			;dcdb
	ld (0ddb1h),a		;dcdc
	cp 000h			;dcdf
	jp nz,L_DCF1		;dce1
	ld a,007h		;dce4
	call 00096h		;dce6   ; BIOS RDPSG - Reads value from PSG-register
	set 2,a			;dce9
	ld e,a			;dceb
	ld a,007h		;dcec
	call 00093h		;dcee   ; BIOS WRTPSG - Writes data to PSG-register
L_DCF1:
	ld a,(0ddb2h)		;dcf1   ; EFECTO 7 - RECOGER OBJETO (canal C). Lo usan los cuatro objetos: 0x8482, 0x8520, 0x853D y 0x8558
L_DCF4:
	cp 000h			;dcf4
	jp z,L_DD42		;dcf6
	ld a,007h		;dcf9
	call 00096h		;dcfb   ; BIOS RDPSG - Reads value from PSG-register
	res 2,a			;dcfe
	ld e,a			;dd00
	ld a,007h		;dd01
	call 00093h		;dd03   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,00bh		;dd06
	ld a,00ah		;dd08
	call 00093h		;dd0a   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,001h		;dd0d
	ld a,004h		;dd0f
	call 00093h		;dd11   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddb2h)		;dd14   ; Complemento del contador: el periodo cae de 0x0401 a 0x0001, barrido ascendente
	cpl			;dd17
	ld e,a			;dd18
	ld a,005h		;dd19
	call 00093h		;dd1b   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddabh)		;dd1e   ; Solo avanza 1 de cada 4 frames: con 0xFB son 5 pasos, 20 frames
	and 003h		;dd21
	cp 003h			;dd23
	jp nz,L_DD42		;dd25
	ld a,(0ddb2h)		;dd28
	add a,001h		;dd2b
	ld (0ddb2h),a		;dd2d
	cp 000h			;dd30
	jp nz,L_DD42		;dd32
	ld a,007h		;dd35
	call 00096h		;dd37   ; BIOS RDPSG - Reads value from PSG-register
	set 2,a			;dd3a
	ld e,a			;dd3c
	ld a,007h		;dd3d
	call 00093h		;dd3f   ; BIOS WRTPSG - Writes data to PSG-register
L_DD42:
	ld a,(0ddb3h)		;dd42   ; EFECTO 8 - RUIDO PULSANTE (canal A). Unico disparador: 0x847D, al recoger el objeto que activa el vuelo. NO es la muerte
L_DD45:
	cp 000h			;dd45
	jp z,L_DDA7		;dd47
	ld a,007h		;dd4a
	call 00096h		;dd4c   ; BIOS RDPSG - Reads value from PSG-register
	res 3,a			;dd4f   ; Pone RUIDO en el canal A (bit 3 a cero) y le quita el TONO (bit 0 a uno)
	set 0,a			;dd51
	ld e,a			;dd53
	ld a,007h		;dd54
	call 00093h		;dd56   ; BIOS WRTPSG - Writes data to PSG-register
	ld e,0c8h		;dd59   ; Periodo de ruido; el PSG solo mira 5 bits, 0xC8 and 0x1F = 8
	ld a,006h		;dd5b
	call 00093h		;dd5d   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddb3h)		;dd60   ; Cada 8 frames vuelve a golpear
	and 007h		;dd63
	cp 000h			;dd65
	jp z,L_DD86		;dd67
	ld a,008h		;dd6a
	call 00096h		;dd6c   ; BIOS RDPSG - Reads value from PSG-register
	dec a			;dd6f   ; Entre golpe y golpe el volumen baja de dos en dos
	dec a			;dd70
	cp 0fah			;dd71   ; Si el volumen ha dado la vuelta por debajo de cero se queda en 0
	jp nc,L_DD81		;dd73
	push af			;dd76
	ld e,a			;dd77
	ld a,008h		;dd78
	call 00093h		;dd7a   ; BIOS WRTPSG - Writes data to PSG-register
	pop af			;dd7d
	jp L_DD88		;dd7e
L_DD81:
	ld a,000h		;dd81
	jp L_DD88		;dd83
L_DD86:
	ld a,00bh		;dd86   ; Frame de golpe: volumen 11 otra vez
L_DD88:
	ld e,a			;dd88
	ld a,008h		;dd89
	call 00093h		;dd8b   ; BIOS WRTPSG - Writes data to PSG-register
	ld a,(0ddb3h)		;dd8e   ; Con 0x73 (0x847D) son 115 frames, unos 2,3 segundos a 50 Hz
	dec a			;dd91
	ld (0ddb3h),a		;dd92
	cp 000h			;dd95
	jp nz,L_DDA7		;dd97
	ld a,007h		;dd9a   ; Apaga el ruido del canal A
	call 00096h		;dd9c   ; BIOS RDPSG - Reads value from PSG-register
	set 3,a			;dd9f
	ld e,a			;dda1
	ld a,007h		;dda2
	call 00093h		;dda4   ; BIOS WRTPSG - Writes data to PSG-register
L_DDA7:
	ret			;dda7

; ----------------------------------------------------------------------
; DATOS sfx_hueco: Tres bytes a cero de alineacion, delante del contador de frames. Ninguna instruccion los referencia (las palabras 0xDDA8..0xDDAA no aparecen en el binario) y en openMSX, con watchpoints de lectura y escritura durante 120 s de partida, no los toca nadie: cero impactos. [SUSTITUYE]
;   0xdda8..0xddab  (3 bytes)
; DATOS sfx_contador: Contador de frames libre del motor de efectos: 0xDB00 lo lee, 0xDB03 lo incrementa y 0xDB04 lo reescribe una vez por frame, y no lo reinicia jamas. Los efectos lo usan de divisor con un AND: 0xDB0F hace 'and 007h / cp 004h' (actua 1 de cada 8 frames) y 0xDD1E hace 'and 003h / cp 003h' (1 de cada 4). VERIFICADO en openMSX: 5861 lecturas desde 0xDB00 y 5861 escrituras desde 0xDB04 en 120 s de partida. Es ademas el unico byte de 0xDDA8-0xDDB4 que cambia entre volcados: 0x00 en la cinta y en el menu, y 0xB3 / 0x16 / 0xAD / 0xE5 en cuatro partidas distintas. [SUSTITUYE]
;   0xddab..0xddac  (1 bytes)
; DATOS ranuras_sonido: 8 ranuras de efecto de sonido. 0xDDAC = andar, 0xDDAD = saltar/caer (las escribe 0x8141).
;   0xddac..0xddb4  (8 bytes)
; DATOS resto_epilogo_irq: Siete bytes, D9 F1 C1 D1 E1 FB C9 = exx / pop af / pop bc / pop de / pop hl / ei / ret, identicos al final de la rutina de interrupcion 0xD00E-0xD014, que es el tramo que desapila lo que mete la BIOS antes de llamar a H.TIMI. La secuencia aparece exactamente DOS veces en los 40449 bytes: alli y aqui. Que sean el resto de una version anterior en la que el motor de efectos colgaba de H.TIMI, en vez de llamarse desde el bucle principal como ahora, encaja con que la rutina actual acabe en un RET pelado, pero no se puede probar con los bytes (?) [SUSTITUYE a la D 0xddb4 0xde01 sfx_restos, que se parte en tres]
;   0xddb4..0xddbb  (7 bytes)
; DATOS ceros_cola: Doce bytes a cero, sin ninguna referencia. Que esten a cero limpio y no con el patron 00/FF de los huecos apunta a que si los emitio el ensamblado, igual que los ceros de 0xDDA8-0xDDAA (?)
;   0xddbb..0xddc7  (12 bytes)
; DATOS ram_sin_iniciar_cola: 58 bytes del mismo patron degradado que 0xDA80: alternancia 00/FF con bits sueltos cambiados (20,7% de desviacion), bytes bajos 04 21 44 54 74 y altos ff fb cb. El ultimo byte del juego, 0xDE00 = 0x21, no significa nada: es un byte mas de este relleno.
;   0xddc7..0xde01  (58 bytes)
; ----------------------------------------------------------------------
	defb 000h,000h,000h	; dda8
VAR_SFX_FRAMES:
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,0d9h,0f1h,0c1h,0d1h	; ddab  .............
	defb 0e1h,0fbh,0c9h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,074h	; ddb8  ...............t
	defb 0ffh,054h,0ffh,054h,0ffh,074h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,074h,0ffh,054h	; ddc8  .T.T.t.T.T.T.t.T
	defb 0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h,0ffh,054h	; ddd8  .T.T.T.T.T.T.T.T
	defb 0ffh,044h,0ffh,044h,0ffh,004h,0ffh,044h,0ffh,044h,0ffh,044h,0ffh,044h,0ffh,054h	; dde8  .D.D...D.D.D.D.T
	defb 0ffh,044h,0cbh,054h,0ffh,054h,0fbh,0ffh,021h	; ddf8  .D.T.T..!
