#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ ${target_platform} =~ .*linux.* ]]; then
    export CFLAGS="${CFLAGS} -D_POSIX_C_SOURCE=200809L"
else
    export CFLAGS="${CFLAGS} -D_DARWIN_C_SOURCE"
fi

# By default the system libdir/includedir are ${PREFIX}/lib and ${PREFIX}/include,
# which makes pkgconf filter -L${PREFIX}/lib and -I${PREFIX}/include out of
# --libs and --cflags. /usr/lib and /usr/include must not be filtered either,
# because conda's compilers use their own sysroot and do not search them.
# An empty value means the default to meson, so pass ":", which pkgconf splits
# into an empty list and therefore filters nothing.
meson ${MESON_ARGS} \
    --wrap-mode=nofallback \
    -Dwith-system-libdir=: \
    -Dwith-system-includedir=: \
    build
meson compile -C build -v
meson install -C build

# conda customization for CDT packages and cross-compilation
mv ${PREFIX}/bin/pkgconf ${PREFIX}/bin/pkgconf.bin
cp "${RECIPE_DIR}"/pkgconf ${PREFIX}/bin/pkgconf
chmod +x ${PREFIX}/bin/pkgconf


# pkg-config compat links; only shipped by the compat variant of pkgconf
ln -s ${PREFIX}/bin/pkgconf ${PREFIX}/bin/pkg-config
ln -s ${PREFIX}/bin/pkgconf ${PREFIX}/bin/${HOST}-pkg-config
