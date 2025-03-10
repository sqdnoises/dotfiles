# sqdnoises/dotfiles
Welcome to my dotfiles repository! This repository contains configurations and setup scripts for managing my development environment. It includes settings for bash, git, Python, Node.js, and many aliases.

## Table of Contents
1. [Included dotfiles](#included-dotfiles)
2. [Setup](#setup)
3. [Customization](#customization)

> [!NOTE]
> Note to self: Use uv to install pip packages ig?

## Included dotfiles
```bash
dotfiles/
├── .bash_aliases  # Custom bash aliases
├── .bash_exports  # Exported environment variables
├── .bash_main     # Main bash configuration file
├── .bash_paths    # Path-related configurations
├── .bash_prompt   # Custom bash prompt settings
└── .gitconfig     # Custom gitconfig (you might want to change this*)
```
<sub>*my [`.gitconfig`](.gitconfig) contains my username and email for `git`. you might want to change it to your username and email if you don't wanna commit as me. or you can add `.gitconfig` to [`exclusions.txt`](exclusions.txt) and it should not put my gitconfig or replace yours if you have setup git before.</sub>

## Setup
### Prerequisites
- Linux-based system (Debian/Ubuntu)
- `sudo` privileges for installing packages

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/sqdnoises/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```
2. Run the installation script:
   ```bash
   chmod +x ./install.sh
   ./install.sh
   ```
3. Restart your terminal or source the `.bashrc` file:
   ```bash
   source ~/.bashrc
   ```

4. Delete the newly created `dotfiles` directory: (optional)
    ```bash
    rm -rf ~/dotfiles
    ```

- All in one of the above, skipping the confirmation prompt: (copy, paste and forget):
   ```bash
   git clone https://github.com/sqdnoises/dotfiles.git ~/dotfiles && cd ~/dotfiles
   chmod +x ./install.sh && ./install.sh -y # -y flag for skipping confirmation prompt
   source ~/.bashrc
   rm -rf ~/dotfiles # optional
   ```


### Flags
- Use `-y` to skip confirmation prompts:
  ```bash
  ./install.sh -y
  ```

## Customization
It is recommended to fork this repository and edit the files to suit your needs since this one includes my settings and configuration.

### Adding new dotfiles
To add new dotfiles:
1. Place your configuration file in the root of this repository.
2. Add any files you want to exclude to `exclusions.txt`.

### Python Packages
Add Python package requirements to `pip-requirements.txt` (one per line) in the following format:
```plaintext
yt-dlp
spotdl
uv
```

### System Packages (apt)
Add system packages to `apt-requirements.txt` (one per line) in the same format as above.

---

💓 [back to top ↑](#top)
