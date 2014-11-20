chai = require('chai');
expect = chai.expect;
chai.use(require('chai-fs'));

r = require('ramda');
sqlite3 = require('sqlite3');
path = require('path');

docsetPath = process.env.DOCSET_PATH;
pathInDocset = (relativePath) ->
    return path.join(docsetPath, relativePath);

describe 'Ramda docset', ->
    resourcesToCheck = {
        'low-res icon': 'icon.png',
        'high-res icon': 'icon@2x.png',
        'Info.plist': 'Contents/Info.plist',
        'start page': 'Contents/Resources/Documents/index.html',
        'API page': 'Contents/Resources/Documents/R.html',
        index: 'Contents/Resources/docSet.dsidx'
    };
    expectResourceToExist = (resourceName) ->
        specify 'contains ' + resourceName, ->
            expect(pathInDocset(resourcesToCheck[resourceName])).to.be.a.file();
    r.forEach(expectResourceToExist, r.keys(resourcesToCheck));

describe 'Index', ->
    specify 'contains all the functions', (done) ->
        db = new sqlite3.Database(pathInDocset('Contents/Resources/docSet.dsidx'));
        db.get 'select count(*) from searchIndex;', (err, row) ->
            if err then throw err
            noOfIndexEntries = row[r.head(r.keys(row))];
            expect(noOfIndexEntries).to.equal(184);
            done();
