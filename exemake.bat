@echo off
rem Builds main.exe from cpp\monocularDepth.cpp.
rem Needs MinGW g++ and OpenCV with pkg-config, e.g. from MSYS2:
rem   pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-opencv mingw-w64-ucrt-x86_64-pkgconf
for /f "delims=" %%i in ('pkg-config --cflags --libs opencv4') do set "OPENCV_FLAGS=%%i"
if not defined OPENCV_FLAGS (
    echo pkg-config could not find opencv4 - see README.md
    pause
    exit /b 1
)
g++ cpp\monocularDepth.cpp -o main.exe %OPENCV_FLAGS%
pause
