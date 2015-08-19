/* global exports */
"use strict";

// module Data.String.Chalk

exports.localChalk = (function() {
  var chalk = require('chalk');
  return new chalk.constructor({enabled: true});
})();

exports.unsafeGet = function(prop) {
  return function(obj) {
    return obj[prop];
  }
}
