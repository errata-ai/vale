Feature: Plugins

  Scenario: Loading
    Given on Unix
    When I test plugins for "test.md"
    Then the output should contain exactly:
      """
      test.md:1:4:plugins.Example:Capitalize your headings!
      test.md:15:5:plugins.Example:Capitalize your headings!
      test.md:54:14:plugins.Sequence:Don't use the word 'dialog'!
      """
