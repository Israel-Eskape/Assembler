title
.286
pila segment stack
    db 32 dup('stack_')
pila ends

data segment
    sies db 'Palidrimo$'
    noes db 'No Palidromo$'
    ;cadena db 'cama$'
    cadena db 'ama$'
    long_letre equ $-cadena
data ends

code segment para 'code'
inicio proc far

    assume cs:code,ds:data,ss:pila

    push ds
    push 0
    mov ax,data
    mov ds,ax

    lea si,cadena
    lea di,[cadena+long_letre-2]
    mov al,[si]
    mov ah,[di]

    cmp al,ah

    jne nopali

    inc si
    dec di

    mov al,[si]
    mov ah,[di]

    cmp al,ah

    je palidromo

    nopali:

    mov ah,09h
    lea dx,noes
    int 21h

    jmp salir

    palidromo:

    mov ah,09h
    lea dx,sies
    int 21h
    salir:
    mov ax,4c00h
    int 21h

inicio endp
code ends
end inicio