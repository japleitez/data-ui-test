Feature: WIH-294 As a user, I can modify a source

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def name = 'source_' + now()


  Scenario: As a user I can PUT a valid form

    Given url serviceUrl + '/api/sources/20'
    And request { id:'20', name: 'source20_updated', url: 'https://ec.europa.eu/database' }
    When method put
    Then status 200

  Scenario: As a user I PUT an invalid form and gets an 422 error (name must be valid)

    Given url serviceUrl + '/api/sources/1'
    And request { name: '$eurostat', url: 'https://ec.europa.eu/' }
    When method put
    Then status 422

  Scenario: As a user I PUT an invalid form and gets an 422 error (name cannot be empty)

    Given url serviceUrl + '/api/sources/1'
    And request { name: '', url: 'https://ec.europa.eu/' }
    When method put
    Then status 422

  Scenario: As a user I PUT an invalid form and gets an 422 error (url must be valid)

    Given url serviceUrl + '/api/sources/1'
    And request { name: 'eurostat', url: '*$invalid' }
    When method put
    Then status 422

  Scenario: As a user I PUT an invalid form and gets an 422 error (url cannot be empty)

    Given url serviceUrl + '/api/sources/1'
    And request { name: 'eurostat', url: '' }
    When method put
    Then status 422
