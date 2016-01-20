require! {
    ramda:r
    './util': u
    './html'
}

removeBuildStatusEtc = ($) -> $('article p').has('a[href*="travis-ci"]').remove()
removeNavCheckbox = ($) -> $('#open-nav').remove()
useLocalLogo = ($) ->
    $('img[src*=ramdaFilled]').attr('src', 'logo.png')

actions = [
    removeBuildStatusEtc
    useLocalLogo
]

[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink
