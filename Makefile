bin := $(shell npm bin)
lsc := $(bin)/lsc
build_dir := build
docset_dirname := Ramda.docset
docset_path := $(build_dir)/$(docset_dirname)
index_path := $(docset_path)/Contents/Resources/docSet.dsidx
api_page_path := $(docset_path)/Contents/Resources/Documents/docs/index.html
docset_docs := $(docset_path)/Contents/Resources/Documents
originals := ramdajs.com

all: clean build check release

clean:
	rm -rf $(build_dir)

.PHONY: build
build: copy-docs docset-index clean-up-homepage clean-up-api-page copy-static-content

copy-docs:
	mkdir -p $(docset_docs)
	cp -R $(originals)/* $(docset_docs)
	rm -rf $(docset_docs)/_*
	rm -rf $(docset_docs)/fonts
	rm -rf $(docset_docs)/repl


logo_name := logo.png
logo := $(docset_docs)/$(logo_name)
homepage_subpath := index.html
homepage := $(docset_docs)/$(homepage_subpath)
original_homepage := $(originals)/$(homepage_subpath)
$(logo):
	wget http://ramda.jcphillipps.com/logo/ramdaFilled_200x235.png -O $(logo)
clean-up-homepage: $(logo)
	rm -rf $(homepage)
	$(lsc) cleanUpHomepage $(original_homepage) $(homepage)


api_page_subpath := docs/index.html
api_page := $(docset_docs)/$(api_page_subpath)
original_api_page := $(originals)/$(api_page_subpath)
clean-up-api-page:
	rm -rf $(api_page)
	$(lsc) cleanUpApiPage $(original_api_page) $(api_page)


copy-static-content:
	mkdir -p $(docset_path)
	cp -R docset_static_content/* $(docset_path)

clean-docset-index:
	rm -f $(index_path)
docset-index:
	$(lsc) generate_index $(index_path) $(api_page_path)

install:
	open $(docset_path)

release:
	cd $(build_dir); tar --exclude='.DS_Store' -cvzf Ramda.tgz $(docset_dirname)


args =
.PHONY: check
check:
	DOCSET_PATH=$(docset_path) $(bin)/mocha --compilers ls:LiveScript --recursive check --reporter mocha-unfunk-reporter $(args)
