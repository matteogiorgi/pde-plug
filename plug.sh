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




### Check
#########

RED='\033[1;36m'
NC='\033[0m'
# ---
if [[ ! -x "$(command -v "vim")" ]]; then
    printf "\n${RED}%s${NC}"   "═══════ Warning: Vim not found ══════"
    printf "\n${RED}%s${NC}\n" "Install Vim and run this script again"
    exit 1
fi
# ---
__error () {
    clear
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}




### Path & dependencies
#######################

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )" || exit 1
sudo apt-get install -qq -y exuberant-ctags pandoc || __error "installing packages"




### Ready?
##########

VIM=${HOME}/.vim
START="${VIM}/pack/plugins/start"
mkdir -p "${VIM}"
# ---
__reset () {
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
__reset
# ---
OPERATION="RESETTING SURROUND"
REPOSITORY="https://github.com/tpope/vim-surround.git"
PLUGIN="${START}/surround"
__reset
# ---
OPERATION="RESETTING REPEAT"
REPOSITORY="https://github.com/tpope/vim-repeat.git"
PLUGIN="${START}/repeat"
__reset
# ---
OPERATION="RESETTING LEXIMA"
REPOSITORY="https://github.com/cohama/lexima.vim.git"
PLUGIN="${START}/lexima"
__reset
# ---
OPERATION="RESETTING CONTEXT"
REPOSITORY="https://github.com/wellle/context.vim.git"
PLUGIN="${START}/context"
__reset
# ---
OPERATION="RESETTING SIGNIFY"
REPOSITORY="https://github.com/mhinz/vim-signify.git"
PLUGIN="${START}/signify"
__reset
# ---
OPERATION="RESETTING ALE"
REPOSITORY="https://github.com/dense-analysis/ale.git"
PLUGIN="${START}/ale"
__reset
# ---
OPERATION="RESETTING CTRLP"
REPOSITORY="https://github.com/ctrlpvim/ctrlp.vim.git"
PLUGIN="${START}/ctrlp"
__reset
# ---
# if (vim >= 9) && (node >= 16)
# add AI-Completion with Copilot
if [[ "$(vim --version | grep -oE 'Vi IMproved 9')" == "Vi IMproved 9" ]] && \
   [[ -x "$(command -v "node")" && $(node --version | cut -d v -f2 | awk -F. '{print $1}') -ge 16 ]]
then
    OPERATION="RESETTING COPILOT"
    REPOSITORY="https://github.com/github/copilot.vim.git"
    PLUGIN="${START}/copilot"
    __reset
fi




### Finish
##########

printf "\n${RED}%s${NC}\n" "setup complete"
