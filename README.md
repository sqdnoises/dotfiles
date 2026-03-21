# sqdnoises/dotfiles
Welcome to my dotfiles repository! This repository contains configurations and setup scripts for managing my development environment. It includes settings for bash, git, and various custom aliases.

### The "copy, paste, and forget" command
Run this one-liner to clone, bootstrap and cleanup automatically:
```bash
git clone https://github.com/sqdnoises/dotfiles.git ~/dotfiles && cd ~/dotfiles && chmod +x ./bootstrap.sh && ./bootstrap.sh -y && rm -rf ~/dotfiles
```

## Table of Contents
1. [Included dotfiles](#included-dotfiles)
2. [Setup](#setup)
3. [Customization](#customization)

## Included dotfiles
```bash
dotfiles/
├── .bash_aliases  # Custom bash aliases
├── .bash_exports  # Exported environment variables
├── .bash_main     # Main bash configuration file
└── .gitconfig     # Custom gitconfig (you might want to change this*)
```
<sub>*my [`.gitconfig`](.gitconfig) contains my username and email for `git`. you might want to change it to your username and email if you don't wanna commit as me. or you can add `.gitconfig` to [`exclusions.txt`](exclusions.txt) and it should not put my gitconfig or replace yours if you have setup git before.</sub>

## Setup

### Prerequisites
  - A Linux-based system (Debian/Ubuntu)

### Installation
1.  Clone this repository:
    ```bash
    git clone https://github.com/sqdnoises/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2.  Run the bootstrap script to copy your dotfiles:
    ```bash
    chmod +x ./bootstrap.sh
    ./bootstrap.sh
    ```

3.  At the end of the script, it will provide `sudo apt ...` commands. Run it to install packages and/or update your system.

4.  Restart your terminal or source the `.bashrc` file:
    ```bash
    source ~/.bashrc
    ```

5.  Delete the cloned repository: (optional)
    ```bash
    rm -rf ~/dotfiles
    ```

### Flags
`-y/--yes`: Use `-y` to skip the overwrite confirmation prompt:
```bash
./bootstrap.sh -y
```

## Customization
It is recommended to fork this repository and edit the files to suit your needs, as these include my personal settings and configurations.

### Adding new dotfiles
To add new dotfiles:
1. Place your configuration file in the root of this repository (make sure it starts with a dot, e.g., `.gitconfig`).
2. Add any files you want the script to ignore to `exclusions.txt`.

### System Packages (apt)
To change which packages get installed, open `bootstrap.sh` and edit the `APT_PACKAGES` variable at the very top of the file:
```bash
APT_PACKAGES="..."
```

---


<sub>💓 [back to top ↑](#top)</sub>
