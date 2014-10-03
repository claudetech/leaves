config = require '../config'

saveOfFail = (val, type) ->
 if val
    config.saveConfig type, {}, ->
  else
    console.warn "Could not save. Check that you are in a leaves project."

setConfig = (opts) ->
  opts.type ?= 'project'
  val = config.set opts.key, opts.value, opts.type
  saveOfFail(val, opts.type)

getConfig = (opts) ->
  val = config.get(opts.key, opts.type)
  console.log val

unsetConfig = (opts) ->
  opts.type ?= 'project'
  val = config.unset opts.key, opts.type
  saveOfFail(val, opts.type)

exports.run = (opts) ->
  switch opts.subaction
    when 'set' then setConfig(opts)
    when 'get' then getConfig(opts)
    when 'unset' then unsetConfig(opts)
