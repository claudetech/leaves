_     = require 'underscore'

grunt = require '../grunt'
deps  = require '../deps'

exports.run = (opts) ->
  if _.isEmpty(opts.packages)
    [args, options] = [[], {}]
    deps.installAll (err) ->
      console.log if err is null then 'Dependencies have been installed' else err
      grunt.tasks 'compile:dev' if err is null
  else
    deps.install opts.packages, { save: opts.save }, opts.provider, (err) ->
      msg = "Dependencies have been installed using #{opts.provider}."
      console.log if err is null then msg else err
      grunt.tasks 'compile:dev' if err is null
