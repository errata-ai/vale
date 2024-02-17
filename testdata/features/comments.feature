Feature: Comments
  Scenario: Markdown
    When I test comments for ".md"
    Then the output should contain exactly:
    """
    test.md:15:19:vale.Redundancy:'ACT test' is redundant
    test.md:19:19:vale.Redundancy:'ACT test' is redundant
    test.md:25:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.md:77:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.md:87:16:demo.Raw:Link "[must not use `.html`](../index.html)" must use the .md file extension.
    test.md:91:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.md:93:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.md:103:19:vale.Redundancy:'ACT test' is redundant
    test.md:109:19:vale.Redundancy:'ACT test' is redundant
    test.md:109:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.md:111:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.md:115:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.md:117:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.md:127:19:vale.Redundancy:'ACT test' is redundant
    test.md:133:19:vale.Redundancy:'ACT test' is redundant
    test.md:133:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.md:135:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.md:139:19:vale.Redundancy:'ACT test' is redundant
    test.md:145:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.md:147:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.md:151:19:vale.Redundancy:'ACT test' is redundant
    test.md:151:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.md:153:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    """

  Scenario: reStructuredText
    When I test comments for ".rst"
    Then the output should contain exactly:
    """
    test.rst:16:19:vale.Redundancy:'ACT test' is redundant
    test.rst:20:19:vale.Redundancy:'ACT test' is redundant
    test.rst:26:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.rst:42:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.rst:44:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.rst:54:19:vale.Redundancy:'ACT test' is redundant
    test.rst:60:19:vale.Redundancy:'ACT test' is redundant
    test.rst:60:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.rst:62:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.rst:66:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.rst:68:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.rst:78:19:vale.Redundancy:'ACT test' is redundant
    test.rst:84:19:vale.Redundancy:'ACT test' is redundant
    test.rst:84:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.rst:86:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.rst:90:19:vale.Redundancy:'ACT test' is redundant
    test.rst:96:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.rst:98:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    test.rst:102:19:vale.Redundancy:'ACT test' is redundant
    test.rst:102:48:demo.Ending-Preposition:Don't end a sentence with 'for.'
    test.rst:104:20:demo.Ending-Preposition:Don't end a sentence with 'of.'
    """

  Scenario: Org Mode
    When I test comments for ".org"
    Then the output should contain exactly:
    """
    test.org:17:21:vale.Redundancy:'ACT test' is redundant
    """
