"""Main entry point for the ModuleExample."""

import sys
from pathlib import Path

# Add parent directory to path to import logging_config
sys.path.insert(0, str(Path(__file__).parent.parent.parent.parent))

from src.logging_config import get_module_logger

# Initialize module logger with startup information
logger = get_module_logger(
    module_name="PrismQ.RepositoryTemplate.ModuleExample",
    module_version="0.1.0",
    module_path=str(Path(__file__).parent.parent),
    log_startup=True,
)


def process_example_data(data: str) -> dict[str, str]:
    """Process example data.

    Args:
        data: Input data to process

    Returns:
        Dictionary containing processed results
    """
    logger.info("Processing data: %s", data)
    logger.debug("Data length: %d characters", len(data))

    result = {
        "input": data,
        "output": data.upper(),
        "length": str(len(data)),
    }

    logger.debug("Processing result: %s", result)
    return result


def main() -> None:
    """Main function for the ModuleExample.

    This is an example implementation demonstrating module structure.
    """
    logger.info("Starting example module execution")

    # Example processing
    example_data = "Hello, PrismQ!"
    logger.info("Processing example data")
    result = process_example_data(example_data)
    logger.info("Processing result: %s", result)

    logger.info("Example module execution completed successfully")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        logger.exception("Module execution failed with error: %s", e)
        raise
