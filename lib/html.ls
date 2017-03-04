require! {
    cheerio
    ramda:r
}

remove = (selector, $) --> $(selector).remove()
hide = (selector, $) --> $(selector).css 'display', 'none'

unlinkLibraryName = ($) -> $('a.navbar-brand').attr 'href', null

removeMenuItems = remove 'header.navbar .navbar-nav'
removeMenuIcon = remove 'header.navbar label.open-nav'

defaultActions = [
    removeMenuItems
    removeMenuIcon
    unlinkLibraryName
]
process = (actions) ->
    taps = r.map r.tap, r.concat(defaultActions, actions)
    r.pipe(
        cheerio.load
        r.apply r.pipe, taps
        ($) -> $.html()
    )

module.exports = {
    process
    remove
    hide
}
