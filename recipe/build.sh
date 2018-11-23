#!/bin/bash
export CFLAGS="$CFLAGS -idirafter /usr/include"
export CXXFLAGS="$CXXFLAGS -idirafter /usr/include"
export LDFLAGS="$LDFLAGS -L/usr/lib/x86_64-linux-gnu"

cd build

cmake \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
    -DCMAKE_PREFIX_PATH:PATH="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR="lib" \
    -DCMAKE_LIBRARY_ARCHITECTURE=x86_64-linux-gnu \
    ./cmake

make -j${CPU_COUNT}
make install

# Don't install the cmake files for 2 reasons:
#   1 - cmake already provides a FindGLEW.cmake
#   2 - the generated file contains hardcoded paths to /usr/lib, to reference the files
#       GL.so and GLU.so libraries.
#       Other distros don't use this nomenclature (eg.: Ubuntu) making these files unsuitable for use
#       in other distros other than redhat/centos.
if [ -d "${PREFIX}/lib/cmake/glew/" ]; then
    rm -rf $PREFIX/lib/cmake/glew/
fi
