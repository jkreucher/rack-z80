all:
	zasm -uwyb --z80 dump.asm

flash: all
	eeprom -d 28c64 -w dump.rom

erase:
	eeprom -d 28c256 -e

clean:
	rm -f *.lst *.rom

upload: all
	./send.sh dump.rom
