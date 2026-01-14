# Home Manager Configuration

This repository contains a configuration for **Nix Home Manager** using **Flakes**.

## What is Nix Home Manager?

[Nix Home Manager](https://github.com/nix-community/home-manager) is a tool for managing user environment configurations using the Nix package manager. It allows you to declaratively define your entire home directory setup, including:

- Installed packages
- Shell configuration and dotfiles
- User-level services
- Application settings
- Development tools and environments

With Home Manager, you can version control your entire user environment and easily reproduce it across different systems.

## What are Flakes?

[Nix Flakes](https://nixos.wiki/wiki/Flakes) are a modern feature of the Nix package manager that provide:

- **Reproducibility**: Lock files ensure exact versions of dependencies
- **Composability**: Easy combination of different Nix packages and configurations
- **Simplified syntax**: Cleaner than traditional Nix expressions
- **Standardization**: A consistent structure for Nix projects

Flakes use a `flake.nix` file to define inputs, outputs, and dependencies in a structured way.

## Setup Instructions

1. Clone this repository to your system
2. Follow the configuration in `home.nix` and `user.nix` to customize for your needs
3. **Important**: Move the `bin` directory to `~/.config/bin` for proper integration with your system configuration

For detailed setup and configuration guidance, refer to: https://rexk.github.io/en/blog/

## Repository Structure

```
flake.nix          - Flakes configuration entry point
home.nix           - Home Manager configuration
user.nix           - User-specific settings
user.nix.tpl       - Template for user configuration
bin/               - Executable scripts (should be moved to ~/.config/bin)
```

## Usage

To apply this configuration:

```bash
home-manager switch -b backup --flake .
```

For more information about Home Manager, visit: https://github.com/nix-community/home-manager
