TITLE
.286
STOCK SEGMENT STACK
    DB 8 DUP ('stack_')
STOCK ENDS
DATAS SEGMENT
    COLUMNA DB 28H
    FILA DB 0
    AUX DB 1
DATAS ENDS
CODE SEGMENT 'CODE'
    ASSUME SS:STOCK,DS:DATAS,CS:CODE   ;CARGAR DATA

    PRINC PROC FAR
    
    PUSH DS                 ;CARGAR DATOS A LA PILA
    PUSH 0
    MOV AX, DATAS
    MOV DS,AX

    MOV ax,0600h 
    MOV bh,01h 
    MOV cx,0000h 
    MOV dx,184Fh 
    INT 10h
    MOV CX,10           ;TAMAÑO DEL TRIANGULO
     
    ADD FILA,10         
    MOV AH, 02H     
    MOV BH, 0       
    MOV DH, FILA      ;Fila
    MOV DL, COLUMNA      ;Columna 
    INT 10H

        CICLO1:       
            PUSH CX    
            MOV CL,AUX                     
            CICLO2:            
                MOV AH,02H       
                MOV DL,'*'
                INT 21H 
                
                DEC CL
                CMP CL,0
            JNE CICLO2
            ADD AUX,2
            DEC FILA
            DEC COLUMNA  
            
            MOV AH, 02H     
            MOV BH, 0       
            MOV DH, FILA      
            MOV DL, COLUMNA     
            INT 10H
            
            POP CX             
            DEC CX
            CMP CX,0
        JNE CICLO1
    RET
PRINC ENDP
CODE ENDS
END PRINC