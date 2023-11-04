# Rack Z80 Code

## Install Assembler

Download zasm source
```
git clone --recurse-submodules https://github.com/Megatokio/zasm.git zasm_src
```

Build Source and install
```
cd zasm_src
make
sudo cp zasm /usr/local/bin/
sudo chmod +x /usr/local/bin/zasm
```

Uninstall
```
sudo rm /usr/local/bin/zasm
```


## Install EEPROM Programmer Software

Download eeprom programmer project files
```
git clone https://github.com/jkreucher/eeprom-programmer.git
```

Install Software
```
cd eeprom-programmer/code
sudo cp eeprom.py /usr/local/bin/eeprom
sudo chmod +x /usr/local/bin/eeprom
```

Uninstall
```
sudo rm /usr/local/bin/eeprom
```