Feature: As a user I can use custom BasicNavigationFilter

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def navigationFilterId = 'eu.europa.ec.eurostat.wihp.navigationfilters.stormcrawler.BasicNavigationFilter'
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

  Scenario: 1. As a user I can post BasicNavigationFilter in playground
    When driver dashboardUrl  + '/screen/playground/details/navigationFilter/' + navigationFilterId
    And waitForUrl(dashboardUrl  + '/screen/playground/details/navigationFilter/' + navigationFilterId)
    And waitForText('.eui-common-header__sub-label-text', "id: " + navigationFilterId)
    And waitForEnabled("//*[@id='metadata_card_header']")
    And waitFor('#id_action_action_0')
    Then input('#id_action_action_0', 'click')
    And waitFor('#url_to_test_id')
    Then input('#url_to_test_id', 'https://www.arhs-group.com/')
    Then waitUntil('#play_btn', '_.getAttribute("aria-disabled") ==="false"')
    And waitFor("//button[@id='play_btn']").click()
    Then waitUntil('#error_filter_validation_list', '_.getAttribute("aria-disabled") ==="false"')
    Then match text("//*[@id='error_filter_validation_list']/eui-card-header/div[1]/div/eui-card-header-title") contains 'Navigation Filter test report has'
    # Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/thead/tr[1]/td[1]") contains 'Action'
    # Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/thead/tr[1]/td[2]") contains 'Xpath'
