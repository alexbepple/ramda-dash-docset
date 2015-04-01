require! {
    ramda:r
    './util': u
    './html'
}

removeLayout = ($) -> $('html').removeClass 'docs-page'

actions = [
    html.remove '.navbar'
    html.remove '.sidebar'
    removeLayout
]


[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink

