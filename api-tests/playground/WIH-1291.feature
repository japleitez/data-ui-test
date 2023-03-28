Feature: WIH-1288 As a user I can use HostURLFilter

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def hostUrlFilter = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'
    * def filterConfiguration = read('classpath:/api-tests/requests/filterHostUrlFilter.json')
    * def filterConfigurationWrong = read('classpath:/api-tests/requests/filterHostUrlFilterWrong.json')
    * def filterConfigurationEmpty = read('classpath:/api-tests/requests/filterHostUrlFilterEmpty.json')

  Scenario: As a user I can get HostURLFilter schema

    Given url playgroundServiceUrl + '/api/url-filters/' + hostUrlFilter
    When method get
    Then status 200
    And match $.id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'
    And match $.name.default == 'Host URL Filter'
    And match $.name.translationKey == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'

  Scenario: As a user I can POST a filter configuration and status 201

    Given url playgroundServiceUrl + '/api/url-filters/' + hostUrlFilter
    And request filterConfiguration
    When method post
    Then status 201
    And match $.urls[0].url contains 'https://www.sourcedomain.com/index.html'
    And match $.urls[1].url contains 'https://www.anotherDomain.com/index.html'
    And match $.urls[2].url contains 'https://sub.sourcedomain.com/index.html'

  Scenario: As a user I can POST a wrong filter configuration and status 400

    Given url playgroundServiceUrl + '/api/url-filters/' + hostUrlFilter
    And request filterConfigurationWrong
    When method post
    Then status 400
    And match $.title == 'Input parameters are not valid'

  Scenario: As a user I can POST an empty filter configuration and status 400

    Given url playgroundServiceUrl + '/api/url-filters/' + hostUrlFilter
    And request filterConfigurationEmpty
    When method post
    Then status 400
    And match $.title == 'Input parameters are not valid'
