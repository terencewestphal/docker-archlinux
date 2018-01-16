# Docker - Arch Linux

# <img src="archlinux-logo.png" alt="Arch Linux" width="350">

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