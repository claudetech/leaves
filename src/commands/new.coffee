generator = require('yeoman-generator')()
path = require 'path'
fs   = require 'fs'

exports.run = (opts) ->
  oldCwd = process.cwd()
  process.chdir path.dirname(__dirname)
  generator.lookup()
  process.chdir oldCwd
  args = ['static-website', opts.projectName]
  opts['save-config'] = false
  opts['gruntfile-path'] = '.gruntfile.coffee'
  generator.run args, opts, ->
    settings =
      project:
        appname: opts.projectName
        options:
          css: opts.css
          html: opts.html
    fs.writeFileSync '.leavesrc', JSON.stringify(settings, null, 4)
