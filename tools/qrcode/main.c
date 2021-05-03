#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "qrcode.h"

int main(int argc, char **argv)
{
	int qrVersion = 6;
	int qrErr = 1;
	int maxSize = 512*1024;
	char buffer[maxSize];
	read(STDIN_FILENO, buffer, maxSize);

    // Create the QR code
	QRCode qrcode;

	// Allocate a chunk of memory to store the QR code
    uint8_t qrcodeData[qrcode_getBufferSize(qrVersion)];

	if(qrcode_initText(&qrcode, qrcodeData, qrVersion, qrErr, buffer) < 0)
	{
		printf("qrcode: To much data to generate qrcode from. \n");
		return -1;
	}

    for (uint8_t y = 0; y < qrcode.size; y++) {
        for (uint8_t x = 0; x < qrcode.size; x++) {
            // Print each module (UTF-8 \u2588 is a solid block)
            printf(qrcode_getModule(&qrcode, x, y) ? "\u2588\u2588": "  ");
        }

        printf("\n");
    }
}
