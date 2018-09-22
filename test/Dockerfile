FROM ubuntu:bionic

WORKDIR /root

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8 SNAPCRAFT_SETUP_CORE=1 container=docker PATH=/snap/bin:$PATH DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

# https://stackoverflow.com/a/20693661
COPY preseed.txt /usr/local/etc/preseed.txt

RUN apt update &&\
    debconf-set-selections /your/preseed.txt &&\
    apt install -y fuse make snapd snap-confine squashfuse sudo snapcraft tzdata &&\
    dpkg-divert --local --rename --add /sbin/udevadm &&\
    ln -s /bin/true /sbin/udevadm &&\
    systemctl enable snapd

VOLUME ["/sys/fs/cgroup"]

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]
