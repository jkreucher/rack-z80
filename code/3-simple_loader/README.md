# Very Simple Loader
This projects aims to make development easier. Removing the EEPROM and programming it every time is very tedious and time consuming. With this project a very simple rom loader is implemented. A binary file can be transferred via UART and be executed by the RackZ80.

## Inner Workings
The CPU expects binary data in form of hex values in ascii on UART port 1. This data gets copied to RAM page 0 which will be placed in the lower 32k later. Once copied, a very simple programm is placed in the upper 32k in RAM page 1 which will replace the lower 32k ROM with the RAM page 0. Next the programm jumps to 0x0000.

Note: No error checking is implemented!

## Sending a Binary File
```
./send.sh ../1-uart_test/uart_echo.rom
```