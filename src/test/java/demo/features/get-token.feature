Feature: Sample API 

  Scenario: get list of users

    Given   url 'https://reqres.in/api/users?page=2'
    When method get
    Then status 200


  Scenario: get list ofd users

    Given   url 'https://reqres.in/api/users?page=1'
    When method get
    Then status 200
  Scenario: get list ofd users

    Given   url 'https://reqres.in/api/users?page=4'
    When method get
    Then status 200

  Scenario: get list ofd users

    Given   url 'https://reqres.in/api/users?page=5'
    When method get
    Then status 200

