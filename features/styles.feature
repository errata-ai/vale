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
    test.md:22:21:demo.Abbreviations:Use 'i.e.,'
    test.md:22:66:demo.Abbreviations:Use 'a.m. or p.m.'
    test.md:22:94:demo.Abbreviations:Use 'midnight or noon'
    test.rst:1:22:demo.CommasPerSentence:More than 3 commas!
    test.rst:1:58:demo.Spacing:'. I' should have one space
    test.rst:3:1:demo.SentenceLength:Sentences should be less than 25 words
    test.rst:7:28:demo.EndingPreposition:Don't end a sentence with 'by.'
    test.rst:11:1:demo.ParagraphLength:Paragraphs should be less than 150 words
    test.rst:22:25:demo.Spelling:Inconsistent spelling of 'center'
    test.rst:26:32:demo.Spelling:Inconsistent spelling of 'colour'
    """

  Scenario: Lint against The Economist's style guide
    When I apply style "TheEconomist"
    Then the output should contain exactly:
    """
    test.adoc:3:1:TheEconomist.UnnecessaryWords:'There are' - See section 'Unnecessary words'
    test.adoc:5:5:TheEconomist.Slang:'key' - See section 'Journalese and slang'
    test.adoc:5:34:TheEconomist.OughtShould:Go easy on the oughts and shoulds
    test.adoc:5:46:TheEconomist.UnnecessaryWords:'there is' - See section 'Unnecessary words'
    test.adoc:7:7:TheEconomist.Endings:avoid using 'German-style'
    test.adoc:7:43:TheEconomist.Endings:avoid using 'EU-style'
    test.adoc:8:38:TheEconomist.Endings:avoid using 'attendees'
    test.adoc:12:5:TheEconomist.Terms:Prefer 'press' over of 'media'
    test.adoc:12:11:TheEconomist.Terms:Prefer 'way of life' over of 'lifestyle'
    test.adoc:12:28:TheEconomist.Terms:Prefer 'naive' over of 'simplistic'
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

  Scenario: Lint against jQuery
    When I apply style "jQuery"
    Then the output should contain exactly:
    """
    test.adoc:5:25:jQuery.Semicolons:Avoid using semicolons
    test.adoc:20:1:jQuery.OxfordComma:Use the Oxford comma in a list of three or more items
    test.md:7:10:jQuery.SentenceLength:Keep sentences short and to the point
    test.md:7:88:jQuery.PassiveVoice:"been implemented" is passive voice
    test.md:7:221:jQuery.PassiveVoice:"been implemented" is passive voice
    test.md:7:266:jQuery.PassiveVoice:"be mixed" is passive voice
    test.md:7:371:jQuery.PassiveVoice:"are covered" is passive voice
    test.md:7:399:jQuery.SentenceLength:Keep sentences short and to the point
    test.rs:5:34:jQuery.Pronouns:Avoid using "we"
    test.rs:9:36:jQuery.Abbreviations:Use 'i.e.'
    test.rs:9:52:jQuery.PassiveVoice:"be linted" is passive voice
    test.rs:13:24:jQuery.Numbers:Spell out numbers below 10 and use numerals for numbers 10 and above
    test.rst:8:51:jQuery.PassiveVoice:"be prompted" is passive voice
    test.rst:9:57:jQuery.PassiveVoice:"is sent" is passive voice
    test.rst:11:71:jQuery.PassiveVoice:"is supported" is passive voice
    test.rst:17:51:jQuery.PassiveVoice:"be omitted" is passive voice
    test.rst:23:11:jQuery.PassiveVoice:"be applied" is passive voice
    test.rst:27:1:jQuery.PassiveVoice:"be used" is passive voice
    """

  Scenario: Lint against Homebrew
    When I apply style "Homebrew"
    Then the output should contain exactly:
    """
    test.md:3:245:Homebrew.Spacing:'. I' should have one space.
    test.md:3:259:Homebrew.Terms:Use 'repository' instead of 'repo'.
    test.md:3:329:Homebrew.OxfordComma:No Oxford commas!
    test.md:3:401:Homebrew.Terms:Use 'RuboCop' instead of 'Rubocop'.
    test.md:15:16:Homebrew.FixedWidth:' brew ' should be in fixed width font.
    test.md:15:49:Homebrew.Abbreviations:Use 'e.g.'
    test.md:15:68:Homebrew.FixedWidth:' homebrew-science ' should be in fixed width font.
    test.md:15:117:Homebrew.Pronouns:Avoid gender-specific language when not necessary.
    test.rst:11:19:Homebrew.FixedWidth:' git ' should be in fixed width font.
    """
