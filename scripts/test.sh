#!/bin/bash
# PrismQ Module Test Script for Linux/Unix
# Target: Linux with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM
# Python scripts are optimized for Windows but will work on Linux too

echo "====================================="
echo "PrismQ Module Test"
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
echo "Running tests with pytest..."
echo "Target: Linux, NVIDIA RTX 5090, AMD Ryzen, 64GB RAM"
echo

# Run pytest with coverage
pytest

if [ $? -ne 0 ]; then
    echo
    echo "====================================="
    echo "Tests failed!"
    echo "====================================="
    echo
    read -p "Press Enter to continue..."
    exit 1
fi

echo
echo "====================================="
echo "Tests Complete!"
echo "====================================="
echo "All tests passed."
echo
echo "Coverage report generated in htmlcov/index.html"
echo

read -p "Press Enter to continue..."
