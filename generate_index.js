var fs = require('fs');
var cheerio = require('cheerio');
var sqlite3 = require('sqlite3');
var db = new sqlite3.Database('build/Ramda.docset/Contents/Resources/docSet.dsidx');

db.serialize(function(){
	db.run('DROP TABLE IF EXISTS searchIndex;');
    db.run('CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);');
    db.run('CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);');
});

var entries = [];

fs.readFile('./build/Ramda.docset/Contents/Resources/Documents/R.html', { encoding: 'utf-8' }, function (err, data) {
    if(err) throw err;

    var $ = cheerio.load(data);
    $('h4.name').each(function (idx, elem) {
        var functionName = elem.attribs.id;
        entries.push({
            name: functionName,
            type: 'Function',
            path: 'R.html#' + functionName
        });
    });

    db.serialize(function(){
        entries.forEach(function(entry){
            db.run('INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ("' + entry.name + '", "' + entry.type + '", "' + entry.path + '");');
        });
    });
});
