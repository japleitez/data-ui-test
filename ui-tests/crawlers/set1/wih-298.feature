Feature: As a user, I can create a crawler

  Background:
    * def getRandomCrawler =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string crawler = getRandomCrawler()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1.Access create form

    Given driver dashboardUrl + '/screen/crawlers/'
    And waitForUrl(dashboardUrl + '/screen/crawlers')
    When waitFor("//ux-button-group[@id='create_crawler']//button").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers/details')

  Scenario: 2.Create crawler

    Given driver dashboardUrl + '/screen/crawlers/details'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details')
    When input('#crawler_name', crawler)
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers')
    And waitForResultCount("//input[@id='fetch_interval']", 0)

  Scenario: 3.Invalid form

    Given driver dashboardUrl + '/screen/crawlers/details'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details')
    When input('#crawler_name', crawler)
    Then waitForEnabled("//button[@id='save_btn']")
    And clear('#crawler_name')
    When input('#crawler_name', 'invalid$')
    And focus('#fetch_interval')
    # check field is marked as invalid and feedback is displayed
    And waitUntil('#crawler_name', '_.getAttribute("aria-invalid") ==="true"')
    And exists('ux-control-feedback')
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')
