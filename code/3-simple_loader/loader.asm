PORT_MEMPAGE	.equ	0x00
PORT_UART1	.equ	0x10
PORT_UART2	.equ	0x18


.org 0x0000
init:
    di
	; cpu init
	ld sp, 0xFFFF
	ld a, 0x00
	ld i, a
	im 2
	; device init
	call uart_init
main:
	; show hello text
	ld hl, msg_hello
	call uart1_puts
	; set upper bank to 0
	ld a, 0x00
	out (PORT_MEMPAGE), a
	; RAM start address
	ld hl, 0x8000
main_loop:
	; get upper nibble
	call uart1_getch
	; check if newline
	cp 0x0D
	jr z, main_end
	; not newline, get upper nibble
	call nibble_to_val
	rrca
	rrca
	rrca
	rrca
	ld b, a
	; get lower nibble
	call uart1_getch
	call nibble_to_val
	or b
	; print data
	;call print_byte
	; write data to ram
	ld (hl), a
	; next address
	inc hl
	jr main_loop
main_end:
	; data is received and written to page 0
	; dump memory
	;call uart1_newline
	;ld hl, 0x8000
	;call dump_mem
	;call uart1_newline
	; switch to upper ram page 1
	ld a, 0x01
	out (PORT_MEMPAGE), a
	; copy helper code to ram
	call copy_code
	; everything ok
	ld a, 'K'
	call uart1_putc
	; dump memory
	;call uart1_newline
	;ld hl, 0x8000
	;call dump_mem
	; jump to ram
	jp 0x8000
	halt


; uart_init
;   init uart port
uart_init:
	; UART1
	; LCR: Set DLAB Bit for Baud Rate
	ld a, 0x80
	out (PORT_UART1+3), a
	; Set Baud Rate
	ld a, 0x0c
	out (PORT_UART1), a
	ld a, 0x00
	out (PORT_UART1+1), a
	; LCR: 8 bit, one stop, no parity, DLAB off
	ld a, 0x03
	out (PORT_UART1+3), a
	; No Interrupt
	ld a, 0x00
	out (PORT_UART1+1), a
	; FCR: FIFO off
	ld a, 0x00
	out (PORT_UART1+2), a
	; MCR: Deactivate all Pins
	ld a, 0x00
	out (PORT_UART1+4), a
	; return
	ret


; uart1_putc
;   sends a single char in a
uart1_putc:
	push af
uart1_putc_loop:
	; wait till ready
	in a, (PORT_UART1+5)
	and 0x40
	jp z, uart1_putc_loop
	; ready to send char now
	pop af
	out (PORT_UART1), a
	; return from subroutine
	ret


; uart1_puts
;   sends a 0 terminated string. Pointer in hl.
uart1_puts:
	ld a, (hl)
	or 0
	ret z	; end of string? Yes: return
	call uart1_putc
	inc hl	; next character
	jp uart1_puts


; uart1_getch
;   waits until single character received. Character in a
uart1_getch:
	in a, (PORT_UART1+5)
	and 0x01			; received char?
	jp z, uart1_getch   ; loop until a char is received
	in a, (PORT_UART1)	; get char
	ret


;uart1_newline:
;	push af
;	ld a, 0x0A
;	call uart1_putc
;	ld a, 0x0D
;	call uart1_putc
;	pop af
;	ret

; ch_to_upper
;   char in A, convert to uppercase
ch_to_upper:
	; less than 'a': return
	cp 'a'
	ret c
	; greater than 'z': return
	cp 'z'+1
	ret nc
	; convert to upper case
	sub 0x20
	ret


; nibble_to_val
;   char in A, convert to hex number
nibble_to_val:
	call ch_to_upper
	cp '9'+1
	jr c, nibble_to_val_1 ; jump if number 0-9
	sub 7                 ; sub for A-F
nibble_to_val_1:
	sub '0'
	and 0x0F
	ret


; print_nibble
;   byte in A, convert to char and print via uart
;print_nibble:
;	and 0x0F
;	add a, '0'
;	cp '9'+1
;	jr c, print_nibble_1
;	add a, 'A'-'0'-0xA
;print_nibble_1:
;	call uart1_putc
;	ret

; print_byte
;   byte in A
;print_byte:
;	push af
;	rrca
;	rrca
;	rrca
;	rrca
;	call print_nibble
;	pop af
;	call print_nibble
;	ret


; copy_code
;   copy the code to upper ram
copy_code:
	ld hl, code_jump ; pointer to code
	ld bc, 0x8000    ; ram address
	ld d, 254        ; number of bytes
copy_code_1:
	ld a, (hl)
	;call print_byte
	ld (bc), a
	inc hl
	inc bc
	dec d
	jp nz, copy_code_1
	ret


; dump_mem
;   starting address in hl, dumps 256 bytes
;dump_mem:
;	push af
;	push bc
;	ld b, 0x00
;dump_mem_loop:
;	; check if newline needed
;	ld a, l
;	and 0x0F
;	jr nz, dump_mem_1 ; skip newline
;	call uart1_newline
;	; print address
;	ld a, h
;	call print_byte
;	ld a, l
;	call print_byte
;	ld a, ':'
;	call uart1_putc
;	ld a, ' '
;	call uart1_putc
;dump_mem_1:
;	; print byte
;	ld a, (hl)
;	call print_byte
;	ld a, ' '
;	call uart1_putc
;	; address counter
;	inc hl
;	; byte counter
;	dec b
;	jr nz, dump_mem_loop
;	pop bc
;	pop af
;	ret


msg_hello: .db "Send raw data in ascii hex values. Executed on newline", 0x0A, 0x0D, 0x00
code_jump: ; this will be in ram_code.asm
