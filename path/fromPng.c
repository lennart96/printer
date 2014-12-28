#include <stdio.h>
#include <stdlib.h>

#include "lodepng.h"

typedef const char * str;
typedef unsigned num;
typedef unsigned char byte;

int main(int argc, str * argv) {
    str filename = argv[1];
    unsigned err, x, y, z, w, h;
    byte * img;

    if (argc != 2) {
        fprintf(stderr, "usage: [filename.png]\n");
        exit(EXIT_FAILURE);
    }

    filename = argv[1];

    if ((err = lodepng_decode24_file(&img, &w, &h, filename))) {
        fprintf(stderr, "lodepng: %s\n", lodepng_error_text(err));
        exit(EXIT_FAILURE);
    }

    for (y = 0; y < h; y++) {
        for (x = 0; x < w; x++) {
            if (x > 0) printf(" ");
            z = 255 - ((img[3*y*w + 3*x+0]
                       +img[3*y*w + 3*x+1]
                       +img[3*y*w + 3*x+2])/3);
            printf("% 3u", z);
        }
        puts("");
    }

    return EXIT_SUCCESS;
}
