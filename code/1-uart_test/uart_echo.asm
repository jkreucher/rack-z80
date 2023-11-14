PORT_UART1	.equ	0x10
PORT_UART2	.equ	0x18


.org 0x0000
init:
    di
	; cpu init
	ld sp, 0xffff
	ld a, 0x00
	ld i, a
	im 2
	; device init
	call uart_init
	; main loop
	ei
	jp main


.org 0x0040
;   Interrupt Vector Table
;   Address set with DIP-Switches
isrs:
	defw isr_uart1
	defw isr_uart2


.org 0x0100
main:
	; enable gpio pin (LED)
	ld a, 0x08
	out (PORT_UART1+4), a
	out (PORT_UART2+4), a
	; send char 
	ld a, 'A'
	call uart2_tx_char
	; wait
	call sleep
	; disable gpio pin (LED)
	ld a, 0x00
	out (PORT_UART1+4), a
	out (PORT_UART2+4), a
	; wait
	call sleep
	jp main


sleep:
	push af
	ld bc, 0xffff
sleep_loop:
	dec bc
	ld a, c
	or b
	jp nz, sleep_loop
	pop af
	ret


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
	; IER: Receiver Interrupt
	ld a, 0x01
	out (PORT_UART1+1), a
	; FCR: FIFO off
	ld a, 0x00
	out (PORT_UART1+2), a
	; MCR: Deactivate all Pins
	ld a, 0x00
	out (PORT_UART1+4), a
	
	; UART2
	; LCR: Set DLAB Bit for Baud Rate
	ld a, 0x80
	out (PORT_UART2+3), a
	; Set Baud Rate
	ld a, 0x0c
	out (PORT_UART2), a
	ld a, 0x00
	out (PORT_UART2+1), a
	; LCR: 8 bit, one stop, no parity, DLAB off
	ld a, 0x03
	out (PORT_UART2+3), a
	; IER: Receiver Interrupt
	ld a, 0x01
	out (PORT_UART2+1), a
	; FCR: FIFO off
	ld a, 0x00
	out (PORT_UART2+2), a
	; MCR: Deactivate all Pins
	ld a, 0x00
	out (PORT_UART2+4), a

	ret


; uart1_tx_char
;   sends a single char in a
uart1_tx_char:
	push af
uart1_tx_char_loop:
	; wait till ready
	in a, (PORT_UART1+5)
	and 0x40
	jp z, uart1_tx_char_loop
	; ready to send char now
	pop af
	out (PORT_UART1), a
	; return from subroutine
	ret


; uart2_tx_char
;   sends a single char in a
uart2_tx_char:
	push af
uart2_tx_char_loop:
	; wait till ready
	in a, (PORT_UART2+5)
	and 0x40
	jp z, uart2_tx_char_loop
	; ready to send char now
	pop af
	out (PORT_UART2), a
	; return from subroutine
	ret


; uart1_tx_str
;   sends a 0 terminated string. Pointer in hl.
;uart1_tx_str:
;	ld a, (hl)
;	or 0
;	ret z	; end of string? Yes: return
;	call uart1_tx_char
;	inc hl	; next character
;	jp uart1_tx_str


; uart1_rx_wait
;   waits until single character received. Character in a
;uart1_rx_wait:
;	in a, (PORT_UART1+5)
;	and 0x01			; received char?
;	jp z, uart1_rx_wait ; loop until a char is received
;	in a, (PORT_UART1)	; get char
;	ret


; Interrupt Service Routines
isr_uart1:
	di
	push af
	; enable recv led
	ld a, 0x04
	out (PORT_UART1+4), a
	; get char from uart controller (clears interrupt)
	in a, (PORT_UART1)
	; send received char back
	call uart1_tx_char
	; disable recv led
	ld a, 0x00
	out (PORT_UART1+4), a
isr_uart1_end:
	pop af
	ei
	reti


isr_uart2:
	di
	push af
	; enable recv led
	ld a, 0x04
	out (PORT_UART2+4), a
	; get char from uart controller (clears interrupt)
	in a, (PORT_UART2)
	; send received char back
	call uart2_tx_char
	; disable recv led
	ld a, 0x00
	out (PORT_UART2+4), a
isr_uart2_end
	pop af
	ei
	reti
