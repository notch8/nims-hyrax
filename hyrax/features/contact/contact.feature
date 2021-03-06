Feature: Contact form

  Background:
    Given an initialised system with a default admin set, permission template and workflow

  Scenario: Unauthenticated user can edit name and email in the contact form
    When I navigate to the contact form
    Then I should see the contact form
    And Name field is not readonly
    And Email field is not readonly

  Scenario: nims_other user cannot edit name and email in the contact form
    Given I am logged in as a nims_other user
    When I navigate to the contact form
    Then I should see the contact form
    But Name field is readonly
    And Email field is readonly

  Scenario: nims_researcher user cannot edit name and email in the contact form
    Given I am logged in as a nims_researcher user
    When I navigate to the contact form
    Then I should see the contact form
    But Name field is readonly
    And Email field is readonly

  Scenario: Admin user cannot edit name and email in the contact form
    Given I am logged in as an admin user
    When I navigate to the contact form
    Then I should see the contact form
    But Name field is readonly
    And Email field is readonly
