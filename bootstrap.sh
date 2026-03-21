#!/usr/bin/env bash

# ==========================================
# Configuration
# ==========================================
APT_PACKAGES="btop curl fastfetch ffmpeg gh git nano nmap python3 python3-pip python3-venv tree unzip wget xclip zip"

# ==========================================
# Colors & Variables
# ==========================================
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

SKIP_CONFIRM=false

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        -y|--yes)
            SKIP_CONFIRM=true
            ;;
    esac
done

# Trap to handle Ctrl+C
trap ctrl_c SIGINT

ctrl_c() {
    echo -e "\nInstallation interrupted. Exiting..."
    exit 1
}

# Exit immediately if a command exits with a non-zero status
set -e

# Print banner and confirm
print_banner_and_confirm() {
    if [ "$SKIP_CONFIRM" = true ]; then
        echo -e "${BLUE}sqd's dotfiles${NC}"
        return 0
    fi

    echo -e "${BLUE}======================================"
    echo "            sqd's dotfiles"
    echo -e "======================================${NC}"
    echo "This script will:"
    echo "1. Copy dotfiles to your home directory"
    echo "2. Setup bash configuration"
    echo "3. Generate an apt install/update command for you to run"

    printf "${RED}This may overwrite existing dotfiles in ~/. Do you want to continue? [y/N]${NC} "
    read response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Installation aborted."
        exit 1
    fi
}

# Print step header
print_step() {
    echo -e "\n${YELLOW}==> $1${NC}"
}

# Copy dotfiles
copy_dotfiles() {
    print_step "Copying dotfiles"
    
    # Create array of files to exclude
    if [ -f "exclusions.txt" ]; then
        mapfile -t EXCLUDES < exclusions.txt
    else
        EXCLUDES=()
    fi
    
    # Keep track of copied files
    COPIED_FILES=()
    
    # Copy all dotfiles
    for file in .*; do
        # Skip if file is in exclusions
        if [[ " ${EXCLUDES[@]} " =~ " ${file} " ]]; then
            continue
        fi
        
        # Skip if file is . or .. or .git
        if [ "$file" = "." ] || [ "$file" = ".." ] || [ "$file" = ".git" ]; then
            continue
        fi
        
        # Copy file
        cp -r "$file" "$HOME/" || {
            echo -e "${RED}Failed to copy $file${NC}"
            exit 1
        }
        COPIED_FILES+=("$file")
        echo "Copied $file to $HOME/"
    done

    echo -e "${GREEN}✓${NC} Total files copied: ${GREEN}${#COPIED_FILES[@]}${NC}"
}

# Setup bash configuration
setup_bash() {
    print_step "Setting up bash configuration"
    
    # Add source line to .bashrc if not present
    SOURCE_LINE="source ~/.bash_main"
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "$SOURCE_LINE" "$HOME/.bashrc"; then
            echo -e "\n# Source dotfiles configuration\n$SOURCE_LINE" >> "$HOME/.bashrc"
            echo "Appended source line to existing ~/.bashrc"
        else
            echo "Source line already present in ~/.bashrc"
        fi
    else
        echo -e "# Source dotfiles configuration\n$SOURCE_LINE" > "$HOME/.bashrc"
        echo "Created new ~/.bashrc with source line"
    fi
}

# Print post-install instructions
print_post_install() {
    echo -e "\n${YELLOW}To finish setting up your system, copy and paste this command to install your packages and update the system:${NC}"
    echo "sudo apt update && sudo apt install -y $APT_PACKAGES && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y"    
    echo -e "${YELLOW}And don't forget to run: ${GREEN}source ~/.bashrc${NC}"
}

main() {
    print_banner_and_confirm
    copy_dotfiles
    setup_bash
    print_post_install
}

# Run main installation
main "$@"
