Feature: WIH-1210 As a user I can access Playground Management

  Scenario: 1. As a user I can get management health
    Given url playgroundServiceUrl + '/management/health'
    When method get
    Then status 200
    And match $.status == 'UP'

  Scenario: 2. As a user I can get management info
    Given url playgroundServiceUrl + '/management/info'
    When method get
    Then status 200
