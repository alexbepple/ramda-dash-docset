var q = require('q');
var r = require('ramda');

var reduce = function (initial) {
	return r.lPartial(r.reduce, q.when, initial, r.tail(arguments));
};

var execOrReturn = function (fn) {
	if (typeof fn === 'function') return fn.apply(null);
	return fn;
};
var all = function () {
	var fnNamesAndValues = arguments;
	var promiseAllResults = r.compose(q.all, r.map(execOrReturn));
	return promiseAllResults(fnNamesAndValues);
};

module.exports = {
	reduce: reduce,
	all: all
};
