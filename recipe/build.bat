mkdir build
cd build

REM Configure step
cmake -GNinja %CMAKE_ARGS% ^
 -DBUILD_SHARED_LIBS=ON ^
 -DCMAKE_BUILD_TYPE=Release ^
 -DTIXI_ENABLE_FORTRAN=ON ^
 ..
if errorlevel 1 exit 1

REM Build step 
cmake --build . --config Release --verbose
if errorlevel 1 exit 1

REM Install step
cmake --install . --config Release
if errorlevel 1 exit 1

REM install python packages
REM SP_DIR is given with a forward slash (e.g. %PREFIX%\Lib/site-packages), which
REM breaks cmd's builtin mkdir/copy commands, so normalize to backslashes first.
set "SP_DIR=%SP_DIR:/=\%"
mkdir %SP_DIR%\tixi3
echo. 2> %SP_DIR%\tixi3\__init__.py
copy lib\tixi3wrapper.py %SP_DIR%\tixi3\
REM cleanup doc and matlab files (mirror Unix build.sh)
if exist "%PREFIX%\share\tixi3\doc" rmdir /s /q "%PREFIX%\share\tixi3\doc"
if exist "%PREFIX%\share\tixi3\matlab" rmdir /s /q "%PREFIX%\share\tixi3\matlab"
