Feature: As a user, I can modify a crawler

  Background:
    * def getRandomSource =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string crawler = getRandomSource()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')


  Scenario: 1.Access edit form with sources loaded (at least one)

    Given driver dashboardUrl + '/screen/crawlers/'
    And waitForUrl(dashboardUrl + '/screen/crawlers/')
    When waitFor('#edit_button_4').click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers/details')
    And waitUntil('#crawler_name', '_.getAttribute("aria-invalid") ==="false"')
    And match value('#crawler_name') == 'crawler4'
    And waitUntil('#configure_sources', '_.getAttribute("aria-disabled") ==="false"')
    And karate.sizeOf(retry().locateAll("//table[@id='sources_table']//tbody/tr[contains(@class,'ng-star-inserted')]")) > 0

  Scenario: 2.Edit crawler

    Given driver dashboardUrl + '/screen/crawlers/details/5'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/5')
    When clear('#crawler_name')
    And input('#crawler_name', crawler)
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers')

  Scenario: 3.Invalid form

    Given driver dashboardUrl + '/screen/crawlers/details/5'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/5')
    When clear('#crawler_name')
    And input('#crawler_name', 'crawler$')
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')
    And focus('#fetch_interval')
    # check field is marked as invalid and feedback is displayed
    And waitUntil('#crawler_name', '_.getAttribute("aria-invalid") ==="true"')
    And exists('ux-control-feedback')


  Scenario: 4.Space symbol is not allowed in the Crawler name

    Given driver dashboardUrl + '/screen/crawlers/details/5'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/5')
    When clear('#crawler_name')
    And input('#crawler_name', 'craw ler')
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')
    And focus('#fetch_interval')
    And waitUntil('#crawler_name', '_.getAttribute("aria-invalid") ==="true"')
    And exists('ux-control-feedback')


  Scenario: 5.Dot symbol is not allowed in the Crawler name

    Given driver dashboardUrl + '/screen/crawlers/details/5'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/5')
    When clear('#crawler_name')
    And input('#crawler_name', 'craw.ler')
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')
    And focus('#fetch_interval')
    And waitUntil('#crawler_name', '_.getAttribute("aria-invalid") ==="true"')
    And exists('ux-control-feedback')


  Scenario: 6.Dash symbol is allowed in the Crawler name

    Given driver dashboardUrl + '/screen/crawlers/details/5'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/5')
    When clear('#crawler_name')
    And input('#crawler_name', 'craw-ler-1')
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers')
