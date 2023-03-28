Feature: As a user, I can login with EU Login

  @ignore
  Scenario: Eu login username
    * waitForAny("//input[contains(@id, 'username')]", "//input[contains(@id, 'password')]")
    * def euloginUsername = exists("//input[contains(@id, 'username')]")
    * if(euloginUsername) input("//input[contains(@id, 'username')]", "Jason.BOURNE@ec.europa.eu")
    * if(euloginUsername) waitFor("//button[contains(@type, 'submit')]").click()

    * def euloginPassword = waitFor("//input[contains(@id, 'password')]")
    * if(euloginPassword) input("//input[contains(@id, 'password')]", "Admin123")
    * if(euloginPassword) waitFor("//input[contains(@type, 'submit')]").click()
