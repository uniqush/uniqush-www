---
title: "Release Note 2.9.0"
weight: -20900
params:
  author: "Misha Nasledov"
---
23-Sep-2026

This release makes wildcard pushes fast on large databases, makes subscribing
and unsubscribing atomic, and adds `/stats`, `/health`, per-device APNs bundle
ids and a systemd unit. It also stops `/psps` and `/subscriptions` handing out
credentials, and removes the APNs binary protocol.

Download:

- [GitHub Releases (rpm, deb, tar.gz)](https://github.com/uniqush/uniqush-push/releases/tag/2.9.0)

The longer version of everything below, for operators, is in the
[upgrade notes](/documentation/upgrading.html#upgrading-from-280). No device
needs to re-subscribe. **Action required:** run `/rebuildsubscriberindex` once
after upgrading (see Redis).

APNs:

- New feature: `/subscribe` accepts a per-device `bundleid`, overriding the provider's, so one certificate can
  serve an app and its other builds from one service. An empty `bundleid` clears it.
- Bugfix: `mutable-content`, `category`, `thread-id` and `target-content-id` go inside `aps`, where iOS reads
  them, rather than beside it. `interruption-level` and `relevance-score` are supported, and numbers are sent
  as numbers.
- Bugfix: `uniqush.payload.apns` accepts `content-available` as the number `1`, the form Apple documents.
- Change: `/addpsp` records `environment` (`production` or `development`) instead of `addr`. `addr` is still
  accepted, and providers stored with one are still routed by it.
- Removal: The binary protocol and the feedback service client, which Apple shut down in 2021.
  `uniqush.http2=0` is still accepted but does nothing. `pool_size` in `[apns]` is ignored.

FCM:

- New feature: `uniqush.priority` on `/push` (`high` or `normal`) sets FCM's `android.priority`.

UnifiedPush / Web Push:

- Change: The RFC 8188 record size is now 4096 (was 2048), so messages are 4096 bytes on the wire and a payload
  may be up to 3993 bytes. Clients built on google/tink's `apps-webpush` could not read 2048.
- New feature: `record_size` in `[webpush]` and `[unifiedpush]`; `record_size=2048` halves egress.
- Bugfix: `allow_private_addresses` and `allowed_hosts` are re-read on every reconfiguration, so deleting one
  closes what it opened.

Redis:

- Change: Wildcard pushes (`subscriber=alice.*`) look at one service's subscribers instead of the whole
  database. **Run `/rebuildsubscriberindex` once after upgrading, when no 2.8.0 instance is left sharing the
  database**, and again if you downgrade and come back. Until then wildcard pushes still work but are slow and
  log an error, and `/stats` refuses to answer. New installations need nothing.
- Change: Subscribing and unsubscribing are atomic, so a crash or dropped connection cannot leave them half
  done. The `delivery.point.counter:` keys are no longer written; leftovers are harmless.
- Change: A `*` in a service name is refused. Only `/nrdp` ever let one through.
- Bugfix: Wildcard pushes and `/rebuildserviceset` page through `SCAN` instead of running `KEYS`, which blocked
  redis for every other client while it walked the keyspace.
- New feature: `/checkdb` reports `unreferenced_delivery_point` (left by an interrupted `/subscribe`),
  `index_not_built`, `missing_index_entry` and `stale_index_entry`.

REST API:

- New feature: `/stats` counts subscribers and devices per service and push service type, optionally only
  those who re-subscribed `since` a given time.
- New feature: `/rebuildsubscriberindex`. Safe on a live server and to run more than once.
- New feature: `/health` answers `200` when redis responds and `503` when it does not, for a load balancer's
  readiness probe. It deliberately does not probe Apple or Google.
- New feature: `/unsubscribe` accepts `alldevices=1` to remove every device a subscriber has in a service,
  given only `service` and `subscriber`.
- Bugfix: `/subscribe` and `/unsubscribe` reject a subscriber of only commas instead of crashing the request.
- Security: `/psps` no longer reports credentials: VAPID private keys, ADM client secrets and access tokens
  are `[redacted]`. The API is still not safe to expose: `/subscriptions` and `/push` remain open.
- Security: `/subscriptions` omits a Web Push subscription's `auth` secret unless
  `include_subscription_secrets=1` is passed. Together with `endpoint` and `p256dh` it is enough to push to
  that browser without uniqush.

Logging:

- Bugfix: An error about one device names that device, rather than `Subscriber=Unknown DeliveryPoint=Unknown`.
- Bugfix: Log why a push is being retried, including the Web Push server's response body.
- Bugfix: Fatal messages are no longer garbled when `log=off`.

Startup and configuration:

- Change: uniqush refuses to start when the system root certificates cannot be loaded. It used to start and
  then fail every push.
- Bugfix: uniqush exits non-zero when it cannot start, so `Restart=on-failure` and `docker run` see the failure.
- Bugfix: A config file that fails to read part way through is an error, not a partial configuration.
- New feature: `request_timeout`, in seconds, in `[apns]`, `[fcm]`, `[gcm]`, `[webpush]` and `[unifiedpush]`.
  Defaults are unchanged: 20 for APNs, 30 for the rest.

Packaging:

- New feature: The `.deb` and `.rpm` install a systemd unit, not enabled. It runs as a transient unprivileged
  user and restarts on failure. (Prompted by @p365labs, #146)
- Change: The shipped config logs to `/var/log/uniqush/uniqush-push.log` (was `/var/log/uniqush`). An upgrade
  keeps your existing config; fix `logfile` there before enabling the unit.
- Bugfix: Releases carry the licenses of the modules they bundle, in `THIRD-PARTY-LICENSES`.

Maintenance:

- The logger and config parser now live in this repository (`log/`, `conf/`) instead of the archived
  `github.com/uniqush/log` and `github.com/uniqush/goconf`; `go.mod` requires nothing else owned by uniqush.
  Parsing is unchanged.
- Update `golang.org/x/crypto` to v0.55.0.

Changes to APIs (embedders only):

- `db.PushDatabase` gains `Ping`, `PrepareSubscriberIndex` (call once before serving, as `Run` does),
  `RebuildSubscriberIndex`, `SubscriberStats` and `RemoveAllDeliveryPointsFromService`.
  `GetPushServiceProviderDeliveryPointPairs` takes a `requestID` before its logger.
- `push.DestinationOf(err)` returns the delivery point an error is about. `ErrorReport`, `BadNotification` and
  `ConnectionError` gain a `Destination` field, set by new `...ForDeliveryPoint` constructors.
- Import `github.com/uniqush/uniqush-push/log` and `.../conf` in place of the old packages. Log level constants
  are renamed (`LOGLEVEL_INFO` is `LevelInfo`), and `MultiLogger`, `WriteConfigFile` and the rest of the config
  writing API are dropped. `HasOption` and `GetOptions` no longer consult the default section.
