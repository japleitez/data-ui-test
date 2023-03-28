Feature: As a user, I can edit the sources

  Background:
    * def getRandomSource =
    """
    function(){ return java.time.Instant.now().toEpochMilli() + '' }
    """
    * string source = getRandomSource()
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1.Access edit form

    Given driver dashboardUrl + '/screen/sources/'
    And waitForUrl(dashboardUrl + '/screen/sources/')
    And waitForResultCount(".eui-table__loading", 0)
    When waitFor('#edit_button_4').click()
    Then waitForUrl(dashboardUrl + '/screen/sources/details')
    And match value('#source_name') == 'source4'

  Scenario: 2.Edit source

    Given driver dashboardUrl + '/screen/sources/details/5'
    And waitForUrl(dashboardUrl + '/screen/sources/details/5')
    And waitFor('#source_name')
    When clear('#source_name')
    And input('#source_name', source)
    And clear('#source_url')
    And input('#source_url', 'http://www.' + source + '.com')
    And waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='save_btn']").click()
    Then waitForUrl(dashboardUrl + '/screen/sources')

  Scenario: 3.Invalid form

    Given driver dashboardUrl + '/screen/sources/details/5'
    And waitForUrl(dashboardUrl + '/screen/sources/details/5')
    When clear('#source_name')
    And input('#source_name', 'source$')
    Then waitUntil('#save_btn', '_.getAttribute("aria-disabled") ==="true"')
    And focus('#source_url')
    And waitUntil('#source_name', '_.getAttribute("aria-invalid") ==="true"')
    And exists('ux-control-feedback')

