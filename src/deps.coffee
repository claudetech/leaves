_   = require 'lodash'
npm = require 'npm'

try
  bower = require 'bower'
catch e
  bower = null

getArgs = (args, options, callback) ->
  [args, options, callback] = [[], {}, args] if _.isFunction(args)
  [args, options, callback] = [[], args, options] unless _.isArray(args)
  [args, options, callback]

exports.bowerInstall = (args, options, callback) ->
  [args, options, callback] = getArgs(args, options, callback)
  unless bower is null
    bower.commands.install(args, options).on('end', (results) ->
      callback(null)
    ).on 'error', (err) ->
      callback "#{err.message}, skipping bower install."
  else
    callback 'Bower not available. Try running "leaves setup".'

exports.npmInstall = (args, options, callback) ->
  [args, options, callback] = getArgs(args, options, callback)
  console.log 'Installing dependencies.' if options.verbose
  npm.config.set 'global', true if options.global
  npm.config.set 'save', true if options.save
  npm.commands.install args, callback

exports.install = (args, options, provider, callback) ->
  [provider, callback] = ['bower', provider] if _.isFunction(provider)
  if provider == 'bower'
    exports.bowerInstall args, options, callback
  else
    exports.npmInstall args, options, callback

exports.installAll = (callback) ->
  exports.npmInstall (err) ->
    return callback(err) unless err is null
    exports.bowerInstall (err) ->
      callback(err)
