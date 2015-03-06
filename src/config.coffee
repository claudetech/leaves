path  = require 'path'
_     = require 'lodash'
async = require 'async'
fs    = require 'fs-extra'
require './mixins'

exports.userHome = process.env.HOME ? process.env.USERPROFILE

config = {}

configs =
  local: {}
  global: {}
  project: {}

notSavable =
  global: ['saveOptions', 'action']
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

checkFile = (key, cb) ->
  if key == 'global'
    fs.ensureDir path.dirname(exports.path[key]), (err) ->
      return cb(err) if err
      fs.exists exports.path[key], (ok) ->
        return cb(null, true) if ok
        fs.writeFile exports.path[key], '{}', (err) -> cb(err, true)
  else
    fs.exists exports.path[key], (ok) ->
      return cb(null, ok) if ok || key == 'project'
      fs.exists exports.path.project, (ok) ->
        return cb(null, false) unless ok
        fs.ensureFile exports.path[key], (err) -> cb(err, true)

readFile = (fileExists, conf, key, cb) ->
  return cb(null, conf, null) unless fileExists
  fs.readJSON exports.path[key], (err, c) ->
    if err
      console.warn "Could not parse #{key} config: #{err.message}"
      return err
    conf[key] = if c? then c else {}
    cb null, conf, err

createFileOnError = (conf, err, key, cb) ->
  if err
    fs.writeJSON exports.path[key], {}, (err) -> cb(err, conf)
  else
    cb null, conf

loadConfig = (callback) ->
  async.reduce ['global', 'project', 'local'], {}, (conf, key, cb) ->
    async.waterfall [
      (cb_) -> checkFile key, cb_
      (exists, cb_) -> readFile exists, conf, key, cb_
      (conf, err, cb_) -> createFileOnError conf, err, key, cb_
    ], cb
  , (err, conf) ->
    configs = conf
    _.merge config, exports.defaults, configs.global, configs.project, configs.local
    callback err, config

configErr = (type, options={}) ->
  return "Unknown config #{type}" unless type in ['global', 'local', 'project']
  errMsg = "Could not read file #{exports.path[type]}. Maybe use '--global'?"
  return options.notFoundMsg ? errMsg unless configs[type] || options.force
  null


exports.updateConfig = (type, confDiff, options, callback) ->
  err = configErr type, options
  return callback(message: err) if err
  [options, callback] = [{}, options] if _.isFunction(options)
  _.merge configs[type], confDiff
  _.merge config, configs.global, configs.project, configs.local
  if options.save
    exports.saveConfig(type, options, callback)
  else
    callback null, config


exports.saveConfig = (type, options, callback) ->
  err = configErr type, options
  return callback(message: err) if err
  fs.writeFile exports.path[type], JSON.stringify(configs[type], null, 4), (err) ->
    callback err, configs[type]

saveCliOptions = (argv, cb) ->
  configFile = exports.path[argv.saveOptions]
  msg = "Could not read file #{configFile}.\nIf you want to save to global config, try --save-options=global."
  toUpdate = {commands: {}}
  toUpdate.commands[argv.action] = _.omit argv, (v, k) ->
    noSave = notSavable[argv.action]? && k in notSavable[argv.action]
    noSave || k in notSavable.global || _.isFunction(v) || !v?
  exports.updateConfig argv.saveOptions, toUpdate, {notFoundMsg: msg, save: true}, (err) ->
    cb err

exports.handleArgs = (argv, callback) ->
  functions = [
    (cb) ->
      argv = _.omit argv, (v) -> v == null || _.isFunction(v)
      cb null, _.defaults argv, config.commands?[argv.action]
  ]
  functions.unshift((cb) -> saveCliOptions(argv, cb)) if argv.saveOptions?
  async.waterfall functions, (err, args) ->
    callback err, args

exports.load = (callback) ->
  loadConfig (err, conf) ->
    config = _.defaults conf, exports.defaults
    callback err

recurseConf = (keys, conf, create, cb) ->
  [create, cb] = [false, create] if _.isFunction(create)
  [key, rest...] = keys
  val = conf[key]
  if _.isEmpty(rest) || _.isUndefined(val)
    if create && !_.isEmpty(rest)
      conf[key] = {}
      recurseConf(rest, conf[key], create, cb)
    else
      cb(key, conf)
  else
    recurseConf(rest, val, create, cb)

exports.get = (key, type) ->
  keys = key.split('.')
  conf = if type then configs[type] else config
  recurseConf keys, conf, (k, c) -> c[k]

exports.set = (key, val, type='project') ->
  keys = key.split('.')
  conf = configs[type]
  return unless conf?
  recurseConf keys, conf, true, (k, c) -> c[k] = val

exports.unset = (key, type='project') ->
  keys = key.split('.')
  conf = configs[type]
  return unless conf?
  recurseConf keys, conf, (k, c) -> delete c[k]

Object.defineProperty exports, 'settings',
  get: ->
    throw new Error("config is not loaded") unless config?
    config
