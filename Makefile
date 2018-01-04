.PHONY: build test

build:
	docker run \
        --name=snap-py37 \
        -d \
        -it \
        --tmpfs /run \
        --tmpfs /run/lock \
        --tmpfs /tmp \
        --cap-add SYS_ADMIN \
        --device=/dev/fuse \
        --security-opt apparmor:unconfined \
        --security-opt seccomp:unconfined \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        -v /lib/modules:/lib/modules:ro \
        codeghar/snapcraft:latest || :
	docker exec -it snap-py37 mkdir -p python37/snap
	docker cp snapcraft.yaml snap-py37:/root/python37/snap/snapcraft.yaml
	docker cp build.sh snap-py37:/root/build.sh
	docker exec -it snap-py37 chmod +x /root/build.sh
	docker exec -it snap-py37 /root/build.sh
	docker cp snap-py37:/root/python37/python37_3.7.0a3+0_amd64.snap .

test:
	docker cp test.sh snap-py37:/root/test.sh
	docker exec -it snap-py37 chmod +x /root/test.sh
	docker exec -it snap-py37 /root/test.sh

all: build test

clean:
	docker kill snap-py37
	docker rm snap-py37
	rm python37_3.7.0a3+0_amd64.snap
