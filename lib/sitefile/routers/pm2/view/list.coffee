
#$ = jQuery = require '../../../node_modules/jquery/dist/jquery.min.js'
#_ = lodash = require '../../../node_modules/lodash/lodash.min.js'
#bootstrap = require '../../../node_modules/bootstrap/dist/js/bootstrap.js'

$(document).ready ->

  appid_base = $('.container.pm2-list').data('urlbase')

  $("button.start").each ( idx, el ) ->
    appid = $(el).data('appid')
    $(el).click ( evt ) ->
      $.ajax(
        method: 'post'
        data: {}
        url: appid_base + '/' + appid + '/start'
      )

  $("button.restart").each ( idx, el ) ->
    appid = $(el).data('appid')
    $(el).click ( evt ) ->
      $.ajax(
        method: 'post'
        data: {}
        url: appid_base + '/' + appid + '/restart'
      )

  $("button.stop").each ( idx, el ) ->
    appid = $(el).data('appid')
    $(el).click ( evt ) ->
      $.ajax(
        method: 'post'
        data: {}
        url: appid_base + '/' + appid + '/stop'
      )

  console.log 'Ready', appid_base

