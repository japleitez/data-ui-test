Feature: As a user, I can add NavigationFilters into crawler

  Background:
    * def getRandomSource =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string crawlerRandomName = getRandomSource()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def testFilterId = 'eu.europa.ec.eurostat.wihp.navigationfilters.stormcrawler.BasicNavigationFilter'
    * def navigationTabXpath = "//*/eui-tabs/div/div[1]/div[1]/div[3]"
    * def addFilterButtonXpath = "//*[@id='btn_add_navigationfilter_" + testFilterId + "']"
    * def removeFilterButtonXpath = "//*[@id='remove_navigationfilter_" + testFilterId + "']"

  Scenario: 1. I can View Navigation Filter Table in a Crawler when clicking on the tab
    Given driver dashboardUrl + '/screen/crawlers/details/'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/')
    And waitForResultCount(".eui-table__loading", 0)
    And scroll(navigationTabXpath).click()
    Then match text("//*[@id='navigation_filters_table']/thead/tr/th[1]") contains 'Navigation Filter Name'
    # And waitFor("//*[@id='btn_add_navigationfilter_" + testFilterId + "']").click()
    # Then match text("//*[@id='remove_navigationfilter_" + testFilterId + "']") contains 'Remove Filter'

  Scenario: 2. Filter can be saved with valid form, add/remove filter works irrespectively
    Given driver dashboardUrl + '/screen/crawlers/details/'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/')
    And waitForResultCount(".eui-table__loading", 0)
     # Input crawler name, save button should be enabled
    When clear('#crawler_name')
    And input('#crawler_name', crawlerRandomName)
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") === "false"')
    # When add filter is clicked button should be disabled
    # Remove filter button should appear and should be enabled
    When scroll(navigationTabXpath).click()
    And waitFor(addFilterButtonXpath).click()
    Then waitUntil(addFilterButtonXpath, '_.getAttribute("aria-disabled") === "true"')
    And focus(removeFilterButtonXpath)
    And match text(removeFilterButtonXpath) contains 'Remove Filter'
    And waitUntil(removeFilterButtonXpath, '_.getAttribute("aria-disabled") === "false"')
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") === "true"')
    # When form is valid, save button should be enabled
    When clear('#id_action_action_0')
    And input('#id_action_action_0', 'click')
    And focus("#id_xpath_xpath_0")
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") === "false"')
    # When form is invalid, save button should be disabled, remove filter should not
    When focus('#id_action_action_0')
    And clear('#id_action_action_0')
    And input('#id_action_action_0', 'invalid_content')
    And focus("#id_xpath_xpath_0")
    Then match text("//*/app-filter-element-form/form/fieldset/ux-form-group/div/div/div/div/ux-control-feedback/div/small") contains 'This field is required'
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") === "true"')
    And waitUntil(removeFilterButtonXpath, '_.getAttribute("aria-disabled") === "false"')
    # When remove filter is clicked then form is valid again can be saved and filter will be removed
    When waitFor(removeFilterButtonXpath).click()
    And focus('#crawler_name')
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") === "false"')
    And waitUntil(addFilterButtonXpath, '_.getAttribute("aria-disabled") === "false"')
    And if (exists('#id_action_action_0')) karate.fail('Filter not removed')