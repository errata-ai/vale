---
description: >-
  Vale offers multiple options for installation, each of which best suits a
  particular use case.
---

# Installation

{% hint style="info" %}
If you're using Vale with a markup format other than Markdown or HTML, you'll also need to install a [parser](markup.md#formats).
{% endhint %}

## Remote, collaborative use[¶](https://errata-ai.github.io/vale/#remote-collaborative-use)

One of Vale's strengths is its ability to help a company, project, or organization maintain consistency \(capitalization styles, word choice, brand terminology, spelling, etc.\) across multiple writers.

The benefits of these installation methods are that every writer has access to the same Vale configuration without having to install and configure the tool themselves.

### **Using Vale with GitHub**

![Example Vale output using GitHub&apos;s annotations UI](https://user-images.githubusercontent.com/8785025/67726924-bf3e6180-f9a4-11e9-9c32-2233756731b9.png)

If you want to lint the contents of a GitHub repository, the recommended approach is to use Vale's [official GitHub Action](https://github.com/errata-ai/vale-action).

### **Using Vale with a continuous integration \(CI\) service**

If you want to use Vale with a CI service such as Travis CI, CircleCI, or Jenkins, the recommended approach is to use Vale's [`GoDownloader`](https://github.com/goreleaser/godownloader) script \(Vale will be installed to `/bin/vale`\):

```bash
$ curl -sfL https://install.goreleaser.com/github.com/ValeLint/vale.sh | sh -s vX.Y.Z
$ export PATH="./bin:$PATH"
$ vale -v
```

where `vX.Y.Z` is your version of choice from the [releases page](https://github.com/errata-ai/vale/releases). This will ensure that your CI builds are consistent and allow you to update versions on an opt-in basis.

## Local use by a single writer[¶](https://errata-ai.github.io/vale/#local-use-by-a-single-writer)

Vale can also be used locally by a single writer through the command line or a third-party integration.

### **Using Vale with a text editor \(or another third-party application\)**

Vale has a commercial desktop application, [Vale Server](https://errata.ai/vale-server/), that integrates with [many third-party applications](https://errata-ai.github.io/vale-server/docs/usage#step-5-using-a-client-application) \(including Atom, Sublime Text, VS Code, and Google Docs\) and allows writers to easily create and switch between multiple local Vale configurations.

{% tabs %}
{% tab title="Sublime Text" %}
![Vale Server&apos;s Sublime Text plugin](https://errata-ai.github.io/vale-server/docs/assets/plugins/st3.png)
{% endtab %}

{% tab title="VS Code" %}
![Vale Server&apos;s VS Code extension](https://errata-ai.github.io/vale-server/docs/assets/plugins/code.png)
{% endtab %}

{% tab title="Atom" %}
![Vale Server&apos;s Atom plugin](https://errata-ai.github.io/vale-server/docs/assets/plugins/atom.gif)
{% endtab %}

{% tab title="Google Docs" %}
![Vale Server&apos;s Google Docs add-on](https://lh3.googleusercontent.com/SsfXYh0tYvBx3gZEMVUCZpTnI4X-eUgVK_7-Fu9liSHunkMMJc_jPtJuYgz7H3giphqM3Wzmbg=w1280-h800)
{% endtab %}

{% tab title="Chrome" %}
![Vale Server&apos;s Chrome add-on](https://lh3.googleusercontent.com/Rqi8XR5DlittHWoiUNu-y9dMDamATtWQ_V-FT5aA6j-anyw_j5bTQg29j3pBEAqiLY_LoD52lA=w640-h400-e365)
{% endtab %}
{% endtabs %}

### **Using Vale from the command line**

Vale can be installed for local usage. To install the CLI, use one of the following options:

* Download an executable from the [releases page](https://github.com/errata-ai/vale/releases).
* Pull the [latest Docker image](https://hub.docker.com/r/jdkato/vale).
* Use one of the available [package managers](https://repology.org/project/vale/versions):

![](https://repology.org/badge/vertical-allrepos/vale.svg)

