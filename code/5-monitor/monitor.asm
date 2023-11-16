; defines
PORT_MEMPAGE	.equ	0x00
PORT_UART1		.equ	0x10
PORT_UART2		.equ	0x18
; variables
PTR_INPUT		.equ	0x8000
PTR_ARGV		.equ	0x8020 ; list of pointers to PTR_INPUT
PTR_ARGC		.equ	0x8030


.org 0x0000
init:
	di
	; set upper ram page
	;ld a, 0x00
	;out (PORT_MEMPAGE), a
	; cpu init
	ld sp, 0xFFFF
	ld a, 0x00
	ld i, a
	im 2
	; device init
	call uart_init

	; clear memory
	ld hl, 0x8000
_init_loop:
	ld (hl), 0xFF
	inc hl
	ld a, h
	cp 0xFF
	jp nz, _init_loop

	; jump to main
	jp main



.org 0x0100
main:
	ld hl, str_hello
	call uart1_puts
_main_loop:
	; print promt
	ld hl, str_promt
	call uart1_puts
	; input buffer
	ld hl, PTR_INPUT
	; pointer to argument
	ld bc, hl
	; argc
	ld a, 0
	ld (PTR_ARGC), a
_main_loop_getc:
	call uart1_getch
	; check if newline or space
	cp 0x0D
	jr z, _main_newline
	; echo back
	call uart1_putc
	; check if space
	cp ' '
	jr nz, _main_loop_no_space
	; save memory location to argv pointer
	call add_argv
	; save next location as start of new argument
	ld bc, hl
	inc bc
	; save a 0 instead of a space
	ld a, 0
_main_loop_no_space:
	; check if backspace
	cp 0x08
	jr z, _main_loop_backspace
	; not return: put into buffer
	ld (hl), a
	inc hl
	jr _main_loop_getc
_main_loop_backspace:
	ld a, 0
	ld (hl), a
	; check if pointer at 0
	ld de, PTR_INPUT
	sbc hl, de
	add hl, de
	jp z, _main_loop_getc
	; if there are some chars, delete last one
	dec hl
	; print space
	ld a, ' '
	call uart1_putc
	ld a, 0x08
	call uart1_putc
	jr _main_loop_getc
_main_newline:
	; enter pressed
	; end buffer with terminating 0
	ld (hl), 0x00
	; save last argument in argv list
	call add_argv
	; parse command
	call uart1_newline
	call handle_cmd
	; print shell again
	jp _main_loop



; add_argv
;   add pointer in bc to argv list
add_argv:
	push de
	push hl
	; get argc and multiply by 2
	ld a, (PTR_ARGC)
	sla a
	ld d, 0
	ld e, a
	; de is offset
	ld hl, PTR_ARGV
	add hl, de
	ld (hl), bc
	; increment argc
	ld a, (PTR_ARGC)
	inc a
	ld (PTR_ARGC), a
	; return
	pop hl
	pop de
	ret



; handle command string
;   command string in argv
handle_cmd:
	; check if input buffer zero
	ld a, (PTR_INPUT)
	cp 0
	ret z
	; get mnemonic id by comparing to list
	ld bc, (PTR_ARGV)
	ld hl, lst_cmds_str_ptr
	call get_index
	cp 0xFF
	jr z, _handle_cmd_error
	; get function pointer, index in a
	ld hl, lst_cmds_ptr
	call get_word_from_index
	push hl
	; save return address in stack for return
	call _handle_cmd_call_func
_handle_cmd_call_func:
	; get pc address 0x0178
	pop hl
	ld bc, 8
	add hl, bc
	push hl ; hl points to address after jp (hl)
	; call address in hl
	pop hl
	jp (hl)
	ret
_handle_cmd_error:
	ld hl, str_error
	call uart1_puts
	ret



; pointer to string in bc
; pointer to list of strings in hl
; 
;   compares command to first space to list of commands
get_index:
	; save start of string
	ld a, 0
	push af
	ld de, bc
_get_index_list_loop:
	; get pointer to string by index
	ld hl, lst_cmds_str_ptr
	call get_word_from_index ; gets pointer to string with index a
	; last index is zero
	ld bc, 0x0000
	sbc hl, bc
	add hl, bc
	jr z, _get_index_not_found
	; get start of string, array pointer in hl
	ld bc, de
	; pointer to command_str[a] in hl
	; compare strcmp(command_str[a], str)
	call strcmp
	; check if strings were the same
	cp 1
	jr z, _get_index_found
	; not equal: next index
	pop af
	inc a
	push af
	; index in a
	jr _get_index_list_loop
_get_index_found:
	pop af
	ret
_get_index_not_found:
	pop af
	ld a, 0xFF
	ret



; get_word_from_index
;   hl - pointer to start of list
;    a - index of list of words
;   Returns: hl - word at (hl + a*2)
get_word_from_index: ; hl = (hl+a*2)
	push af
	sla a ; a=a*2
	; add a to hl
	add a, l
	ld l, a
	adc a, h
	sub l
	ld h, a
	; get word from pointer
	push bc
	ld bc, hl
	ld a, (bc)
	ld l, a
	inc bc
	ld a, (bc)
	ld h, a
	pop bc
	; return
	pop af
	ret



; strcmp
;   compare two strings
;   hl - first string
;   bc - second string
;   returns a: 0 not equal, 1 equal
strcmp:
	; check if second string ends
	ld a, (hl)
	cp 0
	jr z, _strcmp_equal
	; check if first string ends
	ld a, (bc)
	cp 0
	jr z, _strcmp_equal
	; check if chars are the same
	cp (hl)
	jr nz, _strcmp_not_equal
	; next char
	inc hl
	inc bc
	jr strcmp
_strcmp_not_equal:
	ld a, 0
	ret
_strcmp_equal:
	ld a, 1
	ret



; command: print help
cmd_help:
	ld hl, str_cmd_help
	call uart1_puts
	; index counter
	ld b, 0
_cmd_help_loop:
	ld a, b
	ld hl, lst_cmds_str_ptr
	call get_word_from_index
	; check if pointer is zero
	ld de, 0x0000
	sbc hl, de
	add hl, de
	ret z
	; print command name
	call uart1_puts
	; print space
	ld a, ' '
	call uart1_putc
	call uart1_putc
	; print description
	inc hl
	call uart1_puts
	call uart1_newline
	; next index
	inc b
	jr _cmd_help_loop
str_cmd_help: .db "Commands:", 0x0D, 0x0A, 0x00



; command: dump memory
;   starting address in hl
;   puts first argument in bc, second in de
cmd_dump:
	ld a, (PTR_ARGC)
	cp 3
	jr nz, _cmd_dump_error
	; get second argument
	ld hl, PTR_ARGV
	ld a, 1
	call get_word_from_index
	; convert string to hex word
	call word_to_val
	push bc
	; get third argument
	ld hl, PTR_ARGV
	ld a, 2
	call get_word_from_index
	; convert string to hex word
	call word_to_val
	; dump memory (start in hl, end in bc)
	pop hl
	call dump
	call uart1_newline
	ret
_cmd_dump_error
	ld hl, str_cmd_dump_help
	call uart1_puts
	ret
str_cmd_dump_help: .db "Usage: dump <start_addr> <end_addr>", 0x0D, 0x0A, "address in hex", 0x0D, 0x0A, "example: dump 1000", 0x0D, 0x0A, 0x00



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
	; convert to 4 bits and shift
	call nibble_to_val
	rrca
	rrca
	rrca
	rrca
	ld b, a
	; get lower nibble
	call uart1_getch
	call ch_to_upper
	; return on newline
	cp 0x0D
	jr z, _cmd_mset_end
	; convert to 4 bits
	call nibble_to_val
	or b
	; save to memory
	ld (hl), a
	; next memory location
	inc hl
	jr _cmd_mset_upper
_cmd_mset_end:
	call uart1_newline
	ret
_cmd_mset_error:
	ret



; command: jump to location
;   argv in PTR_ARGV
;   argc in PTR_ARGC
cmd_jump:
	ld a, (PTR_ARGC)
	cp 2
	jr nz, _cmd_jump_error
	; get second argument
	ld hl, PTR_ARGV
	ld a, 1
	call get_word_from_index
	; convert argument to word
	call word_to_val
	ld hl, bc
	; jump to location
	jp (hl)
_cmd_jump_error:
	ret



; command: change upper ram page
cmd_page:
	ld a, (PTR_ARGC)
	cp 2
	jr nz, _cmd_mset_error
	; get second argument
	ld hl, PTR_ARGV
	ld a, 1
	call get_word_from_index
	; convert argument to word
	call word_to_val
	ld a, c
	; write page id
	out (PORT_MEMPAGE), a
	ret



; command: load bytes to 0x0000
cmd_load:
	; switch upper 32k to page 0
	ld a, 0x00
	out (PORT_MEMPAGE), a
	; set stackpointer (since page was changed)
	ld sp, 0xFFFF
	; page 0 start address
	ld hl, 0x8000
_cmd_load_loop:
	call uart1_getch
	cp 0x0D
	jr z, _cmd_load_copy
	; not newline, convert to nibble
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
	; write data to ram
	ld (hl), a
	inc hl
	jr _cmd_load_loop
_cmd_load_copy:
	; switch to upper ram page 1
	ld a, 0x01
	out (PORT_MEMPAGE), a
	; copy jump code
	ld hl, jump_code
	ld bc, 0x8000
	ld d, jump_code_len
_cmd_load_copy_loop:
	ld a, (hl)
	ld (bc), a
	inc hl
	inc bc
	dec d
	jr nz, _cmd_load_copy_loop
	; everything ok
	ld a, 'K'
	call uart1_putc
	call uart1_newline
	; code copied, jump to 0x8000
	jp 0x8000



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



; nibble_to_val
;   char in A, convert to hex number
nibble_to_val:
	call ch_to_upper
	cp '9'+1
	jr c, _nibble_to_val_1 ; jump if number 0-9
	sub 7                  ; sub for A-F
_nibble_to_val_1:
	sub '0'
	and 0x0F
	ret



; word_to_val
;   pointer to string in hl
;   returns word in bc
word_to_val:
	; convert string to hex word
	ld bc, 0
_word_to_val_loop:
	ld a, (hl)
	cp 0
	ret z
	call nibble_to_val
	push hl
	; shift left bc 4 times
	ld hl, bc
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add a, l
	ld l, a
	ld bc, hl
	; advance pointer to next char
	pop hl
	inc hl
	jr _word_to_val_loop



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





str_hello:	.db "Hello!", 0x0D, 0x0A, 0x00
str_promt:	.db "$ ",0
str_error:	.db	"Error", 0x0D, 0x0A, 0x00


lst_cmds_str_ptr:	.dw lst_cmds_str_help,lst_cmds_str_dump,lst_cmds_str_mset,lst_cmds_str_jump,lst_cmds_str_page,lst_cmds_str_load,0x0000
lst_cmds_str_help:	.db "help",0, "Prints this help",0
lst_cmds_str_dump:	.db "dump",0, "Dumps 256bytes starting at location specified",0
lst_cmds_str_mset:	.db "mset",0, "Write bytes to memory location",0
lst_cmds_str_jump:	.db "jump",0, "Jumps to location",0
lst_cmds_str_page:	.db "page",0, "Changes upper 32k memory page",0
lst_cmds_str_load:	.db "load",0, "Writes bytes to page 0 and jumps to 0x0000",0

lst_cmds_ptr: .dw cmd_help, cmd_dump, cmd_mset, cmd_jump, cmd_page, cmd_load


jump_code:		.db	0x31,0xFF,0xFF,0x3E,0x11,0xD3,0x00,0xC3,0x00,0x00
jump_code_len:	.equ 10