PRINT MACRO mensaje
    MOV AH,09H
    LEA DX, mensaje
    INT 21H
ENDM
PRINTDIG MACRO digito
    MOV AH,02H
    MOV DL,digito
    INT 21H
ENDM
READ MACRO 
    MOV AH,01H
    INT 21H
    SUB AL, 30H
ENDM
CLEAN MACRO
    ;Establecer modo video (Texto)
    MOV AH,00H
    MOV al,03H
    INT 10H      
    ;Posicionar cursor    
    MOV cx,7; (0,80)
    MOV AH,02H
    MOV dH,0
    MOV dl,20
    MOV bx,1  
ENDM

sstack segment stack  
    db 32 DUP('stack--') 
sstack ends  
sdata segment
    msgMenu DB '   CALCULADORA',13,10
        DB '1.- SUMA',13,10
        DB '2.- RESTA',13,10
        DB '3.- MULTIPLICACI?N',13,10
        DB '4.- DIVISI?N',13,10
        DB '5.- EXIT',13,10,13,10
        DB 'SELECCIONE UNA OPCI?N    $'
    msgDig DB 13,10,'INGRESE UN DIGITO  ','$'
    msgRes DB 13,10,'EL RESULTADO = ','$'
    msgOpIN DB 13,10,'OPCION INVALIDA $'
    msgError DB 13,10,10,'          ERROR NO SE PUEDE DIVIDIR ENTRE 0 $'
sdata ends 
scode SEGMENT 'CODE'
    Assume ss:sstack, ds:sdata, cs:scode
    Princ PROC FAR
        MOV AX, sdata
        MOV ds, AX	

        MENU:           
            CLEAN 
            PRINT msgMenu
            READ
            
            CMP AL,1
                JE SUMA
            CMP AL,2
                JE RESTA
            CMP AL,3
                JE MULT1
            CMP AL,4
                JE DIV1
            CMP AL,5
                JE SALIR
            
             SALIR:
            MOV AH,04ch
            INT 21h

            MOV AH,09H
            LEA DX,msgOpIN
            INT 21H
        JMP MENU
        SUMA:
            CLEAN
            
            PRINT msgDig
            READ
            
            MOV BL,AL

            PRINT msgDig
            READ
            
            ADD AL,BL
            AAA
            
            OR AX,3030H
            MOV BX,AX
            SUB BH,01H
            
            PRINT msgRes
            PRINTDIG BH
            PRINTDIG BL  

            READ
            JMP MENU
        DIV1:
            JMP DIVI
        MULT1:
            JMP MULT
        RESTA:      
            CLEAN
            PRINT msgDig
            READ
            MOV BL,AL
            PRINT msgDig
            READ
            CMP BL,AL
                JB CAMBIAR
            SIGUIENTE:
            SUB BL,AL
            
            ADD BL,30H
            PRINT msgRes
            PRINTDIG BH
            PRINTDIG BL
            READ
            JMP MENU
            CAMBIAR:
                MOV CL,AL
                MOV AL,BL
                MOV BL,CL
                MOV BH,45
            JMP SIGUIENTE
        MULT:
            CLEAN
            PRINT msgDig
            READ
            MOV BL,AL
            PRINT msgDig
            READ
            MUL BL
            PRINT msgRes
            AAM
            MOV BX,AX
            ADD BX,3030H
            PRINTDIG BH
            PRINTDIG BL

            READ
            JMP MENU
        DIVI:
            CLEAN
            PRINT msgDig
            READ
            MOV BL,AL
            PRINT msgDig
            READ
            CMP AL,0
                JE ERROR
            CMP AL,BL
                JA DIVM

            MOV BH,AL
            MOV AL,BL
            MOV AH,00H
            DIV BH
            MOV BL,AL
            MOV CH,AH
            
            ADD BX,3030H
            ADD CH,30H

            PRINT msgRes
            
            PRINTDIG BL
           
            MOV BL,CH
            CMP BL,30H
                JE SIGUIENTEDIV
            PRINTDIG 2CH
            PRINTDIG CL

            CALL FRACCION

            SIGUIENTEDIV:
            READ
            JMP MENU               
        
            DIVM:
                MOV BH,AL
                ADD BX,3030H
                PRINT msgRes
                CALL FRACCION
            JMP SIGUIENTEDIV

            ERROR:
                PRINT msgError
            JMP SIGUIENTEDIV
    Princ ENDP
    FRACCION PROC
        PRINTDIG BL
        PRINTDIG 2FH
        PRINTDIG BH
        RET
    FRACCION ENDP
scode ENDS
END Princ