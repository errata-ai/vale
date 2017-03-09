Feature: Styles
  Scenario: Lint against write-good
    When I apply style "write-good"
    Then the output should contain exactly:
    """
    test.cc:8:27:write-good.NoCliches:'at loose ends' is a cliché
    test.cc:11:40:write-good.PassiveVoice:'was killed'
    test.cc:18:6:write-good.LexicalIllusions:'the' is repeated!
    test.cc:21:25:write-good.ThereIs:Don't start a sentence with '// There are'
    test.cc:28:21:write-good.ThereIs:Don't start a sentence with '// There is'
    test.cc:31:21:write-good.StartsWithSo:Don't start a sentence with '; so'
    test.cc:34:14:write-good.StartsWithSo:Don't start a sentence with '// So'

    """

  Scenario: Lint against demo
    When I apply style "demo"
    Then the output should contain exactly:
    """
    test.html:5:43:demo.EndingPreposition:Don't end a sentence with 'by.'
    test.html:8:30:demo.CommasPerSentence:More than 3 commas!
    test.html:10:27:demo.Spacing:'.M' should have one space
    test.html:10:35:demo.Hyphen:' Randomly-' doesn't need a hyphen
    test.html:12:12:demo.SentenceLength:Sentences should be less than 25 words
    test.html:32:17:demo.HeadingStartsWithCapital:'this is a heading' should be capitalized
    test.md:1:3:demo.HeadingStartsWithCapital:'this is a heading' should be capitalized
    test.md:7:1:demo.HeadingStartsWithCapital:'this is another heading!' should be capitalized
    test.md:12:1:demo.SentenceLength:Sentences should be less than 25 words
    test.md:14:159:demo.SentenceLength:Sentences should be less than 25 words
    test.md:16:1:demo.SentenceLength:Sentences should be less than 25 words
    test.md:16:367:demo.SentenceLength:Sentences should be less than 25 words
    test.txt:1:22:demo.CommasPerSentence:More than 3 commas!
    test.txt:1:58:demo.Spacing:'. I' should have one space
    test.txt:3:1:demo.SentenceLength:Sentences should be less than 25 words
    test.txt:7:28:demo.EndingPreposition:Don't end a sentence with 'by.'
    test.txt:11:1:demo.ParagraphLength:Paragraphs should be less than 150 words
    test.txt:22:25:demo.Spelling:Inconsistent spelling of 'center'
    test.txt:26:32:demo.Spelling:Inconsistent spelling of 'colour'

    """

  Scenario: Lint against The Economist's style guide
    When I apply style "TheEconomist"
    Then the output should contain exactly:
    """
    test.css:1:32:TheEconomist.Punctuation:Use 'eg' instead of 'e.g.'
    test.css:12:54:TheEconomist.UnexpandedAcronyms:'ONE' has no definition
    test.css:34:27:TheEconomist.Slang:'Big pharma' - See section 'Journalese and slang'
    test.md:1:224:TheEconomist.UnexpandedAcronyms:'DAFB' has no definition
    test.md:7:113:TheEconomist.OughtShould:Go easy on the oughts and shoulds
    test.md:9:13:TheEconomist.UnexpandedAcronyms:'AAAS' has no definition
    test.md:9:152:TheEconomist.Punctuation:Use 'eg, or ie,' instead of 'ie '
    test.md:11:12:TheEconomist.OverusedWords:'community' is overused
    test.md:11:51:TheEconomist.OughtShould:Go easy on the oughts and shoulds
    test.md:11:69:TheEconomist.Didactic:'Consider' - Do not be too didactic

    """
