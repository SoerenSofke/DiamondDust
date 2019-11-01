@echo off
SET DOWNLOAD_FOLDER=C:\Users\%USERNAME%\Downloads\
for /f %%i in ('dir /b/a-d/od/t:c %DOWNLOAD_FOLDER%*.bin') do set LAST=%%i
echo "%LAST%" will be flashed to FPGA

cd %DOWNLOAD_FOLDER%
rename %LAST% ice40up5k.bin
pgrcmd.exe -infile programmer.xcf
pause
