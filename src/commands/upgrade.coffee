path   = require 'path'
spawn  = require('child_process').spawn
errors = require 'errno'
npmapi = require 'npm-web-api'
semver = require 'semver'
fs     = require 'fs-extra'
npm    = require 'npm'

libDir = path.dirname(__dirname)

pathResolver = require path.join(libDir, 'path-resolver')

moduleInfo = require path.join(path.dirname(path.dirname(__dirname)), 'package.json')
moduleName = moduleInfo.name

updatePackageDependencies = (src, dest) ->
  srcInfo = JSON.parse fs.readFileSync(src, 'utf-8')
  info = JSON.parse fs.readFileSync(dest, 'utf-8')
  info.devDependencies = srcInfo.devDependencies
  info.dependencies = srcInfo.dependencies
  fs.writeFileSync dest, JSON.stringify(info, null, 4)

updateProjectFiles = (opts) ->
  projectGruntFile = path.join(process.cwd(), 'Gruntfile.coffee')
  projectPackageFile = path.join(process.cwd(), 'package.json')
  if fs.existsSync(projectGruntFile) && fs.existsSync(projectPackageFile)
    console.log 'Upgrading files in project...'
    globalBasePath = 'node_modules/generator-static-website/app/templates/website'
    globalGruntFile = pathResolver.fileGlobalPath moduleName, "#{globalBasePath}/Gruntfile.coffee"
    globalPackageFile = pathResolver.fileGlobalPath moduleName, "#{globalBasePath}/package.json"
    fs.copySync globalGruntFile, projectGruntFile
    updatePackageDependencies globalPackageFile, projectPackageFile
    unless opts.skipInstall
      npm.load {}, (er) ->
        return unless er == null
        console.log 'Installing dependencies.'
        npm.commands.install [], ->
          console.log "Your project has been updated. You're all done!"
  else
    console.warn "You do not seem to be in a #{moduleName} project, ignoring files upgrade."

runUpdate = (retry, opts) ->
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
      return runUpdate(false, opts) if code == 3 && retry && process.platform != "win32"
      error = errors.errno[code]
      console.error "The udpate failed with code #{code} (#{error.code}): #{error.description}."
      console.error "Please try to run the update manually."
    else
      console.log "Great, #{moduleName} has been upgraded!"
      if opts.overwrite
        updateProjectFiles opts

exports.run = (opts) ->
  console.log "Upgrading #{moduleName}..."
  npmapi.getLatest moduleName, (err, pkg) ->
    if semver.lt(moduleInfo.version, pkg.version)
      runUpdate true, opts
    else
      console.log "Great, #{moduleName} is already up to date."
      if opts.overwrite
        updateProjectFiles opts
