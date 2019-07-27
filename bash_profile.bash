#@IgnoreInspection BashAddShebang

echo "Loading profile..."

unset PROMPT_COMMAND

export PS4='+Line ${LINENO}: '

error() {
    echo "Error:"
    # get length of an array
    stackDepth=${#BASH_SOURCE[@]}
    # use for loop read all nameservers
    for (( i=0; i<10; i++ ));
    do
      echo "$i ----- ${FUNCNAME[$i]} ------ ${BASH_SOURCE[$i]}  ---- ${BASH_LINENO[$i]}"
    done
    for (( i=0; i<10; i++ ));
    do
      echo "$i ${FUNCNAME[$i]} at ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]}"
    done
}

# $BASH_LINENO = An array variable whose members are the line numbers in source files where each corresponding member of FUNCNAME was invoked.
# ${BASH_LINENO[$i]} is the line number in the source file (${BASH_SOURCE[$i+1]}) where ${FUNCNAME[$i]} was called
# (or ${BASH_LINENO[$i-1]} if referenced within another shell function).
# Use LINENO to obtain the current line number.
#trap error ERR

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=/Applications/Cocos/Cocos2d-x/cocos2d-x-3.10/tools/cocos2d-console/bin
export PATH=${COCOS_CONSOLE_ROOT}:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT=/Applications/Cocos/Cocos2d-x
export PATH=${COCOS_X_ROOT}:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=/Applications/Cocos/Cocos2d-x/cocos2d-x-3.10/templates
export PATH=${COCOS_TEMPLATES_ROOT}:$PATH

export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="%a $ "

# enable ctrl-s
stty -ixon

export GWF_SERVICE=/Users/jpollak/Projects/gwf_service

alias bp=". ~/.bash_profile"

alias g="git"
alias gs="git submodule"
alias gsu="git submodule update --init --recursive"
alias git-prune="git remote prune origin"

alias add="git add"
alias pull="git pull"
alias checkout="git checkout"
alias fetch="git fetch"
alias push="git push"

alias d="cd ${GWF_SERVICE} && docker"
alias dc="cd ${GWF_SERVICE} && docker-compose"
alias down="dc down"
alias prune="docker system prune -f --volumes"
alias up="dc up"
alias recycle="down && prune && up --build"

alias ops="dc exec ops /bin/bash"

alias dx="dc exec web"
alias dash="dx /bin/bash"
alias dxbx="dx bundle exec"
alias rspec="dxbx /bin/bash -c -- unset VERBOSE \; rspec"

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

if [[ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_THEME=Default\ NoExitState

    __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
    source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
    # TODO: PR for this fix (locally hacked into gitprompt.sh)
    #  if [[ -e "$repo/.bash-git-rc" ]]; then
    #    # The config file can only contain variable declarations on the form A_B=0 or G_P=all
    #    local CONFIG_SYNTAX="^(FETCH_REMOTE_STATUS|GIT_PROMPT_SHOW_UNTRACKED_FILES|GIT_PROMPT_IGNORE_SUBMODULES|GIT_PROMPT_IGNORE_STASH|GIT_PROMPT_SHOW_UPSTREAM|GIT_PROMPT_SHOW_CHANGED_FILES_COUNT)=[01]$"
    #    if egrep -q -v "$CONFIG_SYNTAX" "$repo/.bash-git-rc"; then
    #      echo ".bash-git-rc can only contain variable values in the form NAME=0 or NAME=1 for these variables: FETCH_REMOTE_STATUS, GIT_PROMPT_SHOW_UNTRACKED_FILES, GIT_PROMPT_IGNORE_SUBMODULES, GIT_PROMPT_IGNORE_STASH, GIT_PROMPT_SHOW_UPSTREAM, GIT_PROMPT_SHOW_CHANGED_FILES_COUNT. Ignoring file." >&2
    #    else
    #      source "$repo/.bash-git-rc"
    #    fi
    #  fi
fi

[[ -f ~/.iterm2_shell_integration.bash ]] && . ~/.iterm2_shell_integration.bash

# TODO: PR for this fix
function we_are_on_repo() {
  if [[ -e "$(git rev-parse --git-dir 2> /dev/null)" ]]; then
    echo 1
  else
    echo 0
  fi
}

function setMyPrompt() {
    # append history lines from this session to the history file
    history -a

    # GPWD -- root of repo
    local GPWD=$(git rev-parse --show-toplevel 2>/dev/null)
    local DEPOT=${GPWD##*/}
    local _PWD="${PWD/$GPWD/}"
    _PWD="${_PWD/$HOME/\~}"
    if [[ -n "${DEPOT}" ]]; then
        _PWD="${DEPOT} [${GIT_BRANCH}] ${_PWD}"
    fi
    case ${TERM} in
    xterm*)
        printf "\033]0;%s \007" "${_PWD}"
        ;;
    screen)
        printf "\033]0;%s \033\\" "${_PWD}"
        ;;
      esac

    if [[ $(we_are_on_repo) = 1 ]]; then
        local REPO_NAME=`basename ${GPWD}`
        iterm2_set_user_var gitRepo ${REPO_NAME}
        iterm2_set_user_var gitBranch ${GIT_BRANCH}
    else
        iterm2_set_user_var gitRepo ''
        iterm2_set_user_var gitBranch ''
    fi
    history -c
    history -r
}

gp_install_prompt

PROMPT_COMMAND="${PROMPT_COMMAND};setMyPrompt"
PROMPT_COMMAND="${PROMPT_COMMAND//;/
}"
export PROMPT_COMMAND
echo "PROMPT_COMMAND: ${PROMPT_COMMAND}"

export MY_PRIVATE_GITHUB_KEY=github.pem
export REACT_EDITOR=idea
# added by Anaconda3 2019.07 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<
