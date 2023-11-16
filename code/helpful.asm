; my own reference for useful z80 code


; cp
cp arg1
; arg1 >  a -> carry set
; arg1 <= a -> carry reset
; arg1 == a -> zero set
; arg1 != a -> zero reset
;
; a <  arg1 -> carry set
; a >= arg1 -> carry reset


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
;   char in A, convert to value
nibble_to_val:
	cp '9'+1              ; is it a digit?
	jr c, nibble_to_val_1 ; jump if number
	sub 7                 ; for A-F
nibble_to_val_1:
	sub '0'
	and 0x0F              ; lower nibble only
	ret


; val_to_nibble
;   value in A, convert to hex nibble in ascii
val_to_nibble:
	and 0x0F
	add a, '0'
	cp '9'+1
	jr c, val_to_nibble_1 ; jump if less
	add a, 'A'-'0'-0xA
val_to_nibble_1:
	ret


; print_nibble
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
; print_byte
;   byte in A
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



dump_mem:
	push af
	push bc
	ld b, 0x00
dump_mem_loop:
	; check if newline needed
	ld a, l
	and 0x0F
	jr nz, dump_mem_1 ; skip newline
	call uart1_newline
	; print address
	ld a, h
	call print_byte
	ld a, l
	call print_byte
	ld a, ':'
	call uart1_putc
	ld a, ' '
	call uart1_putc
dump_mem_1:
	; print byte
	ld a, (hl)
	call print_byte
	ld a, ' '
	call uart1_putc
	; address counter
	inc hl
	; byte counter
	dec b
	jr nz, dump_mem_loop
	pop bc
	pop af
	ret