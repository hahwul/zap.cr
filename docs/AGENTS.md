# AGENTS.md - AI Agent Instructions for Zap.cr Docs

This document provides instructions for AI agents working on the zap.cr documentation site.

## Project Overview

This is the documentation site for [zap.cr](https://github.com/hahwul/zap.cr), a Crystal client library for the ZAP (Zed Attack Proxy) API. Built with [Hwaro](https://github.com/hahwul/hwaro), a fast static site generator written in Crystal.

## Site Structure

```
docs/
├── config.toml              # Site configuration
├── content/
│   ├── index.md             # Homepage
│   ├── getting-started/     # Installation & setup
│   │   ├── _index.md
│   │   ├── installation.md
│   │   ├── quick-start.md
│   │   └── configuration.md
│   ├── guide/               # Usage guides
│   │   ├── _index.md
│   │   ├── scanning.md
│   │   ├── spidering.md
│   │   ├── authentication.md
│   │   ├── context.md
│   │   ├── alerts.md
│   │   └── reporting.md
│   └── api/                 # API reference
│       ├── _index.md
│       ├── client.md
│       ├── core.md
│       ├── spider.md
│       ├── ajax-spider.md
│       ├── ascan.md
│       ├── pscan.md
│       ├── alert.md
│       ├── context.md
│       ├── search.md
│       ├── network.md
│       ├── scripts.md
│       └── others.md
├── templates/               # Jinja2 templates
│   ├── header.html
│   ├── footer.html
│   ├── page.html
│   ├── section.html
│   └── 404.html
└── static/
    └── css/style.css
```

## Content Guidelines

- Front matter uses TOML format delimited by `+++`
- Code examples use Crystal syntax
- All ZAP API references link to https://zaproxy.org/docs/api/
- ZAP is NOT an OWASP project - do not use "OWASP ZAP"

## Building

```bash
hwaro serve        # Dev server at localhost:3000
hwaro build        # Build to public/
```
