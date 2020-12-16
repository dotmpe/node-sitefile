define 'sf-v0/toggle-style', [

  'cs!./component',

], ( Component ) ->


  class ToggleStyle extends Component
    # TODO: turn on/off stylesheet links, for debugging.
    # Better yet, paremeterize a SASS endpoint for dynamic CSS w/o build-system
