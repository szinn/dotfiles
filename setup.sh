#!/usr/bin/env bash

set -Eeuo pipefail

declare -r DOTFILES_REPO_URL="https://github.com/szinn/dotfiles"

function get_os_type() {
  uname
}

function initialize_macos() {
  function install_xcode() {
    local git_cmd_path="/Library/Developer/CommandLineTools/usr/bin/git"

    if [ ! -e "${git_cmd_path}" ]; then
      # Install command line developer tool
      xcode-select --install
      # Want for user input
      echo "Press any key when the installation has completed."
      IFS= read -r -n 1 -d ''
      #          │  │    └ The first character of DELIM is used to terminate the input line, rather than newline.
      #          │  └ returns after reading NCHARS characters rather than waiting for a complete line of input.
      #          └ If this option is given, backslash does not act as an escape character. The backslash is considered to be part of the line. In particular, a backslash-newline pair may not be used as a line continuation.
    else
      echo "Command line developer tools are installed."
    fi
  }

  install_xcode
}

function initialize_linux() {
  echo "Finish to pre-initialize Linux OS"
}

function initialize_os_env() {
  local ostype
  ostype="$(get_os_type)"

  if [ "${ostype}" == "Darwin" ]; then
    initialize_macos
  elif [ "${ostype}" == "Linux" ]; then
    initialize_linux
  else
    echo "Invalid OS type: ${ostype}" >&2
    exit 1
  fi
}

function main() {
  initialize_os_env
  initialize_dotfiles
}

main "$@"
