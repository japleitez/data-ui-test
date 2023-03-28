@ignore
Feature: As a user, I can create a data acquisition

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1.Access create acquisition form

    When driver dashboardUrl + '/screen/acquisitions/'
    And waitForUrl(dashboardUrl + '/screen/acquisitions/')
    And waitForResultCount(".eui-table__loading", 0)
    When waitFor("//ux-button-group[@id='create_acquisition']//button").click()
    Then waitForUrl(dashboardUrl + '/screen/acquisitions/details')

  Scenario: 2.Create acquisition

    Given driver dashboardUrl + '/screen/acquisitions/details'
    And waitForUrl(dashboardUrl + '/screen/acquisitions/details')
    When input('#acquisition_name', 'crawler1')
    And input('#acquisition_uuid', '626b97e5-e588-4576-9aea-62b14078497f')
    Then match enabled("//button[@id='start_btn']") == true
    And waitUntil('#start_btn', '_.getAttribute("aria-disabled") ==="false"')
    When waitFor("//button[@id='start_btn']").click()

  Scenario: 3.Invalid acquisition form

    Given driver dashboardUrl + '/screen/acquisitions/details'
    And waitForUrl(dashboardUrl + '/screen/acquisitions/details')
    When input('#acquisition_name', 'crawler$')
    And waitUntil('#start_btn', '_.getAttribute("aria-disabled") ==="true"')
