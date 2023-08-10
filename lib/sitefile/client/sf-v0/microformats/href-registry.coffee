define 'sf-v0/microformats/href-registry', [

  'cs!../component/microformat'
  'lodash'
  'jquery'

# TODO: href-registry UI
  #'text!./href-registry.pug.html'
  #'text!./href-registry-tools.pug.html'
  #'css!./href-registry.sass'

], ( Microformat, _, $, tpl, toolsTpl ) ->


  class HRefReg extends Microformat

    name: 'HRef Registy'
    description: 'Lookup metadata cards for hypertext references'
    selector: 'a[href]'

    attach: ( idx ) ->
      unless @app.registry?
        @app.registry = @

      @refs[idx] =
        doc: null
        el: @$el
        url: @_get_url @$el.attr 'href'

      # If meta is created, pouchdb is loaded
      if typeof @app.meta != "undefined"
        if typeof @app.meta.db != "undefined"
          @fetch idx

    refs: []
    domains: {}
    queue:
      domains: []
      urls: []

    fetch: ( idx ) ->
      url = @refs[idx].url ; domain = url.hostname
      unless domain of @domains
        @domains[domain] = null
        self = @ ; @app.meta.db
        .get domain, ( res, dDoc ) ->
          if dDoc
            self.set_domain idx, domain, dDoc
            self.fetch_url idx, url
          else
            self.store_domain idx, url
      else if @domains[domain]
        @store_url @domains[domain], url
      else
        @queue.domains.push domain
        # TODO: empty queue
        console.log 'queue domain', domain

    fetch_url: ( idx, url ) ->
      self = @ ; @app.meta.db
      .get url.href, ( res, urlDoc ) ->
        if urlDoc
          self.set_url idx, urlDoc
        else
          self.store_url idx, url

    proto_ports: {
      'http': 80
      'https': 443
      'ftp': 21
    }
    store_domain: ( idx, url ) ->
      proto = url.protocol.substr 0, url.protocol.length-1
      port = if url.port then parseInt url.port else @proto_ports[proto]
      domain_obj =
        _id: url.hostname
        protocols: [
          id: url.protocol.substr 0, url.protocol.length-1
          port: port
        ]
      self = @ ; @app.meta.db.put domain_obj, ( dDoc ) ->
        self.set_domain idx, url.hostname, dDoc
        self.store_url idx, url

    store_url: ( idx, url ) ->
      url_obj =
        _id: url.href
        domain: @domains[url.hostname]._id
      self = @ ; @app.meta.db.put url_obj, ( urlDoc ) ->
        self.set_url idx, urlDoc

    _get_url: ( href ) ->
      url = @app.page.resolve_pageref href, location.pathname
      if url.match /^\//
        url = window.location.protocol+'//'+window.location.host+url
      new URL url

    set_domain: ( idx, domain, dDoc ) ->
      @domains[domain] = dDoc
      console.log 'TODO: domain UI', idx, domain, dDoc

    set_url: ( idx, urlDoc ) ->
      @refs[idx].doc = urlDoc
      console.log 'TODO: url UI', idx, urlDoc

###
      @app.events.ready.addListener ( evt ) ->

      @tpl = $.parseHTML tpl
      @toolsTpl = $.parseHTML toolsTpl
      if @$el.hasClass
###
