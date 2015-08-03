bin := $(shell npm bin)
lsc := $(bin)/lsc

lib := lib
build := build
vendor := vendor

docset_name := Ramda.docset
docset := $(build)/$(docset_name)
docset_html := $(docset)/Contents/Resources/Documents

all_published_docs := $(vendor)/ramdajs.com
version := 0.17
published_docs := $(all_published_docs)/$(version)


dev: clean build check install
prod: clean build check release
clean:
	rm -rf $(build)


.PHONY: build
build: static-files files-from-published_docs logo homepage api-page index


all_published_docs_archive := $(all_published_docs).tar.gz
$(all_published_docs_archive):
	mkdir -p `dirname $@`
	wget https://github.com/ramda/ramda.github.io/tarball/master -O $@
$(all_published_docs): $(all_published_docs_archive)
	mkdir -p $@
	tar -xzf $< --strip-components=1 --directory $@
.PHONY: all-published-docs
all-published-docs: $(all_published_docs)


files_from_published_docs := style.css docs/main.js docs/dist/ramda.js fonts/glyphicons-halflings-regular.woff
$(files_from_published_docs):
	ditto $(published_docs)/$@ $(docset_html)/$@
files-from-published_docs: $(files_from_published_docs)


logo_name := logo.png
logo := $(docset_html)/$(logo_name)
downloaded_logo := $(vendor)/$(logo_name)
$(downloaded_logo):
	mkdir -p `dirname $@`
	wget http://ramda.jcphillipps.com/logo/ramdaFilled_200x235.png -O $@
$(logo): $(downloaded_logo)
	ditto $< $@
logo: $(logo)


homepage := $(docset_html)/index.html
original_homepage := $(published_docs)/index.html
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


static-files:
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
$(Makefile_visualization): Makefile
	mkdir -p `dirname $@`
	$(MAKE) -Bnd | make2graph | dot -Tpng -o $@
.PHONY: visualize
visualize: $(Makefile_visualization)
	open $<
