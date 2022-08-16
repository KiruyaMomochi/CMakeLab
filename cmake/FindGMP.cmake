# https://github.com/dune-project/dune-common/blob/master/cmake/modules/FindGMP.cmake

#[=======================================================================[.rst:
FindGMP
-------

Finds the GNU MULTI-Precision Bignum (GMP) library
and the corresponding C++ bindings GMPxx.

This module searches for both libraries and only considers the package
found if both can be located. It then defines separate targets for the C
and the C++ library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``GMP::GMP``
  Library target of the C library.
``GMP::GMPXX``
  Library target of the C++ library, which also links to the C library.

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``GMP_FOUND``
  True if the GMP library, the GMPxx headers and
  the GMPxx library were found.
``GMP_VERSION``
  The version of the GMP library which was found.
``GMP_INCLUDE_DIRS``
  Include directories needed to use GMP.
``GMP_LIBRARIES``
  Libraries needed to use GMP.
``GMPXX_FOUND``
  True if the GMPxx library was found.
``GMPXX_INCLUDE_DIRS``
  Include directories needed to use GMPxx.
``GMPXX_LIBRARIES``
  Libraries needed to use GMPxx.
  

Cache Variables
^^^^^^^^^^^^^^^

You may set the following variables to modify the behaviour of
this module:

``GMP_INCLUDE_DIR``
  The directory containing ``gmp.h``.
``GMP_LIBRARY``
  The path to the gmp library.
``GMPXX_INCLUDE_DIR``
  The directory containing ``gmpxx.h``.
``GMPXX_LIBRARY``
  The path to the gmpxx library.

#]=======================================================================]

# Add a feature summary for this package
include(FeatureSummary)
set_package_properties(GMP PROPERTIES
  DESCRIPTION "GNU multi-precision library"
  URL "https://gmplib.org"
)

# Try finding the package with pkg-config
find_package(PkgConfig QUIET)
pkg_check_modules(PC_GMP QUIET gmp gmpxx)
set(GMP_VERSION PC_GMP_gmp_VERSION)

# Try to locate the libraries and their headers, using pkg-config hints
include(SelectLibraryConfigurations)

# Find GMP
find_path(GMP_INCLUDE_DIR
  NAMES gmp.h
  HINTS ${PC_GMP_INCLUDE_DIRS})
get_filename_component(GMP_INSTALL_DIR ${GMP_INCLUDE_DIR} DIRECTORY)

find_library(GMP_LIBRARY_RELEASE
  NAMES gmp gmp.lib
  HINTS "${PC_GMP_gmp_LIBDIR}/Release" "${GMP_INSTALL_DIR}/debug/lib"
)
find_library(GMP_LIBRARY_DEBUG
  NAMES gmp gmp.lib
  HINTS "${PC_GMP_gmp_LIBDIR}/Debug" "${GMP_INSTALL_DIR}/lib"
)
select_library_configurations(GMP)

# Find GMPXX
find_path(GMPXX_INCLUDE_DIR
  NAMES gmpxx.h
  HINTS ${PC_GMP_gmpxx_INCLUDEDIR})
get_filename_component(GMPXX_INSTALL_DIR ${GMPXX_INCLUDE_DIR} DIRECTORY)

find_library(GMPXX_LIBRARY_RELEASE
  NAMES gmpxx libgmpxx
  HINTS "${PC_GMP_gmpxx_LIBDIR}/Release" "${GMPXX_INSTALL_DIR}/debug/lib"
)
find_library(GMPXX_LIBRARY_DEBUG
  NAMES gmpxx libgmpxx
  HINTS "${PC_GMP_gmpxx_LIBDIR}/Debug" "${GMPXX_INSTALL_DIR}/lib"
)
select_library_configurations(GMPXX)

# Remove these variables from cache inspector
mark_as_advanced(GMP_INCLUDE_DIR GMP_LIBRARY GMPXX_INCLUDE_DIR GMPXX_LIBRARY)

# Report if package was found
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GMP
  FOUND_VAR GMP_FOUND
  REQUIRED_VARS
    GMP_INCLUDE_DIR GMP_LIBRARY GMPXX_INCLUDE_DIR GMPXX_LIBRARY
  VERSION_VAR
    GMP_VERSION
)

# Set targets
if(GMP_FOUND)
  # C library
  if(NOT TARGET GMP::GMP)
    add_library(GMP::GMP UNKNOWN IMPORTED)
  endif()
  if (GMP_LIBRARY_RELEASE)
    set_property(TARGET GMP::GMP APPEND PROPERTY
      IMPORTED_CONFIGURATIONS RELEASE
    )
    set_target_properties(GMP::GMP PROPERTIES
      IMPORTED_LOCATION ${GMP_LIBRARY_RELEASE}
    )
  endif()
  if (GMP_LIBRARY_DEBUG)
    set_property(TARGET GMP::GMP APPEND PROPERTY
      IMPORTED_CONFIGURATIONS DEBUG
    )
    set_target_properties(GMP::GMP PROPERTIES
      IMPORTED_LOCATION ${GMP_LIBRARY_DEBUG}
    )
  endif()
  set_target_properties(GMP::GMP PROPERTIES
    IMPORTED_LOCATION ${GMP_LIBRARY}
    INTERFACE_INCLUDE_DIRECTORIES ${GMP_INCLUDE_DIR}
  )

  # C++ library, which requires a link to the C library
  if(NOT TARGET GMP::GMPXX)
    add_library(GMP::GMPXX UNKNOWN IMPORTED)
  endif()
  if (GMPXX_LIBRARY_RELEASE)
    set_property(TARGET GMP::GMPXX APPEND PROPERTY
      IMPORTED_CONFIGURATIONS RELEASE
    )
    set_target_properties(GMP::GMPXX PROPERTIES
      IMPORTED_LOCATION_RELEASE ${GMPXX_LIBRARY_RELEASE}
    )
  endif()
  if (GMPXX_LIBRARY_DEBUG)
    set_property(TARGET GMP::GMPXX APPEND PROPERTY
      IMPORTED_CONFIGURATIONS DEBUG
    )
    set_target_properties(GMP::GMPXX PROPERTIES
      IMPORTED_LOCATION_DEBUG ${GMPXX_LIBRARY_DEBUG}
    )
  endif()
  set_target_properties(GMP::GMPXX PROPERTIES
    IMPORTED_LOCATION ${GMPXX_LIBRARY}
    INTERFACE_INCLUDE_DIRECTORIES ${GMPXX_INCLUDE_DIR}
    INTERFACE_LINK_LIBRARIES GMP::GMP
  )
endif()
