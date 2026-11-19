#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ "${compat}" == "yes" ]]; then
  ln -s ${PREFIX}/bin/pkgconf ${PREFIX}/bin/pkg-config
  ln -s ${PREFIX}/bin/pkgconf ${PREFIX}/bin/${HOST}-pkg-config
fi
