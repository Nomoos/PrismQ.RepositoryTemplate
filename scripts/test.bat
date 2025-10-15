@echo off
REM PrismQ Module Test Script for Windows
REM Runs the test suite with coverage reporting

echo =====================================
echo PrismQ Module Tests
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

REM Run tests with coverage
echo Running tests with coverage...
echo.
pytest

echo.
echo =====================================
echo Tests Complete!
echo =====================================
echo.
echo Coverage report generated in htmlcov/index.html
echo.

if "%1"=="" pause
