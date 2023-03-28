Feature: As a user, I can delete a source

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def getRandomNumber =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '_delete_me' }
    """
    * def getExpectedTotalItems =
    """
    function(text){
      var expectedTotalItems = text.split(" ")[6] - 1;
      return 'Showing 1 - 25 of ' + expectedTotalItems + ' items'
      }
    """
    * string source = 'delete_me_' + getRandomNumber()
    * def filter = function(x){ return x.getText().contains(source)}
    * driver dashboardUrl + '/screen/sources'
    * waitFor("//ux-button-group[@id='create_source']//button").click()
    * waitFor('#source_name')
    * clear('#source_name')
    * input('#source_name', source)
    * waitFor('#source_url')
    * clear('#source_url')
    * input('#source_url', 'http://www.' + source + '.com')
    * waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    * waitFor("//button[@id='save_btn']").click()

  Scenario: 1.Delete source
    When waitForUrl('/screen/sources')
    And waitForResultCount(".eui-table__loading", 0)
    And waitForEnabled("//span[contains(@class, 'eui-icon eui-icon-caret-last')]").click()
    And karate.call('classpath:ui-tests/eui-table/eui-table-find-backwards.feature', {rowText: source})
    And def text = text("//div[contains(@class, 'eui-table-paginator__page-range')]")
    And def expectedTotalItems = getExpectedTotalItems(text)
    Then def rows = locateAll('//tr', filter)
    And def row = rows[0]
    And def delButton = row.locate("//span[contains(@iconClass, 'eui-icon-delete-o')]/parent::*/parent::button")
    And delButton.click()
    And waitForText("//div[contains(@class, 'ux-modal__header-title')]", "Confirm source delete")
    And waitFor("//uxmodalfooter/button[contains(@class, 'ux-button--primary')]").click()
    And waitForText("//div[contains(@class, 'eui-table-paginator__page-range')]",  expectedTotalItems)


