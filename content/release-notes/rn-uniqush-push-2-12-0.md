---
title: "Release Note 2.12.0"
weight: -21200
params:
  author: "Misha Nasledov"
---
29-Oct-2026

This release adds the push service's own reason to each removed device, maps
`uniqush.urgency` to APNs priority, reports Apple's result for each device, and
retries transient connection failures. It also fixes a regression in 2.11.0
where FCM devices reported gone were not removed.

Download:

- [GitHub Releases (rpm, deb, tar.gz)](https://github.com/uniqush/uniqush-push/releases/tag/2.12.0)
- Docker: `ghcr.io/uniqush/uniqush-push:2.12.0`

REST API:

- New field: removals in `/push` and `/removed` include an optional `vendorReason`, preserving the push
  service's own code, such as `BadDeviceToken` or `SENDER_ID_MISMATCH`. The existing removal
  decisions and uniqush's `reason` codes are unchanged.

FCM:

- Bugfix: A device FCM reported gone was not removed, and not listed in `/removed`, since 2.11.0.

APNs:

- New feature: `uniqush.urgency` sets `apns-priority`: `very-low` and `low` use priority 5, while `normal` and
  `high` use priority 10. Background pushes always require priority 5, so an explicit `normal` or `high` urgency
  is rejected. Without `uniqush.urgency`, APNs keeps deriving priority from `uniqush.apns_push_type`.
- Bugfix: `/push` reports Apple's result for each device, including removals, instead of reporting
  success before interpreting the response. One failed device no longer hides successful devices in the same push.

Push delivery:

- Bugfix: Transient connection failures to APNs, FCM and Web Push now retry with the existing backoff. DNS not-found,
  endpoint-policy and TLS certificate verification failures remain permanent.
