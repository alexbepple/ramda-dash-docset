
.DEFAULT_GOAL = build

variant := default
build_dir := build-$(variant)

clean_tup:
	rm -rf .tup
	rm -rf $(build_dir)

init_tup:
	tup init
	tup variant *.config

install_dependencies:
	npm install
	pip3 install -r requirements.txt

init: install_dependencies clean_tup init_tup get_published_docs

get_published_docs:
	peru sync
update_published_docs:
	peru reup

build:
	tup

install:
	open $(build_dir)/Ramda.docset

