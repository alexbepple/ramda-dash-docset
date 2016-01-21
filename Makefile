
.DEFAULT_GOAL = build

init: published-docs
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
	open build-*/Ramda.docset

