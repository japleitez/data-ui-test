Feature: WIH-1425 As a user I can access the parse-filters endpoints

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def testParseFilter = 'eu.europa.ec.eurostat.wihp.parsefilters.examples.TestParseFilter'
    * def filterTestParseFilter = read('classpath:/api-tests/requests/filterTestParseFilter.json')
    * def filterTestParseFilterEmpty = read('classpath:/api-tests/requests/filterTestParseFilterEmpty.json')

  Scenario: As a user I can get TestParseFilter schema

    Given url playgroundServiceUrl + '/api/parse-filters/' + testParseFilter
    When method get
    Then status 200
    And match $.id == 'eu.europa.ec.eurostat.wihp.parsefilters.examples.TestParseFilter'
    And match $.name.default == 'Test Filter'
    And match $.name.translationKey == 'eu.europa.ec.eurostat.wihp.parsefilters.TestParseFilter'

  Scenario: As a user I can POST a TestParseFilter configuration and status 201

    Given url playgroundServiceUrl + '/api/parse-filters/' + testParseFilter
    And request filterTestParseFilter
    When method post
    Then status 201
    And match $['page.title'] != null

  Scenario: As a user I can POST an empty TestParseFilter configuration and status 400

    Given url playgroundServiceUrl + '/api/parse-filters/' + testParseFilter
    And request filterTestParseFilterEmpty
    When method post
    Then status 400
    And match $.title contains 'Input parameters are not valid'

