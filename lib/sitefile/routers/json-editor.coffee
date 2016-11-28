###
###


# Given sitefile-context, export metadata for json-editor: handlers
module.exports = ( ctx={} ) ->

  name: 'json-editor'
  label: 'JSON-Editor'
  usage: """
    json-editor:**/*.json-editor
  """

  # generators for Sitefile route handlers
  generate:
    default: ( spec, ctx={} ) ->
      fn = spec + '.json'
      ( req, res ) ->
        res.write 'TODO:'+fn
        res.end()


