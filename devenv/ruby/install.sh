#!/bin/bash
set -euo pipefail

echo "Installing devenv template for Ruby development..."

# Download configuration files
curl -o devenv.nix https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/devenv/ruby/devenv.nix
curl -o devenv.yaml https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/devenv/ruby/devenv.yaml
curl -o devenv.lock https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/devenv/ruby/devenv.lock

echo "Ruby development environment configuration downloaded."
echo "To activate, navigate to the devenv/ruby directory and run 'devenv shell'"

