.286
pila segment stack
    db 32 dup('stck---')
pila ends
datos segment 
    
    salto db 10,13,'$'
    
     imprime db ('El resultado es: '),0AH,0DH,'$' 
     margen dw '$'
datos ends
codigo segment 'code'

Main Proc Far
assume ss:pila,ds:datos,cs:codigo

    push ds
    push 0
    mov ax, datos
    mov ds, ax
    
    ;Establecer modo video (Texto)
    mov ah,00h
    mov al,03h
    int 10H      
    ;Posicionar cursor    
    mov cx,80; (0,80)
    mov ah,02h
    mov dh,0
    mov dl,0
    mov bx,1    

ciclo:  
        mov ah,02h
        int 10H
       
        mov ah,0Ah
        mov al,2Ah ;codigo del caracter a escribir(*)
        mov margen,cx
        mov cx,bx
        int 10H
        
        add dl,1
        mov cx,margen
loop ciclo   
   
mov cx,24
mov ah,02h
mov dh,0;fila
mov dl,79;columna
mov bx,1
ciclo2:
        mov ah,02h
        int 10H
       
        mov ah,0Ah;cadena de simbolos
        mov al,2Ah ;codigo del caracter a escribir(*)
        mov margen,cx;almacena en una variable temporal
        mov cx,bx
        int 10H
        
        add dh,1
        mov cx,margen
loop ciclo2

mov cx,80;0,24
mov ah,02h
mov dh,24;fila
mov dl,79;columna
mov bx,1
ciclo4:
        mov ah,02h
        int 10H
       
        mov ah,0Ah;cadena de simbolos
        mov al,2Ah ;codigo del caracter a escribir(*)
        mov margen,cx;almacena en una variable temporal
        mov cx,bx
        int 10H
        
        sub dl,1
        mov cx,margen
loop ciclo4


mov cx,79;0,24
mov ah,02h
mov dh,0;fila
mov dl,0;columna
mov bx,1
ciclo3:
        mov ah,02h
        int 10H
       
        mov ah,0Ah
        mov al,2Ah
        mov margen,cx
        mov cx,bx
        int 10H
        
        add dh,1
        mov cx,margen
loop ciclo3




ret
    
main ENDP
codigo ENDS
end main
