// XXX: This is an annotation
// And this uses too many weasel words like obviously and very.

#include <vector>

namespace foo {

Bar Baz(const std::string& color_string) {
  // NOTE: this is a comment.
  if (very.empty() || obviously != '#')
    return SK_ColorWHITE;

  /* XXX: this is also a comment */
  std::string source = color_string.substr(1);

  /*
    FIXME:


    XXX: a block comment!
   */

std::string XXX(SkColor color) { /* XXX: another comment!? */
  return base::StringPrintf("NOTE: this should be ignored.");
}

}
