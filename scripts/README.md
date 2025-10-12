# Scripts

This directory contains utility scripts for the PrismQ module.

## Available Scripts

### Setup Scripts

- **setup.sh** - Linux/Mac setup script
- **setup.bat** - Windows setup script

### Quick Start Scripts

- **quickstart.sh** - Quick start for Linux/Mac
- **quickstart.bat** - Quick start for Windows

## Usage

### Windows (Recommended Platform)

Run the setup script to install dependencies:
```batch
scripts\setup.bat
```

Run the quick start script to test the module:
```batch
scripts\quickstart.bat
```

### Linux/Mac

```bash
./scripts/setup.sh
./scripts/quickstart.sh
```

## Target Platform

These scripts are optimized for:
- **OS**: Windows
- **GPU**: NVIDIA RTX 5090
- **CPU**: AMD Ryzen
- **RAM**: 64GB

## Creating New Scripts

When adding new scripts:
1. Make them executable (`chmod +x script.sh` on Linux/Mac)
2. Add clear comments explaining what the script does
3. Include error handling
4. Update this README
