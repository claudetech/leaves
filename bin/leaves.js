#!/usr/bin/env node

var path           = require('path');
var cliParser      = require('../lib/cli-parser');
var config         = require('../lib/config');
var _              = require('underscore');
var argv           = cliParser.parse();
var module         = path.join('../lib/commands', argv.action);

require('async').waterfall([
  require('npm').load,
  function (npm, cb) { config.load(cb) },
  function (cb) { config.handleArgs(argv, cb); }
], function (err, args) {
  if (err) return console.warn(err.message);
  console.log(args);
  console.log(config.settings);
  require(module).run(args);
});
