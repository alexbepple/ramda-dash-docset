bin := ./node_modules/.bin
build_dir := build
docset_dirname := Ramda.docset
docset_path := $(build_dir)/$(docset_dirname)
index_path := $(docset_path)/Contents/Resources/docSet.dsidx
api_page_path := $(docset_path)/Contents/Resources/Documents/R.html

all: clean build check release

clean:
	if [ -d $(build_dir) ]; then rm -r $(build_dir); fi

.PHONY: build
build: copy-docs docset-index copy-static-content

-create-docset-folder:
	mkdir -p $(docset_path)

ramdocs_zip := $(build_dir)/ramdocs.zip
copy-docs:
	mkdir -p $(docset_path)/Contents/Resources/Documents
	wget https://github.com/alexbepple/ramdocs/archive/gh-pages.zip -O $(ramdocs_zip)
	unzip $(ramdocs_zip) -d $(build_dir)
	cp -R $(build_dir)/ramdocs-gh-pages/docs/* $(docset_path)/Contents/Resources/Documents

copy-static-content: -create-docset-folder
	cp -R docset_static_content/* $(docset_path)

clean-docset-index:
	rm $(index_path)
docset-index:
	npm install
	node generate_index.js $(index_path) $(api_page_path)

install:
	open $(docset_path)

release:
	cd $(build_dir); tar --exclude='.DS_Store' -cvzf Ramda.tgz $(docset_dirname)


args = 
.PHONY: check
check:
	DOCSET_PATH=$(docset_path) $(bin)/mocha --recursive check --reporter mocha-unfunk-reporter $(args)