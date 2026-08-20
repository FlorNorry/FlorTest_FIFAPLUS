@epic:Authentication @feature:Login
Feature: User authentication
Background: 
    Given a user in the FIFA page
    When the user click on sign in button 

  @severity:critical @owner:FlorNorry
  Scenario Outline: Login with valid credentials

    When enter valid credentials "<username>" and "<password>"
    When click on submit button
    Then the "<username>" is loggued in the fifa page correctly

  Examples:
    | username                    | password        |
    | maflorencia.norry@gmail.com | Rewards123!     |


   
