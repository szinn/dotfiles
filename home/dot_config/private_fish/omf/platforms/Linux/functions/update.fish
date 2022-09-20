function update --description 'Update APT'
  sudo apt update
  sudo apt install linux-generic linux-headers-generic linux-image-generic
  sudo apt upgrade
  sudo apt autoremove

  update-dotfiles
end
