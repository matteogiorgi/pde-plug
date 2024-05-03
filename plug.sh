#!/usr/bin/env bash

# COMMENTARY https://github.com/tpope/vim-commentary
# SURROUND   https://github.com/tpope/vim-surround
# REPEAT     https://github.com/tpope/vim-repeat
# LEXIMA     https://github.com/cohama/lexima.vim
# CONTEXT    https://github.com/wellle/context.vim
# SIGNIFY    https://github.com/mhinz/vim-signify
# ALE        https://github.com/dense-analysis/ale
# CTRLP      https://github.com/ctrlpvim/ctrlp.vim
# COPILOT    https://github.com/github/copilot.vim




### Check & Funcs
#################

RED='\033[1;36m'
NC='\033[0m'
# ---
if [[ ! -x "$(command -v "vim")" ]]; then
    printf "\n${RED}%s${NC}"   "═══════ Warning: Vim not found ══════"
    printf "\n${RED}%s${NC}\n" "Install Vim and run this script again"
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
sudo apt-get install -qq -y exuberant-ctags pandoc || error-echo "installing packages"




### Ready?
##########

VIM=${HOME}/.vim
START="${VIM}/pack/plug/start"
mkdir -p "${VIM}"
# ---
function reset-plugin () {
    printf "\n${RED}%s${NC}\n" "${OPERATION}"
    if [[ -d "${PLUGIN}" ]]; then
        git -C "${PLUGIN}" pull
    else
        git clone "${REPOSITORY}" "${PLUGIN}"
    fi
}




### Start
#########

[[ -d "${VIM}/plugin" ]] || cp -r "${SCRIPTPATH}/plug" "${VIM}/plugin"
[[ -d "${START}" ]] || mkdir -p "${START}"
# ---
OPERATION="RESETTING COMMENTARY"
REPOSITORY="https://github.com/tpope/vim-commentary.git"
PLUGIN="${START}/commentary"
reset-plugin
# ---
OPERATION="RESETTING SURROUND"
REPOSITORY="https://github.com/tpope/vim-surround.git"
PLUGIN="${START}/surround"
reset-plugin
# ---
OPERATION="RESETTING REPEAT"
REPOSITORY="https://github.com/tpope/vim-repeat.git"
PLUGIN="${START}/repeat"
reset-plugin
# ---
OPERATION="RESETTING LEXIMA"
REPOSITORY="https://github.com/cohama/lexima.vim.git"
PLUGIN="${START}/lexima"
reset-plugin
# ---
OPERATION="RESETTING CONTEXT"
REPOSITORY="https://github.com/wellle/context.vim.git"
PLUGIN="${START}/context"
reset-plugin
# ---
OPERATION="RESETTING SIGNIFY"
REPOSITORY="https://github.com/mhinz/vim-signify.git"
PLUGIN="${START}/signify"
reset-plugin
# ---
OPERATION="RESETTING ALE"
REPOSITORY="https://github.com/dense-analysis/ale.git"
PLUGIN="${START}/ale"
reset-plugin
# ---
OPERATION="RESETTING CTRLP"
REPOSITORY="https://github.com/ctrlpvim/ctrlp.vim.git"
PLUGIN="${START}/ctrlp"
reset-plugin
# ---
if [[ "$(vim --version | grep -oE 'Vi IMproved 9')" == "Vi IMproved 9" ]] && \
      [[ -x "$(command -v "node")" && $(node --version | cut -d v -f2 | awk -F. '{print $1}') -ge 16 ]]
then
    OPERATION="RESETTING COPILOT"
    REPOSITORY="https://github.com/github/copilot.vim.git"
    PLUGIN="${START}/copilot"
    reset-plugin
fi




### Finish
##########

printf "\n${RED}%s${NC}\n" "setup complete"
