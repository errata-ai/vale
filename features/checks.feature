Feature: Checks
  Scenario: Annotations
    When I test "checks/Annotations"
    Then the output should contain exactly:
    """
    test.java:2:5:vale.Annotations:'TODO' left in text
    test.java:5:31:vale.Annotations:'NOTE' left in text
    test.java:6:31:vale.Annotations:'XXX' left in text
    test.java:10:8:vale.Annotations:'NOTE' left in text
    test.java:13:12:vale.Annotations:'FIXME' left in text

    """

  Scenario: PassiveVoice
    When I test "checks/PassiveVoice"
    Then the output should contain exactly:
    """
    test.md:7:88:vale.PassiveVoice:'been implemented' is passive voice
    test.md:7:221:vale.PassiveVoice:'been implemented' is passive voice
    test.md:7:266:vale.PassiveVoice:'be mixed' is passive voice
    test.md:7:371:vale.PassiveVoice:'are covered' is passive voice
    test.rst:8:51:vale.PassiveVoice:'be prompted' is passive voice
    test.rst:9:57:vale.PassiveVoice:'is sent' is passive voice
    test.rst:11:71:vale.PassiveVoice:'is supported' is passive voice
    test.rst:17:51:vale.PassiveVoice:'be omitted' is passive voice
    test.rst:23:11:vale.PassiveVoice:'be applied' is passive voice
    test.swift:3:47:vale.PassiveVoice:'were eaten' is passive voice
    test.swift:5:38:vale.PassiveVoice:'was faxed' is passive voice

    """

  Scenario: GenderBias
    When I test "checks/GenderBias"
    Then the output should contain exactly:
    """
    test.tex:171:38:vale.GenderBias:Consider using 'human resources' instead of 'manpower'
    test.tex:177:9:vale.GenderBias:Consider using 'first-year student(s)' instead of 'freshman'
    test.tex:187:8:vale.GenderBias:Consider using 'everyone' instead of 'guys'

    """

  Scenario: Editorializing
    When I test "checks/Editorializing"
    Then the output should contain exactly:
    """
    test.html:9:7:vale.Editorializing:Consider removing 'Note that'
    test.html:10:25:vale.Editorializing:Consider removing 'very'
    test.html:13:7:vale.Editorializing:Consider removing 'Notably'
    test.md:1:24:vale.Editorializing:Consider removing 'very'
    test.rst:5:1:vale.Editorializing:Consider removing 'very'

    """

  Scenario: Abbreviations
    When I test "checks/Abbreviations"
    Then the output should contain exactly:
    """
    test.md:1:21:vale.Abbreviations:Use 'i.e.,'
    test.md:1:66:vale.Abbreviations:Use 'a.m. or p.m.'
    test.md:1:94:vale.Abbreviations:Use 'midnight or noon'

    """

  Scenario: Repetition
    When I test "checks/Repetition"
    Then the output should contain exactly:
    """
    test.tex:31:21:vale.Repetition:'not' is repeated!
    text.rst:6:17:vale.Repetition:'as' is repeated!
    text.rst:8:33:vale.Repetition:'the' is repeated!
    text.rst:15:7:vale.Repetition:'and' is repeated!
    text.rst:16:22:vale.Repetition:'on' is repeated!
    text.rst:19:1:vale.Repetition:'this' is repeated!
    text.rst:20:13:vale.Repetition:'be' is repeated!

    """

  Scenario: Redundancy
    When I test "checks/Redundancy"
    Then the output should contain exactly:
    """
    test.cpp:58:25:vale.Redundancy:'ATM machine' is redundant
    test.cpp:66:51:vale.Redundancy:'free gift' is redundant
    test.cpp:90:14:vale.Redundancy:'completely destroyed' is redundant

    """

  Scenario: Uncomparables
    When I test "checks/Uncomparables"
    Then the output should contain exactly:
    """
    test.adoc:1:49:vale.Uncomparables:'absolutely false' is not comparable
    test.adoc:10:15:vale.Uncomparables:'very unique' is not comparable

    """

  Scenario: Wordiness
    When I test "checks/Wordiness"
    Then the output should contain exactly:
    """
    test.cs:2:19:vale.Wordiness:Consider using 'across' instead of 'all across'
    test.cs:10:4:vale.Wordiness:Consider using 'most' instead of 'A large majority of'
    test.cs:10:45:vale.Wordiness:Consider using 'time' instead of 'time period'
    test.rst:3:1:vale.Wordiness:Consider using 'some' instead of 'some of the'

    """

  Scenario: ComplexWords
    When I test "checks/ComplexWords"
    Then the output should contain exactly:
    """
    test.sass:4:16:vale.ComplexWords:Consider using 'plenty' instead of 'abundance'
    test.sass:5:13:vale.ComplexWords:Consider using 'use' instead of 'utilize'

    """

  Scenario: Hedging
    When I test "checks/Hedging"
    Then the output should contain exactly:
    """
    test.less:9:6:vale.Hedging:Consider removing 'in my opinion'
    test.less:9:29:vale.Hedging:Consider removing 'probably'
    test.less:12:41:vale.Hedging:Consider removing 'As far as I know'

    """

  Scenario: Litotes
    When I test "checks/Litotes"
    Then the output should contain exactly:
    """
    test.scala:2:13:vale.Litotes:Consider using 'rejected' instead of 'not accepted'
    test.scala:2:53:vale.Litotes:Consider using 'lack(s)' instead of 'not have'
    test.scala:6:32:vale.Litotes:Consider using 'large' instead of 'no small'

    """
