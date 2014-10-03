grunt = require '../grunt'
util  = require '../util'

exports.run = (opts) ->
  util.runIfInProject ->
    grunt.tasks [], { force: true }
