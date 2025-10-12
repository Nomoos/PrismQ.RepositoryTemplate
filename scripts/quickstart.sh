#!/bin/bash
# PrismQ Module Quick Start Script
# Note: Primary target is Windows, but this script supports Linux/Mac development

set -e

echo "====================================="
echo "PrismQ Module Quick Start"
echo "====================================="
echo

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Virtual environment not found!"
    echo "Please run setup.sh first."
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
    exit 1
fi

echo
echo "Running PrismQ module..."
echo "Note: Primary target is Windows with NVIDIA RTX 5090, AMD Ryzen, 64GB RAM"
echo

# Run the module
python -m src.main

echo
echo "====================================="
echo "Quick Start Complete!"
echo "====================================="
echo
