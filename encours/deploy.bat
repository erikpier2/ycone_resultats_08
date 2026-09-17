@echo off
setlocal
cd /d "%~dp0"

set "PYTHON_EXE="
if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" set "PYTHON_EXE=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
if not defined PYTHON_EXE if exist "C:\Program Files\Python312\python.exe" set "PYTHON_EXE=C:\Program Files\Python312\python.exe"
if not defined PYTHON_EXE if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe" set "PYTHON_EXE=%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe"
if not defined PYTHON_EXE where python >nul 2>&1 && set "PYTHON_EXE=python"

if not defined PYTHON_EXE (
    echo Python n'est pas installé ou introuvable dans le PATH.
    exit /b 1
)

"%PYTHON_EXE%" update_table.py || exit /b 1

set "GIT_EXE="
if exist "C:\Program Files\Git\cmd\git.exe" set "GIT_EXE=C:\Program Files\Git\cmd\git.exe"
if not defined GIT_EXE if exist "C:\Program Files\Git\bin\git.exe" set "GIT_EXE=C:\Program Files\Git\bin\git.exe"
if not defined GIT_EXE where git >nul 2>&1 && set "GIT_EXE=git"

if not defined GIT_EXE (
    echo Git n'est pas installé ou introuvable dans le PATH.
    exit /b 1
)

if not exist ".git" (
    "%GIT_EXE%" init
    "%GIT_EXE%" branch -M main
)

"%GIT_EXE%" config user.name "Erik" >nul 2>&1
"%GIT_EXE%" config user.email "erik@example.com" >nul 2>&1

"%GIT_EXE%" add index.html donnees.csv

"%GIT_EXE%" diff --cached --quiet
if errorlevel 1 (
    "%GIT_EXE%" commit -m "Mise à jour automatique des données"
    "%GIT_EXE%" remote get-url origin >nul 2>&1
    if not errorlevel 1 (
        "%GIT_EXE%" push origin main
    ) else (
        echo Aucun distant Git configuré. Le commit local a bien été créé.
    )
) else (
    echo Aucune modification à valider.
)

endlocal
