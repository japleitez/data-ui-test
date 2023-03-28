Feature: As a user, I can login with Keycloak

  @tag1
  @ignore
  Scenario: Keycloak login

    Given driver authUrl
    When waitFor('#username').input('user')
    And waitFor('#password').input('user')
    When waitFor('#kc-login').click()
    Then waitForUrl(dashboardUrl + '/screen/home')
