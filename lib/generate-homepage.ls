require! {
    ramda:r
    './util': u
    './html'
    './dash'
}

removeBuildStatusEtc = ($) -> $('article p').has('a[href*="travis-ci"]').remove()
useLocalLogo = ($) ->
    $('img[src*=ramdaFilled]').attr('src', 'logo.png')
removeGitterLink = ($) -> $('script').remove()

actions = [
    dash.referToOnlinePage 'http://ramdajs.com/'
    removeBuildStatusEtc
    removeGitterLink
    useLocalLogo
]

[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink
