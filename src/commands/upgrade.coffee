path   = require 'path'
spawn  = require('child_process').spawn
errors = require 'errno'
npmapi = require 'npm-web-api'
semver = require 'semver'
fs     = require 'fs-extra'
npm    = require 'npm'
_      = require 'lodash'
_.mixin require('underscore.string').exports()

pathResolver = require '../path-resolver'
deps         = require '../deps'
shell        = require '../shell'

moduleInfo = require path.join(path.dirname(path.dirname(__dirname)), 'package.json')
moduleName = moduleInfo.name

templateBasePath = 'node_modules/generator-static-website/app/templates'

compileTemplate = (file, config) ->
  config = _.merge {}, config, {options: {'is-leaves': true}}
  content = fs.readFileSync file, 'utf-8'
  _.template(content)(config)

updatePackageDependencies = (src, dest, config) ->
  srcInfo = JSON.parse compileTemplate(src, config)
  info = JSON.parse fs.readFileSync(dest, 'utf-8')
  _.each ['devDependencies', 'dependencies'], (key) ->
    _.each srcInfo[key], (version, dep) ->
      info[key][dep] = version
  fs.writeFileSync dest, JSON.stringify(info, null, 4)

updateGitignore = (src, dest) ->
  if fs.existsSync dest
    content = fs.readFileSync(dest, 'utf-8').split('\n')
  else
    content = []
  toAdd = []
  _.each compileTemplate(src, {options: {'is-leaves': true}}).split('\n'), (f) ->
    toAdd.push(f) unless _.isEmpty(f) || content.indexOf(f) > -1
  if toAdd.length > 0
    toAdd.push('')
    newContent = content.concat(toAdd)
    fs.writeFileSync dest, newContent.join('\n')

showFinalMessage = (oldVersion, newVersion) ->
  upgradeInfo =
  msg = "Your project has been upgraded"
  msg += " from #{oldVersion} to #{newVersion}" if oldVersion?
  msg += ". You're all done!"
  console.log msg

updateProjectFiles = (opts, newVersion) ->
  projectConfigFile = path.join(process.cwd(), '.leavesrc')
  projectConfig = JSON.parse(fs.readFileSync(projectConfigFile))
  if projectConfig.leaves? && semver.lte(newVersion, projectConfig.leaves)
    console.log "Your project is already up to date!"
    return
  projectGruntFile   = path.join(process.cwd(), 'Gruntfile.coffee')
  projectGruntFile   = path.join(process.cwd(), '.gruntfile.coffee') unless fs.existsSync(projectGruntFile)
  projectPackageFile = path.join(process.cwd(), 'package.json')
  projectGitignore   = path.join(process.cwd(), '.gitignore')
  if fs.existsSync(projectGruntFile) && fs.existsSync(projectPackageFile) && fs.existsSync(projectConfigFile)
    console.log 'Upgrading files in project...'
    config = _.extend JSON.parse(fs.readFileSync(projectConfigFile, 'utf-8')).project, { _: _ }

    globalGruntFile = pathResolver.fileGlobalPath moduleName, "#{templateBasePath}/website/Gruntfile.coffee"
    globalGruntFile = pathResolver.fileGlobalPath moduleName, "#{templateBasePath}/common/Gruntfile.coffee" unless fs.existsSync(globalGruntFile)
    globalPackageFile = pathResolver.fileGlobalPath moduleName, "#{templateBasePath}/website/package.json"
    globalGitignore = pathResolver.fileGlobalPath moduleName, "#{templateBasePath}/common/gitignore"

    fs.writeFileSync projectGruntFile, compileTemplate(globalGruntFile, config)
    updatePackageDependencies globalPackageFile, projectPackageFile, config
    updateGitignore(globalGitignore, projectGitignore)

    oldVersion = projectConfig.leaves
    projectConfig.leaves = newVersion
    fs.writeFileSync projectConfigFile, JSON.stringify(projectConfig, null, 4)

    if opts.skip_install
      showFinalMessage oldVersion, newVersion
    else
      deps.npmInstall { verbose: true }, ->
        showFinalMessage oldVersion, newVersion
  else
    console.warn "You do not seem to be in a Leaves project, ignoring files upgrade."

getNewVersion = ->
  info = fs.readFileSync(pathResolver.fileGlobalPath(moduleName, "package.json"), 'utf8')
  JSON.parse(info).version

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
      newVersion = getNewVersion()
      console.log "Great, Leaves has been upgraded! #{moduleInfo.version} -> #{newVersion}"
      if opts.overwrite
        updateProjectFiles opts, newVersion

exports.run = (opts) ->
  console.log "Upgrading Leaves..."
  npmapi.getLatest moduleName, (err, pkg) ->
    if semver.lt(moduleInfo.version, pkg.version)
      runUpdate true, opts
    else
      console.log "Great, Leaves is already up to date!"
      if opts.overwrite
        updateProjectFiles opts, moduleInfo.version
