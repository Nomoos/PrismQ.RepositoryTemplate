@echo off
REM PrismQ Module - Run All Quality Checks
REM Runs formatting, linting, type checking, and tests

echo =====================================
echo PrismQ Module - All Quality Checks
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

echo [1/4] Formatting code...
echo.
call scripts\format.bat skip-pause
if errorlevel 1 goto :error

echo.
echo [2/4] Running linter...
echo.
call scripts\lint.bat skip-pause
if errorlevel 1 goto :error

echo.
echo [3/4] Type checking...
echo.
call scripts\typecheck.bat skip-pause
if errorlevel 1 goto :error

echo.
echo [4/4] Running tests...
echo.
call scripts\test.bat skip-pause
if errorlevel 1 goto :error

echo.
echo =====================================
echo All Checks Passed! ✓
echo =====================================
echo.
pause
exit /b 0

:error
echo.
echo =====================================
echo Some Checks Failed! ✗
echo =====================================
echo.
pause
exit /b 1
