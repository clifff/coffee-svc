APP_NAME = coffee-svc
POD_NAME = $(shell kubectl get po --selector=app=coffee-svc-coffee-svc -o jsonpath='{.items[*].metadata.name}')
TEST_COMMAND = bundle exec rake test

SRC_DIR := $(shell pwd)/app
DST_DIR := /app

DOCKER_VOLUME := $(SRC_DIR):$(DST_DIR)
DOCKER_REPO   := twelvelabs/$(APP_NAME)
DOCKER_TAG    := dev
DOCKER_IMAGE  := $(DOCKER_REPO):$(DOCKER_TAG)

build:
	docker build -t $(DOCKER_IMAGE) .

start:
	helm upgrade $(APP_NAME) ./charts/$(APP_NAME) --install --set image.repository=$(DOCKER_REPO),image.tag=$(DOCKER_TAG),sourcePath=$(SRC_DIR)

stop:
	helm delete --purge $(APP_NAME)

restart: stop start
install: build start

bash:
	docker run --rm -it -v $(DOCKER_VOLUME) $(DOCKER_IMAGE) bash

test:
	docker run --rm -it -v $(DOCKER_VOLUME) $(DOCKER_IMAGE) $(TEST_COMMAND)

kubetest:
	kubectl exec $(POD_NAME) $(TEST_COMMAND)

.PHONY: build start stop restart install bash test kubetest
default: build
