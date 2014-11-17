var chai = require('chai');
var expect = chai.expect;
chai.use(require('chai-fs'));

var path = require('path');

var docsetPath = process.env.DOCSET_PATH;
var pathInDocset = function (relativePath) {
	return path.join(docsetPath, relativePath);
};

describe('Ramda docset', function() {
	it('contains low-res icon', function() {
		expect(pathInDocset('icon.png')).to.be.a.file();
	});
	it('contains high-res icon', function() {
		expect(pathInDocset('icon@2x.png')).to.be.a.file();
	});
	it('contains Info.plist', function() {
		expect(pathInDocset('Contents/Info.plist')).to.be.a.file();
	});
});
