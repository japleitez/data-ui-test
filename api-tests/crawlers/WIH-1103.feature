Feature: WIH-1103 As a user, I can import a Crawler

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def jsonValid = read('classpath:/api-tests/requests/importCrawlerValid.json')
    * def jsonNonMappable = read('classpath:/api-tests/requests/importCrawlerNonMappable.json')
    * def jsonInvalid = read('classpath:/api-tests/requests/importCrawlerInvalid.txt')
    * def importCrawlerWithEmptySources = read('classpath:/api-tests/requests/importCrawlerWithEmptySources.json')
    * def now = function(){ return java.lang.System.currentTimeMillis() }

  Scenario: As a user I POST a valid Crawler and get 201
    * set jsonValid.name = 'iCrawler1_' + now()
    * set jsonValid.sources[0].name = 'iSource1_' + now()
    * set jsonValid.sources[1].name = 'iSource2_' + now()
    * set jsonValid.sources[2].name = 'iSource3_' + now()
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(jsonValid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 201

  Scenario: As a user I can POST a valid Crawler with existing Sources and get 201
    * set jsonValid.name = 'iCrawler2_' + now()
    * set jsonValid.sources[0].name = 'source1'
    * set jsonValid.sources[1].name = 'source2'
    * set jsonValid.sources[2].name = 'iSource3_' + now()
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(jsonValid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 201

  Scenario: As a user I can POST a Crawler with an empty list of Sources and get 201
    * set importCrawlerWithEmptySources.name = 'iCrawler6_' + now()
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(importCrawlerWithEmptySources)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 201

  Scenario: As a user I POST an Crawler with invalid configuration and get 422
    * set jsonValid.name = 'iCrawler3_' + now()
    * set jsonValid.name = 'invalid$@!&*'
    * set jsonValid.fetchInterval = -10
    * set jsonValid.fetchIntervalWhenError = -10
    * set jsonValid.fetchIntervalWhenFetchError = -10
    * set jsonValid.extractorNoText = null
    * set jsonValid.httpContentLimit = -10
    * set jsonValid.emitOutLinks = null
    * set jsonValid.maxEmitOutLinksPerPage = -10
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(jsonValid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 422

  Scenario: As a user I POST an Crawler with duplicated Sources get 422
    * set jsonValid.name = 'iCrawler4_' + now()
    * set jsonValid.sources[0].name = 'iSource1_' + now()
    * set jsonValid.sources[1].name = jsonValid.sources[0].name
    * set jsonValid.sources[2].name = 'iSource3_' + now()
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(jsonValid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 422

  Scenario: As a user I can POST a Crawler with invalid Sources and get 422
    * set jsonValid.name = 'iCrawler5_' + now()
    * set jsonValid.sources[0].name = 'asd#%b' + now()
    * set jsonValid.sources[0].url = '__source3'
    * set jsonValid.sources[1].name = 'asd2_' + now()
    * set jsonValid.sources[2].name = 'asd3_' + now()
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(jsonValid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 422

  Scenario: As a user I can POST an unmappable json file and get 422
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(jsonNonMappable)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 422

  Scenario: As a user I can POST an invalid json file and get 422
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(jsonInvalid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 422

  Scenario: As a user I can POST a Crawler with an empty list of Sources and get 201
    * set importCrawlerWithEmptySources.name = 'iCrawler1_' + now()
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(importCrawlerWithEmptySources)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 201
