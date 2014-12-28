all: bin
	cp control/{output,setup-env} bin
	gcc -Wall -pedantic -std=c89 -o bin/fromPng path/{fromPng.c,lodepng.c,lodepng.h}
	ghc -Wall -o bin/path path/Paths.hs

bin:
	mkdir -p bin

clean:
	rm -fr bin

.PHONY: all bin clean
