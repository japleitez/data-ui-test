Feature: WIH-288 As a user, I can start a data acquisition and VIEW Configurations

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken

  Scenario: As a user I GET the configurations and gets 200 response with a json list of 25 configurations and 'next' parameter

    Given url serviceUrl + '/api/configs'
    When method get
    Then status 200
    And match $.length() == 25
    And match header Link contains 'next'

  Scenario: As a user I GET the configurations by requesting the next page and gets 200 response with a json list of 5 configurations and 'previous' parameter

    Given url serviceUrl + '/api/configs?page=1'
    When method get
    Then status 200
    And assert response.length > 0
    And match header Link contains 'prev'

  Scenario: As a user I GET the configurations by changing page's size to 50 and gets 200 response with a json list of 30 configurations

    Given url serviceUrl + '/api/configs?page=0&size=50'
    When method get
    Then status 200
    And assert response.length < 51
