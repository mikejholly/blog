all: clean build

build: clean
	node_modules/.bin/metalsmith

clean:
	rm -rf build

server: build
	http-server build

deploy: build
	cd build; rsync --del -rv . root@mikejholly.com:/srv

.PHONY: build clean
