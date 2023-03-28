Feature: WIH-1070 As a user I can set selenium options

  Background:
    * def createCrawlerWithSeleniumOptionsValid = read('classpath:/api-tests/requests/createCrawlerWithSeleniumOptionsValid.json')
    * def createCrawlerWithNullSeleniumOptions = read('classpath:/api-tests/requests/createCrawlerWithNullSeleniumOptions.json')
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def updateCrawlerValidSeleniumOptions = read('classpath:/api-tests/requests/updateCrawlerWithSeleniumOptionsValid.json')


  Scenario: 1. As a user I can create new Crawler with SeleniumOptions via POST request
    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerWithSeleniumOptionsValid
    When method post
    Then status 201
    And match $.dynamicConfig.language == 'ru-JP'
    And match $.dynamicConfig.windowSize == '1111,1111'
    Then def crawlerId = $.id
    And url serviceUrl + '/api/crawlers/' + crawlerId
    And header Authorization = 'Bearer ' + accessToken
    When method delete
    Then status 204

  Scenario: 2. As a user I can create new Crawler with default SeleniumOptions via POST request
    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerWithNullSeleniumOptions
    When method post
    Then status 201
    And match $.dynamicConfig.language == 'de'
    And match $.dynamicConfig.windowSize == '1920,1080'
    And match $.dynamicConfig.maximized == true
    And match $.dynamicConfig.loadImages == 'ALLOW'
    And match $.dynamicConfig.allowCookies == 'BLOCK'
    And match $.dynamicConfig.allowGeolocation == 'BLOCK'
    Then def crawlerId = $.id
    And url serviceUrl + '/api/crawlers/' + crawlerId
    And header Authorization = 'Bearer ' + accessToken
    When method delete
    Then status 204

  Scenario: 3. As a user I can update Crawler
    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerWithSeleniumOptionsValid
    When method post
    Then status 201
    Then def newCrawlerId = $.id
    And match $.dynamicConfig.language == 'ru-JP'
    And match $.dynamicConfig.windowSize == '1111,1111'
    Then url serviceUrl + '/api/crawlers/' + newCrawlerId
    And header Authorization = 'Bearer ' + accessToken
    When method get
    Then status 200
    And match $.dynamicConfig.language == 'ru-JP'
    And match $.dynamicConfig.windowSize == '1111,1111'
    Then replace updateCrawlerValidSeleniumOptions.id_place = newCrawlerId
    And replace updateCrawlerValidSeleniumOptions.windowSize_place = '2222,2222'
    And replace updateCrawlerValidSeleniumOptions.loadImages_place = 'BLOCK'
    Then json updateCrawlerValidSeleniumOptions = updateCrawlerValidSeleniumOptions
    Then request updateCrawlerValidSeleniumOptions
    And header Authorization = 'Bearer ' + accessToken
    When method put
    Then status 200
    And assert response.dynamicConfig.language == 'gr-CH'
    And match $.dynamicConfig.windowSize == '2222,2222'
    And match $.dynamicConfig.maximized == false
    And match $.dynamicConfig.loadImages == 'BLOCK'
    And match $.dynamicConfig.allowCookies == 'ALLOW'
    And match $.dynamicConfig.allowGeolocation == 'ALLOW'
    Then url serviceUrl + '/api/crawlers/' + newCrawlerId
    And header Authorization = 'Bearer ' + accessToken
    When method delete
    Then status 204

  Scenario: 4. As a user when I update Crawler with wrong loadImages I get 400 error
    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerWithSeleniumOptionsValid
    When method post
    Then status 201
    Then def newCrawlerId = $.id
    Then url serviceUrl + '/api/crawlers/' + newCrawlerId
    And header Authorization = 'Bearer ' + accessToken
    When method get
    Then status 200
    Then replace updateCrawlerValidSeleniumOptions.id_place = newCrawlerId
    And replace updateCrawlerValidSeleniumOptions.windowSize_place = '2222,2222'
    And replace updateCrawlerValidSeleniumOptions.loadImages_place = 'WRONG_ENUM'
    Then json updateCrawlerValidSeleniumOptions = updateCrawlerValidSeleniumOptions
    Then request updateCrawlerValidSeleniumOptions
    And header Authorization = 'Bearer ' + accessToken
    When method put
    Then status 400
    And assert response.title == 'Bad Request'
    Then url serviceUrl + '/api/crawlers/' + newCrawlerId
    And header Authorization = 'Bearer ' + accessToken
    When method delete
    Then status 204

  Scenario: 5. As a user when I update Crawler with wrong windowSize I get 422 error
    Given url serviceUrl + '/api/crawlers'
    And request createCrawlerWithSeleniumOptionsValid
    When method post
    Then status 201
    Then def newCrawlerId = $.id
    Then url serviceUrl + '/api/crawlers/' + newCrawlerId
    And header Authorization = 'Bearer ' + accessToken
    When method get
    Then status 200
    Then replace updateCrawlerValidSeleniumOptions.id_place = newCrawlerId
    And replace updateCrawlerValidSeleniumOptions.windowSize_place = '1,111'
    And replace updateCrawlerValidSeleniumOptions.loadImages_place = 'BLOCK'
    Then json updateCrawlerValidSeleniumOptions = updateCrawlerValidSeleniumOptions
    Then request updateCrawlerValidSeleniumOptions
    And header Authorization = 'Bearer ' + accessToken
    When method put
    Then status 422
    And assert response.title == 'Method argument not valid'
    And assert response.fieldErrors[0].field == 'dynamicConfig.windowSize'
    And assert response.fieldErrors[0].message == 'invalid window-size'
    Then url serviceUrl + '/api/crawlers/' + newCrawlerId
    And header Authorization = 'Bearer ' + accessToken
    When method delete
    Then status 204
