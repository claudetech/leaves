path = require 'path'

libDir = path.join __dirname, '..', 'lib'
cliParser = require path.join libDir, 'cli-parser'

cliParser.parse()
