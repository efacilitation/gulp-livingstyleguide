'use strict'

PLUGIN_NAME = 'gulp-livingstyleguide'

gutil       = require 'gulp-util'
through     = require 'through2'
_           = require 'lodash'
exec        = require('child_process').exec
cheerio     = require 'cheerio'
jade        = require 'jade'
html        = require 'html'
fs          = require 'fs'
Vinyl       = require 'vinyl'

module.exports = (options = {}) ->

  _.defaults options,
    template: "#{__dirname}/styleguide.jade"
    css: "#{__dirname}/styleguide.css"

  transformFunc = (file, enc, next) ->
    if file.isStream()
      err = new gutil.PluginError PLUGIN_NAME, 'Streaming not supported'
      @emit 'error', err
      return next()

    styleguidePath = file.path.replace /\.lsg$/, ''
    exec "livingstyleguide compile #{file.path}; cat #{styleguidePath} & rm #{styleguidePath};", (error, stdout, stderr) =>
      if error
        err = new gutil.PluginError PLUGIN_NAME, error
        @emit 'error', err
        return next()

      file.path = styleguidePath

      $ = cheerio.load stdout
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
      cssBuffer = fs.readFileSync options.css
      cssVinyl = new Vinyl
        cwd: file.cwd
        base: file.base
        path: "#{file.base}styleguide.css"
        contents: cssBuffer
      @push cssVinyl

      @push file
      next()

  flushFunc = (next) ->
    next()

  through.obj transformFunc, flushFunc


