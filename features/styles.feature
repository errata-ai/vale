Feature: Styles
  Scenario: Lint against write-good
    When I apply style "write-good"
    Then the output should contain exactly:
      """
      test.cc:1:4:write-good.Weasel:'Remarkably' is a weasel word!
      test.cc:1:15:write-good.Weasel:'few' is a weasel word!
      test.cc:8:27:write-good.Cliches:'at loose ends' is a cliché
      test.cc:11:40:write-good.Passive:'was killed'
      test.cc:18:6:write-good.Illusions:'the' is repeated!
      test.cc:21:25:write-good.ThereIs:Don't start a sentence with '// There are'
      test.cc:28:21:write-good.ThereIs:Don't start a sentence with '// There is'
      test.cc:31:21:write-good.So:Don't start a sentence with '; so'
      test.cc:34:14:write-good.So:Don't start a sentence with '// So'
      test.md:1:1:write-good.Weasel:'Remarkably' is a weasel word!
      test.md:1:12:write-good.Weasel:'few' is a weasel word!
      test.md:3:12:write-good.Passive:'was killed'
      test.md:5:1:write-good.Illusions:'the' is repeated!
      test.md:10:1:write-good.Illusions:'the' is repeated!
      test.md:14:1:write-good.So:Don't start a sentence with 'So'
      test.md:23:15:write-good.So:Don't start a sentence with '; so'
      test.md:25:1:write-good.ThereIs:Don't start a sentence with 'There is'
      test.md:27:1:write-good.ThereIs:Don't start a sentence with 'There are'
      test.md:29:18:write-good.Weasel:'simply' is a weasel word!
      test.md:31:18:write-good.Weasel:'extremely' is a weasel word!
      test.md:33:8:write-good.Passive:'been said'
      test.md:33:23:write-good.Weasel:'few' is a weasel word!
      test.md:35:1:write-good.TooWordy:'As a matter of fact' is too wordy
      test.md:37:32:write-good.TooWordy:'impacted' is too wordy
      test.md:39:23:write-good.Cliches:'at loose ends' is a cliché
      test.md:41:1:write-good.So:Don't start a sentence with 'So,'
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
      test.md:1:1:demo.Reading:Grade level (8.24) too high!
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
      test.md:30:38:demo.EndingPreposition:Don't end a sentence with 'of.'
      test.md:32:61:demo.EndingPreposition:Don't end a sentence with 'by.'
      test.rst:1:22:demo.CommasPerSentence:More than 3 commas!
      test.rst:1:58:demo.Spacing:'. I' should have one space
      test.rst:3:1:demo.SentenceLength:Sentences should be less than 25 words
      test.rst:5:28:demo.EndingPreposition:Don't end a sentence with 'by.'
      test.rst:9:1:demo.ParagraphLength:Paragraphs should be less than 150 words
      test.rst:20:25:demo.Spelling:Inconsistent spelling of 'center'
      test.rst:24:32:demo.Spelling:Inconsistent spelling of 'colour'
      test.rst:26:1:demo.Sentence:'Section Title' should be in sentence case
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
      """"
