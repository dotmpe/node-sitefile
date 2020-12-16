
class Bundle

  default: [
    'coffeescript'
    'pug'
    'bluebird'
    'chalk'
    'lodash'
    'semver'
  ]
  optional: [
    'jquery'
    (
      name: 'bootstrap'
      style: [
        npm: bootstrap/dist/css/bootstrap.min.css
      ,
        npm: bootstrap/dist/css/bootstrap-theme.min.css
      ]
      script: [
        npm: bootstrap/dist/js/bootstrap.min.js
      ]
      fonts: []
    )
    'bookshelf/sqlite3'
    'yaml'
    'markdown'
    'stylus'
  ]
  dev: [
    'grunt'
    'pmx/pm2' ]

  @load: ( ctx, bundlespec ) ->
    if bundlespec not of ctx.bundles
      #if bundlespec of Bundle.default
      #if bundlespec of Bundle.optional
      #if bundlespec of Bundle.dev
      for dirspec in ctx.paths.bundles
        bundle = @resolve dirspec, bundlespec
        if bundle
          ctx.bundles[ bundle.name ] = bundle
          break
    ctx.bundles[ bundlespec ]


module.exports =

  Bundle: Bundle


