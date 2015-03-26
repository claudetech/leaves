_          = require 'lodash'
trim       = require 'lodash.trim'
Repository = require('git-cli').Repository
path       = require 'path'
fs         = require 'fs-extra'
grunt      = require './grunt'

deps       = require './deps'

getRemote = (repo, callback) ->
  found = false
  repo.listRemotes (err, remotes) ->
    _.each remotes, (remote, i) ->
      repo.showRemote remote, (err, info) ->
        if err == null && /github.com/.exec info.pushUrl
          callback null, { name: remote, url: info.pushUrl } unless found
          found = true
        else if i == (remotes.length - 1) && !found
          callback "You do not seem to have any Github remotes. Aborting."

removeBranchIfNeeded = (repo, callback) ->
  repo.branch (err, branches) ->
    if 'gh-pages' in branches
      repo.branch 'gh-pages', {cli: {D: true}}, (err) ->
        callback err
    else
      callback err

switchBranch = (repo, callback) ->
  removeBranchIfNeeded repo, (err) ->
    return callback err unless err == null
    repo.checkout 'gh-pages', {cli: {orphan: true}}, (err) ->
      repo.currentBranch (err, branch) ->
        callback err

cleanupDir = (directoryPath, publicDir) ->
  ignoredFiles = (trim(f, '/') for f in fs.readFileSync('.gitignore', 'utf8').trim().split('\n'))
  toKeep = ['.git', '.gitignore'].concat(ignoredFiles)
  _.each fs.readdirSync(directoryPath), (file) ->
    fs.removeSync path.join(directoryPath, file) unless file in toKeep


prepareDir = (directoryPath, publicDir) ->
  cleanupDir directoryPath, publicDir
  files = fs.readdirSync path.join(directoryPath, publicDir)
  _.each files, (file) ->
    fs.renameSync path.join(directoryPath, publicDir, file), file
  fs.removeSync path.join(directoryPath, publicDir)

checkFiles = (repoPath, publicDir) ->
  unless fs.existsSync path.join(repoPath, publicDir, 'index.html')
    return "You do not seem to have a 'index.html' file in your public directory. Aborting."
  null

commitIfNeeded = (repo, callback) ->
  repo.status (err, status) ->
    return callback() if status.length == 0
    repo.add {cli: {all: true}}, (err) ->
      repo.commit "Preparing to publish.", (err) ->
        callback()

finalizePublish = (repo, remote, options, callback) ->
  repo.push [remote.name, 'gh-pages'], {cli: { force: true } }, (err) ->
    return callback(err) unless err == null
    repo.checkout 'master', (err) ->
      repo.branch 'gh-pages', {cli: {D: true}}, (err) ->
        callback err, remote.url

doPublish = (repo, remote, options, callback) ->
  publicDir = if options.useDev then 'public' else 'dist'
  err = checkFiles(repo.workingDir(), publicDir)
  return callback(err) unless err == null
  prepareDir repo.workingDir(), publicDir
  commitIfNeeded repo, ->
    finalizePublish repo, remote, options, callback

exports.publishToRemote = (repo, remote, options, callback) ->
  [options, callback] = [{}, options] if _.isFunction(options)
  switchBranch repo, (err) ->
    newCallback = -> doPublish(repo, remote, options, callback)
    if options.skipBuild
      newCallback()
    else
      cb = ->
        task = if options.useDev then 'compile:dev' else 'compile:dist'
        grunt.tasks task, {}, newCallback
      if options.skipInstall
        cb()
      else
        deps.npmInstall ->
          cb()

exports.publish = (repoPath, options, callback) ->
  [options, callback] = [{}, options] if _.isFunction(options)
  repository = new Repository(path.join(repoPath, '.git'))
  getRemote repository, (err, remote) ->
    return callback(err) if err != null
    newCallback = ->
      exports.publishToRemote repository, remote, options, callback
    if options.skip_commit
      newCallback()
    else
      commitIfNeeded repository, newCallback

exports.pageUrl = (url) ->
  if url.substring(0, 3) == 'git'
    regex = /git@github\.com:(.*?)\/(.*?)\.git/
  else if url.substring(0, 5) == 'https'
    regex = /https:\/\/github\.com\/(.*?)\/(.*?)\.git/
  else
    return url
  match = regex.exec url
  return url if match == null
  "http://#{match[1]}.github.io/#{match[2]}"
