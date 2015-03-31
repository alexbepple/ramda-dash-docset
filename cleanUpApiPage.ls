require! [fs, cheerio, q]
require! {
    ramda:r
}

readFile = (path) ->
    q.nfcall fs.readFile, path, {encoding: 'utf-8'}
writeToFile = (path) ->
    (data) -> q.nfcall fs.writeFile, path, data, {encoding: 'utf-8'}

remove = (selector, $) --> $(selector).remove()
removeLayout = ($) -> $('html').removeClass 'docs-page'

cleanUp = r.pipe(
    cheerio.load
    r.tap remove '.navbar'
    r.tap remove '.sidebar'
    r.tap removeLayout
    ($) -> $.html()
)

[source, sink] = process.argv[2, 3]

readFile source
.then cleanUp
.then writeToFile sink

