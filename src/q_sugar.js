var q = require('q');
var r = require('ramda');

var sequence = function () {
	return r.lPartial(r.reduce, q.when, q(), arguments);
};

module.exports = {
	sequence: sequence
};
