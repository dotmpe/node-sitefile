
trueish = "1 true yes on".split ' '


rewrite_abs_mains = ( base='/' ) ->
  $('link').each ->
    main = $(this).attr 'main'
    if main.substr( 0, 1 ) is '/' and not ( main.substr( 0, 2 ) is '//' )
      $(this).attr 'main', base+main.substr 1

rewrite_abs_hrefs = ( base='/' ) ->
  $('a, object').each ->
    href = $(this).attr 'href'
    if href.substr( 0, 1 ) is '/' and not ( href.substr( 0, 2 ) is '//' )
      $(this).attr 'href', base+href.substr 1

rewrite_abs_srcs = ( base='/' ) ->
  $('img, object').each ->
    src = $(this).attr 'src'
    if src.substr( 0, 1 ) is '/' and not ( src.substr( 0, 2 ) is '//' )
      $(this).attr 'src', base+src.substr 1


rewrite_abs_refs = ( base='/' ) ->
  # NOTE: need to ignore stylesheets and scripts here
  rewrite_abs_hrefs base
  rewrite_abs_srcs base


$(document).ready ->

  baseref = $('base').attr 'href'

  baseprefix = $('meta[name="sf:base:prefix"]')
  if baseprefix.length
    if trueish.includes baseprefix.attr('content').toLowerCase()
      rewrite_abs_refs baseref
    

  $('.document').addClass 'container'

