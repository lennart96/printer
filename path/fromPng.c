#include <stdio.h>
#include <stdlib.h>

#include "lodepng.h"

typedef const char * str;
typedef unsigned num;
typedef unsigned char byte;

int main(int argc, str * argv) {
    str filename;
    unsigned err, x, y, z, w, h;
    byte * img;
    num sum, max_height;

    if (argc < 2) {
        fprintf(stderr, "usage: filename.png [max-height]\n");
        exit(EXIT_FAILURE);
    }

    filename = argv[1];
    max_height = (argc < 3) ? 255 : atoi(argv[2]); /* security :( */

    if ((err = lodepng_decode24_file(&img, &w, &h, filename))) {
        fprintf(stderr, "lodepng: %s\n", lodepng_error_text(err));
        exit(EXIT_FAILURE);
    }

    for (y = 0; y < h; y++) {
        for (x = 0; x < w; x++) {
            if (x > 0) printf(" ");
            sum = img[3*y*w + 3*x+0]
                + img[3*y*w + 3*x+1]
                + img[3*y*w + 3*x+2];
            z = sum * (max_height+1) / (256*3-1);
            if (z > max_height)
                z = max_height;
            printf("%2u", max_height-z);
        }
        puts("");
    }

    return EXIT_SUCCESS;
}
