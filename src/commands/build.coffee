fs         = require 'fs-extra'
grunt      = require 'grunt'
npmHelpers = require '../npm-helpers'

exports.run = (opts) ->
  npmHelpers.runInstall false, ->
    fs.removeSync 'public' if fs.existsSync 'public'
    grunt.tasks 'compile:dev'
