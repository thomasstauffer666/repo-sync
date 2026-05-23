FROM python:3.13-alpine

RUN apk add --no-cache git ca-certificates uv

WORKDIR /srv/repo-sync

COPY pyproject.toml uv.lock .
RUN uv sync --frozen --no-dev

ENV PYTHONUNBUFFERED=1

COPY repo-sync .

EXPOSE 8080

ENTRYPOINT ["uv", "run", "--no-dev", "python3.13", "repo-sync"]
