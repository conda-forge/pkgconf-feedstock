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

# conda customization for CDT packages and cross-compilation
mv ${PREFIX}/bin/pkgconf ${PREFIX}/bin/pkgconf.bin
cp "${RECIPE_DIR}"/pkgconf ${PREFIX}/bin/pkgconf
chmod +x ${PREFIX}/bin/pkgconf

if [[ "${compat}" == "yes" ]]; then
  ln -s ${PREFIX}/bin/pkgconf ${PREFIX}/bin/pkg-config
  ln -s ${PREFIX}/bin/pkgconf ${PREFIX}/bin/${HOST}-pkg-config
fi
