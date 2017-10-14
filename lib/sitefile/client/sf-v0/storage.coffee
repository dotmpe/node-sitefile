define 'sf-v0/storage', [

  'cs!./component'
  'lodash'
  'pouchdb'
  'relational-pouch'
  #'pouchdb-find'

], ( Component, _, PouchDB, relationalPouch, pouchdb_find ) ->


  PouchDB.plugin relationalPouch
  # FIXME: PouchDB.plugin pouchdb_find


  class ClientMetadata extends Component

    constructor: ( done, @app ) ->
      super()
      self = @

      @db = new PouchDB( 'http://sandbox-3:5984/the-registry',
          auth:
            username: 'admin'
            password: 'admin'
        )
      #@db.changes().on 'change', ->
      #  console.log 'sf-v0/storage: Ch-Ch-Changes', arguments

      @app.meta = this
      @app.events.ready.emit name: 'pouch', instance: this
      done()

    syncs: []
    sync: ( couchdb_url, options={} ) ->
      syncs.push @db.replicate.to couchdb_url,
          live: true
          retry: true
      syncs[-1].on 'complete', ->
