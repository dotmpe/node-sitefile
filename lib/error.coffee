class NoFilesException extends Error
  constructor: ( msg ) ->
    super()
    @message = msg
  toString: ->
    return @message

module.exports =
  types:
    NoFilesException: NoFilesException

