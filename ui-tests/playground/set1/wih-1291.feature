Feature: As a user I can use HostURLFilter

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def hostUrlFilterId = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'

  Scenario: 1. fill HostURLFilter form
    When driver dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId
    And waitForUrl(dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId)
    And waitForText('.eui-common-header__sub-label-text', "id: " + hostUrlFilterId)
    Then waitFor("//*[@id='id_ignoreOutsideHost_" + hostUrlFilterId + "__']").click()
    Then waitFor("//*[@id='id_ignoreOutsideDomain_" + hostUrlFilterId + "__']").click()
    Then input("#urls_to_test_id", 'https://www.somedoman.com\r\n   https://www.anotherdomain.com')
    And waitUntil('#play_btn', '_.getAttribute("aria-disabled") ==="false"')
    And waitFor("//button[@id='play_btn']").click()
    And waitForUrl(dashboardUrl  + '/screen/playground/details/')
