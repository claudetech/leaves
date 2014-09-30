fs              = require 'fs-extra'
path            = require 'path'
herokuPublisher = require 'heroku-publisher'
grunt           = require '../grunt'
deps            = require '../deps'
ghPublisher     = require '../gh-publisher'

publishGithub = (opts) ->
  ghPublisher.publish process.cwd(), opts, (err, remoteUrl) ->
    return console.log(err) unless err == null
    pageUrl = ghPublisher.pageUrl(remoteUrl)
    console.log "Your website has been published at #{pageUrl}"
    console.log "The first time, it can take up to 10 minutes to show up, so be patient."

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

publishHeroku = (options) ->
  config = fs.readJSONSync path.join(process.cwd(), '.leavesrc')
  appName = config.herokuAppName || config.appName || process.cwd()
  if options.useDev
    build = 'leaves build'
    publicDir = 'public'
  else
    build = 'leaves build --production'
    publicDir = 'dist'
  options = { retry: true, appName: appName, build: build, publicDir: publicDir }
  tryCompile options, ->
    herokuPublisher.publish options, (err, app) ->
      return console.warn(err) unless err is null
      config.herokuAppName = app.name
      fs.writeJSONSync path.join(process.cwd(), '.leavesrc'), config
      console.log "Your app has been published to #{app.web_url}"

exports.run = (options) ->
  console.log 'Starting to publish your website.'
  if options.provider == 'github'
    publishGithub options
  else
    publishHeroku options
