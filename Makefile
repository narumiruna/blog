update:
	git submodule update --init --remote --recursive

build: update
	hugo --cleanDestinationDir --buildDrafts

server:
	hugo server --cleanDestinationDir --buildDrafts
