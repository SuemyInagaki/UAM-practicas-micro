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

MOV AX, 99H
MOV BX, 0B2H
MOV CX, 1234H
MOV DX, CX

; SE USAN ES Y BX PARA ACCEDER A LAS DIRECCIONES 65225H Y 65226H
MOV AX, 6520H
MOV ES, AX
MOV BX, 25H
MOV BH, [ES:BX]
MOV BL, [ES:BX+1]

; SE USAN ES Y BX PARA ACCEDER A LA DIRECCION 60008H
MOV AX, 6000H
MOV ES, AX
MOV BX, 8H
MOV [ES:BX], CH
MOV AX, [SI]
MOV BX, [BP+10]

; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 