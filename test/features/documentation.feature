Feature: Documentation

  Scenario: Default resource 
    Given the node-sitefile "testing" site is online
    Then resource "/" should lead to a HTML page

  Scenario: ReadMe
    Given I am at the root resource
    Then I should see "Node Sitefile"

  Scenario: ReadMe reader
    Given the node-sitefile "testing" site is online
    Given I am at the resource "reader/ReadMe"


