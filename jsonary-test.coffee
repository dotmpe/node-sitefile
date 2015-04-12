#!/usr/bin/env coffee
Jsonary = require 'jsonary'

Jsonary.add 'draft-04.js'

#console.log Jsonary
#data = Jsonary.create(
#  'id': 125
#  'authorId': 25
#  'title': 'Example data')
#schema = Jsonary.createSchema(
#  'title': 'Example hyper-schema'
#  'links': [
#    {
#      'rel': 'self'
#      'href': 'http://example.com/items/{id}'
#    }
#    {
#      'rel': 'author'
#      'href': 'http://example.com/users/{authorId}'
#    }
#  ])
#data.addSchema schema
