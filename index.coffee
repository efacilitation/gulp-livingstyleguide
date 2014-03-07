'use strict'

PLUGIN_NAME = 'gulp-livingstyleguide'

livingstyleguide = require 'livingstyleguide'
gutil            = require 'gulp-util'
through          = require 'through2'

module.exports = (options = {}) ->

  # throw new gutil.PluginError("gulp-livingstyleguide", "`foo` required")  unless options.foo

  through.obj (file, enc, next) ->

    if file.isNull()
      @push file
      next()
    if file.isStream()
      @emit "error", new gutil.PluginError("gulp-livingstyleguide", "Streaming not supported")
      return next()

    try
      file.contents = new Buffer(module(file.contents.toString(), options))
    catch err
      @emit "error", new gutil.PluginError("gulp-livingstyleguide", err)

    @push file
    next()
