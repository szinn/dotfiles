# Dotfiles

Managing my personal Dotfiles using [Chezmoi](https://www.chezmoi.io/).

# Initial Installation

```shell
# Install sops-age key into ~/config/sops/age/keys.txt
curl https://raw.githubusercontent.com/szinn/dotfiles/main/install.sh | sh -
export PATH="$HOME/bin:$PATH"
chezmoi init --apply https://github.com/szinn/dotfiles.git
```
