require! [fs, q]

readFile = (path) ->
    q.nfcall fs.readFile, path, {encoding: 'utf-8'}
writeToFile = (path) ->
    (data) -> q.nfcall fs.writeFile, path, data, {encoding: 'utf-8'}

module.exports = {
    readFile
    writeToFile
}
