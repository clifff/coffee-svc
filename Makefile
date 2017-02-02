.PHONY: build start install

DOCKER_IMAGE = twelvelabs/coffee-svc:dev

build:
	docker build -t $(DOCKER_IMAGE) .

start:
	helm upgrade coffee-svc ./charts/coffee-svc --install --set sourcePath=$$(pwd)/app

test:
	docker run --rm -it $(DOCKER_IMAGE) bundle exec rake test

install: build start

default: build
