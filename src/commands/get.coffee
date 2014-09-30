Repository = require('git-cli').Repository
path       = require 'path'
npm        = require 'npm'
_          = require 'underscore'
_.mixin require('underscore.string').exports()

grunt      = require '../grunt'
deps       = require '../deps'

exports.getUrl = (repo, opts={}) ->
  match = /^([a-zA-Z0-9_-]+?)\/([a-zA-Z0-9_-]+?)$/.exec repo
  return repo if match is null
  if opts.protocol == 'ssh'
    "git@github.com:#{match[1]}/#{match[2]}.git"
  else
    "https://github.com/#{match[1]}/#{match[2]}.git"

exports.run = (opts) ->
  url = exports.getUrl(opts.repository, opts)
  dirName = path.basename url, ".git"
  console.log "Fetching repository"
  repo = Repository.clone url, dirName, (err, repo) ->
    return console.log(err.toString()) unless err is null
    process.chdir repo.workingDir()
    npm.config.prefix = process.cwd()
    console.log "Installing dependencies"
    deps.installAll ->
      console.log "Building project"
      grunt.tasks 'compile:dev'
