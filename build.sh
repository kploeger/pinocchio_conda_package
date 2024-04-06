#!/bin/bash

mkdir build && cd build 
cmake .. \
-DPYTHON_EXECUTABLE=$CONDA_PREFIX/bin/python3 \
-DCMAKE_INSTALL_PREFIX=$PREFIX \
-DBUILD_WITH_CASADI_SUPPORT=ON \
-DCMAKE_BUILD_TYPE=Release \
-DBoost_NO_SYSTEM_PATHS=TRUE \
-DBoost_INCLUDE_DIR=$CONDA_PREFIX/include \
-DBoost_LIBRARY_DIR=$CONDA_PREFIX/lib \
-DPython3_EXECUTABLE=$CONDA_PREFIX/bin/python \
-DPython3_INCLUDE_DIR=$CONDA_PREFIX/include/python3.9 \
-DPython3_LIBRARY=$CONDA_PREFIX/lib/libpython3.9.so \
--log-level=VERBOSE

make -j2
make install
