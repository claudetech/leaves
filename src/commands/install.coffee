_    = require 'underscore'

deps = require '../deps'

exports.run = (opts) ->
  if _.isEmpty(opts.packages)
    [args, options] = [[], {}]
    deps.npmInstall ->
      console.log 'npm dependencies installed'
      deps.bowerInstall (err) ->
        console.log if err is null then 'bower dependencies installed' else err
  else
    deps.install opts.packages, { save: true }, opts.provider, (err) ->
      msg = "Dependencies have been installed using #{opts.provider}."
      console.log if err is null then msg else err
