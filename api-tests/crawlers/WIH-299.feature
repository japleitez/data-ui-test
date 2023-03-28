Feature: WIH-299 As a user, I can modify a crawler

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def updateCrawlerInvalid = read('classpath:/api-tests/requests/updateCrawlerInvalid.json')
    * def updateCrawlerValid = read('classpath:/api-tests/requests/updateCrawlerValid.json')
    * def updateCrawlerWithInvalidFilterClassName = read('classpath:/api-tests/requests/updateCrawlerWithInvalidFilterClassName.json')
    * def updateCrawlerWithInvalidFilterName = read('classpath:/api-tests/requests/updateCrawlerWithInvalidFilterName.json')
    * def updateCrawlerWithInvalidFilterParams = read('classpath:/api-tests/requests/updateCrawlerWithInvalidFilterParams.json')


  Scenario: As a user I can PUT a valid crawler form

    Given url serviceUrl + '/api/crawlers/30'
    And request updateCrawlerValid
    When method put
    Then status 200

  Scenario: As a user I PUT a invalid crawler form and gets an 422 error

    Given url serviceUrl + '/api/crawlers/1'
    And request updateCrawlerInvalid
    When method put
    Then status 422

  Scenario: As a user I PUT a valid crawler with invalid Filter className and gets an 422 error

    Given url serviceUrl + '/api/crawlers'
    And request updateCrawlerWithInvalidFilterClassName
    When method post
    Then status 422

  Scenario: As a user I PUT a valid crawler with invalid Filter name and gets an 422 error

    Given url serviceUrl + '/api/crawlers'
    And request updateCrawlerWithInvalidFilterName
    When method post
    Then status 422

  Scenario: As a user I PUT a valid crawler with invalid Filter params and gets an 422 error

    Given url serviceUrl + '/api/crawlers'
    And request updateCrawlerWithInvalidFilterParams
    When method post
    Then status 422