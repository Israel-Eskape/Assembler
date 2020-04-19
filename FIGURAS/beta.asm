TITLE
.286
STOCK SEGMENT STACK
    DB 8 DUP ('stack_')
STOCK ENDS
DATAS SEGMENT
    COLUMNA DB 28H
    FILA DB 0
    ACUM DB 1
DATAS ENDS
CODE SEGMENT 'CODE'
    ASSUME SS:STOCK,DS:DATAS,CS:CODE   ;CARGAR DATA
    
    PRINC PROC FAR
    
    PUSH DS                 ;CARGAR DATOS A LA PILA
    PUSH 0
    MOV AX, DATAS
    MOV DS,AX
    mov ax,0600h 
       mov bh,01h 
       mov cx,0000h 
       mov dx,184Fh 
       int 10h
    MOV CX,10           ;TAMAÑO DEL TRIANGULO
     
    ADD FILA,10         
    MOV AH, 02H     
    MOV BH, 0       
    MOV DH, FILA      ;Fila
    MOV DL, COLUMNA      ;Columna 
    INT 10H

        CICLO_1:       
            PUSH CX    
            MOV CL,ACUM         
            
            CICLO_2:            
                MOV AH,02H       
                MOV DL,2AH
                INT 21H 
                SIGUE:          ;POS PARA QUE SIGAMOS

            LOOP CICLO_2 
                ABAJO2:
                    ADD ACUM,2
                    DEC FILA
                    DEC COLUMNA  
            
    MOV AH, 02H     
    MOV BH, 0       
    MOV DH, FILA      ;Fila
    MOV DL, COLUMNA      ;Columna 
    INT 10H
        POP CX              ;REGRESAMOS EL VALOR DEL CICLO 1
        LOOP CICLO_1            ;FIN CICLO 1      
    RET
PRINC ENDP
CODE ENDS
END PRINC