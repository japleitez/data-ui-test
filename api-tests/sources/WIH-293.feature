Feature: WIH-293 As a user, I can create a new source

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def name = 'source_' + now()


  Scenario: As a user I can POST a valid form

    Given url serviceUrl + '/api/sources'
    And request { name: '#(name)', url: 'https://ec.europa.eu/eurostat' }
    When method post
    Then status 201

  Scenario: As a user I can POST an invalid form and gets an 422 error

    Given url serviceUrl + '/api/sources'
    And request { name: '$eurostat', url: 'ec.europa.eu' }
    When method post
    Then status 422
