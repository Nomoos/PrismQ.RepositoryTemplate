@echo off
REM PrismQ Module Formatting Script for Windows
REM Formats code using Ruff formatter

echo =====================================
echo PrismQ Module Code Formatting
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

REM Run Ruff formatter
echo Formatting code with Ruff...
echo.
ruff format .

echo.
echo Running Ruff linter with auto-fix...
echo.
ruff check --fix .

echo.
echo =====================================
echo Formatting Complete!
echo =====================================
echo.

if "%1"=="" pause
