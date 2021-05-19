#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "qrcodegen.h"

// Prints the given QR Code to the console.
static void printQr(const uint8_t qrcode[]) {
	int size = qrcodegen_getSize(qrcode);
	int border = 0;
	for (int y = -border; y < size + border; y++) {
		for (int x = -border; x < size + border; x++) {
			fputs((qrcodegen_getModule(qrcode, x, y) ? "\u2588\u2588" : "  "), stdout);
		}
		fputs("\n", stdout);
	}
	fputs("\n", stdout);
}

int main(int argc, char **argv)
{
   	int maxSize = 512*1024;
   	char buffer[maxSize];

    // User-supplied text
   	read(STDIN_FILENO, buffer, maxSize);
	  enum qrcodegen_Ecc errCorLvl = qrcodegen_Ecc_MEDIUM;  // Error correction level

	  // Make and print the QR Code symbol
	  uint8_t qrcode[qrcodegen_BUFFER_LEN_MAX];
	  uint8_t tempBuffer[qrcodegen_BUFFER_LEN_MAX];
	  bool ok = qrcodegen_encodeText(buffer, tempBuffer, qrcode, errCorLvl,
		  qrcodegen_VERSION_MIN, qrcodegen_VERSION_MAX, qrcodegen_Mask_AUTO, true);
	  if (ok)
		{
      printQr(qrcode);
    }
    else
    {
      printf("Failed to generate QR code.");
    }
}