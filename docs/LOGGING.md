# Logging Best Practices for PrismQ Modules

This document describes the comprehensive logging system included in the PrismQ template and how to use it effectively.

## Overview

The PrismQ template includes a centralized logging configuration system that provides:

- **Module Identification**: Automatically logs module name, version, and location
- **Environment Detection**: Logs OS, Python version, hardware information, and environment (dev/prod)
- **Structured Logging**: Consistent format with metadata for easier parsing
- **Dual Output**: Supports both console and file logging simultaneously
- **Flexible Configuration**: Respects LOG_LEVEL and LOG_FILE environment variables
- **Hardware Information**: Optional detailed hardware info (CPU, RAM, GPU) when psutil is installed

## Quick Start

### Basic Usage

```python
from src.logging_config import get_module_logger

# Initialize logger with automatic startup information
logger = get_module_logger(
    module_name="PrismQ.MyModule",
    module_version="1.0.0",
    log_startup=True  # Logs comprehensive startup info
)

# Use the logger
logger.info("Processing started")
logger.warning("Low memory detected")
logger.error("Operation failed", exc_info=True)
```

### Output Example

When you run your module, you'll see comprehensive startup information:

```
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:103] - ================================================================================
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:104] - MODULE STARTUP
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:105] - ================================================================================
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:108] - Module Information:
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:109] -   Name: PrismQ.MyModule
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:110] -   Version: 1.0.0
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:111] -   Location: /path/to/module
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:112] -   Environment: development
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:115] - System Information:
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:116] -   Operating System: Windows 11
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:117] -   Platform: Windows-11-10.0.22000-SP0
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:118] -   Architecture: AMD64
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:119] -   Processor: AMD Ryzen 9 7950X
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:120] -   Python Version: 3.12.3
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:121] -   Python Implementation: CPython
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:124] - Runtime Information:
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:125] -   Working Directory: /path/to/project
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:126] -   Python Executable: C:\Python312\python.exe
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:127] -   Log Level: INFO
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:148] -   CPU: 16 physical cores, 32 logical cores
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:155] -   RAM: 64.00 GB total
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:171] -   GPU: NVIDIA GeForce RTX 5090, 32768 MiB
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [logging_config.py:134] - ================================================================================
```

## Configuration

### Environment Variables

Configure logging behavior through environment variables in your `.env` file:

```bash
# Log Level - Controls verbosity
# Options: DEBUG, INFO, WARNING, ERROR, CRITICAL
LOG_LEVEL=INFO

# Optional: Enable file logging
LOG_FILE=./logs/app.log

# Environment setting (affects logging output)
APP_ENV=development  # or production
```

### Log Levels

- **DEBUG**: Detailed information for debugging
- **INFO**: General informational messages (default)
- **WARNING**: Warning messages for potential issues
- **ERROR**: Error messages for failures
- **CRITICAL**: Critical messages for severe failures

### Examples

#### Debug Mode

```bash
LOG_LEVEL=DEBUG python src/main.py
```

#### File Logging

```bash
LOG_FILE=./logs/mymodule.log python src/main.py
```

#### Production Environment

```bash
APP_ENV=production LOG_LEVEL=WARNING python src/main.py
```

## Advanced Usage

### Skip Startup Logging

If you want to use the logger without the detailed startup information:

```python
from src.logging_config import get_module_logger

logger = get_module_logger(
    module_name="PrismQ.MyModule",
    module_version="1.0.0",
    log_startup=False  # Skip startup info
)
```

### Module Shutdown Logging

Log when your module is shutting down:

```python
from src.logging_config import ModuleLogger

module_logger = ModuleLogger("PrismQ.MyModule", "1.0.0")
logger = module_logger.get_logger()

try:
    # Your module logic here
    pass
finally:
    module_logger.log_module_shutdown()
```

### Basic Logging (Simple Use Cases)

For simple scripts that don't need detailed module information:

```python
from src.logging_config import setup_basic_logging

setup_basic_logging(log_level="INFO")

import logging
logger = logging.getLogger(__name__)
logger.info("Simple logging message")
```

## Hardware Information

### Optional Hardware Logging

To enable detailed hardware information (CPU cores, RAM, GPU), install psutil:

```bash
pip install psutil
```

Once installed, the logger will automatically include:
- CPU core counts (physical and logical)
- Total RAM
- GPU information (if NVIDIA GPU and nvidia-smi available)

### Without psutil

If psutil is not installed, the logger will still work but will skip detailed hardware information and only show basic system info.

## Best Practices

### 1. Use Module-Specific Loggers

Always create a logger specific to your module:

```python
logger = get_module_logger("PrismQ.MySpecificModule", "1.0.0")
```

This helps with:
- Identifying which module generated each log message
- Filtering logs by module
- Tracking module versions

### 2. Use Appropriate Log Levels

```python
# DEBUG: Detailed diagnostic information
logger.debug("Processing item %d of %d", i, total)

# INFO: General informational messages
logger.info("Processing completed successfully")

# WARNING: Something unexpected but recoverable
logger.warning("Retrying operation due to timeout")

# ERROR: Serious problem that prevented an operation
logger.error("Failed to process file: %s", filename)

# CRITICAL: Very serious error that may cause the program to abort
logger.critical("Cannot connect to database, shutting down")
```

### 3. Use String Formatting in Logging

Use logger's built-in formatting instead of f-strings:

```python
# ✅ Good - Formatting happens only if message is logged
logger.info("Processing user %s with ID %d", username, user_id)

# ❌ Avoid - Formatting happens even if message isn't logged
logger.info(f"Processing user {username} with ID {user_id}")
```

### 4. Include Exception Information

When logging errors, include the exception information:

```python
try:
    risky_operation()
except Exception as e:
    logger.exception("Operation failed: %s", e)
    # or
    logger.error("Operation failed: %s", e, exc_info=True)
```

### 5. Structure Your Logs

Include contextual information to make logs more useful:

```python
logger.info("Processing file: %s, size: %d bytes", filename, file_size)
logger.info("API request: method=%s, endpoint=%s, status=%d", 
            method, endpoint, status_code)
```

## Log Format

The default log format includes:

```
%(asctime)s - %(name)s - %(levelname)s - [%(filename)s:%(lineno)d] - %(message)s
```

Example:
```
2025-10-16 16:08:11 - PrismQ.MyModule - INFO - [main.py:42] - Processing started
```

This format provides:
- **Timestamp**: When the log was created
- **Module Name**: Which module generated the log
- **Log Level**: Severity of the message
- **File and Line**: Exact location in code
- **Message**: The actual log message

## Integration with PrismQ Ecosystem

### Module Template

The template's `src/main.py` demonstrates proper logging usage:

```python
from pathlib import Path
from src.logging_config import get_module_logger

logger = get_module_logger(
    module_name="PrismQ.RepositoryTemplate",
    module_version="0.1.0",
    module_path=str(Path(__file__).parent.parent),
    log_startup=True,
)

def main() -> None:
    logger.info("Starting module execution")
    # Your code here
    logger.info("Module execution completed successfully")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        logger.exception("Module execution failed with error: %s", e)
        raise
```

### Multi-Module Projects

Each module can have its own logger with unique identification:

```python
# In module A
logger_a = get_module_logger("PrismQ.ModuleA", "1.0.0")

# In module B
logger_b = get_module_logger("PrismQ.ModuleB", "2.0.0")
```

Logs will clearly show which module generated each message.

## Troubleshooting

### Logs Not Appearing

1. Check LOG_LEVEL setting
2. Ensure logger is initialized before use
3. Verify console output isn't being redirected

### File Logging Not Working

1. Check LOG_FILE path is valid
2. Ensure parent directory exists (created automatically)
3. Verify write permissions

### Missing Hardware Information

1. Install psutil: `pip install psutil`
2. For GPU info on Windows: Install NVIDIA drivers with nvidia-smi
3. Check that nvidia-smi is in PATH

### Too Much Output

1. Increase LOG_LEVEL to WARNING or ERROR
2. Disable startup logging: `log_startup=False`
3. Filter logs by module name

## Performance Considerations

### Log Level Impact

- **DEBUG**: Highest overhead (all messages logged)
- **INFO**: Moderate overhead (recommended for development)
- **WARNING**: Low overhead (recommended for production)
- **ERROR**: Minimal overhead

### File Logging Impact

File logging adds minimal overhead:
- Logs are written asynchronously when possible
- UTF-8 encoding is used for compatibility
- Log files are automatically created and rotated by the OS

### Best Practices for Production

```bash
# Production environment settings
APP_ENV=production
LOG_LEVEL=WARNING
LOG_FILE=/var/log/prismq/mymodule.log
```

## Testing Logging

The template includes comprehensive tests for logging in `tests/test_logging_config.py`. Use these as examples for testing your own logging:

```python
def test_my_module_logging(caplog):
    """Test that my module logs correctly."""
    import logging
    
    with caplog.at_level(logging.INFO):
        my_function()
        
        # Verify expected messages were logged
        assert "Expected message" in caplog.text
        assert "Another message" in caplog.text
```

## Related Resources

- [Python Logging Documentation](https://docs.python.org/3/library/logging.html)
- [Python Logging Cookbook](https://docs.python.org/3/howto/logging-cookbook.html)
- [PEP 282 - A Logging System](https://www.python.org/dev/peps/pep-0282/)

## Summary

The PrismQ logging system provides:

✅ **Automatic module identification** - Know which module is running
✅ **Environment detection** - See OS, Python version, hardware
✅ **Flexible configuration** - Control via environment variables
✅ **Dual output** - Console and file logging
✅ **Structured format** - Easy to parse and analyze
✅ **Hardware awareness** - Optional detailed hardware info
✅ **Production-ready** - Configurable for dev and prod
✅ **Well-tested** - Comprehensive test coverage

This makes it easy to identify where your application is running, which module is being used, and track down issues quickly through extensive logging.
