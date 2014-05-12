'use strict'

PLUGIN_NAME = 'gulp-livingstyleguide'

fs          = require 'fs'
path        = require 'path'
exec        = require('child_process').exec

_           = require 'lodash'
gutil       = require 'gulp-util'
through     = require 'through2'
Vinyl       = require 'vinyl'
cheerio     = require 'cheerio'
jade        = require 'jade'
html        = require 'html'

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

      styleguideHtmlFilePath = "#{styleguideFilePath}.html"
      styleguideCssFilePath = "#{styleguideFilePath}.css"

      tempStyleguide = fs.readFileSync styleguideHtmlFilePath
      fs.unlink styleguideHtmlFilePath

      file.path = styleguideHtmlFilePath

      $ = cheerio.load tempStyleguide
      styleguideFragment = $('.livingstyleguide--container').html()
      styleguide = jade.renderFile options.template,
        stylesheet: "link(rel='stylesheet', type='text/css', href='#{path.basename styleguideCssFilePath}')"
        content: styleguideFragment
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
