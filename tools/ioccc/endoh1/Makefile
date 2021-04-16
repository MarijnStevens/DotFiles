CC=gcc
CFLAGS=-D_DEFAULT_SOURCE -std=c99 -Wall -W -Wextra -pedantic

main: bin
	$(CC) endoh1.c -DG=1 -DP=4 -DV=8 $(CFLAGS) -o bin/endoh1 -lm

bin: 
	mkdir bin