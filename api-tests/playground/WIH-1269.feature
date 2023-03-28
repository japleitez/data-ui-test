Feature: WIH-1269 As a user I can validate parse-filters configurations

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def filterId = 'eu.europa.ec.eurostat.wihp.parsefilters.examples.TestParseFilter'
    * def filterConfigValid = read('classpath:/api-tests/requests/filterTestParseFilterConfigValid.json')
    * def filterConfigInvalid = read('classpath:/api-tests/requests/filterTestParseFilterConfigInvalid.json')

  Scenario: As a user I can validate a VALID TestParseFilter configuration

    Given url playgroundServiceUrl + '/api/parse-filters/validate'
    And request filterConfigValid
    When method post
    Then status 200
    And match $.configurations[0].id == filterId
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[0]'

  Scenario: As a user I can validate an INVALID TestParseFilter configuration

    Given url playgroundServiceUrl + '/api/parse-filters/validate'
    And request filterConfigInvalid
    When method post
    Then status 200
    And match $.configurations[0].id == filterId
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[2]'
    And match $.configurations[0].validationErrors[0].id == 'property'
    And match $.configurations[0].validationErrors[0].type == 'REQUIRED'
    And match $.configurations[0].validationErrors[1].id == 'property_wrong'
    And match $.configurations[0].validationErrors[1].type == 'UNEXPECTED'
