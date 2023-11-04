all:
	zasm -uwb --z80 uart_echo.asm

flash: all
	eeprom -d 28c64 -w uart_echo.rom

erase: clean
	eeprom -d 28c256 -e

clean:
	rm -f *.lst *.rom
