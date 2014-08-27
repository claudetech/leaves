grunt      = require 'grunt'
npmHelpers = require '../npm-helpers'

exports.run = (opts) ->
  npmHelpers.runInstall false, ->
    grunt.tasks 'compile:dev'
