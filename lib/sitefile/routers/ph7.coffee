ph7 = require "ph7-darwin"


# Create a new virtual maschine for PHP
pVM = ph7.create()

# Configure the variables you want to...
pVM.$_ENV['my_awesome_app_name']="Meep Meep!"
# This also works for the other super globals too:
pVM.$_GET['ajax']=true
pVM.$_POST['userName']="fubar"
pVM.$_SERVER['NODE_VERSION']='0.1'
pVM.$_SESSION['randomNumber']=42
pVM.$_HEADER['Upgrade:']="WebSocket"
pVM.$_COOKIE['is']="very tasty!"

# To create a new, normal, variable as you would know it in PHP, use $GLOBALS.
#pVM.$GLOBALS['appName']="meepify"
# To create a SUPER global (like $_GET), use the special $SGLOBALS array:
#pVM.$SGLOBALS['_MODULES']=["fs","os"]
# And if you want, you can even use $argv.
#pVM.$argv[0] = "--help"


# Given sitefile-context, export metadata for ph7: handler
module.exports = ( ctx={} ) ->

  name: 'ph7'
  label: 'Embedded PHP engine'
  usage: """
    ph7:**/*.php
  """

  generate: ( spec, ctx={} ) ->

    fn = spec + '.php'

    ( req, res ) ->
      pVM.compileFile fn
      pVM.prepair()

      # Run it!
      exitCode = pVM()

      if exitCode != 0
        res.status(500)
      res.write "#{exitCode}"
      res.end()


