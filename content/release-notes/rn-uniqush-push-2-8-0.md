---
title: "Release Note 2.8.0"
weight: -20800
params:
  author: "Misha Nasledov"
---
03-Sep-2026

This release repairs APNs and FCM after their upstream APIs were shut down
while the project was dormant, adds UnifiedPush/Web Push support, and fixes
a database bug that could silently delete subscriptions.

Download:

- [GitHub Releases (rpm, deb, tar.gz)](https://github.com/uniqush/uniqush-push/releases/tag/2.8.0)

The longer version of everything below, for operators, is in the
[upgrade notes](/documentation/upgrading.html). No device needs to
re-subscribe.

APNs:

Anyone running uniqush for APNs should treat this as a required upgrade:
2.7.0 could not deliver an iOS notification at all. The changes are verified
against a conformance simulator and Apple's sandbox, but not yet against a
real device; see
[docs/apns-verification-plan.md](https://github.com/uniqush/uniqush-push/blob/master/docs/apns-verification-plan.md).

- Bugfix: Use the HTTP/2 API by default. Apple shut the binary protocol down on 31 March 2021.
  `uniqush.http2=0` still selects it and logs a deprecation warning; it will be removed in a future release.
- Bugfix: Send the `apns-push-type` header, and derive `apns-priority` from it instead of hardcoding 10.
  Background pushes were previously either silently discarded (iOS 13+) or rejected with `BadPriority`.
- Bugfix: Classify APNs failures instead of treating every one as a `BadNotification` and dropping the push.
  Transient reasons are retried; credential and configuration reasons are reported against the provider.
- Bugfix: Also unsubscribe on `Unregistered`, `ExpiredToken` and `DeviceTokenNotForTopic`, not only `BadDeviceToken` and 410.
- Bugfix: Refuse `skipverify` for Apple's own hosts. It was silently ignored on the HTTP/2 path, so honouring it
  now would have disabled certificate verification against Apple.
- Bugfix: `Finalize` no longer deadlocks on the HTTP/2 client cache.
- New feature: Token (`.p8`) authentication. `/addpsp` accepts `authkey`, `keyid` and `teamid` as an
  alternative to `cert` and `key`. Tokens are signed deterministically, so any number of uniqush instances can
  share one key with nothing shared between them.
  ([docs/adr/0001-deterministic-apns-provider-tokens.md](https://github.com/uniqush/uniqush-push/blob/master/docs/adr/0001-deterministic-apns-provider-tokens.md))
- New feature: `uniqush.apns_push_type` on `/push` selects the push type (`alert`, `background`, `voip`, ...).
  `uniqush.apns_voip=1` still works and implies `voip`.
- New feature: Send a unique `apns-id` header per notification.
- New feature: `/addpsp` accepts `endpoint` and `cacert` for `apns`, so a simulator or relay can be used
  without disabling certificate verification.
- Security: A non-Apple `endpoint` is refused unless `allow_non_apple_endpoints=true` is set in `[apns]`.

FCM:

- Bugfix: Migrate to FCM's HTTP v1 API. Google decommissioned the legacy endpoint on 20 June 2024, so every
  Android push has been failing since. **Action required:** `/addpsp` now takes `projectid` and `credentialsfile`
  (a Firebase service-account JSON) instead of `apikey`, and all `data` values must be strings.
- Bugfix: Only `UNREGISTERED` and `SENDER_ID_MISMATCH` unsubscribe a device. v1 reports bad payloads as
  `INVALID_ARGUMENT`, so treating that as a dead device would have deleted working subscriptions.
- Maintenance: `gcm` is now an alias for `fcm`. Existing gcm providers and subscriptions keep working.

UnifiedPush / Web Push:

- New provider: `webpush`, also registered as `unifiedpush`. RFC 8030 delivery, RFC 8291 encryption and
  RFC 8292 VAPID, which is what UnifiedPush and browser Web Push use. See the
  [GitHub README](https://github.com/uniqush/uniqush-push#unifiedpush--web-push) for setup.
- New feature: `uniqush-push -generate-vapid-keys` prints a VAPID key pair.
- Security: Pushes to non-globally-routable addresses are refused by default, since the destination comes
  from `/subscribe`. Relax per service with `allow_private_addresses` and `allowed_hosts` in the config.

Retries:

- Change: A push service's requested delay (`Retry-After`, or Apple's provider-token floor) now seeds the
  retry schedule for every backend. Previously the first retry was always 5 seconds and the push was
  abandoned past a minute regardless.
- Security: A requested delay is capped at 30 minutes, so a remote server cannot pin memory with a huge `Retry-After`.

Database:

- Bugfix: A read no longer deletes delivery points whose provider is missing. `/rmpsp` used to silently
  unsubscribe every device in the service on the next push, unrecoverably.
- New feature: `/addpsp` accepts `replace=true` to replace a provider whose credentials changed -- e.g. moving
  APNs from a certificate to a `.p8` -- without losing subscriptions. A delivery point's provider is now
  derived from its service and push service type rather than read from the stored binding; the binding is
  still written, so a rollback needs no repair.
  ([docs/delivery-point-rebinding.md](https://github.com/uniqush/uniqush-push/blob/master/docs/delivery-point-rebinding.md))
- New feature: `/checkdb` reports database inconsistencies. Read-only and lock-free, so it is safe to run
  against production. Run it before upgrading a database created before 2.6.0.

Maintenance:

- Building requires Go 1.25 or newer (was 1.14).
- Update `golang.org/x/net` from a 2020 revision to v0.57.0 (CVE-2023-44487, CVE-2023-45288). `govulncheck` runs in CI.
- Replace Travis CI with GitHub Actions; migrate `.golangci.yml` to the v2 format.
- `go test ./srv/apns/` drives the real HTTP/2 transport against a simulator that enforces Apple's documented
  contract; `go test -tags apns_live ./srv/apns/http_api/` probes Apple's real sandbox.

Changes to APIs (embedders only):

- `http_api.HTTPPushRequestProcessor.GetClient` now returns `(HTTPClient, func(), error)`.
  Call the second value exactly once to release the client; it is nil on the error path.
- `TryGetClient` is removed. It had been returning nil for every caller since the cache moved to a composite key.
