bin := $(shell npm bin)
lsc := $(bin)/lsc

lib := lib
build := build
vendor := vendor
docset_name := Ramda.docset
docset := $(build)/$(docset_name)
docset_html := $(docset)/Contents/Resources/Documents
published_doc := $(vendor)/ramdajs.com
version := 0.15

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
	mkdir -p $(docset_html)/docs/dist
	cp -R $(published_doc)/$(version)/style.css $(docset_html)
	cp -R $(published_doc)/$(version)/docs/dist/ramda.js $(docset_html)/docs/dist/ramda.js
	cp -R $(published_doc)/$(version)/docs/main.js $(docset_html)/docs/main.js



logo_name := logo.png
logo := $(docset_html)/$(logo_name)
downloaded_logo := $(vendor)/$(logo_name)
homepage := $(docset_html)/index.html
original_homepage := $(published_doc)/$(version)/index.html

$(downloaded_logo):
	mkdir -p `dirname $(downloaded_logo)`
	wget http://ramda.jcphillipps.com/logo/ramdaFilled_200x235.png -O $(downloaded_logo)
$(logo): $(downloaded_logo)
	cp $(downloaded_logo) $(logo)
homepage: $(logo) $(original_homepage)
	rm -rf $(homepage)
	$(lsc) $(lib)/generate-homepage $(original_homepage) $(homepage)


api_page_subpath := docs/index.html
api_page := $(docset_html)/$(api_page_subpath)
original_api_page := $(published_doc)/$(api_page_subpath)
$(api_page): $(original_api_page)
	rm -rf $(api_page)
	mkdir -p `dirname $(api_page)`
	$(lsc) $(lib)/generate-api-page $(original_api_page) $(api_page)
api-page: $(api_page)


static-content:
	mkdir -p $(docset)
	cp -R static/* $(docset)


index := $(docset)/Contents/Resources/docSet.dsidx
clean-index:
$(index): $(api_page)
	rm -f $(index)
	$(lsc) $(lib)/generate-index $(index) $(api_page)
index: $(index)


install:
	open $(docset)
release:
	cd $(build); tar --exclude='.DS_Store' -cvzf Ramda.tgz $(docset_name)


args =
.PHONY: check
check:
	DOCSET_PATH=$(docset) $(bin)/mocha --compilers ls:LiveScript --recursive check --reporter mocha-unfunk-reporter $(args)


Makefile_visualization := tmp/Makefile.png
$(Makefile_visualization):
	mkdir -p `dirname $(Makefile_visualization)`
	$(MAKE) -Bnd | make2graph | dot -Tpng -o $(Makefile_visualization)
.PHONY: visualize
visualize: $(Makefile_visualization)
	open $(Makefile_visualization)
