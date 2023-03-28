Feature: As a user, I can stop a data acquisition

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1. View possible actions
    When driver dashboardUrl + '/screen/acquisitions/'
    And waitForUrl(dashboardUrl + '/screen/acquisitions/')
    And waitForResultCount(".eui-table__loading", 0)
    Then exists("//ux-panel[@label='Acquisitions list']")
    And exists("//button[@id='btn_stop_1']")
    And exists("//button[@id='btn_stop_2']")
    And exists("//button[@id='btn_pause_3']")
    And exists("//button[@id='btn_stop_3']")
    And exists("//button[@id='btn_start_4']")
    And exists("//button[@id='btn_stop_4']")
    And exists("//span[@id='spn_no_action_5']")
    And exists("//span[@id='spn_no_action_6']")
    And exists("//span[@id='spn_no_action_7']")
