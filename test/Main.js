/* global exports */
"use strict";

// module Test.Main

exports.escape = JSON.stringify

exports.truthy = function(x) {
  if (x) {
    return true;
  } else {
    return false;
  }
}
