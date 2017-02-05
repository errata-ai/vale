Feature: Checks
  Scenario: Annotations
    When I test "Annotations"
    Then the output should contain exactly:
    """
    test.java:2:5:txtlint.Annotations:'TODO' left in text
    test.java:5:31:txtlint.Annotations:'NOTE' left in text
    test.java:6:31:txtlint.Annotations:'XXX' left in text
    test.java:10:8:txtlint.Annotations:'NOTE' left in text
    test.java:13:12:txtlint.Annotations:'FIXME' left in text

    """

  Scenario: PassiveVoice
    When I test "PassiveVoice"
    Then the output should contain exactly:
    """
    test.swift:3:47:txtlint.PassiveVoice:'were eaten' is passive voice
    test.swift:5:38:txtlint.PassiveVoice:'was faxed' is passive voice
    test.swift:12:18:txtlint.PassiveVoice:'were you taught' is passive voice

    """

  Scenario: GenderBias
    When I test "GenderBias"
    Then the output should contain exactly:
    """
    test.tex:69:9:txtlint.GenderBias:Consider using 'first-year student(s)' instead of 'freshman'
    test.tex:69:68:txtlint.GenderBias:Consider using 'human resources' instead of 'manpower'
    test.tex:189:8:txtlint.GenderBias:Consider using 'everyone' instead of 'guys'

    """

  Scenario: Editorializing
    When I test "Editorializing"
    Then the output should contain exactly:
    """
    test.html:9:7:txtlint.Editorializing:Consider removing 'Note that'
    test.html:13:7:txtlint.Editorializing:Consider removing 'Notably'

    """

  Scenario: Abbreviations
    When I test "Abbreviations"
    Then the output should contain exactly:
    """
    test.md:1:21:txtlint.Abbreviations:Use 'i.e.,'
    test.md:1:66:txtlint.Abbreviations:Use 'a.m. or p.m.'
    test.md:1:94:txtlint.Abbreviations:Use 'midnight or noon'

    """

  Scenario: Repetition
    When I test "Repetition"
    Then the output should contain exactly:
    """
    text.rst:6:17:txtlint.Repetition:'as' is repeated!
    text.rst:8:33:txtlint.Repetition:'the' is repeated!
    text.rst:15:7:txtlint.Repetition:'and' is repeated!
    text.rst:16:22:txtlint.Repetition:'on' is repeated!

    """

  Scenario: Redundancy
    When I test "Redundancy"
    Then the output should contain exactly:
    """
    test.cpp:58:25:txtlint.Redundancy:'ATM machine' is redundant
    test.cpp:66:51:txtlint.Redundancy:'free gift' is redundant
    test.cpp:90:14:txtlint.Redundancy:'completely destroyed' is redundant

    """

  Scenario: Uncomparables
    When I test "Uncomparables"
    Then the output should contain exactly:
    """
    test.adoc:1:49:txtlint.Uncomparables:'absolutely false' is not comparable
    test.adoc:10:15:txtlint.Uncomparables:'very unique' is not comparable

    """

  Scenario: Wordiness
    When I test "Wordiness"
    Then the output should contain exactly:
    """
    test.cs:2:19:txtlint.Wordiness:Consider using 'across' instead of 'all across'
    test.cs:10:4:txtlint.Wordiness:Consider using 'most' instead of 'A large majority of'
    test.cs:10:45:txtlint.Wordiness:Consider using 'time' instead of 'time period'

    """

  Scenario: ComplexWords
    When I test "ComplexWords"
    Then the output should contain exactly:
    """
    test.sass:4:16:txtlint.ComplexWords:Consider using 'plenty' instead of 'abundance'
    test.sass:5:13:txtlint.ComplexWords:Consider using 'use' instead of 'utilize'

    """

  Scenario: Hedging
    When I test "Hedging"
    Then the output should contain exactly:
    """
    test.less:9:6:txtlint.Hedging:Consider removing 'in my opinion'
    test.less:9:29:txtlint.Hedging:Consider removing 'probably'
    test.less:12:41:txtlint.Hedging:Consider removing 'As far as I know'

    """

  Scenario: Litotes
    When I test "Litotes"
    Then the output should contain exactly:
    """
    test.scala:2:13:txtlint.Litotes:Consider using 'rejected' instead of 'not accepted'
    test.scala:2:53:txtlint.Litotes:Consider using 'lack(s)' instead of 'not have'
    test.scala:6:32:txtlint.Litotes:Consider using 'large' instead of 'no small'

    """
