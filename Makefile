bin := ./node_modules/.bin


all: clean build check release

clean:
	rm -r build

.PHONY: build
build: copy-docs generate-index copy-static-content

-create-docset-folder:
	mkdir -p build/Ramda.docset

copy-docs:
	mkdir -p build/Ramda.docset/Contents/Resources/Documents
	wget https://github.com/alexbepple/ramdocs/archive/gh-pages.zip -O build/ramdocs.zip
	unzip build/ramdocs.zip -d build
	cp -R build/ramdocs-gh-pages/docs/* build/Ramda.docset/Contents/Resources/Documents

copy-static-content: -create-docset-folder
	cp -R docset_static_content/* build/Ramda.docset

generate-index:
	npm install
	node generate_index.js

install:
	open build/Ramda.docset

release:
	cd build; tar --exclude='.DS_Store' -cvzf Ramda.tgz Ramda.docset


.PHONY: check
check:
	DOCSET_PATH=build/Ramda.docset $(bin)/mocha --recursive check --reporter mocha-unfunk-reporter
