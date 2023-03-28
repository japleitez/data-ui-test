Feature: As a user, I have access to import source page

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: Access to Import Source page
    Given driver dashboardUrl + '/screen/sources/'
    And waitForUrl(dashboardUrl + '/screen/sources/')
    And waitForResultCount(".eui-table__loading", 0)
    When waitFor("//ux-button-group[@id='import_file']//button").click()
    Then waitForUrl(dashboardUrl + '/screen/sources/import')
    And waitForText('.file-msg', 'Drag and drop file here')
