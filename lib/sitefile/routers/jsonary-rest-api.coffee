#_ = require 'lodajsonary-rest-api'
fs = require 'fs'
#path = require 'path'
#sys = require 'sys'
exec = require('child_process').exec


# Given sitefile-context, export metadata for jsonary-rest-api: handlers
module.exports = ( ctx={} ) ->

  name: 'jsonary-rest-api'
  label: 'JSON storage with REST api'
  usage: """
    '$<api-path>/:action': **/*.json
  """

  # generators for Sitefile route handlers
  generate:
    default :( spec, ctx={} ) ->

      fn = spec + ".json"
      console.log "JSON storage #{fn}"

      ( req, res ) ->

#        if (req.query.schema)
#          res.write fs.readFileSync fn

        if req.params.action
          res.write req.params.action
        else
          res.write fs.readFileSync(fn)
        res.end()

###
header("Content-Type: application/json; 
  profile=http://jsonary-rest-api.org/hyper-schema");

{
	"properties": {
          "Title": {
            "title": "Title"
          }
        },
        "links": [
          {
            "href": "update.php",
            "rel": "update",
            "method": "POST",
            "schema": {
              "$ref": "update.php?schema"
            }
          },
          {
            "href": "view.php",
            "rel": "data"
          }
        ]
      }
    header("Content-Type: application/json; profile=?schema");
    ?>
      {
        "Title": "The main page",
        "Explanation": "A basic test of the Render.Jsonary library."
      }
###

