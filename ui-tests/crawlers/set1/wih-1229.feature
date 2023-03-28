Feature: As a user, I can add UrlFilters into crawler

  Background:
    * def getRandomSource =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string crawlerRandomName = getRandomSource()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def testFilterId = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.BasicUrlFilter'

  Scenario: 1.Add UrlFilter
    Given driver dashboardUrl + '/screen/crawlers/details/5'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/5')
    And waitForResultCount(".eui-table__loading", 0)
    When clear('#crawler_name')
    And input('#crawler_name', crawlerRandomName)
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    And focus('#fetch_interval')
    Then waitFor("//*[@id='btn_add_filter_" + testFilterId + "']").click()
    And focus('#fetch_interval')
    And focus("//*[@id='btn_add_filter_" + testFilterId + "']")
    Then match text("//*[@id='remove_filter_" + testFilterId + "']") contains 'Remove Filter'

  Scenario: 2.Remove UrlFilter
    Given driver dashboardUrl + '/screen/crawlers/details/5'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/5')
    And waitForResultCount(".eui-table__loading", 0)
    When clear('#crawler_name')
    And input('#crawler_name', crawlerRandomName)
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    And focus('#fetch_interval')
    Then waitFor("//*[@id='btn_add_filter_" + testFilterId + "']").click()
    And focus('#fetch_interval')
    And focus("//*[@id='btn_add_filter_" + testFilterId + "']")
    Then match text("//*[@id='remove_filter_" + testFilterId + "']") contains 'Remove Filter'
    Then waitFor("//*[@id='remove_filter_" + testFilterId + "']").click()
    Then waitForEnabled("//*[@id='btn_add_filter_" + testFilterId + "']")

  Scenario: 3.Filter with valid values can be saved
    Given driver dashboardUrl + '/screen/crawlers/details/5'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/5')
    And waitForResultCount(".eui-table__loading", 0)
    When clear('#crawler_name')
    And input('#crawler_name', crawlerRandomName)
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    And focus('#fetch_interval')
    Then waitFor("//*[@id='btn_add_filter_" + testFilterId + "']").click()
    And focus('#fetch_interval')
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')
    Then match text("//*[@id='remove_filter_" + testFilterId + "']") contains 'Remove Filter'
    And input("//*[@id='id_maxPathRepetition_" + testFilterId + "__']", '1')
    And input("//*[@id='id_maxLength_" + testFilterId + "__']", '2')
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')

  Scenario: 4.Save button is disabled if Filter has with invalid values
    Given driver dashboardUrl + '/screen/crawlers/details/5'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/5')
    And waitForResultCount(".eui-table__loading", 0)
    When clear('#crawler_name')
    And input('#crawler_name', crawlerRandomName)
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    And focus('#fetch_interval')
    Then waitFor("//*[@id='btn_add_filter_" + testFilterId + "']").click()
    And focus('#fetch_interval')
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')
    Then match text("//*[@id='remove_filter_" + testFilterId + "']") contains 'Remove Filter'
    And input("//*[@id='id_maxPathRepetition_" + testFilterId + "__']", '20')
    And input("//*[@id='id_maxLength_" + testFilterId + "__']", '2')
    And focus("//*[@id='id_maxLength_" + testFilterId + "__']")
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')
