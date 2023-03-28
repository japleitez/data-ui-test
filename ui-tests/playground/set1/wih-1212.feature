Feature: As a user, I can view the dashboard for the selected URL Filter

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def testFilterId = 'eu.europa.ec.eurostat.wihp.urlfilters.examples.TestUrlFilter'

  Scenario: 1.Open Filter URL dashboard
    When driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    Then exists("//eui-page-content[@id='button_url_test_" + testFilterId + "']")
    Then waitFor("//*[@id=" + "'button_url_test_" + testFilterId + "']").click()
    And waitForText('.eui-common-header__sub-label-text', "id: " + testFilterId)
    And waitForResultCount("#filter-help", 1)
    And karate.sizeOf(retry().locateAll("#filter-param-help")) > 0

  Scenario: 2. back to table by cancel from Filter URL dashboard
    When driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    Then exists("//eui-page-content[@id='button_url_test_" + testFilterId + "']")
    Then waitFor("//*[@id=" + "'button_url_test_" + testFilterId + "']").click()
    And waitUntil('#cancel_btn', '_.getAttribute("aria-disabled") ==="false"')
    Then waitFor("//button[@id='cancel_btn']").click()
    And waitForText('.eui-common-header__label-text', 'Playground Filters')


  Scenario: 3. fill form Filter URL dashboard
    When driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    Then exists("//eui-page-content[@id='button_url_test_" + testFilterId + "']")
    Then waitFor("//*[@id=" + "'button_url_test_" + testFilterId + "']").click()
    And waitForText('.eui-common-header__sub-label-text', "id: " + testFilterId)
    Then input("//*[@id='id_character_" + testFilterId + "__']", "s")
    Then input("//*[@id='id_minReoccurrence_" + testFilterId + "__']", "3")
    Then input("//*[@id='id_maxReoccurrence_" + testFilterId + "__']", "33")
    Then input("//*[@id='id_minPercentage_" + testFilterId + "__']", "2.71")
    Then input("//*[@id='id_maxPercentage_" + testFilterId + "__']", "3.14")
    Then input("#urls_to_test_id", 'invalidUrl\r\n   http://test.com')
    And waitUntil('#play_btn', '_.getAttribute("aria-disabled") ==="false"')
    And waitFor("//button[@id='play_btn']").click()
    Then waitUntil('#error_filter_validation_list', '_.getAttribute("aria-disabled") ==="false"')
    Then match text("//*[@id='error_filter_validation_list']/eui-card-header/div[1]/div/eui-card-header-title/eui-badge") contains '2'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[1]/td[1]") contains 'invalidUrl'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[1]/td[2]") contains 'INVALID'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[2]/td[1]") contains 'http://test.com'
    Then match text("//*[@id='error_filter_validation_list']/eui-card-content/div/table/tbody/tr[2]/td[2]") contains 'FAIL'

  Scenario: 4. form with invalid values can not be sent
    When driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    Then exists("//eui-page-content[@id='button_url_test_" + testFilterId + "']")
    Then waitFor("//*[@id=" + "'button_url_test_" + testFilterId + "']").click()
    And waitForText('.eui-common-header__sub-label-text', "id: " + testFilterId)
    Then input("//*[@id='id_character_" + testFilterId + "__']", "sss")
    Then input("//*[@id='id_minReoccurrence_" + testFilterId + "__']", "3")
    Then input("//*[@id='id_maxReoccurrence_" + testFilterId + "__']", "33")
    Then input("//*[@id='id_minPercentage_" + testFilterId + "__']", "2.71")
    Then input("//*[@id='id_maxPercentage_" + testFilterId + "__']", "3.14")
    Then input("#urls_to_test_id", 'invalidUrl\r\n   http://test.com')
    Then waitUntil('#play_btn', '_.getAttribute("aria-disabled") ==="true"')

  Scenario: 5. empty form can not be sent
    When driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    Then exists("//eui-page-content[@id='button_url_test_" + testFilterId + "']")
    Then waitFor("//*[@id=" + "'button_url_test_" + testFilterId + "']").click()
    And waitForText('.eui-common-header__sub-label-text', "id: " + testFilterId)
    Then waitUntil('#play_btn', '_.getAttribute("aria-disabled") ==="true"')

  Scenario: 6. form with corrected invalid values can be sent
    When driver dashboardUrl  + '/screen/playground/'
    And waitForUrl(dashboardUrl  + '/screen/playground')
    Then exists("//eui-page-content[@id='button_url_test_" + testFilterId + "']")
    Then waitFor("//*[@id=" + "'button_url_test_" + testFilterId + "']").click()
    And waitForText('.eui-common-header__sub-label-text', "id: " + testFilterId)
    Then input("//*[@id='id_character_" + testFilterId + "__']", "sss")
    Then input("//*[@id='id_minReoccurrence_" + testFilterId + "__']", "3")
    Then input("//*[@id='id_maxReoccurrence_" + testFilterId + "__']", "33")
    Then input("//*[@id='id_minPercentage_" + testFilterId + "__']", "2.71")
    Then input("//*[@id='id_maxPercentage_" + testFilterId + "__']", "3.14")
    Then input("#urls_to_test_id", 'invalidUrl\r\n   http://test.com')
    Then waitUntil('#play_btn', '_.getAttribute("aria-disabled") ==="true"')
    Then value("//*[@id='id_character_" + testFilterId + "__']", "")
    Then input("//*[@id='id_character_" + testFilterId + "__']", "a")
    Then waitUntil('#play_btn', '_.getAttribute("aria-disabled") ==="false"')
