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

; a1) MOV AL, ES:[31F2H]
; b1) MOV SI, 0002H
;     MOV AX, ES:[SI]
; c1) MOV ES:[0EF1H], AL
; INICIALIZACION DE DATOS
MOV AX, 051H
MOV DS, AX
MOV AX, 073H
MOV ES, AX
MOV BX, 0222H
MOV DI, 1111H
; PROBLEMA 1 - COMPROBACION
MOV AL, DS:[3412H]
MOV AL, ES:[31F2H]
; PROBLEMA 2 - COMPROBACION
MOV AX, [BX]
MOV SI, 0002H
MOV AX, ES:[SI]
; PROBLEMA 3 - COMPROBACION
MOV [DI], AL
MOV ES:[0EF1H], AL

; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
