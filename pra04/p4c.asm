;*********************************************************
;PRÁCTICA 4 - MICRO
;NOMBRES:
; Daniel Tijerina Gonzáles
; Suemy Inagaki Pinheiro Fagundes
;Pareja 10
;*********************************************************

; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
lectura db 10
	db 11 dup (?)
retorno db 10 dup (?)
prompt db "hex - Convertir un decimal a hexadecimal", 0Ah
       db "dec - Convertir un hexadecimal a decimal", 0Ah
       db "quit - Salir del programa", 0Ah, "$"
hex_prompt db "Escribe un decimal para convertirlo a hexadecimal o dec/quit para cambiar funcionalidad.", 0Ah, "$"
dec_prompt db "Escribe un hexadecimal para convertirlo a decimal o hex/quit para cambiar funcionalidad.", 0Ah, "$"
er_prompt db "Error en la lectura del parametro", 0Ah, "$"
DATOS ENDS

; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
INICIO PROC NEAR
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS
MOV DS, AX
; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA

mov ah, 9
mov dx, OFFSET prompt
int 21h

mov ah, 0Ah
mov dx, OFFSET lectura
int 21h

notd:
cmp lectura[2], 'h'
jne noth
cmp lectura[3], 'e'
jne er
cmp lectura[4], 'x'
jne er
mov ah, 06h
mov dl, 0Ah
int 21h
jmp hex

noth:
cmp lectura[2], 'd'
jne nothd
cmp lectura[3], 'e'
jne er
cmp lectura[4], 'c'
jne er
mov ah, 06h
mov dl, 0Ah
int 21h
jmp deci

nothd:
jmp termina

; Error en la recepcion de parametro
er:
mov ah, 9
mov dx, OFFSET er_prompt
int 21h
jmp termina

; bucle en hex hasta que se reciba dec/quit
hex:
mov ah, 9
mov dx, OFFSET hex_prompt
int 21h

;recibir una cadena de teclado
mov ah, 0Ah
mov dx, OFFSET lectura
int 21h

; imprimir nueva línea (formato)
mov ah, 06h
mov dl, 0Ah
int 21h

cmp lectura[2], 'd'
jne hex_notd
cmp lectura[3], 'e'
jne er
cmp lectura[4], 'c'
jne er
; imprimir nueva línea (formato)
mov ah, 06h
mov dl, 0Ah
int 21h
; cambio a bucle deci
jmp deci

hex_notd:
cmp lectura[2], 'q'
jne hex_ini
cmp lectura[3], 'u'
jne er
cmp lectura[4], 'i'
jne er
cmp lectura[5], 't'
jne er
; fin del programa
jmp termina

hex_ini:
mov cx, 0
mov cl, lectura[1]
mov si, cx
mov cx, 0

mov lectura[si+2], '$'

mov ah, 12h 
mov bx, offset lectura[2]
mov cx, offset retorno
int 60h

mov bx, 0
mov dx, 18
mov cx, 0

push ds
mov ds, cx
mov es, ds:[1Ch * 4 + 2]
mov bp, ds:[1Ch * 4]
pop ds

reiterar_hex:
mov es:[bp - 6], cx
bucle_hex:
cmp es:[bp - 6], dx
jae tmp_hex
jmp bucle_hex

tmp_hex:
mov ah, 6h
mov dl, retorno[bx]
int 21h
inc bx
cmp retorno[bx], '$'
je hex_otra
mov dx, 18
cmp si, bx
jne reiterar_hex

hex_otra:
mov ah, 06h
mov dl, 0Ah
int 21h
int 21h
jmp hex


; bucle en deci hasta que se reciba hex/quit
deci:
mov ah, 9
mov dx, OFFSET dec_prompt
int 21h

;recibir una cadena de teclado
mov ah, 0Ah
mov dx, OFFSET lectura
int 21h

; imprimir nueva línea (formato)
mov ah, 06h
mov dl, 0Ah
int 21h

cmp lectura[2], 'h'
jne dec_noth
cmp lectura[3], 'e'
jne dec_er
cmp lectura[4], 'x'
jne dec_er
; imprimir nueva línea (formato)
mov ah, 06h
mov dl, 0Ah
int 21h
; cambio a bucle hex
jmp hex

dec_noth:
cmp lectura[2], 'q'
jne dec_ini
cmp lectura[3], 'u'
jne dec_er
cmp lectura[4], 'i'
jne dec_er
cmp lectura[5], 't'
jne dec_er
; fin del programa
jmp termina

; Error en la recepcion de parametro
dec_er:
mov ah, 9
mov dx, OFFSET er_prompt
int 21h
jmp termina

dec_ini:
mov cx, 0
mov cl, lectura[1]
mov si, cx
mov cx, 0

mov lectura[si+2], '$'

mov ah, 13h 
mov bx, offset lectura[2]
mov cx, offset retorno
int 60h

mov bx, 0
mov dx, 18
mov cx, 0

push ds
mov ds, cx
mov es, ds:[1Ch * 4 + 2]
mov bp, ds:[1Ch * 4]
pop ds

reiterar_dec:
mov es:[bp - 6], cx
bucle_dec:
cmp es:[bp - 6], dx
jae tmp_dec
jmp bucle_dec

tmp_dec:
mov ah, 6h
mov dl, retorno[bx]
int 21h
inc bx
cmp retorno[bx], '$'
je dec_otra
mov dx, 18
cmp si, bx
jne reiterar_dec

dec_otra:
mov ah, 06h
mov dl, 0Ah
int 21h
int 21h
jmp deci


termina:

; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 
