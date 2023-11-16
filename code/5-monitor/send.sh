#!/bin/bash
if [ -n "$1" ]
then
    #stty -F /dev/ttyUSB0 9600 cs8 -parenb -cstopb -ixon
    stty -F /dev/ttyUSB0 9600 litout -crtscts
    printf "load\x0d" > /dev/ttyUSB0
    xxd -p $1 | tr -d '\n' > /dev/ttyUSB0
    printf "\x0d" > /dev/ttyUSB0
else
    echo "Usage: send.sh <file>"
fi
