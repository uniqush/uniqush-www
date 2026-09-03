---
title: Configuration
aliases:
  - /wiki/UniqushConfig/index.html
---

This document describes the uniqush-push configuration file. See
[Basic Operations](/documentation/basic-opts.html) first if you haven't
already.

## Location

The configuration file defaults to `/etc/uniqush/uniqush-push.conf`, or
specify your own with the `-config` flag: `uniqush-push -config /path/to/uniqush-push.conf`.

## Structure

The file has several **sections**, each with **options** as key-value pairs:

```
globaloption=globalvalue

[Section1]
option1=value1
option2=value2

[Section2]
option=value
```

Lines outside any `[Section]` header are in the *default* section. All
options are optional; an empty config file is a valid one, and uniqush-push
uses its defaults for everything.

## Sections

| Section | Description |
|---|---|
| *default* | Global settings that apply outside any named section. |
| `WebFrontend` | The REST API: listen address, logging. |
| `AddPushServiceProvider`, `RemovePushServiceProvider`, `Subscribe`, `Unsubscribe`, `Push`, `Subscriptions`, `PSPs`, `Services` | Logging for the matching API call. |
| `Database` | The Redis connection. |
| `apns` | APNs-specific settings. |
| `webpush`, `unifiedpush` | Web Push / UnifiedPush destination policy. Independent sections, even though it's one backend registered under two names. |

### Options in the default section

| Option | Values | Default | |
|---|---|---|---|
| `logfile` | a file path | standard error | Where uniqush-push logs. Created with mode 0600 if it doesn't exist; falls back to standard error if that fails. |

### Common options (every section except Database and the default section)

| Option | Values | Default | |
|---|---|---|---|
| `log` | `on`/`off` | `on` | Turn logging for this section on or off. |
| `loglevel` | `alert`, `error`, `warn`, `standard`/`verbose`/`info`, `debug` | `standard` | Verbosity. |

### `WebFrontend`

| Option | Values | Default | |
|---|---|---|---|
| `addr` | `[host]:[port]` | `localhost:9898` | Where the REST API listens. **There is no authentication** — keep this on localhost, or put a reverse proxy that authenticates in front of it. |

### `Database`

| Option | Values | Default | |
|---|---|---|---|
| `engine` | `redis` | `redis` | Only Redis is supported. |
| `host` | an address | `localhost` | The Redis host. |
| `port` | a port number | `0` (Redis's default, 6379) | |
| `name` | a database index | `0` | |
| `password` | a password | empty | |
| `slave_host`, `slave_port` | an address/port | unset | Route reads to a replica, to reduce load on the master. |
| `everysec` | seconds | `600` | How often the in-memory cache syncs to Redis. |
| `leastdirty` | a count | `10` | The cache syncs early if at least this many entries are dirty. |
| `cachesize` | a count | `1024` | Maximum entries the cache holds. |

### `apns`

| Option | Values | Default | |
|---|---|---|---|
| `pool_size` | a count, up to 50 | `13` | Connections to APNs' binary protocol per active provider. Only relevant to the deprecated binary path; HTTP/2 doesn't pool this way. |
| `allow_non_apple_endpoints` | `true`/`false` | `false` | Allow an `/addpsp` `endpoint` outside `push.apple.com` — for pointing a provider at a simulator or relay. See [Using Uniqush](/documentation/usage.html#addpsp). |

### `webpush` / `unifiedpush`

| Option | Values | Default | |
|---|---|---|---|
| `allow_private_addresses` | `true`/`false` | `false` | Allow pushing to a non-globally-routable address (for a self-hosted push server on a private network). |
| `allowed_hosts` | a comma-separated list | unset | Restrict which hosts are allowed, alongside `allow_private_addresses`. |

## Sample Configuration File

The repository's
[`conf/uniqush-push.conf`](https://github.com/uniqush/uniqush-push/blob/master/conf/uniqush-push.conf)
is a working starting point:

```
logfile=/var/log/uniqush

[WebFrontend]
log=on
loglevel=standard
addr=localhost:9898

[AddPushServiceProvider]
log=on
loglevel=standard

[RemovePushServiceProvider]
log=on
loglevel=standard

[Subscribe]
log=on
loglevel=standard

[Unsubscribe]
log=on
loglevel=standard

[Push]
log=on
loglevel=standard

[Database]
engine=redis
port=0
name=0
everysec=600
leastdirty=10
cachesize=1024

[apns]
pool_size=13
```

******

## Related Topics

- [Basic Concepts](/documentation/basic-concept.html)
- [Basic Operations](/documentation/basic-opts.html)
- [Install](/documentation/install.html)
- [Using Uniqush](/documentation/usage.html)
