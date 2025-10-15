# Contributing to Full Kit

Thank you for your interest in contributing to Full Kit! This document outlines the process for contributing to this project.

## Overview

Full Kit is a toolkit that combines three development methodologies:
- **Goal-Driven Development (GDD)**: Focus on business objectives and outcomes
- **Blueprint-Driven Development (BDD)**: Emphasize architectural planning and system design
- **Spec-Driven Development (SDD)**: Detailed specifications that generate working implementations

## Development Setup

1. Fork and clone the repository:
   ```bash
   git clone https://github.com/your-username/full-kit.git
   cd full-kit
   ```

2. Install in development mode:
   ```bash
   uv pip install -e .
   # or with pip
   pip install -e .
   ```

3. Make your changes and test them.

## Adding Support for New AI Agents

To add support for a new AI agent:

1. Update the `AGENT_CONFIG` dictionary in `src/fullkit_cli/__init__.py` with the new agent details
2. Update the `--ai` option help text in the `init()` function
3. Update the README documentation
4. Update the release package script to include the new agent
5. Update the agent context scripts if needed
6. Test the integration

## Code Style

- Follow PEP 8 style guidelines
- Use type hints for all public functions
- Write docstrings for all public functions, classes, and modules
- Keep functions focused and small when possible

## Testing

Before submitting a pull request:

1. Test that the CLI commands work properly
2. Test with multiple AI agents if your changes affect agent integration
3. Verify all three methodologies (GDD, BDD, SDD) work as expected
4. Check that template generation works correctly

## Pull Requests

1. Describe your changes clearly in the pull request description
2. Reference any related issues
3. Ensure all tests pass
4. Update documentation if adding new features

## Issues

When reporting issues:

1. Describe the problem clearly
2. Include steps to reproduce
3. Mention your operating system and Python version
4. Include relevant error messages or logs

## Questions?

If you have any questions about contributing, feel free to open an issue with your question.