# Vale: Your style, our editor [![Build Status](https://img.shields.io/travis/errata-ai/vale/master.svg?logo=travis)](https://travis-ci.org/errata-ai/vale) [![Go Report Card](https://img.shields.io/badge/%F0%9F%93%9D%20%20go%20report-A%2B-75C46B?color=00ACD7)](https://goreportcard.com/report/github.com/errata-ai/vale) ![GitHub All Releases](https://img.shields.io/github/downloads/errata-ai/vale/total?logo=GitHub&color=ff69b4) ![Docker Pulls](https://img.shields.io/docker/pulls/jdkato/vale?color=orange&logo=docker&logoColor=white)

<p align="center">
    <img src="https://user-images.githubusercontent.com/8785025/96957750-5eab0d00-14b0-11eb-9f5f-52d862518ebf.png">
</p>

<p align="center">
  <b>Vale</b> is a command-line tool that brings code-like linting to prose. It's <b><a href="#mag-at-a-glance-vale-vs-">Fast</a></b>, <b><a href="https://docs.errata.ai/vale/install">cross-platform</a></b> (Windows, macOS, and Linux), and <b><a href="https://docs.errata.ai/vale/styles">highly customizable</a></b>.
</p>

## :heart: Sponsors

> Hi there! I'm [@jdkato](https://github.com/jdkato), the sole developer of Vale. If you'd like to help me dedicate more time to *developing*, *documenting*, and *supporting* Vale, feel free to donate through the [Open Collective](https://opencollective.com/vale). Any donation&mdash;big, small, one-time, or recurring&mdash;is greatly appreciated!

<a href="https://opencollective.com/vale/organization/0/website"><img src="https://opencollective.com/vale/organization/0/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/1/website"><img src="https://opencollective.com/vale/organization/1/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/2/website"><img src="https://opencollective.com/vale/organization/2/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/3/website"><img src="https://opencollective.com/vale/organization/3/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/4/website"><img src="https://opencollective.com/vale/organization/4/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/5/website"><img src="https://opencollective.com/vale/organization/5/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/6/website"><img src="https://opencollective.com/vale/organization/6/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/7/website"><img src="https://opencollective.com/vale/organization/7/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/8/website"><img src="https://opencollective.com/vale/organization/8/avatar.svg?avatarHeight=100"></a>
<a href="https://opencollective.com/vale/organization/9/website"><img src="https://opencollective.com/vale/organization/9/avatar.svg?avatarHeight=100"></a>

## :boom: Key Features

- [x] **Support for markup**: Vale has a rich understanding of many [markup formats](https://docs.errata.ai/vale/scoping#formats), allowing it to avoid syntax-related false positives and intelligently exclude code snippets from prose-related rules.

- [x] A **highly customizable** [extension system](https://docs.errata.ai/vale/styles): Vale is capable of enforcing *your style*&mdash;be it a standard [editorial style guide](https://github.com/errata-ai/styles#available-styles) or a custom in-house set of rules (such as those created by [GitLab](https://docs.gitlab.com/ee/development/documentation/#vale), [Homebrew](https://github.com/Homebrew/brew/tree/master/docs/vale-styles/Homebrew), [Linode](https://www.linode.com/blog/linode/docs-as-code-at-linode/), [CockroachDB
](https://github.com/cockroachdb/docs/tree/master/ci/vale), and [Spotify](https://github.com/spotify/backstage)).

- [x] **Easy-to-install**, stand-alone binaries: Unlike other tools, Vale doesn't require you to install and configure a particular programming language and its related tooling (such as Python/pip or Node.js/npm).

See the [documentation](https://docs.errata.ai/vale/about) for more information.

## :mag: At a Glance: Vale vs. `<...>`
