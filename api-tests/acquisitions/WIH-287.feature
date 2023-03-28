@ignore
Feature: WIH-287 As a user, I can create a data acquisition

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken
    * def uuid = function(){ return java.util.UUID.randomUUID() + '' }
    * def cId = uuid()
    * def importCrawlerWithEmptySources = read('classpath:/api-tests/requests/importCrawlerWithEmptySources.json')
    * def now = function(){ return java.lang.System.currentTimeMillis() }

  Scenario: As a user I can POST a valid form

    Given url serviceUrl + '/api/acquisitions'
    And request { name: 'crawler1', uuid: '#(cId)' }
    When method post
    Then status 201

  Scenario: As a user I can POST a valid acquisition form referencing  Crawler with an empty list of Sources and get 422
    * def cname = 'iCrawler6_' + now()
    * set importCrawlerWithEmptySources.name = cname
    Given url serviceUrl + '/api/crawlers/import'
    And multipart file fileToUpload0 = { value: '#(importCrawlerWithEmptySources)', filename: 'fileToUpload0' }
    And multipart field message = 'fileToUpload0'
    When method post
    Then status 201
    And url serviceUrl + '/api/acquisitions'
    And header Authorization = 'Bearer ' + accessToken
    And request { name: '#(cname)', uuid: '#(cId)' }
    When method post
    Then status 422

  Scenario: As a user I can POST an invalid form and gets an 422 error

    Given url serviceUrl + '/api/acquisitions'
    And request { name: 'crawler name $', uuid: '#(cId)' }
    When method post
    Then status 422

  Scenario: As a user I can POST an invalid form and gets an 422 error

    Given url serviceUrl + '/api/acquisitions'
    And request { name: 'crawler1', uuid: 'workflow_uuid' }
    When method post
    Then status 400

  Scenario: As a user I can POST an invalid form and gets an 422 error

    Given url serviceUrl + '/api/acquisitions'
    And request { }
    When method post
    Then status 400

