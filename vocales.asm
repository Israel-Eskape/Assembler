.286
pila segment stack  
    db 32 DUP('stack--') 
pila ends  

datos segment
	;cadena db 'Lenguajes de interfaz','$'
	cadena db 'israel eskape','$'
    num equ $-cadena    ; es donde se guardará el tamaño de la cadena
	tiene db 10,13,'tiene un total de vocales:  $'  ; Solo es un mensaje que mostrará en pantalla 
	total db '  $'    ; Se guardará el total de las vocales que encuentre el programa.
    
datos ends 


codigo segment 'code'  
    assume ss:pila,ds:datos,cs:codigo
      main proc far
    
    mov ax,datos       
	mov ds,ax
	
	lea si,cadena   ; posicionamos el indice al inicio de la cadena
	mov dx,0000h    ; inicializamos dx en ceros 
	
	mov cx,num      ; movemos a cx la variable num que contiene el tamanio total de cadena 
    eti:            ; creamos una etiqueta con el nombre eti
    	mov al,[si]                 ; movemos al registro al, lo que tiene el registro indice del array
		cmp al,61h        ;a        ; comparamos el registro al, con el valor 61 eh hexadecimal  que en decimal es la letra
		je vocal                    ; si el resultado de la comparacion da como resultado cero en la bandera entonces saltamos a la etiqueta vocal
		cmp al,65h        ;e        ; si no, ahora comparamos con 65H que en decimal es la letra e
		je vocal                    ; si el resultado de la comparacion da como resultado cero en la bandera entonces saltamos a la etiqueta vocal
		cmp al,69h        ;i        ; si no, ahora comparamos con 69H en decimal es la letra i
		je vocal                    ; si el resultado de la comparacion da como resultado cero en la bandera entonces saltamos a la etiqueta vocal
		cmp al,6fh        ;o        ; si no, comparamos con 6FH que es la letra o en decmimal.
		je vocal                    ; si el resultado de la comparacion da como resultado cero en la bandera entonces saltamos a la etiqueta vocal
		cmp al,75h        ;u        ; por ultimo comparamos con 75H que es la letra u en decimal
		je vocal                    ; si el resultado de la comparacion da como resultado cero en la bandera entonces saltamos a la etiqueta vocal
		regresa:                    ; creamos etiqueta regresa 
			inc si                  ; incrementa en 1 el indice 
	loop eti                        ; mientras no sea cero cx, se repite el ciclo y salta a la etiqueta eti
	
	lea si, total   ;movemos lo que tiene el indice a la variable total
	mov ax,dx       ;movemos lo que tiene el registro dx al registro ax
	aaa             ;realizamos un ajuste a la suma
	add ah,30h      ;sumamos 30H al lo que tiene el registro a en la parte alta
	mov [si],ah     ;movemos lo que tiene el registro ah al registro indice
	inc si          ;incrementamos 1 al si
	add al,30h      ;sumamos 30H a lo que tiene el registro a en la parte baja
	mov [si],al     ;movemos el registro al al registro indice 
	
	lea dx,cadena   ;movemos al registro dx la variable cadena el cual contiene nuestro arreglo
	mov ah,09h      ;movemos a ah,09h que manda a llamar la funcion de imprmir en pantalla
	int 21h         ;activamos la interrupcion 21h e imprme en pantala el mensaje de cadena
	
	lea dx,tiene    ;movemos al registro dx la variable tiene el cual es un mensaje declarado en el segmento de datos
	mov ah,09h      ;movemos a ah,09h que manda a llamar la funcion de imprimir en pantalla
	int 21h         ;activamos la interrupcion 21h e imprimimo en pantalla el mensaje que tiene 'tiene'+
	
	lea dx,total    ;Obtenemos el valor de total y lo guardamos en dx.
	mov ah,09h      ;movemos a ah,o9h que manda a llamada a la funcion de imprimir en pantalla
	int 21h         ;activamos la interrupcion 21h e imprimimos en pantalla el total que tienen vocales
	jmp salir       ;cuando llegamos a esta linea saltamos a la etiqueta salir
	
	vocal:          ;creamos etiqueta vocal
		inc dl      ;incrementamos el registro dl 
		jmp regresa ;saltamos a la etiqueta regresa declarada en la linea 41.
	
	salir:          ;creamos etiqueta salir
    mov ax,4c00h    ;movemos a ax, para salirnos de programa 
    int 21h         ;activamos la interrupcion 21h 
codigo ends         ;final del segmento de codigo
end main            ;final del main
;Eskape




    