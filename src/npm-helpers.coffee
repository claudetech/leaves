npm = require 'npm'

exports.runInstall = (verbose, callback) ->
  npm.load {}, (err) ->
    return callback(err) unless err == null
    console.log 'Installing dependencies.' if verbose
    npm.commands.install [], callback
