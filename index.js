'use strict';
var gutil = require('gulp-util');
var through = require('through2');
var module = require('module');

module.exports = function (options) {
	if (!options.foo) {
		throw new gutil.PluginError('gulp-livingstyleguide', '`foo` required');
	}

	return through.obj(function (file, enc, cb) {
		if (file.isNull()) {
			this.push(file);
			return cb();
		}

		if (file.isStream()) {
			this.emit('error', new gutil.PluginError('gulp-livingstyleguide', 'Streaming not supported'));
			return cb();
		}

		try {
			file.contents = new Buffer(module(file.contents.toString(), options));
		} catch (err) {
			this.emit('error', new gutil.PluginError('gulp-livingstyleguide', err));
		}

		this.push(file);
		cb();
	});
};
