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
    ASSUME SS:STOCK,DS:DATAS,CS:CODE
    
    PRINC PROC FAR
        
        PUSH DS
        PUSH 0
        MOV AX, DATAS
        MOV DS,AX
        
       mov ax,0600h 
       mov bh,01h   
       mov cx,0000h  
       mov dx,184Fh
       int 10h

        MOV AH, 02H
        MOV BH, 0
        MOV DH, FILA
        MOV DL, COLUMNA 
        INT 10H
    
        MOV CX,11 
        CICLO1:
            PUSH CX
            MOV CL,ACUM 
            CICLO2:
                MOV AH,2H
                MOV DL,2AH
                INT 21H

                MOV AH,2H
                MOV DL,32
                INT 21H

                DEC CX
                CMP CX,0
            JNE CICLO2 
            
            CMP FILA,5
            JE REVERS 
            JC NORMAL
            
            REVERS:
                DEC ACUM
                JMP CONTINUE

            NORMAL:
                INC ACUM

            CONTINUE:
            INC FILA  
            
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