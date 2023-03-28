Feature: WIH-1210 As a user I can access playground service

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken

  Scenario: As a user I can GET a paginated list of filters' configuration and status 200

    Given url playgroundServiceUrl + '/api/url-filters?page=0&size=1'
    When method get
    Then status 200
    And match $[0].id contains 'eu.europa.ec.eurostat.wihp.urlfilters'
    And match response == '#[1]'
