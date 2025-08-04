# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appziyannewcc1_qml_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appziyannewcc1_qml_autogen.dir\\ParseCache.txt"
  "appziyannewcc1_qml_autogen"
  )
endif()
