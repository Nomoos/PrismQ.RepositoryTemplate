@echo off
REM PrismQ Module Build Script for Windows
REM Target: Windows with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM

echo =====================================
echo PrismQ Module Build
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
echo Building distribution packages...
echo Target: Windows, NVIDIA RTX 5090, AMD Ryzen, 64GB RAM
echo.

REM Clean previous builds
echo Cleaning previous builds...
if exist "dist" (
    rmdir /s /q dist
)
if exist "build" (
    rmdir /s /q build
)
if exist "*.egg-info" (
    for /d %%i in (*.egg-info) do rmdir /s /q "%%i"
)

REM Build package
echo Building wheel and source distribution...
python -m pip install --upgrade build
python -m build

if errorlevel 1 (
    echo.
    echo =====================================
    echo Build failed!
    echo =====================================
    echo.
    pause
    exit /b 1
)

echo.
echo =====================================
echo Build Complete!
echo =====================================
echo Distribution packages created in dist/
echo.
echo To install locally:
echo   pip install dist\prismq_module_template-0.1.0-py3-none-any.whl
echo.
echo To upload to PyPI (when ready):
echo   python -m pip install twine
echo   python -m twine upload dist/*
echo.

pause
