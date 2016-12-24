seleniumWebdriver = require 'selenium-webdriver'
{defineSupportCode} = require 'cucumber'


defineSupportCode ({Given, When, Then}) ->

  Given 'I am on the Cucumber.js GitHub repository', ->
    this.driver.get 'https://github.com/cucumber/cucumber-js/tree/master'

  When 'I click on {stringInDoubleQuotes}', (text) ->
    this.driver.findElement({linkText: text}).then (element) ->
      element.click()

  Then 'I should see {stringInDoubleQuotes}', (text) ->
    xpath = "//*[contains(text(),'#{text}')]"
    condition = seleniumWebdriver.until.elementLocated xpath: xpath
    this.driver.wait condition, 5000

