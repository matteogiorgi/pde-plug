#!/usr/bin/env bash

# Zed reset with a simple configuration.
# ---
# Zed is not included in the Debian repos,
# install it separately: https://zed.dev/.




### Check & Funcs
#################

RED='\033[1;36m'
NC='\033[0m'
# ---
if [[ ! -x "$(command -v "zed")" ]]; then
    printf "\n${RED}%s${NC}"   "═══════ Warning: Zed not found ══════"
    printf "\n${RED}%s${NC}\n" "Install Zed and run this script again"
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
command sudo apt-get update && sudo apt-get upgrade -qq -y || error-echo "syncing repos"
command sudo apt-get install -qq -y git bash dash python3 python3-pip golang-go gopls \
      fonts-ubuntu fonts-firacode || error-echo "installing from apt"




### Start
#########

BASE="${HOME}/.config/zed" && command mkdir -p "${BASE}"
cat "${SCRIPTPATH}/zed/settings.json" > "${BASE}/settings.json"
cat "${SCRIPTPATH}/zed/keymap.json" > "${BASE}/keymap.json"




### Finish
##########

printf "\n${RED}%s${NC}\n" "setup complete"
