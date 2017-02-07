Feature: Misc
  Scenario: Line Endings
    When I test "misc/line-endings"
    Then the output should contain exactly:
    """
    CR.md:3:11:txtlint.Editorializing:Consider removing 'very'
    CR.md:8:5:txtlint.Annotations:'NOTE' left in text
    CR.md:8:21:txtlint.Editorializing:Consider removing 'very'
    CR.md:18:4:txtlint.Annotations:'XXX' left in text
    CR.md:18:18:txtlint.Editorializing:Consider removing 'relatively'
    CR.md:32:11:txtlint.Editorializing:Consider removing 'very'
    CRLF.md:3:11:txtlint.Editorializing:Consider removing 'very'
    CRLF.md:8:5:txtlint.Annotations:'NOTE' left in text
    CRLF.md:8:21:txtlint.Editorializing:Consider removing 'very'
    CRLF.md:18:4:txtlint.Annotations:'XXX' left in text
    CRLF.md:18:18:txtlint.Editorializing:Consider removing 'relatively'
    CRLF.md:32:11:txtlint.Editorializing:Consider removing 'very'

    """
