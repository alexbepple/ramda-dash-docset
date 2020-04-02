
## Features


* All original content from http://ramdajs.com/
* No fluff that is not central to the docset functionality. This excludes build status, chats and whatever else is on the main page.

* "Expand/collapse parameters" for parameter description.


## Generate docset

The only requirement should be Docker. If the build needs anything else, consider it a bug.

Run

    $ make builder
    $ make
    $ make install

Only tested on macOS. However, it should work in any Docker environment.


## Update version

* `make update_published_docs`
* Change version in `Makefile`
* Generate docset.
    * Most likely, the number of functions will change. Change it in `check/docset_spec.ls`


## Icon

Generated from <http://ramda.jcphillipps.com/logo/ramdaFilled.svg> using [iConvert](http://iconverticons.com/online/).


## Manual tests

* "Open in REPL" (… `main.js` …)
