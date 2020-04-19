TITLE
.286

STOCK SEGMENT STACK
    DB 8 DUP ('stack_')
STOCK ENDS
DATAS SEGMENT
      COLUMNA DB 20H
      FILA DB 0
      AUX1 DB 1
      AUX2 DB 0
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
       
        MOV AUX2,8
        MOV CX,0
        MOV CL,AUX2
        
        CICLO1:
            PUSH CX 
            MOV CL,AUX1
            CICLO2:
                MOV AH,2H
                MOV DL,'*'
                INT 21H 
            LOOP CICLO2
            
            ADD AUX1,2
            INC FILA  
            DEC COLUMNA  
            
            MOV AH, 02H;Posicionar el Cursor
            MOV BH, 0
            MOV DH, FILA;Fila
            MOV DL, COLUMNA;Columna              
            INT 10H

            POP CX  
        LOOP CICLO1  

        ADD COLUMNA,1        
        MOV FILA,3
        
        MOV AH, 02H;Posicionar el Cursor
        MOV BH, 0
        MOV DH, FILA;Fila
        MOV DL, COLUMNA;Columna              
        INT 10H

        SUB AUX1,2
        MOV CX,0
        
        MOV CL,AUX2 
        CICLO3:
           PUSH CX 
            MOV CL,AUX1 
        CICLO4:
                MOV AH,2H
                MOV DL,'*'
                INT 21H 
        LOOP CICLO4 ;FIN CICLO 

            SUB AUX1,2
            INC FILA  
            INC COLUMNA  
    
            MOV AH, 02H;Posicionar el Cursor
            MOV BH, 0
            MOV DH, FILA;Fila
            MOV DL, COLUMNA;Columna              
            INT 10H
            
            POP CX  
        LOOP CICLO3  ;FIN CICLO 
        RET
    PRINC ENDP

CODE ENDS
END PRINC           