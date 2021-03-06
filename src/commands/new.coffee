generator = require('yeoman-generator')()
path = require 'path'
fs   = require 'fs'

moduleInfo = require '../../package.json'

exports.run = (opts) ->
  oldCwd = process.cwd()
  process.chdir path.dirname(__dirname)
  generator.lookup()
  process.chdir oldCwd
  args = ['static-website', opts.projectName]
  opts['save-config'] = false
  opts['gruntfile-path'] = '.gruntfile.coffee'
  opts['is-leaves'] = true
  generator.run args, opts, ->
    settings =
      project:
        leaves: moduleInfo.version
        appname: opts.projectName
        options:
          css: opts.css
          html: opts.html
    fs.writeFileSync '.leavesrc', JSON.stringify(settings, null, 4)
    fs.writeFileSync '.leavesrc.local', JSON.stringify({}, null, 4)
