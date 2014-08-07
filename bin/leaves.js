#!/usr/bin/env node

var path = require('path');
var cliParser = require(path.join(path.dirname(__dirname), 'lib', 'cli-parser'));
var args = cliParser.parse().options;
require(path.join(path.dirname(__dirname), 'lib', args.action)).run(args);
