# Happier on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/happier?utm_medium=integration&utm_source=button&utm_campaign=happier)

One-click Railway template for [Happier](https://github.com/happier-dev/happier) (MIT): your own server and web app
to run, follow and steer Claude Code, Codex, OpenCode and other coding agents from your phone, desktop or browser,
end-to-end encrypted. Agents keep running on your own computers; they connect out to this server.

**Version:** Happier server `server-v0.2.21` with its web app, from the official image
`happierdev/relay-server:stable-e992e049ffa7@sha256:3617122569179268e8015718ddc2fbb4642fa5461b87e68238e656613929fd63`.

## What it deploys

| Service | What it does | Storage |
|---|---|---|
| **Happier** (this repo) | API, realtime WebSocket channel and the web app on one public HTTPS domain. Health check: `/ready` (checks the database). | Volume at `/data` (uploaded files) |
| **Postgres** (Railway's own) | Accounts, sessions, messages (stored encrypted by your devices) | Railway Postgres volume |

It fits Railway's smallest plan: about 130 MB RAM for Happier at idle, 0.5 GB / 1 vCPU per service is enough.

## After the deploy

Happier accounts have no password: an account is a **secret key**. Anonymous sign-up is closed from the first
boot, so nobody else can create an account on your server. The template creates **your** account on the first boot
from a generated key:

1. In Railway, open the **Happier** service → **Variables** and copy `OWNER_SECRET_KEY` (52 characters).
   Keep it like a password: anyone with it can sign in as you.
2. Open the service's domain, choose **Login — I already use Happier** → **Restore with Secret Key Instead**, and
   paste the key.
3. To connect a computer, install the Happier CLI there and run `happier setup --relay "https://YOUR-DOMAIN"`
   (the web app shows the exact command), or add the server in the Happier mobile or desktop app.

## Variables

| Variable | Default | Notes |
|---|---|---|
| `OWNER_SECRET_KEY` | generated | Your account's secret key. Changing it later creates a second account (the first one stays). |
| `HANDY_MASTER_SECRET` | generated | Signs auth tokens and encrypts server-side secrets. Keep it stable: changing it signs every device out. |
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | Private-network link to the Postgres service. |
| `HAPPIER_PUBLIC_SERVER_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | The URL put in QR codes and links. Change it if you add a custom domain. |
| `PORT` | `3005` | The port Railway routes to. |

Optional, not set by the template: `AUTH_ANONYMOUS_SIGNUP_ENABLED=true` reopens public sign-up (anyone who finds
the URL can then create an account); GitHub or OIDC sign-in (`AUTH_SIGNUP_PROVIDERS`, `GITHUB_CLIENT_ID`, …, see
[Server auth](https://docs.happier.dev/self-hosting/auth)); S3 storage instead of the volume.

## Updates

The Happier service builds from this repository. When a new Happier release is tested here, the pin in the
`Dockerfile` is bumped and an entry is added to `CHANGELOG.md`; Railway then shows your project an
"update available" notice and you choose when to apply it. Database migrations run on start.

## How it works

- `Dockerfile`: the official image pinned by version and digest, switched to upstream's full flavor (Postgres,
  local files at `/data`), Sentry crash reports and the metrics port off.
- `start.sh`: fixes the volume's ownership, then on first boot starts the server on loopback with sign-up open,
  registers `OWNER_SECRET_KEY` through upstream's own key-challenge route (`POST /v1/auth`), stops it, and starts
  the server on `$PORT` with `AUTH_ANONYMOUS_SIGNUP_ENABLED=false`. A crash exits non-zero so Railway restarts it.
- `docker-compose.test.yml`: local test of the same setup (not used by Railway).

Not affiliated with the Happier project.
