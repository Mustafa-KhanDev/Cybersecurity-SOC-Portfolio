# Contributing to Cybersecurity SOC Portfolio

Thank you for your interest in contributing to this SOC Analyst portfolio! This document provides guidelines for contributing to ensure high-quality, production-ready code.

## Code Standards

### General
- Follow language-specific best practices
- Include comprehensive error handling
- Add logging for debugging and monitoring
- Write clear, concise comments
- Use meaningful variable and function names

### Python Projects
- Follow PEP 8 style guide
- Use type hints for function parameters
- Include docstrings for all functions/classes
- Write unit tests with pytest
- Maintain >=80% code coverage

### PowerShell Projects
- Use approved verbs for cmdlets
- Include comment-based help
- Handle errors with try/catch
- Test on multiple PowerShell versions
- Follow PowerShell scripting best practices

### Configuration Files
- Use JSON for structured data
- Include comments for complex configurations
- Validate syntax in tests
- Document all parameters

## Project Structure

Each project must follow this structure:
```
ProjectName/
├── src/           # Source code
├── docs/          # Documentation
└── tests/         # Test files
```

## Documentation Requirements

- Comprehensive README.md in docs/
- Usage examples and command-line help
- Installation and setup instructions
- Troubleshooting guide
- Security considerations

## Testing

- Include unit tests for all code
- Test edge cases and error conditions
- Validate configurations
- Ensure tests run in CI/CD pipeline

## Security

- Never commit secrets or credentials
- Follow principle of least privilege
- Validate all inputs
- Include security headers where applicable

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
6. Wait for review and approval

## Commit Messages

Use clear, descriptive commit messages:
- `feat: add brute force detection algorithm`
- `fix: resolve memory leak in process scanner`
- `docs: update installation guide`
- `test: add unit tests for email parser`

## Code Review

All contributions require code review:
- At least one maintainer review
- Automated tests must pass
- Documentation must be updated
- Security review for sensitive changes

## Reporting Issues

Use GitHub Issues to report bugs or request features:
- Provide detailed description
- Include steps to reproduce
- Specify environment details
- Suggest potential solutions

## Getting Help

- Check existing documentation
- Search GitHub Issues
- Contact maintainers for questions

Thank you for contributing to making this portfolio even better!