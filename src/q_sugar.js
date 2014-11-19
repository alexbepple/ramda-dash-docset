var q = require('q');
var r = require('ramda');

var reduce = function (initial) {
	return r.lPartial(r.reduce, q.when, initial, r.tail(arguments));
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
	reduce: reduce,
	all: all
};
