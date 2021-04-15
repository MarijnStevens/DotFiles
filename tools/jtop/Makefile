CC=gcc
ARCH=$(shell uname -s)-$(shell uname -m) 

all: main

main:
	echo -e Building for: $(ARCH)
	
	mkdir -p bin
	$(CC) jtop.c -o ./bin/jtop-$(ARCH)

clean:
	rm -r bin