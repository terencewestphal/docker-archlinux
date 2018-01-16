FROM alpine:latest as builder

WORKDIR /tmp

ADD . .

RUN apk --update add bash curl coreutils gnupg
RUN bash ./get-archlinux-bootstrap.sh

FROM scratch
COPY --from=builder /tmp/bootstrap /

ENV container docker \
    LANG en_US.UTF-8

RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm grep gzip less systemd-sysvcompat zsh grml-zsh-config vim && \
    locale-gen && \
    systemctl set-default bootstrap.target

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]

ENTRYPOINT ["/usr/sbin/init"]