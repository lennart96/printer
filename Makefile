all: bin
	cp control/{output,setup-env} bin
	gcc -o bin/fromPng path/{fromPng.c,lodepng.c,lodepng.h}
	ghc -o bin/path path/Paths.hs

bin:
	mkdir -p bin

clean:
	rm -fr bin

.PHONY: all bin clean
