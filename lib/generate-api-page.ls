require! {
    ramda:r
    './util': u
    './html'
}

removeLeftMarginForMainContent = ($) -> $('main').css 'left', '0'
reorderFunctionsByCategory = ($) ->
    allEntries = $('main section').get()
    categoryName = -> $(it).find('.label-category').text()
    reorderByCategory = r.pipe r.groupBy(categoryName), r.values, r.flatten
    $('main') .empty() .append reorderByCategory(allEntries)

actions = [
    html.hide '.sidebar'
    removeLeftMarginForMainContent
    reorderFunctionsByCategory
]


[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink

