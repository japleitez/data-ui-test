Feature: WIH-1288 As a user I can use HostURLFilter

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def hostUrlFilter = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'
    * def filterHostUrlFilterConfig = read('classpath:/api-tests/requests/filterHostUrlFilterConfig.json')
    * def filterHostUrlFilterEmptyConfig = read('classpath:/api-tests/requests/filterHostUrlFilterEmptyConfig.json')
    * def filterHostUrlFilterWrongConfig = read('classpath:/api-tests/requests/filterHostUrlFilterWrongConfig.json')

  Scenario: As a user I can validate a VALID HostURLFilter configuration

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request filterHostUrlFilterConfig
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[0]'

  Scenario: As a user I can validate an INVALID HostURLFilter configuration

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request filterHostUrlFilterWrongConfig
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[3]'
    And match $.configurations[0].validationErrors[0].id == 'ignoreOutsideDomain'
    And match $.configurations[0].validationErrors[0].type == 'REQUIRED'
    And match $.configurations[0].validationErrors[1].id == 'ignoreOutsideHost.required'
    And match $.configurations[0].validationErrors[1].type == 'INVALID'
    And match $.configurations[0].validationErrors[2].id == 'ignoreOutsideDomain$'
    And match $.configurations[0].validationErrors[2].type == 'UNEXPECTED'

  Scenario: As a user I can validate an Empty HostURLFilter configuration

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request filterHostUrlFilterEmptyConfig
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[2]'
    And match $.configurations[0].validationErrors[0].id == 'ignoreOutsideHost'
    And match $.configurations[0].validationErrors[0].type == 'REQUIRED'
    And match $.configurations[0].validationErrors[1].id == 'ignoreOutsideDomain'
    And match $.configurations[0].validationErrors[1].type == 'REQUIRED'
