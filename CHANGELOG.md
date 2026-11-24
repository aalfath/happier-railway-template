# Changelog

Each entry is one version of this template. Breaking changes are listed first. Railway shows deployers an
"update available" notice when this repo's `main` changes; read the entry before you apply it.

## 0.2.21 (2026-11-24)

First release of the template.

- Happier server `server-v0.2.21` with its embedded web app (official image
  `happierdev/relay-server:stable-e992e049ffa7`, pinned by digest
  `sha256:3617122569179268e8015718ddc2fbb4642fa5461b87e68238e656613929fd63`).
- Railway Postgres as the database (upstream's "full flavor"); uploads on a volume at `/data`.
- Anonymous sign-up is closed from the first boot; the owner account is created on first boot from the generated
  `OWNER_SECRET_KEY`.
- Health check on `/ready` (checks the database); upstream crash reporting and the metrics port are off.
