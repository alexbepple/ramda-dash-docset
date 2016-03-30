
## Generate docset

Install system requirements:

* Node, cp. `.node-version`
* Python3
* [tup](http://gittup.org/tup)

Then run:

    $ make init
    $ make

Only tested on Mac.


## Update version

* `make update_published_docs`
* Change version in `Tupfile`.
* Generate docset.
    * Most likely, the number of functions will change. Change it in `check/docset_spec.ls`


## Icon

Generated from <http://ramda.jcphillipps.com/logo/ramdaFilled.svg> using [iConvert](http://iconverticons.com/online/).

