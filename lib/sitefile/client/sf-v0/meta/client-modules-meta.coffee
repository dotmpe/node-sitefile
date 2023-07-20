###
	Interface to get sitefile-client-modules meta content.
###
define 'sf-v0/meta/client-modules-meta', [

  'jquery'

], ( $ ) ->


  class ClientModulesMeta

    get: ->
      meta = $('meta[name=sitefile-client-modules]')
      if meta.length then meta.attr('content').split( ',' )
      else [ 'cs!sf-v0/page' ]
