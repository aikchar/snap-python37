CONTAINER_NAME := snap-py37
DOCKER_EXEC := docker exec -it $(CONTAINER_NAME)
PYTHON37_VERSION ?= 3.7.0b2
PWD := $(shell pwd)


.PHONY: all
all: build test get-snap


.PHONY: build
build: run-container
	$(DOCKER_EXEC) apt update
	$(DOCKER_EXEC) mkdir -p python37/snap
	docker cp snapcraft.yaml $(CONTAINER_NAME):/root/python37/snap/snapcraft.yaml
	docker cp build.sh $(CONTAINER_NAME):/root/build.sh
	$(DOCKER_EXEC) chmod +x /root/build.sh
	$(DOCKER_EXEC) /root/build.sh


.PHONY: test
test:
	docker cp test.sh $(CONTAINER_NAME):/root/test.sh
	$(DOCKER_EXEC) chmod +x /root/test.sh
	$(DOCKER_EXEC) /root/test.sh


.PHONY: get-snap
get-snap: | $(PWD)/python37_$(PYTHON37_VERSION)_amd64.snap


$(PWD)/python37_$(PYTHON37_VERSION)_amd64.snap:
	docker cp $(CONTAINER_NAME):/root/python37/python37_$(PYTHON37_VERSION)_amd64.snap .


.PHONY: run-container
run-container:
		docker run \
        --name=$(CONTAINER_NAME) \
        -d \
        -it \
		--env PYTHON37_VERSION=$(PYTHON37_VERSION) \
        --tmpfs /run \
        --tmpfs /run/lock \
        --tmpfs /tmp \
        --cap-add SYS_ADMIN \
        --device=/dev/fuse \
        --security-opt apparmor:unconfined \
        --security-opt seccomp:unconfined \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        -v /lib/modules:/lib/modules:ro \
		--privileged \
        codeghar/snapcraft:latest || :


.PHONY: clean
clean:
	@docker kill $(CONTAINER_NAME) || :
	@docker rm $(CONTAINER_NAME) || :


.PHONY: destroy
destroy: clean
	rm python37_$(PYTHON37_VERSION)_amd64.snap


.PHONY: list
list:
	@grep '^\.PHONY' ./Makefile | awk '{print $$2}'
