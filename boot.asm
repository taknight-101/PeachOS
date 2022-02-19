ORG 0x7c00 
; ORG 0 
BITS 16

; some bios needs this stub to pad with zeros as they overwrite the bios block param structure 
_start:
    jmp short start
    nop

times 33 db 0
 
start:
    jmp 0:step2

; 

handle_zero:
    mov ah , 0eh
    mov al , 'V' 
    mov bx , 0x00
    int 0x10
    iret

step2:
    cli ; Clear Interrupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enables Interrupts
   
    mov word[ss:0x00] , handle_zero - 0x7c00 ; this took some time from me to get on my own :)
    mov word[ss:0x02] , 0x7c0

    mov ax, 0x00
    div ax
    ; or int 0
    int 0 

    mov si, message
    call print
    jmp $


  

print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

message: db 'Hello World!', 0

times 510-($ - $$) db 0 ; as the BIOS will look for the bootloader's code in the first sector "first 521 bytes" in every storage medium
dw 0xAA55  ; boot signature that marks the sector as bootable <contains the bootloader code> this sector later on gets loaded at address 0x7C00 to be executed