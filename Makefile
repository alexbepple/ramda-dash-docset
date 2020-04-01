
.DEFAULT_GOAL = build_in_builder

variant := default
build_dir := build-$(variant)
pwd := $(shell pwd)


##############
# Get started
##############

builder:
	docker build -t tup .
	$(MAKE) in_builder cmd='make init'

build_in_builder:
	$(MAKE) in_builder cmd='make build'

install:
	open $(build_dir)/Ramda.docset



##############
# More
##############

build_continuously:
	$(MAKE) in_builder cmd='tup monitor --foreground --autoupdate'


##################
# Building blocks
##################

clean_tup:
	rm -rf .tup
	rm -rf $(build_dir)

init_tup:
	tup init
	tup variant *.config

install_dependencies:
	npm install

init: install_dependencies clean_tup init_tup get_published_docs

get_published_docs:
	git submodule init
	git submodule update
update_published_docs:
	cd vendor/ramda.github.io
	git checkout master
	git pull

_archive:
	# GZIP=-n and --sort=name seem to make it reproducible in this case
	# but may not be enough, cp. https://reproducible-builds.org/docs/archives/
	cd $(build_dir) && GZIP=-n tar --sort=name -czf Ramda.tgz Ramda.docset

build:
	tup
	$(MAKE) _archive

cmd = tup
in_builder:
	docker run -it --rm -v $(pwd):/app --privileged tup /bin/sh -c '$(cmd)'
