[BITS 16]
[ORG 0x7C00]

start:
  mov si, msg
  
  call .print_char

.print_char:
  lodsb
  
  or al, al
  jz .done 

  mov ah, 0eh
  mov bx, 0 
  int 0x10

  jmp .print_char

.done:
  jmp load_gdt 

load_gdt:
  ; Fast A20
  in al, 0x92 
  or al, 2 
  out 0x92, al

  cli
  lgdt [gdtr]
  mov eax, cr0
  or eax, 1 
  mov cr0, eax
  
  jmp 0x08:protected_mode

msg db "Hello, World !", 0

gdt_start:
  ; Null Segment
  dd 0x00000000, 0x00000000

  ; Code Segment
  dd 0x0000FFFF, 0x00CF9A00
  
  ; Data Segment
  dd 0x0000FFFF, 0x00CF9200
gdt_end:

gdtr:
  dw gdt_end - gdt_start - 1 
  dd gdt_start

[BITS 32]
protected_mode:
  mov ax, 0x10
  ; ds, es, fs, gs, ss
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  mov esp, 0x90000
  
  sgdt [gdt_dump]
  jmp .done

.done:
    hlt
    jmp $

gdt_dump:
  dw 0 
  dd 0

times 510-($-$$) db 0 
dw 0xAA55
