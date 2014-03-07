'use strict'
assert = require 'assert'
gutil = require 'gulp-util'
livingstyleguide = require  '../index'

describe 'The Plugin Tests', ->

  it 'should work', (cb) ->

    stream = livingstyleguide()

    stream.on 'data', (file) ->
      expect(file.relative).toEqual 'file.ext'
      expect(file.contents.toString()).toEqual 'unicorns'

    stream.on "end", cb
    stream.write new gutil.File(
      base: __dirname
      path: __dirname + 'file.ext'
      contents: new Buffer('unicorns')
    )

    stream.end()
