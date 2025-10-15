@echo off
REM PrismQ Module - Install Pre-commit Hooks
REM Sets up pre-commit hooks for code quality checks

echo =====================================
echo PrismQ Module - Pre-commit Setup
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

REM Install pre-commit hooks
echo Installing pre-commit hooks...
echo.
pre-commit install

echo.
echo =====================================
echo Pre-commit Hooks Installed!
echo =====================================
echo.
echo Pre-commit will now run automatically on git commit.
echo To run manually: pre-commit run --all-files
echo.

pause
