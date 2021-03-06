EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 3
Title "Project RackZ80 - RS232"
Date "2021-04-09"
Rev "1.0"
Comp "Jannik Kreucher"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 3500 3500 0    50   BiDi ~ 0
D[0..7]
$Comp
L RackZ80_Parts:74HC245 U6
U 1 1 609AE69A
P 6000 4850
F 0 "U6" H 6250 5600 50  0000 C CNN
F 1 "74HC245" H 6250 5500 50  0000 C CNN
F 2 "rackz80_footprints:DIP-20_Socket" H 5750 5400 50  0001 C CNN
F 3 "" H 5750 5400 50  0001 C CNN
	1    6000 4850
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_DIP_x08 SW2
U 1 1 609B126B
P 4200 4800
F 0 "SW2" H 4200 5467 50  0000 C CNN
F 1 "Vector" H 4200 5376 50  0000 C CNN
F 2 "Button_Switch_THT:SW_DIP_SPSTx08_Slide_9.78x22.5mm_W7.62mm_P2.54mm" H 4200 4800 50  0001 C CNN
F 3 "~" H 4200 4800 50  0001 C CNN
	1    4200 4800
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Network08 RN1
U 1 1 609B3F18
P 5000 5400
F 0 "RN1" H 4521 5354 50  0000 R CNN
F 1 "1k" H 4521 5445 50  0000 R CNN
F 2 "Resistor_THT:R_Array_SIP9" V 5475 5400 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 5000 5400 50  0001 C CNN
	1    5000 5400
	1    0    0    1   
$EndComp
Wire Wire Line
	4500 4900 5100 4900
Wire Wire Line
	5600 4800 5000 4800
Wire Wire Line
	4500 4700 4900 4700
Wire Wire Line
	5600 4600 4800 4600
Wire Wire Line
	5600 4400 4600 4400
Wire Wire Line
	4600 5200 4600 4400
Connection ~ 4600 4400
Wire Wire Line
	4600 4400 4500 4400
Wire Wire Line
	4700 5200 4700 4500
Connection ~ 4700 4500
Wire Wire Line
	4700 4500 5600 4500
Wire Wire Line
	4800 5200 4800 4600
Connection ~ 4800 4600
Wire Wire Line
	4800 4600 4500 4600
Wire Wire Line
	4900 5200 4900 4700
Connection ~ 4900 4700
Wire Wire Line
	4900 4700 5600 4700
Wire Wire Line
	5000 5200 5000 4800
Connection ~ 5000 4800
Wire Wire Line
	5000 4800 4500 4800
Wire Wire Line
	5100 5200 5100 4900
Connection ~ 5100 4900
Wire Wire Line
	5100 4900 5600 4900
$Comp
L power:GND #PWR021
U 1 1 609BA1EB
P 4600 5650
F 0 "#PWR021" H 4600 5400 50  0001 C CNN
F 1 "GND" H 4605 5477 50  0000 C CNN
F 2 "" H 4600 5650 50  0001 C CNN
F 3 "" H 4600 5650 50  0001 C CNN
	1    4600 5650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR023
U 1 1 609BB552
P 6000 5650
F 0 "#PWR023" H 6000 5400 50  0001 C CNN
F 1 "GND" H 6005 5477 50  0000 C CNN
F 2 "" H 6000 5650 50  0001 C CNN
F 3 "" H 6000 5650 50  0001 C CNN
	1    6000 5650
	1    0    0    -1  
$EndComp
Entry Wire Line
	6600 4400 6700 4300
Entry Wire Line
	6600 4500 6700 4400
Entry Wire Line
	6600 4600 6700 4500
Entry Wire Line
	6600 4700 6700 4600
Entry Wire Line
	6600 4800 6700 4700
Entry Wire Line
	6600 4900 6700 4800
Entry Wire Line
	6600 5000 6700 4900
Entry Wire Line
	6600 5100 6700 5000
Wire Wire Line
	6600 4400 6400 4400
Wire Wire Line
	6400 4500 6600 4500
Wire Wire Line
	6600 4600 6400 4600
Wire Wire Line
	6400 4700 6600 4700
Wire Wire Line
	6600 4800 6400 4800
Wire Wire Line
	6400 4900 6600 4900
Wire Wire Line
	6600 5000 6400 5000
Wire Wire Line
	6400 5100 6600 5100
Text Label 6600 4400 2    50   ~ 0
D0
Text Label 6600 4500 2    50   ~ 0
D1
Text Label 6600 4600 2    50   ~ 0
D2
Text Label 6600 4700 2    50   ~ 0
D3
Text Label 6600 4800 2    50   ~ 0
D4
Text Label 6600 4900 2    50   ~ 0
D5
Text Label 6600 5000 2    50   ~ 0
D6
Text Label 6600 5100 2    50   ~ 0
D7
$Comp
L power:+5V #PWR020
U 1 1 609C142A
P 6000 4150
F 0 "#PWR020" H 6000 4000 50  0001 C CNN
F 1 "+5V" H 6015 4323 50  0000 C CNN
F 2 "" H 6000 4150 50  0001 C CNN
F 3 "" H 6000 4150 50  0001 C CNN
	1    6000 4150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR019
U 1 1 609C20C7
P 3850 4150
F 0 "#PWR019" H 3850 4000 50  0001 C CNN
F 1 "+5V" H 3865 4323 50  0000 C CNN
F 2 "" H 3850 4150 50  0001 C CNN
F 3 "" H 3850 4150 50  0001 C CNN
	1    3850 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3850 4150 3850 4400
Wire Wire Line
	3850 5100 3900 5100
Wire Wire Line
	3900 5000 3850 5000
Connection ~ 3850 5000
Wire Wire Line
	3850 5000 3850 5100
Wire Wire Line
	3900 4900 3850 4900
Connection ~ 3850 4900
Wire Wire Line
	3850 4900 3850 5000
Wire Wire Line
	3900 4800 3850 4800
Connection ~ 3850 4800
Wire Wire Line
	3850 4800 3850 4900
Wire Wire Line
	3900 4700 3850 4700
Connection ~ 3850 4700
Wire Wire Line
	3850 4700 3850 4800
Wire Wire Line
	3900 4600 3850 4600
Connection ~ 3850 4600
Wire Wire Line
	3850 4600 3850 4700
Wire Wire Line
	3900 4500 3850 4500
Connection ~ 3850 4500
Wire Wire Line
	3850 4500 3850 4600
Wire Wire Line
	3900 4400 3850 4400
Connection ~ 3850 4400
Wire Wire Line
	3850 4400 3850 4500
Wire Wire Line
	6000 4150 6000 4200
Wire Wire Line
	6000 5500 6000 5650
$Comp
L 74xx:74LS138 U5
U 1 1 609CAE69
P 5900 2200
F 0 "U5" H 5650 2800 50  0000 C CNN
F 1 "74LS138" H 5650 2700 50  0000 C CNN
F 2 "rackz80_footprints:DIP-16_Socket" H 5900 2200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS138" H 5900 2200 50  0001 C CNN
	1    5900 2200
	-1   0    0    -1  
$EndComp
$Comp
L power:+5V #PWR017
U 1 1 609CC3C6
P 5900 1550
F 0 "#PWR017" H 5900 1400 50  0001 C CNN
F 1 "+5V" H 5915 1723 50  0000 C CNN
F 2 "" H 5900 1550 50  0001 C CNN
F 3 "" H 5900 1550 50  0001 C CNN
	1    5900 1550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR018
U 1 1 609CCA47
P 5900 2950
F 0 "#PWR018" H 5900 2700 50  0001 C CNN
F 1 "GND" H 5905 2777 50  0000 C CNN
F 2 "" H 5900 2950 50  0001 C CNN
F 3 "" H 5900 2950 50  0001 C CNN
	1    5900 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 2900 5900 2950
Wire Wire Line
	5900 1550 5900 1600
Entry Wire Line
	6600 1900 6700 1800
Entry Wire Line
	6600 2000 6700 1900
Entry Wire Line
	6600 2100 6700 2000
Entry Wire Line
	6600 2500 6700 2400
Wire Wire Line
	6600 1900 6400 1900
Wire Wire Line
	6400 2000 6600 2000
Wire Wire Line
	6600 2100 6400 2100
Wire Wire Line
	6400 2500 6600 2500
Text Label 6600 1900 2    50   ~ 0
A4
Text Label 6600 2000 2    50   ~ 0
A5
Text Label 6600 2100 2    50   ~ 0
A6
Text Label 6600 2500 2    50   ~ 0
A7
Wire Notes Line
	3500 3750 3500 6000
$Comp
L Switch:SW_DIP_x08 SW1
U 1 1 609E4DDB
P 4900 2300
F 0 "SW1" H 4900 2967 50  0000 C CNN
F 1 "Chip Select" H 4900 2876 50  0000 C CNN
F 2 "Button_Switch_THT:SW_DIP_SPSTx08_Slide_9.78x22.5mm_W7.62mm_P2.54mm" H 4900 2300 50  0001 C CNN
F 3 "~" H 4900 2300 50  0001 C CNN
	1    4900 2300
	-1   0    0    -1  
$EndComp
Wire Notes Line
	3500 1250 3500 3250
Wire Wire Line
	5200 1900 5400 1900
Wire Wire Line
	5400 2000 5200 2000
Wire Wire Line
	5200 2100 5400 2100
Wire Wire Line
	5400 2200 5200 2200
Wire Wire Line
	5200 2300 5400 2300
Wire Wire Line
	5400 2400 5200 2400
Wire Wire Line
	5200 2500 5400 2500
Wire Wire Line
	5400 2600 5200 2600
Wire Wire Line
	4600 1900 4500 1900
Wire Wire Line
	4500 1900 4500 2000
Wire Wire Line
	4500 2600 4000 2600
Wire Wire Line
	4600 2600 4500 2600
Connection ~ 4500 2600
Wire Wire Line
	4600 2500 4500 2500
Connection ~ 4500 2500
Wire Wire Line
	4500 2500 4500 2600
Wire Wire Line
	4600 2400 4500 2400
Connection ~ 4500 2400
Wire Wire Line
	4500 2400 4500 2500
Wire Wire Line
	4600 2300 4500 2300
Connection ~ 4500 2300
Wire Wire Line
	4500 2300 4500 2400
Wire Wire Line
	4500 2200 4600 2200
Connection ~ 4500 2200
Wire Wire Line
	4500 2200 4500 2300
Wire Wire Line
	4600 2100 4500 2100
Connection ~ 4500 2100
Wire Wire Line
	4500 2100 4500 2200
Wire Wire Line
	4600 2000 4500 2000
Connection ~ 4500 2000
Wire Wire Line
	4500 2000 4500 2100
Wire Bus Line
	3500 1000 6700 1000
Text HLabel 6600 5300 2    50   Input ~ 0
~INTACK
Wire Wire Line
	6600 5300 6400 5300
Wire Wire Line
	4600 5600 4600 5650
Text HLabel 4000 2600 0    50   Output ~ 0
~CS
Text HLabel 3500 1000 0    50   BiDi ~ 0
A[0..7]
Wire Bus Line
	3500 3500 6700 3500
Text HLabel 5350 4050 2    50   Input ~ 0
INT2
Wire Wire Line
	4500 5000 5200 5000
Wire Wire Line
	5600 5100 5300 5100
Wire Wire Line
	5200 5200 5200 5000
Connection ~ 5200 5000
Wire Wire Line
	4700 4050 4700 4500
Wire Wire Line
	4700 4050 5350 4050
Wire Wire Line
	4500 4500 4700 4500
Wire Wire Line
	5200 5000 5600 5000
Wire Wire Line
	5300 5200 5300 5100
Connection ~ 5300 5100
Wire Wire Line
	5300 5100 4500 5100
Text HLabel 6450 2600 2    50   Input ~ 0
~IORQ
Text HLabel 6450 2400 2    50   Input ~ 0
~M1
Wire Notes Line
	7250 1250 7250 3250
Wire Notes Line
	3500 1250 7250 1250
Wire Notes Line
	3500 3250 7250 3250
Wire Notes Line
	7250 3750 7250 6000
Wire Notes Line
	3500 3750 7250 3750
Wire Notes Line
	3500 6000 7250 6000
Wire Wire Line
	6450 2400 6400 2400
Wire Wire Line
	6400 2600 6450 2600
Wire Wire Line
	5600 5300 5450 5300
Wire Bus Line
	6700 1000 6700 2500
Wire Bus Line
	6700 3500 6700 5100
Text Label 5450 5300 0    50   ~ 0
+5V
$EndSCHEMATC
