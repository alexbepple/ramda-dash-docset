require! [fs, cheerio, sqlite3, q]
require! ramda:r
require! './util':{readFile}

createIndexAt = (indexPath) ->
    db = new sqlite3.Database indexPath
    deferred = q.defer()
    db.serialize ->
        db.run 'DROP TABLE IF EXISTS searchIndex;'
        db.run 'CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);'
        db.run 'CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);'
        deferred.resolve db
    deferred.promise


extractFunctionNames = (apiHtml) ->
    $ = cheerio.load apiHtml
    toFunction = -> $(it).data('name')
    r.map toFunction, $('li.func').get()


extractCategoriesWithFirstFunction = (apiHtml) ->
    toCategoryAndFunction = ->
        category: $(it).data('category')
        function: $(it).data('name')

    toNameOfFirstFunction = r.pipe r.head, r.prop('function')

    toFirstFunctionPerCategory = r.pipe(
        r.map toCategoryAndFunction
        r.groupBy r.prop('category')
        r.map toNameOfFirstFunction
    )

    $ = cheerio.load apiHtml
    functionEntries = $('li.func').get()
    toFirstFunctionPerCategory functionEntries


prepareInsert = (db, type) ->
    db.prepare "INSERT INTO searchIndex(name, type, path) VALUES (?, '#{type}', ?)"

writeFunctionNamesToIndex = (functionNames, db) ->
    stmt = prepareInsert db, 'Function'
    for name in functionNames
        stmt.run name, 'docs/index.html#'+name

writeCategoryNamesToIndex = (categoriesWithFirstFunction, db) ->
    stmt = prepareInsert db, 'Category'
    for category, firstFunction of categoriesWithFirstFunction
        stmt.run category, 'docs/index.html#'+firstFunction


[indexPath, apiPagePath] = process.argv[2, 3]
createIndex = r.always createIndexAt(indexPath)
getHtml = r.always readFile apiPagePath

q [getHtml().then(extractFunctionNames), createIndex()]
    .spread writeFunctionNamesToIndex
    .done()

q [getHtml().then(extractCategoriesWithFirstFunction), createIndex()]
    .spread writeCategoryNamesToIndex
    .done()
