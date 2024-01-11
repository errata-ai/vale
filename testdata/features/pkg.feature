Feature: Packages

    Scenario: Sync a complete, v3 package
        When I sync pkg "complete"
        Then the output should contain:
            """
            test.md:11:1:Vale.Spelling:Did you really mean 'peut'?
            test.md:13:11:v3.MyProduct:Using 'easy' may come across as condescending.
            """
        And the exit status should be 1

    Scenario: Sync a style-only package
        When I sync pkg "style"
        Then the output should contain:
            """
            test.md:3:5:Vale.Spelling:Did you really mean 'Myproduct'?
            test.md:7:5:Vale.Spelling:Did you really mean 'Myproduct'?
            test.md:9:34:write-good.Passive:'be flagged' may be passive voice. Use active voice if you can.
            test.md:11:1:Vale.Spelling:Did you really mean 'peut'?
            test.md:13:11:write-good.Weasel:'very' is a weasel word!
            """
        And the exit status should be 1

    Scenario: Sync a config-only package
        When I sync pkg "config"
        Then the output should contain:
            """
            test.md:3:5:Vale.Spelling:Did you really mean 'Myproduct'?
            test.md:7:5:Vale.Spelling:Did you really mean 'Myproduct'?
            test.md:11:1:Vale.Spelling:Did you really mean 'peut'?
            """
        And the exit status should be 1