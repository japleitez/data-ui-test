Feature: WIH-1473 As a user I can validate navigation-filters configurations

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def filterId = 'eu.europa.ec.eurostat.wihp.navigationfilters.stormcrawler.BasicNavigationFilter'
    * def filterConfigValid = read('classpath:/api-tests/requests/filterTestNavigationFilterConfigValid.json')
    * def filterConfigInvalid = read('classpath:/api-tests/requests/filterTestNavigationFilterConfigInvalid.json')

  Scenario: As a user I can validate a VALID TestParseFilter configuration

    Given url playgroundServiceUrl + '/api/navigation-filters/validate'
    And request filterConfigValid
    When method post
    Then status 200
    And match $.configurations[0].id == filterId
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[0]'

  Scenario: As a user I can validate an INVALID TestParseFilter configuration

    Given url playgroundServiceUrl + '/api/navigation-filters/validate'
    And request filterConfigInvalid
    When method post
    Then status 200
    And match $.configurations[0].id == filterId
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[1]'
    And match $.configurations[0].validationErrors[0].id == 'steps'
    And match $.configurations[0].validationErrors[0].type == 'REQUIRED'

