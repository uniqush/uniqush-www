---
title: "Release Note 2.7.0"
weight: -20700
params:
  author: "Uniqush Maintainers"
---
25-Nov-2019

This release contains bugfixes and starts using Go modules.

Download:

- [GitHub Releases (rpm, deb, tar.gz)](https://github.com/uniqush/uniqush-push/releases/tag/2.7.0)

ChangeLog:

- Bugfix: Change from the deprecated `redis.FlushDb` alias to `redis.FlushDB` of go-redis (`FlushDb` is removed in later releases). This may require updating the version of go-redis that `uniqush-push` is built with.
- Bugfix: Properly handle values of `sandbox` other than `sandbox=true` when creating push service providers. (#249) (This bug is not triggered when there is no `sandbox` query param.)
- Bugfix: Fix possible incorrect subscription when sending the API response for `/push` containing multiple subscriptions (pushes were sent correctly).
- Maintenance: Start using Go modules.
- Maintenance: Add documentation to source code.
