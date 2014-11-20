require! {
    chai: {expect}:chai
}
chai.use require('chai-fs')
{head, keys, map} = require 'prelude-ls'

require! [sqlite3, path]

docsetPath = process.env.DOCSET_PATH
pathInDocset = (relativePath) ->
    path.join docsetPath, relativePath

describe 'Ramda docset' ->
    resourcesToCheck =
        'low-res icon': 'icon.png'
        'high-res icon': 'icon@2x.png'
        'Info.plist': 'Contents/Info.plist'
        'start page': 'Contents/Resources/Documents/index.html'
        'API page': 'Contents/Resources/Documents/R.html'
        index: 'Contents/Resources/docSet.dsidx'
    expectResourceToExist = (resourceName) ->
        specify "contains #resourceName", ->
            expect(pathInDocset(resourcesToCheck[resourceName])).to.be.a.file()
    keys resourcesToCheck |> map expectResourceToExist

describe 'Index' ->
    specify 'contains all the functions', (done) ->
        db = new sqlite3.Database pathInDocset('Contents/Resources/docSet.dsidx')
        db.get 'select count(*) from searchIndex;', (err, row) ->
            if err then throw err
            noOfIndexEntries = row[keys row |> head]
            expect(noOfIndexEntries).to.equal(184)
            done()
