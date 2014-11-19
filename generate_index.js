var fs = require('fs');
var cheerio = require('cheerio');
var q = require('q');
var _q = require('./src/q_sugar');
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

var readApiHtml = function () {
    return q.nfcall(fs.readFile, apiPagePath, { encoding: 'utf-8' });
};

var extractFunctionNames = function (apiHtml) {
    var $ = cheerio.load(apiHtml);
    var functionNames = [];
    $('h4.name').each(function(_, elem){ functionNames.push(elem.attribs.id); });
    return functionNames;
};

var writeFunctionNamesToIndex = function (functionNames) {
    var stmt = db.prepare('INSERT INTO searchIndex(name, type, path) VALUES (?, "Function", ?)');
    functionNames.forEach(function(functionName){
        stmt.run(functionName, 'R.html#'+functionName);
    });
};

var fillIndex = _q.sequence(
    readApiHtml, extractFunctionNames, writeFunctionNamesToIndex);

createIndex();
fillIndex();

