
PRINT MACRO mensaje
    MOV AH,09H
    LEA DX, mensaje
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
    msgError DB 13,10,'NO SE PUEDE DIVIDIR ENTRE 0 $'
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
                JE MULT
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

            mov ah,02h
            mov dl,bh
            int 21h
    
            mov ah,02h
            mov dl,bl
            int 21h
            
            READ
            JMP MENU
        DIV1:
            JMP DIVI
        RESTA:
            MOV AH,02H
            MOV DX,'2'
            INT 21H

            JMP MENU
        MULT:
            MOV AH,02H
            MOV DX,'3'
            INT 21H

            JMP MENU
        DIVI:
            MOV AH,02H
            MOV DX,'4'
            INT 21H 

            JMP MENU               

       

    Princ ENDP
scode ENDS
END Princ