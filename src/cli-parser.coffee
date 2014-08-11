path = require 'path'
ArgumentParser = require('argparse').ArgumentParser

defaultAction = 'run'

parser = new ArgumentParser(
  prog: 'leaves'
  version: '0.1.0'
  addHelp: true
  description: 'Generator and build tool for designers.'
)

actionSubparser = parser.addSubparsers(
  title: 'Actions'
  dest: 'action'
  default: 'run'
)

newParser = actionSubparser.addParser 'new', { addHelp: true }
newParser.addArgument ['projectName'],
  action: 'store'
  help: 'Name of the project to create'

runParser = actionSubparser.addParser 'run', { addHelp: true }

upgradeParser = actionSubparser.addParser 'upgrade', { addHelp: true }

addDefaultArg = (args) ->
  hasArg = false
  args.forEach (arg) ->
    unless arg == 'node' || path.basename(arg, '.js') == 'leaves' || arg[0] == '-'
      return hasArg = true
  args.push defaultAction unless hasArg

exports.parse = (args=process.argv.slice(2)) ->
  addDefaultArg args
  parser.parseArgs args
