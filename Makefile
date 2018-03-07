DOCKER_EXEC := pipenv run docker-compose exec builder
PYTHON37_VERSION ?= 3.7.0b2
PWD := $(shell pwd)


.PHONY: init
init:
	pipenv install


.PHONY: all
all: build test get-snap


.PHONY: build
build: up
	$(DOCKER_EXEC) $(BUILD_CONTAINER_WORK_DIR)/build.sh


.PHONY: test
test:
	$(DOCKER_EXEC) $(BUILD_CONTAINER_WORK_DIR)/test.sh


.PHONY: get-snap
get-snap: | $(PWD)/python37_$(PYTHON37_VERSION)_amd64.snap


$(PWD)/python37_$(PYTHON37_VERSION)_amd64.snap:
	docker cp $(BUILD_CONTAINER_NAME):/root/python37/python37_$(PYTHON37_VERSION)_amd64.snap .


.PHONY: up
up:
	. .envrc && pipenv run docker-compose up -d


.PHONY: clean
clean:
	. .envrc && pipenv run docker-compose down


.PHONY: destroy
destroy: clean
	rm -f **/*.snap


.PHONY: list
list:
	@grep '^\.PHONY' ./Makefile | awk '{print $$2}'
