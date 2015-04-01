require! {
    ramda:r
    './util': u
    './html'
}

removeLeftMarginForMainContent = ($) -> $('main').css 'left', '0'

actions = [
    html.hide '.sidebar'
    removeLeftMarginForMainContent
]


[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink

