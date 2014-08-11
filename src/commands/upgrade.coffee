path   = require 'path'
spawn  = require('child_process').spawn
errors = require 'errno'
npmapi = require 'npm-web-api'
semver = require 'semver'

moduleInfo = require path.join(path.dirname(path.dirname(__dirname)), 'package.json')
moduleName = moduleInfo.name

runUpdate = (retry) ->
  if retry
    command = 'npm'
    npmOptions = ['update', '-g', moduleName]
  # on retry, try with sudo
  else
    command = 'sudo'
    npmOptions = ['npm', 'update', '-g', moduleName]
  npmUpdate = spawn command, npmOptions

  npmUpdate.on 'close', (code) ->
    unless code == 0
      return runUpdate(false) if code == 3 && retry && process.platform != "win32"
      error = errors.errno[code]
      console.error "The udpate failed with code #{code} (#{error.code}): #{error.description}."
      console.error "Please try to run the update manually."
    else
      console.log "Great, #{moduleName} has been upgraded!"

exports.run = (opts) ->
  console.log "Upgrading #{moduleName}..."
  npmapi.getLatest moduleName, (err, pkg) ->
    if semver.lt(moduleInfo.version, pkg.version)
      runUpdate(true)
    else
      console.log "Great, #{moduleName} is already up to date."
