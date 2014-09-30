grunt = require 'grunt'
_     = require 'underscore'
path  = require 'path'
fs    = require 'fs'

exports.tasks = (tasks, options={}, callback) ->
  unless fs.existsSync path.join(process.cwd(), 'Gruntfile.coffee')
    options = _.extend {}, options, {gruntfile: path.join(process.cwd(), '.gruntfile.coffee')}
  grunt.tasks tasks, options, callback
