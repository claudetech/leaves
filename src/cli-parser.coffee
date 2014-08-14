path = require 'path'
ArgumentParser = require('argparse').ArgumentParser

defaultAction = 'watch'

parser = new ArgumentParser(
  prog: 'leaves'
  version: '0.1.0'
  addHelp: true
  description: 'Generator and build tool for designers.'
)

actionSubparser = parser.addSubparsers(
  title: 'Actions'
  dest: 'action'
)

newParser = actionSubparser.addParser 'new', { addHelp: true }
newParser.addArgument ['projectName'],
  action: 'store'
  help: 'Name of the project to create'

newParser.addArgument ['--css'],
  action: 'store'
  help: 'The CSS engine to use: Stylus (default) or less'

watchParser = actionSubparser.addParser 'watch', { addHelp: true }

upgradeParser = actionSubparser.addParser 'upgrade', { addHelp: true }
upgradeParser.addArgument ['-o', '--overwrite'],
  action: 'storeTrue'
  help: 'Overwrite Gruntfile.coffee and update package.json in your current project. USE WITH CARE.'

upgradeParser.addArgument ['-I', '--skip-install'],
  action: 'storeTrue'
  help: 'Skip NPM install after updating package.json. Do nothing if -o is not on.'

buildParser = actionSubparser.addParser 'build', { addHelp: true }

publishParser = actionSubparser.addParser 'publish', { addHelp: true }
publishParser.addArgument ['-B', '--skip-build'],
  action: 'storeTrue'
  help: 'Skip file compile before publishing.'
publishParser.addArgument ['-C', '--skip-commit'],
  action: 'storeTrue'
  help: 'Skip adding/commiting changes before publishing.'
publishParser.addArgument ['-I', '--skip-install'],
  action: 'storeTrue'
  help: 'Skip npm install before building. Ignored when --skip-build is active.'

addDefaultArg = (args) ->
  hasArg = false
  args.forEach (arg) ->
    unless arg == 'node' || path.basename(arg, '.js') == 'leaves' || arg[0] == '-'
      return hasArg = true
  args.push defaultAction unless hasArg

exports.parse = (args=process.argv.slice(2)) ->
  addDefaultArg args
  parser.parseArgs args
