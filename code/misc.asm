; command: write memory
;   argv in PTR_ARGV
;   argc in PTR_ARGC
cmd_mset:
	ld a, (PTR_ARGC)
	cp 2
	jr nz, _cmd_mset_error
	; get second argument
	ld hl, PTR_ARGV
	ld a, 1
	call get_word_from_index
	; convert argument to word
	call word_to_val
	ld hl, bc
	; wait for data and copy to location
_cmd_mset_upper:
	; get first char
	call uart1_getch
	call ch_to_upper
	; return on newline
	cp 0x0D
	jr z, _cmd_mset_end
	; skip everything below 0
	cp 0x2F
	jr c, _cmd_mset_upper
	; skip above F
	cp 0x47
	jr nc, _cmd_mset_upper
	; echo back
	call uart1_putc
	; convert to 4 bits and shift
	call nibble_to_val
	rrca
	rrca
	rrca
	rrca
	ld b, a
_cmd_mset_lower:
	; get lower nibble
	call uart1_getch
	call ch_to_upper
	; return on newline
	cp 0x0D
	jr z, _cmd_mset_end
	; skip everything below 0
	cp 0x2F
	jr c, _cmd_mset_lower
	; skip above F
	cp 0x47
	jr nc, _cmd_mset_lower
	; echo back
	call uart1_putc
	; convert to 4 bits
	call nibble_to_val
	or b
	; save byte for later
	push af
	; print space
	ld a, ' '
	call uart1_putc
	; check if newline has to be printed
	ld a, l
	and 0x0F
	cp 0x0F
	jr nz, _cmd_mset_skip_newline
	call uart1_newline
_cmd_mset_skip_newline:
	; save byte to RAM
	pop af
	ld (hl), a
	; next memory location
	inc hl
	jr _cmd_mset_upper
_cmd_mset_end:
	call uart1_newline
	ret
_cmd_mset_error:
	ret