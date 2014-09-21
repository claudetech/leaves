fs         = require 'fs-extra'
grunt      = require 'grunt'
deps       = require '../deps'

exports.run = (opts) ->
  deps.npmInstall ->
    fs.removeSync 'public' if fs.existsSync 'public'
    grunt.tasks 'compile:dev'
