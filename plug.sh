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
if [[ ! -x "$(command -v "vim")" || ! "$(command vim --version | grep -oE 'Vi IMproved 9')" == "Vi IMproved 9" ]]; then
    printf "\n${RED}%s${NC}"   "═══════ Warning: Vim9 not found ══════"
    printf "\n${RED}%s${NC}\n" "Install Vim9 and run this script again"
    exit 1
fi
# ---
function error-echo () {
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}
# ---
function reset-plugin () {
    printf "\n${RED}%s${NC}\n" "${OPERATION}"
    if [[ -d "${PLUGIN}" ]]; then
        command git -C "${PLUGIN}" pull
    else
        command git clone "${REPOSITORY}" "${PLUGIN}"
    fi
}




### Path & Dependencies
#######################

SCRIPTPATH="$( cd "$(command dirname "$0")" ; pwd -P )" || exit 1
command sudo apt-get install -qq -y git python3-pip exuberant-ctags pandoc || error-echo "installing from apt"
command pip3 install python-lsp-server pyflakes black || error-echo "installing from pip"




### Start
#########

VIM=${HOME}/.vim && mkdir -p "${VIM}"
START="${VIM}/pack/plug/start" && mkdir -p "${START}"
[[ -d "${VIM}/plugin" ]] || cp -r "${SCRIPTPATH}/plug" "${VIM}/plugin"
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
if [[ -x "$(command -v "node")" && $(command node --version | command cut -d v -f2 | command awk -F. '{print $1}') -ge 16 ]]; then
    OPERATION="RESETTING COPILOT"
    REPOSITORY="https://github.com/github/copilot.vim.git"
    PLUGIN="${START}/copilot"
    reset-plugin
fi




### Finish
##########

printf "\n${RED}%s${NC}\n" "setup complete"
