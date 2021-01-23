;*********************************************************
;PRÁCTICA 4 - MICRO
;NOMBRES:
; Daniel Tijerina González
; Suemy Inagaki Pinheiro Fagundes
;Pareja 10
;*********************************************************

;**************************************************************************
; SBM 2020. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
;-- rellenar con los datos solicitados
	cadena_decimal db "3252$"
	cadena_hexa db "F35A$"
	cadena_decimal1 db "325$"
	cadena_hexa1 db "F35$"
	cadena_decimal2 db "13$"
	cadena_hexa2 db "FA$"
	cadena_decimal3 db "2$"
	cadena_hexa3 db "A$"
	texto db " se convierte en: $"
	salida_hexa db 10 dup (?)
	salida_decimal db 10 dup (?)
	salida_hexa1 db 10 dup (?)
	salida_decimal1 db 10 dup (?)
	salida_hexa2 db 10 dup (?)
	salida_decimal2 db 10 dup (?)
	salida_hexa3 db 10 dup (?)
	salida_decimal3 db 10 dup (?)
	msg_preba1 db "Test de DectoHex$"
	msg_preba2 db "Test de HextoDec$"
DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
PILA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT
EXTRA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
INICIO PROC NEAR
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS
MOV DS, AX
MOV AX, PILA
MOV SS, AX
MOV AX, EXTRA
MOV ES, AX
MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA

; Utilizacion de la int60h para convertir de decimal a hexadecimal
mov ah, 12h
mov bx, offset cadena_decimal
mov cx, offset salida_hexa
int 60h

; Utilizacion de la int60h para convertir de hexadecimal a decimal
mov ah, 13h
mov bx, offset cadena_hexa
mov cx, offset salida_decimal
int 60h

; Utilizacion de la int60h para convertir de decimal a hexadecimal
mov ah, 12h
mov bx, offset cadena_decimal1
mov cx, offset salida_hexa1
int 60h

; Utilizacion de la int60h para convertir de hexadecimal a decimal
mov ah, 13h
mov bx, offset cadena_hexa1
mov cx, offset salida_decimal1
int 60h

; Utilizacion de la int60h para convertir de decimal a hexadecimal
mov ah, 12h
mov bx, offset cadena_decimal2
mov cx, offset salida_hexa2
int 60h

; Utilizacion de la int60h para convertir de hexadecimal a decimal
mov ah, 13h
mov bx, offset cadena_hexa2
mov cx, offset salida_decimal2
int 60h

; Utilizacion de la int60h para convertir de decimal a hexadecimal
mov ah, 12h
mov bx, offset cadena_decimal3
mov cx, offset salida_hexa3
int 60h

; Utilizacion de la int60h para convertir de hexadecimal a decimal
mov ah, 13h
mov bx, offset cadena_hexa3
mov cx, offset salida_decimal3
int 60h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h

mov ah, 9
mov dx, offset msg_preba1
int 21h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h


; Se imprimen los resultados de la primera prueba
mov ah, 9
mov dx, offset cadena_decimal
int 21h
mov dx, offset texto
int 21h
mov dx, offset salida_hexa
int 21h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h


; Se imprimen los resultados de la primera prueba
mov ah, 9
mov dx, offset cadena_decimal1
int 21h
mov dx, offset texto
int 21h
mov dx, offset salida_hexa1
int 21h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h

; Se imprimen los resultados de la primera prueba
mov ah, 9
mov dx, offset cadena_decimal2
int 21h
mov dx, offset texto
int 21h
mov dx, offset salida_hexa2
int 21h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h

; Se imprimen los resultados de la primera prueba
mov ah, 9
mov dx, offset cadena_decimal3
int 21h
mov dx, offset texto
int 21h
mov dx, offset salida_hexa3
int 21h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h

mov ah, 9
mov dx, offset msg_preba2
int 21h


; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h



; Se imprimen los resultados de la segunda prueba
mov ah, 9
mov dx, offset cadena_hexa
int 21h
mov dx, offset texto
int 21h
mov dx, offset salida_decimal
int 21h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h

; Se imprimen los resultados de la segunda prueba
mov ah, 9
mov dx, offset cadena_hexa1
int 21h
mov dx, offset texto
int 21h
mov dx, offset salida_decimal1
int 21h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h

; Se imprimen los resultados de la segunda prueba
mov ah, 9
mov dx, offset cadena_hexa2
int 21h
mov dx, offset texto
int 21h
mov dx, offset salida_decimal2
int 21h

; Se imprime un NL (ascii 0Ah)
mov ah, 06h
mov dl, 0Ah
int 21h



; Se imprimen los resultados de la segunda prueba
mov ah, 9
mov dx, offset cadena_hexa3
int 21h
mov dx, offset texto
int 21h
mov dx, offset salida_decimal3
int 21h



; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 