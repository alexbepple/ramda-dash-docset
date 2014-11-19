var q = require('q');
var r = require('ramda');

var sequence = function () {
	var steps = r.skip(0, arguments);
	return function () {
		return steps.reduce(q.when, q());
	};
};

module.exports = {
	sequence: sequence
};
