# Repo-Sync

A simple web server to keep a local repository synchronized with a remote one. It supports manual synchronization via HTTP endpoints and automatic synchronization based on a cron schedule.

## Features

- **Automated Sync**: Synchronize the repository at regular intervals using cron expressions.
- **Manual Sync**: Trigger an immediate synchronization via a POST request.
- **Status Monitoring**: Check the last sync time and history via a GET request.
- **Post-Pull Hook**: Execute a custom command after a successful pull.
- **Cooldown Mechanism**: Prevent excessive sync operations with a configurable cooldown period.
- **Containerized**: Ready to be deployed as a container.

## Configuration

The application is configured using environment variables:

| Environment Variable      | Description                                    | Default                      |
| ------------------------- | ---------------------------------------------- | ---------------------------- |
| `REPO_URL`                | The URL of the repository to sync.             | None                         |
| `SYNC_AUTO_INTERVAL_TIME` | Cron expression for automatic synchronization. | `0 5 * * *` (Daily at 05:00) |
| `SYNC_COOLDOWN_SECONDS`   | Minimum time between syncs in seconds.         | `300` (5 minutes)            |
| `PORT`                    | The port the web server listens on.            | `8080`                       |
| `POST_PULL_COMMAND`       | Command to run after a successful pull.        | None                         |

## API Endpoints

### POST /sync

Triggers a manual synchronization.

**Returns**:
- `200 OK`: Sync started or already up to date.
- `429 Too Many Requests`: Sync requested within the cooldown period.
- `500 Internal Server Error`: An error occurred, including synchronization.

### GET /status

Returns the status of the synchronization.

**Returns**:
- `200 OK`: JSON object with `last_sync_ago_seconds` and `sync_history`.

## Usage

### Local Development

```sh
uv run ./repo-sync
```

### Docker

```sh
make container-build
```

```sh
docker run --env REPO_URL=https://github.com/user/repo.git --publish 127.0.0.1:8080:8080 repo-sync
```

### Docker Compose

A [docker-compose.yml](docker-compose.yml) is provided as an example.

```sh
docker pull ghcr.io/thomasstauffer666/repo-sync:latest
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
