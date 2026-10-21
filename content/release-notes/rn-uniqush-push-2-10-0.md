---
title: "Release Note 2.10.0"
weight: -21000
params:
  author: "Misha Nasledov"
---
20-Oct-2026

This release adds a Prometheus `/metrics` endpoint and a `compose.yaml` for
trying uniqush with Docker, and fixes a race in ADM pushes.

Download:

- [GitHub Releases (rpm, deb, tar.gz)](https://github.com/uniqush/uniqush-push/releases/tag/2.10.0)
- Docker: `ghcr.io/uniqush/uniqush-push:2.10.0`

REST API:

- New feature: `/metrics` reports push results by service, push service type and outcome, abandoned retries,
  requests per endpoint, redis reachability and the `/stats` counts in the Prometheus text format. (#299)

ADM:

- Bugfix: A push whose message couldn't be built right after an access-token refresh no longer reuses the
  refresh's result, which raced with its reader and could report the refresh as the push's error. (#337)

Packaging:

- New feature: `compose.yaml` runs the Docker image with a persistent redis, for trying uniqush with
  `docker compose up`. The README's new quickstart walks through it.
