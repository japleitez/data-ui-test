Feature: WIH-1544 As a user, I cannot add/update deprecated ParserFilters

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def getCrawlerSuffix =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '_copied_without_parserFilters' }
    """
    * def getExpectedTotalItems =
    """
    function(text){
      var expectedTotalItems = text.split(" ")[6] - 1;
      return 'Showing 1 - 25 of ' + expectedTotalItems + ' items'
      }
    """
    * string crawlerToCheck = getCrawlerSuffix()
    * def filter = function(x){ return x.getText().contains(crawlerToCheck)}
    * driver dashboardUrl + '/screen/crawlers/'
    * waitFor("//button[@id='copy_button_1']").click()
    * waitFor('#crawler_name')
    * clear('#crawler_name')
    * input('#crawler_name', crawlerToCheck)
    * waitUntil('#copy_btn', '_.getAttribute("aria-disabled") ==="false"')
    * waitFor("//button[@id='copy_btn']").click()

  Scenario: 1 As a user, I can see legacy ParserFilters in an old Crawler

    Given driver dashboardUrl + '/screen/crawlers/details/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1')
    And waitFor("//eui-tabs")
    Then def panel = locateAll("//ux-panel[@label='Filters']")
    And karate.sizeOf(panel) == 1

  Scenario: 2. As a user, I access create form and the ParserFilter forms are not present

    Given driver dashboardUrl + '/screen/crawlers/'
    And waitForUrl(dashboardUrl + '/screen/crawlers')
    When waitFor("//ux-button-group[@id='create_crawler']//button").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers/details')
    And waitFor("//eui-tabs")
    Then def panel = locateAll("//ux-panel[@label='Filters']")
    And karate.sizeOf(panel) == 0


  Scenario: 3 As a user, when an old crawler is copied, the new one does not contain legacy ParserFilters

    When waitForUrl(dashboardUrl + '/screen/crawlers')
    And waitForResultCount(".eui-table__loading", 0)
    And waitForEnabled("//span[contains(@class, 'eui-icon eui-icon-caret-last')]").click()
    And karate.call('classpath:ui-tests/eui-table/eui-table-find-backwards.feature', {rowText: crawlerToCheck})
    And def text = text("//div[contains(@class, 'eui-table-paginator__page-range')]")
    And def expectedTotalItems = getExpectedTotalItems(text)
    Then def rows = locateAll('//tr', filter)
    And def row = rows[0]
    And def editButton = row.locate("//span[contains(@iconClass, 'eui-icon-create')]/parent::*/parent::button")
    And editButton.click()
    And waitFor("//eui-tabs")
    Then def parserFiltersPanel = locateAll("//ux-panel[@label='Filters']")
    And match karate.sizeOf(parserFiltersPanel) == 0

