@echo off
REM PrismQ Add Module Script for Windows
REM Target: Windows with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM

setlocal enabledelayedexpansion

REM Get script directory and repository root
set "SCRIPT_DIR=%~dp0"
set "REPO_ROOT=%SCRIPT_DIR%.."
cd /d "%REPO_ROOT%"

REM Function to print colored output (simulated with echo)
goto :main

:print_info
    echo [INFO] %~1 >&2
    exit /b

:print_success
    echo [SUCCESS] %~1 >&2
    exit /b

:print_error
    echo [ERROR] %~1 >&2
    exit /b

:main
    REM Check if module name was provided
    if "%~1"=="" (
        call :print_error "Module name is required"
        echo.
        echo Usage: %~nx0 MODULE_NAME [REMOTE_URL]
        echo.
        echo Example:
        echo   %~nx0 PrismQ.MyNewModule
        echo   %~nx0 PrismQ.MyNewModule https://github.com/Nomoos/PrismQ.MyNewModule.git
        exit /b 1
    )

    set "MODULE_NAME=%~1"
    set "REMOTE_URL=%~2"
    
    REM If remote URL is not provided, create a placeholder
    if "%REMOTE_URL%"=="" (
        set "REMOTE_URL=https://github.com/Nomoos/%MODULE_NAME%.git"
    )

    REM Create module directory in src/
    set "MODULE_DIR=%REPO_ROOT%\src\%MODULE_NAME%"
    
    REM Check if module already exists
    if exist "%MODULE_DIR%" (
        call :print_error "Module '%MODULE_NAME%' already exists at %MODULE_DIR%"
        exit /b 1
    )

    call :print_info "Creating module '%MODULE_NAME%' in src\%MODULE_NAME%..."
    
    REM Create directory structure
    mkdir "%MODULE_DIR%"
    mkdir "%MODULE_DIR%\src"
    mkdir "%MODULE_DIR%\tests"
    
    REM Create module.json
    call :print_info "Creating module.json..."
    (
        echo {
        echo   "remote": {
        echo     "url": "%REMOTE_URL%"
        echo   }
        echo }
    ) > "%MODULE_DIR%\module.json"
    
    REM Create .gitignore
    call :print_info "Creating .gitignore..."
    (
        echo # Python
        echo __pycache__/
        echo *.py[cod]
        echo *$py.class
        echo *.so
        echo .Python
        echo build/
        echo develop-eggs/
        echo dist/
        echo downloads/
        echo eggs/
        echo .eggs/
        echo lib/
        echo lib64/
        echo parts/
        echo sdist/
        echo var/
        echo wheels/
        echo *.egg-info/
        echo .installed.cfg
        echo *.egg
        echo.
        echo # Testing
        echo .pytest_cache/
        echo .coverage
        echo htmlcov/
        echo .tox/
        echo .nox/
        echo coverage.xml
        echo *.cover
        echo.
        echo # Directories created at runtime
        echo cache/
        echo input/
        echo output/
        echo.
        echo # IDE
        echo .vscode/
        echo .idea/
        echo *.swp
        echo *.swo
        echo *~
        echo.
        echo # OS
        echo Thumbs.db
    ) > "%MODULE_DIR%\.gitignore"
    
    REM Create README.md
    call :print_info "Creating README.md..."
    (
        echo # %MODULE_NAME%
        echo.
        echo A PrismQ module for [describe purpose].
        echo.
        echo ## Structure
        echo.
        echo ```
        echo %MODULE_NAME%/
        echo ├── module.json          # Module configuration
        echo ├── src/                 # Source code
        echo │   ├── __init__.py
        echo │   └── main.py          # Main entry point
        echo ├── tests/               # Test suite
        echo │   └── __init__.py
        echo └── README.md            # This file
        echo ```
        echo.
        echo ## Configuration
        echo.
        echo The module uses `module.json` for git subtree synchronization:
        echo.
        echo ```json
        echo {
        echo   "remote": {
        echo     "url": "%REMOTE_URL%"
        echo   }
        echo }
        echo ```
        echo.
        echo ## Usage
        echo.
        echo ### Running the Module
        echo.
        echo ```bash
        echo cd src\%MODULE_NAME%
        echo python -m src.main
        echo ```
        echo.
        echo ### Running Tests
        echo.
        echo ```bash
        echo cd src\%MODULE_NAME%
        echo pytest tests/
        echo ```
        echo.
        echo ## Target Platform
        echo.
        echo - **Operating System**: Windows
        echo - **GPU**: NVIDIA RTX 5090 (32GB VRAM)
        echo - **CPU**: AMD Ryzen processor
        echo - **RAM**: 64GB DDR5
        echo.
        echo ## License
        echo.
        echo Proprietary - All Rights Reserved
        echo.
        echo Copyright (c) 2025 PrismQ
    ) > "%MODULE_DIR%\README.md"
    
    REM Create src/__init__.py
    call :print_info "Creating src/__init__.py..."
    (
        echo """
        echo %MODULE_NAME% module.
        echo """
        echo.
        echo __version__ = "0.1.0"
    ) > "%MODULE_DIR%\src\__init__.py"
    
    REM Create src/main.py
    call :print_info "Creating src/main.py..."
    (
        echo """
        echo Main entry point for %MODULE_NAME%.
        echo """
        echo.
        echo import logging
        echo.
        echo logging.basicConfig(
        echo     level=logging.INFO,
        echo     format='%%^(asctime^)s - %%^(name^)s - %%^(levelname^)s - %%^(message^)s'
        echo ^)
        echo logger = logging.getLogger(__name__^)
        echo.
        echo.
        echo def main(^) -^> None:
        echo     """Main function."""
        echo     logger.info("Starting %MODULE_NAME%..."^)
        echo     # Add your code here
        echo     logger.info("%MODULE_NAME% completed successfully"^)
        echo.
        echo.
        echo if __name__ == "__main__":
        echo     main(^)
    ) > "%MODULE_DIR%\src\main.py"
    
    REM Create src/py.typed (PEP 561 marker)
    call :print_info "Creating src/py.typed..."
    type nul > "%MODULE_DIR%\src\py.typed"
    
    REM Create tests/__init__.py
    call :print_info "Creating tests/__init__.py..."
    (
        echo """
        echo Tests for %MODULE_NAME%.
        echo """
    ) > "%MODULE_DIR%\tests\__init__.py"
    
    echo.
    call :print_success "Module '%MODULE_NAME%' created successfully at src\%MODULE_NAME%"
    echo.
    echo Next steps:
    echo   1. Review the generated files in src\%MODULE_NAME%
    echo   2. Update README.md with module-specific information
    echo   3. Implement your module functionality in src\main.py
    echo   4. Add tests in tests/
    echo   5. Verify module is discoverable:
    echo      scripts\sync-modules.bat --list
    echo.
    
    exit /b 0
