#!/usr/bin/env bash

# VSCode reset with just few tweaks and GitHub-Copilot extension:
# https://marketplace.visualstudio.com/items?itemName=GitHub.copilot




### Check
#########

RED='\033[1;36m'
NC='\033[0m'
# ---
if [[ ! -x "$(command -v "code")" ]]; then
    printf "\n${RED}%s${NC}"   "═══════ Warning: VSCode not found ══════"
    printf "\n${RED}%s${NC}\n" "Install VSCode and run this script again"
    exit 1
fi
# ---
function error-echo () {
    clear -x
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}




### Path & Dependencies
#######################

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )" || exit 1
sudo apt-get install -qq -y gnome-keyring dash fonts-firacode || error-echo "installing packages"




### Ready?
##########

BASE="${HOME}/.config/Code/User"
mkdir -p "${BASE}"
# ---
function clean-extensions () {
    for EXTENSION in $(code --list-extensions); do
        code --uninstall-extension "${EXTENSION}" &>/dev/null
    done
}




### Start
#########

clean-extensions
code --install-extension github.copilot &>/dev/null
cat "${SCRIPTPATH}/code/settings.json" > "${BASE}/settings.json"
cat "${SCRIPTPATH}/code/keybindings.json" > "${BASE}/keybindings.json"




### Finish
##########

printf "\n${RED}%s${NC}\n" "setup complete"
