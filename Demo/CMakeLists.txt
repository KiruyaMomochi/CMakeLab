# CMakeList.txt : CMake project for Demo, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.8)

# Add source to this project's executable.
add_executable (Demo "Demo.cpp" "Demo.h")

# Link libraries.

find_package (Eigen3 REQUIRED)
find_package (LAPACK REQUIRED)
find_package (BLAS REQUIRED)
find_package (blaze REQUIRED)

target_link_libraries (Demo
                       PRIVATE
                       Eigen3::Eigen
                       LAPACK::LAPACK
                       BLAS::BLAS
                       blaze::blaze)

find_package(PkgConfig REQUIRED)

pkg_check_modules(gmp REQUIRED IMPORTED_TARGET gmp)
target_link_libraries(Demo PRIVATE PkgConfig::gmp)
pkg_check_modules(mpfr REQUIRED IMPORTED_TARGET mpfr)
target_link_libraries(Demo PRIVATE PkgConfig::mpfr)

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET Demo PROPERTY CXX_STANDARD 17)
endif()

# TODO: Add tests and install targets if needed.
