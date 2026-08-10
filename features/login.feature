Feature: User authentication
Background: 
    Given a user in the FIFA page
    When the user click on sign in button 

  Scenario Outline:

    When enter valid credentials "<username>" and "<password>"
    When click on submit button
    Then the user is loggued in the fifa page correctly

  Examples:
    | username                    | password        |
    | maflorencia.norry@gmail.com | Rewards123!     |


   
