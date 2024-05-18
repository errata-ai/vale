Feature: Fragments
    Scenario: Code -> Markup
        When I test "fragments"
        Then the output should contain exactly:
            """
            test.go:2:14:Vale.Spelling:Did you really mean 'implments'?
            test.go:10:4:Vale.Spelling:Did you really mean 'Println'?
            test.go:12:4:Vale.Spelling:Did you really mean 'Println'?
            test.go:12:54:Vale.Spelling:Did you really mean 'oprands'?
            """
