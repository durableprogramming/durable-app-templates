#!/bin/bash
set -euo pipefail

echo "Installing devenv template for Python development..."

# Download configuration files
curl -o devenv.nix https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/devenv/python/devenv.nix
curl -o devenv.yaml https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/devenv/python/devenv.yaml
curl -o devenv.lock https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/devenv/python/devenv.lock

echo "Python development environment configuration downloaded."
echo "To activate, navigate to the devenv/python directory and run 'devenv shell'"
