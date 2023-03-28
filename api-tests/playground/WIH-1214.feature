Feature: WIH-1214 As a user, test filters on the playground

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def testFilter = 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter'
    * def dummyWrong = '@eu#europa$ec.eurostat.wihp.urlfilters.dummy.dummy.DummyUrlFilter'
    * def nonExistingFilter = 'eu.europa.ec.eurostat.wihp.urlfilters.dummy.dummy.Hugues'
    * def filterConfiguration = read('classpath:/api-tests/requests/filterConfiguration.json')
    * def filterConfigurationWrong = read('classpath:/api-tests/requests/filterConfigurationWrong.json')
    * def filterConfigurationEmpty = read('classpath:/api-tests/requests/filterConfigurationEmpty.json')


  Scenario: As a user I can GET a filter configuration and status 200

    Given url playgroundServiceUrl + '/api/url-filters/' + testFilter
    When method get
    Then status 200
    And match $.id == 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter'
    And match $.name.default == 'Test Filter'
    And match $.name.translationKey == 'eu.europa.ec.eurostat.wihp.urlfilters.TestFilter'

  Scenario: As a user I can POST a filter configuration and status 201

    Given url playgroundServiceUrl + '/api/url-filters/' + testFilter
    And request filterConfiguration
    When method post
    Then status 201
    And match $.urls[0].url contains 'https://www.test.com'


  Scenario: As a user I can GET a wrong page of filters' configuration and response empty

    Given url playgroundServiceUrl + '/api/url-filters?page=100&size=100'
    When method get
    Then status 200
    And match response == []



  Scenario: As a user I can GET a wrong id and status 400

    Given url playgroundServiceUrl + '/api/url-filters/' + dummyWrong
    When method get
    Then status 400

  Scenario: As a user I can GET a non existing id and status 404

    Given url playgroundServiceUrl + '/api/url-filters/' + nonExistingFilter
    When method get
    Then status 404

  Scenario: As a user I can POST a wrong filter configuration and status 400

    Given url playgroundServiceUrl + '/api/url-filters/' + testFilter
    And request filterConfigurationWrong
    When method post
    Then status 400

  Scenario: As a user I can POST an empty filter configuration and status 400

    Given url playgroundServiceUrl + '/api/url-filters/' + testFilter
    And request filterConfigurationEmpty
    When method post
    Then status 400

  Scenario: As a user I can POST a non existing id and status 404

    Given url playgroundServiceUrl + '/api/url-filters/' + nonExistingFilter
    And request filterConfiguration
    When method post
    Then status 404

  Scenario: As a user I can post a wrong id and status 400

    Given url playgroundServiceUrl + '/api/url-filters/' + dummyWrong
    And request filterConfiguration
    When method post
    Then status 400