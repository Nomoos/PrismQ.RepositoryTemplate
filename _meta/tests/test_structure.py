"""Tests for repository structure validation."""

from pathlib import Path


def test_src_directory_exists():
    """Test that src/ directory exists for core package."""
    src_dir = Path("src")
    assert src_dir.exists(), "src/ directory should exist"
    assert src_dir.is_dir(), "src/ should be a directory"


def test_src_contains_core_files():
    """Test that src/ contains core infrastructure files."""
    src_dir = Path("src")

    # Core files that should exist in src/
    core_files = [
        "config.py",
        "logging_config.py",
        "main.py",
        "__init__.py",
    ]

    for filename in core_files:
        file_path = src_dir / filename
        assert file_path.exists(), f"src/{filename} should exist"


def test_main_readme_documents_structure():
    """Test that main README documents the structure."""
    readme = Path("README.md")
    content = readme.read_text(encoding="utf-8")

    # Should mention src/
    assert "src/" in content, "README should document src/ directory"

    # Should explain what src/ contains
    assert "core" in content.lower() or "infrastructure" in content.lower() or "package" in content.lower(), (
        "README should explain src/ directory purpose"
    )


def test_pyproject_toml_packages_config():
    """Test that pyproject.toml correctly configures packages."""
    pyproject = Path("pyproject.toml")
    content = pyproject.read_text(encoding="utf-8")

    # Should include src in packages (flexible matching)
    assert "packages" in content and "src" in content, (
        "pyproject.toml should configure src in packages"
    )


def test_meta_directory_exists():
    """Test that _meta/ directory exists for metadata and supporting files."""
    meta_dir = Path("_meta")
    assert meta_dir.exists(), "_meta/ directory should exist"
    assert meta_dir.is_dir(), "_meta/ should be a directory"


def test_meta_structure():
    """Test that _meta/ has proper subdirectory structure."""
    meta_dir = Path("_meta")
    
    # Core _meta subdirectories
    meta_subdirs = [
        "docs",
        "tests",
        "issues",
        "_scripts",
        "research",
    ]
    
    for subdir in meta_subdirs:
        subdir_path = meta_dir / subdir
        assert subdir_path.exists(), f"_meta/{subdir}/ should exist"
        assert subdir_path.is_dir(), f"_meta/{subdir}/ should be a directory"


def test_doc_directory_exists():
    """Test that _meta/docs/ directory exists for documentation."""
    doc_dir = Path("_meta/docs")
    assert doc_dir.exists(), "_meta/docs/ directory should exist"
    assert doc_dir.is_dir(), "_meta/docs/ should be a directory"


def test_doc_sphinx_structure():
    """Test that _meta/docs/ has proper Sphinx structure."""
    doc_source = Path("_meta/docs/source")
    assert doc_source.exists(), "_meta/docs/source/ should exist"

    # Core Sphinx files
    sphinx_files = [
        "conf.py",
        "index.rst",
    ]

    for filename in sphinx_files:
        file_path = doc_source / filename
        assert file_path.exists(), f"_meta/docs/source/{filename} should exist"

    # Sphinx directories
    assert (doc_source / "_static").exists(), "_meta/docs/source/_static/ should exist"
    assert (doc_source / "_templates").exists(), "_meta/docs/source/_templates/ should exist"


def test_doc_conf_has_autodoc_path():
    """Test that _meta/docs/source/conf.py configures path for autodoc."""
    conf_py = Path("_meta/docs/source/conf.py")
    content = conf_py.read_text(encoding="utf-8")

    # Should configure sys.path for autodoc
    assert "sys.path.insert" in content, "conf.py should configure sys.path for autodoc"
    assert "../../../src" in content or "'../../../src'" in content, (
        "conf.py should add ../../../src to path for autodoc"
    )

    # Should have autodoc extension
    assert "sphinx.ext.autodoc" in content, "conf.py should include sphinx.ext.autodoc extension"
