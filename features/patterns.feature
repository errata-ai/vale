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

  Scenario: AsciiDoc
    When I test patterns for "test.adoc"
    Then the output should contain exactly:
      """
      test.adoc:1:19:vale.Redundancy:'ACT test' is redundant
      test.adoc:7:19:vale.Redundancy:'ACT test' is redundant
      test.adoc:19:1:vale.Redundancy:'ACT test' is redundant
      """
    And the exit status should be 0

  Scenario: reStructuredText
    When I test patterns for "test.rst"
    Then the output should contain exactly:
      """
      test.rst:1:19:vale.Redundancy:'ACT test' is redundant
      test.rst:7:19:vale.Redundancy:'ACT test' is redundant
      test.rst:19:1:vale.Redundancy:'ACT test' is redundant
      """
    And the exit status should be 0
