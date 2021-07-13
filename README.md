# Rack Z80 Computer

![PCB](pictures/processor_serial_backplane.jpg)
Copyright 2021 Jannik Kreucher

**NOTE: This Project is still work in progress and not working at this point !**

## Table of Contents
 - [About The Project](#about-the-project)
 - [Folder Structure](#folder-structure)
  

## About The Project

The goal of this project is to understand how computers and operating systems work. This is a collection of hardware and software to create a multi purpose 8-Bit computer with the popular [ZiLog Z80](https://de.wikipedia.org/wiki/Zilog_Z80) processor as the heart of this project. Everything is contained in a [Eurocard Subrack](https://en.wikipedia.org/wiki/Eurocard_(printed_circuit_board)) formfactor because I really like the industrial look to it. This makes it really flexible and easy to expand (and good looking of course). All the parts used should still be manufacured and every PCB is etched at home so everyone can reproduce this project. I know chinese PCB houses are fairly cheap these days but I love tinkering and I have the PCB right away and dont need to wait 2 weeks for the next revision because it seems like the first design is never working.


## Folder Structure

The project is divided into following directories:
 - code
 - schematics
 - tools

[`schematics/`](schematics) contains all the PCBs I designed for this project. Each board has its own README file for way more detailed information. [`code/`](code) contains the source code for the Z80 computer itself. The directory [`tools/`](tools) contains everything needed to compile, assemble source code and other software for this project.
