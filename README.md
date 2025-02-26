# sqdnoises/dotfiles
Welcome to my dotfiles repository! This repository contains configurations and setup scripts for managing my development environment. It includes settings for bash, Python, Node.js, and many aliases.

## Table of Contents
1. [Included dotfiles](#included-dotfiles)
2. [Setup](#setup)
3. [Customization](#customization)
4. [Future Additions](#future-additions)

## Included dotfiles
```python
dotfiles/
├── .bash_aliases  # Custom bash aliases
├── .bash_exports  # Exported environment variables
├── .bash_main     # Main bash configuration file
├── .bash_paths    # Path-related configurations
└── .bash_prompt   # Custom bash prompt settings
```

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
```

### System Packages (apt)
Add system packages to `apt-requirements.txt` (one per line).

---

💓
