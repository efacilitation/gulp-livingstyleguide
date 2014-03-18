'use strict'

PLUGIN_NAME = 'gulp-livingstyleguide'

gutil       = require 'gulp-util'
through     = require 'through2'
module      = require 'module'
exec        = require('child_process').exec

module.exports = (options = {}) ->

  transformFunc = (file, enc, next) ->

    exec "livingstyleguide compile #{file.path}", (error, stdout, stderr) =>
      if error
        err = new gutil.PluginError PLUGIN_NAME, error
        @emit 'error', err
        return next()
      else
        console.log stdout

      if file.isNull()
        @push file
        return next()

      if file.isStream()
        err = new gutil.PluginError PLUGIN_NAME, 'Streaming not supported'
        @emit 'error', err
        return next()

      try
        file.contents = new Buffer(module(file.contents.toString(), options))
      catch error
        err = new gutil.PluginError PLUGIN_NAME, error
        @emit 'error', err

      @push file
      next()

  flushFunc = (next) ->
    next()

  through.obj transformFunc, flushFunc


