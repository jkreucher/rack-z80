#!/bin/python3
#
# EEPROM Programmer Software
# **************************
#    by Jannik Kreucher
#  This program interfaces with the programmer and
#  can be used with other python programs by
#  refering to the classes defined below.

import serial
import sys
import os
import time
import math
from argparse import ArgumentParser, HelpFormatter



class eeprom_prog:
	def __init__(self, port, baud):
		try:
			self.serport = serial.Serial(port, baud, timeout=2)
			# delete everything that we received until now (ignore that)
			self.serport.flush()
		except:
			print("[-] Failed to open serial port: "+port)
			exit()
	
	def close(self):
		self.serport.close()

	def read_byte(self, address):
		# write address to programmer
		self.serport.write(("r%04x" % address).encode("ascii"))
		# read two bytes and convert to value
		return int( self.serport.read(2).decode("ascii"), 16 )
	
	def write_byte(self, address, data):
		# write address and data to programmer
		self.serport.write( ("w%04x%02x" % (address, data)).encode("ascii") )
		# read byte written to eeprom (convert from hex str to value)
		return int( self.serport.read(2).decode("ascii"), 16 )
	
	def diable_protect(self):
		# tell programmer to diable write protect
		self.serport.write('d'.encode("ascii"))
		# return response
		return self.serport.read(1).decode("ascii")

	def print_table(self, addr_start=0x00, addr_end=0xff):
		for row in range(addr_start>>4, (addr_end>>4)+1):
			row_str = ""
			for col in range(16):
				row_str += "%02X " % self.read_byte( (row<<4)+col )
			print(("%04X: "%(row<<4)) + row_str)
	
	def progressbar(self, val, maxval, length=40, fillchar="#", emptychar="-"):
		length_fill = int( float(val) / float(maxval) * float(length) )
		chars = fillchar*length_fill + emptychar*(length-length_fill)
		outstr = "\rProgress: ["+chars+"] %6.2f" % (float(val)/float(maxval)*100.0)
		outstr += " %"
		print(outstr, end="", flush=True)


# only execute when not called by another python program
if __name__ == "__main__":
	
	# Argument stuff
	def formatter(prog):
		return HelpFormatter(prog, max_help_position=100, width=200)
	
	parser = ArgumentParser(sys.argv[0], formatter_class=formatter)

	parser.add_argument("-p", "--port",   type=str, help="UART Port",              metavar="PORT", default="/dev/ttyACM0")
	parser.add_argument("-b", "--baud",   type=int, help="UART Baudrate",          metavar="RATE", default=115200)
	parser.add_argument("-d", "--device", type=str, help="EEPROM (28c64, 28c256)", metavar="TYPE", default="28c64")
	parser.add_argument("-s", "--start",  type=int, help="EEPROM start address",   metavar="ADDR", default=0)
	parser.add_argument("-e", "--erase",  action='store_true', help="Erase EEPROM")
	parser.add_argument("-o", "--off",  action='store_true', help="Disable Write Protect")
	parser.add_argument("-w", "--write",  type=str, help="Write file to eeprom",   metavar="FILE")
	parser.add_argument("-r", "--read",   type=str, help="Read eeprom to file",    metavar="FILE")
	args = parser.parse_args()

	# programmer class
	programmer = eeprom_prog(args.port, args.baud)

	# other arguments
	eeprom_addr = args.start
	eeprom_size = 8192
	if args.device.upper() == "28C256":
		eeprom_size = 32768
	
	# disable write protect
	if args.off:
		print("[-] Disable write protect")
		response = programmer.diable_protect()
		if not response == 'd':
			print("[-] Failed to disable write protect")
			programmer.close()
			exit()
		print("[+] OK")

	# erase eeprom
	if args.erase:
		print("[*] Erasing EEPROM (%d bytes)" % eeprom_size)
		while eeprom_addr < eeprom_size:
			written = programmer.write_byte(eeprom_addr, 0xFF)
			time.sleep(0.005)
			programmer.progressbar(eeprom_addr, eeprom_size)
			if written != 0xFF:
				print("\n[!] Failed to erase byte %d" % eeprom_addr)
				programmer.close()
				exit()
			eeprom_addr += 1
		eeprom_addr = args.start
		print("\n[+] Done")

	# check what to do next
	if args.write:
		# exit if file not there
		if not os.path.isfile(args.write):
			print("[-] Failed to open file")
			programmer.close()
			exit()
		# exit if file too large
		if os.path.getsize(args.write) > eeprom_size:
			print("[-] Not enough space for File")
			programmer.close()
			exit()
		# everything is ok, write file now
		print("[*] Writing file to EEPROM")
		f = open(args.write, "rb")
		while 1:
			# get single byte from file
			data = f.read(1)
			# exit if at end of file
			if not data:
				break
			# write data to eeprom
			written = programmer.write_byte(eeprom_addr, ord(data))
			time.sleep(0.005)
			programmer.progressbar(eeprom_addr, os.path.getsize(args.write)-1)
			if written != ord(data):
				print("\n[!] Failed to write byte %d" % eeprom_addr)
				programmer.close()
				exit()
			# next addr
			eeprom_addr += 1
		f.close()
		print("\n[+] Done")
	
	elif args.read:
		print("[*] Writing %d bytes to file" % eeprom_size)
		f = open(args.read, "wb")
		while eeprom_addr < eeprom_size:
			# read byte from eeprom
			data = programmer.read_byte(eeprom_addr)
			time.sleep(0.005)
			programmer.progressbar(eeprom_addr, eeprom_size)
			f.write(data.to_bytes(1, 'big'))
			eeprom_addr += 1
		f.close()
		print("\n[+] Done")

	else:
		if not args.erase and not args.off:
			print("[!] Read or Write EEPROM ?")
			print("use option -h for more information")
			exit()

	programmer.close()
	
