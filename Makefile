bin := $(shell npm bin)
lsc := $(bin)/lsc

lib := lib
build := build
vendor := vendor
docset_name := Ramda.docset
docset := $(build)/$(docset_name)
docset_html := $(docset)/Contents/Resources/Documents
published_doc := $(vendor)/ramdajs.com

dev: clean build check install
prod: clean build check release

clean:
	rm -rf $(build)


.PHONY: build
build: bits-from-original-doc index homepage api-page static-content


published_doc_archive := $(published_doc).tar.gz
$(published_doc_archive):
	mkdir -p `dirname $(published_doc_archive)`
	wget https://github.com/ramda/ramda.github.io/tarball/master -O $(published_doc_archive)
$(published_doc): $(published_doc_archive)
	mkdir -p $(published_doc)
	tar -xzf $(published_doc_archive) --strip-components=1 --directory $(published_doc)
bits-from-original-doc: $(published_doc)
	mkdir -p $(docset_html)
	cp -R $(published_doc)/0.13/* $(docset_html)
	rm -r $(docset_html)/fonts


logo_name := logo.png
logo := $(docset_html)/$(logo_name)
downloaded_logo := $(vendor)/$(logo_name)
homepage_subpath := index.html
homepage := $(docset_html)/$(homepage_subpath)
original_homepage := $(published_doc)/$(homepage_subpath)

$(downloaded_logo):
	mkdir -p `dirname $(downloaded_logo)`
	wget http://ramda.jcphillipps.com/logo/ramdaFilled_200x235.png -O $(downloaded_logo)
$(logo): $(downloaded_logo)
	cp $(downloaded_logo) $(logo)
homepage: $(logo)
	rm -rf $(homepage)
	$(lsc) $(lib)/generate-homepage $(original_homepage) $(homepage)


api_page_subpath := docs/index.html
api_page := $(docset_html)/$(api_page_subpath)
original_api_page := $(published_doc)/$(api_page_subpath)
api-page:
	rm -rf $(api_page)
	$(lsc) $(lib)/generate-api-page $(original_api_page) $(api_page)


static-content:
	cp -R static/* $(docset)


index_path := $(docset)/Contents/Resources/docSet.dsidx
clean-index:
	rm -f $(index_path)
index:
	$(lsc) $(lib)/generate-index $(index_path) $(api_page)


install:
	open $(docset)
release:
	cd $(build); tar --exclude='.DS_Store' -cvzf Ramda.tgz $(docset_name)


args =
.PHONY: check
check:
	DOCSET_PATH=$(docset) $(bin)/mocha --compilers ls:LiveScript --recursive check --reporter mocha-unfunk-reporter $(args)
