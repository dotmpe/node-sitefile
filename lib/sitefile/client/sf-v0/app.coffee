###
To load anything we need names of modules and other resources, and a
structure.

SfApp defines ways for resources to declare a relation with a metadata
resource, and use that metadata as a blueprint for the DHTML "client
configuration".

- variant:{.yaml,.json}

  Look for a YAML or JSON variant of the current resource.
  Like <resource>.yaml

- group:meta.json

  There is one file for a group of files.

- embedded

  There should be <meta name="sitefile-meta-json" .. probably.

All there is to know about a resource, its media, templates, style, etc.
is intrinsic for the most part in the case of documents.

But for applications in the extreme case all content is dynamic and
structured. This is good, but there are many ways to get towards a
similar functional DHTML. 

###
define 'sf-v0/app', [
  
  'cs!base'
  'cs!sf-v0/component/page'

], ( app, PageComponent ) ->
  'use strict'

  console.log 'Sitefile App loading...'

  class SitefileApplication extends PageComponent
    constructor: ( @app ) ->

      console.log "TODO Sitefile App", app, app.meta

    load_meta: ->

    resolve_variant: ->
    resolve_group: ->
#
