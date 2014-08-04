path = require 'path'
ArgumentParser = require('argparse').ArgumentParser

defaultAction = 'run'

parser = new ArgumentParser(
  prog: 'leaves'
  version: '0.1.0'
  addHelp: true
  description: 'Generator and build tool for designers.'
)

newSubParser = parser.addSubparsers(
  title: 'Actions'
  dest: 'action'
  default: 'new'
)

newParser = newSubParser.addParser 'new', { addHelp: true }
newParser.addArgument ['projectName'],
  action: 'store'
  help: 'Name of the project to create'

runParser = newSubParser.addParser 'run', { addHelp: true }

addDefaultArg = ->
  process.argv.forEach (arg) ->
    return unless arg == 'node' || path.basename(arg) == 'leaves' || arg[0] == '-'
  process.argv.push defaultAction

exports.parse = ->
  addDefaultArg()
  args = parser.parseArgs()
  actionModule = path.join __dirname, args.action
  require(actionModule).run(args)
