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
      test.cc:31:21:write-good.So:Don't start a sentence with '; so'
      test.cc:34:14:write-good.So:Don't start a sentence with '// So'
      test.md:1:1:write-good.Weasal:'Remarkably' is a weasal word!
      test.md:1:12:write-good.Weasal:'few' is a weasal word!
      test.md:3:12:write-good.Passive:'was killed'
      test.md:5:1:write-good.Illusions:'the' is repeated!
      test.md:10:1:write-good.Illusions:'the' is repeated!
      test.md:14:1:write-good.So:Don't start a sentence with 'So'
      test.md:23:15:write-good.So:Don't start a sentence with '; so'
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
      test.adoc:1:1:demo.SentenceLength:Sentences should be less than 25 words
      test.adoc:3:4:demo.Title:'Level 1 section title' should be titlecased
      test.html:5:43:demo.EndingPreposition:Don't end a sentence with 'by.'
      test.html:8:30:demo.CommasPerSentence:More than 3 commas!
      test.html:10:27:demo.Spacing:'.M' should have one space
      test.html:10:35:demo.Hyphen:'Randomly-' doesn't need a hyphen
      test.html:12:12:demo.SentenceLength:Sentences should be less than 25 words
      test.html:32:17:demo.HeadingStartsWithCapital:'this is a heading' should be capitalized
      test.md:1:1:demo.Reading:Grade level (8.87) too high!
      test.md:1:3:demo.HeadingStartsWithCapital:'this is a heading' should be capitalized
      test.md:7:1:demo.HeadingStartsWithCapital:'this is another heading!' should be capitalized
      test.md:12:1:demo.SentenceLength:Sentences should be less than 25 words
      test.md:14:121:demo.Filters:Did you really mean 'DBA'?
      test.md:14:158:demo.SentenceLength:Sentences should be less than 25 words
      test.md:16:1:demo.Filters:Did you really mean 'MHS'?
      test.md:16:60:demo.Filters:Did you really mean 'MHS'?
      test.md:20:21:demo.Abbreviations:Use 'i.e.,'
      test.md:20:66:demo.Abbreviations:Use 'a.m. or p.m.'
      test.md:20:94:demo.Abbreviations:Use 'midnight or noon'
      test.md:22:6:demo.Spellcheck:Did you really mean 'dissapear'?
      test.md:22:47:demo.Spellcheck:Did you really mean 'preceeded'?
      test.md:24:27:demo.Code:Consider using 'for-loop' instead of '`for` loops'
      test.md:24:42:demo.Code:Consider using 'for-loop' instead of 'for loops'
      test.md:26:3:demo.Meetup:Use 'meetup(s)' instead of 'meet up'
      test.md:26:88:demo.Abbreviations:Use 'a.m. or p.m.'
      test.md:26:110:demo.Meetup:Use 'meetup(s)' instead of 'meet-ups'
      test.md:26:381:demo.Meetup:Use 'meetup(s)' instead of 'meet up'
      test.md:28:1:demo.Filters:Did you really mean 'FOOOOOO'?
      test.rst:1:22:demo.CommasPerSentence:More than 3 commas!
      test.rst:1:58:demo.Spacing:'. I' should have one space
      test.rst:3:1:demo.SentenceLength:Sentences should be less than 25 words
      test.rst:5:28:demo.EndingPreposition:Don't end a sentence with 'by.'
      test.rst:9:1:demo.ParagraphLength:Paragraphs should be less than 150 words
      test.rst:20:25:demo.Spelling:Inconsistent spelling of 'center'
      test.rst:24:32:demo.Spelling:Inconsistent spelling of 'colour'
      test.rst:26:1:demo.Sentence:'Section Title' should be in sentence case
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
      test.md:9:152:TheEconomist.Punctuation:Use 'eg, or ie,' instead of 'ie'
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
      test.md:7:1:jQuery.SentenceLength:Keep sentences short and to the point
      test.md:7:88:jQuery.PassiveVoice:"been implemented" is passive voice
      test.md:7:221:jQuery.PassiveVoice:"been implemented" is passive voice
      test.md:7:266:jQuery.PassiveVoice:"be mixed" is passive voice
      test.md:7:371:jQuery.PassiveVoice:"are covered" is passive voice
      test.md:7:399:jQuery.SentenceLength:Keep sentences short and to the point
      test.md:7:509:jQuery.UnexpandedAcronyms:'REPL' has no definition
      test.md:10:1:jQuery.ListStart:Capitalize the first word in a list.
      test.md:11:3:jQuery.ListStart:Capitalize the first word in a list.
      test.md:13:17:jQuery.Quotes:Punctuation should be inside the quotes.
      test.md:15:19:jQuery.Semicolons:Avoid using semicolons
      test.rs:5:34:jQuery.Pronouns:Avoid using "we"
      test.rs:9:36:jQuery.Abbreviations:Use 'i.e.'
      test.rs:9:52:jQuery.PassiveVoice:"be linted" is passive voice
      test.rs:13:24:jQuery.Numbers:Spell out numbers below 10 and use numerals for numbers 10 and above
      test.rst:8:51:jQuery.PassiveVoice:"be prompted" is passive voice
      test.rst:9:57:jQuery.PassiveVoice:"is sent" is passive voice
      test.rst:17:51:jQuery.PassiveVoice:"be omitted" is passive voice
      test.rst:23:4:jQuery.ListStart:Capitalize the first word in a list.
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
      test.md:15:49:Homebrew.Abbreviations:Use 'e.g.'
      test.md:15:117:Homebrew.Pronouns:Avoid gender-specific language when not necessary.
      test.md:18:24:Homebrew.Terms:Use 'repository' instead of 'repo'.
      test.md:21:4:Homebrew.Titles:'Formula Duplicate Names' should be in sentence case
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
      test.md:3:59:Middlebury.Abbreviations:Use 'i.e.,' instead of 'i.e.'
      test.md:5:122:Middlebury.Disabilities:Avoid using 'special needs'
      test.md:7:21:Middlebury.Hyphens:Use 'worldwide' instead of 'world-wide'
      """

  Scenario: Lint against 18F
    When I apply style "18F"
    Then the output should contain exactly:
      """
      test.md:8:93:18F.Ages:Avoid hyphens in ages unless it clarifies the text.
      test.md:14:16:18F.Abbreviations:Use 'DC' instead of 'D.C.'
      test.md:17:162:18F.Terms:Prefer 'drop-down' or 'drop down' over 'dropdown.'
      test.md:45:18:18F.Abbreviations:Use 'U.S.' instead of 'US'
      test.md:45:26:18F.Abbreviations:Use 'U.S.' instead of 'USA'
      """

  Scenario: Lint against MailChimp
    When I apply style "MailChimp"
    Then the output should contain exactly:
      """
      test.md:1:70:MailChimp.SentenceLength:Write short sentences (less than 25 words).
      test.md:3:5:MailChimp.Ages:Don’t refer to people using age-related descriptors like "young."
      test.md:3:24:MailChimp.Quotes:Punctuation should be inside the quotes.
      test.md:5:1:MailChimp.Exclamation:Use exclamation points sparingly, and never more than one at a time.
      test.md:5:22:MailChimp.Avoid:Avoid using “rockstar.”
      test.md:7:1:MailChimp.NumbersStart:Spell out a number when it begins a sentence.
      test.rst:1:70:MailChimp.SentenceLength:Write short sentences (less than 25 words).
      test.rst:3:5:MailChimp.Ages:Don’t refer to people using age-related descriptors like "young."
      test.rst:3:24:MailChimp.Quotes:Punctuation should be inside the quotes.
      test.rst:5:1:MailChimp.Exclamation:Use exclamation points sparingly, and never more than one at a time.
      test.rst:5:22:MailChimp.Avoid:Avoid using “rockstar.”
      test.rst:7:1:MailChimp.NumbersStart:Spell out a number when it begins a sentence.
      test.txt:3:5:MailChimp.Ages:Don’t refer to people using age-related descriptors like "young."
      test.txt:3:24:MailChimp.Quotes:Punctuation should be inside the quotes.
      test.txt:5:1:MailChimp.Exclamation:Use exclamation points sparingly, and never more than one at a time.
      test.txt:5:22:MailChimp.Avoid:Avoid using “rockstar.”
      """

  Scenario: Lint against OpenStack
    When I apply style "OpenStack"
    Then the output should contain exactly:
      """
      test.rst:1:58:OpenStack.This:Do not overuse “this”
      test.rst:24:1:OpenStack.Branding:Use “OpenStack” instead of “openstack”
      test.rst:24:11:OpenStack.Contractions:Generally, do not contract the words such as “can't”.
      test.rst:24:17:OpenStack.Branding:Use “OpenStack” instead of “open stack”
      test.rst:26:37:OpenStack.Backend:Use “back end(s)” instead of “back-ends”
      test.rst:26:71:OpenStack.Backend:Use “back-end(s)” instead of “back end”
      test.rst:32:14:OpenStack.Login:Use “login” instead of “log in”
      test.rst:32:83:OpenStack.Login:Use “log in” instead of “login”
      test.rst:36:45:OpenStack.Contractions:Generally, do not contract the words such as “don't”.
      test.rst:36:51:OpenStack.Login:Use “log in” or “login” instead of “log-in”
      test.rst:38:11:OpenStack.Setup:Use “set up” instead of “setup”
      """

  Scenario: Lint against proselint
    When I apply style "proselint"
    Then the output should contain exactly:
      """
      test.md:1:19:proselint.Nonwords:Consider using 'regardless' instead of 'irregardless'.
      test.md:3:18:proselint.Archaisms:'perchance' is archaic.
      test.md:7:6:proselint.Cliches:'a chip off the old block' is a cliche.
      test.md:9:12:proselint.Cliches:'a fate worse than death' is a cliche.
      test.md:11:20:proselint.Spelling:Inconsistent spelling of 'color'.
      test.md:11:61:proselint.Spelling:Inconsistent spelling of 'center'.
      test.md:13:9:proselint.CorporateSpeak:'circle back around' is corporate speak.
      test.md:15:5:proselint.Cursing:Consider replacing 'shit'.
      test.md:17:16:proselint.DateCase:With lowercase letters, the periods are standard.
      test.md:17:37:proselint.DateSpacing:It's standard to put a space before '7a.m.'
      test.md:17:58:proselint.DateMidnight:Use 'midnight' or 'noon'.
      test.md:17:81:proselint.DateRedundancy:'a.m.' is always morning; 'p.m.' is always night.
      test.md:19:18:proselint.Uncomparables:'most correct' is not comparable
      test.md:21:1:proselint.Hedging:'I would argue that' is hedging.
      test.md:23:4:proselint.Hyperbole:'exaggerated!!!' is hyperbolic.
      test.md:25:14:proselint.Jargon:'in the affirmative' is jargon.
      test.md:27:10:proselint.Illusions:'the the' - There's a lexical illusion here.
      test.md:29:14:proselint.LGBTOffensive:'fag' is offensive. Remove it or consider the context.
      test.md:29:44:proselint.LGBTTerms:Consider using 'sexual orientation' instead of 'sexual preference'.
      test.md:31:10:proselint.Malapropisms:'the Infinitesimal Universe' is a malapropism.
      test.md:33:1:proselint.Apologizing:Excessive apologizing: 'More research is needed'
      test.md:35:1:proselint.But:Do not start a paragraph with a 'but'.
      test.md:37:9:proselint.Currency:Incorrect use of symbols in '$10 dollars'.
      test.md:39:14:proselint.Oxymorons:'exact estimate' is an oxymoron.
      test.md:41:38:proselint.GenderBias:Consider using 'lawyer' instead of 'lady lawyer'.
      test.md:43:11:proselint.Skunked:'impassionate' is a bit of a skunked term — impossible to use without issue.
      test.md:45:21:proselint.DenzienLabels:Did you mean 'Hong Konger'?
      test.md:47:13:proselint.AnimalLabels:Consider using 'avine' instead of 'bird-like'.
      test.md:49:20:proselint.Typography:Consider using the '©' symbol instead of '(C)'.
      test.md:49:40:proselint.Typography:Consider using the '™' symbol instead of '(tm)'.
      test.md:49:56:proselint.Typography:Consider using the '®' symbol instead of '(R)'.
      test.md:49:79:proselint.Typography:Consider using the '×' symbol instead of '2 x 2'.
      test.md:51:27:proselint.Diacritical:Consider using 'Beyoncé' instead of 'Beyonce'.
      test.md:51:36:proselint.P-Value:You should use more decimal places, unless 'p = 0.00' is really true.
      test.md:51:47:proselint.Needless:Prefer 'abolition' over 'abolishment'
      """

  Scenario: Lint against Rust
    When I apply style "Rust"
    Then the output should contain exactly:
      """
      test.md:1:4:Rust.Titles:'Generating a secret number' should be in title case
      test.md:3:26:Rust.Methods:Remove parentheses from 'read_line()`'
      test.md:5:1:Rust.Titles:'Matching Ranges of Values with `***` foo bar' should be in title case
      test.md:7:16:Rust.Methods:Remove parentheses from 'connect()`'
      test.md:7:46:Rust.Methods:Remove parentheses from 'connect()`'
      """

  Scenario: Lint against GCC
    When I apply style "GCC"
    Then the output should contain exactly:
      """
      test.md:1:1:GCC.Terms:Use 'Red Hat' instead of 'RedHat'
      test.md:1:43:GCC.Terms:Use 'free software' instead of 'open source'
      test.md:3:15:GCC.Bugfix:Use 'bug fix' (noun) or 'bug-fix' (adjective) instead of 'bugfix'
      test.md:3:26:GCC.Terms:Use 'GNU/Linux' instead of 'Linux'
      test.md:3:32:GCC.Terms:Use 'bit-field(s)' instead of 'bitfields'
      test.md:3:75:GCC.Terms:Use 'Microsoft Windows' instead of 'Windows'
      test.md:3:98:GCC.Backend:Use 'back-end' instead of 'back end'
      """

  Scenario: Lint against PlainLanguage
    When I apply style "PlainLanguage"
    Then the output should contain exactly:
      """
      test.adoc:1:14:PlainLanguage.Slash:Use either 'or' or 'and' in 'db/retract'
      test.adoc:1:31:PlainLanguage.ComplexWords:Consider using 'give' or 'offer' instead of 'provide'
      test.adoc:1:39:PlainLanguage.PassiveVoice:'be retracted' is passive voice
      test.adoc:1:60:PlainLanguage.ComplexWords:Consider using 'give' or 'offer' instead of 'provide'
      test.adoc:2:6:PlainLanguage.PassiveVoice:'be retracted' is passive voice
      test.adoc:4:10:PlainLanguage.Slash:Use either 'or' or 'and' in 'db/noHistory'
      test.adoc:6:17:PlainLanguage.Slash:Use either 'or' or 'and' in 'fn/retractEntity'
      test.adoc:7:32:PlainLanguage.PassiveVoice:'be retracted' is passive voice
      test.cs:2:19:PlainLanguage.Wordiness:Consider using 'across' instead of 'all across'
      test.cs:5:45:PlainLanguage.PassiveVoice:'be named' is passive voice
      test.cs:10:4:PlainLanguage.Wordiness:Consider using 'most' instead of 'A large majority of'
      test.cs:10:45:PlainLanguage.Wordiness:Consider using 'time' instead of 'time period'
      test.md:1:68:PlainLanguage.Contractions:Use 'aren't' instead of 'are not.'
      test.md:7:1:PlainLanguage.SentenceLength:Keep sentences short and to the point
      test.md:7:39:PlainLanguage.Wordiness:Consider using 'some' instead of 'some of the'
      test.md:7:88:PlainLanguage.PassiveVoice:'been implemented' is passive voice
      test.md:7:212:PlainLanguage.Contractions:Use 'haven't' instead of 'have not.'
      test.md:7:221:PlainLanguage.PassiveVoice:'been implemented' is passive voice
      test.md:7:266:PlainLanguage.PassiveVoice:'be mixed' is passive voice
      test.md:7:371:PlainLanguage.PassiveVoice:'are covered' is passive voice
      test.md:7:399:PlainLanguage.SentenceLength:Keep sentences short and to the point
      test.md:7:555:PlainLanguage.Slash:Use either 'or' or 'and' in 'io/repl'
      test.rst:8:51:PlainLanguage.PassiveVoice:'be prompted' is passive voice
      test.rst:9:49:PlainLanguage.ComplexWords:Consider using 'ask' instead of 'request'
      test.rst:9:57:PlainLanguage.PassiveVoice:'is sent' is passive voice
      test.rst:17:51:PlainLanguage.PassiveVoice:'be omitted' is passive voice
      test.rst:23:11:PlainLanguage.PassiveVoice:'be applied' is passive voice
      test.rst:27:1:PlainLanguage.PassiveVoice:'be used' is passive voice
      test.sass:4:16:PlainLanguage.ComplexWords:Consider using 'plenty' instead of 'abundance'
      test.sass:5:13:PlainLanguage.ComplexWords:Consider using 'use' instead of 'utilize'
      test.swift:3:47:PlainLanguage.PassiveVoice:'were eaten' is passive voice
      test.swift:5:38:PlainLanguage.PassiveVoice:'was faxed' is passive voice
      """
