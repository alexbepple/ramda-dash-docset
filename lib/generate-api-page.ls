require! {
    ramda:r
    './util': u
    './html'
    './dash'
}


removeLeftMarginForMainContent = ($) -> $('main').css 'margin-left', '0'

offsetFunctionAnchorSoThatTopBorderIsVisible = ($) -> $('.section-id').css 'top', '-80px'

removeLinkAnchorsToPreventJumpingToTop = ($) ->
    $('.toggle-params').removeAttr('href').css('cursor', 'pointer')

reorderFunctionsByCategory = ($) ->
    getCategoryName = -> $(it).find('.label-category').text()
    getFunctionName = -> $(it).find('a.name').text()

    allFunctionSections = $('main section').get()
    reorderByCategory = r.pipe r.groupBy(getCategoryName), r.values, r.flatten

    addAnchor = -> $(it).prepend("<div id='#{getFunctionName(it)}' class='section-id'></div>")

    processFunctionSections = r.pipe(
        r.map(addAnchor),
        reorderByCategory
    )
    $('main') .empty() .append processFunctionSections(allFunctionSections)

actions = [
    dash.referToOnlinePage 'http://ramdajs.com/docs/'
    html.hide '.sidebar'
    removeLeftMarginForMainContent
    reorderFunctionsByCategory
    offsetFunctionAnchorSoThatTopBorderIsVisible
    removeLinkAnchorsToPreventJumpingToTop
]


[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink

