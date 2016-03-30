
.DEFAULT_GOAL = build

variant := default
build_dir := build-$(variant)

clean_tup:
	rm -rf .tup
	rm -rf $(build_dir)

init: clean_tup published-docs
	npm install
	pip3 install -r requirements.txt
	tup init
	tup variant *.config

published-docs:
	peru sync
update-published-docs:
	peru reup

build:
	tup

install:
	open $(build_dir)/Ramda.docset

