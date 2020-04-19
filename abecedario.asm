.286
stock SEGMENT STACK
DB 8 DUP ('stack_')
stock ENDS
datas SEGMENT
    numLetras DB 26
    ACUM DB 65
    ESPACIO db 0AH,0DH,'$'
datas ENDS
code SEGMENT 'CODE'
ASSUME SS:stock,DS:datas,CS:code
Princ Proc Far
    PUSH DS
    PUSH 0
    mov ax, datas
    mov ds,ax
    CALL INICIALIZAR

        ; ALPHABET UPPER LETTER 65-90
        ; ALPHABET LOWER LETTER 97-122

        
        MOV CX,1

        CICLO_1:
            PUSH CX
            MOV CX,0
            MOV CL,numLetras ; ciclo 2 
                CICLO_2:

                    MOV AH,2H
                    MOV DL,ACUM
                    INT 21H
                    INC ACUM
                LOOP CICLO_2 ;fin ciclo_2

                MOV AH,09H  ; SALTO
                LEA DX,ESPACIO
                INT 21H

                DEC ACUM

                MOV CX,0
                MOV CL,numLetras ; ciclo 3
                CICLO_3:

                    MOV AH,02H
                    MOV DL,ACUM
                    INT 21H

                    DEC ACUM
                LOOP CICLO_3 ;fin ciclo_3
                ADD ACUM,33
                MOV AH,09H  ; SALTO
                LEA DX,ESPACIO
                INT 21H
                POP CX
            LOOP CICLO_1
    EXIT:
    MOV AH,4CH
    INT 21H
    RET
Princ ENDP
INICIALIZAR PROC NEAR
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
        
        MOV AX,0
        MOV BX,0
        MOV CX,0
        MOV DX,0
    INICIALIZAR ENDP 
code ENDS
END Princ        
