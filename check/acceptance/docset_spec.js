var chai = require('chai');
var expect = chai.expect;
chai.use(require('chai-fs'));
var r = require('ramda');

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
		'index page': 'Contents/Resources/Documents/index.html',
		'API html': 'Contents/Resources/Documents/R.html',
		index: 'Contents/Resources/docSet.dsidx'
	};
	var expectResourceToExist = function (resourceName) {
		it('contains ' + resourceName, function() {
			expect(pathInDocset(resourcesToCheck[resourceName])).to.be.a.file();
		});
	};
	r.forEach(expectResourceToExist, r.keys(resourcesToCheck));
});
