#!/bin/bash
# PrismQ Module Sync Script for Linux/macOS
# Note: Windows is the primary target platform. This script provides limited Linux/macOS support for development only.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to extract remote URL from module.json
get_remote_url() {
    local module_dir="$1"
    local json_file="$module_dir/module.json"
    
    if [ ! -f "$json_file" ]; then
        return 1
    fi
    
    # Extract URL using grep and sed (more portable than jq)
    local url=$(grep -o '"url"[[:space:]]*:[[:space:]]*"[^"]*"' "$json_file" | sed 's/.*"url"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
    
    if [ -z "$url" ]; then
        return 1
    fi
    
    echo "$url"
    return 0
}

# Function to generate remote name from URL
generate_remote_name() {
    local url="$1"
    # Extract repository name from URL
    local repo_name=$(basename "$url" .git)
    # Convert to lowercase and replace dots and underscores with hyphens
    echo "$repo_name" | tr '[:upper:]' '[:lower:]' | tr '._' '--'
}

# Function to discover modules
discover_modules() {
    local modules=()
    
    for module_path in "$REPO_ROOT"/src/*/; do
        if [ -d "$module_path" ]; then
            local module_name=$(basename "$module_path")
            local src_dir="$module_path/src"
            local json_file="$module_path/module.json"
            
            # Check if module has src/ subdirectory
            if [ ! -d "$src_dir" ]; then
                continue
            fi
            
            # Check if module.json exists
            if [ ! -f "$json_file" ]; then
                print_warning "Module '$module_name' has no module.json file"
                continue
            fi
            
            # Try to get remote URL
            local remote_url=$(get_remote_url "$module_path")
            if [ $? -ne 0 ] || [ -z "$remote_url" ]; then
                print_warning "Module '$module_name' has invalid or missing remote URL in module.json"
                continue
            fi
            
            modules+=("$module_path")
        fi
    done
    
    printf '%s\n' "${modules[@]}"
}

# Function to list modules
list_modules() {
    print_info "Discovering modules..."
    echo
    
    local modules=$(discover_modules)
    
    if [ -z "$modules" ]; then
        print_warning "No valid modules found in src/"
        echo
        echo "A valid module must have:"
        echo "  - A src/ subdirectory"
        echo "  - A module.json file with remote.url"
        return 0
    fi
    
    echo "Found modules:"
    echo
    
    while IFS= read -r module_path; do
        local module_name=$(basename "$module_path")
        local remote_url=$(get_remote_url "$module_path")
        local remote_name=$(generate_remote_name "$remote_url")
        
        echo "  📦 $module_name"
        echo "     Path: src/$module_name"
        echo "     Remote: $remote_name"
        echo "     URL: $remote_url"
        echo
    done <<< "$modules"
}

# Function to manage git origin for a module
manage_git_origin() {
    local module_path="$1"
    local remote_url="$2"
    
    if [ ! -d "$module_path/.git" ]; then
        return 0
    fi
    
    cd "$module_path"
    
    # Check if origin remote exists
    if git remote get-url origin &>/dev/null; then
        local current_url=$(git remote get-url origin)
        if [ "$current_url" != "$remote_url" ]; then
            print_info "Updating origin remote URL"
            git remote set-url origin "$remote_url"
        fi
    else
        print_info "Adding origin remote"
        git remote add origin "$remote_url"
    fi
    
    cd "$REPO_ROOT"
}

# Function to sync a single module
sync_module() {
    local module_path="$1"
    local module_name=$(basename "$module_path")
    
    print_info "Syncing module: $module_name"
    
    # Get remote URL
    local remote_url=$(get_remote_url "$module_path")
    if [ $? -ne 0 ] || [ -z "$remote_url" ]; then
        print_error "Cannot sync '$module_name': Invalid or missing remote URL"
        return 1
    fi
    
    local remote_name=$(generate_remote_name "$remote_url")
    print_info "Remote name: $remote_name"
    print_info "Remote URL: $remote_url"
    
    cd "$REPO_ROOT"
    
    # Manage git origin for module directory
    manage_git_origin "$module_path" "$remote_url"
    
    # Add or update remote
    if git remote get-url "$remote_name" &>/dev/null; then
        local current_url=$(git remote get-url "$remote_name")
        if [ "$current_url" != "$remote_url" ]; then
            print_info "Updating remote '$remote_name'"
            git remote set-url "$remote_name" "$remote_url"
        else
            print_info "Remote '$remote_name' already exists"
        fi
    else
        print_info "Adding remote '$remote_name'"
        git remote add "$remote_name" "$remote_url"
    fi
    
    # Fetch from remote
    print_info "Fetching from remote..."
    if ! git fetch "$remote_name" main; then
        print_error "Failed to fetch from $remote_name"
        return 1
    fi
    
    # Pull using git subtree
    print_info "Pulling updates using git subtree..."
    local prefix="src/$module_name"
    
    if ! git subtree pull --prefix="$prefix" "$remote_name" main --squash; then
        print_error "Failed to pull subtree for $module_name"
        return 1
    fi
    
    print_success "Module '$module_name' synced successfully"
    return 0
}

# Function to sync all modules
sync_all_modules() {
    print_info "Syncing all modules..."
    echo
    
    local modules=$(discover_modules)
    
    if [ -z "$modules" ]; then
        print_warning "No valid modules found"
        return 0
    fi
    
    local success_count=0
    local fail_count=0
    
    while IFS= read -r module_path; do
        if sync_module "$module_path"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
        echo
    done <<< "$modules"
    
    print_info "Sync complete: $success_count succeeded, $fail_count failed"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS] [MODULE_PATH]

Sync PrismQ modules using git subtree.

OPTIONS:
  --list, -l       List all discovered modules
  --all, -a        Sync all modules
  --help, -h       Show this help message

MODULE_PATH:
  Path to a specific module to sync (e.g., src/YourModule)

EXAMPLES:
  # List all modules
  $0 --list

  # Sync all modules
  $0 --all

  # Sync a specific module
  $0 src/YourModule

NOTE:
  This script is for development purposes on Linux/macOS.
  Windows is the primary target platform.

EOF
}

# Main script logic
main() {
    cd "$REPO_ROOT"
    
    if [ $# -eq 0 ]; then
        show_usage
        exit 0
    fi
    
    case "$1" in
        --list|-l)
            list_modules
            ;;
        --all|-a)
            sync_all_modules
            ;;
        --help|-h)
            show_usage
            ;;
        *)
            # Treat as module path
            local module_path="$1"
            
            # Normalize path
            if [[ ! "$module_path" = src/* ]]; then
                module_path="src/$module_path"
            fi
            
            local full_path="$REPO_ROOT/$module_path"
            
            if [ ! -d "$full_path" ]; then
                print_error "Module directory not found: $module_path"
                exit 1
            fi
            
            sync_module "$full_path"
            ;;
    esac
}

main "$@"
