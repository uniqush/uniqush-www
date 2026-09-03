---
title: Contribution Guidelines
---

## Introduction

This document explains how to contribute to the uniqush project.

Before contributing, make sure you're comfortable with [git](https://git-scm.com)
and have a [GitHub](https://github.com) account.

## Basic procedure

All uniqush repositories are under the
[uniqush GitHub organization](https://github.com/uniqush). To contribute:

1. Find the repository you want to change.
2. Fork it.
3. Make your change in a branch of your fork.
4. Push the branch to your fork.
5. Open a pull request against `master`. It'll be reviewed, and merged if it's
   a good fit.

Repositories fall into two categories: *code* repositories (source and
libraries) and *content* repositories (this site, the blog, everything that
isn't source).

Questions, bug reports and suggestions are all welcome on
[GitHub Issues](https://github.com/uniqush/uniqush-push/issues).

## Source code repositories

The server is written in [Go](https://go.dev/). `master` is the branch to
work from and to open pull requests against; it should always build and pass
`go test ./...`.

## Content repositories

This site ([uniqush.org](https://uniqush.org)) is the
[uniqush-www repository](https://github.com/uniqush/uniqush-www), built with
[Hugo](https://gohugo.io) and deployed by GitHub Actions on every push to
`master`.

The [blog](/blog/) is the
[uniqush-blog repository](https://github.com/uniqush/uniqush-blog), built
with [Pelican](https://getpelican.com/) and published alongside this site.

Fork, change, and send a pull request the same way as for code.

## Copyright

Source code is under the
[Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0.html).
Content on this site and the blog is under the
[Creative Commons Attribution 3.0 Unported License](https://creativecommons.org/licenses/by/3.0/).
Please make sure you've read and accept the relevant one before contributing.
