---
title: Downloads
aliases:
  - /downloads/index.html
menu:
  main:
    name: Downloads
    weight: 30
---

**Every packaged release through 2.6.1 predates the fixes to APNs and FCM
described in the [upgrade notes](/documentation/upgrading.html) — their APNs
and FCM support cannot deliver a notification any more, since both services
shut down the APIs those releases spoke to. Upgrade to 2.8.0 or newer.**

## uniqush-push

All releases, with their notes and downloadable packages (`.deb`, `.rpm`,
`.tar.gz`), are on
[GitHub Releases](https://github.com/uniqush/uniqush-push/releases).

Release notes for each version are also on this site, under
[Release Notes](/release-notes/).

## Building from source

```
git clone https://github.com/uniqush/uniqush-push.git
cd uniqush-push
go build
```

See [Install](/documentation/install.html) for the rest.
