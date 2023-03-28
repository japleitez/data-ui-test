Feature: WIH-1472 As a user I can access the navigation-filters endpoints

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def testNavigationFilter = 'eu.europa.ec.eurostat.wihp.navigationfilters.stormcrawler.BasicNavigationFilter'
    * def filterTestNavigationFilter = read('classpath:/api-tests/requests/filterTestNavigationFilter.json')
    * def filterTestNavigationFilterEmpty = read('classpath:/api-tests/requests/filterTestNavigationFilterEmpty.json')
    * configure connectTimeout = 20000
    * configure readTimeout = 20000

  Scenario: As a user I can get BasicNavigationFilter schema

    Given url playgroundServiceUrl + '/api/navigation-filters/' + testNavigationFilter
    When method get
    Then status 200
    And match $.id == 'eu.europa.ec.eurostat.wihp.navigationfilters.stormcrawler.BasicNavigationFilter'
    And match $.name.default == 'Basic Selenium Filter'
    And match $.name.translationKey == 'eu.europa.ec.eurostat.wihp.navigationfilters.stormcrawler.BasicNavigationFilter'

  Scenario: As a user I can POST a TestNavigationFilter configuration and status 201

    Given url playgroundServiceUrl + '/api/navigation-filters/' + testNavigationFilter
    And request filterTestNavigationFilter
    When method post
    Then status 201

  Scenario: As a user I can POST an empty TestNavigationFilter configuration and status 400

    Given url playgroundServiceUrl + '/api/navigation-filters/' + testNavigationFilter
    And request filterTestNavigationFilterEmpty
    When method post
    Then status 400

