@echo off
REM PrismQ Module Sync Script for Windows
REM Target: Windows with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM

setlocal enabledelayedexpansion

REM Get script directory and repository root
set "SCRIPT_DIR=%~dp0"
set "REPO_ROOT=%SCRIPT_DIR%.."
cd /d "%REPO_ROOT%"

REM Function to print colored output (simulated with echo)
goto :main

:print_info
    echo [INFO] %~1
    exit /b

:print_success
    echo [SUCCESS] %~1
    exit /b

:print_warning
    echo [WARNING] %~1
    exit /b

:print_error
    echo [ERROR] %~1
    exit /b

REM Function to check if module.json exists and extract URL
:get_remote_url
    set "module_dir=%~1"
    set "json_file=%module_dir%\module.json"
    set "remote_url="
    
    if not exist "%json_file%" (
        exit /b 1
    )
    
    REM Extract URL from JSON using findstr and for loop
    for /f "tokens=2 delims=:""" %%a in ('findstr /i "url" "%json_file%"') do (
        set "url_candidate=%%a"
        REM Remove leading/trailing spaces
        for /f "tokens=* delims= " %%b in ("!url_candidate!") do set "remote_url=%%b"
    )
    
    if "!remote_url!"=="" (
        exit /b 1
    )
    
    REM Return URL via environment variable
    endlocal & set "REMOTE_URL=%remote_url%"
    exit /b 0

REM Function to generate remote name from URL
:generate_remote_name
    set "url=%~1"
    
    REM Extract repository name from URL (last part before .git)
    for %%a in ("%url%") do set "repo_name=%%~na"
    
    REM Convert to lowercase and replace dots and underscores with hyphens
    set "remote_name=%repo_name%"
    set "remote_name=%remote_name:.=-%"
    set "remote_name=%remote_name:_=-%"
    
    REM Convert to lowercase (Windows batch doesn't have native lowercase)
    for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
        set "remote_name=!remote_name:%%L=%%L!"
    )
    
    REM Simple lowercase conversion
    call :to_lowercase "%remote_name%" remote_name_lower
    
    endlocal & set "REMOTE_NAME=%remote_name_lower%"
    exit /b 0

:to_lowercase
    set "str=%~1"
    set "str=%str:A=a%"
    set "str=%str:B=b%"
    set "str=%str:C=c%"
    set "str=%str:D=d%"
    set "str=%str:E=e%"
    set "str=%str:F=f%"
    set "str=%str:G=g%"
    set "str=%str:H=h%"
    set "str=%str:I=i%"
    set "str=%str:J=j%"
    set "str=%str:K=k%"
    set "str=%str:L=l%"
    set "str=%str:M=m%"
    set "str=%str:N=n%"
    set "str=%str:O=o%"
    set "str=%str:P=p%"
    set "str=%str:Q=q%"
    set "str=%str:R=r%"
    set "str=%str:S=s%"
    set "str=%str:T=t%"
    set "str=%str:U=u%"
    set "str=%str:V=v%"
    set "str=%str:W=w%"
    set "str=%str:X=x%"
    set "str=%str:Y=y%"
    set "str=%str:Z=z%"
    set "%~2=%str%"
    exit /b

REM Function to list all modules
:list_modules
    call :print_info "Discovering modules..."
    echo.
    
    set "found_modules=0"
    
    for /d %%M in ("%REPO_ROOT%\src\*") do (
        set "module_path=%%M"
        set "module_name=%%~nxM"
        set "src_dir=!module_path!\src"
        set "json_file=!module_path!\module.json"
        
        REM Check if module has src/ subdirectory
        if not exist "!src_dir!\" (
            goto :continue_list
        )
        
        REM Check if module.json exists
        if not exist "!json_file!" (
            call :print_warning "Module '!module_name!' has no module.json file"
            goto :continue_list
        )
        
        REM Get remote URL
        call :get_remote_url "!module_path!"
        if errorlevel 1 (
            call :print_warning "Module '!module_name!' has invalid or missing remote URL in module.json"
            goto :continue_list
        )
        
        set "remote_url=!REMOTE_URL!"
        call :generate_remote_name "!remote_url!"
        set "remote_name=!REMOTE_NAME!"
        
        if !found_modules!==0 (
            echo Found modules:
            echo.
        )
        
        set "found_modules=1"
        echo   [Module] !module_name!
        echo      Path: src\!module_name!
        echo      Remote: !remote_name!
        echo      URL: !remote_url!
        echo.
        
        :continue_list
    )
    
    if !found_modules!==0 (
        call :print_warning "No valid modules found in src\"
        echo.
        echo A valid module must have:
        echo   - A src\ subdirectory
        echo   - A module.json file with remote.url
    )
    
    exit /b 0

REM Function to manage git origin for a module
:manage_git_origin
    set "module_path=%~1"
    set "remote_url=%~2"
    
    if not exist "%module_path%\.git\" (
        exit /b 0
    )
    
    cd /d "%module_path%"
    
    REM Check if origin remote exists
    git remote get-url origin >nul 2>&1
    if errorlevel 1 (
        call :print_info "Adding origin remote"
        git remote add origin "%remote_url%"
    ) else (
        for /f "delims=" %%a in ('git remote get-url origin') do set "current_url=%%a"
        if not "!current_url!"=="%remote_url%" (
            call :print_info "Updating origin remote URL"
            git remote set-url origin "%remote_url%"
        )
    )
    
    cd /d "%REPO_ROOT%"
    exit /b 0

REM Function to sync a single module
:sync_module
    set "module_path=%~1"
    
    REM Get module name from path
    for %%a in ("%module_path%") do set "module_name=%%~nxa"
    
    call :print_info "Syncing module: %module_name%"
    
    REM Get remote URL
    call :get_remote_url "%module_path%"
    if errorlevel 1 (
        call :print_error "Cannot sync '%module_name%': Invalid or missing remote URL"
        exit /b 1
    )
    
    set "remote_url=!REMOTE_URL!"
    call :generate_remote_name "!remote_url!"
    set "remote_name=!REMOTE_NAME!"
    
    call :print_info "Remote name: !remote_name!"
    call :print_info "Remote URL: !remote_url!"
    
    cd /d "%REPO_ROOT%"
    
    REM Manage git origin for module directory
    call :manage_git_origin "%module_path%" "!remote_url!"
    
    REM Check if remote exists
    git remote get-url "!remote_name!" >nul 2>&1
    if errorlevel 1 (
        call :print_info "Adding remote '!remote_name!'"
        git remote add "!remote_name!" "!remote_url!"
    ) else (
        for /f "delims=" %%a in ('git remote get-url "!remote_name!"') do set "current_url=%%a"
        if not "!current_url!"=="!remote_url!" (
            call :print_info "Updating remote '!remote_name!'"
            git remote set-url "!remote_name!" "!remote_url!"
        ) else (
            call :print_info "Remote '!remote_name!' already exists"
        )
    )
    
    REM Fetch from remote
    call :print_info "Fetching from remote..."
    git fetch "!remote_name!" main
    if errorlevel 1 (
        call :print_error "Failed to fetch from !remote_name!"
        exit /b 1
    )
    
    REM Pull using git subtree
    call :print_info "Pulling updates using git subtree..."
    
    REM Calculate relative path for subtree prefix
    set "prefix=src\%module_name%"
    
    git subtree pull --prefix="!prefix!" "!remote_name!" main --squash
    if errorlevel 1 (
        call :print_error "Failed to pull subtree for %module_name%"
        exit /b 1
    )
    
    call :print_success "Module '%module_name%' synced successfully"
    exit /b 0

REM Function to sync all modules
:sync_all_modules
    call :print_info "Syncing all modules..."
    echo.
    
    set "success_count=0"
    set "fail_count=0"
    
    for /d %%M in ("%REPO_ROOT%\src\*") do (
        set "module_path=%%M"
        set "module_name=%%~nxM"
        set "src_dir=!module_path!\src"
        set "json_file=!module_path!\module.json"
        
        REM Check if module has src/ subdirectory
        if not exist "!src_dir!\" (
            goto :continue_sync
        )
        
        REM Check if module.json exists
        if not exist "!json_file!" (
            goto :continue_sync
        )
        
        REM Sync the module
        call :sync_module "!module_path!"
        if errorlevel 1 (
            set /a "fail_count+=1"
        ) else (
            set /a "success_count+=1"
        )
        echo.
        
        :continue_sync
    )
    
    call :print_info "Sync complete: !success_count! succeeded, !fail_count! failed"
    exit /b 0

REM Function to show usage
:show_usage
    echo Usage: %~nx0 [OPTIONS] [MODULE_PATH]
    echo.
    echo Sync PrismQ modules using git subtree.
    echo.
    echo OPTIONS:
    echo   --list, -l       List all discovered modules
    echo   --all, -a        Sync all modules
    echo   --help, -h       Show this help message
    echo.
    echo MODULE_PATH:
    echo   Path to a specific module to sync (e.g., src\YourModule)
    echo.
    echo EXAMPLES:
    echo   # List all modules
    echo   %~nx0 --list
    echo.
    echo   # Sync all modules
    echo   %~nx0 --all
    echo.
    echo   # Sync a specific module
    echo   %~nx0 src\YourModule
    echo.
    echo NOTE:
    echo   This script is optimized for Windows with NVIDIA RTX 5090.
    echo.
    exit /b 0

REM Main script logic
:main
    cd /d "%REPO_ROOT%"
    
    if "%~1"=="" (
        call :show_usage
        exit /b 0
    )
    
    if /i "%~1"=="--list" goto :cmd_list
    if /i "%~1"=="-l" goto :cmd_list
    if /i "%~1"=="--all" goto :cmd_all
    if /i "%~1"=="-a" goto :cmd_all
    if /i "%~1"=="--help" goto :cmd_help
    if /i "%~1"=="-h" goto :cmd_help
    
    REM Treat as module path
    set "module_path=%~1"
    
    REM Normalize path - add src\ prefix if not present
    echo !module_path! | findstr /i "^src\\" >nul
    if errorlevel 1 (
        set "module_path=src\!module_path!"
    )
    
    set "full_path=%REPO_ROOT%\!module_path!"
    
    if not exist "!full_path!\" (
        call :print_error "Module directory not found: !module_path!"
        exit /b 1
    )
    
    call :sync_module "!full_path!"
    exit /b !errorlevel!

:cmd_list
    call :list_modules
    exit /b 0

:cmd_all
    call :sync_all_modules
    exit /b 0

:cmd_help
    call :show_usage
    exit /b 0
