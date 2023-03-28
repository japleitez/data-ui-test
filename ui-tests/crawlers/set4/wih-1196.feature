Feature: As a user, I can access help page of crawler form

  Background:
    * def getRandomCrawler =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string crawler = getRandomCrawler()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 2. Access Crawler form and open help dialog

    Given driver dashboardUrl + '/screen/crawlers/details'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details')
    When input('#crawler_name', crawler)
    When waitFor("//button[@id='open_help']").click()
    Then waitForEnabled("//button[contains(@class, 'eui-dialog__footer-dismiss-button eui-button ng-star-inserted')]")
