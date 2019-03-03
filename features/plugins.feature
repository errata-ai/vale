Feature: Plugins

  Scenario: Loading
    Given on Unix
    When I test plugins for "test.md"
    Then the output should contain exactly:
      """
      test.md:1:1:plugins.Example:Don't use 'The'!
      """
