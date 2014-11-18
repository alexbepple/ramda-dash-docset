var fs = require('fs');
var cheerio = require('cheerio');
var sqlite3 = require('sqlite3');
var db = new sqlite3.Database('build/Ramda.docset/Contents/Resources/docSet.dsidx');

db.serialize(function(){
	db.run('DROP TABLE IF EXISTS searchIndex;');
    db.run('CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);');
    db.run('CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);');
});

fs.readFile('./build/Ramda.docset/Contents/Resources/Documents/R.html', { encoding: 'utf-8' }, function (err, data) {
    if(err) throw err;

    var $ = cheerio.load(data);
    var functionNames = [];
    $('h4.name').each(function(_, elem){ functionNames.push(elem.attribs.id); });

    var stmt = db.prepare('INSERT INTO searchIndex(name, type, path) VALUES (?, "Function", ?)');
    functionNames.forEach(function(functionName){
        stmt.run(functionName, 'R.html#'+functionName);
    });
});
