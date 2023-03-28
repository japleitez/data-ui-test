Feature: WIH-300 As a user, I can delete a crawler

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def name = 'crawler_' + now()
    * def createCrawlerValid = read('classpath:/api-tests/requests/createCrawlerValid.json')
    * replace createCrawlerValid.unique_name = name
    * json createCrawlerValid = createCrawlerValid


  Scenario: As a user I can DELETE an existing crawler

    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerValid
    And method post
    And status 201
    And def crawlerId = $.id
    And url serviceUrl + '/api/crawlers/' + crawlerId
    And header Authorization = 'Bearer ' + accessToken
    When method delete
    Then status 204

  Scenario: As a user I can DELETE a non existing crawler and get 500 error

    Given url serviceUrl + '/api/crawlers/-1'
    When method delete
    Then status 500

  Scenario: As a user I can DELETE a crawler that is used by an acquisition and get 400 error

    Given url serviceUrl + '/api/crawlers/1'
    When method delete
    Then status 400
