CC=gcc
ARCH=$(shell uname -s)-$(shell uname -m)
BUILDNAME=$(shell tr '[:upper:]' '[:lower:]' <<< $(ARCH))

all: main

main:
	echo -e Building for: $(BUILDNAME)

	mkdir -p bin
	$(CC) jtop.c -o ./bin/jtop-$(BUILDNAME)
	ln -s ./bin/jtop-$(BUILDNAME) ./jtop

clean:
	rm -r bin