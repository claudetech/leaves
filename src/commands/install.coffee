_    = require 'underscore'

deps = require '../deps'

exports.run = (opts) ->
  if _.isEmpty(opts.packages)
    [args, options] = [[], {}]
    deps.installAll (err) ->
      console.log if err is null then 'Dependencies have been installed' else err
  else
    deps.install opts.packages, { save: opts.save }, opts.provider, (err) ->
      msg = "Dependencies have been installed using #{opts.provider}."
      console.log if err is null then msg else err
