extern _ExitProcess@4
extern _printf
extern _scanf

    size equ 4

section .data
    msgA: db "Gano el jugador 1",10,0
    msgB: db "Gano el jugador 2",10,0
    msgC: db "Nadie ha ganado aun",10,0
    msgD: db "El juego termino sin que nadie ganara",10,0
    
    cambioLinea: db 10,0
    formato: db " %c ",0
    count: dw 0
    vertical: dw 4

section .bss 
    gato: resw 9
    
section .text
    global _main
    
    _main:
    mov ebp, esp; for correct debugging
    
    mov dword [gato + 0], 49
    mov dword [gato + 4], 49
    mov dword [gato + 8], 53    
    mov dword [gato + 12], 49
    mov dword [gato + 16], 49
    mov dword [gato + 20], 49      
    mov dword [gato + 24], 49
    mov dword [gato + 28], 53
    mov dword [gato + 32], 49
    
    xor eax, eax
    xor ecx, ecx    
    casoHorizontal:
        mov ecx, 3
        mov ebx, 0
        cicloExt: 
            push ecx
            xor eax,eax
            mov ecx, 3 ; reinicia en 3 para el loop interno
            cicloInt:
                push ecx
                add eax, dword [gato + ebx]
                add ebx, 4
                pop ecx
            loop cicloInt            
            pop ecx  
                      
            cmp eax, 147        
            je player1
            cmp eax, 159
            je player2             
        loop cicloExt
           

    xor eax, eax
    xor ebx, ebx  
    casoDiagonales:        
        mov ecx, 3
        cicloDiagonal:
            push ecx
            dec ecx 
            mov eax, 16
            mul ecx
            add ebx, dword [gato + eax]
            pop ecx
        loop cicloDiagonal
            
        mov eax, ebx; para que siempre se revise el registro eax
        cmp eax, 147        
        je player1
        cmp eax, 159
        je player2            
        
        xor eax, eax
        add eax, dword [gato + 8]
        add eax, dword [gato + 16]
        add eax, dword [gato + 24]
        
        cmp eax, 147        
        je player1
        cmp eax, 159
        je player2
    
    casoVertical:
        xor eax, eax
        add eax, dword [gato + 0]
        add eax, dword [gato + 12]
        add eax, dword [gato + 24]
        cmp eax, 147        
        je player1
        cmp eax, 159
        je player2
                
        xor eax, eax
        add eax, dword [gato + 4]
        add eax, dword [gato + 16]
        add eax, dword [gato + 28]
        cmp eax, 147        
        je player1
        cmp eax, 159
        je player2
        
        xor eax, eax
        add eax, dword [gato + 8]
        add eax, dword [gato + 20]
        add eax, dword [gato + 32]
        cmp eax, 147        
        je player1
        cmp eax, 159
        je player2
        
    
    casoKeepPlaying:
        xor eax, eax            
        mov ecx, 8
        ciclo2:
            push ecx            
            cmp dword [gato + ecx * 4], 49
            je keepPlaying
            cmp dword [gato + ecx * 4], 53
            je keepPlaying
            pop ecx
        loop ciclo2
        jmp casoMatch       
         
    casoMatch:
        jmp match            
    
    
    player1:
        push msgA
        call _printf
        add esp,4
        jmp fin
        
    player2:
        push msgB
        call _printf
        add esp,4
        jmp fin
        
    keepPlaying:
        pop ecx
        push msgC
        call _printf
        add esp,4
        jmp fin
        
    match:
        push msgD
        call _printf
        add esp,4
        jmp fin

    fin:
    

    mov dword [count],0
    mov ecx, 3
        externo1:
        push ecx
        mov ebx, ecx
        mov ecx, 3
            interno1:
            push ecx
            mov ebx, [count]
            push dword [gato + ebx]
            push formato
            call _printf
            add esp, 8
            add dword[count], size
            pop ecx
            loop interno1
        push cambioLinea
        call _printf
        add esp, 4
        mov ecx, ebx
        pop ecx   
        loop externo1

    
    push dword 0
    call _ExitProcess@4    
    