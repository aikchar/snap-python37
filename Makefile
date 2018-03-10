PWD := $(shell pwd)
DOCKER_EXEC := pipenv run docker-compose exec builder


.PHONY: init
init: | $(SNAP_DIR)
	pipenv install


.PHONY: all
all: build get-snap test clean


.PHONY: build
build:
	. .envrc && docker build --tag $(BUILD_DOCKER_IMAGE) --build-arg PYTHON37_VERSION=$(PYTHON37_VERSION) ./build


.PHONY: get-snap
get-snap: | $(SNAP_DIR)/$(PYTHON_SNAP)


$(SNAP_DIR):
	mkdir -p $(SNAP_DIR)


$(SNAP_DIR)/$(PYTHON_SNAP): | $(SNAP_DIR)
	. .envrc && docker run --tty --detach --name $(BUILD_CONTAINER_NAME) $(BUILD_DOCKER_IMAGE) bash
	. .envrc && docker cp $(BUILD_CONTAINER_NAME):$(BUILD_CONTAINER_WORK_DIR)/$(PYTHON_SNAP) $(SNAP_DIR)/
	. .envrc && docker rm -f $(BUILD_CONTAINER_NAME)


.PHONY: test
test:
	. .envrc && pipenv run docker-compose --file $(TEST_DIR)/docker-compose.yml up -d
	. .envrc && pipenv run docker-compose --file $(TEST_DIR)/docker-compose.yml exec test ./test.sh


.PHONY: clean
clean:
	. .envrc && pipenv run docker-compose --file $(TEST_DIR)/docker-compose.yml down
	docker rm -f $(BUILD_CONTAINER_NAME)  || :


.PHONY: destroy
destroy: clean
	rm -f $(PWD)/*.snap
	rm -f **/*.snap
	rm -rf $(SNAP_DIR)


.PHONY: list
list:
	@grep '^\.PHONY' ./Makefile | awk '{print $$2}'
