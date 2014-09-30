fs         = require 'fs-extra'
grunt      = require '../grunt'
deps       = require '../deps'

exports.run = (opts) ->
  deps.npmInstall ->
    task = if opts.production then 'compile:dist'  else 'compile:dev'
    grunt.tasks task
