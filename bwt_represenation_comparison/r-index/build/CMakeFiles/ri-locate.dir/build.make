# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /dartfs-hpc/admin/opt/el7/cmake/3.10.1/bin/cmake

# The command to remove a file.
RM = /dartfs-hpc/admin/opt/el7/cmake/3.10.1/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /dartfs/rc/lab/S/SongL/projects/compactds/r-index

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /dartfs/rc/lab/S/SongL/projects/compactds/r-index/build

# Include any dependencies generated for this target.
include CMakeFiles/ri-locate.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/ri-locate.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/ri-locate.dir/flags.make

CMakeFiles/ri-locate.dir/ri-locate.cpp.o: CMakeFiles/ri-locate.dir/flags.make
CMakeFiles/ri-locate.dir/ri-locate.cpp.o: ../ri-locate.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/dartfs/rc/lab/S/SongL/projects/compactds/r-index/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/ri-locate.dir/ri-locate.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/ri-locate.dir/ri-locate.cpp.o -c /dartfs/rc/lab/S/SongL/projects/compactds/r-index/ri-locate.cpp

CMakeFiles/ri-locate.dir/ri-locate.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ri-locate.dir/ri-locate.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /dartfs/rc/lab/S/SongL/projects/compactds/r-index/ri-locate.cpp > CMakeFiles/ri-locate.dir/ri-locate.cpp.i

CMakeFiles/ri-locate.dir/ri-locate.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ri-locate.dir/ri-locate.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /dartfs/rc/lab/S/SongL/projects/compactds/r-index/ri-locate.cpp -o CMakeFiles/ri-locate.dir/ri-locate.cpp.s

CMakeFiles/ri-locate.dir/ri-locate.cpp.o.requires:

.PHONY : CMakeFiles/ri-locate.dir/ri-locate.cpp.o.requires

CMakeFiles/ri-locate.dir/ri-locate.cpp.o.provides: CMakeFiles/ri-locate.dir/ri-locate.cpp.o.requires
	$(MAKE) -f CMakeFiles/ri-locate.dir/build.make CMakeFiles/ri-locate.dir/ri-locate.cpp.o.provides.build
.PHONY : CMakeFiles/ri-locate.dir/ri-locate.cpp.o.provides

CMakeFiles/ri-locate.dir/ri-locate.cpp.o.provides.build: CMakeFiles/ri-locate.dir/ri-locate.cpp.o


# Object files for target ri-locate
ri__locate_OBJECTS = \
"CMakeFiles/ri-locate.dir/ri-locate.cpp.o"

# External object files for target ri-locate
ri__locate_EXTERNAL_OBJECTS =

ri-locate: CMakeFiles/ri-locate.dir/ri-locate.cpp.o
ri-locate: CMakeFiles/ri-locate.dir/build.make
ri-locate: CMakeFiles/ri-locate.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/dartfs/rc/lab/S/SongL/projects/compactds/r-index/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ri-locate"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ri-locate.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/ri-locate.dir/build: ri-locate

.PHONY : CMakeFiles/ri-locate.dir/build

CMakeFiles/ri-locate.dir/requires: CMakeFiles/ri-locate.dir/ri-locate.cpp.o.requires

.PHONY : CMakeFiles/ri-locate.dir/requires

CMakeFiles/ri-locate.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/ri-locate.dir/cmake_clean.cmake
.PHONY : CMakeFiles/ri-locate.dir/clean

CMakeFiles/ri-locate.dir/depend:
	cd /dartfs/rc/lab/S/SongL/projects/compactds/r-index/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /dartfs/rc/lab/S/SongL/projects/compactds/r-index /dartfs/rc/lab/S/SongL/projects/compactds/r-index /dartfs/rc/lab/S/SongL/projects/compactds/r-index/build /dartfs/rc/lab/S/SongL/projects/compactds/r-index/build /dartfs/rc/lab/S/SongL/projects/compactds/r-index/build/CMakeFiles/ri-locate.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/ri-locate.dir/depend

