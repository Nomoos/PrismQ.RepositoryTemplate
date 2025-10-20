"""Configuration management for the PrismQ module."""

import os
import sys
from pathlib import Path
from typing import Optional


class Config:
    """Configuration class for the PrismQ module.

    Automatically detects the nearest parent directory with 'PrismQ' in its name
    and stores configuration in a .env file at that location.
    """

    def __init__(self, env_file: Optional[str] = None, interactive: bool = True) -> None:
        """Initialize configuration from environment variables and .env file.

        Args:
            env_file: Path to .env file (default: .env in nearest PrismQ directory)
            interactive: Whether to prompt for missing values (default: True)
        """
        # Determine working directory and .env file path
        if env_file is None:
            # Find nearest parent directory with "PrismQ" in its name
            prismq_dir = self._find_prismq_directory()
            self.working_directory = str(prismq_dir)
            env_file = prismq_dir / ".env"
        else:
            # Use the directory of the provided env_file as working directory
            env_path = Path(env_file)
            self.working_directory = str(env_path.parent.absolute())
            env_file = env_path

        self.env_file = str(env_file)
        self._interactive = interactive

        # Create .env file if it doesn't exist
        if not Path(self.env_file).exists():
            self._create_env_file()

        # Load environment variables from .env file
        self._load_dotenv()

        # Store/update working directory in .env
        self._ensure_working_directory()

        # Load configuration
        self.app_name: str = os.getenv("APP_NAME", "PrismQ.ModuleName")
        self.app_env: str = os.getenv("APP_ENV", "development")
        self.debug: bool = os.getenv("DEBUG", "false").lower() == "true"
        self.log_level: str = os.getenv("LOG_LEVEL", "INFO")

        # Python Configuration
        self.python_executable: str = os.getenv("PYTHON_EXECUTABLE", "python")

        # Paths
        self.input_dir: Path = Path(os.getenv("INPUT_DIR", "./input"))
        self.output_dir: Path = Path(os.getenv("OUTPUT_DIR", "./output"))
        self.cache_dir: Path = Path(os.getenv("CACHE_DIR", "./cache"))

        # Create directories if they don't exist
        self._create_directories()

    def _find_prismq_directory(self) -> Path:
        """Find the nearest parent directory with 'PrismQ' in its name.

        Returns:
            Path to the nearest PrismQ directory, or current directory if none found
        """
        current_path = Path.cwd().absolute()

        # Check current directory and all parents
        for path in [current_path] + list(current_path.parents):
            if "PrismQ" in path.name:
                return path

        # If no PrismQ directory found, use current directory as fallback
        return current_path

    def _create_env_file(self) -> None:
        """Create a new .env file with default values."""
        env_path = Path(self.env_file)
        env_path.parent.mkdir(parents=True, exist_ok=True)
        env_path.touch()

    def _load_dotenv(self) -> None:
        """Load environment variables from .env file."""
        try:
            with open(self.env_file, 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    # Skip empty lines and comments
                    if not line or line.startswith('#'):
                        continue

                    # Parse key=value pairs
                    if '=' in line:
                        key, value = line.split('=', 1)
                        key = key.strip()
                        value = value.strip()
                        # Only set if not already in environment
                        if key not in os.environ:
                            os.environ[key] = value
        except Exception as e:
            if self._interactive:
                print(f"[WARNING] Failed to load .env file: {e}", file=sys.stderr)

    def _ensure_working_directory(self) -> None:
        """Ensure working directory is stored in .env file."""
        current_wd = os.getenv("WORKING_DIRECTORY")

        if current_wd != self.working_directory:
            # Update or add working directory to .env
            self._set_env_value("WORKING_DIRECTORY", self.working_directory)
            # Reload to pick up the change
            os.environ["WORKING_DIRECTORY"] = self.working_directory

    def _set_env_value(self, key: str, value: str) -> None:
        """Set or update a value in the .env file.

        Args:
            key: Environment variable key
            value: Environment variable value
        """
        env_path = Path(self.env_file)
        
        # Read existing content
        lines = []
        key_found = False
        
        if env_path.exists():
            with open(env_path, 'r', encoding='utf-8') as f:
                for line in f:
                    if line.strip().startswith(f"{key}="):
                        lines.append(f"{key}={value}\n")
                        key_found = True
                    else:
                        lines.append(line)
        
        # If key not found, add it
        if not key_found:
            lines.append(f"{key}={value}\n")
        
        # Write back
        with open(env_path, 'w', encoding='utf-8') as f:
            f.writelines(lines)

    def _create_directories(self) -> None:
        """Create necessary directories if they don't exist."""
        for directory in [self.input_dir, self.output_dir, self.cache_dir]:
            directory.mkdir(parents=True, exist_ok=True)

    def get_api_key(self, service: str) -> str | None:
        """Get API key for a service.

        Args:
            service: Name of the service (e.g., 'openai', 'anthropic')

        Returns:
            API key or None if not found
        """
        env_var = f"{service.upper()}_API_KEY"
        return os.getenv(env_var)


# Global config instance
config = Config()
