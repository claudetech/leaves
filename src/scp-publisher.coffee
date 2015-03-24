_      = require 'lodash'
prompt = require 'prompt'
client = require 'scp2'
async  = require 'async'
path   = require 'path'
fs     = require 'fs'

config = require './config'

promptScpInfo = (callback) ->
  prompt.start()
  prompt.get [
    name: 'host'
    message: 'Enter hostname'
  ,
    name: 'username'
    message: 'Enter username'
  ,
    name: 'path'
    message: 'Upload path'
  ,
    name: 'privateKeyPath'
    message: 'Private key path'
    default: path.join(config.userHome, '.ssh', 'id_rsa')
  ,
    name: 'passphrase'
    message: 'SSH passphrase (enter for blank)'
    hidden: true
  ], (err, result) ->
    callback err, result if callback?

saveInfo = (info, cb) ->
  delete info.privateKey
  config.set 'scp', info, 'local'
  config.saveConfig 'local', {}, (err, info) ->
    cb(err, info?.scp)

getInfo = (cb) ->
  return cb(null, config.settings.scp) if config.settings.scp
  promptScpInfo cb

addPrivateKey = (info, cb) ->
  fs.readFile info.privateKeyPath, (err, data) ->
    return cb(err) if err?
    info.privateKey = data
    cb(null, info)

upload = (dir, info, cb) ->
  return cb('Could not get info, check your configuration.') unless info.host && info.username && info.path
  client.scp dir, info, (err) ->
    cb(err, info)

exports.publish = (dir, opts, callback) ->
  async.waterfall [
    getInfo
    addPrivateKey
    (info, cb) -> upload(dir, info, cb)
    saveInfo
  ], callback
