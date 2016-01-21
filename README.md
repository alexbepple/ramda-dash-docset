
## Generate docset

Get Node.
Get [peru](https://github.com/buildinspace/peru).
Then run:

    $ make init
    $ make

Only tested on Mac.


### Node versions

I could build with

* node v0.12.9 (npm v2.14.9)

I could not build with

* node v5.3.0 (npm v2.14.15)
* node v5.4.1 (npm v3.3.12)


## Update version

* `make update-published-docs`
* Change version in `Tupfile`.
* Generate docset.
    * Most likely, the number of functions will change. Fix it in `check/docset_spec.ls`


## Icon

Generated from <http://ramda.jcphillipps.com/logo/ramdaFilled.svg> using [iConvert](http://iconverticons.com/online/).
