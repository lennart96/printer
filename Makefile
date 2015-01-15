CPSRC=output setup-env send-img send-cmd set-ref ref x y z

all: bin
	cp $(CPSRC:%=control/%) bin
	gcc -Wall -pedantic -std=c89 -o bin/fromPng path/{fromPng.c,lodepng.c}
	ghc -Wall -o bin/path path/{Command.hs,Path.hs,OrderLanes.hs,Lanes.hs}
	ghc -Wall -o bin/talk control/SendCmd.hs

bin:
	mkdir -p bin

clean:
	rm -fr bin

.PHONY: all bin clean
