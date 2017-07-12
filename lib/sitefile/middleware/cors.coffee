
module.exports = ( ctx ) ->

  name: 'cors'
  label: 'Sitefile CORS middleware'
  type: 'middleware'

  description: ""
  usage: ""

  passthrough: ( req, res, next ) ->
    allow_domains = ctx.site.upstream
    if 'string' is typeof allow_domains
      allow_domains = [ allow_domains ]
    referrer = req.get 'referer'
    for url in allow_domains
      if referrer?.startsWith url
        # NOTE: set if referer header matches upstream; not very transparent,
        # but do not know what else to do; this or multiple headers.
        res.set 'Access-Control-Allow-Origin', url
        #'*'
    next()



