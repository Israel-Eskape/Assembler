PRINT MACRO mensaje         ;Macro para imprimir el mensaje que recibe como parametro
    MOV AH,09H              
    LEA DX, mensaje
    INT 21H
ENDM
READ MACRO                  ;Macro para leer un caracter del teclado
    MOV AH,01H
    INT 21H
    SUB AL, 30H
ENDM
clear MACRO                 ;Macro para limpiar la pantalla de la consola 
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
    LETRE1 DB 'EL RATON ESTA INSTALADO $'; 
    LETRE2 DB 'EL RATON NO ESTA INSTALADO $'
    LETRE3 DB 'PRIMERO VERIFIQUE QUE ESTE INSTALADO EL MOUSE $'
    LETRE4 DB 'SE MUESTRA EL MOUSE $'
    LETRE5 DB 'PRIMERO MUESTRE EL MOUSE $'
    LETRE6 DB 'SE OCULTA EL MOUSE $'
    LETRE7 DB 'PRESIONE UN BOTON DEL MOUSE'
    LETRE8 DB 'BOTON IZQUIERDO $'
    LETRE9 DB 'BOTON DERECHO $'
    
    FLAG0 DB 1         ;Bandera de si esta o no instalado el mouse
    FLAG1 DB 1         ;Bandera si se muestra o no el mouse
    FLAG2 DB 1         ;Bandera si se oculta o no el mouse

    msgMenu DB '       MOUSE',13,10                       ;Mensaje de Menú de las opciones de la calculadora
        DB '    1.- ACTIVAR   (00H)',13,10
        DB '    2.- MOSTRAR   (01H)',13,10
        DB '    3.- OCULTAR   (02H)',13,10
        DB '    4.- DETECTAR BOTON (03H)',13,10
        DB '    8.- EXIT',13,10,13,10
        DB '    SELECCIONE UNA OPCI?N    $'
sdata ends                      ;End del segmento de Datos
scode SEGMENT 'CODE'            ;Start del segmento de Código
    Assume ss:sstack, ds:sdata, cs:scode
        Princ PROC FAR          ;Start del procedimiento principal
        MOV AX, sdata
        MOV ds, AX	
  
        SUB AX, AX          
        MENU:
        clear
        PRINT msgMenu
        READ

        CMP AL,1
            JE ACTIVAR
        CMP AL,2
            JE MOSTRAR
        CMP AL,3
            JE OCULTAR
        CMP AL,4
            JE DETECTAR
        CMP AL,8
            JE SALIR

        ACTIVAR:
            MOV AX, 0000H           ; Función que inicializa el mouse
            INT 33H                 ; Interrupción del mouse

            CMP AX, 0000H           ; Comparación si se inicializó el mouse.
            JZ IMP2                 ; Si el resultado es 0 salta a imprimir mensaje 2
            JNZ IMP1                ; Si el resultado es diferente a 0 saltar a imprimir mensaje 1

            IMP1:                   ; Etiqueta de imprimir mensaje 1
                clear
                LEA DX, LETRE1      ; Asignarle a DX, el mensaje 1
                MOV AH, 09H         ; Asignarle a AH, la función de imprimir mensaje
                INT 21H             ; Interrupcion 21H activa la funcion en AH
                MOV FLAG0,0
                READ
                ;JMP SALIR               ; Saltar sin condición a la etiqueta salir
        JMP MENU
            IMP2:                   ; Etiqueta de imprimir mensaje 2
                clear
                LEA DX, LETRE2      ; Asignarle a DX el mensaje de El raton esta instalado
                MOV AH, 09H         ; Funcion para imprimir mensaje en consola
                INT 21H             ; Activa la función en AH de imprimir mensaje
                MOV FLAG0,1
                READ
                ;JMP SALIR
        JMP MENU

        MOSTRAR:
            CMP FLAG0,0
            JNE MENS
            MOV FLAG1,0
            MOV AX,01H
            INT 33H
            clear
            PRINT LETRE4
            READ
        JMP MENU
            MENS:
                MOV FLAG1,1
                clear
                PRINT LETRE3
                READ
        JMP MENU

        OCULTAR:
            CMP FLAG1,0
            JNE MENS1
                MOV FLAG2,0
                MOV AX,02H
                INT 33H
                clear
                PRINT LETRE6
                READ
            JMP MENU
            MENS1:
                MOV FLAG2,1
                clear
                PRINT LETRE5
                READ 
        JMP MENU
        DETECTAR:
            CMP FLAG1,0
            JNE MENS1
        JMP MENU
        SALIR:
            MOV AX,4C00H 
            INT 21H

    Princ ENDP          ;END del procedimiento principal 
scode ENDS  ;End del segmento de codigo 
END Princ   
