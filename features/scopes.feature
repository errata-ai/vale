Feature: Scopes
  Scenario: Attr
    When I test scope "attr"
    Then the output should contain exactly:
      """
      test.adoc:3:16:rules.Alt:alt text should be less than 125 characters.
      test.md:3:3:rules.Alt:alt text should be less than 125 characters.
      test.rst:4:10:rules.Alt:alt text should be less than 125 characters.
      """

  Scenario: Link
    When I test scope "link"
    Then the output should contain exactly:
      """
      test.adoc:1:35:rules.Link:Don't use 'here' as the content of a link.
      test.md:5:35:rules.Link:Don't use 'here' as the content of a link.
      test.rst:1:40:rules.Link:Don't use 'here' as the content of a link.
      """

  Scenario: Heading
    When I test scope "heading"
    Then the output should contain exactly:
    """
    test.adoc:1:20:rules.Heading:'XXX' left in text
    test.adoc:3:26:rules.Heading:'TODO' left in text
    test.html:2:45:rules.Heading:'XXX' left in text
    test.html:6:60:rules.Heading:'TODO' left in text
    test.md:1:21:rules.Heading:'XXX' left in text
    test.md:3:5:rules.Heading:'TODO' left in text
    test.rst:2:9:rules.Heading:'XXX' left in text
    test.rst:5:19:rules.Heading:'TODO' left in text
    """

  Scenario: Table
    When I test scope "table"
    Then the output should contain exactly:
    """
    test.adoc:9:2:rules.Table:'TODO' left in text
    test.adoc:15:20:rules.Table:'XXX' left in text
    test.html:24:69:rules.Table:'TODO' left in text
    test.md:12:10:rules.Table:'TODO' left in text
    test.rst:15:16:rules.Table:'TODO' left in text
    test.rst:17:3:rules.Table:'XXX' left in text
    """

  Scenario: List
    When I test scope "list"
    Then the output should contain exactly:
    """
    test.adoc:7:11:rules.List:'TODO' left in text
    test.adoc:9:11:rules.List:'TODO' left in text
    test.html:14:12:rules.List:'TODO' left in text
    test.html:20:12:rules.List:'TODO' left in text
    test.md:7:3:rules.List:'TODO' left in text
    test.md:8:3:rules.List:'TODO' left in text
    test.md:12:4:rules.List:'XXX' left in text
    test.rst:9:3:rules.List:'TODO' left in text
    test.rst:10:3:rules.List:'TODO' left in text
    test.rst:14:4:rules.List:'XXX' left in text
    """
