Feature: Misc
  Background:
    Given a file named "test.md" with:
    """
    This is very, very important message: all of the teams in all of the cities should listen!

    """

  Scenario: Line Endings
    When I test "misc/line-endings"
    Then the output should contain exactly:
    """
    CR.md:3:11:vale.Editorializing:Consider removing 'very'
    CR.md:15:18:vale.Editorializing:Consider removing 'very'
    CR.md:32:11:vale.Editorializing:Consider removing 'very'
    CRLF.md:3:11:vale.Editorializing:Consider removing 'very'
    CRLF.md:15:18:vale.Editorializing:Consider removing 'very'
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
    When I run vale "test.md"
    Then the output should contain exactly:
    """
    test.md:1:9:vale.Editorializing:Consider removing 'very'
    test.md:1:15:vale.Editorializing:Consider removing 'very'
    test.md:1:39:vale.Wordiness:Consider using 'all' instead of 'all of'
    test.md:1:59:vale.Wordiness:Consider using 'all' instead of 'all of'
    """
