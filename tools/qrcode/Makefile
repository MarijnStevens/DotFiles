
CC=gcc
FLAGS=-Os

ARCH=$(shell uname -s)-$(shell uname -m)
BUILDNAME=$(shell tr '[:upper:]' '[:lower:]' <<< $(ARCH))

all: main

main:
	echo -e Building for: $(BUILDNAME)

	mkdir -p bin
	$(CC) $(FLAGS) qrcode.c qrcode.h main.c -o ./bin/qrcode-$(BUILDNAME)
	wc -c ./bin/qrcode-$(BUILDNAME)
clean:
	rm -r bin
