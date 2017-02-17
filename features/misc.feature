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
    CR.md:8:5:vale.Annotations:'NOTE' left in text
    CR.md:8:21:vale.Editorializing:Consider removing 'very'
    CR.md:18:4:vale.Annotations:'XXX' left in text
    CR.md:18:18:vale.Editorializing:Consider removing 'relatively'
    CR.md:32:11:vale.Editorializing:Consider removing 'very'
    CRLF.md:3:11:vale.Editorializing:Consider removing 'very'
    CRLF.md:8:5:vale.Annotations:'NOTE' left in text
    CRLF.md:8:21:vale.Editorializing:Consider removing 'very'
    CRLF.md:18:4:vale.Annotations:'XXX' left in text
    CRLF.md:18:18:vale.Editorializing:Consider removing 'relatively'
    CRLF.md:32:11:vale.Editorializing:Consider removing 'very'

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
