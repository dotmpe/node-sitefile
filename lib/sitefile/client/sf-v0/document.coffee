### document is a between class to test using optional & configurable mixins
for run-time components. Ie. to customize the UI components like no, one or
multiple search, or menus, etc.

DocumentPage is an attempt of this, using a set of mixins and a mix of a
bootstrap/docutils structured page DOM. The only problem wrt. dynamic run-time
UI components is that Component needs all its dependencies loaded, regardless
of wether they are configured. 

###
define 'sf-v0/document', [

  'cs!./component'
  'cs!./mixins'
  #'cs!./client/includes/document'
  'lodash'
  'jquery'

], ( Component, mixins, _, $ ) ->

  class DocumentPage extends Component

    constructor: ( @container, @options ) ->
      super()

  #includes.mixin DocumentPage
  mixins.all DocumentPage

  DocumentPage

