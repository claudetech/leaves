npm = require 'npm'

exports.runInstall = (verbose, callback) ->
  console.log 'Installing dependencies.' if verbose
  npm.commands.install [], callback
