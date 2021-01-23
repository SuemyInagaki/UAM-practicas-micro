;**************************************************************************
; NOMBRES DE LOS AUTORES
;**************************************************************************
; DANIEL TIJERINA GONZÁLES
; SUEMY INAGAKI PINHEIRO FAGUNDES
; PAREJA 10
;**************************************************************************
;* BASIC ASSEMBLY PROGRAM STRUCTURE EXAMPLE to use with C code link
;* SBM / MBS 2020
;* 
;**************************************************************************

; CODE SEGMENT DEFINITION
_TEXT SEGMENT BYTE PUBLIC 'CODE'
ASSUME CS: _TEXT
PUBLIC _calculaMediana  ; example for the first function
_calculaMediana PROC FAR 
	PUSH BP
	MOV BP, SP
	MOV AX, [BP + 12]  ; PRIMER ELEMENTO
	MOV BX, [BP + 10]  ; SEGUNDO ELEMENTO
	MOV CX, [BP + 8]   ; TERCER ELEMENTO
	MOV DX, [BP + 6]   ; CUARTO ELEMENTO

	;******************************************
	; COMO LA FUNCION CALCULA LA MEDIANA:
	;******************************************
	; PRIMERO SEPARO LOS NUMEROS EN DOS PAREJAS
	; ORDENO CADA PAREJA
	; COMPARO EL MENOR DE LA PRIMERA PAREJA CON EL MENOR DE LA SEGUNDA
	; ORDENO LOS DOS NUMEROS
	; COMPARO EL MAS GRANDE DE LA PRIMERA PAREJA CON EL MAS GRANDE DE LA SEGUNDA
	; ORDENO LOS DOS NUMEROS
	; AHORA TENGO LOS NUMEROS ORDENADOS
	; CALCULO LA SUMA DE LOS DOS NUMEROS MEDIANOS: BX + CX
	; DIVIDO LA SUMA POR 2
	; RETORNA
	;******************************************

	CMP AX, BX   ; COMPARO EL PRIMER PARAMETRO CON EL SEGUNDO
	JG L1        ; SI AX ES MAS GRANDE QUE BX, PULA PARA L1
	JLE L2       ; SI BX ES MAS GRANDE O IGUAL QUE AX, ESTA ORDENADO.
				 ; PULA PARA L2

	L1:
	XCHG AX, BX  ;REALIZO EL CAMBIO DE AX Y BX (para ordenar)

	L2:
	CMP CX, DX
	JG L3        ;SI CX ES MAS GRANDE QUE DX, PULA PARA L3
	JLE L4       ;SI DX ES MAS GRANDE O IGUAL QUE CX, PULA PARA L4

	L3:
	XCHG CX, DX  ;REALIZO EL CAMBIO DE CX Y DX (para ordenar)

	L4:
	CMP AX, CX   ;COMPARO LOS MENORES NUMEROS DE CADA PAREJA
	JG L5        ;SI AX ES MAS GRANDE QUE CX, PULA PARA L5
	JLE L6       ;SI CX ES MAS GRANDE QUE AX, PULA PARA L6

	L5:
	XCHG AX, CX  ;REALIZO EL CAMBIO DE AX Y CX (para ordenar)

	L6:
	XCHG CX, BX

	CMP CX, DX
	JG L7        ;SI CX ES MAS GRANDE QUE DX, PULA PARA L7
	JLE L8       ;SI DX ES MAS GRANDE O IGUAL QUE CX, PULA PARA L8

	L7:
	XCHG CX, DX  ;REALIZO EL CAMBIO DE CX Y DX (para ordenar)

	L8: 
	MOV DX, 0
	ADD DX, CX  ;SUMA CX A DX
	ADD DX, BX  ;SUMA BX A DX (DX = BX + CX)

	MOV AX, DX  ;AX ES EL DIVIDENDO 
	XOR DX, DX  ;PARA LIMPIAR DX
	SAR AX, 1   ;DIVIDE EL CONTENIDO DE AX POR 2
	  			;RETORNA EL VALOR DE AX
	POP BP	    ;BP restored
	RET
_calculaMediana ENDP


PUBLIC _enteroACadenaHexa
_enteroACadenaHexa PROC FAR
	PUSH BP
	MOV BP, SP
	LES SI, [BP + 8]
	MOV BX, [BP + 6]

	XOR AX, AX
	MOV AL, BL
	MOV CL, 10h
	DIV CL
	MOV CH, AL

	MOV CL, BL
	AND CL, 0Fh

	XOR AX, AX
	MOV AL, BH
	MOV DL, 10h
	DIV DL
	MOV DH, AL

	MOV DL, BH
	AND DL, 0Fh

	; primer byte en CL
	; segundo byte en CH
	; tercer byte en DL
	; cuarto byte en DH
	; leer como DH DL CH CL

	CMP CL, 0Ah
	JB LST1
	ADD CL, 37h
	JMP N2
	LST1:
	ADD CL, 30h

	N2:
	CMP CH, 0Ah
	JB LST2
	ADD CH, 37h
	JMP N3
	LST2:
	ADD CH, 30h

	N3:
	CMP DL, 0Ah
	JB LST3
	ADD DL, 37h
	JMP N4
	LST3:
	ADD DL, 30h

	N4:
	CMP DH, 0Ah
	JB LST4
	ADD DH, 37h
	JMP N5
	LST4:
	ADD DH, 30h

	N5:
	MOV ES:[SI], DH
	MOV ES:[SI+1], DL
	MOV ES:[SI+2], CH
	MOV ES:[SI+3], CL
	MOV ES:[SI+4], 00h

	POP BP	    ;BP restored
	RET
_enteroACadenaHexa ENDP


PUBLIC _calculaLetraDNI
_calculaLetraDNI PROC FAR ;
	JMP INI
	TABLA DB "TRWAGMYFPDXBNJZSQVHLCKE"

	INI:
	PUSH BP
	MOV BP, SP

	LES BX, [BP + 6]  ; PRIMER PARAMETRO

	; tenemos en ES:BX la direccion del string

	MOV CX, 0
	; poner el primer caracter (multiplicado por 10^7) en DI:SI
	MOV CL, ES:[BX]
	SUB CL, 30h
	MOV AX, 1000d
	MUL CX
	MOV CX, 10000d
	MUL CX
	MOV CX, 0
	MOV DI, DX
	MOV SI, AX

	; poner el segundo caracter (multiplicado por 10^6) en DI:SI
	MOV CL, ES:[BX+1]
	SUB CL, 30h
	MOV AX, 1000d
	MUL CX
	MOV CX, 1000d
	MUL CX
	MOV CX, 0
	ADD SI, AX
	ADC DI, DX

	; poner el tercer caracter (multiplicado por 10^5) en DI:SI
	MOV CL, ES:[BX+2]
	SUB CL, 30h
	MOV AX, 1000d
	MUL CX
	MOV CX, 100d
	MUL CX
	MOV CX, 0
	ADD SI, AX
	ADC DI, DX

	; poner el cuarto caracter (multiplicado por 10^4) en DI:SI
	MOV CL, ES:[BX+3]
	SUB CL, 30h
	MOV AX, 1000d
	MUL CX
	MOV CX, 10d
	MUL CX
	MOV CX, 0
	ADD SI, AX
	ADC DI, DX

	; poner el quinto caracter (multiplicado por 10^3) en DI:SI
	MOV CL, ES:[BX+4]
	SUB CL, 30h
	MOV AX, 1000d
	MUL CX
	MOV CX, 0
	ADD SI, AX
	ADC DI, DX

	; poner el sexto caracter (multiplicado por 10^2) en DI:SI
	MOV CL, ES:[BX+5]
	SUB CL, 30h
	MOV AX, 100d
	MUL CX
	MOV CX, 0
	ADD SI, AX
	ADC DI, DX

	; poner el septimo caracter (multiplicado por 10^1) en DI:SI
	MOV CL, ES:[BX+6]
	SUB CL, 30h
	MOV AX, 10d
	MUL CX
	MOV CX, 0
	ADD SI, AX
	ADC DI, DX

	; poner el octavo caracter (multiplicado por 1) en DI:SI
	MOV CL, ES:[BX+7]
	SUB CL, 30h
	ADD SI, CX

	MOV AX, SI
	MOV DX, DI
	; El valor del numero esta en DX:AX

	CMP DX, 0
	JE ZERO
	JMP DIVIDE

	ZERO:      ;Para saber si el numero es menor que 23
	CMP AX, 23
	JGE DIVIDE
	JMP FIN

	DIVIDE:
	SUB AX, 23
	SBB DX, 0
	CMP DX, 0
	JE CASI
	JMP DIVIDE

	CASI:
	CMP AX, 23
	JAE DIVIDE
	JMP FIN

	FIN:
	MOV BX, AX
	MOV BL, TABLA + BX

	LES SI, [BP + 10] ; Lectura del segundo parámetro
	MOV ES:[SI], BL

	POP BP	    ;BP restored
	RET

_calculaLetraDNI ENDP





_TEXT ENDS

END
