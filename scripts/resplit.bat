@echo off

:: resplit.bat v3 by oggzee
::
:: place wbfs_file.exe in same directory where this .bat file is located
:: edit the below two variables: WBFS_DIR and TEMP_DIR
:: and run


set WBFS_DIR=I:\wbfs
set TEMP_DIR=D:\temp


:::::::::::::::::::::::::::::::::::::::::::



if NOT EXIST %WBFS_DIR% (
	echo Error: missing wbfs dir: %WBFS_DIR%
	pause
	exit
)

if NOT EXIST %TEMP_DIR% (
	echo Error: missing temp dir: %TEMP_DIR%
	pause
	exit
)

if NOT EXIST wbfs_file.exe (
	echo Error: missing wbfs_file.exe
	pause
	exit
)

VERIFY OTHER 2>nul
SETLOCAL ENABLEDELAYEDEXPANSION
IF ERRORLEVEL 1 echo error enabling extensions

echo Games to be re-split in %WBFS_DIR%: ..
echo.

for %%I in ("%WBFS_DIR%\*.wbfs") do (
	set SPLIT=%%~dpnI.wbf1
	set SIZE=%%~zI
	:: echo %%I !SPLIT! %%~zI
	if EXIST !SPLIT! (
		:: echo exist !SPLIT!
		if !SIZE! LSS 4294934528 (
			:: echo RE-SPLIT: %%I
			wbfs_file.exe "%%I" ls | findstr : | findstr /V ^wbfs
		) else (
			echo SKIP: %%I already split at 4gb-32kb
		)
	)
)

echo.
echo re-split these games?
set /P ASK="y/n? : "
if NOT %ASK%==y (
	echo bye
	pause
	exit
)

echo.
echo Re-splitting: ...
echo.

for %%I in ("%WBFS_DIR%\*.wbfs") do (
	set FBASE=%%~nI
	set SPLIT=%%~dpnI.wbf1
	set SIZE=%%~zI
	if EXIST !SPLIT! (
		if !SIZE! LSS 4294934528 (
			wbfs_file.exe "%%I" extract_wbfs_all "%TEMP_DIR%"
			if EXIST "%TEMP_DIR%\!FBASE!.wbfs" (
				echo ok. moving %TEMP_DIR%\!BASE!.wbf* to %WBFS_DIR%
				echo del "%WBFS_DIR%\!FBASE!.wbf*"
				del "%WBFS_DIR%\!FBASE!.wbf*"
				echo copy "%TEMP_DIR%\!FBASE!.wbf*" "%WBFS_DIR%"
				copy "%TEMP_DIR%\!FBASE!.wbf*" "%WBFS_DIR%"
				echo del "%TEMP_DIR%\!FBASE!.wbf*" "%TEMP_DIR%\!FBASE!_*.txt"
				del "%TEMP_DIR%\!FBASE!.wbf*" "%TEMP_DIR%\!FBASE!_*.txt"
				echo.
			) else (
				echo ERROR: not found: %TEMP_DIR%\!FBASE!.wbfs
				echo exiting...
				pause
				exit
			)
		)
	)
)

echo.
echo ===== DONE =====
echo.

