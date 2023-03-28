Feature: WIH-1295 As a user I can valdiate a complex type parameter in a filter

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def fastUrlFilter = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.fasturlfilter.FastURLFilter'
    * def filterConfiguration = read('classpath:/api-tests/requests/filterFastUrlFilter.json')
    * def filterConfigurationWrongConfig = read('classpath:/api-tests/requests/filterFastUrlFilterWrongConfig.json')
    * def filterFastUrlFilterMissedConfig = read('classpath:/api-tests/requests/filterFastUrlFilterMissedConfig.json')
    * def filterFastUrlFilterEmptyConfig = read('classpath:/api-tests/requests/filterFastUrlFilterEmptyConfig.json')
    * def filterFastUrlFilterEmpty = read('classpath:/api-tests/requests/filterFastUrlFilterEmpty.json')

  Scenario: As a user I can get FastURLFilter schema

    Given url playgroundServiceUrl + '/api/url-filters/' + fastUrlFilter
    When method get
    Then status 200
    And match $.id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.fasturlfilter.FastURLFilter'
    And match $.name.default == 'Fast URL Filter'
    And match $.name.translationKey == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.FastURLFilter'

  Scenario: As a user I can POST a FastURLFilter configuration and status 201

    Given url playgroundServiceUrl + '/api/url-filters/' + fastUrlFilter
    And request filterConfiguration
    When method post
    Then status 201
    And match $.urls[0].url contains 'http://www.somedomain.com/image.jpg'
    And match $.urls[0].result == false
    And match $.urls[1].url contains 'http://stormcrawler.net/'
    And match $.urls[1].result == false
    And match $.urls[2].url contains 'http://stormcrawler.net/digitalpebble/'
    And match $.urls[2].result == true

  Scenario: As a user I can POST an empty FastURLFilter configuration and status 400

    Given url playgroundServiceUrl + '/api/url-filters/' + fastUrlFilter
    And request filterFastUrlFilterEmpty
    When method post
    Then status 400
    And match $.title == 'Input parameters are not valid'

  Scenario: As a user I can VALIDATE an FastURLFilter configuration with INVALID PARAMETERS

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request filterConfigurationWrongConfig
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.fasturlfilter.FastURLFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[9]'
    And match $.configurations[0].validationErrors[0].id == 'scope.pattern'
    And match $.configurations[0].validationErrors[0].type == 'INVALID'
    And match $.configurations[0].validationErrors[1].id == 'patterns.pattern'
    And match $.configurations[0].validationErrors[1].type == 'INVALID'
    And match $.configurations[0].validationErrors[2].id == 'patterns.pattern'
    And match $.configurations[0].validationErrors[2].type == 'INVALID'
    And match $.configurations[0].validationErrors[3].id == 'scope.pattern'
    And match $.configurations[0].validationErrors[3].type == 'INVALID'
    And match $.configurations[0].validationErrors[4].id == 'patterns.pattern'
    And match $.configurations[0].validationErrors[4].type == 'INVALID'
    And match $.configurations[0].validationErrors[5].id == 'patterns.pattern'
    And match $.configurations[0].validationErrors[5].type == 'INVALID'
    And match $.configurations[0].validationErrors[6].id == 'scope.pattern'
    And match $.configurations[0].validationErrors[6].type == 'INVALID'
    And match $.configurations[0].validationErrors[7].id == 'patterns.pattern'
    And match $.configurations[0].validationErrors[7].type == 'INVALID'
    And match $.configurations[0].validationErrors[8].id == 'patterns.pattern'
    And match $.configurations[0].validationErrors[8].type == 'INVALID'

  Scenario: As a user I can VALIDATE an FastURLFilter configuration with MISSING PARAMETERS

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request filterFastUrlFilterMissedConfig
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.fasturlfilter.FastURLFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[4]'
    And match $.configurations[0].validationErrors[0].id == 'scope'
    And match $.configurations[0].validationErrors[0].type == 'REQUIRED'
    And match $.configurations[0].validationErrors[1].id == 'patterns'
    And match $.configurations[0].validationErrors[1].type == 'REQUIRED'
    And match $.configurations[0].validationErrors[2].id == 'scope__'
    And match $.configurations[0].validationErrors[2].type == 'UNEXPECTED'
    And match $.configurations[0].validationErrors[3].id == 'patterns__'
    And match $.configurations[0].validationErrors[3].type == 'UNEXPECTED'

  Scenario: As a user I can VALIDATE an Empty FastURLFilter configuration

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request filterFastUrlFilterEmptyConfig
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.fasturlfilter.FastURLFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[1]'
    And match $.configurations[0].validationErrors[0].id == 'rules'
    And match $.configurations[0].validationErrors[0].type == 'REQUIRED'

