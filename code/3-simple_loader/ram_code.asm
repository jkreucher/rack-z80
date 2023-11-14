PORT_MEMPAGE	.equ	0x00

.org 0x8000
start:
    ; upper ram page zero
    ld sp, 0xFFFF
    ; lower page in ram page 0 instead of rom
    ld a, 0x11
    out (PORT_MEMPAGE), a
    ; jump to entry point
    jp 0x0000
