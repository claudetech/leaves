npm = require 'npm'
path = require 'path'

npm.load()

exports.moduleGlobalPath = (module) ->
  path.join npm.globalDir, module

exports.fileGlobalPath = (module, file) ->
  modulePath = exports.moduleGlobalPath module
  filepath = file.split '/'
  path.join modulePath, filepath...
