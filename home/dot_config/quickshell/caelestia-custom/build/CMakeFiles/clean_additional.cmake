# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Release")
  file(REMOVE_RECURSE
  "plugin/src/Caelestia/CMakeFiles/caelestia_autogen.dir/AutogenUsed.txt"
  "plugin/src/Caelestia/CMakeFiles/caelestia_autogen.dir/ParseCache.txt"
  "plugin/src/Caelestia/CMakeFiles/caelestiaplugin_autogen.dir/AutogenUsed.txt"
  "plugin/src/Caelestia/CMakeFiles/caelestiaplugin_autogen.dir/ParseCache.txt"
  "plugin/src/Caelestia/caelestia_autogen"
  "plugin/src/Caelestia/caelestiaplugin_autogen"
  )
endif()
