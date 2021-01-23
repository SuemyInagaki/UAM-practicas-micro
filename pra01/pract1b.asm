;**************************************************************************
; NOMBRES DE LOS AUTORES
;**************************************************************************
; DANIEL TIJERINA GONZÁLES
; SUEMY INAGAKI PINHEIRO FAGUNDES
; PAREJA 10

;**************************************************************************
; SBM 2020. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT

;-- rellenar con los datos solicitados
CONTADOR DB ?
BEBE DW 0CAFEH
ERRORFATAL1 DB "Este programa se cuelga siempre."
TABLA100 DB 100 dup (0)

DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT
RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES)
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
; -- rellenar con las instrucciones solicitadas

; acceder al tercer caracter de errorfatal
; como tiene tamano de 1 byte, cargar en AH (tambien tiene tamano de 1 byte)
; por fin, cargar el contenido de ah en la posicion 63h de tabla100

MOV AH, ERRORFATAL1[3]
MOV TABLA100[63h], AH

; CARGAR EL CONTENIDO DE BEBE EN EL REGISTRO AX, CADA UNO TIENE 2 BYTES
; SE USAN AH Y AL PARA ACCEDER A CADA BYTE DE AX
; CARGAR CADA BYTE EN SU RESPECTIVA POSICION EN TABLA100

MOV AX, BEBE
MOV TABLA100[23H], AH
MOV TABLA100[24H], AL

; COMO AX YA TIENE EL CONTENIDO DE BEBE, ACCEDER SU BYTE MAS SIGNIFICATIVO
; UTILIZANDO AH

MOV CONTADOR, AH


; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 
