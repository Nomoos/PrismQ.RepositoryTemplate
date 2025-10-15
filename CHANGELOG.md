# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Development scripts (test.bat, lint.bat, format.bat, typecheck.bat, check-all.bat)
- GitHub Actions workflows (CI, code quality, documentation)
- Pre-commit hooks configuration
- Dependabot configuration for automated dependency updates
- Security policy (SECURITY.md)
- Code of Conduct (CODE_OF_CONDUCT.md)
- Editor configuration (.editorconfig)
- Changelog for version tracking
- Example code and tutorials
- Architecture documentation

### Changed
- Enhanced .gitignore with more comprehensive patterns
- Updated scripts README with new development tools

### Fixed
- N/A

## [0.1.0] - 2025-01-15

### Added
- Initial project structure
- Python project configuration (pyproject.toml)
- PEP-compliant setup (PEP 517/518/621/660)
- Type checking with MyPy (PEP 484/526/544/561)
- Code quality with Ruff (PEP 8/257)
- SOLID principles documentation
- AI-assisted coding guidelines (GitHub Copilot)
- Configuration management with environment variables
- Test framework setup (pytest)
- Comprehensive documentation structure
- Issue tracking system
- Setup and quickstart scripts for Windows
- GitHub templates (issues, PRs)
- Optimized for Windows + RTX 5090

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- N/A

---

## How to Update This Changelog

### For Developers

When making changes:

1. Add entries under `[Unreleased]` in the appropriate section:
   - **Added** for new features
   - **Changed** for changes in existing functionality
   - **Deprecated** for soon-to-be removed features
   - **Removed** for now removed features
   - **Fixed** for any bug fixes
   - **Security** for vulnerability fixes

2. Keep entries brief but descriptive
3. Link to issues/PRs when relevant

### For Release Managers

When creating a new release:

1. Move items from `[Unreleased]` to a new version section
2. Add the release date in YYYY-MM-DD format
3. Update version in `pyproject.toml`
4. Create a git tag for the release

Example:
```markdown
## [0.2.0] - 2025-02-15

### Added
- Feature X
- Feature Y
```

---

[Unreleased]: https://github.com/Nomoos/PrismQ.RepositoryTemplate/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Nomoos/PrismQ.RepositoryTemplate/releases/tag/v0.1.0
