---
title: FAQ
aliases:
  - /wiki/UniqushFAQ/index.html
---

## Usage

### I don't know how to use uniqush. Can you explain it a little?

The only component of Uniqush right now is `uniqush-push`, a standalone
program you talk to over HTTP. Start it, then use it as an ordinary web
service according to its [API](/documentation/usage.html). You can
[configure](/documentation/config.html) which port it listens on and
everything else.

If you have questions, ask on [GitHub Issues](https://github.com/uniqush/uniqush-push/issues).

### Which platforms does it support?

[FCM](https://firebase.google.com/docs/cloud-messaging/) for Android (`gcm`
is kept as an alias for existing subscriptions), [APNs](https://developer.apple.com/documentation/usernotifications)
for iOS, [ADM](https://developer.amazon.com/device-messaging) for Kindle
tablets, and [UnifiedPush](https://unifiedpush.org/) / Web Push for
de-Googled Android, Linux desktops, and browsers — the only backend with no
vendor account or certificate at all.

******

## Development

### Where do I report a bug or make a suggestion?

[GitHub Issues](https://github.com/uniqush/uniqush-push/issues) for
`uniqush-push` itself; the [uniqush-www](https://github.com/uniqush/uniqush-www)
and [uniqush-blog](https://github.com/uniqush/uniqush-blog) repositories for
this site and the blog.

### Why doesn't `uniqush-push` provide HTTPS?

It's safe to run without it *if* you keep the REST API on `localhost` and let
something in front of it — a reverse proxy, or your own backend — handle
authentication and encryption on the way in. Most web servers already do TLS
termination well; there's no reason for `uniqush-push` to duplicate it.

### Why doesn't `uniqush-push` let me activate/deactivate a delivery point?

That's better handled outside `uniqush-push`. We want the push path itself to
stay fast and simple: checking an "active" flag on every delivery point, on
every push, is a branch in the hottest code path for no benefit most of the
time. If you want this, unsubscribe the delivery point when it's deactivated
and re-subscribe it when it's reactivated — the outside program that tracks
activation state can do this cheaply, since it happens far less often than
pushes do.

### Why Go?

It's a good fit for a network daemon like this one: a small, simple language
with first-class concurrency, a solid standard library, and (since 1.25) it's
what this project already requires to build.
