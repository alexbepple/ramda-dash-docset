bin := $(shell npm bin)
lsc := $(bin)/lsc

lib := lib
build := build
vendor := vendor
docset_name := Ramda.docset
docset := $(build)/$(docset_name)
docset_html := $(docset)/Contents/Resources/Documents
all_published_docs := $(vendor)/ramdajs.com
version := 0.15
published_docs := $(all_published_docs)/$(version)


dev: clean build check install
prod: clean build check release

clean:
	rm -rf $(build)


.PHONY: build
build: bits-from-original-doc index homepage api-page static-content


all_published_docs_archive := $(all_published_docs).tar.gz
$(all_published_docs_archive):
	mkdir -p `dirname $@`
	wget https://github.com/ramda/ramda.github.io/tarball/master -O $@
$(all_published_docs): $(all_published_docs_archive)
	mkdir -p $@
	tar -xzf $< --strip-components=1 --directory $@


bits_from_original_doc_files := style.css docs/main.js docs/dist/ramda.js
bits_from_original_doc := $(foreach bit,$(bits_from_original_doc_files),$(docset_html)/$(bit))
$(bits_from_original_doc): $(docset_html)/%: $(published_docs)/%
	mkdir -p `dirname $@`
	cp $< $@
bits-from-original-doc: $(bits_from_original_doc)


logo_name := logo.png
logo := $(docset_html)/$(logo_name)
downloaded_logo := $(vendor)/$(logo_name)
homepage := $(docset_html)/index.html
original_homepage := $(published_docs)/index.html

$(downloaded_logo):
	mkdir -p `dirname $@`
	wget http://ramda.jcphillipps.com/logo/ramdaFilled_200x235.png -O $@
$(logo): $(downloaded_logo)
	mkdir -p `dirname $@`
	cp $< $@
$(homepage): $(original_homepage)
	$(lsc) $(lib)/generate-homepage $< $@
homepage: $(homepage)


api_page_subpath := docs/index.html
api_page := $(docset_html)/$(api_page_subpath)
original_api_page := $(published_docs)/$(api_page_subpath)
$(api_page): $(original_api_page)
	mkdir -p `dirname $@`
	$(lsc) $(lib)/generate-api-page $< $@
api-page: $(api_page)


static-content:
	mkdir -p $(docset)
	cp -R static/* $(docset)


index := $(docset)/Contents/Resources/docSet.dsidx
$(index): $(api_page)
	$(lsc) $(lib)/generate-index $@ $<
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
	mkdir -p `dirname $@`
	$(MAKE) -Bnd | make2graph | dot -Tpng -o $@
.PHONY: visualize
visualize: $(Makefile_visualization)
	open $<
