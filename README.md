# Vale: Your style, our editor [![Build status](https://ci.appveyor.com/api/projects/status/snk0oo6ih1nwuf6r?svg=true)](https://ci.appveyor.com/project/jdkato/vale) [![Go Report Card](https://img.shields.io/badge/%F0%9F%93%9D%20%20go%20report-A%2B-75C46B?color=00ACD7)](https://goreportcard.com/report/github.com/errata-ai/vale) [![GitHub All Releases](https://img.shields.io/github/downloads/errata-ai/vale/total?logo=GitHub&color=ff69b4)](https://github.com/errata-ai/vale/releases) [![Docker Pulls](https://img.shields.io/docker/pulls/jdkato/vale?color=orange&logo=docker&logoColor=white)](https://hub.docker.com/r/jdkato/vale) [![Chocolatey](https://img.shields.io/chocolatey/dt/vale?color=white&label=chocolatey&logo=chocolatey)](https://community.chocolatey.org/packages/vale) [![Homebrew](https://img.shields.io/homebrew/installs/dy/vale?color=yellow&label=homebrew&logo=homebrew)](https://formulae.brew.sh/formula/vale)

<p align="center">
  <b>Vale</b> is a command-line tool that brings code-like linting to prose. It's <b><a href="#mag-at-a-glance-vale-vs-">fast</a></b>, <b>cross-platform</b> (Windows, macOS, and Linux), and <b>highly customizable</b>.
</p>

<p align="center">
  <img width="75%" alt="A demo screenshot." src="https://vale.sh/images/vale/mac.png">
</p>

<div align="center">
<table>
<thead>
<tr>
<th><a href="https://vale.sh/docs/vale-cli/installation/">Docs</a></th>
<th><a href="https://studio.vale.sh/">Vale Studio</a></th>
<th><a href="https://vale.sh/hub/">Package Hub</a></th>
<th><a href="https://vale.sh/explorer/">Rule Explorer</a></th>
<th><a href="https://vale.sh/generator/">Config Generator</a></th>
</tr>
</thead>
</table>
</div>

## :heart: Sponsors

> Hi there! I'm [@jdkato](https://github.com/jdkato), the sole developer of Vale. If you'd like to help me dedicate more time to _developing_, _documenting_, and _supporting_ Vale, feel free to donate through [GitHub Sponsors](https://github.com/sponsors/jdkato) or [Open Collective](https://opencollective.com/vale). Any donation&mdash;big, small, one-time, or recurring&mdash;is greatly appreciated!

### Organizations

<a href="https://opencollective.com/vale/organization/0/website"><img src="https://opencollective.com/vale/organization/0/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/1/website"><img src="https://opencollective.com/vale/organization/1/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/2/website"><img src="https://opencollective.com/vale/organization/2/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/3/website"><img src="https://opencollective.com/vale/organization/3/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/4/website"><img src="https://opencollective.com/vale/organization/4/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/5/website"><img src="https://opencollective.com/vale/organization/5/avatar.svg?avatarHeight=100"></a>

### Other

> Thanks to [DigitalOcean][1] for providing hosting credits for [Vale Studio][2].

<p>
  <a href="https://www.digitalocean.com/">
    <img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/PoweredByDO/DO_Powered_by_Badge_blue.svg" width="201px">
  </a>
</p>

> Thanks to [Appwrite][4] for supporting Vale through their [Open Source Sponsorship program][3].

<p>
  <a href="https://appwrite.io/">
    <img src="https://github.com/errata-ai/vale/assets/8785025/95d4b2f8-a94b-4512-8197-7e80973655cc" width="201px">
  </a>
</p>

### Individuals

<a href="https://opencollective.com/vale"><img src="https://opencollective.com/vale/individuals.svg?width=890"></a>

## :boom: Key Features

- [x] **Support for markup**: Vale has a rich understanding of many [markup formats](https://vale.sh/docs/topics/scoping/#formats), allowing it to avoid syntax-related false positives and intelligently exclude code snippets from prose-related rules.

- [x] A **highly customizable** [extension system](https://vale.sh/docs/topics/styles/): Vale is capable of enforcing _your style_&mdash;be it a standard [editorial style guide](https://github.com/errata-ai/styles#available-styles) or a custom in-house set of rules (see [examples][6]).

- [x] **Easy-to-install**, stand-alone binaries: Unlike other tools, Vale doesn't require you to install and configure a particular programming language and its related tooling (such as Python/pip or Node.js/npm).

See the [documentation](https://vale.sh) for more information.

## :mag: At a Glance: Vale vs. `<...>`

> **NOTE**: While all of the options listed below are open-source (CLI-based) linters for prose, their implementations and features vary significantly. And so, the "best" option will depends on your specific needs and preferences.

### Functionality

| Tool       | Extensible           | Checks          | Supports Markup                                                         | Built With | License      |
| ---------- | -------------------- | --------------- | ----------------------------------------------------------------------- | ---------- | ------------ |
| Vale       | Yes (via YAML)       | spelling, style | Yes (Markdown, AsciiDoc, reStructuredText, HTML, XML, Org)              | Go         | MIT          |
| textlint   | Yes (via JavaScript) | spelling, style | Yes (Markdown, AsciiDoc, reStructuredText, HTML, Re:VIEW)               | JavaScript | MIT          |
| RedPen     | Yes (via Java)       | spelling, style | Yes (Markdown, AsciiDoc, reStructuredText, Textile, Re:VIEW, and LaTeX) | Java       | Apache-2.0   |
| write-good | Yes (via JavaScript) | style           | No                                                                      | JavaScript | MIT          |
| proselint  | No                   | style           | No                                                                      | Python     | BSD 3-Clause |
| Joblint    | No                   | style           | No                                                                      | JavaScript | MIT          |
| alex       | No                   | style           | Yes (Markdown)                                                          | JavaScript | MIT          |

The exact definition of "Supports Markup" varies by tool but, in general, it means that the format is understood at a higher level than a regular plain-text file (for example, features like excluding code blocks from spell check).

Extensibility means that there's a built-in means of creating your own rules without modifying the original source code.

### Benchmarks

<table>
    <tr>
        <td width="50%">
            <a href="https://user-images.githubusercontent.com/8785025/97052257-809aa300-1535-11eb-83cd-65a52b29d6de.png">
                <img src="https://user-images.githubusercontent.com/8785025/97052257-809aa300-1535-11eb-83cd-65a52b29d6de.png" width="100%">
            </a>
        </td>
        <td width="50%">
            <a href="https://user-images.githubusercontent.com/8785025/97051175-91e2b000-1533-11eb-9a57-9d44d6def4c3.png">
                <img src="https://user-images.githubusercontent.com/8785025/97051175-91e2b000-1533-11eb-9a57-9d44d6def4c3.png" width="100%">
            </a>
        </td>
    </tr>
    <tr>
        <td width="50%">
          This benchmark has all three tools configured to use their implementations of the <code>write-good</code> rule set and Unix-style output.
        </td>
        <td width="50%">This benchmark runs Vale's implementation of <code>proselint</code>'s rule set against the original. Both tools are configured to use JSON output.</td>
    </tr>
    <tr>
        <td width="50%">
            <a href="https://user-images.githubusercontent.com/8785025/97053402-c5bfd480-1537-11eb-815b-a33ab13a59cf.png">
                <img src="https://user-images.githubusercontent.com/8785025/97053402-c5bfd480-1537-11eb-815b-a33ab13a59cf.png" width="100%">
            </a>
        </td>
        <td width="50%">
            <a href="https://user-images.githubusercontent.com/8785025/97055850-7b8d2200-153c-11eb-86fa-d882ce6babf8.png">
                <img src="https://user-images.githubusercontent.com/8785025/97055850-7b8d2200-153c-11eb-86fa-d882ce6babf8.png" width="100%">
            </a>
        </td>
    </tr>
    <tr>
        <td width="50%">
          This benchmark runs Vale's implementation of Joblint's rule set against the original. Both tools are configured to use JSON output.
        </td>
        <td width="50%">This benchmark has all three tools configured to perform only English spell checking using their default output styles.</td>
    </tr>
</table>

All benchmarking was performed using the open-source [hyperfine](https://github.com/sharkdp/hyperfine) tool on a MacBook Pro (2.9 GHz Intel Core i7):

```
hyperfine --warmup 3 '<command>'
```

The corpus IDs in the above plots&mdash;`gitlab` and `ydkjs`&mdash;correspond to the following files:

- A [snapshot](https://gitlab.com/gitlab-org/gitlab/-/tree/7d6a4025a0346f1f50d2825c85742e5a27b39a8b/doc) of GitLab's open-source documentation (1,500 Markdown files).

- A [chapter](https://raw.githubusercontent.com/getify/You-Dont-Know-JS/1st-ed/es6%20%26%20beyond/ch2.md) from the open-source book _You Don't Know JS_.

## :page_facing_up: License

[![FOSSA Status](https://app.fossa.com/api/projects/custom%2B21090%2Fgithub.com%2Ferrata-ai%2Fvale.svg?type=large)](https://app.fossa.com/projects/custom%2B21090%2Fgithub.com%2Ferrata-ai%2Fvale?ref=badge_large)

[1]: https://www.digitalocean.com/open-source/credits-for-projects
[2]: https://studio.vale.sh/
[3]: https://appwrite.io/oss-fund
[4]: https://appwrite.io/
[5]: https://page.famewall.io/vale
[6]: https://vale.sh/#users
