; System Info
SYS_CLOCK	.equ	1843200
; I/O Ports
PORT_CTC	.equ	0x00
PORT_UART	.equ	0x10

.org 0x0000
; start
;   Reset Vector
start:
	; cpu init
	di
	ld sp, 0xFFFF
	ld a, 0x00
	ld i, a
	im 2
	ei
	; device init
	call uart_init
	; welcome string
	ld hl, string_startup
	call uart_tx_str
	; main loop
	call main
	halt


.org 0x0030
; ISR
;   Interrupt Service Routine
int_uart:
	defw isr_uart




.org 0x0050
; main
;   Main Program loop
main:
	;call uart_rx_wait
	;call uart_tx_char

	jp main
	ret

isr_uart:
	di
	push af
	; IIR: check if received
	in a, (PORT_UART+2)
	and 0x04	; interrupt id: received data available
	jp z, isr_uart_end	; wrong interrupt! skip
	; get char from uart controller (clears interrupt)
	in a, (PORT_UART)
	; send received char back
	call uart_tx_char
isr_uart_end:
	; return
	pop af
	ei
	reti




; ### 16c550 UART Driver ###
; ##########################
; uart_init
;   initializes uart chip
uart_init:
	; LCR: Set DLAB Bit for Baud Rate
	ld a, 0x80
	out (PORT_UART+3), a
	; Set Baud Rate
	ld a, 0x0C
	out (PORT_UART), a
	ld a, 0x00
	out (PORT_UART+1), a
	; LCR: 8 bit, one stop, no parity, DLAB off
	ld a, 0x03
	out (PORT_UART+3), a
	; IER: Receiver Interrupt
	ld a, 0x01
	out (PORT_UART+1), a
	; FCR: FIFO off
	ld a, 0x00
	out (PORT_UART+2), a
	; MCR: Deactivate all Pins
	ld a, 0x00
	out (PORT_UART+4), a
	; return from routine
	ret


; uart_tx_char
;   sends a single char in a
uart_tx_char:
	push af
uart_tx_char_loop:
	in a, (PORT_UART+5)	; 0x15
	and 0x40
	jp z, uart_tx_char_loop
	; ready to send char now
	pop af
	out (PORT_UART), a
	; return from subroutine
	ret


; uart_tx_str
;   sends a 0 terminated string. Pointer in hl.
uart_tx_str:
	ld a, (hl)
	or 0
	ret z	; end of string? Yes: return
	call uart_tx_char
	inc hl	; next character
	jp uart_tx_str


; uart_rx_wait
;   waits until single character received. Character in a
uart_rx_wait:
	in a, (PORT_UART+5)
	and 0x01			; received char?
	jp z, uart_rx_wait
	in a, (PORT_UART)	; get char
	ret


; Some constants like strings and stuff
string_startup:	.db "System initialized !", 0x0D, 0x0A, 0x00
