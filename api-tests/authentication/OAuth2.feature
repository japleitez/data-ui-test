@ignore
Feature: WIH-952 As a devOps I need to provide access through authentication

  Background:
    * url  tokenUrl
    * def base64encode =
  """
  function fn(creds) {
    var temp = creds.username + ':' + creds.password;
    var Base64 = Java.type('java.util.Base64');
    var encoded = Base64.getEncoder().encodeToString(temp.toString().getBytes());
    return 'Basic ' + encoded;
  }
  """

  Scenario: OAuth2 flow

    * header Content-Type = 'application/x-www-form-urlencoded'
    * header Authorization = base64encode({ username: client_id, password: client_secret })
    * form field client_id = client_id
    * form field client_secret = client_secret
    * form field grant_type = 'client_credentials'
    * form field scope = scopes
    * method post
    * status 200
