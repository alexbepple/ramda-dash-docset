require! [fs, cheerio, sqlite3, q]

createIndex = (indexPath) ->
	db = new sqlite3.Database indexPath
	deferred = q.defer()
	db.serialize ->
		db.run 'DROP TABLE IF EXISTS searchIndex;'
		db.run 'CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);'
		db.run 'CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);'
		deferred.resolve db
	deferred.promise

readFile = (path) ->
	q.nfcall fs.readFile, path, {encoding: 'utf-8'}

extractFunctionNames = (apiHtml) ->
	$ = cheerio.load apiHtml
	indexEntryToFunctionName = (_, elem) -> $(this).data('name')
	functionNames = $('li.func').map(indexEntryToFunctionName).get()
	functionNames

writeFunctionNamesToIndex = (functionNames, db) ->
	stmt = db.prepare 'INSERT INTO searchIndex(name, type, path) VALUES (?, "Function", ?)'
	for name in functionNames
		stmt.run name, 'docs/index.html#'+name

getFunctionNames = (apiPagePath) ->
	readFile apiPagePath .then extractFunctionNames

[indexPath, apiPagePath] = process.argv[2, 3]

q.all [getFunctionNames(apiPagePath), createIndex(indexPath)]
	..spread writeFunctionNamesToIndex
