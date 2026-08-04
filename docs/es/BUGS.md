# Bugs del juego original

Fallos que tiene *Temptations* desde 1988. No son errores del desensamblado:
están en el código tal y como salió a la venta.

Cada uno con el código que lo produce y, cuando se ha podido, la comprobación en
el emulador. Van de menos a más grave.

---

## 1. El tope de vidas es 9, aunque el código pretenda que sean 10

La rutina que te da una vida extra:

```asm
DA_VIDA:
    ld a,(08f12h)   ; A = vidas actuales
    inc a           ; una mas
    cp 00ah         ; ¿ha llegado a 10?
    ret z           ; SI -> se va... SIN GUARDAR
    ld (08f12h),a   ; NO -> guarda el valor nuevo
    call PINTA_MARCADOR
    ret
```

El `ret z` está **antes** del `ld` que guarda. Así que si tienes 9 vidas y coges
otra, el `inc a` da 10, salta el `ret z`, y la vida se pierde por el camino.

Nunca verás 10 en el marcador. **El tope real es 9.**

Puede ser intencionado —el marcador solo tiene un dígito, y la rutina que lo
pinta también recorta a 9— pero entonces la comparación tendría que ser con 10 y
el orden de las instrucciones al revés. Tal y como está, el código dice una cosa
y hace otra.

---

## 2. Al coger un objeto desaparece otro

Ésta se ve jugando.

Cuando recoges un objeto, el juego tiene que borrarlo del mapa. Lo hace así:

```asm
BORRA_OBJETO_MAPA:
    ld hl,07d80h    ; SIEMPRE desde el principio del mapa
    ld bc,00200h    ; los 512 bytes de la pantalla
    cpir            ; busca el primer byte igual a A
    ...
    ld (hl),000h    ; y lo borra
```

`CPIR` busca desde el **principio del buffer**, no desde donde está el jugador.
Encuentra el primer tile de ese tipo que haya en la pantalla, sea el que sea.

En una pantalla con un solo objeto de cada clase no se nota. Pero:

| Pantalla | Objetos repetidos |
|---|---|
| 16 | **2** de munición |
| 27 | **6** de vida extra |

En la pantalla 27, con seis vidas extra a la vista, cojas la que cojas
desaparecerá siempre la primera en orden de barrido — arriba a la izquierda. Si
coges la última, verás desaparecer una que está al otro lado de la pantalla,
mientras la que acabas de tocar sigue dibujada.

### Y hay un segundo fallo encadenado

Las rutinas que recogen objetos borran la casilla **antes** de comprobar si
tienes el marcador al tope. Es decir: si coges una vida extra teniendo ya 9, o
munición teniendo el máximo, o el arma que ya llevas, el objeto **desaparece del
mapa sin darte nada**.

---

## 3. Cada partida perdida se come un trozo de pila

Éste es el más serio, y tarda en manifestarse.

El juego coloca la pila una sola vez, durante el arranque:

```asm
GAME_START:
    ld sp,0efffh    ; pila provisional
    ...
    ld sp,08fffh    ; pila definitiva del juego   <- 0x8058
    jp INIT_PRINCIPAL
```

Pero cuando pierdes la última vida, el game over termina así:

```asm
    call 08bfdh
    jp 08076h       ; reinicia... entrando DESPUES del ld sp
```

`0x8076` es la inicialización principal, que está **por debajo** de la
instrucción que coloca la pila. Así que la partida nueva arranca con el puntero
de pila donde lo dejó la anterior.

### Medido en el emulador

Provocando ocho game overs seguidos —forzados desde el depurador, poniendo las
vidas a cero y saltando a la rutina de morir— y anotando dónde quedaba la pila
en cada reinicio:

| Reinicio | Puntero de pila |
|---|---|
| 1 | `0x8FFF` |
| 2 | `0x8FFF` |
| 3 | `0x8FFD` |
| 4 | `0x8FFB` |
| 5 | `0x8FF9` |
| 6 | `0x8FDB` |
| 7 | `0x8FD9` |
| 8 | `0x8FD7` |

Baja y no vuelve a subir.

La pila crece hacia abajo desde `0x8FFF`. Justo debajo, en `0x8FA0`, está la
tabla de los cuatro puntos ocultos de la pantalla en curso, y más abajo aún,
desde `0x8F00`, las variables del juego. O sea que el primer daño llega a los
~80 bytes de fuga, y a partir de ~160 empieza a comerse las variables. Tras
suficientes partidas perdidas seguidas **sin resetear la máquina**, la partida
acabaría corrompiéndose.

En 1988, jugando en una cinta que tardaba siete minutos en cargar, era difícil
que alguien encadenase tantas partidas de una sentada. Hoy, con un emulador y
carga instantánea, es trivial llegar ahí.

**Arreglo:** cambiar el destino del salto de `0x8076` a una dirección que
recoloque la pila antes de continuar.

---

## 4. El final no tiene salida

Cuando te pasas el juego, la pantalla de victoria entra en este bucle:

```asm
BUCLE_FINAL:
    call MUEVE_ENEMIGOS
    halt
    halt
    halt
    jp BUCLE_FINAL
```

No lee el teclado. Ni siquiera CTRL+STOP funciona, porque el juego solo consulta
esa combinación desde la rutina de partida, y aquí no se llama.

Terminado el juego, la única forma de volver es **resetear la máquina**. No es
exactamente un bug —puede ser deliberado, para que la pantalla final se quede
puesta— pero conviene saberlo.

---

## Una rareza que no es un bug

En la pantalla 26 hay un punto oculto cuyo premio es un tile **mortal**.

Los puntos ocultos son casillas que sueltan un objeto al dispararles. Casi todos
dan munición, armas o vidas. Ése no: te mata.

Está en los datos tal cual, así que es intencionado: una trampa para quien vaya
disparando a todo lo que se mueve. Muy en el espíritu de un juego que además
guarda un reproche para los tramposos en la pantalla final.
