update:
	git submodule update --init --recursive

build: update
	hugo --cleanDestinationDir
