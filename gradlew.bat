@echo off
REM ##########################################################################
REM InstaFarm - Gradle Wrapper Script (Windows)
REM Gradle yoksa otomatik indirir ve derler.
REM ##########################################################################
setlocal enabledelayedexpansion

set "GRADLE_VERSION=8.4"
set "CACHE=%USERPROFILE%\.gradle\wrapper\dists\gradle-%GRADLE_VERSION%-bin"
set "GRADLE_BIN=%CACHE%\gradle-%GRADLE_VERSION%\bin\gradle.bat"

REM System gradle var mi?
where gradle >nul 2>nul
if %ERRORLEVEL% == 0 (
    gradle %*
    exit /b %ERRORLEVEL%
)

REM Cache'de var mi?
if exist "%GRADLE_BIN%" (
    call "%GRADLE_BIN%" %*
    exit /b %ERRORLEVEL%
)

REM Indir
echo =^> Gradle %GRADLE_VERSION% indiriliyor...
if not exist "%CACHE%" mkdir "%CACHE%"
set "ZIP=%TEMP%\gradle-%GRADLE_VERSION%.zip"

powershell -Command "& { $ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip' -OutFile '%ZIP%' }"

if not exist "%ZIP%" (
    echo HATA: Gradle indirilemedi! Lutfen https://gradle.org/install/ adresinden kurun.
    exit /b 1
)

powershell -Command "Expand-Archive -Path '%ZIP%' -DestinationPath '%CACHE%\' -Force"
del "%ZIP%"
echo =^> Gradle hazir!

call "%GRADLE_BIN%" %*
