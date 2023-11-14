void main() {
    const char *text = "Hello World!\r\n";
    unsigned char var=0;
    for(unsigned char i=0; i<10; i++) {
        var += text[i];
    }
}