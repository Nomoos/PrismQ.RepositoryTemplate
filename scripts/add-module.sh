#!/bin/bash
# PrismQ Add Module Script for Linux
# Target: Windows with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM
# Note: This script provides limited Linux support for development only

set -e

# Get script directory and repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Color output functions
print_info() {
    echo "[INFO] $1" >&2
}

print_success() {
    echo "[SUCCESS] $1" >&2
}

print_error() {
    echo "[ERROR] $1" >&2
}

main() {
    # Check if module name was provided
    if [ -z "$1" ]; then
        print_error "Module name is required"
        echo ""
        echo "Usage: $0 MODULE_NAME [REMOTE_URL]"
        echo ""
        echo "Example:"
        echo "  $0 PrismQ.MyNewModule"
        echo "  $0 PrismQ.MyNewModule https://github.com/Nomoos/PrismQ.MyNewModule.git"
        exit 1
    fi

    MODULE_NAME="$1"
    REMOTE_URL="${2:-https://github.com/Nomoos/$MODULE_NAME.git}"

    # Create module directory in src/
    MODULE_DIR="$REPO_ROOT/src/$MODULE_NAME"
    
    # Check if module already exists
    if [ -d "$MODULE_DIR" ]; then
        print_error "Module '$MODULE_NAME' already exists at $MODULE_DIR"
        exit 1
    fi

    print_info "Creating module '$MODULE_NAME' in src/$MODULE_NAME..."
    
    # Create directory structure
    mkdir -p "$MODULE_DIR/src"
    mkdir -p "$MODULE_DIR/tests"
    
    # Create module.json
    print_info "Creating module.json..."
    cat > "$MODULE_DIR/module.json" << EOF
{
  "remote": {
    "url": "$REMOTE_URL"
  }
}
EOF
    
    # Create .gitignore
    print_info "Creating .gitignore..."
    cat > "$MODULE_DIR/.gitignore" << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/
.nox/
coverage.xml
*.cover

# Directories created at runtime
cache/
input/
output/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
EOF
    
    # Create README.md
    print_info "Creating README.md..."
    cat > "$MODULE_DIR/README.md" << EOF
# $MODULE_NAME

A PrismQ module for [describe purpose].

## Structure

\`\`\`
$MODULE_NAME/
├── module.json          # Module configuration
├── src/                 # Source code
│   ├── __init__.py
│   └── main.py          # Main entry point
├── tests/               # Test suite
│   └── __init__.py
└── README.md            # This file
\`\`\`

## Configuration

The module uses \`module.json\` for git subtree synchronization:

\`\`\`json
{
  "remote": {
    "url": "$REMOTE_URL"
  }
}
\`\`\`

## Usage

### Running the Module

\`\`\`bash
cd src/$MODULE_NAME
python -m src.main
\`\`\`

### Running Tests

\`\`\`bash
cd src/$MODULE_NAME
pytest tests/
\`\`\`

## Target Platform

- **Operating System**: Windows
- **GPU**: NVIDIA RTX 5090 (32GB VRAM)
- **CPU**: AMD Ryzen processor
- **RAM**: 64GB DDR5

## License

Proprietary - All Rights Reserved

Copyright (c) 2025 PrismQ
EOF
    
    # Create src/__init__.py
    print_info "Creating src/__init__.py..."
    cat > "$MODULE_DIR/src/__init__.py" << 'EOF'
"""
$MODULE_NAME module.
"""

__version__ = "0.1.0"
EOF
    
    # Fix MODULE_NAME in __init__.py
    sed -i "s/\$MODULE_NAME/$MODULE_NAME/g" "$MODULE_DIR/src/__init__.py"
    
    # Create src/main.py
    print_info "Creating src/main.py..."
    cat > "$MODULE_DIR/src/main.py" << 'EOF'
"""
Main entry point for MODULE_NAME_PLACEHOLDER.
"""

import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def main() -> None:
    """Main function."""
    logger.info("Starting MODULE_NAME_PLACEHOLDER...")
    # Add your code here
    logger.info("MODULE_NAME_PLACEHOLDER completed successfully")


if __name__ == "__main__":
    main()
EOF
    
    # Replace placeholder in main.py
    sed -i "s/MODULE_NAME_PLACEHOLDER/$MODULE_NAME/g" "$MODULE_DIR/src/main.py"
    
    # Create src/py.typed (PEP 561 marker)
    print_info "Creating src/py.typed..."
    touch "$MODULE_DIR/src/py.typed"
    
    # Create tests/__init__.py
    print_info "Creating tests/__init__.py..."
    cat > "$MODULE_DIR/tests/__init__.py" << 'EOF'
"""
Tests for MODULE_NAME_PLACEHOLDER.
"""
EOF
    
    # Replace placeholder in tests/__init__.py
    sed -i "s/MODULE_NAME_PLACEHOLDER/$MODULE_NAME/g" "$MODULE_DIR/tests/__init__.py"
    
    echo ""
    print_success "Module '$MODULE_NAME' created successfully at src/$MODULE_NAME"
    echo ""
    echo "Next steps:"
    echo "  1. Review the generated files in src/$MODULE_NAME"
    echo "  2. Update README.md with module-specific information"
    echo "  3. Implement your module functionality in src/main.py"
    echo "  4. Add tests in tests/"
    echo "  5. Verify module is discoverable:"
    echo "     ./scripts/sync-modules.sh --list"
    echo ""
}

main "$@"
