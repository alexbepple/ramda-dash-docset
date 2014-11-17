var chai = require('chai');
var expect = chai.expect;
chai.use(require('chai-fs'));

var r = require('ramda');
var sqlite3 = require('sqlite3');
var path = require('path');

var docsetPath = process.env.DOCSET_PATH;
var pathInDocset = function (relativePath) {
	return path.join(docsetPath, relativePath);
};

describe('Ramda docset', function() {
	var resourcesToCheck = {
		'low-res icon': 'icon.png',
		'high-res icon': 'icon@2x.png',
		'Info.plist': 'Contents/Info.plist',
		'start page': 'Contents/Resources/Documents/index.html',
		'API page': 'Contents/Resources/Documents/R.html',
		index: 'Contents/Resources/docSet.dsidx'
	};
	var expectResourceToExist = function (resourceName) {
		it('contains ' + resourceName, function() {
			expect(pathInDocset(resourcesToCheck[resourceName])).to.be.a.file();
		});
	};
	r.forEach(expectResourceToExist, r.keys(resourcesToCheck));
});

describe('Index', function() {
	it('contains all the functions', function(done) {
		var db = new sqlite3.Database(pathInDocset('Contents/Resources/docSet.dsidx'));
		db.get('select count(*) from searchIndex;', function (err, row) { 
			if (err) throw err;
			var noOfIndexEntries = row[r.head(r.keys(row))]; 
			expect(noOfIndexEntries).to.equal(184);
			done();
		});
	});
});
