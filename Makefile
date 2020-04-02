version = 0.27.0

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

_tup:
	tup

all_original_docs := vendor/ramda.github.io
original_docs = $(all_original_docs)/$(version)

docset = $(build_dir)/Ramda.docset
docset_docs = $(docset)/Contents/Resources/Documents

_copy_resources:
	mkdir -p $(docset)
	cp -R static/* $(docset)

	mkdir -p $(docset_docs)
	cp $(all_original_docs)/ramdaFilled_200x235.png $(docset_docs)/logo.png
	cp $(original_docs)/style.css $(docset_docs)

	mkdir -p $(docset_docs)/docs/dist
	cp $(original_docs)/docs/dist/ramda.js $(docset_docs)/docs/dist/ramda.js

# cp. https://github.com/source-foundry/Hack/issues/401#issuecomment-397102332
SOURCE_DATE_EPOCH := $(shell git show -s --format=%ct HEAD)

_archive:
	# make it reproducible, cp. https://reproducible-builds.org/docs/archives/
	cd $(build_dir) && GZIP=-n tar --sort=name \
      --mtime="@${SOURCE_DATE_EPOCH}" \
      --owner=0 --group=0 --numeric-owner \
      --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime \
	  -czf Ramda.tgz Ramda.docset

build: _copy_resources _tup
	$(MAKE) _archive

cmd = tup
in_builder:
	docker run -it --rm -v $(pwd):/app --privileged tup /bin/sh -c '$(cmd)'
