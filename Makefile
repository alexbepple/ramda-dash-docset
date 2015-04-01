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
build: copy-docs docset-index clean-up-homepage clean-up-api-page copy-static-content

copy-docs:
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
clean-up-homepage: $(logo)
	rm -rf $(homepage)
	$(lsc) cleanUpHomepage $(original_homepage) $(homepage)


api_page_subpath := docs/index.html
api_page := $(docset_html)/$(api_page_subpath)
original_api_page := $(originals)/$(api_page_subpath)
clean-up-api-page:
	rm -rf $(api_page)
	$(lsc) cleanUpApiPage $(original_api_page) $(api_page)


copy-static-content:
	mkdir -p $(docset)
	cp -R static/* $(docset)


index_path := $(docset)/Contents/Resources/docSet.dsidx
clean-docset-index:
	rm -f $(index_path)
docset-index:
	$(lsc) generate_index $(index_path) $(api_page)

install:
	open $(docset)

release:
	cd $(build); tar --exclude='.DS_Store' -cvzf Ramda.tgz $(docset_name)


args =
.PHONY: check
check:
	DOCSET_PATH=$(docset) $(bin)/mocha --compilers ls:LiveScript --recursive check --reporter mocha-unfunk-reporter $(args)
