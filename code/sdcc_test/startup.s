.module starup

.area	_HEADER (ABS)

; Reset Vector
.org 0x0000
reset:
    jp init

; Interrupt Vectors
.org 0x0010


; Code
.org 0x0100
init:
	di
	ld sp, #0xFFFF
	ld a, #0x00
	ld i, a
	im 2
	ei
	ld	bc, #l__INITIALIZER
	ld	de, #s__INITIALIZED
	ld	hl, #s__INITIALIZER

	; call c main
	call _main
	halt

; segment order for linker
.area   _HOME
.area   _CODE

.area   _DATA

.area   _CODE