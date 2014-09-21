deps  = require '../deps'
shell = require '../shell'

exports.run = (opts) ->
  shellType = process.env.SHELL
  if shellType? && shellType.indexOf('zsh') > -1
    shell.setupZsh()

  unless opts.skipInstall
    deps.npmInstall ['bower', 'grunt-cli'], { global: true },  ->
      console.log 'Installed bower and grunt-cli.'
