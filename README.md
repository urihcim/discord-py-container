# discord.py Container

A runtime image for Discord bots written with [discord.py](https://github.com/Rapptz/discord.py).
The image contains Python and the libraries only. Bot code is not included: mount it into `/app` at run time (for example from a ConfigMap or with git-sync on Kubernetes).

## Contents

- Python (`python:<version>-slim`). The time zone is UTC by default; set the `TZ` environment variable (e.g., `TZ=Asia/Tokyo`) to change it. The base image includes `tzdata`.
- Libraries from [`requirements.txt`](requirements.txt): `discord-py`, `lxml`, `pillow`
- The libraries are installed in a virtual environment at `/opt/venv`, which is on `PATH`. Mounting code at `/app` does not hide them.
- Runs as the non-root user `bot` (UID/GID 1000) in `/app`. The default command is `python`.
- Platforms: `linux/amd64`, `linux/arm64`

## Docker Images & Tags

Images are published to the GitHub Container Registry (GHCR).

- [urihcim/discord-py](https://github.com/urihcim/discord-py-container/pkgs/container/discord-py)

```bash
docker pull ghcr.io/urihcim/discord-py:<TAG>
```

| Tag | Description |
|---|---|
| `[version]` | Released version (e.g., `1.0.0`) |
| `latest` | Latest `main` branch |

## Usage

```bash
docker run --rm \
  -v "$(pwd)":/app:ro \
  --env-file .env \
  -e TZ=Asia/Tokyo \
  ghcr.io/urihcim/discord-py:<TAG> \
  python -m mybot
```

To install extra packages for tests, run `pip install` in the container. Run it as root, or as UID 1000, because `/opt/venv` belongs to root.

## Releases

Releases are automated with [release-please](https://github.com/googleapis/release-please).

1. Commits on `main` follow [Conventional Commits](https://www.conventionalcommits.org/). Dependabot uses `fix(deps):` for pip/Docker updates and `chore(deps):` for GitHub Actions updates.
2. release-please keeps a release PR open that bumps `.release-please-manifest.json` and updates `CHANGELOG.md`. `fix` bumps the patch version, `feat` bumps the minor version, and a breaking change bumps the major version.
3. Merging the release PR creates the `v*` tag and GitHub Release, and dispatches the image build for that tag.

`chore` commits (including GitHub Actions updates) do not trigger a release on their own.
