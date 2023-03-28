Feature: As a user, I can configure and validate BasicURLNormalizer

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def BasicURLNormalizerId = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.basicurlnormalizer.BasicURLNormalizer'
    * def jsonOK = read('classpath:/api-tests/requests/BasicURLNormalizer_useFilter.json')
    * def filterConfigurationEmpty = read('classpath:/api-tests/requests/basicUrlNormalizer_empty.json')
    * def jsonDefault = read('classpath:/api-tests/requests/basicUrlNormalizer_default.json')
    * def jsonNonDefault = read('classpath:/api-tests/requests/basicUrlNormalizer_nonDefault.json')
    * def jsonWrong = read('classpath:/api-tests/requests/basicUrlNormalizer_wrong.json')

  Scenario: As a user I can get HostURLFilter schema

    Given url playgroundServiceUrl + '/api/url-filters/' + BasicURLNormalizerId
    When method get
    Then status 200
    And match $.id == BasicURLNormalizerId
    And match $.name.default == 'Basic URL Normalizer'
    And match $.name.translationKey == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.BasicURLNormalizer'

  Scenario: As a user I can POST a filter configuration and status 201

    Given url playgroundServiceUrl + '/api/url-filters/' + BasicURLNormalizerId
    And request jsonOK
    When method post
    Then status 201
    And match $.urls[0].url contains 'https://www.blah.com/bla?caram=3&param2=bar&zaram=1'
    And match $.urls[1].url contains 'http://welldone?shouldstay=1'
    And match $.urls[2].url contains 'http://welldone?shouldstay=1'

  Scenario: As a user I can POST a wrong filter configuration and status 400

    Given url playgroundServiceUrl + '/api/url-filters/' + BasicURLNormalizerId
    And request jsonWrong
    When method post
    Then status 400
    And match $.title == 'Input parameters are not valid'

  Scenario: As a user I can POST an empty filter configuration and status 400

    Given url playgroundServiceUrl + '/api/url-filters/' + BasicURLNormalizerId
    And request filterConfigurationEmpty
    When method post
    Then status 400
    And match $.title == 'Input parameters are not valid'



  Scenario: As a user I can validate BasicURLNormalizer with a DEFAULT filter configuration and get empty error list

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request jsonDefault
    When method post
    Then status 200
    And match $.configurations[0].id == BasicURLNormalizerId
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[0]'


  Scenario: As a user I can validate BasicURLNormalizer with a non DEFAULT filter configuration and get empty error list

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request jsonNonDefault
    When method post
    Then status 200
    And match $.configurations[0].id == BasicURLNormalizerId
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[0]'


  Scenario: As a user I can validate BasicURLNormalizer with a non Valid filter configuration and get error list

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request jsonWrong
    When method post
    Then status 200
    And match $.configurations[0].id == BasicURLNormalizerId
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[1]'