
seleniumWebdriver = require 'selenium-webdriver'
{defineSupportCode} = require 'cucumber'
expect = require('chai').expect


defineSupportCode ({Given, When, Then}) ->

  Given 'the node-sitefile {env:stringInDoubleQuotes} site is online',
    (env) ->
      this.driver.get "http://localhost:7012/"
      this.driver.findElements({ css: 'div.document' })
        .then (elements) ->
          expect(elements.length).to.not.equal(0)

  Given 'I am at the resource {arg1:stringInDoubleQuotes}', (arg1, callback) ->
    # Write code here that turns the phrase above into concrete actions
    callback null, 'pending'

  Given 'I am at the root resource', (callback) ->
    callback null, 'pending'

  Then 'resource {arg1:stringInDoubleQuotes} should lead to a HTML page',
    (arg1, callback) ->
      # Write code here that turns the phrase above into concrete actions
      callback null, 'pending'

