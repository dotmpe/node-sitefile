module.exports = ( ctx ) ->

  name: 'cors'
  label: 'Sitefile CORS middleware'
  type: 'middleware'

  description: ""
  usage: ""

  passthrough: ( req, res, next ) ->
    allow_domains = ctx.site.upstream
    if 'string' is typeof allow_domains
      if '*' == allow_domains
        res.set 'Access-Control-Allow-Origin', '*'
      else
        allow_domains = [ allow_domains ]
    else
      # FIXME: normal mode allow https too if http given, https only if explicit
      # or if left out enforced if request has it

      # FIXME: compile regexes on load

      # NOTE: its is not very transparent, but is the way CORS is specified:
      # "The Access-Control-Allow-Origin header should contain the value that
      # was sent in the request's Origin header. "
      # [https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS]
      # Ie. no advertising. It looks like some browser may support multiple ACAO
      # headers, but not following up on that.
      remote = req.get 'Origin'
      unless remote
        remote = req.get 'referer'
      unless remote
        if ctx.verbose
          console.warn "Undefined remote, skipped access-control"
      else
        for url in allow_domains
          if remote.startsWith url
            res.set 'Access-Control-Allow-Origin', url
    next()
