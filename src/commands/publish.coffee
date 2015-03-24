fs              = require 'fs-extra'
path            = require 'path'
herokuPublisher = require 'heroku-publisher'
grunt           = require '../grunt'
deps            = require '../deps'
ghPublisher     = require '../gh-publisher'
ftpPublisher    = require '../ftp-publisher'
scpPublisher    = require '../scp-publisher'
util            = require '../util'
config          = require '../config'
slack           = require '../slack'

appname = ->
  config.get('project.appname') ? "Your website"

publishGithub = (opts, cb) ->
  ghPublisher.publish process.cwd(), opts, (err, remoteUrl) ->
    return console.log(err) unless err == null
    pageUrl = ghPublisher.pageUrl(remoteUrl)
    msg = "#{appname()} has been published at #{pageUrl}"
    console.log msg
    console.log "The first time, it can take up to 10 minutes to show up, so be patient."
    cb(msg)

tryCompile = (options, callback) ->
  if options.skipBuild
    callback()
  else
    task = if options.useDev then 'compile:dev' else 'compile:dist'
    cb = -> grunt.tasks task, {}, callback
    if options.skipInstall
      cb()
    else
      deps.npmInstall cb

publishHeroku = (options, cb) ->
  projectConfig = fs.readJSONSync path.join(process.cwd(), '.leavesrc')
  appName = projectConfig.herokuAppName || projectConfig.appName || process.cwd()
  publicDir = 'dist'
  if options.useDev
    build = 'leaves build --development'
  else
    build = 'leaves build'
  options = { retry: true, appName: appName, build: build, publicDir: publicDir }
  tryCompile options, ->
    herokuPublisher.publish options, (err, app) ->
      return console.warn(err) unless err is null
      projectConfig.herokuAppName = app.name
      fs.writeJSONSync path.join(process.cwd(), '.leavesrc'), projectConfig
      msg = "#{appname()} has been published to #{app.web_url}"
      console.log msg
      cb(msg)

publish = (publisher, options, cb) ->
  tryCompile options, ->
    dir = path.join process.cwd(), 'dist'
    publisher.publish dir, options, (err, info) ->
      if err?
        console.warn "An error has occured while uploading: #{err.message}"
      else
        msg = "#{appname()} has been uploaded successfully to #{info.host}."
        console.log msg
        cb(msg)

publishFtp = (options, cb) ->
  publish ftpPublisher, options, cb

publishScp = (options, cb) ->
  publish scpPublisher, options, cb

exports.run = (options) ->
  cb = (msg) ->
    slack.post {text: msg}, (err) ->
      console.log "An error has occured while posting to slack: #{err}" if err
  util.runIfInProject ->
    console.log 'Starting to publish your website.'
    if options.provider == 'github'
      publishGithub options, cb
    else if options.provider == 'ftp'
      publishFtp options, cb
    else if options.provider == 'scp'
      publishScp options, cb
    else
      publishHeroku options, cb
