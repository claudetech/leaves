path   = require 'path'
spawn  = require('child_process').spawn
errors = require 'errno'
npmapi = require 'npm-web-api'
semver = require 'semver'
fs     = require 'fs-extra'
npm    = require 'npm'
_      = require 'underscore'
_.mixin require('underscore.string').exports()

pathResolver = require '../path-resolver'
deps         = require '../deps'
shell        = require '../shell'

moduleInfo = require path.join(path.dirname(path.dirname(__dirname)), 'package.json')
moduleName = moduleInfo.name

templateBasePath = 'node_modules/generator-static-website/app/templates/website'

compileTemplate = (file, config) ->
  content = fs.readFileSync file, 'utf-8'
  _.template(content)(config)

updatePackageDependencies = (src, dest, config) ->
  srcInfo = JSON.parse compileTemplate(src, config)
  info = JSON.parse fs.readFileSync(dest, 'utf-8')
  info.devDependencies = srcInfo.devDependencies
  info.dependencies = srcInfo.dependencies
  fs.writeFileSync dest, JSON.stringify(info, null, 4)

updateProjectFiles = (opts) ->
  projectConfigFile  = path.join(process.cwd(), '.leavesrc')
  projectGruntFile   = path.join(process.cwd(), 'Gruntfile.coffee')
  projectPackageFile = path.join(process.cwd(), 'package.json')
  if fs.existsSync(projectGruntFile) && fs.existsSync(projectPackageFile) && fs.existsSync(projectConfigFile)
    console.log 'Upgrading files in project...'
    config = _.extend JSON.parse(fs.readFileSync(projectConfigFile, 'utf-8')).project, { _: _ }

    globalGruntFile = pathResolver.fileGlobalPath moduleName, "#{templateBasePath}/Gruntfile.coffee"
    globalPackageFile = pathResolver.fileGlobalPath moduleName, "#{templateBasePath}/package.json"

    fs.writeFileSync projectGruntFile, compileTemplate(globalGruntFile, config)
    updatePackageDependencies globalPackageFile, projectPackageFile, config

    unless opts.skip_install
      deps.npmInstall { verbose: true }, ->
        console.log "Your project has been updated. You're all done!"
  else
    console.warn "You do not seem to be in a #{moduleName} project, ignoring files upgrade."
    console.warn "If you just upgraded, you probably need .leavesrc file in your project. Please copy it from another project for now."

runUpdate = (retry, opts) ->
  shell.copyZshSetup()
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
      console.error "Please try to upgrade manually."
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
