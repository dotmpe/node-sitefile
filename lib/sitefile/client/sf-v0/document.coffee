define 'sf-v0/document', [

  'cs!sf-v0/module',
  'cs!sf-v0/component',
  'cs!sf-v0/mixins'

], ( Module, Component, mixins ) ->


  class DocumentPage extends Module

    constructor: ( @container, @options ) ->
      super()
      @init_header()
      @init_footer()

    #@addMixins mixins

    @include mixins.DocutilsPage
    @include mixins.DocumentLastModified
    @include mixins.DocumentBreadcrumb
    @include mixins.HNavDocument


