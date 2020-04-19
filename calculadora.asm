PRINT MACRO mensaje         ;Macro para imprimir el mensaje que recibe como parametro
    MOV AH,09H              
    LEA DX, mensaje
    INT 21H
ENDM
PRINTDIG MACRO digito       ;Macro para imprimir un caracter que recibe como parametro
    MOV AH,02H
    MOV DL,digito
    INT 21H
ENDM
READ MACRO                  ;Macro para leer un caracter del teclado
    MOV AH,01H
    INT 21H
    SUB AL, 30H
ENDM
CLEAN MACRO                 ;Macro para limpiar la pantalla de la consola 
    ;Establecer modo video (Texto)
    MOV AH,00H
    MOV AL,03H
    INT 10H      
    ;Posicionar cursor    
    MOV CX,7; (0,80)
    MOV AH,02H
    MOV DH,0
    MOV DL,20
    MOV BX,1  
ENDM

sstack segment stack            ;Start del segmento de pila
    db 32 DUP('stack--') 
sstack ends                     ;End del segmento de pila
sdata segment                   ;Start del segmento de datos
    msgMenu DB '       CALCULADORA',13,10                       ;Mensaje de Menú de las opciones de la calculadora
        DB '    1.- SUMA',13,10
        DB '    2.- RESTA',13,10
        DB '    3.- MULTIPLICACI?N',13,10
        DB '    4.- DIVISI?N',13,10
        DB '    5.- EXIT',13,10,13,10
        DB '    SELECCIONE UNA OPCI?N    $'
    msgDig DB 13,10,'   INGRESE UN DIGITO  ','$'                ;Muestra el mensaje al momento de ingresar un digito
    msgRes DB 13,10,10,'       EL RESULTADO = ','$'             ;Muestra el mensaje cuando va a mostrar el resultado
    msgOpIN DB 13,10,'              OPCION INVALIDA $'                      ;Muestra el mensaje cuando ingresa un numero diferente a la de las opciones
    msgError DB 13,10,10,'          ERROR NO SE PUEDE DIVIDIR ENTRE 0 $'    ;Muestra el mensaje cuando en la division el segundo numero es cero
sdata ends                      ;End del segmento de Datos
scode SEGMENT 'CODE'            ;Start del segmento de Código
    Assume ss:sstack, ds:sdata, cs:scode
    Princ PROC FAR                  ;Start del procedimiento principal
        MOV AX, sdata
        MOV ds, AX	

        MENU:                       ;Etiqueta de Menú
            CLEAN                   ;LLamada a la Macro de nombre CLEAN para limpiar la pantalla de la consola
            PRINT msgMenu           ;LLamada a la Macro de imprimir mensaje y se le manda como parametro la cadena del Menu
            READ                    ;LLamada a la Macro READ y espera una entrada al teclado y lo guarda en el registro AL 
            
            CMP AL,1                ;Compara el digito que se guardó en AL con el 1
                JE SUMA             ;Si es 1 salta a la etiqueta Suma donde se realiza la suma
            CMP AL,2                ;Compara el digito que se guardó en AL con el 2
                JE RESTA            ;Si es 2 salta a la etiqueta Resta donde se realiza resta
            CMP AL,3                ;Compara el digito que se guardó en AL con el 3
                JE MULT1            ;Si es 3 salta a la etiqueta Mult 
            CMP AL,4                ;Compara el digito que se guardó en AL con el 4
                JE DIV1             ;Si es 4 salta a la etiqueta DIV1 
            CMP AL,5                ;Compara el digito que se guardó en AL con el 5
                JE SALIR            ;Si es 5 salta a la etiqueta salir Se sale del programa SI y SOLO SI es la opcion 5
            
                                    ;Si el caracter ingresado no corresponde a ninguno
            PRINT msgOpIN           ;hace la llamada a la Macro PRINT donde se le envia como parametro el mensaje de opcion invalida
            READ
            JMP MENU                ;Realiza un salto a la etiqueta menú para mostrar el menú y elegir una opción valida

             SALIR:                 ;Etiqueta para salir del programa
                MOV AH,04CH             
                INT 21h

        SUMA:                       ;Start de la etiqueta de Suma
            CLEAN                   ;Limpiamos la pantalla de la consola
            
            PRINT msgDig            ;LLamamos a la Macro PRINT para mostrar el mensaje de ingresar un digito
            READ                    ;LLamamos a la Macro READ para ingresar el primer digito a sumar
            
            MOV BL,AL               ;Respaldamos en BL el digito ingresado

            PRINT msgDig            ;Mostramos el mensaje de ingresar digito
            READ                    ;Obtenemos el digito ingresado
            
            ADD AL,BL               ;con ADD se realiza la suma     ;   AL = AL + BL
            AAA                     ;Realizamos un ajuste de la suma
            
            OR AX,3030H             ;Se suman 30H al registro AL y AH
            MOV BX,AX               ;Se respalda el registro AX en el registro BX
            SUB BH,01H
            
            PRINT msgRes            ;Se muestra el mensaje de el resultado de la suma 
            PRINTDIG BH             ;Imprimimos el digito de las centenas guardadas en el registro BH
            PRINTDIG BL             ;Imprimimos el digoto de la unidad guadada en el registro BL

            READ                    ;Para ver el mensaje del resultado tendremos que ingresar un caracter para avanzar
            JMP MENU                ;Saltamos a la etiqueta Menu. END Suma 

        DIV1:                       ;Etiqueta para hacer un puente entre la etiqueta del menu y
            JMP DIVI                ;donde se va a realizar la division
        MULT1:                      ;Etiqueta para hacer un puente entre la etiqueta del menu y 
            JMP MULT                ;donde se va a realizar la multiplicación

        RESTA:                      ;Start de la Resta
            CLEAN                   
            PRINT msgDig
            READ
            MOV BL,AL
            PRINT msgDig
            READ
            CMP BL,AL               ;Comparamos los digitos ingresado 
                JB CAMBIAR          ;Si resulta que el segundo digito es mayor que el primero saltamos a la etiqueta cambiar
            
            SIGUIENTE:              
            SUB BL,AL               ;Con SUB se realiza la resta BL = BL - AL
            
            ADD BL,30H              ;Se suma 30H para obtener el numero correspondiente en Hexadecimal
            PRINT msgRes            
            PRINTDIG BH
            PRINTDIG BL
            READ
            JMP MENU                ;Saltamos a la etiqueta del Menu.   End de Resta
            CAMBIAR:                ;Start cambiar para realizar la resta del numero mayor menos el numero menor
                MOV CL,AL           ; Respaldamos en CL el segundo digito ingresado
                MOV AL,BL           ; Movemos al registro AL el primer digito ingresado
                MOV BL,CL           ; Movemos al registro BL el registro respaldado en CL
                MOV BH,45           ; El número 45 corresponde al simbolo - (menos) como cambiamos los registros 
                                    ; entonces el resultado debe de ser negativo
            JMP SIGUIENTE           ; Saltamos a la etiqueta siguiente para continuar con la restal de los registros.
                                    ;End etiqueta cambiar

        MULT:                       ;Start de la Multiplicacion 
            CLEAN       
            PRINT msgDig
            READ
            MOV BL,AL
            PRINT msgDig
            READ
            MUL BL                  ;con MUL se realiza la multiplicacion de los registros AL = AL * BL
            PRINT msgRes
            AAM                     ; Se realiza el ajuste para la multiplicacion
            MOV BX,AX               ; Respaldamos el resultado AX en el registro BX
            ADD BX,3030H
            PRINTDIG BH
            PRINTDIG BL

            READ
            JMP MENU                ;Saltamos a la etiqueta del Menu.   End Multiplicación
            
        DIVI:                       ;Start de la División
            CLEAN
            PRINT msgDig
            READ
            MOV BL,AL
            PRINT msgDig
            READ
            CMP AL,0                ;Comparamos el segundo digito ingresado con 0
                JE ERROR            ;No se puede dividir entre 0 entonces saltamos a la etiqueta ERROR
            CMP AL,BL               ;Comparamos si el segundo digito con el primer digito 
                JA DIVM             ;Si el segundo digito es menor Saltamos a la etiqueta DIVM

            MOV BH,AL               ;Respaldamos el segundo digito en el registro BH
            MOV AL,BL               ;Movemos el primer digito al registro AL
            MOV AH,00H              ;Restablecemos el valor del registro AH en ceros
            DIV BH                  ;con DIV se realiza la division AL = AL / BH ; en AL se guarda el cociente y en AH se guarda el residuo
            MOV BL,AL               ;Respaldamos el cociente de la division en el registro BL
            MOV CH,AH               ;Respaldamos el residuo de la division en el registro CH
            
            ADD BX,3030H            ;Sumamos 30H al registro de BX para tener su valor en Hexadecimal
            ADD CH,30H              ;Sumamos 30H al registro de CH para tener su valor en Hexadecimal

            PRINT msgRes            ;Mostramos en pantalla el mensaje de resultado
            
            PRINTDIG BL             ;Imprimimos el cociente de la division
           
            CMP CH,30H              ;Comparamos el residuo con 0 en decimal
                JE SIGUIENTEDIV     ;Si resulta que la comparación si es cero se termina la operacion de la division 
                                
            PRINTDIG 2BH            ;Imprime el simbolo de + es igual a 2BH  
            MOV BL,CH               ;Movemos al registro BL el residuo, para poder utilizarlo en el procedimiento de imprimir Fraccion
            CALL FRACCION           ;LLama al procedimiento donde va a imprimir el residuo y dividendo
                                    ; para tener el resultado de todos sus digitos reales
            SIGUIENTEDIV:           
            READ                    ;Espera un caracter del teclado 
            JMP MENU                ;Saltamos a la etiqueta del Menu.   End de la Division
        
            DIVM:                   ;Start de la etiqueta DIVM
                MOV BH,AL           ;Movemos a BH el valor del segundo digito para poder utilizar el procedimiento FRACCION 
                ADD BX,3030H        ;Sumamos a todo el registro BX 30H para tener su valor en Hexadecimal
                PRINT msgRes        ;Mostramos el mensaje de resultado 
                CALL FRACCION       ;LLamamos al procedimiento FRACCION para imprimir el resultado en forma de fraccion 
            JMP SIGUIENTEDIV        ;Saltamos a la etiqeuta SIGUIENTEDIV.   End DIVM

            ERROR:                  ;Start de la etiqueta ERROR
                PRINT msgError      ;Imprime en pantalla el mensaje de error que no se puede dividir entre de cero
            JMP SIGUIENTEDIV        ;Salta a la etiqueta SIGUIENTEDIV.  End ERROR
    Princ ENDP          ;END del procedimiento principal 
    
    FRACCION PROC       ;Start del procedimiento de FRACCION imprime en forma de fraccion BL/BH
        PRINTDIG BL     ;Imprime el registro BL
        PRINTDIG 2FH    ;Imprime el simbolo / que su correspondiente en Hexadecimal es 2FH 
        PRINTDIG BH     ;Imprime el registro BH
        RET             ;Indica un retorno del procedimiento
    FRACCION ENDP       ;End del procedimiento FRACCION
scode ENDS  ;End del segmento de codigo 
END Princ   
;#Israel-Eskape
;e^(i*PI)+1 =0