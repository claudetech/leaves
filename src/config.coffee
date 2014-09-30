path  = require 'path'
_     = require 'underscore'
async = require 'async'
fs    = require 'fs-extra'

exports.userHome = process.env.HOME ? process.env.USERPROFILE

config = null

commands =
  'new':
    notSavable: ['projectName']
    defaults:
      css: 'stylus'
      html: 'jade'
  build:
    defaults:
      production: true
  publish:
    defaults:
      provider: 'heroku'
  install:
    notSavable: ['packages']
    defaults:
      packages: []
      provider: 'bower'
      save: true
  get:
    notSavable: ['repository']
    defaults:
      protocol: 'https'

exports.path =
  global: path.join exports.userHome, '.leaves/config'
  project: path.join process.cwd(), '.leavesrc'
  local: path.join process.cwd(), '.leavesrc.local'

loadConfig = (callback) ->
  async.reduce ['global', 'project', 'local'], {}, (conf, key, cb) ->
    filepath = exports.path[key]
    async.waterfall [
      (cb_) ->
        if key == 'global'
          fs.ensureFile filepath, (err) -> cb_(err, true)
        else
          fs.exists filepath, (ok) -> cb_(null, ok)
    , (exists, cb_) ->
        return cb_(null, conf, null) unless exists
        fs.readJSON filepath, (err, c) ->
          _.extend(conf, c) if c?
          cb_ null, conf, err
    , (conf, err, cb_) ->
      if err
        fs.writeJSON filepath, {}, (err) -> cb_(err, conf)
      else
        cb_ null, conf
    ], cb
  , (err, conf) ->
    callback err, conf

exports.handleArgs = (argv, callback) ->
  functions = [
    (cb) ->
      cb null, _.extend({}, config.commands?[argv.action], argv)
  ]
  if argv.saveOptions?
    configFile = exports.path[argv.saveOptions]
    functions.push (args, cb) ->
      fs.readJSON configFile, (err, conf) ->
        if err && err.code == 'ENOENT'
          cb({message: "Could not read file #{configFile}.\nIf you want to save to global config, try --save-options=global."}, conf, args)
        else
          cb(err, conf, args)
    ,
      (conf, args, cb) ->
        conf.commands ?= {}
        conf.commands[argv.action] = _.omit args, (v, k) ->
          noSave = commands[argv.action]?.notSavable?
          k in ['action', 'saveOptions'] || (noSave && k in noSave)
        fs.writeFile configFile, JSON.stringify(conf, null, 4), (err) ->
          cb err, args
  async.waterfall functions, (err, args) ->
    callback err, args

exports.load = (callback) ->
  loadConfig (err, conf) ->
    config = conf
    callback err

Object.defineProperty exports, 'settings',
  get: ->
    throw new Error("config is not loaded") unless config?
    config
