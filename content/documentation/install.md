---
title: Install
aliases:
  - /wiki/UniqushInstall/index.html
  - /wiki/UniqushUpdate/index.html
---

## Installing uniqush-push

`uniqush-push` is the only component of Uniqush. Building it needs
**Go 1.25 or newer**; running it needs a [Redis](https://redis.io) server.

Prebuilt packages (`.deb`, `.rpm`, `.tar.gz`) for the latest release, 2.8.0,
are on
[GitHub Releases](https://github.com/uniqush/uniqush-push/releases/tag/2.8.0).
Or build from source:

```
git clone https://github.com/uniqush/uniqush-push.git
cd uniqush-push
go build          # produces ./uniqush-push
```

or, without a checkout: `go install github.com/uniqush/uniqush-push@v2.8.0`
(or `@master` for the latest unreleased changes).

### Install Redis

Redis should run somewhere with low latency to `uniqush-push` (ideally the
same host or datacenter), and with
[persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
enabled — every subscription lives there.

- Debian-based systems (Debian, Ubuntu, Mint, …): `sudo apt-get install redis-server`
- yum-based systems (RHEL, Fedora, CentOS, …): `sudo yum install redis-server`
- Otherwise, see the [Redis](https://redis.io) site.

### Configure and run

Copy [`conf/uniqush-push.conf`](https://github.com/uniqush/uniqush-push/blob/master/conf/uniqush-push.conf)
from the repository to `/etc/uniqush/uniqush-push.conf` — the default
location — or point at your own copy with `-config`. See
[Configuration](/documentation/config.html) for what it can contain.

**The REST API has no authentication.** Its default address,
`localhost:9898`, only accepts local connections; keep it that way, or put it
behind a reverse proxy that authenticates.

```
uniqush-push                      # or: uniqush-push -config /path/to/uniqush-push.conf
curl http://localhost:9898/version
```

See [Using Uniqush](/documentation/usage.html) for the full API.

******

## Related Topics

- [Basic Concepts](/documentation/basic-concept.html)
- [Basic Operations](/documentation/basic-opts.html)
- [Configuration](/documentation/config.html)
- [Using Uniqush](/documentation/usage.html)
