define 'sf-v0/mixins', [

  'cs!./mixin.breadcrumb',
  'cs!./mixin.du-page',
  'cs!./mixin.last-modified',
  'cs!./mixin.hyper-nav'

], (
  { DocumentBreadcrumb },
  { DocutilsPage },
  { DocumentLastModified },
  { HNavDocument }
) ->

  mixin: ( klass ) ->
    klass.include DocutilsPage
    klass.include DocumentLastModified
    klass.include DocumentBreadcrumb
    klass.include HNavDocument

