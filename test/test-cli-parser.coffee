expect = require 'expect.js'
path   = require 'path'

cliParser = require path.join(path.dirname(__dirname), 'src', 'cli-parser')

describe 'cliParser', ->
  it 'should parse new action', ->
    projectName = 'foo'
    args = cliParser.parse ['new', projectName]
    expect(args.action).to.be 'new'
    expect(args.projectName).to.be projectName

  it 'should parser run action', ->
    args = cliParser.parse ['run']
    expect(args.action).to.be 'run'

  it 'should default to run action', ->
    args = cliParser.parse []
    expect(args.action).to.be 'run'
