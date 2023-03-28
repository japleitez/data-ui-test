Feature: WIH-370 As a user, I can view the sources

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    
  Scenario: As a user I GET the resources and gets 200 response with a json list of 25 sources and 'next' parameter

    Given url serviceUrl + '/api/sources'
    When method get
    Then status 200
    And match $.length() == 25
    And match header Link contains 'next'

  Scenario: As a user I GET the resources by requesting the next page and gets 200 response with a json list of 5 sources and 'previous' parameter

    Given url serviceUrl + '/api/sources?page=1'
    When method get
    Then status 200
    And assert response.length > 0
    And match header Link contains 'prev'

  Scenario: As a user I GET the resources by changing page's size to 50 and gets 200 response with a json list of 30 sources

    Given url serviceUrl + '/api/sources?page=0&size=50'
    When method get
    Then status 200
    And assert response.length < 51

  Scenario: As a user I GET the resources by requesting page 1000000 and gets 400 response

    Given url serviceUrl + '/api/sources?page=1000000'
    When method get
    Then status 400
