all: clean build

build: clean
	node_modules/.bin/metalsmith

clean:
	rm -rf build

server: build
	http-server build

.PHONY: build clean
