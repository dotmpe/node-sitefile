###
Boilerplate context for all web Apps in Node-Sitefile.
###
define 'sf-v0/base', [
  
  'jquery'
  'lodash'
  'underscore'

], ( $, Lodash, Underscore ) ->
  'use strict'
  {
    #Common: Common
    lib:
      $: $
      _: Lodash
      __: Underscore
    _: []
    $: {}
    router:
      routes: {}
      proto: {}
    view: {}
    init: {}
    collection: null
    model:
      proto: {}
  }
#
