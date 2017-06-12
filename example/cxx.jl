using Cxx
const path_to_lib = dirname(@__FILE__())
addHeaderDir(path_to_lib, kind=C_System)

# Compiling lastools.so is left as an exercise to the reader
Libdl.dlopen(path_to_lib * "/lastools.so", Libdl.RTLD_GLOBAL)
cxxinclude("~/git/LAStools/LASlib/inc/lasreader_txt.hpp")  # random header

# Read .laz file
a = @cxxnew LASreadOpener()
@cxx a -> set_file_name(pointer("~/01608_4.laz"))
reader = @cxx a -> open()
p = @cxx reader -> read_point()
p = @cxx reader -> point
x = @cxx p -> get_X()
y = @cxx p -> get_Y()
z = @cxx p -> get_Z()

# Read .lax file
cxxinclude("~/git/LAStools/LASzip/src/lasindex.hpp")
i = @cxxnew LASindex()
@cxx i -> read(pointer("~/01608_4.lax"))
si = @cxx i -> get_spatial()
