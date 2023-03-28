Feature: As a user, I can view the playground

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')

  Scenario: 1.View playground table

    When driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    Then exists("//ux-panel[@label='URL Filters list']")
    And match text("//eui-table-paginator//span[@euilabel]") == '25'
    And match enabled("//span[contains(@class, 'eui-icon eui-icon-caret-left')]/parent::*/parent::button") == false

  @ignore
  Scenario: 2.Last page
    Given driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    And waitForResultCount(".eui-table__loading", 0)
    When waitFor("//span[contains(@class, 'eui-icon-caret-last')]/parent::*/parent::button").click()
    Then match retry().enabled("//span[contains(@class, 'eui-icon-caret-right')]/parent::*/parent::button") == false
    And match retry().enabled("//span[contains(@class, 'eui-icon-caret-left')]/parent::*/parent::button") == true

  @ignore
  Scenario: 3.Page size change
    Given driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    And waitForResultCount(".eui-table__loading", 0)
    When waitFor("//eui-table-paginator//button").click()
    And karate.sizeOf(retry().locateAll("//tbody/tr[contains(@class,'ng-star-inserted')]")) <= 25
    And waitFor("//eui-table-paginator/div[2]/div[1]/eui-dropdown/div/button").click()
    And waitFor("//div[contains(@class, 'eui-list-item__container') and text() = '100']").click()
    Then match retry().text("//div[contains(@class, 'eui-table-paginator__page-range')]") !contains 'Showing 25'
    And karate.sizeOf(retry().locateAll("//tbody/tr[contains(@class,'ng-star-inserted')]")) <= 100

  @ignore
  Scenario: 4.Access URL Test details (dummy page)
    Given driver dashboardUrl + '/screen/playground/details/DummyId'
    And waitForUrl(dashboardUrl + '/screen/playground/details/DummyId')
    And retry().waitForText("//eui-page-content", "DummyId")
