# Dotfiles

This is my dotfiles repo. There are many like it, but this one is mine 😅

## Tools

I manage my system/dotfiles through Ansible and Chezmoi:

- Ansible is used to install/manage packages and system settings
- Chezmoi is used to manage configuration files

## Installation Flow

```text
   ┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
┌──┤ curl -fsSL https://raw.githubusercontent.com/szinn/dotfiles/main/scripts/setup.sh | sh -s -- --all │
│  └────────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│     ┌───────────────────────────────────┐
├───► │ git clone szinn/dotfiles.git /tmp │
│     └───────────────────────────────────┘
│
│     ┌──────────────────────────┐     ┌──────────────────┐
├───► │ ./install_dependencies.sh├────►│ yay <essentials> │
│     └──────────────────────────┘     └──────────────────┘
│
│     ┌──────────────────┐
├───► │./install_brew.sh │
│     └──────────────────┘
│
│     ┌────────────┐
└───► │./ansible.sh│
      └─────┬──────┘
            │
   ┌────────┘
   │
   │  ┌─────────────────────────────────────────────┐
   ├─►│ ansible-galaxy install -r requirements.yaml │
   │  └─────────────────────────────────────────────┘
   │
   │  ┌──────────────────────────┐
   │  │ prompt for password if   │
   ├─►│ sudo is not passwordless │
   │  └──────────────────────────┘
   │
   │  ┌───────────────────────────────┐
   └─►│ansible-playbook ... main.yaml │
      └───────────────┬───────────────┘
                      │
     ┌────────────────┘
     │
     │  ┌──────────┐
     ├─►│ packages │
     │  └─────┬────┘
     │        │  ┌─────────────────────────┐
     │        ├─►│ yay install <packages>  │
     │        │  └─────────────────────────┘
     │        │
     │        │  ┌─────────────────────────┐
     │        ├─►│ brew install <packages> │
     │        │  │ brew install <casks>    │
     │        │  └─────────────────────────┘
     │        │
     │        │  ┌─────────────────────────────────────┐
     │        └─►│ download / extract <other_binaries> │
     │           └─────────────────────────────────────┘
     │
     │  ┌───────┐
     ├─►│ fonts │
     │  └───────┘
     │
     │  ┌──────┐       ┌──────────────────────┐
     ├─►│ fish ├─────┐ │ change default shell │
     │  └──────┘     └►│ install fisher       │
     │                 │ install fish plugins │
     │                 └──────────────────────┘
     │
     │                 ┌────────────────┐
     │  ┌──────────┐   │ chezmoi init   │
     ├─►│ dotfiles ├──►│ chezmoi update │
     │  └──────────┘   └────────────────┘
     │
     │  ┌────────┐
     └─►│ system │
        └────┬───┘
             │         ┌─────────────────────────┐
             ├────────►│ allow sudo with TouchID │
             │         └─────────────────────────┘
             │
             │         ┌────────────────────┐
             └────────►│ manage XDG folders │
                       └────────────────────┘
```

## Credits

Thanks to <https://github.com/bjw-s/dotfiles> for providing the inspiration to this approach!
