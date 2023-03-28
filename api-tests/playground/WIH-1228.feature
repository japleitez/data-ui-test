Feature: WIH-1228 As a user, validate filters on the playground

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def jsonValid = read('classpath:/api-tests/requests/filtersConfigValid.json')
    * def jsonInvalid = read('classpath:/api-tests/requests/filtersConfigInvalid.json')
    * def jsonInvalidID = read('classpath:/api-tests/requests/filterConfigInvalidId.json')
    * def jsonInvalidUnexpectedAndMissing = read('classpath:/api-tests/requests/filterConfigurationUnexpectedAndMissing.json')
    * def jsonfilterConfigInvalidAllCombinations = read('classpath:/api-tests/requests/filterConfigInvalidAllcombinations.json')

  Scenario: As a user I can validate a VALID filter configuration

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request jsonValid
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[0]'

  Scenario: As a user I can validate an INVALID filter configuration

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request jsonInvalid
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[2]'
    And match $.configurations[0].validationErrors[0].id == 'character.pattern'
    And match $.configurations[0].validationErrors[0].type == 'INVALID'
    And match $.configurations[0].validationErrors[1].id == 'character.maxLength'
    And match $.configurations[0].validationErrors[1].type == 'INVALID'


  Scenario: As a user I can get validation result for a configuration with not existing ID and get INVALID

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request jsonInvalidID
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter2'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[1]'
    And match $.configurations[0].validationErrors[0].id == 'id'
    And match $.configurations[0].validationErrors[0].type == 'INVALID'
    And match $.configurations[1].id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.BasicUrlFilter3'
    And match $.configurations[1].validationErrors != null
    And match $.configurations[1].validationErrors == '#[1]'
    And match $.configurations[1].validationErrors[0].id == 'id'
    And match $.configurations[1].validationErrors[0].type == 'INVALID'

  Scenario: As a user I can get validation result for a configuration with not expected field and missing field and get respectively UNEXPECTED and REQUIRED

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request jsonInvalidUnexpectedAndMissing
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[1]'
    And match $.configurations[0].validationErrors[0].id == 'character'
    And match $.configurations[0].validationErrors[0].type == 'REQUIRED'
    And match $.configurations[1].id == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.BasicUrlFilter'
    And match $.configurations[1].validationErrors != null
    And match $.configurations[1].validationErrors == '#[1]'
    And match $.configurations[1].validationErrors[0].id == 'alvaro'
    And match $.configurations[1].validationErrors[0].type == 'UNEXPECTED'


  Scenario: As a user I can get validation result for a configuration with a combination of invalid configuration and get INVALID

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request jsonfilterConfigInvalidAllCombinations
    When method post
    Then status 200
    And match $.configurations[0].id == 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter'
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[11]'
    And match $.configurations[0].validationErrors[0].id == 'character.required'
    And match $.configurations[0].validationErrors[0].type == 'INVALID'
    And match $.configurations[0].validationErrors[1].id == 'minReoccurrence.minimum'
    And match $.configurations[0].validationErrors[1].type == 'INVALID'
    And match $.configurations[0].validationErrors[2].id == 'maxReoccurrence.minimum'
    And match $.configurations[0].validationErrors[2].type == 'INVALID'
    And match $.configurations[0].validationErrors[3].id == 'minPercentage.minimum'
    And match $.configurations[0].validationErrors[3].type == 'INVALID'
    And match $.configurations[0].validationErrors[4].id == 'maxPercentage.minimum'
    And match $.configurations[0].validationErrors[4].type == 'INVALID'
    And match $.configurations[0].validationErrors[5].id == 'extraCharacters.pattern'
    And match $.configurations[0].validationErrors[5].type == 'INVALID'
    And match $.configurations[0].validationErrors[6].id == 'extraCharacters.minLength'
    And match $.configurations[0].validationErrors[6].type == 'INVALID'
    And match $.configurations[0].validationErrors[7].id == 'extraCharacters.pattern'
    And match $.configurations[0].validationErrors[7].type == 'INVALID'
    And match $.configurations[0].validationErrors[8].id == 'extraCharacters.minLength'
    And match $.configurations[0].validationErrors[8].type == 'INVALID'
    And match $.configurations[0].validationErrors[9].id == 'extraCharacters.pattern'
    And match $.configurations[0].validationErrors[9].type == 'INVALID'
    And match $.configurations[0].validationErrors[10].id == 'extraCharacters.minLength'
    And match $.configurations[0].validationErrors[10].type == 'INVALID'
    And match $.configurations[1].id == 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter'
    And match $.configurations[1].validationErrors != null
    And match $.configurations[1].validationErrors == '#[7]'
    And match $.configurations[1].validationErrors[0].id == 'character.pattern'
    And match $.configurations[1].validationErrors[0].type == 'INVALID'
    And match $.configurations[1].validationErrors[1].id == 'minPercentage.maximum'
    And match $.configurations[1].validationErrors[1].type == 'INVALID'
    And match $.configurations[1].validationErrors[2].id == 'maxPercentage.maximum'
    And match $.configurations[1].validationErrors[2].type == 'INVALID'
    And match $.configurations[1].validationErrors[3].id == 'extraCharacters.maxArrayLength'
    And match $.configurations[1].validationErrors[3].type == 'INVALID'
    And match $.configurations[1].validationErrors[4].id == 'extraCharactersMinReoccurrence.maxArrayLength'
    And match $.configurations[1].validationErrors[4].type == 'INVALID'
    And match $.configurations[1].validationErrors[5].id == 'extraCharactersMinReoccurrencePercentage.maxArrayLength'
    And match $.configurations[1].validationErrors[5].type == 'INVALID'
    And match $.configurations[1].validationErrors[6].id == 'extraCharactersExistInDomain.maxArrayLength'
    And match $.configurations[1].validationErrors[6].type == 'INVALID'