---
title: Home
menu:
  main:
    name: Home
    weight: 1
---

**Uniqush** is free and open source software which provides a unified push
service for server-side notification to apps on mobile devices. By running
**uniqush-push** on your own server, you can send push notifications to any
supported platform through one API. [This story](/documentation/intro.html)
helps explain the basic idea.

The latest news about Uniqush is posted to our [blog](/blog/).

The latest release is [2.7.0](/release-notes/rn-uniqush-push-2-7-0.html); an
unreleased version in progress fixes APNs and FCM for both services' shut-down
APIs and adds UnifiedPush/Web Push support — see the
[upgrade notes](/documentation/upgrading.html).

## Features

- A standalone server program dedicated to push notifications, which you run
  yourself.
- One HTTP API for every supported platform. You don't need to write
  platform-specific code; uniqush-push talks to each push service on your
  behalf.
- Automatic retries on recoverable errors, honouring the delay a push service
  asks for.
- Wildcard and native multicast, so you can push to a group of subscribers in
  one call.

## Supported Platforms

- [FCM](https://firebase.google.com/docs/cloud-messaging/) for Android (`gcm` is kept as an alias)
- [APNs](https://developer.apple.com/documentation/usernotifications) for iOS
- [ADM](https://developer.amazon.com/device-messaging) for Kindle tablets
- [UnifiedPush](https://unifiedpush.org/) and Web Push, for de-Googled Android, Linux desktops and browsers

## Source Code & Downloads

The source is on [GitHub](https://github.com/uniqush/uniqush-push). See
[Install](/documentation/install.html) for how to build and run it, and
[Downloads](/downloads.html) for released versions.

## Getting Help

Questions, bug reports and suggestions are all welcome on
[GitHub Issues](https://github.com/uniqush/uniqush-push/issues).

## License

- Uniqush's source code is [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
- This site's content is [Creative Commons Attribution 3.0](https://creativecommons.org/licenses/by/3.0/).
