all: bin
	cp control/{output,setup-env,send-cmd,set-ref,ref,x,y,z} bin
	gcc -Wall -pedantic -std=c89 -o bin/fromPng path/{fromPng.c,lodepng.c,lodepng.h}
	ghc -Wall -o bin/path path/{Command.hs,Path.hs,OrderLanes.hs,Lanes.hs}

bin:
	mkdir -p bin

clean:
	rm -fr bin

.PHONY: all bin clean
