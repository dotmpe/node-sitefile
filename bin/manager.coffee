#!/usr/bin/env coffee
pm2 = require 'pm2'
path = require('path')
cwd = path.dirname(__dirname)

pm2.connect ( err ) ->

  if err
    console.error(err)
    process.exit(2)

  console.log cwd
  
  pm2.start(
    name: 'sf-sitefile'
    cwd: cwd
    script: './bin/sitefile.coffee'         # Script to be run
    interpreter: 'coffee'
    exec_mode: 'fork'

    #port: 4325
    #instances : 1                # Optional: Scale your app by 4
    #max_memory_restart : '100M'  # Optional: Restart if it reaches 100Mo
  , ( err, apps) ->

    console.log apps.length, 'Apps'
    console.log apps[0].pm_id, apps[0].name

    pm2.disconnect()   # Disconnect from PM2
    if err
      throw Error err
  )

