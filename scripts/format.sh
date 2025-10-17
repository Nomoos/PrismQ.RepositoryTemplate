#!/bin/bash
# PrismQ Module Format Script for Linux/Unix
# Target: Linux with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM
# Python scripts are optimized for Windows but will work on Linux too

echo "====================================="
echo "PrismQ Module Format"
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
echo "Formatting code with Ruff (PEP 8)..."
echo "Target: Linux, NVIDIA RTX 5090, AMD Ryzen, 64GB RAM"
echo

# Run ruff format
ruff format .

if [ $? -ne 0 ]; then
    echo
    echo "====================================="
    echo "Formatting failed!"
    echo "====================================="
    echo
    read -p "Press Enter to continue..."
    exit 1
fi

echo
echo "====================================="
echo "Formatting Complete!"
echo "====================================="
echo "Code has been formatted according to PEP 8."
echo

read -p "Press Enter to continue..."
