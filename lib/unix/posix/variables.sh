
#User Defined varibales
typeset -a SUPPORTED_SHELLS
SUPPORTED_SHELLS=("bash" "zsh")

typeset -a SUPPORTED_UNIX_SYSTEM
SUPPORTED_UNIX_SYSTEM=("Linux" "Darwin")

typeset -a SUPPORTED_OS
SUPPORTED_OS=("Ubuntu" "OSX")

typeset -a SUPPORTED_PLATFORMS
SUPPORTED_PLATFORMS=("Generic" "WSL" "WSL_Docker" "Docker" "Mac")

# commands which needs to be available
typeset -a PREREQUISITE_COMMANDS 
PREREQUISITE_COMMANDS=("git" "envsubst")

#Return values
TRUE=0
FALSE=1
VARIABLE_NOT_DEFINED=2
NOT_IMPLEMENTED=3

#System Detected varibales
UNIX_SYSTEM="$(uname -s)"
HOME_DIR=$HOME
DEFAULT_SHELL=$(echo $SHELL | sed 's:.*/::')
CURRENT_SHELL=${CURRENT_SHELL:-$(ps $$ | sed -n 2p | awk '{print $5}' | tr -d '-')}

TOOLS_HOME="${TOOLS_HOME:-$HOME_DIR}"

#NVM variables can be set by users
NVM_GIT_URL="${NVM_GIT_URL:-https://github.com/nvm-sh/nvm}"
NVM_DIR="${NVM_DIR:-$TOOLS_HOME/.nvm}"
NVMRC="${NVMRC:-$TOOLS_HOME/.nvmrc}"

#PYENV variables can be set by users
PYENV_GIT_URL="${PYENV_GIT_URL:-https://github.com/pyenv/pyenv}"
PYENV_DIR="${PYENV_DIR:-$TOOLS_HOME/.pyenv}"
PYENVRC="${PYENVRC:-$TOOLS_HOME/.pyenvrc}"

#GIT_PROMPT variables can be set by users
GIT_ZSH_PROMPT_URL="${GIT_ZSH_PROMPT_URL:-https://github.com/olivierverdier/zsh-git-prompt}"
GIT_BASH_PROMPT_URL="${GIT_BASH_PROMPT_URL:-https://github.com/magicmonty/bash-git-prompt}"
GIT_PROMPT_DIR=${GIT_PROMPT_DIR:-$TOOLS_HOME/.git_prompt}
GIT_PROMPTRC=${GIT_PROMPTRC:-$TOOLS_HOME/.git_promptrc}

#GIT_PROMPT Variable is set to appropriate URL based on SHELL
[[ "$CURRENT_SHELL" =~ bash ]] && GIT_PROMPT_URL="$GIT_BASH_PROMPT_URL" || GIT_PROMPT_URL="$GIT_ZSH_PROMPT_URL"

#Some more variables
DESIRED_USER=${DESIRED_USER:-$USER}
DESIRED_HOSTNAME=${DESIRED_HOSTNAME:-$(hostname)}
INSTALL_EXTRAS=${INSTALL_EXTRAS:-$FALSE}