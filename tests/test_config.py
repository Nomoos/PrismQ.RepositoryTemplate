"""Tests for configuration module."""

import os
import tempfile
from pathlib import Path


from src.config import Config


def test_config_defaults():
    """Test that configuration has sensible defaults."""
    config = Config(interactive=False)
    assert config.app_name == os.getenv("APP_NAME", "PrismQ.ModuleName")
    assert config.app_env in ["development", "production", "testing"]
    assert isinstance(config.debug, bool)


def test_config_directories():
    """Test that configuration creates necessary directories."""
    config = Config(interactive=False)
    assert config.input_dir.exists()
    assert config.output_dir.exists()
    assert config.cache_dir.exists()


def test_config_api_key():
    """Test API key retrieval."""
    config = Config(interactive=False)
    # Should return None for non-existent keys
    assert config.get_api_key("nonexistent") is None


def test_config_python_executable():
    """Test Python executable configuration."""
    config = Config(interactive=False)
    # Should have a default value
    assert config.python_executable is not None
    assert isinstance(config.python_executable, str)
    # Default should be "python"
    assert config.python_executable == os.getenv("PYTHON_EXECUTABLE", "python")


def test_working_directory_stored():
    """Test that working directory is stored in .env file."""
    with tempfile.TemporaryDirectory() as tmpdir:
        env_path = Path(tmpdir) / ".env"

        # Create config
        config = Config(str(env_path), interactive=False)

        # Check that working directory is set
        assert config.working_directory == tmpdir

        # Check that it's stored in .env file
        assert env_path.exists()
        with open(env_path, 'r') as f:
            content = f.read()
            assert "WORKING_DIRECTORY=" in content


def test_env_file_created_if_missing():
    """Test that .env file is created if it doesn't exist."""
    with tempfile.TemporaryDirectory() as tmpdir:
        env_path = Path(tmpdir) / ".env"

        # Ensure file doesn't exist
        assert not env_path.exists()

        # Create config
        config = Config(str(env_path), interactive=False)

        # Check that file was created
        assert env_path.exists()
        assert config.env_file == str(env_path)


def test_working_directory_from_cwd():
    """Test that working directory defaults to current directory when no PrismQ dir found."""
    # Save original cwd
    original_cwd = os.getcwd()

    try:
        with tempfile.TemporaryDirectory() as tmpdir:
            # Change to temp directory (no PrismQ in path)
            os.chdir(tmpdir)

            # Create config without specifying env_file
            config = Config(interactive=False)

            # Check that working directory is the temp directory (fallback)
            assert config.working_directory == tmpdir
            assert config.env_file == str(Path(tmpdir) / ".env")
    finally:
        # Restore original cwd
        os.chdir(original_cwd)


def test_working_directory_finds_prismq_parent():
    """Test that working directory finds nearest parent with PrismQ in name."""
    # Save original cwd
    original_cwd = os.getcwd()

    try:
        with tempfile.TemporaryDirectory() as base_temp:
            # Create a temporary directory structure with PrismQ in the name
            prismq_dir = Path(base_temp) / "MyPrismQProject"
            subdir = prismq_dir / "subdirectory" / "nested"
            subdir.mkdir(parents=True, exist_ok=True)

            # Change to nested subdirectory
            os.chdir(subdir)

            # Create config without specifying env_file
            config = Config(interactive=False)

            # Check that working directory is the PrismQ parent directory
            assert config.working_directory == str(prismq_dir)
            assert config.env_file == str(prismq_dir / ".env")
            assert (prismq_dir / ".env").exists()
    finally:
        # Restore original cwd
        os.chdir(original_cwd)


def test_working_directory_from_env_file_path():
    """Test that working directory is derived from env_file path."""
    with tempfile.TemporaryDirectory() as tmpdir:
        env_path = Path(tmpdir) / "subdir" / ".env"
        env_path.parent.mkdir(parents=True, exist_ok=True)

        # Create config
        config = Config(str(env_path), interactive=False)

        # Check that working directory is the parent of .env file
        assert config.working_directory == str(env_path.parent.absolute())


def test_config_non_interactive_mode():
    """Test that non-interactive mode doesn't prompt."""
    with tempfile.TemporaryDirectory() as tmpdir:
        env_path = Path(tmpdir) / ".env"

        # Create config in non-interactive mode
        config = Config(str(env_path), interactive=False)

        # Should use defaults without prompting
        assert config.app_name == "PrismQ.ModuleName"
        assert config.python_executable == "python"


def test_existing_env_values_preserved():
    """Test that existing .env values are preserved."""
    with tempfile.TemporaryDirectory() as tmpdir:
        env_path = Path(tmpdir) / ".env"

        # Create .env with some values
        with open(env_path, 'w') as f:
            f.write("APP_NAME=CustomApp\n")
            f.write("DEBUG=false\n")

        # Create config
        config = Config(str(env_path), interactive=False)

        # Check that values are preserved
        assert config.app_name == "CustomApp"
        assert not config.debug

        # Check that working directory was added
        with open(env_path, 'r') as f:
            content = f.read()
            assert "WORKING_DIRECTORY=" in content
