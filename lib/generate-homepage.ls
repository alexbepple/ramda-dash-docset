require! {
    ramda:r
    './util': u
    './html'
}

removeBuildStatusEtc = ($) -> $('article p').has('a[href*="travis-ci"]').remove()
useLocalLogo = ($) ->
    $('img[src*=ramdaFilled]').attr('src', 'logo.png')

actions = r.pipe(
    r.tap html.remove '.navbar-left'
    r.tap removeBuildStatusEtc
    r.tap useLocalLogo
)


[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink
