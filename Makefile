update:
	git submodule update --init --recursive

build: update
	hugo --cleanDestinationDir --buildDrafts

server:
	hugo server --cleanDestinationDir --buildDrafts
