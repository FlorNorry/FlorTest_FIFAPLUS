@epic:Navigation @feature:NavigationFifa
Feature: User Navigation
Background: 
    Given a user in the FIFA page

  @severity:critical @owner:FlorNorry
  Scenario Outline: The user navigates to the home page and News/Ranking
    When click on option "<url>" and validate the "<title>"
    Then the user scrolls to the bottom of the page
    Then the footer should be visible

  Examples:
    | url      | title         |
    | NEWS     | Latest news   |
    | RANKINGS | FIFA Rankings |