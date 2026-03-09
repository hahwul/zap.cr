+++
title = "API Reference"
+++

Complete reference for all zap.cr API modules. Each module wraps a corresponding ZAP API component.

## Core

| Module | Accessor | Description |
|--------|----------|-------------|
| [Client](/api/client/) | - | HTTP client, entry point |
| [Core](/api/core/) | `client.core` | Sessions, messages, site tree, options |

## Scanning

| Module | Accessor | Description |
|--------|----------|-------------|
| [Spider](/api/spider/) | `client.spider` | Traditional web crawler |
| [Ajax Spider](/api/ajax-spider/) | `client.ajax_spider` | Browser-based crawler |
| [Active Scan](/api/ascan/) | `client.ascan` | Active vulnerability scanner |
| [Passive Scan](/api/pscan/) | `client.pscan` | Passive scanner management |

## Results

| Module | Accessor | Description |
|--------|----------|-------------|
| [Alert](/api/alert/) | `client.alert` | Scan findings management |
| [Search](/api/search/) | `client.search` | Search traffic history |

## Configuration

| Module | Accessor | Description |
|--------|----------|-------------|
| [Context](/api/context/) | `client.context` | Scan scope management |
| [Network](/api/network/) | `client.network` | Proxy, DNS, certificates |
| [Script](/api/scripts/) | `client.script` | Script engine |

## Other Modules

| Module | Accessor | Description |
|--------|----------|-------------|
| [Others](/api/others/) | various | Authentication, Users, Reports, etc. |
