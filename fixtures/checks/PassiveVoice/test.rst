Use `Github API`_ to post a comment on an
`issue <https://github.com/jkbrzt/httpie/issues/83>`_
with `authentication`_:

===================     ======================================================
``--auth, -a``          Pass a ``username:password`` pair as
                        the argument. Or, if you only specify a username
                        (``-a username``), you'll be prompted for
                        the password before the request is sent.
                        To send an empty password, pass ``username:``.
                        The ``username:password@hostname`` URL syntax is
                        supported as well (but credentials passed via ``-a``
                        have higher priority).

``--auth-type, -A``     Specify the auth mechanism. Possible values are
                        ``basic`` and ``digest``. The default value is
                        ``basic`` so it can often be omitted.
===================     ======================================================

Default behaviour
-----------------

1. should be applied.
