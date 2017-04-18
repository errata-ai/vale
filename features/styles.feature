Feature: Styles
  Scenario: Lint against write-good
    When I apply style "write-good"
    Then the output should contain exactly:
    """
    test.cc:1:4:write-good.Weasal:'Remarkably' is a weasal word!
    test.cc:1:15:write-good.Weasal:'few' is a weasal word!
    test.cc:8:27:write-good.Cliches:'at loose ends' is a cliché
    test.cc:11:40:write-good.Passive:'was killed'
    test.cc:18:6:write-good.Illusions:'the' is repeated!
    test.cc:21:25:write-good.ThereIs:Don't start a sentence with '// There are'
    test.cc:28:21:write-good.ThereIs:Don't start a sentence with '// There is'
    test.cc:31:21:write-good.So:Don't start a sentence with '; so '
    test.cc:34:14:write-good.So:Don't start a sentence with '// So '
    test.md:1:1:write-good.Weasal:'Remarkably' is a weasal word!
    test.md:1:12:write-good.Weasal:'few' is a weasal word!
    test.md:3:12:write-good.Passive:'was killed'
    test.md:5:1:write-good.Illusions:'the' is repeated!
    test.md:7:1:write-good.Illusions:'the' is repeated!
    test.md:10:1:write-good.Illusions:'the' is repeated!
    test.md:14:1:write-good.So:Don't start a sentence with 'So '
    test.md:23:15:write-good.So:Don't start a sentence with '; so '
    test.md:25:1:write-good.ThereIs:Don't start a sentence with 'There is'
    test.md:27:1:write-good.ThereIs:Don't start a sentence with 'There are'
    test.md:29:18:write-good.Weasal:'simply' is a weasal word!
    test.md:31:18:write-good.Weasal:'extremely' is a weasal word!
    test.md:33:8:write-good.Passive:'been said'
    test.md:33:23:write-good.Weasal:'few' is a weasal word!
    test.md:35:1:write-good.TooWordy:'As a matter of fact' is too wordy
    test.md:37:32:write-good.TooWordy:'impacted' is too wordy
    test.md:39:23:write-good.Cliches:'at loose ends' is a cliché
    test.txt:1:8:write-good.E-Prime:Avoid using "is"
    test.txt:3:12:write-good.E-Prime:Avoid using "was"
    test.txt:5:1:write-good.E-Prime:Avoid using "I'm"
    test.txt:9:1:write-good.E-Prime:Avoid using "I'm"
    test.txt:9:57:write-good.E-Prime:Avoid using "was"
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
    test.md:10:133:demo.CheckSpellings:Use 'ValeLint' instead of 'Valelint'
    test.md:12:1:demo.SentenceLength:Sentences should be less than 25 words
    test.md:14:159:demo.SentenceLength:Sentences should be less than 25 words
    test.md:16:1:demo.SentenceLength:Sentences should be less than 25 words
    test.md:16:367:demo.SentenceLength:Sentences should be less than 25 words
    test.md:22:21:demo.Abbreviations:Use 'i.e.,'
    test.md:22:66:demo.Abbreviations:Use 'a.m. or p.m.'
    test.md:22:94:demo.Abbreviations:Use 'midnight or noon'
    test.md:24:4:demo.CheckSpellings:Use 'disappear' instead of 'dissapear'
    test.md:24:43:demo.CheckSpellings:Use 'preceded' instead of 'preceeded'
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
    test.css:89:35:TheEconomist.Terms:Prefer 'practical' over of 'actionable'
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
    test.md:18:24:Homebrew.Terms:Use 'repository' instead of 'repo'.
    test.rst:11:19:Homebrew.FixedWidth:' git ' should be in fixed width font.
    """

  Scenario: Lint against Joblint
    When I apply style "Joblint"
    Then the output should contain exactly:
    """
    browser.html:5:12:Joblint.TechTerms:Use 'JavaScript' instead of 'java script'
    browser.html:5:24:Joblint.Gendered:Avoid using 'dude'
    oh-dear.txt:4:21:Joblint.Profanity:Remove 'fucking'
    oh-dear.txt:4:37:Joblint.TechTerms:Use 'JavaScript' instead of 'java script'
    oh-dear.txt:4:49:Joblint.Gendered:Avoid using 'dude'
    oh-dear.txt:4:76:Joblint.DumbTitles:Avoid using 'ninja'
    oh-dear.txt:5:19:Joblint.TechTerms:Use 'JavaScript' instead of 'javascript'
    oh-dear.txt:5:59:Joblint.Bro:Avoid using 'crush'
    oh-dear.txt:7:13:Joblint.Profanity:Remove 'damn'
    oh-dear.txt:7:18:Joblint.Sexualised:Avoid using 'sexy'
    oh-dear.txt:7:49:Joblint.LegacyTech:Avoid using 'Frontpage'
    oh-dear.txt:7:85:Joblint.DevEnv:Don't specify a development environment unless absolutely necessary.
    oh-dear.txt:7:145:Joblint.Competitive:Avoid using 'top of your game'
    oh-dear.txt:7:179:Joblint.Visionary:Avoid using 'enlightened'
    oh-dear.txt:9:69:Joblint.LegacyTech:Avoid using 'VBScript'
    oh-dear.txt:9:91:Joblint.Gendered:Avoid using 'He'
    oh-dear.txt:9:112:Joblint.Starter:Avoid using 'hit the ground running'
    oh-dear.txt:9:145:Joblint.Competitive:Avoid using 'cutting-edge'
    oh-dear.txt:9:159:Joblint.Meritocracy:Reevaluate the use of 'meritocratic'
    oh-dear.txt:11:24:Joblint.Benefits:Avoid using 'pool table'
    oh-dear.txt:11:52:Joblint.Benefits:Avoid using 'beer'
    oh-dear.txt:11:71:Joblint.Reassure:Avoid using 'drama-free'
    oh-dear.txt:11:118:Joblint.DumbTitles:Avoid using 'heroic'
    oh-dear.txt:14:21:Joblint.Hair:Avoid using 'beards'
    realistic.txt:4:32:Joblint.TechTerms:Use 'JavaScript' instead of 'java script'
    realistic.txt:4:44:Joblint.Gendered:Avoid using 'guy'
    realistic.txt:5:19:Joblint.TechTerms:Use 'JavaScript' instead of 'javascript'
    """

  Scenario: Lint against Middlebury
    When I apply style "Middlebury"
    Then the output should contain exactly:
    """
    test.md:1:15:Middlebury.Typography:Use an en dash.
    test.md:1:34:Middlebury.Typography:Use a left-facing apostrophe.
    test.md:3:5:Middlebury.Terms:Avoid using 'oriental'
    test.md:3:42:Middlebury.Typography:Words combined with -long should be closed.
    test.md:3:59:Middlebury.Abbreviations:Use 'i.e.,' instead of 'i.e. '
    test.md:5:122:Middlebury.Disabilities:Avoid using 'special needs'
    test.md:7:21:Middlebury.Hyphens:Use 'worldwide' instead of 'world-wide'
    """
