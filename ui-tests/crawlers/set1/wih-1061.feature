Feature: As a user, I can set selenium options

  Background:
    * def getRandomCrawler =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string crawler = getRandomCrawler()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1.Selenium option form

    Given driver dashboardUrl + '/screen/crawlers/details/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1')
    And if(waitFor("#dynamic").script("!_.checked")) waitFor("#dynamic").click()
    Then waitFor("//ux-panel[contains(@label, 'Dynamic Configuration')]")
    And exists("#language")
    And exists("#maximized")
    And exists("#window_size")
    And exists("#load_image_allow")
    And exists("#load_image_block")
    And exists("#allow_cookies_allow")
    And exists("#allow_cookies_block")
    And exists("#allow_geolocation_allow")
    And exists("#allow_geolocation_block")
    And exists("#chrome_options_list")

  Scenario: 2.Create crawler with selenium options
    Given driver dashboardUrl + '/screen/crawlers/details'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details')
    When input('#crawler_name', crawler)
    And waitFor("#dynamic").click()
    And waitFor("//ux-panel[contains(@label, 'Dynamic Configuration')]")
    And value("#language", "gr")
    And click("#maximized")
    And value("#window_size", "800,600")
    And click("#load_image_block")
    And click("#allow_cookies_allow")
    And click("#allow_geolocation_allow")
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers')
    And waitForResultCount("//input[@id='fetch_interval']", 0)

  Scenario: 3.Update crawler with selenium options
    Given driver dashboardUrl + '/screen/crawlers/details/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1')
    And if(waitFor("#dynamic").script("!_.checked")) waitFor("#dynamic").click()
    And waitFor("//ux-panel[contains(@label, 'Dynamic Configuration')]")
    And value("#language", "gr")
    And click("#maximized")
    And value("#window_size", "800,600")
    And click("#load_image_block")
    And click("#allow_cookies_allow")
    And click("#allow_geolocation_allow")
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers')
    And waitForResultCount("//input[@id='fetch_interval']", 0)

  Scenario: 4.Create crawler with invalid selenium options
    Given driver dashboardUrl + '/screen/crawlers/details'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details')
    When input('#crawler_name', crawler)
    And waitFor("#dynamic").click()
    And waitFor("//ux-panel[contains(@label, 'Dynamic Configuration')]")
    And input("#language", "$#%")
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')

  Scenario: 5.Update crawler with invalid selenium options
    Given driver dashboardUrl + '/screen/crawlers/details/1'
    And waitForUrl(dashboardUrl + '/screen/crawlers/details/1')
    And if(waitFor("#dynamic").script("!_.checked")) waitFor("#dynamic").click()
    And waitFor("//*[contains(@label, 'Dynamic Configuration')]")
    And clear("#language")
    And input("#language", "$#%")
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')
