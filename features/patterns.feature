Feature: IgnorePatterns
  Scenario: Markdown
    When I test patterns for "test.md"
    Then the output should contain exactly:
      """
      test.md:1:19:vale.Redundancy:'ACT test' is redundant
      test.md:7:19:vale.Redundancy:'ACT test' is redundant
      test.md:19:1:vale.Redundancy:'ACT test' is redundant
      """
    And the exit status should be 0