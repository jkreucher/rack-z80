TARGET=sdcc-test

all:
	sdasz80 -xlos -g startup.s
	sdcc -c -mz80 --no-std-crt0 startup0.rel main.c -o main.rel

	sdcc -mz80 --code-loc 0x0120 --data-loc 0x8000 --no-std-crt0 startup.rel main.rel -o $(TARGET).ihx

	sdobjcopy -I ihex -O binary $(TARGET).ihx $(TARGET).bin

dasm:
	z80dasm --address --labels --origin=0000h $(TARGET).bin -o $(TARGET)_dasm.asm

clean:
	rm -f *.lst *.sym *.ihx *.lk *.noi *.map *.?db *.rel *.bin *.asm