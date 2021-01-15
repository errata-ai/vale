Feature: Lint

  Scenario: Lint a path with excluded folders
    When I lint path with exclusions
    Then the output should contain exactly:
      """
      """
    And the exit status should be 0

  Scenario: Lint a Sphinx file
    When I lint Sphinx "index.rst"
    Then the output should contain exactly:
      """
      index.rst:14:13:Vale.Repetition:'to' is repeated!
      index.rst:19:1:Vale.Spelling:Did you really mean 'documentarians'?
      index.rst:20:22:Vale.Repetition:'and' is repeated!
      """
    And the exit status should be 1

  Scenario: Lint a AsciiDoc file
    When I lint AsciiDoc "test.adoc"
    Then the output should contain exactly:
      """
      test.adoc:1:24:Test.Rule:Use 'Web source' instead of 'Web Source'.
      test.adoc:3:33:Test.Rule:Use 'Web source' instead of 'web Source'.
      test.adoc:9:33:Test.Rule:Use 'Web sources' instead of 'web sources'.
      test.adoc:11:36:Test.Rule:Use 'Web source' instead of 'Web Source'.
      test.adoc:13:23:Test.Rule:Use 'Web sources' instead of 'Web Sources'.
      test.adoc:15:4:Test.Rule:Use 'Web source' instead of 'Web Source'.
      test.adoc:17:30:Test.Rule:Use 'Web source' instead of 'Web Source'.
      test.adoc:19:12:Test.Rule:Use 'Web source' instead of 'Web Source'.
      test.adoc:19:23:Test.Rule:Use 'Web source' instead of 'web source'.
      test.adoc:19:46:Test.Rule:Use 'Web sources' instead of 'Web Sources'.
      test.adoc:19:58:Test.Rule:Use 'Web sources' instead of 'web sources'.
      test.adoc:22:3:Test.Rule:Use 'Web source' instead of 'Web Source'.
      test.adoc:23:3:Test.Rule:Use 'Web source' instead of 'web source'.
      test.adoc:25:3:Test.Rule:Use 'Web sources' instead of 'Web Sources'.
      test.adoc:26:3:Test.Rule:Use 'Web sources' instead of 'web sources'.
      test.adoc:30:2:Test.Rule:Use 'Web source' instead of 'Web Source'.
      test.adoc:31:2:Test.Rule:Use 'Web source' instead of 'web source'.
      test.adoc:34:2:Test.Rule:Use 'Web source' instead of 'Web Source'.
      test.adoc:35:2:Test.Rule:Use 'Web source' instead of 'web source'.
      test.adoc:38:2:Test.Rule:Use 'Web sources' instead of 'Web Sources'.
      test.adoc:39:2:Test.Rule:Use 'Web sources' instead of 'web sources'.
      """
    And the exit status should be 1

  Scenario: Lint a AsciiDoc file with a listing block
    When I lint AsciiDoc "test2.adoc"
    Then the output should contain exactly:
      """
      test2.adoc:3:17:Test.Rule2:Consider using 'AsciiDoc' instead of 'Asciidoc'
      test2.adoc:11:16:Test.Rule2:Consider using 'AsciiDoc' instead of 'asciidoc'
      test2.adoc:19:16:Test.Rule2:Consider using 'AsciiDoc' instead of 'asciidoc'
      """
    And the exit status should be 1

  Scenario: Lint a DITA file
    When I lint "test.dita"
    Then the output should contain exactly:
      """
      test.dita:20:82:vale.Annotations:'TODO' left in text
      test.dita:25:21:vale.Annotations:'NOTE' left in text
      """
    And the exit status should be 0

  Scenario: Lint an XML file
    When I lint "test.xml"
    Then the output should contain exactly:
      """
      test.xml:19:34:vale.Annotations:'TODO' left in text
      test.xml:23:21:vale.Annotations:'XXX' left in text
      test.xml:24:53:vale.Annotations:'FIXME' left in text
      """
    And the exit status should be 0

  Scenario: Lint a JSON file
    When I lint "test.json"
    Then the output should contain exactly:
      """
      test.json:9:10:vale.Annotations:'XXX' left in text
      test.json:12:19:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0

  Scenario: Lint a Plain Text file
    When I lint "test.txt"
    Then the output should contain exactly:
      """
      test.txt:1:27:vale.Annotations:'NOTE' left in text
      test.txt:4:12:vale.Annotations:'XXX' left in text
      test.txt:4:66:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0

  Scenario: Lint an AsciiDoc file
    When I lint "test.adoc"
    Then the output should contain exactly:
      """
      test.adoc:10:39:vale.Annotations:'TODO' left in text
      test.adoc:29:27:vale.Annotations:'XXX' left in text
      test.adoc:44:1:vale.Annotations:'TODO' left in text
      test.adoc:59:1:vale.Annotations:'FIXME' left in text
      test.adoc:59:21:vale.Annotations:'TODO' left in text
      test.adoc:59:27:vale.Annotations:'XXX' left in text
      test.adoc:64:38:vale.Annotations:'XXX' left in text
      test.adoc:66:20:vale.Annotations:'TODO' left in text
      test.adoc:75:16:vale.Annotations:'TODO' left in text
      test.adoc:79:6:vale.Annotations:'NOTE' left in text
      test.adoc:86:6:vale.Annotations:'NOTE' left in text
      """
    And the exit status should be 0

  Scenario: Lint a Python file
    When I lint "test.py"
    Then the output should contain exactly:
      """
      test.py:1:3:vale.Annotations:'FIXME' left in text
      test.py:5:5:vale.Annotations:'FIXME' left in text
      test.py:11:3:vale.Annotations:'XXX' left in text
      test.py:13:16:vale.Annotations:'XXX' left in text
      test.py:14:14:vale.Annotations:'NOTE' left in text
      test.py:17:1:vale.Annotations:'NOTE' left in text
      test.py:23:1:vale.Annotations:'XXX' left in text
      test.py:28:5:vale.Annotations:'NOTE' left in text
      test.py:35:8:vale.Annotations:'NOTE' left in text
      test.py:37:5:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0

  Scenario: Lint a C++ file
    When I lint "test.cc"
    Then the output should contain exactly:
      """
      test.cc:1:4:vale.Annotations:'XXX' left in text
      test.cc:9:6:vale.Annotations:'NOTE' left in text
      test.cc:13:6:vale.Annotations:'XXX' left in text
      test.cc:17:5:vale.Annotations:'FIXME' left in text
      test.cc:20:5:vale.Annotations:'XXX' left in text
      test.cc:23:37:vale.Annotations:'XXX' left in text
      """
    And the exit status should be 0

  Scenario: Lint a Markdown file
    When I lint "test.md"
    Then the output should contain exactly:
      """
      test.md:3:1:vale.Annotations:'NOTE' left in text
      test.md:32:1:vale.Annotations:'XXX' left in text
      test.md:34:29:vale.Annotations:'TODO' left in text
      test.md:36:3:vale.Annotations:'TODO' left in text
      test.md:36:10:vale.Annotations:'XXX' left in text
      test.md:36:16:vale.Annotations:'FIXME' left in text
      test.md:40:21:vale.Annotations:'FIXME' left in text
      test.md:44:5:vale.Annotations:'TODO' left in text
      test.md:46:3:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0

  Scenario: Lint an assigned Markdown file
    When I lint file "test.xyz" as ".md"
    Then the output should contain exactly:
      """
      test.xyz:3:1:vale.Annotations:'NOTE' left in text
      test.xyz:32:1:vale.Annotations:'XXX' left in text
      test.xyz:34:29:vale.Annotations:'TODO' left in text
      test.xyz:36:3:vale.Annotations:'TODO' left in text
      test.xyz:36:10:vale.Annotations:'XXX' left in text
      test.xyz:36:16:vale.Annotations:'FIXME' left in text
      test.xyz:40:21:vale.Annotations:'FIXME' left in text
      test.xyz:44:5:vale.Annotations:'TODO' left in text
      test.xyz:46:3:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0

  Scenario: Lint an MDX file
    When I lint "test.mdx"
    Then the output should contain exactly:
      """
      test.mdx:3:1:vale.Annotations:'NOTE' left in text
      test.mdx:32:1:vale.Annotations:'XXX' left in text
      test.mdx:34:29:vale.Annotations:'TODO' left in text
      test.mdx:36:3:vale.Annotations:'TODO' left in text
      test.mdx:36:10:vale.Annotations:'XXX' left in text
      test.mdx:36:16:vale.Annotations:'FIXME' left in text
      test.mdx:40:21:vale.Annotations:'FIXME' left in text
      test.mdx:44:5:vale.Annotations:'TODO' left in text
      test.mdx:46:3:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0

  Scenario: Lint a reStructuredText file
    When I lint "test.rst"
    Then the output should contain exactly:
      """
      test.rst:4:34:vale.Annotations:'XXX' left in text
      test.rst:37:45:vale.Annotations:'TODO' left in text
      test.rst:58:1:vale.Annotations:'NOTE' left in text
      test.rst:60:40:vale.Annotations:'TODO' left in text
      test.rst:63:3:vale.Annotations:'TODO' left in text
      test.rst:63:29:vale.Annotations:'XXX' left in text
      test.rst:69:3:vale.Annotations:'FIXME' left in text
      test.rst:75:3:vale.Annotations:'TODO' left in text
      test.rst:75:38:vale.Annotations:'XXX' left in text
      test.rst:81:10:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0

  Scenario: Lint a Rust file
    When I lint "test.rs"
    Then the output should contain exactly:
      """
      test.rs:1:5:vale.Annotations:'NOTE' left in text
      test.rs:3:5:vale.Annotations:'XXX' left in text
      test.rs:5:17:vale.Annotations:'TODO' left in text
      test.rs:7:4:vale.Annotations:'FIXME' left in text
      test.rs:9:5:vale.Annotations:'XXX' left in text
      """
    And the exit status should be 0

  Scenario: Lint an R file
    When I lint "test.r"
    Then the output should contain exactly:
      """
      test.r:1:3:vale.Annotations:'NOTE' left in text
      test.r:6:22:vale.Annotations:'XXX' left in text
      """
    And the exit status should be 0

  Scenario: Lint a PHP file
    When I lint "test.php"
    Then the output should contain exactly:
      """
      test.php:2:31:vale.Annotations:'XXX' left in text
      test.php:3:8:vale.Annotations:'NOTE' left in text
      test.php:4:8:vale.Annotations:'FIXME' left in text
      test.php:6:33:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0

  Scenario: Lint a Lua file
    When I lint "test.lua"
    Then the output should contain exactly:
      """
      test.lua:1:4:vale.Annotations:'NOTE' left in text
      test.lua:2:19:vale.Annotations:'XXX' left in text
      test.lua:5:7:vale.Annotations:'NOTE' left in text
      test.lua:9:6:vale.Annotations:'XXX' left in text
      test.lua:15:4:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0

  Scenario: Lint a Haskell file
    When I lint "test.hs"
    Then the output should contain exactly:
      """
      test.hs:2:4:vale.Annotations:'NOTE' left in text
      test.hs:5:6:vale.Annotations:'TODO' left in text
      test.hs:6:25:vale.Annotations:'XXX' left in text
      test.hs:11:41:vale.Annotations:'XXX' left in text
      """
    And the exit status should be 0

  Scenario: Lint a Ruby file
    When I lint "test.rb"
    Then the output should contain exactly:
      """
      test.rb:2:1:vale.Annotations:'NOTE' left in text
      test.rb:6:1:vale.Annotations:'XXX' left in text
      test.rb:9:23:vale.Annotations:'XXX' left in text
      test.rb:11:3:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0


  Scenario: Lint an assigned format
    When I lint path "subdir3"
    Then the output should contain exactly:
      """
      test.mdx:3:1:vale.Annotations:'NOTE' left in text
      test.mdx:32:1:vale.Annotations:'XXX' left in text
      test.mdx:34:29:vale.Annotations:'TODO' left in text
      test.mdx:36:3:vale.Annotations:'TODO' left in text
      test.mdx:36:10:vale.Annotations:'XXX' left in text
      test.mdx:36:16:vale.Annotations:'FIXME' left in text
      test.mdx:40:21:vale.Annotations:'FIXME' left in text
      test.mdx:44:5:vale.Annotations:'TODO' left in text
      test.mdx:46:3:vale.Annotations:'TODO' left in text
      """
    And the exit status should be 0
