# Python Development Environment

This directory contains configuration files for setting up a reproducible Python development environment using [devenv](https://devenv.sh/).

## Prerequisites

- [devenv](https://devenv.sh/) must be installed on your system
- [Nix package manager](https://nixos.org/download.html) (devenv is built on top of Nix)

## Quick Start

1. Use the install script:
```bash
curl -s https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/devenv/python/install.sh | bash
```

Or manually copy the following files to your project directory:
- `devenv.nix`
- `devenv.yaml`
- `devenv.lock`

2. Enter the development environment:
```bash
devenv shell
```

## What's Included

The development environment provides:
- Python runtime
- Virtual environment support
- Git
- Standard Python development tools
- Isolated environment managed by Nix

## Configuration Files

- `devenv.nix`: Main configuration file that defines the development environment
- `devenv.yaml`: Additional configuration and input sources
- `devenv.lock`: Lockfile ensuring reproducible environments
- `install.sh`: Helper script for easy installation

## Customization

To customize the environment, modify `devenv.nix`. You can:
- Add additional packages
- Configure Python version
- Add environment variables
- Include development tools
- Configure virtual environment settings

## License

This work is marked with CC0 1.0. 
To view a copy of this license, visit:
https://creativecommons.org/publicdomain/zero/1.0/

## Support

For issues and feature requests, please visit:
https://github.com/durableprogramming/durable-app-templates
