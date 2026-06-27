PROJECTNAME   := casns
PROJECTORG    := casapps
VERSION       := $(shell cat release.txt 2>/dev/null || echo "dev")
DOCKER_IMAGE  := ghcr.io/casapps/casns
BINARY        := binaries/$(PROJECTNAME)
GO_DOCKER     := docker run --rm -v $$(pwd):/app -w /app \
                   -e CGO_ENABLED=0 \
                   -e GOFLAGS=-buildvcs=false \
                   casjaysdev/go:latest

.PHONY: all dev local build test clean docker release lint fmt tidy

all: build

dev: tidy build

local: build

build:
	@mkdir -p binaries
	$(GO_DOCKER) go build \
		-ldflags="-s -w -X main.version=$(VERSION)" \
		-o /app/binaries/$(PROJECTNAME) \
		./src/

test:
	@mkdir -p "/tmp/$(PROJECTORG)"
	$(GO_DOCKER) sh -c 'COVDIR=$$(mktemp -d "/tmp/$(PROJECTORG)/$(PROJECTNAME)-XXXXXX") && \
		go test -coverprofile="$$COVDIR/coverage.out" ./src/... && \
		go tool cover -html="$$COVDIR/coverage.out" -o "$$COVDIR/coverage.html" && \
		echo "Coverage report: $$COVDIR/coverage.html"'

lint:
	$(GO_DOCKER) golangci-lint run ./src/...

fmt:
	$(GO_DOCKER) gofmt -w ./src/

tidy:
	$(GO_DOCKER) go mod tidy

clean:
	rm -rf binaries/ releases/

docker:
	docker build \
		--build-arg VERSION=$(VERSION) \
		-f docker/Dockerfile \
		-t $(DOCKER_IMAGE):$(VERSION) \
		-t $(DOCKER_IMAGE):latest \
		.

release:
	@mkdir -p releases
	@for os in linux darwin windows freebsd; do \
		for arch in amd64 arm64; do \
			ext=""; \
			if [ "$$os" = "windows" ]; then ext=".exe"; fi; \
			echo "Building $(PROJECTNAME)-$$os-$$arch$$ext..."; \
			docker run --rm -v $$(pwd):/app -w /app \
				-e CGO_ENABLED=0 \
				-e GOFLAGS=-buildvcs=false \
				-e GOOS=$$os \
				-e GOARCH=$$arch \
				casjaysdev/go:latest \
				go build \
					-ldflags="-s -w -X main.version=$(VERSION)" \
					-o /app/releases/$(PROJECTNAME)-$$os-$$arch$$ext \
					./src/; \
		done; \
	done
