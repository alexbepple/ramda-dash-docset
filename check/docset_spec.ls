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
        'API page': 'Contents/Resources/Documents/docs/index.html'
        index: 'Contents/Resources/docSet.dsidx'
    expectResourceToExist = (resourceName) ->
        specify "contains #resourceName", ->
            expect pathInDocset(resourcesToCheck[resourceName]) .to.be.a.file!
    keys resourcesToCheck |> map expectResourceToExist

describe 'Index' ->
    specify 'contains all the functions', (done) ->
        db = new sqlite3.Database pathInDocset('Contents/Resources/docSet.dsidx'), sqlite3.OPEN_READONLY
        err, row <- db.get 'select count(*) from searchIndex where type = "Function";'
        if err then throw err
        noOfFunctions = row[keys row |> head]
        expect noOfFunctions .to.equal 255
        done!

    specify 'contains all the categories', (done) ->
        db = new sqlite3.Database pathInDocset('Contents/Resources/docSet.dsidx'), sqlite3.OPEN_READONLY
        err, row <- db.get 'select count(*) from searchIndex where type = "Category";'
        if err then throw err
        noOfCategories = row[keys row |> head]
        expect noOfCategories .to.equal 8
        done!

