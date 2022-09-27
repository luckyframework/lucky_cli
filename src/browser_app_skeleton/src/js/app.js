/* eslint no-console:0 */

// Rails Unobtrusive JavaScript (UJS) is *required* for links in Lucky that use DELETE, POST and PUT.
// Though it says "Rails" it actually works with any framework.
require("@rails/ujs").start();

// Turbo is optional. Learn more: https://github.com/hotwired/turbo
require("@hotwired/turbo");

// If using Turbo, you can attach events to page load like this:
//
// document.addEventListener("turbo:load", function() {
//   ...
// })
