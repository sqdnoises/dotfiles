#!/usr/bin/env bash

# Ensure the script has sudo permissions upfront
if ! sudo -v; then
    echo "This script requires sudo permissions. Please run it with a user that has sudo access."
    exit 1
fi

# Keep sudo active during the script's execution
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Trap to handle Ctrl+C
trap ctrl_c SIGINT

ctrl_c() {
    echo -e "\n${RED}Installation interrupted. Exiting...${NC}"
    exit 1
}

# Exit immediately if a command exits with a non-zero status
set -e

# Print banner
print_banner() {
    echo -e "${BLUE}"
    echo "======================================"
    echo "            sqd's dotfiles"
    echo "======================================"
    echo "Go grab a popcorn, this will take a while."
    echo -e "${NC}"
    echo "This script will:"
    echo "1. Install system requirements"
    echo "2. Install Python packages"
    echo "3. Setup Node.js environment"
    echo "4. Configure dotfiles"
    echo ""
    echo -e "${YELLOW}Note: This script will require sudo permissions.${NC}"
}

# Check if Ubuntu is running
check_ubuntu() {
    if [ -f "/etc/os-release" ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]]; then
            echo -e "${GREEN}Ubuntu detected (Ubuntu $VERSION_ID)${NC}"
        else
            echo -e "${RED}Could not detect Ubuntu. This may cause issues.${NC}"
        fi
    else
        echo -e "${RED}Could not detect Ubuntu. This may cause issues.${NC}"
    fi
}

# Check if running with -y flag
AUTO_CONTINUE=false
if [[ "$1" == "-y" ]]; then
    AUTO_CONTINUE=true
fi

# Ask for confirmation
confirm() {
    if [ "$AUTO_CONTINUE" = true ]; then
        return 0
    fi

    printf "${RED}This may overwrite existing dotfiles. Do you want to continue? [y/N]${NC} "
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

# Add FastFetch PPA
setup_fastfetch() {
    print_step "Adding FastFetch PPA"
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
}

# Install system requirements
install_system_requirements() {
    print_step "Installing system requirements"
    
    # Update and upgrade
    sudo apt update
    sudo apt upgrade -y
    
    # Track failed packages
    FAILED_PACKAGES=()
    
    # Read and install packages from apt-requirements.txt
    while IFS= read -r package || [[ -n "$package" ]]; do
        if [[ ! "$package" =~ ^#.*$ ]] && [[ ! -z "$package" ]]; then
            echo -e "${BLUE}Installing $package...${NC}"
            if ! sudo apt install -y "$package"; then
                echo -e "${RED}Failed to install $package${NC}"
                FAILED_PACKAGES+=("$package")
            fi
        fi
    done < apt-requirements.txt
    
    # Report failed packages
    if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}The following packages failed to install:${NC}"
        for pkg in "${FAILED_PACKAGES[@]}"; do
            echo -e "${RED}- $pkg${NC}"
        done
    fi
}

# Install Python packages
install_python_packages() {
    print_step "Installing Python packages"
    
    # Track failed packages
    FAILED_PYTHON_PACKAGES=()
    
    while IFS= read -r package || [[ -n "$package" ]]; do
        if [[ ! "$package" =~ ^#.*$ ]] && [[ ! -z "$package" ]]; then
            echo -e "${BLUE}Installing $package...${NC}"
            if ! pip3 install -U "$package"; then
                echo -e "${YELLOW}Retrying $package with --break-system-packages...${NC}"
                if ! pip3 install --break-system-packages -U "$package"; then
                    echo -e "${RED}Failed to install Python package: $package${NC}"
                    FAILED_PYTHON_PACKAGES+=("$package")
                fi
            fi
        fi
    done < pip-requirements.txt
    
    # Report failed packages
    if [ ${#FAILED_PYTHON_PACKAGES[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}The following Python packages failed to install:${NC}"
        for pkg in "${FAILED_PYTHON_PACKAGES[@]}"; do
            echo -e "${RED}- $pkg${NC}"
        done
    fi
}

# Setup Node.js
setup_node() {
    print_step "Setting up Node.js"
    
    # Install curl if not present
    sudo apt-get install -y curl
    
    # Download and run NodeSource setup script
    curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
    sudo -E bash nodesource_setup.sh
    sudo apt install -y nodejs || {
        echo -e "${RED}Failed to install Node.js${NC}"
        exit 1
    }
    
    # Verify installation
    echo "Node.js version: $(node -v)"
    
    # Cleanup
    rm nodesource_setup.sh
}

# Setup pnpm
setup_pnpm() {
    print_step "Setting up pnpm"
    
    # Install pnpm via the official script
    curl -fsSL https://get.pnpm.io/install.sh | env PNPM_VERSION=10.0.0 sh - || {
        echo -e "${RED}Failed to install pnpm${NC}"
        exit 1
    }
    
    # Add pnpm to the PATH for immediate use
    export PATH="$HOME/.local/share/pnpm:$PATH"
    
    # Verify installation
    echo "pnpm version: $(pnpm -v)"
}

# Copy dotfiles
copy_dotfiles() {
    print_step "Copying dotfiles"
    
    # Create array of files to exclude
    mapfile -t EXCLUDES < exclusions.txt
    
    # Copy all dotfiles
    for file in .*; do
        # Skip if file is in exclusions
        if [[ " ${EXCLUDES[@]} " =~ " ${file} " ]]; then
            continue
        fi
        
        # Skip if file is . or ..
        if [ "$file" = "." ] || [ "$file" = ".." ]; then
            continue
        fi
        
        # Copy file
        cp -r "$file" "$HOME/" || {
            echo -e "${RED}Failed to copy $file${NC}"
            exit 1
        }
        echo "Copied $file to $HOME/"
    done
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

update_system() {
    print_step "Updating system"

    echo "Updating packages..."
    sudo apt update

    echo "Upgrading packages..."
    sudo apt upgrade -y
    
    echo "Autoremoving packages..."
    sudo apt autoremove -y

    echo "Cleaning packages..."
    sudo apt clean -y
    
    echo "Autocleaning packages..."
    sudo apt autoclean -y
}

main() {
    print_banner
    check_ubuntu
    confirm
    
    setup_fastfetch
    install_system_requirements
    install_python_packages
    setup_node
    setup_pnpm
    update_system
    copy_dotfiles
    setup_bash
    
    echo -e "\n${GREEN}Installation completed successfully!${NC}"
    echo "Please restart your terminal or run \`source ~/.bashrc\` to apply changes."
    
    # Print summary
    echo -e "\n${BLUE}Installation Summary:${NC}"
    echo -e "${GREEN}✓${NC} System packages installed"
    echo -e "${GREEN}✓${NC} $(python3 -V) installed"
    echo -e "${GREEN}✓${NC} Python packages installed"
    echo -e "${GREEN}✓${NC} Node.js $(node -v) installed"
    echo -e "${GREEN}✓${NC} pnpm $(pnpm -v) installed"
    echo -e "${GREEN}✓${NC} Dotfiles copied to $HOME"
    echo -e "${GREEN}✓${NC} Bash configuration updated"
    
    # Report any failed installations
    if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}The following apt packages failed to install:${NC}"
        for pkg in "${FAILED_PACKAGES[@]}"; do
            echo -e "${RED}- $pkg${NC}"
        done
    fi
    
    if [ ${#FAILED_PYTHON_PACKAGES[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}The following Python packages failed to install:${NC}"
        for pkg in "${FAILED_PYTHON_PACKAGES[@]}"; do
            echo -e "${RED}- $pkg${NC}"
        done
    fi
}

# Run main installation
main "$@"
