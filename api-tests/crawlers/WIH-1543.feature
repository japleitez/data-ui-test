Feature: WIH-1543 As a user, I cannot create or update deprecated ParserFilters

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def name = 'crawler_' + now()
    * def depName = 'crawler_dep_' + now()
    * def copyName = 'crawler_copy_' + now()
    * def crawlerValid = read('classpath:/api-tests/requests/createCrawlerValid.json')
    * def crawlerWithDeprecatedFilters = read('classpath:/api-tests/requests/crawler_form_with_deprecated_filters.json')
    * def crawlerWithExistingDeprecatedFilters = read('classpath:/api-tests/requests/crawler_form_with_existing_deprecated_filters.json')
    * def crawlerWithoutExistingDeprecatedFilters = read('classpath:/api-tests/requests/crawler_form_without_existing_deprecated_filters.json')
    * def copyCrawlerWithExistingDeprecatedFilters = read('classpath:/api-tests/requests/copy_crawler_form_with_existing_deprecated_filters.json')
    * replace crawlerValid.unique_name = name
    * replace crawlerWithDeprecatedFilters.unique_name = depName
    * replace copyCrawlerWithExistingDeprecatedFilters.unique_name = copyName
    * json crawlerValid = crawlerValid
    * json crawlerWithDeprecatedFilters = crawlerWithDeprecatedFilters
    * json crawlerWithExistingDeprecatedFilters = crawlerWithExistingDeprecatedFilters
    * json crawlerWithoutExistingDeprecatedFilters = crawlerWithoutExistingDeprecatedFilters
    * json copyCrawlerWithExistingDeprecatedFilters = copyCrawlerWithExistingDeprecatedFilters

  Scenario: 1. As a user I POST a crawler form with deprecated parserFilters and gets an 422 error

    Given url serviceUrl + '/api/crawlers'
    And request crawlerWithDeprecatedFilters
    When method post
    Then status 422

  Scenario: 2. As a user I PUT a crawler form to update and existing crawler without ParserFilters and gets a 422 error (create and update)

    Given url serviceUrl + '/api/crawlers'
    And request crawlerValid
    When method post
    Then status 201
    Then def newCrawlerId = $.id
    Then def newCrawlerName = $.name
    Then replace crawlerWithoutExistingDeprecatedFilters.unique_id = newCrawlerId
    Then replace crawlerWithoutExistingDeprecatedFilters.unique_name = newCrawlerName
    Then json crawlerWithoutExistingDeprecatedFilters = crawlerWithoutExistingDeprecatedFilters
    Then url serviceUrl + '/api/crawlers/' + newCrawlerId
    Then request crawlerWithoutExistingDeprecatedFilters
    And header Authorization = 'Bearer ' + accessToken
    When method put
    Then status 422

  Scenario: 3. As a user I PUT a crawler form to update and existing crawler with ParserFilters and gets a 200 (api does not update ParserFilters)

    Then url serviceUrl + '/api/crawlers/1'
    When method get
    Then status 200
    Then def existingCrawlerId = $.id
    Then def existingCrawlerName = $.name
    Then replace crawlerWithExistingDeprecatedFilters.unique_id = existingCrawlerId
    Then replace crawlerWithExistingDeprecatedFilters.unique_name = existingCrawlerName
    Then replace crawlerWithExistingDeprecatedFilters.parserFilters = []
    Then json crawlerWithExistingDeprecatedFilters = crawlerWithExistingDeprecatedFilters
    Then url serviceUrl + '/api/crawlers/1'
    Then request crawlerWithExistingDeprecatedFilters
    And header Authorization = 'Bearer ' + accessToken
    When method put
    Then status 200
    And assert response.parserFilters.length == 7

  Scenario: 4. As a user I can POST to copy a crawler with ParserFilters and copied crawler does not have ParserFilters

    Given url serviceUrl + '/api/crawlers/2/copy'
    And request copyCrawlerWithExistingDeprecatedFilters
    When method post
    Then status 201
    And assert response.parserFilters.length == 0


