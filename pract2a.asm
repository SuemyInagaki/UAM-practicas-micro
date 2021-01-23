;**************************************************************************
; PRACTICA 2 - MICRO - GRUPO 2213
; PAREJA 10
; NOMBRES:
; DANIEL TIJERINA GONZÁLES
; SUEMY INAGAKI PINHEIRO FAGUNDES
;**************************************************************************

;**************************************************************************
; SBM 2020. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
	EXTRN fopen:FAR
	EXTRN Write_WAV:FAR
	EXTRN fclose:FAR
	EXTRN Init_WAV_Header:FAR
	TABLA DB 8000 DUP (?)
	NOMBRE DB "gen_la.WAV",0
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
	MOV SI, 0 ;INDICE DE LA TABLA
	MOV CX, 8000 ;CONTADOR DEL BUCLE
	XOR DX, DX ;SE INICIALIZA DX A 0 PARA USARSE EN DIVISION
POSI:
	; SE VERIFICA QUE NO SE PASE DEL TAMAÑO DE LA TABLA
	CMP CX, 0
	JE DISTINTO
	DEC CX

	; SE AGREGA UN VALOR A LA TABLA
	MOV TABLA[SI], 50
	INC SI

	; SE HACE LA FLUCTUACIÓN SEGÚN EL ÍNDICE DE LA TABLA
    XOR DX, DX
	MOV AX, SI
	MOV BX, 9
	DIV BX
	CMP DX, 0
	JE NEGA

	JMP POSI
NEGA:
	; SE VERIFICA QUE NO SE PASE DEL TAMAÑO DE LA TABLA
	CMP CX, 0
	JE DISTINTO
	DEC CX

	; SE AGREGA UN VALOR A LA TABLA
	MOV TABLA[SI], -50
	INC SI

	; SE HACE LA FLUCTUACIÓN SEGÚN EL ÍNDICE DE LA TABLA
    XOR DX, DX
	MOV AX, SI
	MOV BX, 9
	DIV BX
	CMP DX, 0
	JE POSI
	
	JMP NEGA
DISTINTO:
	; ACABAMOS
	MOV DX, OFFSET NOMBRE
	CALL fopen
	MOV BX, AX
	MOV DX, 8000
	MOV CX, 8000
	CALL Init_WAV_Header
	MOV DI, OFFSET TABLA
	CALL Write_WAV
	CALL fclose

	; FIN DEL PROGRAMA
	MOV AX, 4C00H
	INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 