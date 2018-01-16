[![Docker Build Statu](https://img.shields.io/docker/build/terencewestphal/archlinux.svg)](https://hub.docker.com/r/terencewestphal/archlinux/builds/) ![Docker Stars](https://img.shields.io/docker/stars/terencewestphal/archlinux.svg) [![Docker Pulls](https://img.shields.io/docker/pulls/terencewestphal/archlinux.svg)](https://hub.docker.com/r/terencewestphal/archlinux/) 

# Docker - Arch Linux

[![Minecraft](https://github.com/terencewestphal/docker-archlinux/blob/master/archlinux-logo.png?raw=true)](https://archlinux.org)

## Features

* Build with the latest version of Arch Linux Bootstrap.
* Bootstrap archive and signature from [https://archive.archlinux.org]()
* Supported architecture: x86_64

## Requirements

* Docker 17.05 or higher (for multi-stage builds) 


## Build

Modify and build the container image from source:
```
git clone https://github.com/terencewestphal/docker-archlinux.git
cd docker-archlinux
```
```
docker build -t archlinux:<tag> .
```

## Usage

### Systemd

Run in detached mode:
```
docker run --rm \
           --detach \
           --tmpfs /tmp \
           --tmpfs /run \
           --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
           --cap-add SYS_ADMIN \
           --security-opt=seccomp:unconfined \
           --hostname archlinux.io \
           --name archlinux \
           archlinux
```

Enter container:
```
docker exec --tty --interactive archlinux zsh  
```