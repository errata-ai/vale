Feature: Misc

  Scenario: Projects
    When I use Project "Basic"
    Then the output should contain exactly:
      """
      test.md:3:5:Vale.Avoid:Avoid using 'Mac OS X'.
      """

  Scenario: Line Endings
    When I test "misc/line-endings"
    Then the output should contain exactly:
    """
    CR.md:3:11:vale.Editorializing:Consider removing 'very'
    CR.md:32:11:vale.Editorializing:Consider removing 'very'
    CRLF.md:3:11:vale.Editorializing:Consider removing 'very'
    CRLF.md:32:11:vale.Editorializing:Consider removing 'very'
    """

  Scenario: Unicode
    When I test "misc/unicode"
    Then the output should contain exactly:
    """
    test.py:2:27:vale.Hedging:Consider removing 'probably'
    test.rst:1:36:vale.Annotations:'TODO' left in text
    test.rst:2:55:vale.Hedging:Consider removing 'probably'
    test.rst:4:23:vale.Editorializing:Consider removing 'very'
    test.txt:1:36:vale.Annotations:'TODO' left in text
    test.txt:2:55:vale.Hedging:Consider removing 'probably'
    test.txt:4:23:vale.Editorializing:Consider removing 'very'
    """

  Scenario: Duplicate matches
    When I test "misc/duplicates"
    Then the output should contain exactly:
    """
    test.md:1:9:vale.Editorializing:Consider removing 'very'
    test.md:1:15:vale.Editorializing:Consider removing 'very'
    test.md:1:39:vale.Editorializing:Consider removing 'very'
    test.md:1:57:vale.Editorializing:Consider removing 'very'
    """

  Scenario: Spelling
    When I test "spelling"
    Then the output should contain exactly:
      """
      test.adoc:61:1:Vale.Spelling:Did you really mean 'Nginx'?
      test.html:5:21:Spelling.Ignores:Did you really mean 'docbook'?
      test.html:14:96:Spelling.Ignores:Did you really mean 'TODO'?
      test.md:3:1:Spelling.Ignore:'HTTPie' is a typo!
      test.md:3:59:Spelling.Ignore:'CLI' is a typo!
      test.md:3:96:Spelling.Ignore:'human-friendly' is a typo!
      test.rst:8:139:Spelling.Ignores:Did you really mean 'substring'?
      """
