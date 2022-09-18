#!/usr/bin/env bash

set -eoE pipefail

declare -A osInfo;
osInfo[/etc/arch-release]="yay"
osInfo[/etc/apt/sources.list]="apt"

cwd="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"

for f in ${!osInfo[@]}
do
  if [[ -f $f ]]; then
    package_manager=${osInfo[$f]}
  fi
done

if [ -z "$package_manager" ]; then
  echo "⚪ [Error] Could not determine package manager"
fi

case $package_manager in
  yay)
    package_manager_opts="-Syu --needed --batchinstall --noprovides --noconfirm"
    ;;
  apt)
    sudo="sudo"
    package_manager_opts="install -y"
    ;;
  *)
    package_manager_opts=""
    ;;
esac

install_from_package_list() {
  packages="$(awk '! /^ *(#|$)/' "$1")"
  xargs -a <(echo "$packages") -r -- echo "⚪ Installing packages"
  xargs -a <(echo "$packages") -r -- $sudo $package_manager $package_manager_opts
}

install_from_package_list "$cwd/dependencies"
