Feature: WIH-606 As a user, I can view the crawlers

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken

  Scenario: As a user I GET a crawler (sources not loaded)
    Given url serviceUrl + '/api/crawlers/1'
    When method get
    Then status 200
    And assert response.sources.length == 0

  Scenario: As a user I GET the crawlers and gets 200 response with an empty json list of sources and 'next' parameter

    Given url serviceUrl + '/api/crawlers'
    When method get
    Then status 200
    And match $ == '#[25]'
    And match header Link contains 'next'
    And assert response[0].sources.length == 0

  Scenario: As a user I GET the crawlers by requesting the next page and gets 200 response with a json list of 5 sources and 'previous' parameter

    Given url serviceUrl + '/api/crawlers?page=1'
    When method get
    Then status 200
    And assert response.length > 0
    And match header Link contains 'prev'

  Scenario: As a user I GET the crawlers by changing page's size to 50 and gets 200 response with a json list of 30 crawlers

    Given url serviceUrl + '/api/crawlers?page=0&size=50'
    When method get
    Then status 200
    And assert response.length < 51


  Scenario: As a user I GET the crawlers by requesting page 10000 and gets 400 response

    Given url serviceUrl + '/api/crawlers?page=10000'
    When method get
    Then status 400
