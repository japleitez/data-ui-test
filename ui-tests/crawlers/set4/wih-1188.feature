Feature: As a user, I can modify sources for crawler

  Background:
    * def getRandomCrawler =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string crawler = getRandomCrawler()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')


  Scenario: 1.Source Configuration Exists

    Given driver dashboardUrl + '/screen/crawlers/details/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1')
    And waitForResultCount(".eui-table__loading", 0)
    And exists("#configure_sources")


  Scenario: 2.Sources for Crawler Exists

    Given driver dashboardUrl + '/screen/crawlers/details/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1')
    And waitForResultCount(".eui-table__loading", 0)
    Then waitFor("//button[@id='configure_sources']").click()
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1/sources')
    And waitForResultCount(".eui-table__loading", 0)


  Scenario: 3.Add Source to Crawler

    Given driver dashboardUrl + '/screen/crawlers/details/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1')
    And waitForResultCount(".eui-table__loading", 0)
    Then waitFor("//button[@id='configure_sources']").click()
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1/sources')
    And waitForResultCount(".eui-table__loading", 0)
    And waitFor("//table[@id='sources_all_selection']/tbody/tr[1]/td[5]/button").click()
    And waitForText(".eui-growl-item-message-title", "SUCCESS")


  Scenario: 4.Remove Source from Crawler

    Given driver dashboardUrl + '/screen/crawlers/details/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1')
    And waitForResultCount(".eui-table__loading", 0)
    Then waitFor("//button[@id='configure_sources']").click()
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1/sources')
    And waitForResultCount(".eui-table__loading", 0)
    And waitFor("//table[@id='sources_all_selection']/tbody/tr[1]/td[5]/button").click()
    And waitForText(".eui-growl-item-message-title", "SUCCESS")
    And waitFor("//table[@id='sources_crawler']/tbody/tr[1]/td[4]/button").click()
    And waitFor("//*[@id='remove-source-confirm']/div/div/div[1]/div")
    Then match locate("//*[@id='remove-source-confirm']/div/div/div[1]/div").text == 'Confirm remove source'


  Scenario: 5.Source Configuration form Crawler list

    Given driver dashboardUrl + '/screen/crawlers'
    And waitForUrl(dashboardUrl + '/screen/crawlers')
    And waitForResultCount(".eui-table__loading", 0)
    And waitFor("//*[@id='edit_sources_button_1']").click()
    And waitFor('.eui-common-header__sub-label-text')
    Then match locate(".eui-common-header__label-text").text contains 'Sources for Crawler'
