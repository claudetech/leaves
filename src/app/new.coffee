generator = require('yeoman-generator')()

exports.run = (opts) ->
  generator.lookup()
  args = ['static-website', opts.projectName]
  generator.run args, opts

