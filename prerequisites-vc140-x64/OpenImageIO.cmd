SET current=%cd%

if not exist "prereq" ^
mkdir prereq
cd prereq

if not exist "oiio" ^
git clone https://github.com/OpenImageIO/oiio.git

cd oiio
git pull
cd ..

if not exist "build\oiio" mkdir build\oiio
cd build\oiio

REM -DUSE_PTEX=0 because ptex was recently changed and doesn't work with several projects
cmake -G "Visual Studio 14 2015 Win64"^
    -DCMAKE_PREFIX_PATH="%current%\local"^
    -DCMAKE_INSTALL_PREFIX="%current%\local" ^
    -DCMAKE_CXX_COMPILER_WORKS=1 ^
    -DOPENEXR_CUSTOM_INCLUDE_DIR:STRING="%current%\local\include" ^
    -DOPENEXR_CUSTOM_LIB_DIR="%current%\local\lib" ^
    -DBOOST_ROOT="%current%\local" ^
    -DBOOST_LIBRARYDIR="%current%\local\lib" ^
    -DBoost_USE_STATIC_LIBS:INT=0 ^
    -DBoost_LIBRARY_DIR_RELEASE="%current%\local\lib" ^
    -DBoost_LIBRARY_DIR_DEBUG="%current%\local\lib" ^
    -DOCIO_PATH="%current%\local" ^
    -DPTEX_LOCATION="%current%\local" ^
    -DUSE_PTEX=0 ^
    ..\..\oiio

cmake --build . --target install --config Release -- /maxcpucount:16

rem msbuild oiio.sln /t:Build /p:Configuration=Release /p:Platform=x64

cd %current%
