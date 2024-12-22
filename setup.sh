#!/usr/bin/env bash

set -Eeuo pipefail

declare -r DOTFILES_REPO_URL="https://github.com/szinn/dotfiles"

function get_os_type() {
  uname
}

function initialize_os_env() {
  local ostype
  ostype="$(get_os_type)"

  if [[ "${ostype}" == "Darwin" ]]; then
    initialize_macos
  else
    echo "Invalid OS type: ${ostype}" >&2
    exit 1
  fi
}

function initialize_macos() {
  function install_xcode() {
    local git_cmd_path="/Library/Developer/CommandLineTools/usr/bin/git"

    if [[ ! -e "${git_cmd_path}" ]]; then
      # Install command line developer tool
      xcode-select --install
      read -p "Press any key when the installation has completed." -n 1 -r
    else
      echo "Command line developer tools are installed."
    fi
  }

  function install_rosetta() {
      sudo softwareupdate --agree-to-license --install-rosetta
  }

  echo "Initializing MacOS..."
  install_xcode
  install_rosetta
}

function install_homebrew() {
  # Install Homebrew if necessary
  export HOMEBREW_CASK_OPTS=--no-quarantine
  if [[ -e "/opt/homebrew/bin/brew" ]]; then
    echo "Homebrew is already installed."
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

function install_chezmoi() {
  # Install chezmoi if necessary
  if [[ -e "/opt/homebrew/bin/chezmoi" ]]; then
    echo "Chezmoi is already installed."
  else
    brew install chezmoi
  fi
}

function install_1password() {
  # Install 1Password if necessary
  if [[ -e "/opt/homebrew/bin/op" ]]; then
    echo "1Password is already installed."
  else
    brew install --cask 1password
    brew install 1password-cli
    read -p "Please open 1Password, log into all accounts and set under Settings>CLI activate Integrate with 1Password CLI. Press any key to continue." -n 1 -r
  fi
}

initialize_os_env
install_homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
install_chezmoi
install_1password

 # Apply dotfiles
echo "Applying Chezmoi configuration."
chezmoi init "${DOTFILES_REPO_URL}"
cd ~/.local/shared/chezmoi
git remote set-url origin git@github.com:szinn/dotfiles.git
chezmoi apply
