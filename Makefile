bin := $(shell npm bin)
lsc := $(bin)/lsc

build := build
docset_name := Ramda.docset
docset := $(build)/$(docset_name)
docset_html := $(docset)/Contents/Resources/Documents
originals := ramdajs.com

all: clean build check release

clean:
	rm -rf $(build)

.PHONY: build
build: original-html index homepage api-page static-content

original-html:
	mkdir -p $(docset_html)
	cp -R $(originals)/* $(docset_html)
	rm -rf $(docset_html)/_*
	rm -rf $(docset_html)/fonts
	rm -rf $(docset_html)/repl


logo_name := logo.png
logo := $(docset_html)/$(logo_name)
homepage_subpath := index.html
homepage := $(docset_html)/$(homepage_subpath)
original_homepage := $(originals)/$(homepage_subpath)
$(logo):
	wget http://ramda.jcphillipps.com/logo/ramdaFilled_200x235.png -O $(logo)
homepage: $(logo)
	rm -rf $(homepage)
	$(lsc) generate-homepage $(original_homepage) $(homepage)


api_page_subpath := docs/index.html
api_page := $(docset_html)/$(api_page_subpath)
original_api_page := $(originals)/$(api_page_subpath)
api-page:
	rm -rf $(api_page)
	$(lsc) generate-api-page $(original_api_page) $(api_page)


static-content:
	cp -R static/* $(docset)


index_path := $(docset)/Contents/Resources/docSet.dsidx
clean-index:
	rm -f $(index_path)
index:
	$(lsc) generate-index $(index_path) $(api_page)


install:
	open $(docset)
release:
	cd $(build); tar --exclude='.DS_Store' -cvzf Ramda.tgz $(docset_name)


args =
.PHONY: check
check:
	DOCSET_PATH=$(docset) $(bin)/mocha --compilers ls:LiveScript --recursive check --reporter mocha-unfunk-reporter $(args)
