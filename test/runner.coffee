path = require 'path'
global.__nodepath = path.dirname __dirname

_ = require 'lodash'

miniJasmineLib = require('minijasminenode2')

# At this point, jasmine is available in the global node context.
# Add your tests by filename.
miniJasmineLib.addSpecs 'test/jasmine/sitefile_index.coffee'
miniJasmineLib.addSpecs 'test/jasmine/sitefile_express.coffee'
miniJasmineLib.addSpecs 'test/jasmine/sitefile_router_du.coffee'

# If you'd like to add a custom Jasmine reporter, you can do so. Tests will
# be automatically reported to the terminal.
#miniJasmineLib.addReporter myCustomReporter

options = showColors: true, includeStackTrace: true

# Run those tests!
miniJasmineLib.executeSpecs options
