path = require 'path'

exports.moduleGlobalPath = (module, env=process) ->
  prefix = process.config.variables.node_prefix
  basePath = path.join prefix, 'lib' unless process.platform == 'win32'
  basePath = path.join basePath, 'node_modules'
  path.join basePath, module

exports.fileGlobalPath = (module, file, env=process) ->
  modulePath = exports.moduleGlobalPath module, env
  filepath = file.split '/'
  path.join modulePath, filepath...
