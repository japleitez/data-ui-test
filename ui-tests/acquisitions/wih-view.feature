Feature: As a user, I can view the acquisitions
  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1.View acquisitions list

    When driver dashboardUrl + '/screen/acquisitions/'
    And waitForUrl(dashboardUrl + '/screen/acquisitions/')
    And waitForResultCount(".eui-table__loading", 0)
    Then exists("//ux-panel[@label='Acquisitions list']")
    And match text("//eui-table-paginator//span[@euilabel]") == '25'
    And match enabled("//span[contains(@class, 'eui-icon eui-icon-caret-right')]/parent::*/parent::button") == true
    And match enabled("//span[contains(@class, 'eui-icon eui-icon-caret-left')]/parent::*/parent::button") == false

  Scenario: 2.Last page
    Given driver dashboardUrl + '/screen/acquisitions/'
    And waitForUrl(dashboardUrl + '/screen/acquisitions/')
    And waitForResultCount(".eui-table__loading", 0)
    And waitForText("//div[contains(@class, 'eui-table-paginator__page-range')]", "Showing 1")
    And waitFor("//ux-a-label/div/ux-badge/span")
    When waitForEnabled("//eui-table-paginator//span[contains(@class, 'eui-icon eui-icon-caret-last')]").click()
    And waitForResultCount(".eui-table__loading", 0)
    And match retry().enabled("//span[contains(@class, 'eui-icon-caret-right')]/parent::*/parent::button") == false
    And match retry().enabled("//span[contains(@class, 'eui-icon-caret-left')]/parent::*/parent::button") == true

  Scenario: 3.Page size change
    Given driver dashboardUrl + '/screen/acquisitions/'
    And waitForUrl(dashboardUrl + '/screen/acquisitions/')
    And waitForResultCount(".eui-table__loading", 0)
    And waitForText("//div[contains(@class, 'eui-table-paginator__page-range')]", "Showing 1")
    When waitFor("//eui-table-paginator//button").click()
    And waitForResultCount(".eui-table__loading", 0)
    And karate.sizeOf(retry().locateAll("//tbody/tr[contains(@class,'ng-star-inserted')]")) <= 25
    And waitFor("//eui-table-paginator/div[2]/div[1]/eui-dropdown/div/button").click()
    And waitFor("//div[contains(@class, 'eui-list-item__container') and text() = '100']").click()
    Then match text("//div[contains(@class, 'eui-table-paginator__page-range')]") !contains 'Showing 25'
    And karate.sizeOf(retry().locateAll("//tbody/tr[contains(@class,'ng-star-inserted')]")) >= 25
    And karate.sizeOf(retry().locateAll("//tbody/tr[contains(@class,'ng-star-inserted')]")) <= 100
