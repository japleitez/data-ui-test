Feature: As a user, I can configure and validate MaxDepthFilter

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def MaxDepthFilter = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.MaxDepthFilter'
    * def jsonOK = read('classpath:/api-tests/requests/max_depth_2.json')
    * def filterConfigurationEmpty = read('classpath:/api-tests/requests/max_dept_empty.json')
    * def jsonUnlimited = read('classpath:/api-tests/requests/max_depth_unlimited.json')
    * def jsonWrong = read('classpath:/api-tests/requests/max_depth_Filter_wrong.json')

  Scenario: As a user I can get HostURLFilter schema

    Given url playgroundServiceUrl + '/api/url-filters/' + MaxDepthFilter
    When method get
    Then status 200
    And match $.id == MaxDepthFilter
    And match $.name.default == 'Maximum depth filter'
    And match $.name.translationKey == 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.MaxDepthFilter'

  Scenario: As a user I can POST a filter configuration and status 201

    Given url playgroundServiceUrl + '/api/url-filters/' + MaxDepthFilter
    And request jsonOK
    When method post
    Then status 201
    And match $.urls[0].url contains 'https://www.blah.com/bla?caram=3&param2=bar&zaram=1#someresource'


  Scenario: As a user I can validate MaxDepthFilter with an empty filter configuration and get error list

    Given url playgroundServiceUrl + '/api/url-filters/validate' + MaxDepthFilter
    And request filterConfigurationEmpty
    When method post
    Then status 400
    And match $.title == 'Input parameters are not valid'



  Scenario: As a user I can post MaxDepthFilter with a not bound filter configuration and get empty error list

    Given url playgroundServiceUrl + '/api/url-filters/' + MaxDepthFilter
    And request jsonUnlimited
    When method post
    Then status 201
    And match $.urls == '#[3]'
    And match $.urls[0].url contains 'https://www.blah.com/bla?caram=3&param2=bar&zaram=1#someresource'
    And match $.urls[0].result == true
    And match $.urls[1].url contains 'http://welldone?shouldstay=1&id=912ec803b2ce49e4a541068d495ab570'
    And match $.urls[1].result == true
    And match $.urls[2].url contains 'http://welldone?asd=a&ddc=b&ccn=d&shouldstay=1'
    And match $.urls[2].result == true


  Scenario: As a user I can validate MaxDepthFilter with a non Valid filter configuration and get error list

    Given url playgroundServiceUrl + '/api/url-filters/validate'
    And request jsonWrong
    When method post
    Then status 200
    And match $.configurations[0].id == MaxDepthFilter
    And match $.configurations[0].validationErrors != null
    And match $.configurations[0].validationErrors == '#[2]'
