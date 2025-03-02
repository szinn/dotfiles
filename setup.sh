#!/usr/bin/env bash

set -Eeuo pipefail

declare -r DOTFILES_REPO_URL="https://github.com/szinn/dotfiles"
declare -r ostype="$(uname)"

function initialize_os_env() {
  if [[ "${ostype}" == "Darwin" ]]; then
    initialize_macos
  elif [[ "${ostype}" == "Linux" ]]; then
    initialize_linux
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

function initialize_linux() {
  echo "Initializing Linux..."
}

function get_homebrew_install_dir() {
  if [[ "${ostype}" == "Darwin" ]]; then
    echo "/opt/homebrew"
  elif [[ "${ostype}" == "Linux" ]]; then
    echo "/home/linuxbrew/.linuxbrew"
  fi
}

function install_homebrew() {
  # Install Homebrew if necessary
  export HOMEBREW_CASK_OPTS=--no-quarantine
  if [[ -e "$(get_homebrew_install_dir)/bin/brew" ]]; then
    echo "Homebrew is already installed."
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

function install_chezmoi() {
  # Install chezmoi if necessary
  if [[ -e "$(get_homebrew_install_dir)/bin/chezmoi" ]]; then
    echo "Chezmoi is already installed."
  else
    brew install chezmoi
  fi
}

function install_1password() {
  # Install 1Password if necessary
  if [[ "${ostype}" == "Darwin" ]]; then
    if [[ -e "$(get_homebrew_install_dir)/bin/op" ]]; then
      echo "1Password is already installed."
    else
      brew install --cask 1password
      brew install --cask 1password-cli
    fi
  elif [[ "${ostype}" == "Linux" ]]; then
    if [[ -e "/usr/local/bin/op" ]]; then
      echo "1Password is already installed."
    else
      wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.30.3/op_linux_amd64_v2.30.3.zip" -O op.zip && \
      unzip -d op op.zip && \
      sudo mv op/op /usr/local/bin/ && \
      rm -r op.zip op && \
      sudo groupadd -f onepassword-cli && \
      sudo chgrp onepassword-cli /usr/local/bin/op && \
      sudo chmod g+s /usr/local/bin/op
    fi
  fi
  read -p "Please open 1Password, log into all accounts and set under Settings>CLI activate Integrate with 1Password CLI. Press any key to continue." -n 1 -r
}

function get_homebrew_shellenv() {
  $(get_homebrew_install_dir)/bin/brew shellenv
}

initialize_os_env
install_homebrew
eval "$(get_homebrew_shellenv)"
install_chezmoi
install_1password

# Apply dotfiles
echo "Applying Chezmoi configuration."
chezmoi init "${DOTFILES_REPO_URL}"
cd ~/.local/share/chezmoi
git remote set-url origin git@github.com:szinn/dotfiles.git
chezmoi apply
