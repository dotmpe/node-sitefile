define 'app.workspace.Workspace', [

  'backbone'

], ( backbone ) ->

  Workspace = backbone.Router.extend
    routes:
      help: "help"
      "search/:query": "search"
    help: ->
    search: ( q, p ) ->

  Workspace

