#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CFLAGS="${CFLAGS} -D_POSIX_C_SOURCE=200809L"

meson ${MESON_ARGS} --wrap-mode=nofallback build
meson compile -C build -v
meson install -C build
