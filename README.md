# GitHub Actions Self-Hosted Runner

This repository contains a Docker-based GitHub Actions self-hosted runner that supports both web and Android builds.

## Features

- Supports Docker-in-Docker operations
- Includes Android SDK for mobile builds
- Pre-installed with Node.js 18 and Java 17
- Includes Expo CLI and EAS CLI for React Native builds
- Automatic runner registration and deregistration
- Runner name randomization for multiple instances

## Prerequisites

- Docker and Docker Compose installed
- GitHub Personal Access Token with necessary permissions:
  - `repo` (full control)
  - `workflow` (full control)
  - `admin:org` (read/write)
- Access to GitHub Container Registry (GHCR)

## Setup

1. Clone this repository
2. Copy `.env.example` to `.env` and fill in your details:
   ```bash
   cp .env.example .env
   ```

3. Edit the `.env` file with your GitHub details:
   ```
   ORGANIZATION=your-org-or-username
   REPO=your-repo-name
   ACCESS_TOKEN=your-github-pat
   ```

4. Pull the latest runner image:
   ```bash
   docker compose pull
   ```

5. Start the runner:
   ```bash
   docker compose up -d
   ```

## Local Development

To build the runner locally instead of pulling from GHCR:

```bash
docker compose build
docker compose up -d
```

## Monitoring

```bash
# View logs
docker compose logs -f

# Check runner status
docker compose ps

# Restart runner
docker compose restart
```

## GitHub Workflow

The repository includes a GitHub Actions workflow that automatically builds and pushes the runner image to GitHub Container Registry when changes are made to the Dockerfile or startup script.

## Security Notes

- The runner container runs with elevated privileges (required for Docker-in-Docker)
- Secure your `.env` file and never commit it to version control
- Regularly rotate your GitHub PAT
- Monitor runner logs for suspicious activity

## License

MIT