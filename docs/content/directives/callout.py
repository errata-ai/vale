import markdown


def main(content, title="", classes=[]):
    """Generate a 'Material for MkDocs' admonition.
    """
    md = markdown.markdown(content)
    return '<div class="admonition {0}">\n'.format(" ".join(classes)) + \
           '    <p class="admonition-title">{0}</p>\n'.format(title) + \
           '    <p>{0}</p>\n'.format(md) + \
           '</div>'
