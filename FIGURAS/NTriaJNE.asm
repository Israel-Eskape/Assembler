 TITLE
.286
STOCK SEGMENT STACK
    DB 8 DUP ('stack_')
STOCK ENDS
DATAS SEGMENT
      COLUMNA DB 20H; columna
      FILA DB 0;fila
      AUX DB 1
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
       MOV AH, 02H;Posicionar el Cursor
        MOV BH, 0
        MOV DH, FILA;Fila
        MOV DL, COLUMNA;Columna           
        INT 10H
        
        MOV CX,10
        CICLO1:
            PUSH CX 
            MOV CL,AUX
            CICLO2:
                MOV AH,2H
                MOV DL,2AH
                INT 21H
                DEC CX
                CMP CX,0
                JNE CICLO2
            
                ADD AUX,2
                INC FILA  
                DEC COLUMNA  

                MOV AH, 02H;Posicionar el Cursor
                MOV BH, 0
                MOV DH, FILA;Fila
                MOV DL, COLUMNA;Columna           
                INT 10H
                POP CX  
            
                DEC CX
                CMP CX,0
        JNE CICLO1
    RET
    PRINC ENDP

CODE ENDS
END PRINC