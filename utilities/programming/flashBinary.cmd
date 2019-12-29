@echo off
SET DOWNLOAD_FOLDER=C:\Users\%USERNAME%\Downloads\
cd %DOWNLOAD_FOLDER%
echo ">>> Flash %1 to ice40up5k"
copy %1 ice40up5k.bin
pgrcmd.exe -infile programmer.xcf
pause
