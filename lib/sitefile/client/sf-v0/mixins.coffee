define 'sf-v0/mixins', [

  'cs!sf-v0/mixin.breadcrumb',
  'cs!sf-v0/mixin.du-page',
  'cs!sf-v0/mixin.last-modified',
  'cs!sf-v0/mixin.hyper-nav'

], (
  { DocumentBreadcrumb },
  { DocutilsPage },
  { DocumentLastModified },
  { HNavDocument }
) ->

  DocutilsPage: DocutilsPage
  DocumentLastModified: DocumentLastModified
  DocumentBreadcrumb: DocumentBreadcrumb
  HNavDocument: HNavDocument

