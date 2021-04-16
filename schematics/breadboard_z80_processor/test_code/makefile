all:
	./zasm -uwb --z80 0-test.asm

flash: all
	./eeprom.py -d 28c64 -w 0-test.rom

erase: clean
	./eeprom.py -d 28c256 -e

clean:
	rm -f *.lst *.rom

