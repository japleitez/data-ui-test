Feature: WIH-1297 As a user I can set metadata for filter testing

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def testFilter = 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter'
    * def filterConfigurationMetadata = read('classpath:/api-tests/requests/filterConfigurationMetadata.json')


  Scenario: As a user I can POST a filter configuration with Metadata and status 201

    Given url playgroundServiceUrl + '/api/url-filters/' + testFilter
    And request filterConfigurationMetadata
    When method post
    Then status 201
    And match $.urls[0].url contains 'https://www.test.com'
    And match $.urls[1].url contains 'https://www.google.com'
    And match $.urls[2].url contains 'invalid'
