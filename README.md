# casns

[![License](https://img.shields.io/github/license/casapps/casns)](LICENSE.md)
[![Build Status](https://github.com/casapps/casns/actions/workflows/ci.yml/badge.svg)](https://github.com/casapps/casns/actions)
[![Go Report Card](https://goreportcard.com/badge/github.com/casapps/casns)](https://goreportcard.com/report/github.com/casapps/casns)

A complete single-binary DNS platform — replaces BIND, Unbound, Pi-hole, Technitium, AdGuard Home, acme-dns, and hosted DDNS services (DuckDNS, No-IP, DynDNS, FreeDNS, redirect.center).

## About

casns is a self-hosted DNS server and management platform. It provides authoritative DNS, recursive resolution, ad-blocking, custom DDNS, ACME DNS challenge support, and more — all in one static binary with zero runtime dependencies.

Official site: [redxt.us](https://redxt.us) | Cluster nodes: ns1.redxt.us, ns2.redxt.us

## Features

- Authoritative DNS server (replaces BIND/PowerDNS)
- Recursive resolver with ad-blocking (replaces Unbound/Pi-hole)
- DNS-over-TLS (DoT), DNS-over-HTTPS (DoH, HTTP/2+HTTP/3), DNS-over-QUIC (DoQ), DNSCrypt
- DDNS service (replaces DuckDNS, No-IP, DynDNS, FreeDNS)
- ACME DNS challenge support (replaces acme-dns)
- Tor `.onion`/`.exit` resolution (RFC 7686)
- Multi-user with invite-only registration
- Organizations and team workspaces
- Custom domain support with automatic SSL
- Git-based zone sync (pure Go, no git binary required)
- SQLite (default), PostgreSQL, MariaDB support
- Web admin panel with dark/light/auto theme
- Let's Encrypt SSL with automatic renewal
- Single static binary, zero runtime dependencies

## Production

### Docker (recommended)

```bash
docker run -d \
  --name casns \
  -p 53:53/tcp -p 53:53/udp \
  -p 80:80 -p 443:443 \
  -v ./config:/config:z \
  -v ./data:/data:z \
  ghcr.io/casapps/casns:latest
```

### Docker Compose

```bash
curl -LO https://raw.githubusercontent.com/casapps/casns/main/docker/docker-compose.yml
docker compose up -d
```

### Binary

Download the latest release for your platform from the [releases page](https://github.com/casapps/casns/releases).

```bash
casns
```

On first run, casns auto-detects paths based on privilege level and creates `server.yml`.

### Service Install

```bash
sudo casns --service install
```

## Client

casns includes a built-in CLI client:

```bash
casns --help
```

## Configuration

Configuration file: `/etc/casapps/casns/server.yml` (privileged) or `~/.config/casapps/casns/server.yml` (user).

casns generates a default config on first run. Edit `server.yml` or use the web admin panel at `http://localhost:{port}/server/admin`.

## API

REST API available at `/api/v1/`. See the admin panel for interactive documentation.

## Disclaimer

casns is provided as-is. Use responsibly and comply with your jurisdiction's regulations regarding DNS services.

## License

MIT License — see [LICENSE.md](LICENSE.md) for details.
