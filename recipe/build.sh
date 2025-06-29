#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ ${target_platform} =~ .*linux.* ]]; then
    export CFLAGS="${CFLAGS} -D_POSIX_C_SOURCE=200809L"
else
    export CFLAGS="${CFLAGS} -D_DARWIN_C_SOURCE"
fi

meson ${MESON_ARGS} --wrap-mode=nofallback build
meson compile -C build -v
meson install -C build
