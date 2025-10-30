# _meta Directory

This directory contains metadata, supporting files, and project management resources that are not part of the core package but are essential for development and maintenance.

## Structure

```
_meta/
├── docs/           # Documentation (Sphinx, guides, configuration docs)
├── tests/          # Test suite for the project
├── issues/         # Issue tracking (new/wip/done)
├── _scripts/       # Utility scripts (setup, build, test, lint)
└── research/       # Research materials, experiments, and explorations
```

## Directory Purposes

### docs/
Contains all project documentation:
- **Sphinx documentation**: API documentation, user guides
- **Configuration guides**: How to configure and use the module
- **Technical documentation**: Architecture, design decisions

### tests/
Contains the complete test suite:
- Unit tests for core functionality
- Integration tests
- Test utilities and fixtures

### issues/
Manual issue tracking system:
- **new/**: Newly identified issues and feature requests
- **wip/**: Issues currently being worked on
- **done/**: Completed issues (for reference)

### _scripts/
Development and automation scripts:
- Setup scripts (environment, dependencies)
- Build scripts
- Test runners
- Linting and formatting tools
- Documentation generators

### research/
Research and experimental work:
- Proof-of-concept implementations
- Performance benchmarks
- Research notes and findings
- Alternative approaches and experiments

## Why _meta?

The `_meta` directory follows the PrismQ repository convention of keeping the root directory clean and focused on the core package (`src/`) while organizing all supporting materials in a centralized location.

The underscore prefix (`_meta`) indicates that this is a special directory containing metadata and tooling rather than application code.

## Related Files at Root Level

The following files remain at the root level as they are essential for immediate project setup and configuration:

- `.env.example` - Environment variable template
- `.gitignore` - Git ignore rules
- `LICENSE` - License information
- `README.md` - Main project documentation
- `module.json` - Module metadata
- `pyproject.toml` - Python project configuration
- `requirements.txt` - Python dependencies
