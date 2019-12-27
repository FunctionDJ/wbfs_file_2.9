@echo off

:: move_dirs.bat v3 by oggzee
::
:: Usage:
:: 1. place wbfs_file.exe in same directory where this .bat file is located
:: 2. drag the wbfs directory to this .bat file
::
:: or:
::
:: 2. edit the below variable: WBFS_DIR
:: 3. and run


set WBFS_DIR="I:\wbfs"


:::::::::::::::::::::::::::::::::::::::::::

set WBFS_FILE=wbfs_file.exe

if NOT '%1'=='' (
	echo Using specified wbfs dir: %1
	set WBFS_DIR=%1
	:: for %%X in (%0) do cd /D %%~dpX
	for %%X in (%0) do set WBFS_FILE=%%~dpX\wbfs_file.exe
)

if NOT EXIST %WBFS_DIR% (
	echo Error: missing wbfs dir: %WBFS_DIR%
	pause
	exit /B
)

if NOT EXIST %WBFS_FILE% (
	echo Error: missing %WBFS_FILE%
	pause
	exit /B
)

VERIFY OTHER 2>nul
SETLOCAL ENABLEDELAYEDEXPANSION
IF ERRORLEVEL 1 echo error enabling extensions

echo Games to be moved in %WBFS_DIR%:
echo.

for %%I in (%WBFS_DIR%\*.wbfs) do (
	%WBFS_FILE% "%%I" id_title > nul:
	if ERRORLEVEL 1 (
		echo ERROR %WBFS_FILE% "%%I" id_title
		pause
		exit /B
		)
	for /F "delims=" %%J in ('%WBFS_FILE% "%%I" id_title') do set IDT=%%J
	echo !IDT!
)

echo.
echo move these games?
set /P ASK="y/n? : "
if NOT "%ASK%"=="y" (
	echo bye
	pause
	exit /B
)

echo.
echo Moving: ...
echo.

for %%I in (%WBFS_DIR%\*.wbfs) do (
	set FN=%%~nI
	for /F "delims=" %%J in ('%WBFS_FILE% "%%I" id_title') do set IDT=%%J
	echo Moving to: "!IDT!"
	echo mkdir %WBFS_DIR%\"!IDT!"
	mkdir %WBFS_DIR%\"!IDT!"
	echo move %WBFS_DIR%\"!FN!"*.* %WBFS_DIR%\"!IDT!"
	move %WBFS_DIR%\"!FN!"*.* %WBFS_DIR%\"!IDT!"
	echo.
)

echo.
echo ===== DONE =====
echo.
pause

