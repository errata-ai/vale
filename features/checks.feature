Feature: Checks

  Scenario: SentenceCase
    When I test "checks/SentenceCase"
    Then the output should contain exactly:
      """
      test.md:5:3:demo.SentenceCase:'this isn't in sentence case' should be sentence-cased
      test.md:11:3:demo.SentenceCase:'This Does Not Comply' should be sentence-cased
      """

  Scenario: Repetition
    When I test "checks/Repetition"
    Then the output should contain exactly:
      """
      test.tex:31:21:Vale.Repetition:'not' is repeated!
      text.rst:6:17:Vale.Repetition:'as' is repeated!
      text.rst:15:7:Vale.Repetition:'and' is repeated!
      text.rst:16:22:Vale.Repetition:'on' is repeated!
      text.rst:20:13:Vale.Repetition:'be' is repeated!
      """

  Scenario: Sequence
    When I test "checks/Sequence"
    Then the output should contain exactly:
      """
      test.md:3:10:LanguageTool.WOULD_BE_JJ_VB:The infinitive 'write' after 'be' requries 'to'. Did you mean 'be great *to* write'?
      test.md:9:94:LanguageTool.WOULD_BE_JJ_VB:The infinitive 'come' after 'be' requries 'to'. Did you mean 'be available *to* come'?
      test.md:11:59:LanguageTool.OF_ALL_TIMES:In this context, the idiom needs to be spelled 'of all time'.
      test.md:13:17:LanguageTool.OF_ALL_TIMES:In this context, the idiom needs to be spelled 'of all time'.
      test.md:15:36:LanguageTool.OF_ALL_TIMES:In this context, the idiom needs to be spelled 'of all time'.
      test.md:17:35:LanguageTool.OF_ALL_TIMES:In this context, the idiom needs to be spelled 'of all time'.
      """
