generator = require('yeoman-generator')()
path = require 'path'

exports.run = (opts) ->
  oldCwd = process.cwd()
  process.chdir path.dirname(__dirname)
  generator.lookup()
  process.chdir oldCwd
  args = ['static-website', opts.projectName]
  generator.run args, opts
