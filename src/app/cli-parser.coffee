ArgumentParser = require('argparse').ArgumentParser

parser = new ArgumentParser(
  version: '0.1.0'
  addHelp: true
  description: 'Generator and build tool for designers.'
)

newSubParser = parser.addSubparsers(
  title: 'new'
  dest: 'action'
)

newParser = newSubParser.addParser 'new', { addHelp: true }
newParser.addArgument ['projectName'],
  action: 'store'
  help: 'Name of the project to create'

args = parser.parseArgs()
console.log args
