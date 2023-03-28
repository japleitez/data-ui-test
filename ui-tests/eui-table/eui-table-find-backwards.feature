Feature: As a user, I can load eui table

  @ignore
  Scenario: Eui table load
    * print rowText
    * waitForResultCount(".eui-table__loading", 0)
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }
    * sleep(1500)
    * def rowTextDoesNotExist = retry().script("body", "function(e){return document.body.innerHTML.search('" + rowText + "')}") == -1
    * print rowTextDoesNotExist
    * def leftButtonEnabled = enabled("//span[contains(@class, 'eui-icon eui-icon-caret-left')]/parent::*/parent::button") == true
    * print leftButtonEnabled
    * if(rowTextDoesNotExist && leftButtonEnabled) waitForEnabled("//span[contains(@class, 'eui-icon eui-icon-caret-left')]/parent::*/parent::button").click()
    * if(rowTextDoesNotExist && leftButtonEnabled) karate.call(true, 'classpath:ui-tests/eui-table/eui-table-find-backwards.feature')
