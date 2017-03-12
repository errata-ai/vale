Feature: Lint

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

  Scenario: Lint an LaTeX file
    When I lint "test.tex"
    Then the output should contain exactly:
    """
    test.tex:148:77:vale.Annotations:'XXX' left in text
    test.tex:178:35:vale.Annotations:'FIXME' left in text
    test.tex:236:25:vale.Annotations:'TODO' left in text

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
