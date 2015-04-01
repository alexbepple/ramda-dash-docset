require! [fs, cheerio, sqlite3, q]
require! ramda:r
require! './util':{readFile}

createIndex = (indexPath) ->
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
    $ = cheerio.load apiHtml

    toCategoryAndFunction = ->
        category: $(it).data('category')
        function: $(it).data('name')
    nameOfFirstFunction = r.pipe r.head, r.prop('function')

    toFirstFunctionPerCategory = r.pipe(
        r.map toCategoryAndFunction
        r.groupBy r.prop('category')
        r.mapObj nameOfFirstFunction
    )
    toFirstFunctionPerCategory $('li.func').get()


writeFunctionNamesToIndex = (functionNames, db) ->
    stmt = db.prepare 'INSERT INTO searchIndex(name, type, path) VALUES (?, "Function", ?)'
    for name in functionNames
        stmt.run name, 'docs/index.html#'+name

writeCategoryNamesToIndex = (categoriesWithFirstFunction, db) ->
    stmt = db.prepare 'INSERT INTO searchIndex(name, type, path) VALUES (?, "Category", ?)'
    for category, firstFunction of categoriesWithFirstFunction
        stmt.run category, 'docs/index.html#'+firstFunction


getFunctionNames = (apiPagePath) ->
    readFile apiPagePath .then extractFunctionNames

getCategoriesWithFirstFunction = (apiPagePath) ->
    readFile apiPagePath .then extractCategoriesWithFirstFunction


[indexPath, apiPagePath] = process.argv[2, 3]

db = createIndex(indexPath)
q.all [getFunctionNames(apiPagePath), db]
    ..spread writeFunctionNamesToIndex

q.all [getCategoriesWithFirstFunction(apiPagePath), db]
    ..spread writeCategoryNamesToIndex
