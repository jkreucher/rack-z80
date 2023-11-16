; defines
PORT_MEMPAGE	.equ	0x00
PORT_UART1		.equ	0x10
PORT_UART2		.equ	0x18


.org 0x0000
init:
	di
	ld sp, 0xFFFF
	ld a, 0x00
	ld i, a
	im 2
	jp main



.org 0x0100
main:
	; device init
	call uart_init
	ld hl, 0x0000
	ld bc, 0x0200
	call dump
	halt


; dump
;   hl - start address
;   bc - end address
dump:
	push de
	ld de, bc
	
_dump_line:
	; print address
	call print_word
	; print colon and space
	ld a, ':'
	call uart1_putc
	ld a, ' '
	call uart1_putc
	; print 16 bytes
	push hl
	ld b, 0x10
_dump_line_loop:
	ld a, (hl)
	call print_byte
	ld a, ' '
	call uart1_putc
	inc hl
	; decrement b and jump if b not zero
	djnz _dump_line_loop
	; get memory location
	pop hl
	ld b, 0x10
_dump_ascii_loop:
	ld a, (hl)
	; check if ascii
	call is_ascii
	jr c, _dump_ascii_loop_is_ascii
	; not ascii: use '.' as placeholder
	ld a, '.'
_dump_ascii_loop_is_ascii:
	call uart1_putc
	inc hl
	; decrement b and jump if b not zero
	djnz _dump_ascii_loop
	; 16 bytes printed
	call uart1_newline
	; check if at the end
	or a
	sbc hl, de
	add hl, de
	jr c, _dump_line
	; end of dump
	pop de
	ret



; checks if byte is a printable ascii char
;   a - byte to check
;   Returns: if printable char then carry flag is set
is_ascii:
	cp 0x20
	jr c, _is_ascii_nope
	cp 0x7F
	ret
_is_ascii_nope:
	ccf
	ret



; print a 16-Bit word to serial port as hex value
;   hl - word to print in hex
print_word:
	push af
	ld a, h
	call print_byte
	ld a, l
	call print_byte
	pop af
	ret


; print a byte as hex value
;   a - byte to print in hex
print_byte:
	push af
	rrca
	rrca
	rrca
	rrca
	call print_nibble
	pop af
	call print_nibble
	ret


; print a nibble as hex value
;   byte in A, convert to char and print via uart
print_nibble:
	and 0x0F
	add a, '0'
	cp '9'+1
	jr c, print_nibble_1
	add a, 'A'-'0'-0xA
print_nibble_1:
	call uart1_putc
	ret



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
_uart1_putc_loop:
	; wait till ready
	in a, (PORT_UART1+5)
	and 0x40
	jp z, _uart1_putc_loop
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



; uart1_newline
;   prints newline to terminal
uart1_newline:
	push af
	ld a, 0x0A
	call uart1_putc
	ld a, 0x0D
	call uart1_putc
	pop af
	ret