
{
  Terminal, NonTerminal, Comment, Skip,
  Sequence, Choice, Optional, OneOrMore, ZeroOrMore

} = require 'railroad-diagrams'


eval_rr = ( src, ctx ) ->

module.exports = ( ctx ) ->

  
  name: "rr-dia"
  usage: """
      rr-dia:[**/*].rr-dia
    """

  defaults:
    global: {}
    local: {}

  lib:
    eval_rr: eval_rr

  generate:
    default: ( rctx ) ->
      ( req, res ) ->
        #eval_rr ''
        res.type 'text'
        res.end()

