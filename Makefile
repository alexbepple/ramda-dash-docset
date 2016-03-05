
.DEFAULT_GOAL = build

dependencies:
	pip3 install -r requirements.txt

init: dependencies published-docs
	npm install
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

