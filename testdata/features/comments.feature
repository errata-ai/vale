Feature: Comments
  Scenario: Markdown
    When I test comments for ".md"
    Then the output should contain exactly:
    """
    test.md:23:19:vale.Redundancy:'ACT test' is redundant
    test.md:33:19:vale.Redundancy:'ACT test' is redundant
    test.md:37:19:vale.Redundancy:'ACT test' is redundant
    test.md:43:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.md:95:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.md:105:16:demo.Raw:Link "[must not use `.html`](../index.html)" must use the .md file extension.
    """

  Scenario: reStructuredText
    When I test comments for ".rst"
    Then the output should contain exactly:
    """
    test.rst:15:19:vale.Redundancy:'ACT test' is redundant
    test.rst:19:19:vale.Redundancy:'ACT test' is redundant
    test.rst:25:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    """

  Scenario: AsciiDoc
    When I test comments for ".adoc"
    Then the output should contain exactly:
    """
    test.adoc:15:19:vale.Redundancy:'ACT test' is redundant
    test.adoc:19:19:vale.Redundancy:'ACT test' is redundant
    test.adoc:25:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    """

  Scenario: Org Mode
    When I test comments for ".org"
    Then the output should contain exactly:
    """
    test.org:17:21:vale.Redundancy:'ACT test' is redundant
    """
