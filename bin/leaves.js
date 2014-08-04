#!/usr/bin/env node

var path = require('path');
var libDir = path.join(__dirname, '..', 'lib');
var cliParser = require(path.join(libDir, 'cli-parser'));
cliParser.parse();
