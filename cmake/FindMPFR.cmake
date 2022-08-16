# https://github.com/lforg37/marto/blob/Functions/cmake/FindMPFR.cmake

#[=======================================================================[.rst:
FindMPFR
-------

Finds the GNU MPFR library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``MPFR::MPFR``
  The MPFR library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``MPFR_FOUND``
  True if the system has the MPFR library.
``MPFR_VERSION``
  The version of the MPFR library which was found.
``MPFR_INCLUDE_DIRS``
  Include directories needed to use MPFR.
``MPFR_LIBRARIES``
  Libraries needed to link to MPFR.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``MPFR_INCLUDE_DIR``
  The directory containing ``mpfr.h``.
``MPFR_LIBRARY``
  The path to the MPFR library.

#]=======================================================================]

# Add a feature summary for this package
include(FeatureSummary)
set_package_properties(MPFR PROPERTIES
  DESCRIPTION "GNU multiple-precision floating-point computations with correct rounding library"
  URL "https://mpfr.org"
)

# Try finding the package with pkg-config
find_package(PkgConfig QUIET)
pkg_check_modules(PC_MPFR QUIET mpfr)
set(MPFR_VERSION ${PC_MPFR_VERSION})

# Try to locate the libraries and their headers, using pkg-config hints
include(SelectLibraryConfigurations)

#Find MPFR
find_path(MPFR_INCLUDE_DIR
  NAMES mpfr.h
  HINTS ${PC_MPFR_INCLUDE_DIRS}
  DOC "Path of mpfr.h, the GNU MPFR header file"
)
get_filename_component(MPFR_INSTALL_DIR ${MPFR_INCLUDE_DIR} DIRECTORY)

find_library(MPFR_LIBRARY_RELEASE
  NAMES mpfr mpfr.lib
  HINTS "${PC_MPFR_LIBRARY_DIRS}/Release" "${MPFR_INSTALL_DIR}/debug/lib"
)
find_library(MPFR_LIBRARY_DEBUG
  NAMES mpfr mpfr.lib
  HINTS "${PC_MPFR_LIBRARY_DIRS}/Debug" "${MPFR_INSTALL_DIR}/lib"
)
select_library_configurations(MPFR)

# Remove these variables from cache inspector
mark_as_advanced(MPFR_INCLUDE_DIR MPFR_LIBRARY)

# Report if package was found
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MPFR
  FOUND_VAR MPFR_FOUND
  REQUIRED_VARS
    MPFR_INCLUDE_DIR MPFR_LIBRARY
  VERSION_VAR
    MPFR_VERSION
)

# Set targets
if(MPFR_FOUND)
  if(NOT TARGET MPFR::MPFR)
    add_library(MPFR::MPFR UNKNOWN IMPORTED)
  endif()
  if (MPFR_LIBRARY_RELEASE)
    set_property(TARGET MPFR::MPFR APPEND PROPERTY
      IMPORTED_CONFIGURATIONS RELEASE
    )
    set_target_properties(MPFR::MPFR PROPERTIES
      IMPORTED_LOCATION_RELEASE "${MPFR_LIBRARY_RELEASE}"
    )
  endif()
  if (MPFR_LIBRARY_DEBUG)
	set_property(TARGET MPFR::MPFR APPEND PROPERTY
	  IMPORTED_CONFIGURATIONS DEBUG
	)
	set_target_properties(MPFR::MPFR PROPERTIES
	  IMPORTED_LOCATION_DEBUG "${MPFR_LIBRARY_DEBUG}"
	)
  endif()
  set_target_properties(MPFR::MPFR PROPERTIES
      IMPORTED_LOCATION ${MPFR_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${MPFR_INCLUDE_DIR}
  )
endif()
