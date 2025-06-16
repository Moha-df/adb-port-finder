@echo off
setlocal enabledelayedexpansion

REM Usage: adb_nmap_scanner.bat 192.168.0.100
if "%1"=="" (
    echo [ERROR] Usage: %0 ^<IP_ADDRESS^>
    echo [INFO] Example: %0 192.168.0.100
    pause
    exit /b 1
)

set IP=%1
echo [INFO] Scanning ADB ports on %IP%...
echo ======================================

REM Check if nmap is available
nmap --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] nmap not found! Please install nmap
    echo [INFO] Download from: https://nmap.org/download.html
    pause
    exit /b 1
)

REM Check if ADB is available
adb version >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] ADB not found! Please install Android SDK Platform Tools
    echo [INFO] Download from: https://developer.android.com/studio/releases/platform-tools
    pause
    exit /b 1
)

echo [INFO] Starting port scan...

REM 1. Check port 5555 first (default ADB port)
echo.
echo [1/4] Checking default ADB port 5555...
nmap -p 5555 %IP% | findstr "5555/tcp open" >nul
if !errorlevel! equ 0 (
    echo [SUCCESS] Port 5555 is open!
    call :test_adb_port 5555
    if !errorlevel! equ 0 exit /b 0
) else (
    echo [INFO] Port 5555 is closed or filtered
)

REM 2. Scan ports 30000-50000
echo.
echo [2/4] Scanning ports 30000-50000...
nmap -p 30000-50000 %IP% > temp_scan.txt
for /f "tokens=1 delims=/" %%i in ('type temp_scan.txt ^| findstr "open" ^| findstr "^[0-9]"') do (
    echo [FOUND] Open port: %%i
    call :test_adb_port %%i
    if !errorlevel! equ 0 (
        del temp_scan.txt >nul 2>&1
        exit /b 0
    )
)
del temp_scan.txt >nul 2>&1

REM 3. Scan ports 50000-65535
echo.
echo [3/4] Scanning ports 50000-65535...
nmap -p 50000-65535 %IP% > temp_scan.txt
for /f "tokens=1 delims=/" %%i in ('type temp_scan.txt ^| findstr "open" ^| findstr "^[0-9]"') do (
    echo [FOUND] Open port: %%i
    call :test_adb_port %%i
    if !errorlevel! equ 0 (
        del temp_scan.txt >nul 2>&1
        exit /b 0
    )
)
del temp_scan.txt >nul 2>&1

REM 4. Scan ports 1-29999
echo.
echo [4/4] Scanning ports 1-29999...
nmap -p 1-29999 %IP% > temp_scan.txt
for /f "tokens=1 delims=/" %%i in ('type temp_scan.txt ^| findstr "open" ^| findstr "^[0-9]"') do (
    echo [FOUND] Open port: %%i
    call :test_adb_port %%i
    if !errorlevel! equ 0 (
        del temp_scan.txt >nul 2>&1
        exit /b 0
    )
)
del temp_scan.txt >nul 2>&1

echo.
echo [FAILED] No working ADB connection found
echo [INFO] Suggestions:
echo    - Check if wireless debugging is enabled on tablet
echo    - Verify IP address: %IP%
echo    - Make sure tablet and PC are on same WiFi network
echo    - Try pairing first if needed (adb pair IP:PORT)
echo    - Check tablet's Wireless Debugging screen for correct port
pause
exit /b 1

REM Function to test ADB connection on a port
:test_adb_port
set test_port=%1
echo [TEST] Testing ADB connection on %IP%:%test_port%...
adb connect %IP%:%test_port% >nul 2>&1
timeout /t 2 /nobreak >nul
adb devices | findstr "%IP%:%test_port%" | findstr "device" >nul
if !errorlevel! equ 0 (
    echo [SUCCESS] ADB connection successful on port %test_port%!
    echo [RESULT] Connected device:
    adb devices | findstr "%IP%:%test_port%"
    echo.
    echo [READY] Ready to use ADB commands!
    exit /b 0
) else (
    echo [FAILED] Port %test_port% - ADB connection failed
    adb disconnect %IP%:%test_port% >nul 2>&1
    exit /b 1
)
goto :eof