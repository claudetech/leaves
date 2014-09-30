#!/usr/bin/env node

var path = require('path');
var cliParser = require(path.join(path.dirname(__dirname), 'lib', 'cli-parser'));
var args = cliParser.parse();
var module = path.join(path.dirname(__dirname), 'lib', 'commands', args.action);
require('npm').load(function() {
  console.log(args);
  require(module).run(args);
});
