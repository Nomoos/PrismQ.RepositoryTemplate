@echo off
REM PrismQ Module Documentation Build Script for Windows
REM Target: Windows with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM

echo =====================================
echo PrismQ Module Documentation
echo =====================================
echo.

REM Check if virtual environment exists
if not exist "venv" (
    echo Virtual environment not found!
    echo Please run setup.bat first.
    pause
    exit /b 1
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

echo.
echo Building documentation with Sphinx...
echo Target: Windows, NVIDIA RTX 5090, AMD Ryzen, 64GB RAM
echo.

REM Install Sphinx if not already installed
echo Checking for Sphinx...
python -c "import sphinx" 2>nul
if errorlevel 1 (
    echo Installing Sphinx and dependencies...
    pip install sphinx sphinx-rtd-theme
)

REM Clean previous builds
echo Cleaning previous documentation builds...
if exist "docs\sphinx\build" (
    rmdir /s /q docs\sphinx\build
)

REM Build HTML documentation
echo Building HTML documentation...
cd docs\sphinx
sphinx-build -b html source build\html

if errorlevel 1 (
    cd ..\..
    echo.
    echo =====================================
    echo Documentation build failed!
    echo =====================================
    echo.
    pause
    exit /b 1
)

cd ..\..

echo.
echo =====================================
echo Documentation Build Complete!
echo =====================================
echo.
echo Documentation available at:
echo   docs\sphinx\build\html\index.html
echo.
echo To view in browser:
echo   start docs\sphinx\build\html\index.html
echo.

REM Optional: Open in browser automatically
set /p OPEN_BROWSER="Open documentation in browser? (y/n): "
if /i "%OPEN_BROWSER%"=="y" (
    start docs\sphinx\build\html\index.html
)

pause
