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
	EXTRN fread:FAR
	
	BUFFER DB 255         ;NUMERO MAXIMO DE ELEMENTOS A SEREM LIDOS
		   DB ?           ;NUMERO DE ELEMENTOS LIDOS RETORNADO PELA INTERRUPÇÃO SEM INCLUIR ENTER
	ARCHIVO DB 255 DUP (0) ;VARIAVEL ARMAZENANDO O TEXTO LIDO 

	TERMINADOR DB 10D, 13D, '$'

	MENSAGE DB "EXCRIBA EL NOMBRE DEL FICHERO INCLUINDO LA EXTENSION", 10D, 13D, '$'
	ERROR_ABRIR_FICHERO DB "ERRO AL ABRIR EL FICHERO", 10D, 13D, '$'
	MSG_ERROR_LECTURA_FICHERO DB "ERRO AL LEER DATOS DEL FICHERO", 10D, 13D, '$'
	MSG_TIPO DB 13D, "TIPO DE FICHERO:", 10D, '$'
	MSG_NOMBRE DB 13D, "NOMBRE DEL FICHERO:", 10D, 13D, '$'
	
	DATOS_FICHERO DW ? 
	
	HANDLE DW ?

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

COMIENZO:
	
   ;***********************************************
   ; Lendo o nome do fichero desde o teclado
   ;
   ; IMPRIME MENSAGE - SOLICITA NOMBRE DEL FICHERO
	MOV DX, OFFSET MENSAGE
	MOV AH, 09H
	INT 21H

	;LE LA ENTRADA EN EL BUFFER
	MOV DX, OFFSET BUFFER
	MOV AH, 0AH
	INT 21H

	; SUBSTITUI ENTER CHR(13)

	MOV SI, OFFSET BUFFER + 1 ; CARGA EN SI EL NUMERO DE ELEMENTOS LEIDOS
	MOV CL, [SI]              ; ALMACENA EN CL EL NUMERO DE ELMENTOS LEIDOS
	MOV CH, 0                 ; ZERA CH PARA PODER UTILIZAR EL CX
	INC CX                    ; CX PASA A ALMACENAR LA POSICION DEL ENTER CHR(13) FINAL DEL BUFFER
	ADD SI, CX                ; SI APONTA PARA LA POSICION
	MOV AL, '$'                 ; SUBSTITUINDO O CHR(13) POR 0 $
	MOV [SI], AL              ;SUBSTITUI O ENTER CHR(13) PELO TERMINADOR DE STRING '$'

	; MOSTRANDO EL NOMBRE DEL ARCHIVO LEIDO

NOMBRE:
	MOV DX, OFFSET MSG_NOMBRE
	MOV AH, 09H
	INT 21H

	MOV DX, OFFSET ARCHIVO
	MOV AH, 09H
	INT 21H

	MOV DX, OFFSET TERMINADOR
	MOV AH, 09H
	INT 21H
 	;
	;**********************************************

	

   ;***********************************************
   ; Abrindo o ficheiro wav
   ;
ABRIR_FICHERO:
	;LLAMA LA FUNCION FOPEN
	
	MOV DX, OFFSET ARCHIVO
	CALL fopen
	MOV HANDLE, AX ;FILE HANDLE
	MOV AH, 09H
	INT 21H
	;
	;**********************************************

	;**********************************************
	; Copiando LA CABECERA DEL FICHERO

	;COPIANDO LOS DATOS LEIDOS PARA DATOS_FICHERO
	MOV BX, HANDLE
	MOV CX, 44
	MOV DX, DATOS_FICHERO
	CALL fread
	JB ERROR_LECTURA_FICHERO
	JMP TIPO

ERROR_LECTURA_FICHERO:
	MOV DX, OFFSET MSG_ERROR_LECTURA_FICHERO
	MOV AH, 09H
	INT 21H
	JMP FIN

TIPO:
	MOV DX, OFFSET MSG_TIPO
	MOV AH, 09H
	INT 21H
	
	xor dx, dx
	mov si, 23                      ;si es la posicion inicial
	mov bx, 4                       ;tamano del tipo
	mov di, bx                      ;vamos precisar del bx depues, entonces 
	                                ;guardé el bx en di
	add di, si                      ;calcula la posicion final
	mov DATOS_FICHERO[di], '$'
	mov dx, offset DATOS_FICHERO
	add dx, si
	int 21h

FIN:
	MOV BX, HANDLE
	CALL fclose
	
	; FIN DEL PROGRAMA
	MOV AX, 4C00H
	INT 21H
INICIO ENDP

; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 