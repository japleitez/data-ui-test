Feature: As a user, I can create a new source

  Background:
    * def getRandomSource =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string source = getRandomSource()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1.Access create form

    Given driver dashboardUrl + '/screen/sources/'
    And waitForUrl(dashboardUrl + '/screen/sources/')
    And waitForResultCount(".eui-table__loading", 0)
    When waitFor("//ux-button-group[@id='create_source']//button").click()
    Then waitForUrl(dashboardUrl + '/screen/sources/details')

  Scenario: 2.Create source

    Given driver dashboardUrl + '/screen/sources/details'
    And waitForUrl(dashboardUrl + '/screen/sources/details')
    When input('#source_name', source)
    And input('#source_url', 'http://www.' + source + '.com')
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/sources')

  Scenario: 3.Invalid form

    Given driver dashboardUrl + '/screen/sources/details'
    And waitForUrl(dashboardUrl + '/screen/sources/details')
    When input('#source_name', 'source$')
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')

