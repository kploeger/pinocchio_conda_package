#!/bin/sh

mkdir build && cd build

export BUILD_NUMPY_INCLUDE_DIRS=$( $PYTHON -c "import numpy; print (numpy.get_include())")
export TARGET_NUMPY_INCLUDE_DIRS=$SP_DIR/numpy/core/include

echo $BUILD_NUMPY_INCLUDE_DIRS
echo $TARGET_NUMPY_INCLUDE_DIRS

export GENERATE_PYTHON_STUBS=1
if [[ $CONDA_BUILD_CROSS_COMPILATION == 1 ]]; then
  echo "Copying files from $BUILD_NUMPY_INCLUDE_DIRS to $TARGET_NUMPY_INCLUDE_DIRS"
  mkdir -p $TARGET_NUMPY_INCLUDE_DIRS
  cp -r $BUILD_NUMPY_INCLUDE_DIRS/numpy $TARGET_NUMPY_INCLUDE_DIRS
  export GENERATE_PYTHON_STUBS=0
fi

cmake ${CMAKE_ARGS} .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_WITH_URDF_SUPPORT=ON \
      -DBUILD_WITH_COLLISION_SUPPORT=ON \
      -DPython3_NumPy_INCLUDE_DIR=$TARGET_NUMPY_INCLUDE_DIRS \
      -DBUILD_WITH_OPENMP_SUPPORT=ON \
      -DBUILD_TESTING=OFF \
      -DGENERATE_PYTHON_STUBS=$GENERATE_PYTHON_STUBS \
      -DPYTHON_EXECUTABLE=$PYTHON \
      -DBUILD_WITH_CASADI_SUPPORT=ON \
      -DBoost_NO_SYSTEM_PATHS=TRUE \
      -DBoost_INCLUDE_DIR=$CONDA_PREFIX/include \
      -DBoost_LIBRARY_DIR=$CONDA_PREFIX/lib \
      -DCMAKE_INSTALL_RPATH="${PREFIX}/lib" \
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \

make -j${CPU_COUNT}
make install

if [[ $CONDA_BUILD_CROSS_COMPILATION == 1 ]]; then
  echo $BUILD_PREFIX
  echo $PREFIX
  sed -i.back 's|'"$BUILD_PREFIX"'|'"$PREFIX"'|g' $PREFIX/lib/cmake/pinocchio/pinocchioTargets.cmake
  rm $PREFIX/lib/cmake/pinocchio/pinocchioTargets.cmake.back
fi
