
sstack segment stack  
    db 32 DUP('stack--') 
sstack ends  

sdata segment
	cadena db '1945863189589753355','$' ; la variable cadena donde va a contener el mensaje que vamos analizar
    NUM equ $-cadena    ; Donde se guardará el tamaño de la cadena
   ordenado db 10,13,'Numeros ordenados ',' $'  ; Mensaje que mostrará en pantalla 

sdata ends 

scode SEGMENT 'CODE'
    Assume ss:sstack, ds:sdata, cs:scode
    Princ PROC FAR
        MOV AX, sdata
        MOV ds, AX	
        MOV DX,0000H    ; inicializamos DX en ceros

        MOV CX,NUM    ; movemos a cx, el valor del tamaño de la cadena 
        SUB CX,2
        FORX:           ; creamos etiqueta FORX
            LEA SI,cadena   ; posicionar SI en el inicio de la cadena
            PUSH CX             ; guardamos en la pila el valor de cx
            MOV CX,NUM                 ; movemos el tamaño del arreglo a cx
            SUB CX,2                    ; restamos a CX un 2
            FORY:                       ; etiqueta de FOR Y
                MOV DL,[SI]             ; movemos al registro DL el valor de la posicion de SI dentro de la cadena
                CMP DL,[SI+1]           ; comparamos el valos de DL con la posicion mas 1
                
                JA ORDENAR              ; si la comparacion resulta que es mejor se va a la etiqueta ordenar
                CONTINUAR:              ; una etiqueta que continua despues de ordenar 
                INC SI                  ; incrementa la posicion en la cadena
            LOOP FORY                   ; realiza el ciclo mientras se cumpla la condicion del ciclo FOR Y
            POP CX                      ; extrae de la pila el valor de CX
        LOOP FORX                       ; realiza el ciclo mientra se cumpla la condicion del LOOP y la etiqueta FOR X
        
        MOV AH, 09H                     ; Mueve al registro AH la funcion 09H de la interrupcion 21h
        LEA DX, ordenado                ; Mueve a DX lo que va a mostrar en consola 
        INT 21H                         ; activa la interrupcion 21H

        MOV AH, 09H
        LEA DX, cadena
        INT 21H

        SALIR:
            mov ax,4c00h    ;movemos a ax, para salirnos de programa 
            int 21h         ;activamos la interrupcion 21h

        ORDENAR:                        ; etiqueta ordenar si se cumple la comparacion de la linea 29 
            MOV DH,[SI+1]               ; Movemos al registro DH el valor de la cadena en la posicion SI + 1
            MOV [SI],DH                 ; Movemos a la posicion actual el valor de DH
            MOV [SI+1],DL               ; y a la posicion actual mas uno el valor de de DL 
        JMP CONTINUAR                   ; sin condicion salta a la etiqueta continuar
    Princ ENDP
scode ENDS

END Princ