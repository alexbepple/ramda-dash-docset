
## Generate docset

    $ make builder
    $ make

Only tested on macOS. However, it should work in any Docker environment.


## Update version

**This will need updating for Docker …**

* `make update_published_docs`
* Change version in `Tupfile`.
* Generate docset.
    * Most likely, the number of functions will change. Change it in `check/docset_spec.ls`


## Icon

Generated from <http://ramda.jcphillipps.com/logo/ramdaFilled.svg> using [iConvert](http://iconverticons.com/online/).

