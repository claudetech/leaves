grunt = require '../grunt'
deps  = require '../deps'
util  = require '../util'

exports.run = (opts) ->
  util.runIfInProject ->
    deps.npmInstall ->
      task = if opts.production then 'compile:dist'  else 'compile:dev'
      grunt.tasks task
