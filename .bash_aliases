#!/usr/bin/env bash

# Pretty path print
alias path='echo $PATH | tr -s ":" "\n"'

# Easy exit
alias e="exit"

# bashrc editing
alias bashrc="edit ~/.bashrc"

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# List all files colorized in long format
alias l="ls -lF"

# List all files colorized in long format, excluding . and ..
alias la="ls -lAF"

# List only directories
alias lsd="ls -lF | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Enable aliases to be sudo’ed
alias sudo="sudo "

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias pubip="publicip"
alias ips="python3 -c '
import subprocess
import re
from typing import List, Tuple
import ipaddress

RED = \"\033[31m\"
BLUE = \"\033[94m\"
RESET = \"\033[0m\"

def get_interface_ips() -> List[Tuple[str, str, str]]:
    try:
        output = subprocess.check_output([\"ip\", \"-o\", \"addr\", \"show\"]).decode()
    except subprocess.CalledProcessError:
        return []

    interfaces = []
    for line in output.splitlines():
        match = re.search(r\"^\\d+:\\s+(\\S+)\\s+.*inet[6]?\\s+([^/]+)/\\d+\", line)
        if match:
            iface, ip = match.groups()
            try:
                ip_obj = ipaddress.ip_address(ip)
                is_ipv6 = isinstance(ip_obj, ipaddress.IPv6Address)
                if ip in [\"127.0.0.1\", \"::1\"]:
                    ip_type = \"\"
                elif (ip.startswith(\"169.\") or ip.startswith(\"fe80:\") or (is_ipv6 and ip.startswith(\"fe80\"))):
                    ip_type = \"local\"
                else:
                    ip_type = \"public\"
                interfaces.append((iface, ip, ip_type))
            except ValueError:
                continue
    return interfaces

def sort_interfaces(interfaces: List[Tuple[str, str, str]]) -> List[Tuple[str, str, str]]:
    def sort_key(entry):
        iface, ip, ip_type = entry
        is_ipv6 = \":\" in ip
        primary = 0 if iface == \"lo\" else 1
        secondary = iface
        tertiary = 0 if ip_type == \"\" else 1 if ip_type == \"local\" else 2
        quaternary = 1 if is_ipv6 else 0
        try:
            ip_obj = ipaddress.ip_address(ip)
            final = int(ip_obj)
        except ValueError:
            final = 0
        return (primary, secondary, tertiary, quaternary, final)
    return sorted(interfaces, key=sort_key)

def format_output(iface: str, ip: str, ip_type: str) -> str:
    type_str = f\" ({ip_type})\" if ip_type else \"\"
    return f\"{RED}{iface}{RESET}{type_str} -> {BLUE}{ip}{RESET}\"

interfaces = get_interface_ips()
sorted_interfaces = sort_interfaces(interfaces)
for iface, ip, ip_type in sorted_interfaces:
    print(format_output(iface, ip, ip_type))
'"

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# URL-encode/decode strings
alias urlencode="python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))'"
alias urldecode="python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))'"

# reload shell (invoke it as a login shell)
alias reload="exec ${SHELL} -l"

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

### wsl ###
# Detect if running in WSL
if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    ## Opening files
    alias edit="code"  # Use VS Code in WSL
    alias open="explorer.exe"

    ## Browsing fs
    alias sqd="cd /mnt/c/Users/sqd"
    alias desktop="cd /mnt/c/Users/sqd/Desktop"
    alias downloads="cd /mnt/c/Users/sqd/Downloads"
else
    ## Opening files
    alias edit="nano"
    alias open="xdg-open"

    ## Browsing fs
    alias sqd="cd /home/sqd"
    alias desktop="cd ~/Desktop"
    alias downloads="cd ~/Downloads"
fi
alias ed="edit"
alias editor="edit"

### yt-dlp video download ###
alias dlmp3='yt-dlp -f "bestaudio[ext=m4a]/bestaudio" --extract-audio --audio-format mp3 --audio-quality 0 -o "%(title)s - %(uploader)s [%(id)s] (audio).%(ext)s"'
alias dlmp4='yt-dlp --merge-output-format mp4 -f "bestvideo+bestaudio[ext=m4a]/best" --embed-subs --write-thumbnail --embed-thumbnail --all-subs -o "%(title)s - %(uploader)s [%(id)s].%(ext)s"'

### Python ###
alias cv="create-venv"
alias create-venv="python3 -m venv .venv --upgrade-deps"
alias a="activate"
alias activate='f() { for venv in .venv venv */.venv */venv; do [ -d "$venv" ] && source "$venv/bin/activate" && return; done; echo -e "\e[31m<!> No virtual environment found.\e[0m"; }; f'
alias r="requirements"
alias requirements="pip install -r requirements.txt"
alias d="deactivate"
#alias deactivate='echo -e "\e[31m<!> Not in a venv.\e[0m"'

### apt ###
alias i="install"
alias install="sudo apt install"

alias rem="remove"
alias uni="remove"
alias uninstall="remove"
alias remove="sudo apt remove"

alias re="reinstall"
alias reinstall="sudo apt reinstall"

alias u="update && upgrade"
alias update="sudo apt update"
alias upgrade="sudo apt upgrade -y"

alias s="search"
alias search="apt search"

alias ar="autoremove"
alias autoremove="sudo apt autoremove -y"

alias c="clean"
alias clean="sudo apt clean -y"

alias ac="autoclean"
alias autoclean="sudo apt autoclean -y"

alias p="purge"
alias purge="sudo apt purge"

alias us="update-system"
alias update-system="echo 'Updating packages...' && update && echo 'Upgrading packages...' && upgrade && echo 'Autoremoving packages...' && autoremove && echo 'Cleaning packages...' && clean && echo 'Autocleaning packages...' && autoclean"

alias moo="apt moo"
