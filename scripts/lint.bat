@echo off
REM PrismQ Module Linting Script for Windows
REM Runs Ruff linter to check code quality

echo =====================================
echo PrismQ Module Linting
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

REM Run Ruff linter
echo Running Ruff linter...
echo.
ruff check .

echo.
echo =====================================
echo Linting Complete!
echo =====================================
echo.

if "%1"=="" pause
