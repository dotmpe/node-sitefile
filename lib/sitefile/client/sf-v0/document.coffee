define 'sf-v0/document', [

  'cs!./component'
  'cs!./mixins'

], ( Component, mixins ) ->


  class DocumentPage extends Component

    constructor: ( @container, @options ) ->
      super()

  mixins.mixin DocumentPage

  DocumentPage

