SH := /bin/sh
PWD := $(shell pwd)
export BUILD_DOCKER_IMAGE := localhost/snappython37:latest
export BUILD_CONTAINER_NAME := py37-snap-builder
export TEST_CONTAINER_NAME := py37-snap-test
export TEST_CONTAINER_WORK_DIR := /test
export TEST_CONTAINER_ARTIFACTS_DIR := /artifacts
export PYTHON37_VERSION := 3.7.0
export TEST_DIR := $(PWD)/test
export SNAP_DIR := $(PWD)/snap
export SNAP_NAME := python37-codeghar
export PYTHON_SNAP := $(SNAP_NAME)_$(PYTHON37_VERSION)_amd64.snap


.PHONY: init
init: | $(SNAP_DIR)
	pipenv install


.PHONY: all
all: build get-snap test clean


.PHONY: build
build:
	docker build --tag=$(BUILD_DOCKER_IMAGE) ./build


.PHONY: get-snap
get-snap: | $(SNAP_DIR)/$(PYTHON_SNAP)


$(SNAP_DIR):
	mkdir -p $(SNAP_DIR)


$(SNAP_DIR)/$(PYTHON_SNAP): | $(SNAP_DIR)
	docker run --rm --tty --detach --name $(BUILD_CONTAINER_NAME) $(BUILD_DOCKER_IMAGE) bash
	docker cp $(BUILD_CONTAINER_NAME):/build_root/$(PYTHON_SNAP) $(SNAP_DIR)/
	docker stop $(BUILD_CONTAINER_NAME)


.PHONY: test
test:
	pipenv run docker-compose --file $(TEST_DIR)/docker-compose.yml up -d
	pipenv run docker-compose --file $(TEST_DIR)/docker-compose.yml exec test ./test.sh


.PHONY: install
install:
	sudo snap install --dangerous --classic snap/$(PYTHON_SNAP)


.PHONY: verify
verify:
	$(SNAP_NAME).python37 --version


.PHONY: clean
clean:
	pipenv run docker-compose --file $(TEST_DIR)/docker-compose.yml down
	docker rm -f $(BUILD_CONTAINER_NAME)  || :


.PHONY: destroy
destroy: clean
	rm -f $(PWD)/*.snap
	rm -f **/*.snap
	rm -rf $(SNAP_DIR)


.PHONY: list
list:
	@grep '^\.PHONY' ./Makefile | awk '{print $$2}'
