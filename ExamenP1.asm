extern _printf
extern _ExitProcess@4
extern _scanf
extern _atoi

section .data
    msg: db "Ingrese entre 10 y 100 valores numericos, separador por comas (,): ",10,0
    formatoEntrada: db "%s",0
    formatoSalida: db "El valor ingresado es %s", 10, 0
    msgError: db "Error! Debe ingresar entre 10 y 100 valores numeros y deben estar separados de comas (,)",10,0
    count: dd 0
    showInt: db "[%d]",0
    
section .bss
    input: rest 100
    valor: resb 8
    arreglo: resd 100
    
section .text
    

section .text
    global _main
    
 _main:
    mov ebp, esp; for correct debugging   

    ;Imprime mensaje inicial
    push msg
    call _printf
    add esp,4
    
    ;Toma el input del usuario
    push input
    push formatoEntrada
    call _scanf
    add esp,8
leerString:

    xor esi, esi; recorre string
    xor edi, edi; lee comas
    mov [count], edi; resets el valor del count
    
findNum:
    mayorIgualCero:
        xor ebx, ebx
        mov bl, [input + esi]; parte baja de ebx
        cmp ebx, 48
        jge menorIgualNueve
        jl esComa
            
    menorIgualNueve:   
        cmp ebx, 57
        jle guardarNumero ; brinca a guardar el numero porque está entre 48 y 57
        
    esComa:
        cmp ebx, 44        
        je convetir
        cmp ebx, 0
        je fin
        jne pedirNuevoArreglo            

    guardarNumero:
        mov [valor + edi], bl
        inc esi
        inc edi
        jmp findNum
    
    convetir:
        xor eax, eax ;limpiar memoria
        push valor ;contiene el valor en decimal       
        call _atoi ; pasa lo que esta en valor como numero
        add esp, 4 
        xor edx,edx       
        mov edx, [count]
        mov dword [arreglo + edx*4], eax
        add dword [count],1 
        inc esi       
        jmp restablecerCero

    restablecerCero:
        xor ebx, ebx
        xor edi, edi
        mov ecx, 8
        ciclo:
            push ecx
            mov [valor + edi], bl
            inc edi
            pop ecx
        loop ciclo
        xor edi, edi
        jmp findNum
        
    pedirNuevoArreglo:
        push msgError
        call _printf
        add esp, 4        
        jmp _main
        
    fin:
        xor eax, eax
        push valor ;contiene el valor en decimal       
        call _atoi ; pasa lo que esta en valor como numero
        add esp, 4 

        mov edx, [count]
        mov dword [arreglo + edx * 4], eax
        inc dword [count] 
        
        mov edx, [count]
        cmp edx, 10
        jl pedirNuevoArreglo
        cmp edx, 100
        jg pedirNuevoArreglo
        

   call sort
   call print
 
   ;Sale del programa: 
   push dword 0
   call _ExitProcess@4
   
   print:
       inc dword [count]
       mov ecx, [count]
       xor esi, esi
       ciclo3:
           push ecx
           mov ebx, [arreglo + esi*4]
           push ebx
           push showInt
           call _printf
           add esp,8
           inc esi
           pop ecx
       loop ciclo3
       
   ret
   
   sort:
    mov ecx, [count]
    xor edi, edi
    mov esi, 1
    dec dword [count] 
     
   externo:
    push ecx
    mov ecx, [count]
        
   interno:
    mov eax, [arreglo+ edi * 4]
    cmp eax, [arreglo+ esi * 4]
    jle finloopinterno
    
    ;intercambiar
    mov ebx, [arreglo+ esi * 4]
    mov [arreglo+ edi * 4], ebx
    mov [arreglo+ esi * 4], eax

   finloopinterno:
    inc edi
    inc esi
    loop interno
    pop ecx
    xor edi, edi
    mov esi, 1
    loop externo
    
   ret