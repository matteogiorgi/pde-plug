#!/usr/bin/env bash

# VSCode reset with just few tweaks and GitHub-Copilot extension:
# https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
# ---
# VSCode is not included in the Debin repos,
# install it separately from https://code.visualstudio.com/.




### Check & Funcs
#################

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
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}




### Path & Dependencies
#######################

SCRIPTPATH="$( cd "$(command dirname "$0")" ; pwd -P )" || exit 1
command sudo apt-get install -qq -y gnome-keyring bash dash python3 black golang-go \
      fonts-firacode || error-echo "installing from apt"




### Start
#########

BASE="${HOME}/.config/Code/User" && command mkdir -p "${BASE}"
for EXTENSION in $(command code --list-extensions); do
    command code --uninstall-extension "${EXTENSION}" &>/dev/null
done
# ---
command code --install-extension github.copilot &>/dev/null
command code --install-extension ms-python.python &>/dev/null
command code --install-extension ms-python.black-formatter &>/dev/null
command code --install-extension golang.go &>/dev/null
cat "${SCRIPTPATH}/code/settings.json" > "${BASE}/settings.json"
cat "${SCRIPTPATH}/code/keybindings.json" > "${BASE}/keybindings.json"




### Finish
##########

printf "\n${RED}%s${NC}\n" "setup complete"
