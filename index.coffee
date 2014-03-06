'use strict'

PLUGIN_NAME = 'gulp-livingstyleguide'

livingstyleguide = require 'livingstyleguide'
through = require 'through2'

module.exports = (options = {}) ->

  through.obj (file, enc, next) ->

    next null, file
