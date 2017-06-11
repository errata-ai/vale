Feature: CLI
  Scenario: Lint a file and a directory
    When I lint "test.json subdir1"
    Then the output should contain exactly:
    """
    subdir1/test.hs:2:4:vale.Annotations:'NOTE' left in text
    subdir1/test.hs:5:6:vale.Annotations:'TODO' left in text
    subdir1/test.hs:6:25:vale.Annotations:'XXX' left in text
    subdir1/test.hs:11:41:vale.Annotations:'XXX' left in text
    subdir1/test.rs:1:5:vale.Annotations:'NOTE' left in text
    subdir1/test.rs:3:5:vale.Annotations:'XXX' left in text
    subdir1/test.rs:5:17:vale.Annotations:'TODO' left in text
    subdir1/test.rs:7:4:vale.Annotations:'FIXME' left in text
    subdir1/test.rs:9:5:vale.Annotations:'XXX' left in text
    test.json:9:10:vale.Annotations:'XXX' left in text
    test.json:12:19:vale.Annotations:'TODO' left in text
    """
    And the exit status should be 0

  Scenario: Lint 2 directories
    When I lint "subdir1 subdir2"
    Then the output should contain exactly:
    """
    subdir1/test.hs:2:4:vale.Annotations:'NOTE' left in text
    subdir1/test.hs:5:6:vale.Annotations:'TODO' left in text
    subdir1/test.hs:6:25:vale.Annotations:'XXX' left in text
    subdir1/test.hs:11:41:vale.Annotations:'XXX' left in text
    subdir1/test.rs:1:5:vale.Annotations:'NOTE' left in text
    subdir1/test.rs:3:5:vale.Annotations:'XXX' left in text
    subdir1/test.rs:5:17:vale.Annotations:'TODO' left in text
    subdir1/test.rs:7:4:vale.Annotations:'FIXME' left in text
    subdir1/test.rs:9:5:vale.Annotations:'XXX' left in text
    subdir2/test.lua:1:4:vale.Annotations:'NOTE' left in text
    subdir2/test.lua:2:19:vale.Annotations:'XXX' left in text
    subdir2/test.lua:5:7:vale.Annotations:'NOTE' left in text
    subdir2/test.lua:9:6:vale.Annotations:'XXX' left in text
    subdir2/test.lua:15:4:vale.Annotations:'TODO' left in text
    """
    And the exit status should be 0

  Scenario: Lint 2 files
    When I lint "test.json test.txt"
    Then the output should contain exactly:
    """
    test.json:9:10:vale.Annotations:'XXX' left in text
    test.json:12:19:vale.Annotations:'TODO' left in text
    test.txt:1:27:vale.Annotations:'NOTE' left in text
    test.txt:4:12:vale.Annotations:'XXX' left in text
    test.txt:4:66:vale.Annotations:'TODO' left in text
    """
    And the exit status should be 0

  Scenario: Lint 3 files
    When I lint "test.json test.txt test.cc"
    Then the output should contain exactly:
    """
    test.cc:1:4:vale.Annotations:'XXX' left in text
    test.cc:9:6:vale.Annotations:'NOTE' left in text
    test.cc:13:6:vale.Annotations:'XXX' left in text
    test.cc:17:5:vale.Annotations:'FIXME' left in text
    test.cc:20:5:vale.Annotations:'XXX' left in text
    test.cc:23:37:vale.Annotations:'XXX' left in text
    test.json:9:10:vale.Annotations:'XXX' left in text
    test.json:12:19:vale.Annotations:'TODO' left in text
    test.txt:1:27:vale.Annotations:'NOTE' left in text
    test.txt:4:12:vale.Annotations:'XXX' left in text
    test.txt:4:66:vale.Annotations:'TODO' left in text
    """
    And the exit status should be 0
