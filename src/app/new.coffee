generator = require('yeoman-generator')()

run = (opts) ->
  generator.lookup()
  args = ['static-website', opts.projectName]
  generator.run args, opts

exports.run = run
