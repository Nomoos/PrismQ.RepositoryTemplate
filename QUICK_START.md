# Quick Start Guide

## Setup (First Time)

```batch
# 1. Clone the repository
git clone https://github.com/Nomoos/PrismQ.RepositoryTemplate.git YourModule
cd YourModule

# 2. Run setup (creates virtual environment and installs dependencies)
scripts\setup.bat

# 3. Configure environment
copy .env.example .env
# Edit .env with your settings
```

## Daily Development Workflow

```batch
# Format your code (auto-fix PEP 8 issues)
scripts\format.bat

# Run linting and type checking
scripts\lint.bat

# Run tests with coverage
scripts\test.bat

# Generate documentation
scripts\docs.bat
```

## What's Included

### Linting & Formatting
- **Ruff** - Modern linter (replaces Flake8, Black, isort, Pylint)
- **mypy** - Type checking (PEP 484/526/544/561)

### Testing
- **pytest** - Test framework with 81% coverage
- **pytest-cov** - Coverage reporting

### Documentation
- **Sphinx** - Auto-generated API docs
- **markdown guides** - Comprehensive documentation in docs/

### Development Scripts
- `setup.bat` - Initial setup
- `format.bat` - Auto-format code
- `lint.bat` - Check code quality
- `test.bat` - Run tests
- `docs.bat` - Generate docs
- `quickstart.bat` - Run the module

## Platform Requirements

- **OS**: Windows
- **Python**: 3.10+
- **GPU**: NVIDIA RTX 5090 (32GB VRAM)
- **RAM**: 64GB DDR5

## Documentation

See `docs/` for comprehensive guides:
- **DEVELOPMENT_UTILITIES_EVALUATION.md** - Complete tool evaluation
- **PEP_STANDARDS.md** - Python standards followed
- **SOLID_PRINCIPLES.md** - Design principles
- **CONTRIBUTING.md** - How to contribute
- **LOGGING.md** - Logging best practices

## Quick Commands

```batch
# Activate virtual environment manually
venv\Scripts\activate.bat

# Run Python module
python -m src.main

# Install in development mode
pip install -e ".[dev]"

# Install with docs dependencies
pip install -e ".[dev,docs]"

# Run specific test
pytest tests/test_config.py -v

# Check coverage report
start htmlcov\index.html
```

## Need Help?

1. Check `docs/README.md` for documentation overview
2. Review existing code for examples
3. Check `issues/KNOWN_ISSUES.md` for known problems
4. Open a new issue with the appropriate template

---

**Happy coding with PrismQ! 🚀**
