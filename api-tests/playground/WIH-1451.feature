Feature: WIH-1451 As a user I can access the XPathFilter endpoint

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def xPathFilter = 'eu.europa.ec.eurostat.wihp.parsefilters.stormcrawler.xpathfilter.XPathFilter'
    * def xPathFilterJson = read('classpath:/api-tests/requests/xPathFilterJson.json')
    * def xPathFilterEmptyJson = read('classpath:/api-tests/requests/xPathFilterEmpty.json')

  Scenario: As a user I can get XPathFilter schema

    Given url playgroundServiceUrl + '/api/parse-filters/' + xPathFilter
    When method get
    Then status 200
    And match $.id == 'eu.europa.ec.eurostat.wihp.parsefilters.stormcrawler.xpathfilter.XPathFilter'
    And match $.name.default == 'XPath Filter'
    And match $.name.translationKey == 'eu.europa.ec.eurostat.wihp.parsefilters.stormcrawler.xpathfilter.XPathFilter'

  Scenario: As a user I can POST a XPathFilter configuration and status 201

    Given url playgroundServiceUrl + '/api/parse-filters/' + xPathFilter
    And request xPathFilterJson
    When method post
    Then status 201
    And match $['canonical'] != null
    And match $['parse.title'] != null
    And match $['parse.description'] != null

  Scenario: As a user I can POST an empty XPathFilter configuration and status 400

    Given url playgroundServiceUrl + '/api/parse-filters/' + xPathFilter
    And request xPathFilterEmptyJson
    When method post
    Then status 400
    And match $.title contains 'Input parameters are not valid'
