Feature: Fragments
    Scenario: Code -> Markup
        When I test "fragments"
        Then the output should contain exactly:
            """
            test.go:2:14:Vale.Spelling:Did you really mean 'implments'?
            test.go:10:4:Vale.Spelling:Did you really mean 'Println'?
            test.go:12:4:Vale.Spelling:Did you really mean 'Println'?
            test.go:12:54:Vale.Spelling:Did you really mean 'oprands'?
            test.py:3:13:Vale.Spelling:Did you really mean 'parap'?
            test.py:13:35:Vale.Spelling:Did you really mean 'vaiable'?
            test.py:18:29:Vale.Spelling:Did you really mean 'docmentation'?
            test.py:20:20:Vale.Spelling:Did you really mean 'ducmenation'?
            test.py:24:13:Vale.Spelling:Did you really mean 'parapp'?
            test2.py:16:5:Vale.Spelling:Did you really mean 'docmentation'?
            test2.py:60:5:Vale.Spelling:Did you really mean 'traceback'?
            test2.py:62:53:Vale.Spelling:Did you really mean 'traceback'?
            test2.py:139:11:Vale.Spelling:Did you really mean 'qualname'?
            test2.py:146:22:Vale.Spelling:Did you really mean 'qualname'?
            test2.py:187:38:Vale.Spelling:Did you really mean 'nuber'?
            test2.py:216:38:Vale.Spelling:Did you really mean 'pragma'?
            test2.py:219:35:Vale.Spelling:Did you really mean 'noqa'?
            test2.py:246:39:Vale.Spelling:Did you really mean 'vaiable'?
            test2.py:252:36:Vale.Spelling:Did you really mean 'vaiable'?
            """
