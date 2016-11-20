var basePathIds = {
	"app": "/app",
	"base": "requirejs-base",
	"build": "/build/script",
};

var cdnIds = {
	"jquery": "//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min",
	"jqueryui": "//cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min",
	"underscore": "//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.6.0/underscore-min",
	"underscore.string": "//cdnjs.cloudflare.com/ajax/libs/underscore.string/2.3.3/underscore.string.min",

  "coffee-script": "//cdnjs.cloudflare.com/ajax/libs/coffee-script/1.11.1/coffee-script.min",
  cs: "//cdnjs.cloudflare.com/ajax/libs/require-cs/0.5.0/cs.min",
  backbone: "//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.3.3/backbone-min"
};

var bowerUrlIds = {
  jquery: '/components/jquery/dist/jquery',
  underscore: '/components/underscore/underscore',
  bootstrap: '/components/bootstrap/dist/js/bootstrap',
  'coffee-script': '/components/coffeescript/extras/coffee-script',
  cs: "/components/require-cs/cs",
  backbone: "/components/backbone/backbone-min"
};

// Production refs
var prodIds = {}

// Testing refs
var testIds = {}
Object.assign(testIds, basePathIds);
Object.assign(testIds, cdnIds);

// Development refs
var devIds = {}
Object.assign(devIds, basePathIds);
Object.assign(devIds, cdnIds);
Object.assign(devIds, bowerUrlIds);



requirejs.config({
	baseUrl: "lib",
	paths: devIds,
	shim: {
    bootstrap: [ 'jquery' ],
		jqueryui: [ "jquery" ],
	},
  deps: [
    "cs!app/view",
    "cs!app/view/list",
    "cs!app/model",
    "cs!app/workspace",
    "cs!app/collection",
    "cs!app/topic",
    "cs!app/topics",
    "cs!app/topic/list",
    "cs!app/main"
  ]
});

