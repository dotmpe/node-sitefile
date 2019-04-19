Router = require '../Router'
fs = require 'fs'
path = require 'path'


class StaticFile
  constructor: (@spec) ->
    # FIXME: sfdir #@path = Router.expand_path @spec
    @path = path.join process.cwd(), @spec
    @load()
  load: ->
    fd = fs.openSync @path, 'r'
    @stat = fs.fstatSync fd
    @len = @stat.size
    fs.closeSync fd
    @data = fs.readFileSync @path
  reload: ->
    nstat = fs.statSync @path
    if nstat.mtimeMs > @stat.mtimeMs
      @load()
  toString: ->
    @data.toString 'ascii'

# XXX: maybe encapsulate some built-ins differently. Ie. make them special,
# builtin modules building on Express static or other middleware forms.
# Load them always or slightly differently, but coded looking more like
# regular router modules. See todo router 

module.exports = ( ctx ) ->

  name: 'file'
  label: ''
  usage: """
  """

  defaults:
    handler: 'html'

  generate:

    html: ( rctx ) ->
      #sfmod = ctx._routers.get('file')
      #sfmod.load(rctx.route.spec)
      ( req, res ) ->
        res.type 'html'
        res.end()

  StaticFile: StaticFile
