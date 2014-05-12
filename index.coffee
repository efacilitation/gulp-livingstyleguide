'use strict'

PLUGIN_NAME = 'gulp-livingstyleguide'

gutil       = require 'gulp-util'
through     = require 'through2'
_           = require 'lodash'
exec        = require('child_process').exec
cheerio     = require 'cheerio'
jade        = require 'jade'
html        = require 'html'
Vinyl       = require 'vinyl'
fs          = require 'fs'

module.exports = (options = {}) ->

  _.defaults options,
    template: "#{__dirname}/styleguide.jade"

  transformFunc = (file, enc, next) ->
    if file.isStream()
      err = new gutil.PluginError PLUGIN_NAME, 'Streaming not supported'
      @emit 'error', err
      return next()

    styleguideFilePath = file.path.replace /\..*$/g, ''
    exec "livingstyleguide compile #{file.path};", (error, stdout, stderr) =>
      if error
        err = new gutil.PluginError PLUGIN_NAME, error
        @emit 'error', err
        return next()

      tempStyleguide = fs.readFileSync styleguideFilePath
      fs.unlink styleguideFilePath

      file.path = "#{styleguideFilePath}.html"

      $ = cheerio.load tempStyleguide
      generated = $('.livingstyleguide--container').html()
      styleguide = jade.renderFile options.template,
        content: generated
        title: 'Living Style Guide'
        layout: false

      styleguide = html.prettyPrint styleguide,
        max_char: 300
        unformatted: ['b', 'code', 'em', 'pre']

      try
        file.contents = new Buffer styleguide
      catch error
        err = new gutil.PluginError PLUGIN_NAME, error
        @emit 'error', err
        return next()

      # Add css to the stream
      cssVinyl = new Vinyl
        cwd: file.cwd
        base: file.base
        path: "#{styleguideFilePath}.css"
        contents: new Buffer($('style').html())
      @push cssVinyl

      @push file
      next()

  flushFunc = (next) ->
    next()

  through.obj transformFunc, flushFunc
