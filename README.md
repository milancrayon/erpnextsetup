# Woodwolf ERPNext on Coolify

Fresh production deploy of ERPNext (latest v16) with HRMS and Frappe CRM,
built as a custom Docker image on the Coolify server. No external image
registry needed.

## Stack

- Base image: `frappe/erpnext:v16.37.0` (latest v16 as of Oct 2026)
- Baked-in apps:
  - `hrms` from the `version-16` branch
  - `crm` from the `develop` branch (tracks Frappe v16)
- Database: `mariadb:11.8`
- Redis: `redis-cache`, `redis-queue`

## How it works

1. `Dockerfile` builds one custom image on top of `frappe/erpnext`,
   installing HRMS and CRM and building their assets.
2. `docker-compose.yml` builds that image once (in `configurator`) and
   reuses the local image for every runtime service.
3. `create-site` is idempotent: it creates the site and installs
   `erpnext`, `hrms`, `crm` on first run, and only runs migrations after.

## Deploying in Coolify

1. Push these two files to a **public** GitHub repo (no secrets in them).
2. Coolify: New resource -> Application -> Public repository.
3. Build pack: **Docker Compose**, compose location `/docker-compose.yml`,
   exposed port `8080`.
4. Set environment variables on the application:
   - `SITE_NAME` (e.g. `erp.woodwolfdigital.com`)
   - `SERVICE_PASSWORD_ADMIN` (ERPNext Administrator password)
   - `SERVICE_PASSWORD_DB` (MariaDB root password)
5. Deploy. First deploy builds the image (takes a while), then creates
   the site automatically.

Routing is handled by Traefik labels on the `frontend` service, using
`SITE_NAME` as the host with automatic Let's Encrypt TLS.
