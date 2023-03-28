Feature: As a user, I can view the sources

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1.View sources table

    When driver dashboardUrl + '/screen/sources/'
    And waitForUrl(dashboardUrl + '/screen/sources')
    Then exists("//ux-panel[@label='Sources list']")
    And waitForResultCount(".eui-table__loading", 0)
    And match text("//eui-table-paginator//span[@euilabel]") == '25'
    And match enabled("//span[contains(@class, 'eui-icon eui-icon-caret-right')]/parent::*/parent::button") == true
    And match enabled("//span[contains(@class, 'eui-icon eui-icon-caret-left')]/parent::*/parent::button") == false

  Scenario: 2.Last page
    Given driver dashboardUrl + '/screen/sources/'
    And waitForUrl(dashboardUrl + '/screen/sources')
    When waitForResultCount(".eui-table__loading", 0)
    And waitForEnabled("//span[contains(@class, 'eui-icon eui-icon-caret-last')]/parent::*/parent::button")
    And click("//span[contains(@class, 'eui-icon eui-icon-caret-last')]")
    And waitUntil("//span[contains(@class, 'eui-icon eui-icon-caret-last')]/parent::*/parent::button", "_.disabled")
    And waitForEnabled("//span[contains(@class, 'eui-icon eui-icon-caret-first')]/parent::*/parent::button")

  Scenario: 3.Page size change
    Given driver dashboardUrl + '/screen/sources/'
    And waitForUrl(dashboardUrl + '/screen/sources')
    And waitForResultCount(".eui-table__loading", 0)
    When waitFor("//eui-table-paginator//button").click()
    And karate.sizeOf(retry().locateAll("//tbody/tr[contains(@class,'ng-star-inserted')]")) <= 25
    And waitFor("//eui-table-paginator/div[2]/div[1]/eui-dropdown/div/button").click()
    And waitFor("//div[contains(@class, 'eui-list-item__container') and text() = '100']").click()
    Then match retry().text("//div[contains(@class, 'eui-table-paginator__page-range')]") !contains 'Showing 25'
    And karate.sizeOf(retry().locateAll("//tbody/tr[contains(@class,'ng-star-inserted')]")) >= 25
    And karate.sizeOf(retry().locateAll("//tbody/tr[contains(@class,'ng-star-inserted')]")) <= 100

