/* global exports */
"use strict";

// module Data.String.Chalk

exports.localChalk = (function() {
  var chalk = require('chalk');
  return new chalk.constructor({enabled: true});
})();

exports.ansiStyles = require('ansi-styles');

exports.stripAnsi = require('strip-ansi');

exports.hasAnsi = require('has-ansi');

exports.ansiRegex = require('ansi-regex')();

exports.supportsColor = function() {
  return require('supports-color')
}

exports.unsafeGet = function(prop) {
  return function(obj) {
    return obj[prop];
  }
}
