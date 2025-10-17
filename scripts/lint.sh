#!/bin/bash
# PrismQ Module Lint Script for Linux/Unix
# Target: Linux with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM
# Python scripts are optimized for Windows but will work on Linux too

echo "====================================="
echo "PrismQ Module Lint"
echo "====================================="
echo

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Virtual environment not found!"
    echo "Please run setup.sh first."
    read -p "Press Enter to continue..."
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

echo
echo "Running code quality checks..."
echo "Target: Linux, NVIDIA RTX 5090, AMD Ryzen, 64GB RAM"
echo

# Run ruff check (PEP 8, PEP 257 linting)
echo "Running Ruff linting (PEP 8, PEP 257)..."
ruff check .

if [ $? -ne 0 ]; then
    echo
    echo "====================================="
    echo "Linting failed!"
    echo "====================================="
    echo
    echo "To auto-fix issues, run:"
    echo "  ruff check --fix ."
    echo
    read -p "Press Enter to continue..."
    exit 1
fi

echo
echo "Running MyPy type checking (PEP 484, 526, 544)..."
mypy src/

if [ $? -ne 0 ]; then
    echo
    echo "====================================="
    echo "Type checking failed!"
    echo "====================================="
    echo
    read -p "Press Enter to continue..."
    exit 1
fi

echo
echo "====================================="
echo "Linting Complete!"
echo "====================================="
echo "All code quality checks passed."
echo

read -p "Press Enter to continue..."
