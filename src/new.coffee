generator = require('yeoman-generator')()
path = require 'path'

exports.run = (opts) ->
  generator.lookup path.dirname(__dirname)
  args = ['static-website', opts.projectName]
  generator.run args, opts

