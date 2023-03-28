Feature: As a user, I can copy a crawler

  Background:
    * def getRandomCrawler =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string crawler = getRandomCrawler()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1.Access copy form

    Given driver dashboardUrl + '/screen/crawlers/'
    And waitForUrl(dashboardUrl + '/screen/crawlers/')
    When waitFor('#copy_button_1').click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers/copy/1')
    And match value('#crawler_name') contains '_copy'

  Scenario: 2.Copy crawler

    Given driver dashboardUrl + '/screen/crawlers/copy/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/copy/1')
    When value('#crawler_name', crawler)
    Then waitUntil('#copy_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='copy_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers')

  Scenario: 3.Copy crawler using an existing name

    Given driver dashboardUrl + '/screen/crawlers/copy/2'
    And waitForUrl(dashboardUrl + '/screen/crawlers/copy/2')
    When value('#crawler_name', 'crawler1')
    Then waitUntil('#copy_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='copy_btn']").click()
    # ux-growl contains the error
    Then waitFor("//div[contains(@class, 'eui-growl-item-container--danger')]")

  Scenario: 4.Invalid form

    Given driver dashboardUrl + '/screen/crawlers/copy/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/copy/1')
    When input('#crawler_name', 'crawler$')
    Then focus("//button[@id='copy_btn']")
    # check field is marked as invalid and feedback is displayed
    And waitUntil('#crawler_name', '_.getAttribute("aria-invalid") ==="true"')
    And exists('ux-control-feedback')


  Scenario: 6.space is not allowed in the Crawler name

    Given driver dashboardUrl + '/screen/crawlers/copy/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/copy/1')
    When input('#crawler_name', 'abc def')
    Then focus("//button[@id='copy_btn']")
    And waitUntil('#crawler_name', '_.getAttribute("aria-invalid") ==="true"')
    And exists('ux-control-feedback')


  Scenario: 7.dot is not allowed in the Crawler name

    Given driver dashboardUrl + '/screen/crawlers/copy/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/copy/1')
    When input('#crawler_name', 'abc.def')
    Then focus("//button[@id='copy_btn']")
    And waitUntil('#crawler_name', '_.getAttribute("aria-invalid") ==="true"')
    And exists('ux-control-feedback')


  Scenario: 8.dash is allowed in the Crawler name

    Given driver dashboardUrl + '/screen/crawlers/copy/2'
    And waitForUrl(dashboardUrl + '/screen/crawlers/copy/2')
    When value('#crawler_name', 'crawler-1')
    Then waitUntil('#copy_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='copy_btn']").click()
    Then waitFor("//div[contains(@class, 'eui-growl-item-container--danger')]")

