#!/bin/bash
# PrismQ Module Quick Start Script for Linux/Unix
# Target: Linux with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM
# Python scripts are optimized for Windows but will work on Linux too

echo "====================================="
echo "PrismQ Module Quick Start"
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

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "WARNING: .env file not found!"
    echo "Copying .env.example to .env..."
    cp .env.example .env
    echo
    echo "Please edit .env with your configuration before running."
    read -p "Press Enter to continue..."
fi

echo
echo "Running PrismQ module..."
echo "Target: Linux, NVIDIA RTX 5090, AMD Ryzen, 64GB RAM"
echo

# Run the module
python -m src.main

echo
echo "====================================="
echo "Quick Start Complete!"
echo "====================================="
echo

read -p "Press Enter to continue..."
