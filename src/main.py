"""Main entry point for the PrismQ module."""

from pathlib import Path

from src.logging_config import get_module_logger

# Initialize module logger with startup information
logger = get_module_logger(
    module_name="PrismQ.RepositoryTemplate",
    module_version="0.1.0",
    module_path=str(Path(__file__).parent.parent),
    log_startup=True,
)


def main() -> None:
    """Main function for the PrismQ module.

    This is a template implementation. Replace with your module logic.
    """
    logger.info("Starting module execution")
    logger.debug("Module initialized with configuration")

    # TODO: Implement your module logic here
    logger.info("Performing module operations...")
    logger.debug("This is a debug message (only shown if LOG_LEVEL=DEBUG)")

    # Example: Log with context at different levels
    _demonstrate_logging_levels()

    logger.info("Module execution completed successfully")


def _demonstrate_logging_levels() -> None:
    """Demonstrate proper logging at different levels.

    This function shows logging best practices including:
    - Using appropriate log levels
    - Including context in log messages
    - Function-level logging for better orientation
    """
    logger.debug("Debug: Detailed diagnostic information for developers")
    logger.info("Info: General informational messages about progress")
    logger.warning("Warning: Something unexpected but handled")
    # Note: Error and critical should only be used for actual errors
    # logger.error("Error: Something failed")
    # logger.critical("Critical: System is unusable")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        logger.exception("Module execution failed with error: %s", e)
        raise
