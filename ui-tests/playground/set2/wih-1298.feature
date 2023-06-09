Feature: As a user I can set metadata for filter testing

  Background:
    * if (keycloakEnabled) karate.call('classpath:ui-tests/authentication/keycloak-login.feature')
    * if (cognitoEnabled) karate.call('classpath:ui-tests/authentication/cognito-login.feature')
    * def hostUrlFilterId = 'eu.europa.ec.eurostat.wihp.urlfilters.stormcrawler.HostURLFilter'

  Scenario: 1. open Default Entry Set, and fill form
    When driver dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId
    And waitForUrl(dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId)
    And waitForText('.eui-common-header__sub-label-text', "id: " + hostUrlFilterId)
    And waitForEnabled("//*[@id='metadata_card_header']")
    Then waitFor("//*[@id='metadata_card_header']").click()
    And waitFor('#key_0')
    Then input('#key_0', 'greeting')
    And waitFor('#key_0_value_0')
    Then input('#key_0_value_0', 'hello')

  Scenario: 2. open Default Entry Set, add two values, and fill form
    When driver dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId
    And waitForUrl(dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId)
    And waitForText('.eui-common-header__sub-label-text', "id: " + hostUrlFilterId)
    And waitForEnabled("//*[@id='metadata_card_header']")
    Then waitFor("//*[@id='metadata_card_header']").click()
    And waitForEnabled("//*[@id='add_value_key_0']")
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitForEnabled("//*[@id='add_value_key_0']")
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0')
    Then input('#key_0', 'greeting')
    And waitFor('#key_0_value_0')
    Then input('#key_0_value_0', 'hello 0')
    And waitFor('#key_0_value_1')
    Then input('#key_0_value_1', 'hello 1')
    And waitFor('#key_0_value_2')
    Then input('#key_0_value_2', 'hello 2')
    And karate.sizeOf(retry().locateAll("//div[contains(@id,'metadata_entry_set_key_0')]//input[contains(@id, 'key_0_value_')]")) == 3

  Scenario: 3. open Default Entry Set, add four values, then remove first value, and fill form
    When driver dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId
    And waitForUrl(dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId)
    And waitForText('.eui-common-header__sub-label-text', "id: " + hostUrlFilterId)
    And waitForEnabled("//*[@id='metadata_card_header']")
    Then waitFor("//*[@id='metadata_card_header']").click()
    And waitForEnabled("//*[@id='add_value_key_0']")
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitForEnabled("//*[@id='add_value_key_0']")
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitForEnabled("//*[@id='add_value_key_0']")
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitForEnabled("//*[@id='add_value_key_0']")
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0')
    Then input('#key_0', 'greeting')
    And waitFor('#key_0_value_0')
    Then input('#key_0_value_0', 'hello 0')
    And waitFor('#key_0_value_1')
    Then input('#key_0_value_1', 'hello 1')
    And waitFor('#key_0_value_2')
    Then input('#key_0_value_2', 'hello 2')
    And waitFor('#key_0_value_3')
    Then input('#key_0_value_3', 'hello 3')
    And waitFor('#key_0_value_4')
    Then input('#key_0_value_4', 'hello 4')
    And waitForEnabled("//*[@id='remove_key_0_value_0']")
    Then waitFor("//*[@id='remove_key_0_value_0']").click()
    And karate.sizeOf(retry().locateAll("//div[contains(@id,'metadata_entry_set_key_0')]//input[contains(@id, 'key_0_value_')]")) == 4

  Scenario: 4. add Metadata Entry Set, add 1 value to each Entry Set and fill form
    When driver dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId
    And waitForUrl(dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId)
    And waitForText('.eui-common-header__sub-label-text', "id: " + hostUrlFilterId)
    And waitForEnabled("//*[@id='metadata_card_header']")
    Then waitFor("//*[@id='metadata_card_header']").click()
    And waitForEnabled("//*[@id='add_value_key_0']")
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0')
    Then input('#key_0', 'greeting')
    And waitFor('#key_0_value_0')
    Then input('#key_0_value_0', 'hello 0')
    And waitFor('#key_0_value_1')
    Then input('#key_0_value_1', 'hello 1')
    And waitForEnabled("//*[@id='add_metadata_entry_set']")
    Then waitFor("//*[@id='add_metadata_entry_set']").click()
    And waitForEnabled("//*[@id='add_value_key_1']")
    Then waitFor("//*[@id='add_value_key_1']").click()
    And waitFor('#key_1')
    Then input('#key_1', 'colors')
    And waitFor('#key_1_value_0')
    Then input('#key_1_value_0', 'blue')
    And waitFor('#key_1_value_1')
    Then input('#key_1_value_1', 'green')
    And karate.sizeOf(retry().locateAll("//div[contains(@id,'metadata_entry_set_key_0')]//input[contains(@id, 'key_0_value_')]")) == 2
    And karate.sizeOf(retry().locateAll("//div[contains(@id,'metadata_entry_set_key_1')]//input[contains(@id, 'key_1_value_')]")) == 2

  Scenario: 5. cannot add more than 20 values
    When driver dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId
    And waitForUrl(dashboardUrl  + '/screen/playground/details/urlFilter/' + hostUrlFilterId)
    And waitForText('.eui-common-header__sub-label-text', "id: " + hostUrlFilterId)
    And waitForEnabled("//*[@id='metadata_card_header']")
    Then waitFor("//*[@id='metadata_card_header']").click()
    And waitFor('#key_0_value_0')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_1')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_2')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_3')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_4')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_5')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_6')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_7')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_8')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_9')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_10')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_11')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_12')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_13')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_14')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_15')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_16')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_17')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_18')
    Then waitFor("//*[@id='add_value_key_0']").click()
    And waitFor('#key_0_value_19')
    Then waitFor("//*[@id='add_value_key_0']").click()
    Then waitFor("//*[@id='add_value_key_0']").click()
    Then waitFor("//*[@id='add_value_key_0']").click()
    Then waitFor("//*[@id='add_value_key_0']").click()
    And karate.sizeOf(retry().locateAll("//div[contains(@id,'metadata_entry_set_key_0')]//input[contains(@id, 'key_0_value_')]")) == 20
