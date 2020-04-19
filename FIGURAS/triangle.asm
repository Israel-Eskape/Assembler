      CURSOR MACRO VX,VY
        MOV AH, 02H;Posicionar el Cursor
        MOV BH, 0
        MOV DH, VY;Fila
        MOV DL, VX;Columna 
             
        INT 10H
      ENDM

STOCK SEGMENT STACK
    DB 8 DUP ('stack_')
STOCK ENDS
DATAS SEGMENT
      COLX DB 28H
      FILY DB 0
      ACUM DB 1
DATAS ENDS
CODE SEGMENT 'CODE'
    ASSUME SS:STOCK,DS:DATAS,CS:CODE
    
    PRINC PROC FAR
        
        PUSH DS
        PUSH 0
        MOV AX, DATAS
        MOV DS,AX
        
       mov ax,0600h  ;ah 06(es un recorrido), al 00(pantalla completa)
       mov bh,71h    ;fondo blanco(7), sobre azul(1)
       mov cx,0000h  ;es la esquina superior izquierda reglon: columna
       mov dx,184Fh ;es la esquina inferior derecha reglon: columna
       int 10h  ;interrupcion que llama al BIOS

        CURSOR COLX,FILY
        
        MOV CX,20 ;ciclo 1, 20 veces
        
        CICLO_1:;INICIO CICLO 1
            PUSH CX ;guardar valor del ciclo 1
            MOV CL,ACUM ; ciclo 2
            CICLO_2:;INICIO CICLO 2
                MOV AH,2H
                MOV DL,2AH
                INT 21H 
            LOOP CICLO_2 ;FIN CICLO 2
            
            ADD ACUM,2
            INC FILY  
            DEC COLX  
            CURSOR COLX,FILY
            POP CX  ;regresar valor ciclo 1
        LOOP CICLO_1     ;FIN CICLO 1
                    
        RET
    PRINC ENDP

CODE ENDS
END PRINC

                   