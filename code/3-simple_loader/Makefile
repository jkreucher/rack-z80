all:
	zasm -uwb --z80 loader.asm
	zasm -uwb --z80 ram_code.asm
	cat loader.rom ram_code.rom > binary.rom

flash: all
	eeprom -d 28c64 -w binary.rom

erase: clean
	eeprom -d 28c256 -e

clean:
	rm -f *.lst *.rom
