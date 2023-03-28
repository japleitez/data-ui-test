Feature: Data Collection Dashboard

  Background:
    * def environment = karate.env
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: As a user I can access the environment
    When driver dashboardUrl
    And waitForUrl(dashboardUrl)
    Then match karate.lowerCase(text('//eui-toolbar-environment')) contains environment
