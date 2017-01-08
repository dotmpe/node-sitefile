define 'webcomp', [
  'element',
  'template'

], ( element, template ) ->

  # FIXME: not working correctly? introduces errors on load

  console.log 'element', element

  template.ready ->
    console.log 'template ready', arguments

