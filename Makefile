SUDO := $(shell groups | grep -q docker || echo sudo -E)

.PHONY: build start stop test

build:
	$(SUDO) docker-compose build

start:
	$(SUDO) docker-compose up -d

stop:
	$(SUDO) docker-compose down -v

test: start
	$(SUDO) docker build --file docker/testing.Dockerfile --tag cc-pytest . \
	&& $(SUDO) docker run --rm --net backend_coding_challenge_default cc-pytest