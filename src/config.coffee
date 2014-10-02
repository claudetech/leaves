path  = require 'path'
_     = require 'underscore'
async = require 'async'
fs    = require 'fs-extra'

exports.userHome = process.env.HOME ? process.env.USERPROFILE

config = null

notSavable =
  new: ['projectName']
  install: ['packages']
  get: ['repository']

exports.defaults =
  commands:
    new:
      css: 'stylus'
      html: 'jade'
    build:
      production: true
    publish:
      provider: 'heroku'
    install:
      packages: []
      provider: 'bower'
      save: true
    get:
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
      argv = _.omit argv, (v) -> v == null || _.isFunction(v)
      cb null, _.defaults argv, config.commands?[argv.action]
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
          noSave = notSavable[argv.action]? && k in notSavable[argv.action]
          k in ['action', 'saveOptions'] || noSave
        fs.writeFile configFile, JSON.stringify(conf, null, 4), (err) ->
          cb err, args
  async.waterfall functions, (err, args) ->
    callback err, args

exports.load = (callback) ->
  loadConfig (err, conf) ->
    config = _.defaults conf, exports.defaults
    callback err

Object.defineProperty exports, 'settings',
  get: ->
    throw new Error("config is not loaded") unless config?
    config
