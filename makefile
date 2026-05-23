.PHONY: run
run:
	uv run ./repo-sync

.PHONY: lint
lint:
	uv run ruff check .
	uv run ruff format --check .

.PHONY: format
format:
	uv run ruff check --fix .
	uv run ruff format .

.PHONY: status
status:
	curl --silent http://127.0.0.1:8080/status | jq

.PHONY: sync
sync:
	curl --silent http://127.0.0.1:8080/status | jq
	curl --write-out "%{http_code}\n" --request POST http://127.0.0.1:8080/sync
	curl --write-out "%{http_code}\n" --request POST http://127.0.0.1:8080/sync
	curl --silent http://127.0.0.1:8080/status | jq

.PHONY: container-build
container-build:
	docker build --tag repo-sync --file Containerfile .
	docker images repo-sync

.PHONY: container-test
container-test:
ifndef REPO_URL
	$(error REPO_URL is undefined)
endif
	docker run --detach --name repo-sync-test --publish 8080:8080 --volume /etc/localtime:/etc/localtime:ro --env REPO_URL=$(REPO_URL) repo-sync
	sleep 10
	curl --fail http://127.0.0.1:8080/status
	docker logs repo-sync-test
	docker rm --force repo-sync-test

# Create classic token with write:packages permission
# On https://github.com/<USER>?tab=packages mark package public
.PHONY: container-push
container-push: container-build
ifndef CR_PAT
	$(error CR_PAT is undefined)
endif
	echo $(CR_PAT) | docker login ghcr.io --username thomasstauffer666 --password-stdin
	docker tag repo-sync ghcr.io/thomasstauffer666/repo-sync:latest
	docker tag repo-sync ghcr.io/thomasstauffer666/repo-sync:1.0.0
	docker push ghcr.io/thomasstauffer666/repo-sync:latest
	docker push ghcr.io/thomasstauffer666/repo-sync:1.0.0
