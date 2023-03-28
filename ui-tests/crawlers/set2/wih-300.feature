Feature: As a user, I can delete a crawler

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def getRandomCrawler =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '-crawler-to-delete' }
    """
    * def getExpectedTotalItems =
    """
    function(text){
      var expectedTotalItems = text.split(" ")[6] - 1;
      return 'Showing 1 - 25 of ' + expectedTotalItems + ' items'
      }
    """
    * string crawlerToDelete = getRandomCrawler()
    * def filter = function(x){ return x.getText().contains(crawlerToDelete)}
    * driver dashboardUrl + '/screen/crawlers/'
    * waitFor("//button[@id='copy_button_1']").click()
    * waitFor('#crawler_name')
    * clear('#crawler_name')
    * input('#crawler_name', crawlerToDelete)
    * waitUntil('#copy_btn', '_.getAttribute("aria-disabled") ==="false"')
    * waitFor("//button[@id='copy_btn']").click()


  Scenario: 1.Delete crawler
    When waitForUrl(dashboardUrl + '/screen/crawlers')
    And waitForResultCount(".eui-table__loading", 0)
    And waitForEnabled("//span[contains(@class, 'eui-icon eui-icon-caret-last')]").click()
    And karate.call('classpath:ui-tests/eui-table/eui-table-find-backwards.feature', {rowText: crawlerToDelete})
    And def text = text("//div[contains(@class, 'eui-table-paginator__page-range')]")
    And def expectedTotalItems = getExpectedTotalItems(text)
    Then def rows = locateAll('//tr', filter)
    And def row = rows[0]
    And def delButton = row.locate("//span[contains(@iconClass, 'eui-icon-delete-o')]/parent::*/parent::button")
    And delButton.click()
    And waitForText("//div[contains(@class, 'ux-modal__header-title')]", "Confirm crawler delete")
    And waitFor("//uxmodalfooter/button[contains(@class, 'ux-button--primary')]").click()
    And waitForText("//div[contains(@class, 'eui-table-paginator__page-range')]", expectedTotalItems)


