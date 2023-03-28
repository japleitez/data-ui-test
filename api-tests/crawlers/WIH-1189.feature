
Feature: WIH-1189 As a user, I can CRUD crawler's sources

  Background:
    * def tokenResult = callonce read('classpath:/api-tests/authentication/OAuth2.feature')
    * def accessToken = karate.jsonPath(tokenResult, "$.response.access_token")
    * header Authorization = 'Bearer ' + accessToken


  Scenario: As a user I can GET a page of the list of sources from an existing crawler and get HTTP 200
    Given url serviceUrl + '/api/crawlers/1/sources?page=0&size=2'
    When method get
    Then status 200
    And assert response.length <= 2

  Scenario: As a user I can POST an existing source to an existing crawler and get HTTP 204
    Given url serviceUrl + '/api/crawlers/1/sources/9'
    When method post
    Then status 204

  Scenario: As a user I can DELETE an existing source from an existing crawler and get HTTP 204
    Given url serviceUrl + '/api/crawlers/1/sources/9'
    When method delete
    Then status 204


  Scenario: As a user I GET the list of sources from an NOT existing crawler I get HTTP 400
    Given url serviceUrl + '/api/crawlers/1000000/sources?page=0&size=2'
    When method get
    Then status 400

  Scenario: As a user I can POST a NOT existing source to an existing crawler and get HTTP 400
    Given url serviceUrl + '/api/crawlers/1/sources/1000000'
    When method post
    Then status 400

  Scenario: As a user I can POST an existing source to a NOT existing crawler and get HTTP 400
    Given url serviceUrl + '/api/crawlers/1000000/sources/1'
    When method post
    Then status 400

  Scenario: As a user I can DELETE a NOT existing source from an existing crawler and get HTTP 400
    Given url serviceUrl + '/api/crawlers/1/sources/1000000'
    When method delete
    Then status 400

  Scenario: As a user I can DELETE an existing source from a NOT existing crawler and get HTTP 400
    Given url serviceUrl + '/api/crawlers/1000000/sources/1'
    When method delete
    Then status 400
