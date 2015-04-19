libconf = require '../../lib/conf'


describe "Module conf", ->


  it "Should get the name of the nearest Sitefile", ->

    rc = libconf.get 'Sitefile', paths: [ '.' ]

    expect( rc ).toBe "Sitefile.yaml"


  it "Should get the name of the nearest sitefilerc", ->

    rc = libconf.get 'sitefilerc', suffixes: [ '' ]

    expect( rc ).toBe ".sitefilerc"


  it "Should load the data of the nearest sitefilerc", ->

    rc = libconf.get 'sitefilerc', suffixes: [ '' ]
    data = libconf.load_file rc

    expect( data ).toEqual {}


