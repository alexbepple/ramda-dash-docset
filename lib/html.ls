require! {
    cheerio
    ramda:r
}

remove = (selector, $) --> $(selector).remove()

process = (actions) -> r.pipe(
    cheerio.load
    actions
    ($) -> $.html()
)

module.exports = {
    process
    remove
}
