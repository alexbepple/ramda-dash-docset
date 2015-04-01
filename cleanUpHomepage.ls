require! [fs, cheerio, q]
require! {
    ramda:r
}

readFile = (path) ->
    q.nfcall fs.readFile, path, {encoding: 'utf-8'}
writeToFile = (path) ->
    (data) -> q.nfcall fs.writeFile, path, data, {encoding: 'utf-8'}

remove = (selector, $) --> $(selector).remove()
removeBuildStatusEtc = ($) -> $('article p').has('a[href*="travis-ci"]').remove()
useLocalLogo = ($) ->
    $('img[src*=ramdaFilled]').attr('src', 'logo.png')

cleanUp = r.pipe(
    cheerio.load
    r.tap remove '.navbar-left'
    r.tap removeBuildStatusEtc
    r.tap useLocalLogo
    ($) -> $.html()
)

[source, sink] = process.argv[2, 3]

readFile source
.then cleanUp
.then writeToFile sink

