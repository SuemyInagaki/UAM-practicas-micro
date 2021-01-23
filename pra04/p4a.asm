;*********************************************************
;PRÁCTICA 4 - MICRO
;NOMBRES:
; Daniel Tijerina González
; Suemy Inagaki Pinheiro Fagundes
;Pareja 10
;*********************************************************


codigo SEGMENT
	ASSUME cs: codigo
	ORG 256

inicio PROC NEAR

	jmp startup

	;Variables globales
	AUTORES DB "Grupo #2213. Daniel Tijerina y Suemy Inagaki$" 
	STATUS_I DB "RSI se encuentra instalado",10,13,'$'
	STATUS_D DB "RSI no se encuentra instalado", 10,13,'$'
	msg_error db "parametro invalido$"
	firma dw 0CAFEh    ;firma para comprobar la instalación de la RSI

;Rutina de servicio para int 60h
rsi PROC FAR
	cmp ah, 12h
	je decimalAhexa
	cmp ah, 13h
	je hexaAdecimal

	decimalAhexa:
	call decToHex
	iret

	hexaAdecimal:
	call HexToDec
	iret
rsi ENDP

firma2 dw 0FECAh
contador dw 0
ORIGINAL_OFF dw (?)
ORIGINAL_SEG dw (?)
timerRsi PROC FAR
	inc contador
	iret
timerRsi ENDP


decToHex PROC NEAR
	push cx ; Se guarda la direccion de salida

	mov al, ds:[bx+1]
	cmp al, 24h
	mov si, 1d
	je ini

	mov al, ds:[bx+2]
	cmp al, 24h
	mov si, 10d
	je ini

	mov al, ds:[bx+3]
	cmp al, 24h
	mov si, 100d
	je ini

	mov al, ds:[bx+4]
	cmp al, 24h
	mov si, 1000d
	je ini

	mov al, ds:[bx+5]
	cmp al, 24h
	mov si, 10000d
	je ini

	ini:
	xor cx, cx
	xor dx, dx
	xor ax, ax
	xor bp, bp

	bucle:
	xor ax, ax
	mov al, ds:[bx]
	sub al, 30h
	mul si
	add bp, ax

	mov ax, si
	mov si, 10d
	div si
	mov si, ax
	inc bx
	cmp si, 0
	je fini
	jmp bucle

	fini:
	pop cx ; se recupera la direccion de salida
	mov si, cx
	mov dl, 24h ; se escribe $ al final de la cadena
	mov ds:[si + 4], dl

	xor dx, dx
	mov ax, bp
	mov bx, 10h
	div bx
	cmp dl, 0Ah
	jb d4l
	jmp d4g
	d4l:
	add dx, 30h
	jmp f4
	d4g:
	add dx, 37h
	f4:
	mov ds:[si + 3], dl

	xor dx, dx
	div bx
	cmp dl, 0Ah
	jb d3l
	jmp d3g
	d3l:
	add dx, 30h
	jmp f3
	d3g:
	add dx, 37h
	f3:
	mov ds:[si + 2], dl

	xor dx, dx
	div bx
	cmp dl, 0Ah
	jb d2l
	jmp d2g
	d2l:
	add dx, 30h
	jmp f2
	d2g:
	add dx, 37h
	f2:
	mov ds:[si + 1], dl

	xor dx, dx
	div bx
	cmp dl, 0Ah
	jb d1l
	jmp d1g
	d1l:
	add dx, 30h
	jmp f1
	d1g:
	add dx, 37h
	f1:
	mov ds:[si], dl
	ret
decToHex ENDP


HexToDec PROC NEAR
	jmp inicio_htd	

	fin_ret:
	ret	
	
	inicio_htd:
	push cx ; se guarda la direccion de salida
	xor cx, cx
	xor dx, dx
	xor ax, ax
	xor bp, bp


	mov al, ds:[bx]
	cmp al, 24h
	je fin_ret
	
	mov al, ds:[bx+1]
	cmp al, 24h
	mov si, 0
	mov di, si      ;di es el tamaño de la cadena
	je loop_hex
	
	mov al, ds:[bx+2]
	cmp al, 24h
	mov si, 1
	mov di, si      ;di es el tamaño de la cadena
	je loop_hex

	mov al, ds:[bx+3]
	cmp al, 24h
	mov si, 2
	mov di, si      ;di es el tamaño de la cadena
	je loop_hex
	
	mov si, 3
	mov di, si


loop_hex:
	cmp si, 0
	jl fin_loop
	xor ax, ax
	mov al, ds:[bx+si]
	cmp al, 'A'
	jae letra
	sub al, 48
	mov cx, di
	sub cx, si
	jmp potencia
letra: 
	sub al, 55
	mov cx, di
	sub cx, si
potencia:
	cmp cx, 0
	je fin_pot
	mov dx, 16d
	mul dx
	dec cx
	jmp potencia
fin_pot:
	add bp, ax
	dec si
	jmp loop_hex

fin_loop:
	mov ax, bp    ;se tiene en ax el valor hexadecimal
	pop cx        ;se recupera el valor de cx
	mov si, cx    ;se guarda la direccion de salida en si
	
; hex to dec
	push bx             ;guardo el valor de bx
	mov bx, ax          ;guardo en bx el numero

	cmp ax, 10d         ;ax < 10 = tiene solamente 1 digito
	jb fin_divide
	cmp ax, 100d        ;ax < 100 & ax > 10 = tiene dos digitos
	jb dos
	cmp ax, 1000d       ;ax < 1000 & ax > 100 = tiene tres digitos
	jb tres
	cmp ax, 10000d      ;ax < 10000 & ax > 1000 = tiene cuatro digitos
	jb cuatro
	jmp cinco
dos:
	mov cx, 10d
	jmp divide
tres:
	mov cx, 100d
	jmp divide
cuatro:
	mov cx, 1000d
	jmp divide
cinco:
	mov cx, 10000d
divide:
	cmp cx, 1d 			;divisor = 1, fin de la funcion
	je fin_divide
	xor dx, dx          
	mov ax, bx          ;ax = recibe el numero
	div cx              ;ax = ax / cx
	xor dx, dx
	push bx             ;guarda el valor de bx
	mov bx, 10d        
	div bx              ;ax = ax / 10
	add dl, 48
	mov ds:[si], dl     ;guardo el numero en la string
	inc si              ;si = si + 1
	mov ax, cx          ;ax = divisor
	xor dx, dx
	mov bx, 10d
	div bx              ;ax = divisor / 10
	mov cx, ax          ;cx = divisor
	pop bx				;recupera el valor original en bx
	jmp divide

fin_divide:
	mov ax, bx 			 ;ax = recibe el numero
	mov bx, 10d          ;dl = resto de (ax / 10) = ultimo digito
	div bx               ;dl = ultimo digito
	add dl, 48
	mov ds:[si], dl      ;guarda en ds:[si] el ultimo digito
	mov ds:[si+1], '$'   ;se escribe $ al final de la cadena
	pop bx
	ret
HexToDec ENDP


instalador PROC
	push ds bx
	mov ax, 0
	mov es, ax
	mov ax, OFFSET rsi
	cli
	mov es:[60h * 4], ax
	mov es:[60h * 4 + 2], cs
	sti
	
	mov ax, es:[1Ch * 4]
	mov ds, es:[1Ch * 4 + 2]
	mov ORIGINAL_SEG, ds
	mov ORIGINAL_OFF, ax

	mov ax, 0
	mov es, bx
	mov bx, OFFSET timerRsi
	;cli
	in al, 21h
	or al, 01b
	out 21h, al

	mov es:[1Ch * 4], bx
	mov es:[1Ch * 4 + 2], cs

	and al, 0FEh
	out 21h, al
	;sti

	pop bx ds

	mov bp, ORIGINAL_SEG
	mov si, ORIGINAL_OFF

	mov dx, OFFSET instalador
	int 27h
instalador ENDP


desinstalador PROC
	push ax bx cx dx ds es

	mov cx, 0
	mov ds, cx
	mov es, ds:[60h * 4 + 2]
	mov bx, ds:[60h *4]
	mov cx, es:[bx-2]

	; Validacion de que el RSI este instalado
	cmp cx, firma
	je sigue
	pop es ds dx cx bx ax
	mov ah, 9
	mov dx, OFFSET STATUS_D
	int 21h
	ret
	
	sigue:
	mov bx, es:[2Ch]
	mov ah, 49h ;SE LIBERA SEGMENTO DE RSI DE LA INT 60h
	int 21h
	mov es, bx ;SE LIBERA SEGMENTO DE VARIABLES DE ENTORNO PARA EL RSI DE INT 60h
	int 21h
	
	; PONE A 0 EL VECTOR DE INTERRUPCIONES 60h
	cli
	mov ds:[60h * 4], cx 
	mov ds:[60h * 4 + 2], cx
	sti

	; DEVUELVE EL VECTOR DE INTERRUPCIONES 80h A SU CONTENIDO ORIGINAL
	mov dx, ds:[1Ch * 4 - 2] ; Lectura de la variable global del programa residente
	mov es, dx
	mov dx, ds:[1Ch * 4 - 4] ; Lectura de la variable global del programa residente
	
	; Inhibicion de interrupciones de timer
	in al, 21h
	or al, 01b ;Se hace un OR con 00000001b
	out 21h, al

	mov ds:[1Ch * 4], dx
	mov ds:[1Ch * 4 + 2], es

	and al, 0FEh ;Se hace un AND con 111111110b
	out 21h, al

	
	mov es, ds:[1Ch * 4 + 2]
	mov bx, es:[2Ch]
	mov ah, 49h ;SE LIBERA SEGMENTO DE RSI DE LA INT 80h
	int 21h
	mov es, bx ;SE LIBERA SEGMENTO DE VARIABLES DE ENTORNO PARA EL RSI DE INT 80h
	int 21h

	pop es ds dx cx bx ax
	ret
desinstalador ENDP


estado PROC
	push ds
	mov cx, 0
	mov ds, cx
	mov es, ds:[60h * 4 + 2]
	mov bx, ds:[60h * 4]
	mov cx, es:[bx - 2]

	cmp cx, FIRMA
	pop ds
	je inst
	jmp desinst

	inst:
	mov ah, 9
	mov dx, OFFSET STATUS_I
	int 21h
	jmp aut
	
	desinst:
	mov ah, 9
	mov dx, OFFSET STATUS_D
	int 21h

	aut:
	mov ah, 9
	mov DX, OFFSET AUTORES
	int 21h
	ret
estado ENDP


startup PROC
	mov si, 80h
	mov al, ds:[si]    
	cmp al, 0
	je noparam	

	mov al, ds:[si+3]  
	cmp al, 49h
	je instalar
	cmp al, 44h
	je desinsatalar
	jmp error_param

	noparam:	
	call estado
	jmp fin

	instalar:
	call instalador
	jmp fin

	desinsatalar:
	call desinstalador
	jmp fin
	
	error_param:
	mov ah, 9
	mov dx, offset msg_error
	int 21h

	fin:
	mov ax, 4C00h
	int 21h
startup ENDP

inicio ENDP
codigo ENDS
END inicio
