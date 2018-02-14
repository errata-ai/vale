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

  Scenario: Repetition
    When I test "checks/Repetition"
    Then the output should contain exactly:
      """
      test.tex:31:21:vale.Repetition:'not' is repeated!
      text.rst:6:17:vale.Repetition:'as' is repeated!
      text.rst:15:7:vale.Repetition:'and' is repeated!
      text.rst:16:22:vale.Repetition:'on' is repeated!
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

  Scenario: Hedging
    When I test "checks/Hedging"
    Then the output should contain exactly:
      """
      test.adoc:1:39:vale.Hedging:Consider removing 'probably'
      test.adoc:3:50:vale.Hedging:Consider removing 'probably'
      test.adoc:4:32:vale.Hedging:Consider removing 'probably'
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
