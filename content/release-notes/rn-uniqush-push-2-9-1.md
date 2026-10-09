---
title: "Release Note 2.9.1"
weight: -20901
params:
  author: "Misha Nasledov"
---
08-Oct-2026

This release fixes five HTTP/2 vulnerabilities and moves builds to a Go
version that still gets security fixes. It also adds a Docker image.

Download:

- [GitHub Releases (rpm, deb, tar.gz)](https://github.com/uniqush/uniqush-push/releases/tag/2.9.1)
- Docker: `ghcr.io/uniqush/uniqush-push:2.9.1`

Security:

- Bugfix: Updated golang.org/x/net to v0.60.0 for five HTTP/2 vulnerabilities (GO-2026-6603, -6610, -6611, -6612,
  -6617), and build releases and the Docker image with Go 1.27, since Go 1.25 no longer gets security fixes.
  Building now requires Go 1.26 or newer (was 1.25).

Packaging:

- New feature: A Docker image for linux/amd64 and linux/arm64 at `ghcr.io/uniqush/uniqush-push`, tagged with
  each release (`:latest`, `:X.Y`, `:X.Y.Z`) and as `:edge` from master. It listens on port 9898 and expects
  redis at the host `redis`; mount a config over `/etc/uniqush/uniqush-push.conf` to change either.
- Bugfix: The Dockerfile builds again. It was based on CentOS 7 and `go get`, neither of which still works.
