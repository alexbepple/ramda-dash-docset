var q = require('q');
var r = require('ramda');

var sequence = function () {
	return r.lPartial(r.reduce, q.when, q(), arguments);
};

var exec = function (fn) {
	return fn.apply(null);
};
var all = function () {
	var fnNames = arguments;
	var promiseAllResults = r.compose(q.all, r.map(exec));
	return promiseAllResults(fnNames);
};

module.exports = {
	sequence: sequence,
	all: all
};
