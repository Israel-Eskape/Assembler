
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
   
        mov cx,8                ; Se mueve a CX 8 unidades que va hacer la cantidad de veces a repetir el loop
        mov bl,10100001B        ; Se mueve a bl un numero en binario
        rol bl,1                ; Realiza un corrimiento a la izquierda con ROL

    rotar:                      ; Etiqueta donde se va a imprimir el numero en binario del corrimiento 
        rol bl,1                ; Se realiza corrimiento a la izquierda para visualizar los digitos que se van a imprimir
        jc imprime_1            ; Si se realiza acarreo saltar a la etiqueta imprimir 1.
       
    imprime_0:                  ; Se crea la etiqueta imprime_0 
        mov ah,02h              ; Se mueve a ah,02 que es la funcion de imprimir caracter
        mov dl,30h              ; Se mueve a dl el digito 0 
        int 21h                 ; Se llama a la instruccion 21H
        loop rotar              ; Compara si CX = 0, si no, salta a la etiqueta rotar
       
    imprime_1:                  ; Se crea la etiqueta imprime_1
        mov ah,02h              ; Se mueve a ah,02 que es la funcion de imprimir caracter
        mov dl,31h              ; Se mueve a dl el digito 1
        int 21h                 ; Se llama a la instruccion 21H 
        loop rotar              ; Compara si CX = 0, si no, salta a la etiqueta rotar y si es 0 salta a la siguiente linea

salir:                          ; Etiqueta de salir
    mov ax,4c00h                ; Funcion que sale del procedimiento principal
    int 21h                     ; Interrupcion 21H que ejecuta la funcion anterior

    Princ ENDP          ;END del procedimiento principal 
scode ENDS  ;End del segmento de codigo 
END Princ   
