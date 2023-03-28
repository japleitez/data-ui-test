Feature: WIH-298 As a user, I can create a new crawler

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def name = 'crawler_' + now()
    * def createCrawlerError = read('classpath:/api-tests/requests/createCrawlerError.json')
    * def createCrawlerInvalid = read('classpath:/api-tests/requests/createCrawlerInvalid.json')
    * def createCrawlerValid = read('classpath:/api-tests/requests/createCrawlerValid.json')
    * replace createCrawlerValid.unique_name = name
    * json createCrawlerValid = createCrawlerValid
    * def createCrawlerWithInvalidFilterClassName = read('classpath:/api-tests/requests/createCrawlerWithInvalidFilterClassName.json')
    * def createCrawlerWithInvalidFilterName = read('classpath:/api-tests/requests/createCrawlerWithInvalidFilterName.json')
    * def createCrawlerWithInvalidFilterParams = read('classpath:/api-tests/requests/createCrawlerWithInvalidFilterParams.json')
    * def crawlerNameTooLong = read('classpath:/api-tests/requests/crawlerNameTooLong.json')


  Scenario: As a user I can POST a valid crawler form

    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerValid
    When method post
    Then status 201

  Scenario: As a user I can POST a invalid crawler form and gets an 422 error

    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerInvalid
    When method post
    Then status 422

  Scenario: As a user I can POST a malformed crawler form and gets an 422 error

    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerError
    When method post
    Then status 422

  Scenario: As a user I can POST a valid crawler with invalid Filter className and gets an 422 error

    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerWithInvalidFilterClassName
    When method post
    Then status 422

  Scenario: As a user I can POST a valid crawler with invalid Filter name and gets an 422 error

    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerWithInvalidFilterName
    When method post
    Then status 422

  Scenario: As a user I can POST a valid crawler with invalid Filter params and gets an 422 error

    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerWithInvalidFilterParams
    When method post
    Then status 422


  Scenario: As a user I can POST to copy a crawler

    Given url serviceUrl + '/api/crawlers/1/copy'
    And request { name: '#(name)' }
    When method post
    Then status 201

  Scenario: As a user I can POST to copy a crawler without providing a new name and gets and 422 error

    Given url serviceUrl + '/api/crawlers/1/copy'
    And request { name: '' }
    When method post
    Then status 422

  Scenario: As a user I can POST to copy a crawler with invalid new name and gets and 422 error

    Given url serviceUrl + '/api/crawlers/1/copy'
    And request { name: '$eurostat' }
    When method post
    Then status 422

  Scenario: As a user I can POST to copy a crawler with a new name already in use and gets and 500 error

    Given url serviceUrl + '/api/crawlers/1/copy'
    And request { name: 'crawler1' }
    When method post
    Then status 400

  Scenario: As a user I can POST to copy a crawler with a new name exceeding 100 chars and gets and 422 error

    Given url serviceUrl + '/api/crawlers/1/copy'
    And request crawlerNameTooLong
    When method post
    Then status 422
