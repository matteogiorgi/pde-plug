#!/usr/bin/env bash

# Sublime-Text & Sublime-Merge reset with no options, no nothing.
# ---
# Sublime-Text & Sublime-Merge are not included in the Debian repos,
# install them separately: https://www.sublimetext.com/
#                          https://www.sublimemerge.com/.




### Funcs
#########

RED='\033[1;36m'
NC='\033[0m'
# ---
function error-echo () {
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}




### Path & Dependencies
#######################

SCRIPTPATH="$( cd "$(command dirname "$0")" ; pwd -P )" || exit 1
command sudo apt-get install -qq -y fonts-firacode || error-echo "installing from apt"




### Sublime-Text
################

if [[ -x "$(command -v "subl")" ]]; then
    BASE="${HOME}/.config/sublime-text/Packages/User" && command mkdir -p "${BASE}"
    cat "${SCRIPTPATH}/subl/subl-settings.json" > "${BASE}/Preferences.sublime-settings"
    cat "${SCRIPTPATH}/subl/subl-keybindings.json" > "${BASE}/Default (Linux).sublime-keymap"
    # ---
    command mkdir -p "${HOME}/.local/bin"
    command ln -sf /usr/bin/subl "${HOME}/.local/bin/subl"
else
    printf "\n${RED}%s${NC}"   "═══════ Warning: Sublime-Text not found ══════"
    printf "\n${RED}%s${NC}\n" "Install Sublime-Text and run this script again"
fi




### Sublime-Merge
#################

if [[ -x "$(command -v "smerge")" ]]; then
    BASE="${HOME}/.config/sublime-merge/Packages/User" && command mkdir -p "${BASE}"
    cat "${SCRIPTPATH}/subl/smerge-settings.json" > "${BASE}/Preferences.sublime-settings"
    # ---
    command mkdir -p "${HOME}/.local/bin"
    command ln -sf /usr/bin/smerge "${HOME}/.local/bin/smerge"
else
    printf "\n${RED}%s${NC}"   "═══════ Warning: Sublime-Merge not found ══════"
    printf "\n${RED}%s${NC}\n" "Install Sublime-Merge and run this script again"
fi




### Finish
##########

printf "\n${RED}%s${NC}\n" "setup complete"
