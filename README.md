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

```
docker build -t archlinux:bootstrap .
```

## Usage

### Systemd

Run in detached mode
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
           archlinux:bootstrap
```

Enter container
```
docker exec --tty --interactive archlinux zsh  
```