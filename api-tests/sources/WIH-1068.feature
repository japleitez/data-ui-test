Feature: WIH-1068 As a user, I can upload a list of sources

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def jsonValid = read('classpath:/api-tests/requests/sourceListValid.json')
    * def jsonEmpty = read('classpath:/api-tests/requests/sourceListEmpty.json')
    * def jsonNonMappable = read('classpath:/api-tests/requests/sourceListNonMappable.json')
    * def sourceListInvalid = read('classpath:/api-tests/requests/sourceListInvalid.txt')
    * def now = function(){ return java.lang.System.currentTimeMillis() }

  Scenario: As a user I can POST a valid list of sources and get 201
    * set jsonValid.sources[0].name = 'asd1_' + now()
    * set jsonValid.sources[1].name = 'asd2_' + now()
    * set jsonValid.sources[2].name = 'asd3_' + now()
    Given url serviceUrl + '/api/sources/batch/import'
    And multipart file fileToUpload0 = { value: '#(jsonValid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 201

  Scenario: As a user I can POST an invalid list of sources with some duplicate names and get 202
    * set jsonValid.sources[0].name = 'asd1_' + now()
    * set jsonValid.sources[1].name = jsonValid.sources[0].name
    * set jsonValid.sources[2].name = 'asd3_' + now()
    Given url serviceUrl + '/api/sources/batch/import'
    And multipart file fileToUpload0 = { value: '#(jsonValid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 202

  Scenario: As a user I can POST an invalid list of sources with some invalid fields and get 202
    * set jsonValid.sources[0].name = 'asd#%b' + now()
    * set jsonValid.sources[0].url = '__source3'
    * set jsonValid.sources[1].name = 'asd2_' + now()
    * set jsonValid.sources[2].name = 'asd3_' + now()
    Given url serviceUrl + '/api/sources/batch/import'
    And multipart file fileToUpload0 = { value: '#(jsonValid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 202

  Scenario: As a user I can POST a valid list but with some existing sources and get 202
    * set jsonValid.sources[0].name = 'source1'
    * set jsonValid.sources[1].name = 'source2'
    * set jsonValid.sources[2].name = 'source3' + now()
    Given url serviceUrl + '/api/sources/batch/import'
    And multipart file fileToUpload0 = { value: '#(jsonValid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 202

  Scenario: As a user I can POST an unmappable json file and get 422
    Given url serviceUrl + '/api/sources/batch/import'
    And multipart file fileToUpload0 = { value: '#(jsonNonMappable)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 422

  Scenario: As a user I can POST an invalid json file and get 422
    Given url serviceUrl + '/api/sources/batch/import'
    And multipart file fileToUpload0 = { value: '#(sourceListInvalid)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 422

  Scenario: As a user I can POST an empty list of sources and get 422
    Given url serviceUrl + '/api/sources/batch/import'
    And multipart file fileToUpload0 = { read: 'classpath:/api-tests/requests/sourceListEmpty.json', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 422
