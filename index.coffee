'use strict'

PLUGIN_NAME = 'gulp-livingstyleguide'

fs = require 'fs'
exec = require('child_process').exec

gutil = require 'gulp-util'
through = require 'through2'

module.exports = (options = {}) ->

  transform = (file, enc, callback) ->
    if file.isStream()
      error = new gutil.PluginError PLUGIN_NAME, 'Streaming not supported'
      @emit 'error', error
      return callback()

    exec "bundle exec livingstyleguide compile #{file.path}", (error) =>
      if error
        error = new gutil.PluginError PLUGIN_NAME, error
        @emit 'error', error
        return callback()

      styleguideFilePath = file.path.replace /\..*$/g, ''
      styleguideHtmlFilePath = "#{styleguideFilePath}.html"

      file.path = styleguideHtmlFilePath
      styleguide = fs.readFileSync styleguideHtmlFilePath

      fs.unlink styleguideHtmlFilePath

      try
        file.contents = new Buffer styleguide
      catch error
        err = new gutil.PluginError PLUGIN_NAME, error
        @emit 'error', err
        return callback()

      @push file
      callback()

  flush = (callback) ->
    callback()

  through.obj transform, flush
