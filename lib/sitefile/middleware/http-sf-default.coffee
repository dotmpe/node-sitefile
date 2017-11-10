module.exports = ( ctx ) ->

  name: 'http-sf-default'
  label: 'Sitefile default HTTP middleware'
  type: 'middleware'

  description: ""
  usage: ""

  passthrough: ( req, res, next ) ->

    if ctx.config['advertise']
      hd = if ctx.config['advertise-server'] then 'Server' else 'X-Powered-By'
      res.setHeader hd, "Sitefile/#{ctx.version}; Express/#{ctx.express_version}"

    if ctx.site.host
      if ctx['strict-domain'] and req.hostname != ctx.site.host
        console.warn "Domain mismatch, redirecting #{req.hostname}.."
        res.redirect "#{req.protocol}://#{ctx.domain}"
        res.end()

      else
        next()

    else
      if ctx.verbose
        console.warn "Undefined ctx.site.host, skipped strict-domain check"

      next()
