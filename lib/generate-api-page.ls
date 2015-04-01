require! {
    ramda:r
    './util': u
    './html'
}

removeLayout = ($) -> $('html').removeClass 'docs-page'

actions = r.pipe(
    r.tap html.remove '.navbar'
    r.tap html.remove '.sidebar'
    r.tap removeLayout
)


[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink

