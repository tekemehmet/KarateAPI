Feature: Spartan API test

  Background: setup
    * url 'http://54.196.47.224:8000'
    * header Authorization = call read('basic-auth.js') {username: 'admin', password: 'admin'}


    Scenario: Get all spartans
      Given path '/api/spartans/'
      When method get
      Then status 200
      * print karate.pretty(response)

      Scenario: Add new spartan and verify status code
        Given path '/api/spartans'
        * def spartan =
        """
        {
        "name": "Karate Master",
        "gender": "Male",
        "phone": 1234567898
        }
        """
        And request spartan
        When method post
        Then status 201
        And print karate.pretty(response)
        * def id = response.data.id
        * header Authorization = token


        Scenario: Delete Spartan
          Given path '/api/spartans/9'
          When  method delete
          Then status 204

          Scenario: Add new Spartan from external JSON file
            Given path '/api/spartans'
            * def spartan = read('spartan.json')
            * request spartan
            When method post
            * print karate.pretty(response)
            Then status 201
            And assert response.success == 'A Spartan is Born!'


            Scenario: Update spartan
              Given path '/api/spartans/594'
              And request {name: 'Jiu Master'}
              And method patch
              * print karate.pretty(response)
              Then status 204
              * header Authorization = token
              * path '/api/spartans/594'
              When method get
              * print karate.pretty(response)



