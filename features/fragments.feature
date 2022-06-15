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
            test.rb:2:23:Vale.Spelling:Did you really mean 'thre'?
            test.rb:6:6:Vale.Spelling:Did you really mean 'stil'?
            test.rb:9:36:Vale.Spelling:Did you really mean 'coment'?
            test.rb:11:16:Vale.Spelling:Did you really mean 'foof'?
            test.rb:11:21:Vale.Spelling:Did you really mean 'hopl'?
            test.rb:15:16:Vale.Spelling:Did you really mean 'foof'?
            test.rb:15:21:Vale.Spelling:Did you really mean 'hopll'?
            test.rb:17:16:Vale.Spelling:Did you really mean 'foof'?
            test.rb:17:21:Vale.Spelling:Did you really mean 'hopl'?
            test.rs:3:22:Vale.Spelling:Did you really mean 'representd'?
            test.rs:5:22:Vale.Spelling:Did you really mean 'representd'?
            test.rs:7:39:Vale.Spelling:Did you really mean 'mattter'?
            test.rs:16:35:Vale.Spelling:Did you really mean 'doof'?
            test.rs:18:11:Vale.Spelling:Did you really mean 'Exmples'?
            test2.py:16:5:Vale.Spelling:Did you really mean 'docmentation'?
            test2.py:60:5:Vale.Spelling:Did you really mean 'traceback'?
            test2.py:62:53:Vale.Spelling:Did you really mean 'traceback'?
            test2.py:100:9:Vale.Spelling:Did you really mean 'qualname'?
            test2.py:100:60:Vale.Spelling:Did you really mean 'qualname'?
            test2.py:139:11:Vale.Spelling:Did you really mean 'qualname'?
            test2.py:146:22:Vale.Spelling:Did you really mean 'qualname'?
            test2.py:187:38:Vale.Spelling:Did you really mean 'nuber'?
            test2.py:216:38:Vale.Spelling:Did you really mean 'pragma'?
            test2.py:219:35:Vale.Spelling:Did you really mean 'noqa'?
            test2.py:246:39:Vale.Spelling:Did you really mean 'vaiable'?
            test2.py:252:36:Vale.Spelling:Did you really mean 'vaiable'?
            test2.rs:47:42:Vale.Spelling:Did you really mean 'vrsion'?
            test2.rs:2829:34:Vale.Spelling:Did you really mean 'conlicts'?
            """