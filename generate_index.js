var fs = require('fs');
var cheerio = require('cheerio');
var q = require('q');
var sqlite3 = require('sqlite3');

var indexPath = process.argv[2];
var apiPagePath = process.argv[3];

var db = new sqlite3.Database(indexPath);

var createIndex = function () {
    db.serialize(function(){
        db.run('DROP TABLE IF EXISTS searchIndex;');
        db.run('CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);');
        db.run('CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);');
    });
};

var getFunctionNames = function () {
    var deferred = q.defer();
    fs.readFile(apiPagePath, { encoding: 'utf-8' }, function (err, data) {
        if(err) throw err;

        var $ = cheerio.load(data);
        var functionNames = [];
        $('h4.name').each(function(_, elem){ functionNames.push(elem.attribs.id); });
        deferred.resolve(functionNames);
    });
    return deferred.promise;
};

var writeFunctionNamesToIndex = function (functionNames) {
    var stmt = db.prepare('INSERT INTO searchIndex(name, type, path) VALUES (?, "Function", ?)');
    functionNames.forEach(function(functionName){
        stmt.run(functionName, 'R.html#'+functionName);
    });
};

var fillIndex = function () {
    getFunctionNames().then(writeFunctionNamesToIndex);
};

createIndex();
fillIndex();

