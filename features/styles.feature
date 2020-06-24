Feature: Styles
  Scenario: Lint against demo
    When I apply style "demo"
    Then the output should contain exactly:
      """
      test.adoc:1:1:demo.SentenceLength:Sentences should be less than 25 words
      test.adoc:3:84:demo.Smart:Inconsistent use of '”' ('smart' mixed with 'dumb')
      test.adoc:5:6:demo.Contractions:Use 'are not' instead of 'aren’t'
      test.html:8:30:demo.CommasPerSentence:More than 3 commas!
      test.html:10:27:demo.Spacing:'.M' should have one space
      test.html:10:35:demo.Hyphen:' Randomly-' doesn't need a hyphen
      test.html:12:12:demo.SentenceLength:Sentences should be less than 25 words
      test.html:32:17:demo.HeadingStartsWithCapital:'this is a heading' should be capitalized
      test.md:1:3:demo.HeadingStartsWithCapital:'this is a heading' should be capitalized
      test.md:1:3:demo.Reading:Grade level (8.30) too high!
      test.md:7:1:demo.HeadingStartsWithCapital:'this is another heading!' should be capitalized
      test.md:12:1:demo.SentenceLength:Sentences should be less than 25 words
      test.md:14:121:demo.Filters:Did you really mean 'DBA'?
      test.md:14:159:demo.SentenceLength:Sentences should be less than 25 words
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
      test.md:36:1:demo.SentenceLength:Sentences should be less than 25 words
      test.md:36:101:demo.Smart:Inconsistent use of '"' ('smart' mixed with 'dumb')
      test.md:38:6:demo.Contractions:Use 'are not' instead of 'aren't'
      test.rst:1:22:demo.CommasPerSentence:More than 3 commas!
      test.rst:1:58:demo.Spacing:'. I' should have one space
      test.rst:3:1:demo.SentenceLength:Sentences should be less than 25 words
      test.rst:5:28:demo.EndingPreposition:Don't end a sentence with 'by.'
      test.rst:9:1:demo.ParagraphLength:Paragraphs should be less than 150 words
      test.rst:20:25:demo.Spelling:Inconsistent spelling of 'center'
      test.rst:24:32:demo.Spelling:Inconsistent spelling of 'colour'
      """
