sstack segment stack            ;Start del segmento de pila
    db 32 DUP('stack--') 
sstack ends                     ;End del segmento de pila
sdata segment                   ;Start del segmento de datos
sdata ends                      ;End del segmento de Datos
scode SEGMENT 'CODE'            ;Start del segmento de Código
    Assume ss:sstack, ds:sdata, cs:scode
        Princ PROC FAR                  ;Start del procedimiento principal
        MOV AX, sdata
        MOV ds, AX	

           
    ;Interrupción para limpiar pantalla                       
        mov ax,0600h    
        mov bh,30H       
        mov cx,0000h   
        mov dx,184FH   
        int 10H   
       
    ;posicionar el cursor
        mov ah,02h 
        mov dh, 10   
        mov dl, 10
        mov bh,00h
        int 10h   
       
    ;imprime mensaje.
        ;mov ah,09h
        ;lea dx,msj
        ;int 21h

        mov bl,10100001b        ; Cadena de bits con el cual va a probar los corrimientos
        
recorrer:                       ; Etiqueta donde recorre toda la cadena de bits  
    ;posicionar el cursor             
        mov ah,02h
        mov dl,12
        mov dh,12
        int 10h

        sub cx,cx               ; Resta lo que tiene cx para dejarlo en cero
        mov cx,08h              ; Mueve el tamaño de la cadena de bits a cx que es el numero de ciclos

    rotar:                      ; Etiqueta donde va ir comparando bit por bits si es uno o cero
        rol bl,1                ; Realiza la rotacion a la izquierda de un elemento
        jc imprime_1            ; Si el elemento que rotó es 1 salta a la etiqueta imprime_1 
                                ; Si el elemento que roto es 0 continua con la etiqueta imprime_0
    imprime_0:                  ; Etiqueta donde imprime el bit 0 (cero).
        mov ah,02h              ; Funcion que imprime el digito.
        mov dl,30h              ; Imprime el digito Cero.
        int 21h                 ; Manda a llamar la interrupción 21h
        jmp ultimo              ; Salta a la etiqueta ultimo para realizar el loop

    imprime_1:                  ; Etiqueta imprime_1
        mov ah,02h
        mov dl,31h              ; Imprime el digito 1
        int 21h
    ultimo:
        loop rotar              ; Compara si CX = 0 continua con la ejecucion del siguiente codigo
                                ; Si no es 0 salta a la etiqueta rotar y resta un 1 a CX
       
    pedir:                      ; Pide ←,→ o ESC desde el teclado
        ;mov ah,01h
        ;int 21h
        mov ah,10h              ; Funcion que lee el caracter del teclado 
        int 16h                 ; Interrupcion que controla el teclado de la PC.
       
        cmp ah,4Bh; ←           ; Se realiza una comparación si el caracter ingresado es ←
        je izquierda            ; Si es la flecha Izquierda ← salta a la etiqueta izquierda
       
        cmp ah,4Dh; →           ; Comparacion del caracter ingresado es →           
        je derecha              ; Si el resultado es → entonces salta a la etiqueta derecha
       
        cmp al,1Bh; ESC         ; Compración del caracter ingresado es ESC
        je salir                ; Si esl resultado es ESC salta a la etiqueta salir
        
    jmp pedir                   ; Si no es ninguna de las anteriores salta a la etiqueta Pedir

    izquierda:                  ; Etiqueta izquierda
        rol bl,1                ; Rota la cadena de bits un elemento a la izquierda
jmp recorrer                    ; Salta a la etiqueta recorrer

    derecha:                    ; Etiqueta derecha
        ror bl,1                ; Rotal la cadena de bits un elemento a la derecha
jmp recorrer                    ; Salta a la etiqueta recorrer

salir:                          ; Etiqueta salir                        
    mov ax,4c00h                ; mueve a ax el equivalente la función salir del programa 
    int 21h                     ; Activa la interrupcion 21h

    Princ ENDP          ;END del procedimiento principal 
scode ENDS  ;End del segmento de codigo 
END Princ   
