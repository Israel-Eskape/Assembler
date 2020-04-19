TITLE
.286
STOCK SEGMENT STACK
    DB 8 DUP ('stack_')
STOCK ENDS
DATAS SEGMENT
      COLUMNA DB 20H; columna
      FILA DB 0;
      AUX DB 1
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
        MOV DH, FILA
        MOV DL, COLUMNA       
        INT 10H
        
        MOV AUX2,10
        MOV CL,AUX2

        CICLO1:
            PUSH CX 
            MOV CL,AUX
            CICLO2:
                MOV AH,02H
                MOV DL,'*'
                INT 21H 
            LOOP CICLO2 
            
            ADD AUX,2
            INC FILA  
            DEC COLUMNA  

            MOV AH, 02H;Posicionar el Cursor
            MOV BH, 0
            MOV DH, FILA;Fila
            MOV DL, COLUMNA;Columna           
            INT 10H
            POP CX  
        LOOP CICLO1

        ADD COLUMNA,2
            MOV AH, 02H;Posicionar el Cursor
            MOV BH, 0
            MOV DH, FILA;Fila
            MOV DL, COLUMNA;Columna           
            INT 10H

        SUB AUX,4
        SUB AUX2,1
        MOV CL,AUX2 
        CICLO3: 
            PUSH CX
            MOV CL,AUX 
        CICLO4:
                MOV AH,2H
                MOV DL,'*'
                INT 21H 
        LOOP CICLO4 

            SUB AUX,2
            INC FILA  
            INC COLUMNA  

            MOV AH, 02H;Posicionar el Cursor
            MOV BH, 0
            MOV DH, FILA;Fila
            MOV DL, COLUMNA;Columna           
            INT 10H
            
            POP CX  
        LOOP CICLO3            
        RET
    PRINC ENDP

CODE ENDS
END PRINC