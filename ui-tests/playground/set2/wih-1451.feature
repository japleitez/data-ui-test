Feature: As a user I can use custom XPath Filter

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def xPathFilterId = 'eu.europa.ec.eurostat.wihp.parsefilters.stormcrawler.xpathfilter.XPathFilter'
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

  Scenario: 1. As a user I can post XPathFilter in playground
    When driver dashboardUrl  + '/screen/playground/details/parseFilter/' + xPathFilterId
    And waitForUrl(dashboardUrl  + '/screen/playground/details/parseFilter/' + xPathFilterId)
    And waitForText('.eui-common-header__sub-label-text', "id: " + xPathFilterId)
    And waitForEnabled("//*[@id='metadata_card_header']")
    And waitFor('#id_property_property_0')
    Then input('#id_property_property_0', 'parse.title')
    And waitFor('#id_expressions_0_id_0_expressions')
    Then input('#id_expressions_0_id_0_expressions', '//TITLE')
    And waitForEnabled("//button[@id='add_item_patterns']")
    Then waitFor("//button[@id='add_item_patterns']").click()
    And waitFor('#id_property_property_1')
    Then input('#id_property_property_1', 'parse.description')
    And waitFor('#id_expressions_0_id_1_expressions')
    Then input('#id_expressions_0_id_1_expressions', '//*[@name="description"]/@content')
    And waitFor('#url_to_test_id')
    Then input('#url_to_test_id', 'https://www.arhs-group.com/')
    And waitUntil('#play_btn', '_.getAttribute("aria-disabled") ==="false"')
    And waitFor("//button[@id='play_btn']").click()
    Then waitUntil('#error_filter_validation_list', '_.getAttribute("aria-disabled") ==="false"')
    Then match text("//*[@id='error_filter_validation_list']/eui-card-header/div[1]/div/eui-card-header-title/eui-badge") contains '2'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[1]/td[1]") contains 'parse.title'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[2]/td[1]") contains 'parse.description'

  Scenario: 1. As a user I can add XPathFilter to a crawler
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
    Then waitForEnabled("//ux-panel/div[2]/div/div[2]/div/div/form/eui-tabs/div/div[1]/div[1]/div[2]")
    Then waitFor("//ux-panel/div[2]/div/div[2]/div/div/form/eui-tabs/div/div[1]/div[1]/div[2]").click()
    Then waitForEnabled("//button[@id='btn_add_parsefilter_" + xPathFilterId + "']")
    Then waitFor("//button[@id='btn_add_parsefilter_" + xPathFilterId + "']").click()
    And waitFor('#id_property_property_0')
    Then input('#id_property_property_0', 'parse.title')
    And waitFor('#id_expressions_0_id_0_expressions')
    Then input('#id_expressions_0_id_0_expressions', '//TITLE')
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers')
