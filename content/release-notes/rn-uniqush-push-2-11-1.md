---
title: "Release Note 2.11.1"
weight: -21101
params:
  author: "Misha Nasledov"
---
28-Oct-2026

This release fixes two ways around the Web Push check that keeps uniqush from
sending to private addresses: DNS rebinding, and NAT64 addresses. See
[GHSA-857j-w4f9-cmg4](https://github.com/uniqush/uniqush-push/security/advisories/GHSA-857j-w4f9-cmg4).
It also makes Web Push's `request_timeout` cover the endpoint's DNS lookup.

Download:

- [GitHub Releases (rpm, deb, tar.gz)](https://github.com/uniqush/uniqush-push/releases/tag/2.11.1)
- Docker: `ghcr.io/uniqush/uniqush-push:2.11.1`

Security:

- Bugfix: Web Push checked an endpoint's addresses from one DNS lookup and then connected using another, so a
  DNS server that answered the two differently could get a push sent to a private address such as
  `169.254.169.254`. uniqush now checks the address it actually connects to.
- Bugfix: Web Push treated IPv6 addresses that carry an IPv4 address, such as NAT64's `64:ff9b::a9fe:a9fe`
  (169.254.169.254) and 6to4's `2002::/16`, as public. On a network with NAT64, such as an IPv6-only cloud subnet
  with DNS64, an endpoint resolving to one reached the private IPv4 address, and DNS64 makes one from an ordinary
  A record. uniqush now judges the IPv4 address inside. It also refuses `0.0.0.0/8`, `fec0::/10`, `64:ff9b:1::/48`
  and the IPv6 documentation, discard-only, benchmarking and SRv6 ranges.

UnifiedPush / Web Push:

- Bugfix: Endpoint DNS validation now counts against `request_timeout`; a slow lookup could previously add
  time beyond `request_timeout`.
