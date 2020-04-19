TITLE
.286

IMPRIMIR MACRO CADENA
    MOV AH,09H      
    LEA DX,CADENA
    INT 21H
 ENDM

POSICURSOR MACRO X,Y
    MOV AH, 02H     
    MOV BH, 0       
    MOV DH, Y      ;Fila
    MOV DL, X      ;Columna 
    INT 10H
ENDM

STOCK SEGMENT STACK
    DB 8 DUP ('stack_')
STOCK ENDS
DATAS SEGMENT

    MESSAGE DB '1.-TRIANGULO',0DH,0AH,'2.-INVERTIDO',0DH,0AH,'3.-IZQUIERDA',0DH,0AH,'4.-DERECHA',0DH,0AH,'5 lEXIT',0DH,0AH,'$'
    OPCION DB 'OPCION: ','$'
    MESSAGE_DIALOG DB 'CARACTER NO VALIDO','$'
    TIPO DB 0
    
    COLX DB 28H
    FILY DB 0
      
    ACUM DB 1
    VALUE DB 0
 
DATAS ENDS

CODE SEGMENT 'CODE'
    ASSUME SS:STOCK,DS:DATAS,CS:CODE   ;CARGAR DATA
    
    PRINC PROC FAR
    
    PUSH DS                 ;CARGAR DATOS A LA PILA
    PUSH 0
    MOV AX, DATAS
    MOV DS,AX

    CALL PIDEDATOS        ;PIDE DATOS
        
    EXIT:          ;FINALIZA EL PROGRAMA
        MOV AH,4CH
        INT 21H

    BREAK:              ;REINICIA EL PROGRAMA
        MOV COLX,28H
        MOV FILY,0
        MOV ACUM,1
        MOV VALUE,0
        POSICURSOR 0,15
        CALL PIDEDATOS
    RET
PRINC ENDP


PIDEDATOS PROC NEAR 
    IMPRIMIR MESSAGE             
    IMPRIMIR OPCION     
    CALL CONVERT                    
    MOV TIPO,AL                
    CALL CLEAR              
    CALL INIT                       
    RET
PIDEDATOS ENDP

CONVERT PROC NEAR
    MOV AH,01H
    INT 21H
    SUB AL,30H
    RET
CONVERT ENDP

CLEAR PROC NEAR
    ;Establecer modo video (Texto)
    mov ah,00h
    mov al,03h
    int 10H      
    ;Posicionar cursor    
    mov cx,7; (0,80)
    mov ah,02h
    mov dh,0
    mov dl,20
    mov bx,1  
    RET
CLEAR ENDP

INIT PROC NEAR                                             
    MOV CX,10           ;TAMAÑO DEL TRIANGULO
    CMP TIPO,1     
        JE NORMAL
    CMP TIPO,2     
        JE ABAJO
    CMP TIPO,3     
        JE IZQUIERDA            
    CMP TIPO,4     
        JE IZQUIERDA         
    CMP TIPO,5     
        JE SALIR        
     
    IZQUIERDA:                     
        MOV VALUE,10       
        MOV CX,11           ;CANTIDAD DE VECES QUE SE HARÁ EL CICLO
        JMP NORMAL          

    ABAJO:             ;INICIALIZA VALORES PARA VOLTEAR EL TRIANGULO
        ADD FILY,10         
        JMP NORMAL      
    SALIR:             
        JMP EXIT
        
    NORMAL:            
        POSICURSOR COLX,FILY

        CICLO_1:       
            PUSH CX    
            MOV CL,ACUM         
            
            CICLO_2:            
                MOV AH,02H       
                MOV DL,2AH
                INT 21H 

                CMP TIPO,3 ;SI ES A LA IZQUIERDA VAMOS A IMPRIMIR CON ESPACIO
                    JE ADS
                    
                CMP TIPO,4 ;LO MISMO QUE ARRIBA
                    JE ADS      
                    JMP SIGUE

                        ADS:    ;AQUI IMPRIMIMOS LOS ESPACIOS
                        MOV AH,2H
                        MOV DL,32
                        INT 21H
                SIGUE:          ;POS PARA QUE SIGAMOS

            LOOP CICLO_2 

            CMP TIPO,4   
            JE RIGHT

            CMP TIPO,3
            JE IZQUIERDA2

            CMP TIPO,2
            JE ABAJO2

            CMP TIPO,1
            JE NORMAL2

                ABAJO2:
                    ADD ACUM,2
                    DEC FILY
                    DEC COLX  
                    JMP CONTINUE

                NORMAL2:
                    ADD ACUM,2
                    DEC COLX  
                    INC FILY
            
            CONTINUE:
            POSICURSOR COLX,FILY
            POP CX              ;REGRESAMOS EL VALOR DEL CICLO 1
        LOOP CICLO_1            ;FIN CICLO 1
        
        JMP BREAK               ;SE TERMINA DE DIBUJAR EL TRIANGULO, REINICIAMOS

        RIGHT:
            CMP FILY,5
            JGE CHANGER 
            JC NORMALR
            
            CHANGER:
                DEC ACUM
                JMP CONTINUER
            
            NORMALR:
                INC ACUM
            
            CONTINUER:
                INC FILY
            
            JMP CONTINUE 

        IZQUIERDA2:
            CMP FILY,5
            JGE CHANGE 
            JC  FLUJ
            
            CHANGE:
                DEC ACUM
                INC COLX 
                INC COLX 
                JMP NEXT

            FLUJ:
                DEC COLX
                DEC COLX
                INC ACUM

            NEXT:
            INC FILY
            JMP CONTINUE
    RET
    INIT ENDP

CODE ENDS
END PRINC

                   