Feature: WIH-295 As a user, I can delete a source

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def name = 'source_' + now()

  Scenario: As a user I can DELETE an existing source

    Given url serviceUrl + '/api/sources'
    And request { name: '#(name)', url: 'https://ec.europa.eu/eurostat' }
    And method post
    And status 201
    And def sourceId = $.id
    And url serviceUrl + '/api/sources/' + sourceId
    And header Authorization = 'Bearer ' + accessToken
    When method delete
    Then status 204

  Scenario: As a user I can DELETE a non existing source and get 500 error

    Given url serviceUrl + '/api/sources/-1'
    When method delete
    Then status 500

  Scenario: As a user I can DELETE a source that is used by a crawler and get 400 error

    Given url serviceUrl + '/api/sources/1'
    When method delete
    Then status 400
