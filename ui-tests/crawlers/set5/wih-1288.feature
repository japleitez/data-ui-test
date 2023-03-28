Feature: WIH-1288 As a user, As a user I can use HostURLFilter

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def getCrawlerSuffix =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '_host_url_filter' }
    """
    * def getExpectedTotalItems =
    """
    function(text){
      var expectedTotalItems = text.split(" ")[6] - 1;
      return 'Showing 1 - 25 of ' + expectedTotalItems + ' items'
      }
    """
    * string crawlerToUpdate = getCrawlerSuffix()
    * def filter = function(x){ return x.getText().contains(crawlerToUpdate)}
    * driver dashboardUrl + '/screen/crawlers/'
    * waitFor("//button[@id='copy_button_1']").click()
    * waitFor('#crawler_name')
    * clear('#crawler_name')
    * input('#crawler_name', crawlerToUpdate)
    * waitUntil('#copy_btn', '_.getAttribute("aria-disabled") ==="false"')
    * waitFor("//button[@id='copy_btn']").click()
    * def hostUrlFilterId = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'

  Scenario: 1 As a user, I can add HostURLFilter to crawler
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
    Then waitFor("//button[@id='btn_add_filter_" + hostUrlFilterId + "']")
    Then waitFor("//button[@id='btn_add_filter_" + hostUrlFilterId + "']").click()
    Then waitFor("//*[@id='id_ignoreOutsideHost_" + hostUrlFilterId + "__']").click()
    Then waitFor("//*[@id='id_ignoreOutsideDomain_" + hostUrlFilterId + "__']").click()
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers')
