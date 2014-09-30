Client = require 'ftp'
_      = require 'underscore'
prompt = require 'prompt'
path   = require 'path'
fs     = require 'fs-extra'
async  = require 'async'

prompt.message = ''

settingsPath = path.join process.cwd(), '.leavesrc'
localSettingsPath = path.join process.cwd(), '.leavesrc.local'


promptFtpInfo = (callback) ->
  prompt.start()
  prompt.get [
    name: 'host'
    message: 'Enter hostname'
  ,
    name: 'user'
    message: 'Enter username'
  ,
    name: 'password'
    message: 'Type password'
    hidden: true
  ,
    name: 'cwd'
    message: 'Upload path'
  ], (err, result) ->
    callback err, result if callback?

checkConnection = (info, callback) ->
  c = new Client
  c.on 'ready', ->
    c.end()
    callback(null)
  c.on 'error', (err) ->
    if err.code == 530
      callback "Could not connect: bad credentials."
    else
      callback "Could not connect: check your settings."
  c.connect info

exports.getInfo = (options, callback) ->
  return callback("You are not in a leaves directory") unless fs.existsSync(settingsPath)
  fs.writeJSONSync(localSettingsPath, {}) unless fs.existsSync(localSettingsPath)
  settings = fs.readJSONSync localSettingsPath
  return callback(null, settings.ftp) if settings.ftp? && !options.resetSettings
  promptFtpInfo (err, result) ->
    return callback(err) if err
    ftpData = {}
    _.each result, (v, k) ->
      ftpData[k] = v unless _.isEmpty(v)
    checkConnection ftpData, (err) ->
      return callback(err) if err
      fs.writeFile localSettingsPath, JSON.stringify({ftp: ftpData}, null, 4), ->
        callback err, ftpData

processFiles = (c, files, dir, remoteDir, callback) ->
  async.eachSeries files, (file, cb) ->
    filepath = path.join dir, file
    fs.stat filepath, (err, stats) ->
      return cb(err) if err
      if stats.isDirectory()
        uploadDir c, filepath, file, null, (err) ->
          return cb(err) if err
          c.cdup (err) ->
            cb err
      else
        console.log "Uploading file #{path.join(remoteDir ? '', file)}"
        c.put filepath, file, cb
  , (err) ->
    c.pwd (er, cwd)->
      callback err

createMissingDir = (c, remoteDir, onExisting, callback) ->
  c.list (err, files) ->
    return callback(err) if err
    if _.any files, ((f) -> f.name == remoteDir && f.type == "d")
      return callback(null) unless onExisting?
      return onExisting remoteDir, callback
    c.mkdir remoteDir, true, (err) ->
      console.log "Creating directory #{remoteDir}"
      callback err

uploadDir = (c, dir, remoteDir, onExisting, callback) ->
  cb = -> fs.readdir dir, (err, files) ->
    return callback(err) if err
    processFiles c, files, dir, remoteDir, callback
  return cb() unless remoteDir?
  createMissingDir c, remoteDir, onExisting, (err) ->
    return callback(err) if err
    c.cwd remoteDir, (err) ->
      return callback(err) if err
      cb()

getClient = (info, callback) ->
  c = new Client()
  c.on 'ready', ->
    callback null, c
  c.on 'error', ->
    callback err
  c.connect info

askConfirmation = (directory, callback) ->
  prompt.start()
  prompt.get [
    name: 'ok'
    message: "#{directory} already exists. Are you sure you want to upload here? (y/n)"
  ], (err, result) ->
    return callback(err) if err
    if /^(y(es)?|no?)$/i.exec(result.ok) == null
      console.log "Invalid input."
      return askConfirmation directory, callback
    err = if result.ok[0] == 'y' then null else 'Aborted.'
    callback err

makeDirUpload = (info, dir, remoteDir, onExisting, callback) ->
  getClient info, (err, c) ->
    return callback(err) if err
    uploadDir c, dir, remoteDir, onExisting, (err) ->
      c.end()
      return callback(err) if err

exports.publish = (dir, opts, callback) ->
  exports.getInfo opts, (err, ftpData) ->
    return err if err
    makeDirUpload ftpData, dir, ftpData.cwd, askConfirmation, (err) ->
      callback err, ftpData
