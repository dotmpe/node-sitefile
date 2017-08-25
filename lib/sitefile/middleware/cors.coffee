
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
      # NOTE: set if referer header matches upstream; not very transparent,
      # but do not know what else to do; this or multiple headers.
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


