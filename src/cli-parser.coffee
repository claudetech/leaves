path           = require 'path'
_              = require 'underscore'
ArgumentParser = require('argparse').ArgumentParser

moduleInfo = require path.join(path.dirname(__dirname), 'package.json')

defaultAction = 'watch'

parsers = {}

parser = new ArgumentParser(
  prog: 'leaves'
  version: moduleInfo.version
  addHelp: true
  description: 'Static website generator for designers.'
)

actionSubparser = parser.addSubparsers(
  title: 'Subcommands'
  dest: 'action'
)


parsers.new = newParser = actionSubparser.addParser 'new',
  addHelp: true
  description: 'Create a new project'

newParser.addArgument ['projectName'],
  action: 'store'
  help: 'Name of the project to create'
  metavar: 'PROJECT_NAME'

newParser.addArgument ['--css'],
  action: 'store'
  help: 'The CSS engine to use: Stylus (default) or less'
  defaultValue: 'stylus'
  choices: ['stylus', 'less']

newParser.addArgument ['--html'],
  action: 'store'
  help: 'The HTML template engine to use: Jade (default) or EJS'
  defaultValue: 'jade'
  choices: ['jade', 'ejs']


parsers.watch = watchParser = actionSubparser.addParser 'watch',
  addHelp: true
  description: 'Watch for changes'


parsers.upgrade = upgradeParser = actionSubparser.addParser 'upgrade', { addHelp: true }
upgradeParser.addArgument ['-o', '--overwrite'],
  action: 'storeTrue'
  help: 'Overwrite Gruntfile.coffee and update package.json in your current project. USE WITH CARE.'

upgradeParser.addArgument ['-I', '--skip-install'],
  action: 'storeTrue'
  help: 'Skip NPM install after updating package.json. Do nothing if -o is not on.'
  dest: 'skipInstall'

parsers.build = buildParser = actionSubparser.addParser 'build',
  addHelp: true
  description: 'Build the project'

buildParser.addArgument ['-p', '--production'],
  action: 'storeTrue'
  help: 'Builds for production (concat+minifiy)'
  defaultValue: true

buildParser.addArgument ['-d', '--development'],
  action: 'storeFalse'
  help: 'Builds for development (no concat/minify)'
  dest: 'production'

parsers.publish = publishParser = actionSubparser.addParser 'publish',
  addHelp: true
  description: 'Publish the project'

publishParser.addArgument ['-p', '--provider'],
  action: 'store'
  help: 'Choose provider to publish. Default "heroku".'
  defaultValue: 'heroku'
  choices: ['heroku', 'github', 'ftp']
publishParser.addArgument ['-B', '--skip-build'],
  action: 'storeTrue'
  help: 'Skip file compile before publishing.'
  dest: 'skipBuild'
publishParser.addArgument ['-C', '--skip-commit'],
  action: 'storeTrue'
  help: 'Skip adding/commiting changes before publishing.'
  dest: 'skipCommit'
publishParser.addArgument ['-I', '--skip-install'],
  action: 'storeTrue'
  help: 'Skip npm install before building. Always true when --skip-build is active.'
  dest: 'skipInstall'
publishParser.addArgument ['-d', '--use-dev'],
  action: 'storeTrue'
  help: 'Use development build instead of production build.'
  dest: 'useDev'
publishParser.addArgument ['-r', '--reset-settings'],
  action: 'storeTrue'
  help: 'Prompt for credentials instead of using .leavesrc.local'
  dest: 'resetSettings'

parsers.setup = setupParser = actionSubparser.addParser 'setup',
  addHelp: true
  description: 'Setup leaves'

setupParser.addArgument ['-I', '--skip-install'],
  action: 'storeTrue'
  help: 'Skip bower and grunt-cli install.'
  dest: 'skipInstall'

parsers.install = installParser = actionSubparser.addParser 'install',
  addHelp: true
  description: 'Install dependencies'

installParser.addArgument ['-p', '--provider'],
  action: 'store'
  help: 'Choose provider to install dependencies. Default "bower".'
  defaultValue: 'bower'
  choices: ['bower', 'npm']

installParser.addArgument ['packages'],
  action: 'store'
  help: 'Name of the packages to install'
  metavar: 'PACKAGES'
  nargs: '*'
  defaultValue: []

installParser.addArgument ['-S', '--no-save'],
  action: 'storeFalse'
  help: 'Avoid adding dependencies to bower.json or package.json'
  dest: 'save'
  defaultValue: true

parsers.get = getParser = actionSubparser.addParser 'get',
  addHelp: true
  description: 'Fetch and prepare leaves project.'

getParser.addArgument ['repository'],
  action: 'store'
  help: 'Git repository URL for the project'
  metavar: 'REPOSITORY'

getParser.addArgument ['-p', '--protocol'],
  action: 'store'
  dest: 'protocol'
  help: 'Choose the protocol to clone directory.'
  defaultValue: 'https'
  choices: ['https', 'ssh']

_.each parsers, (parser) ->
  parser.addArgument  ['--save-options'],
    action: 'store'
    dest: 'saveOptions'
    metavar: 'TYPE'
    help: 'Saves the current CLI options'
    choices: ['global', 'project', 'local']

fixArgs = (args) ->
  args.unshift defaultAction unless args[0]? && args[0][0] != '-'

exports.parse = (args=process.argv.slice(2)) ->
  fixArgs args
  parser.parseArgs args
