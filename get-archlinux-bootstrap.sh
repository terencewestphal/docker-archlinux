#!/usr/bin/env bash

# Get Arch Linux Bootstrap

set -e

cache() {
    [[ -f "${1}" ]] || return 1
    print " ---> Found in cache: ${1}"
}

error() {
    printf "%b\n" "${*:-}"  1>&2
    exit 1
}

dependency() {
  for executable in "$@"; do
    ! type ${executable} >/dev/null 2>&1 && \
    print " ---> Dependency not installed: ${executable}" 1>&2 && return 1
  done; return 0
}

download() {
    print " ---> Downloading: ${2:-}"
    curl "${1:-}/${2:-}" -# -O -f --stderr -
}

latest() {
    local this_year=$(date +%Y)
    local this_month=$(date +%m)
    local today=$(date +%d)
    local last_year=$((this_year-1))
    local last_month=$(printf "%02d" $((this_month-1)))

    local range1="$this_year.$this_month.[00-$today]"
    local range2="$this_year.$last_month.[01-31]"
    local range3="$this_year.[00-$this_month].[01-31]"
    local range4="$last_year.[01-12].[01-31]"
    local ranges=(${range1} ${range2} ${range3} ${range4})

    local latest
    local counter=0
    local mirror="${1:-https://archive.archlinux.org}"
    local url="${mirror}/iso/${ranges[$counter]}/md5sums.txt"
    local options="-I --compressed --stderr -"
    local filter='/Last-Modified/ {print $3,$4,$5;}'
    while [[ ! ${latest} && ${counter} -lt 4 ]]; do
        latest=$(curl "${url}" ${options} | awk "${filter}" | tail -1)
        let counter+=1
    done

    local version=$(date -d "${latest}" +%Y.%m.%d)
    printf "%b" "${version}"
}

mirrorlist() {
    local date=${1//.//}
    local repository="Server=https://archive.archlinux.org/repos/${date:-}/\$repo/os/\$arch"
    print " ---> Setting up mirrorlist: /etc/pacman.d/mirrorlist"
    print " ---> ${repository:-}"
    printf "%b\n" "${repository}" > "${2:-}/etc/pacman.d/mirrorlist"
}

motd() {
  cat ./motd
}

print() {
    printf "%b\n" "${*:-}"  2>&1
}

unpack() {
    print " ---> Unpack archive: ${1:-}"
    tar --strip-components=1 -zxf "${1:-}" -C "${2:-}" -X exclude || error "Failed to unpack: ${1:-}"
}

verify() {
    print " ---> Verifying signature"
    gpg --auto-key-retrieve --verify ${1:-} >/dev/null 2>&1 && return 0 || error "Failed to verify: ${1:-}"
}

workdir() {
    print " ---> Setting up workdir: ${1:-}"
    mkdir -p "${1:-}" || error "Failed to create workdir: ${1:-}"
}

main() {
    local mirror="${1:-https://archive.archlinux.org}"
    local latest=$(latest ${mirror})
    local base_url="${mirror}/iso/${latest}"
    local bootstrap="archlinux-bootstrap-${latest}-x86_64.tar.gz"
    local signature="${bootstrap}.sig"
    local workdir="./bootstrap"

    print " ---> Latest version: ${latest}-x86_64"
    cache "${bootstrap}" || download "${base_url}" "${bootstrap}"
    cache "${signature}" || download "${base_url}" "${signature}"
    verify "${signature}"
    workdir "${workdir}"
    unpack "${bootstrap}" "${workdir}"
    mirrorlist "${latest}" "${workdir}"
}

main

