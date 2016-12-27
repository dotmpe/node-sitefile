
var $ = jQuery = require('../../../node_modules/jquery/dist/jquery.min.js');
var _ = lodash = require('../../../node_modules/lodash/lodash.min.js');
var bootstrap = require('../../../node_modules/bootstrap/dist/js/bootstrap.js');

//var bootstrap_glyphicons = require('../../../node_modules/bootstrap/dist/fonts/glyphicons-halflings-regular.woff');
//var bootstrap_glyphicons = require('../../../node_modules/bootstrap/dist/fonts/glyphicons-halflings-regular.ttf');

$(document).ready( function() {

  // Adapt Du/rST-XHTML to Twitter-Bootstrap CSS
  $('.document, .header, .footer').addClass('container');

  console.log("Ready");
});

