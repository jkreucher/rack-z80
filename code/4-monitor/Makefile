all:
	zasm -uwyb --z80 monitor.asm

flash: all
	eeprom -d 28c64 -w monitor.rom

erase:
	eeprom -d 28c256 -e

clean:
	rm -f *.lst *.rom

upload: all
	./send.sh monitor.rom
