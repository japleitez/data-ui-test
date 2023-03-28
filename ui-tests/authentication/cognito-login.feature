Feature: As a user, I can login with Cognito

  @ignore
  Scenario: Cognito login

    * driver dashboardUrl + '/screen/sources/'
    * def cognitoButton = waitForAny("//input[contains(@type, 'button')]", "//button[contains(@type, 'submit')]")
    * optional("//input[contains(@type, 'button')]").click()
    * optional("//button[contains(@type, 'submit')]").click()
    * waitForAny(["//eui-toolbar", "//input[contains(@id, 'username')]", "//input[contains(@id, 'password')]"])
    * if (exists("//input[contains(@id, 'username')]") || exists("//input[contains(@id, 'password')]")) karate.call('classpath:ui-tests/authentication/eu-login.feature')
    * waitForUrl(dashboardUrl)
