Feature: As a user I can start an acquisition from crawler table

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1. access acquisition details when start acquisition from crawler list

    Given driver dashboardUrl + '/screen/crawlers/'
    And waitForUrl(dashboardUrl + '/screen/crawlers/')
    And waitForResultCount(".eui-table__loading", 0)
    When waitFor('#start_button_13').click()
    Then waitForUrl(dashboardUrl + '/screen/acquisitions/details?crawlerName=crawler13')
    And match value('#acquisition_name') == 'crawler13'
