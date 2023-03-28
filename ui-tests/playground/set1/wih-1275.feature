Feature: As a user, I can view the dashboard and use MaxDepthFilter Filter

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def MaxDepthFilter = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.MaxDepthFilter'
    * def getCrawlerSuffix =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '-basic-url-normalizer' }
    """
    * def getExpectedTotalItems =
    """
    function(text){
      var expectedTotalItems = text.split(" ")[6] - 1;
      return 'Showing 1 - 25 of ' + expectedTotalItems + ' items'
      }
    """
    * string crawlerSuffix = getCrawlerSuffix()
    * def filter = function(x){ return x.getText().contains(crawlerSuffix)}
    * driver dashboardUrl + '/screen/crawlers/'
    * waitFor("//button[@id='copy_button_1']").click()
    * waitFor('#crawler_name')
    * input('#crawler_name', crawlerSuffix)
    * waitUntil('#copy_btn', '_.getAttribute("aria-disabled") ==="false"')
    * waitFor("//button[@id='copy_btn']").click()
    * string crawlerToUpdate = 'crawler1_copy' + crawlerSuffix

  Scenario: 3. As a user I can configure MaxDepthFilter and get back the response
    When driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    Then exists("//eui-page-content[@id='button_test_" + MaxDepthFilter + "']")
    Then waitFor("//*[@id=" + "'button_url_test_" + MaxDepthFilter + "']").click()
    And waitForText('.eui-common-header__sub-label-text', "id: " + MaxDepthFilter)
    Then input("//*[@id='id_maxDepth_" + MaxDepthFilter + "__']", "2")
    Then input("#urls_to_test_id", 'invalidUrl\r\n   http://test.com#fragmentWatever')
    And waitUntil('#play_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='play_btn']").click()
    Then waitUntil('#error_filter_validation_list', '_.getAttribute("aria-disabled") ==="false"')
    Then match text("//*[@id='error_filter_validation_list']/eui-card-header/div[1]/div/eui-card-header-title/eui-badge") contains '2'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[1]/td[1]") contains 'invalidUrl'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[1]/td[2]") contains 'INVALID'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[2]/td[1]") contains 'http://test.com'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[2]/td[2]") contains 'PASS'

  Scenario: 1 As a user, I can add MaxDepthFilter to crawler
    When waitForUrl(dashboardUrl + '/screen/crawlers')
    And waitForResultCount(".eui-table__loading", 0)
    And waitForEnabled("//span[contains(@class, 'eui-icon eui-icon-caret-last')]").click()
    And karate.call('classpath:ui-tests/eui-table/eui-table-find-backwards.feature', {rowText: crawlerToUpdate})
    And def text = text("//div[contains(@class, 'eui-table-paginator__page-range')]")
    And def expectedTotalItems = getExpectedTotalItems(text)
    Then def rows = locateAll('//tr', filter)
    And def row = rows[0]
    And def editButton = row.locate("//span[contains(@iconClass, 'eui-icon-create')]/parent::*/parent::button")
    And editButton.click()
    Then waitFor("//button[@id='btn_add_filter_" + MaxDepthFilter + "']")
    Then waitFor("//button[@id='btn_add_filter_" + MaxDepthFilter + "']").click()
    Then input("//*[@id='id_maxDepth_" + MaxDepthFilter + "__']", "2")
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers')

