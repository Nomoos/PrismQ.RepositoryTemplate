@echo off
REM PrismQ Module Type Checking Script for Windows
REM Runs MyPy type checker

echo =====================================
echo PrismQ Module Type Checking
echo =====================================
echo.

REM Check if virtual environment exists
if not exist "venv" (
    echo ERROR: Virtual environment not found!
    echo Please run setup.bat first.
    pause
    exit /b 1
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Run MyPy type checker
echo Running MyPy type checker...
echo.
mypy src/

echo.
echo =====================================
echo Type Checking Complete!
echo =====================================
echo.

if "%1"=="" pause
