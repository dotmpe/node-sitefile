### lib/sitefile/client/sf-v0 - Simple jQ based hook for RJS to boot from
sf client-modules. Which by default includes SitefilePage.

Used on pages where sf-v0 is defined as rjs main app. But should allow to
modularize development code.
###
define 'sf-v0', [

  'cs!sf-v0/component/client-modules'

  'jquery'
  'bootstrap'
  'css!/vendor/bootstrap'
  'css!/vendor/bootstrap-theme'

], ( ClientModules ) ->

  new ClientModules().start()

