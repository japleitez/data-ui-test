Feature: As a user, I have access to import crawler page

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: Access to Import Source page
    Given driver dashboardUrl + '/screen/crawlers/'
    And waitForUrl(dashboardUrl + '/screen/crawlers/')
    When waitFor("//ux-button-group[@id='import_file']//button").click()
    Then waitForUrl(dashboardUrl + '/screen/crawlers/import')
    And waitForText('.file-msg', 'Drag and drop file here')
