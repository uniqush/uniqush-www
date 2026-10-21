---
title: "Release Note 2.11.0"
weight: -21100
params:
  author: "Misha Nasledov"
---
20-Oct-2026

This release is built with Go 1.27.3, which distrusts the compromised eMudhra
intermediate CAs. It adds an optional bearer token for the REST API, unix
socket listening, a log of devices removed by push services, and the RFC 8030
`TTL`, `Topic` and `Urgency` headers for Web Push.

Download:

- [GitHub Releases (rpm, deb, tar.gz)](https://github.com/uniqush/uniqush-push/releases/tag/2.11.0)
- Docker: `ghcr.io/uniqush/uniqush-push:2.11.0`

The longer version of everything below, for operators, is in the
[upgrade notes](/documentation/upgrading.html#upgrading-from-2100). No device
needs to re-subscribe.

Security:

- Bugfix: Releases and the Docker image are built with Go 1.27.3, whose crypto/x509 rejects any certificate chain
  through the eight eMudhra intermediate CAs whose private keys were compromised (CVE-2026-111943). uniqush
  verifies APNs, FCM, ADM and every Web Push endpoint against the system roots, so a certificate issued with one
  of those keys could otherwise have let an attacker intercept its connections, provider tokens included. If you
  build uniqush yourself, use Go 1.27.3 or 1.26.10 or newer.

REST API:

- New feature: `[WebFrontend] token_file` names a file holding a bearer token that every endpoint but `/health`
  then requires, `/metrics` included. A request without it is answered 401, and `/health` leaves out the version
  and redis's error. Without `token_file` the API is unauthenticated as before, and uniqush warns when that is on
  a non-loopback address.
- New feature: `[WebFrontend] addr=unix:/path/to.sock` listens on a unix socket, with the mode in `socket_mode`
  (default `0660`). A socket file left by an unclean exit is replaced; one still in use is not.
- New feature: `/push` reports each device it removed because the push service said it was gone in
  `droppedDetails[].removed`, with the `devid` given at `/subscribe` and the endpoint, device token or registration
  id that was rejected. `/removed?service=...&since=<cursor>` lists every such removal, including the ones made by a
  retry or by an APNs answer read after `/push` responded, so a caller can keep its own device records in step. Each
  service keeps its newest 100000; the log needs Redis 5.0 or newer. A device is removed only if its record is still
  the one the push read, so one re-subscribed in the meantime keeps its new subscription.
- New feature: A `/push` by `delivery_point_id` reports each id none of the named subscribers has as `UNIQUSH_NOT_SUBSCRIBED`
  in `droppedDetails`, rather than skipping it.
- Bugfix: The `/push` response is serialized under the lock retries add to it under, so a retry finishing at the
  same time no longer races with it.
- Bugfix: A device whose first attempt is being retried is in the `/push` response's `failureDetails`, and counted
  in `failureCount`, with the new code `UNIQUSH_PUSH_RETRYING` and the push service's answer in `errorMsg`. It used to
  be left out, so a push whose only device was retrying answered with an empty response.
- Bugfix: A push refused before any device is tried, for a bad `ttl`, `msggroup`, `uniqush.urgency` or an oversized
  payload, names the request's subscribers in `failureDetails`, and the device when the push named exactly one
  `delivery_point_id`, rather than an empty `subscriber` and `Unknown`. The log line names them too.
- Bugfix: A `/push` by `delivery_point_id` no longer sends the ids to the device. Every backend copied them into
  the payload it built, for example as a top-level `delivery_point_id` key beside `aps` for APNs.

APNs:

- Change: `msggroup` on `/push` is sent as `apns-collapse-id`, so iOS shows notifications with the same group
  as one, as FCM and ADM already did with it. A `msggroup` over Apple's 64 bytes, or with a control character,
  now fails the push.

FCM:

- Change: `projectid` is optional for `fcm` providers, and defaults to the `project_id` in `credentialsfile`,
  including for a provider already stored without one, such as by the Klippa fork's 3.0.4. Those would have
  failed every push with `NoProjectID`. Providers from the fork's earlier releases need one `/addpsp` with
  `replace=true`; see docs/upgrading.md.

UnifiedPush / Web Push:

- New feature: `ttl`, `msggroup` and the new `uniqush.urgency` on `/push` set the RFC 8030 `TTL`, `Topic` and
  `Urgency` headers, including with `uniqush.payload.webpush`. Without them a push goes out as before: a
  12-hour TTL, no topic and normal urgency.
- Change: A `ttl` that is not a number of seconds (`1h`), a `msggroup` that is not up to 32 characters of
  `A-Z`, `a-z`, `0-9`, `-` and `_` (`chat:42`), or an unknown `uniqush.urgency` now fails the push. They used
  to be passed harmlessly in the body.
- Change: `ttl` and `msggroup` are no longer copied into the generated JSON body, as with FCM and ADM, so a
  push carrying nothing else now fails as an empty payload.
- Change: `/previewpush` rejects the same parameters `/push` does, for APNs and Web Push.
- Change: `/addpsp` checks the `subscriber` (VAPID contact) of a `webpush` or `unifiedpush` provider, and accepts
  an email address, a `mailto:` URI or an `https:` URL. Anything else, such as an `http:` URL or a name without an
  `@`, is refused rather than signed as an invalid `mailto:` contact. Stored providers are unchanged; one stored
  with a contact that is now refused keeps pushing and can still be removed with `/rmpsp`, and `/addpsp` with
  `replace=true` and a valid contact fixes it.

Packaging:

- New feature: `uniqush-push -healthcheck` exits 0 if the server on the config's `addr` answers `/health` with a
  200, and the Docker image and `compose.yaml` use it as their healthcheck, since the image has no curl.
  `compose.yaml` pulls `:latest`, so its healthcheck needs 2.11.0 or newer.
- New feature: `compose.yaml` has a commented example of requiring a bearer token: the token is passed from `.env`
  as a secret owned by the image's user with mode 0400, and a mounted config sets `token_file` to it.
- Bugfix: The .deb and .rpm mark `/etc/uniqush/uniqush-push.conf` as a config file, so upgrading keeps a changed
  one, `token_file` included, instead of overwriting it with the stock config. Upgrading a .deb from 2.10.0 or
  earlier asks about it once if it was edited, and replaces it silently if not; for an unattended upgrade, pass
  `-o Dpkg::Options::=--force-confold` to apt-get to keep the edited one.
- Change: `build/build-uniqush-push.sh` is gone. It cloned over SSH and used `go get`, and the release workflow
  builds the packages without it.
