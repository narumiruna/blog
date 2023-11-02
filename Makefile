update:
	git submodule update --recursive --remote

build: update
	hugo --cleanDestinationDir --buildDrafts

server:
	hugo server --cleanDestinationDir --buildDrafts
