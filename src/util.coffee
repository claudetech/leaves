fs    = require 'fs-extra'
path  = require 'path'

exports.runIfInProject = (cb) ->
  fs.exists path.join(process.cwd(), ".leavesrc"), (exists) ->
    if exists
      cb()
    else
      console.warn '.leavesrc not found. Maybe you are not in a leaves project.'
